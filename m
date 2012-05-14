Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab2ENQzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:55:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52719 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755826Ab2ENQy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:54:58 -0400
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/4] printk: Separate out console bits to console.[ch]
Date: Mon, 14 May 2012 09:54:32 -0700
Message-Id: <c3cdf63dff530c41a2b5e31e83d6d1e880695b63.1337013606.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <1337013987.29436.16.camel@joe2Laptop>
References: <1337013987.29436.16.camel@joe2Laptop>
In-Reply-To: <76bd4533a88ae2ebf584887d51bf306591d0c01a.1337013604.git.joe@perches.com>
References: <76bd4533a88ae2ebf584887d51bf306591d0c01a.1337013604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some clarity to the printk subsystem by restructuring
the code a bit.

Move the console variables and functions to separate
code and header files.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/Makefile  |    1 +
 kernel/printk/console.c |  913 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/printk/console.h |   11 +
 kernel/printk/printk.c  |  854 +-------------------------------------------
 4 files changed, 936 insertions(+), 843 deletions(-)
 create mode 100644 kernel/printk/console.c
 create mode 100644 kernel/printk/console.h

diff --git a/kernel/printk/Makefile b/kernel/printk/Makefile
index 2fc9fe7..28b7129 100644
--- a/kernel/printk/Makefile
+++ b/kernel/printk/Makefile
@@ -1,2 +1,3 @@
 obj-y += printk.o
 obj-y += log_buf.o
+obj-y += console.o
diff --git a/kernel/printk/console.c b/kernel/printk/console.c
new file mode 100644
index 0000000..82a5455
--- /dev/null
+++ b/kernel/printk/console.c
@@ -0,0 +1,913 @@
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/console.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/nmi.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/interrupt.h>			/* For in_interrupt() */
+#include <linux/delay.h>
+#include <linux/smp.h>
+#include <linux/security.h>
+#include <linux/bootmem.h>
+#include <linux/memblock.h>
+#include <linux/syscalls.h>
+#include <linux/kexec.h>
+#include <linux/kdb.h>
+#include <linux/ratelimit.h>
+#include <linux/kmsg_dump.h>
+#include <linux/syslog.h>
+#include <linux/cpu.h>
+#include <linux/notifier.h>
+#include <linux/rculist.h>
+#include <linux/uaccess.h>
+
+#include "log_buf.h"
+#include "console.h"
+
+#include <trace/events/printk.h>
+
+extern volatile unsigned int printk_cpu;
+extern size_t log_prefix(const char *p, unsigned int *level, char *special);
+extern int __read_mostly keep_bootcon;
+
+/* We show everything that is MORE important than this.. */
+#define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
+#define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
+
+#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
+
+int console_printk[4] = {
+	DEFAULT_CONSOLE_LOGLEVEL,	/* console_loglevel */
+	DEFAULT_MESSAGE_LOGLEVEL,	/* default_message_loglevel */
+	MINIMUM_CONSOLE_LOGLEVEL,	/* minimum_console_loglevel */
+	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
+};
+
+/*
+ * console_sem protects the console_drivers list, and also
+ * provides serialisation for access to the entire console
+ * driver system.
+ */
+DEFINE_SEMAPHORE(console_sem);
+
+struct console *console_drivers;
+EXPORT_SYMBOL_GPL(console_drivers);
+
+/*
+ * This is used for debugging the mess that is the VT code by
+ * keeping track if we have the console semaphore held. It's
+ * definitely not the perfect debug tool (we don't know if _WE_
+ * hold it are racing, but it helps tracking those weird code
+ * path in the console code where we end up in places I want
+ * locked without the console sempahore held
+ */
+
+static int console_locked;
+static int console_suspended;
+
+static int saved_console_loglevel = -1;
+
+/*
+ * If exclusive_console is non-NULL then only this console is to be printed to.
+ */
+static struct console *exclusive_console;
+
+/*
+ *	Array of consoles built from command line options (console=)
+ */
+struct console_cmdline
+{
+	char	name[8];			/* Name of the driver	    */
+	int	index;				/* Minor dev. to use	    */
+	char	*options;			/* Options for the driver   */
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	char	*brl_options;			/* Options for braille driver */
+#endif
+};
+
+#define MAX_CMDLINECONSOLES 8
+
+static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
+static int selected_console = -1;
+static int preferred_console = -1;
+int console_set_on_cmdline;
+EXPORT_SYMBOL(console_set_on_cmdline);
+
+/* Flag: console code may call schedule() */
+static int console_may_schedule;
+
+static bool __read_mostly ignore_loglevel;
+
+static int __init ignore_loglevel_setup(char *str)
+{
+	ignore_loglevel = 1;
+	printk(KERN_INFO "debug: ignoring loglevel setting\n");
+
+	return 0;
+}
+
+early_param("ignore_loglevel", ignore_loglevel_setup);
+module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ignore_loglevel,
+		 "ignore loglevel setting, print all kernel messages to the console");
+
+int console_do_syslog(int type, char __user *buf, int len, bool from_file)
+{
+	int error = 0;
+
+	switch (type) {
+	case SYSLOG_ACTION_CONSOLE_OFF:		/* Disable logging to console */
+		if (saved_console_loglevel == -1)
+			saved_console_loglevel = console_loglevel;
+		console_loglevel = minimum_console_loglevel;
+		break;
+	case SYSLOG_ACTION_CONSOLE_ON:		/* Enable logging to console */
+		if (saved_console_loglevel != -1) {
+			console_loglevel = saved_console_loglevel;
+			saved_console_loglevel = -1;
+		}
+		break;
+	case SYSLOG_ACTION_CONSOLE_LEVEL:	/* Set level of messages
+						 * printed to console
+						 */
+
+		error = -EINVAL;
+		if (len < 1 || len > 8)
+			goto out;
+		if (len < minimum_console_loglevel)
+			len = minimum_console_loglevel;
+		console_loglevel = len;
+		/* Implicitly re-enable logging to console */
+		saved_console_loglevel = -1;
+		error = 0;
+		break;
+	}
+out:
+	return error;
+}
+
+/*
+ * Call the console drivers on a range of log_buf
+ */
+static void __call_console_drivers(unsigned start, unsigned end)
+{
+	struct console *con;
+
+	for_each_console(con) {
+		if (exclusive_console && con != exclusive_console)
+			continue;
+		if ((con->flags & CON_ENABLED) && con->write &&
+		    (cpu_online(smp_processor_id()) ||
+		     (con->flags & CON_ANYTIME)))
+			con->write(con, &LOG_BUF(start), end - start);
+	}
+}
+
+/*
+ * Write out chars from start to end - 1 inclusive
+ */
+static void _call_console_drivers(unsigned start,
+				  unsigned end, int msg_log_level)
+{
+	trace_console(&LOG_BUF(0), start, end, log_buf_len);
+
+	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
+	    console_drivers && start != end) {
+		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
+			/* wrapped write */
+			__call_console_drivers(start & LOG_BUF_MASK,
+					       log_buf_len);
+			__call_console_drivers(0, end & LOG_BUF_MASK);
+		} else {
+			__call_console_drivers(start, end);
+		}
+	}
+}
+
+/*
+ * Call the console drivers, asking them to write out
+ * log_buf[start] to log_buf[end - 1].
+ * The console_lock must be held.
+ */
+static void call_console_drivers(unsigned start, unsigned end)
+{
+	unsigned cur_index, start_print;
+	static int msg_level = -1;
+
+	BUG_ON(((int)(start - end)) > 0);
+
+	cur_index = start;
+	start_print = start;
+	while (cur_index != end) {
+		if (msg_level < 0 && ((end - cur_index) > 2)) {
+			/* strip log prefix */
+			cur_index += log_prefix(&LOG_BUF(cur_index), &msg_level,
+						NULL);
+			start_print = cur_index;
+		}
+		while (cur_index != end) {
+			char c = LOG_BUF(cur_index);
+
+			cur_index++;
+			if (c == '\n') {
+				if (msg_level < 0) {
+					/*
+					 * printk() has already given us
+					 * loglevel tags in the buffer.
+					 * This code is here in case the
+					 * log buffer has wrapped right round
+					 * and scribbled on those tags
+					 */
+					msg_level = default_message_loglevel;
+				}
+				_call_console_drivers(start_print, cur_index,
+						      msg_level);
+				msg_level = -1;
+				start_print = cur_index;
+				break;
+			}
+		}
+	}
+	_call_console_drivers(start_print, end, msg_level);
+}
+
+/*
+ * Zap console related locks when oopsing. Only zap at most once
+ * every 10 seconds, to leave time for slow consoles to print a
+ * full oops.
+ */
+void console_zap_locks(void)
+{
+	static unsigned long oops_timestamp;
+
+	if (time_after_eq(jiffies, oops_timestamp) &&
+	    !time_after(jiffies, oops_timestamp + 30 * HZ))
+		return;
+
+	oops_timestamp = jiffies;
+
+	debug_locks_off();
+	/* If a crash is occurring, make sure we can't deadlock */
+	raw_spin_lock_init(&logbuf_lock);
+	/* And make sure that we print immediately */
+	sema_init(&console_sem, 1);
+}
+
+/* Check if we have any console registered that can be called early in boot. */
+static int have_callable_console(void)
+{
+	struct console *con;
+
+	for_each_console(con)
+		if (con->flags & CON_ANYTIME)
+			return 1;
+
+	return 0;
+}
+
+/*
+ * Can we actually use the console at this time on this cpu?
+ *
+ * Console drivers may assume that per-cpu resources have
+ * been allocated. So unless they're explicitly marked as
+ * being able to cope (CON_ANYTIME) don't call them until
+ * this CPU is officially up.
+ */
+static inline int can_use_console(unsigned int cpu)
+{
+	return cpu_online(cpu) || have_callable_console();
+}
+
+/*
+ * Try to get console ownership to actually show the kernel
+ * messages from a 'printk'. Return true (and with the
+ * console_lock held, and 'console_locked' set) if it
+ * is successful, false otherwise.
+ *
+ * This gets called with the 'logbuf_lock' spinlock held and
+ * interrupts disabled. It should return with 'lockbuf_lock'
+ * released but interrupts still disabled.
+ */
+int console_trylock_for_printk(unsigned int cpu)
+	__releases(&logbuf_lock)
+{
+	int retval = 0, wake = 0;
+
+	if (console_trylock()) {
+		retval = 1;
+
+		/*
+		 * If we can't use the console, we need to release
+		 * the console semaphore by hand to avoid flushing
+		 * the buffer. We need to hold the console semaphore
+		 * in order to do this test safely.
+		 */
+		if (!can_use_console(cpu)) {
+			console_locked = 0;
+			wake = 1;
+			retval = 0;
+		}
+	}
+	printk_cpu = UINT_MAX;
+	if (wake)
+		up(&console_sem);
+	raw_spin_unlock(&logbuf_lock);
+	return retval;
+}
+
+static int __add_preferred_console(char *name, int idx, char *options,
+				   char *brl_options)
+{
+	struct console_cmdline *c;
+	int i;
+
+	/*
+	 *	See if this tty is not yet registered, and
+	 *	if we have a slot free.
+	 */
+	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
+		if (strcmp(console_cmdline[i].name, name) == 0 &&
+		    console_cmdline[i].index == idx) {
+			if (!brl_options)
+				selected_console = i;
+			return 0;
+		}
+	if (i == MAX_CMDLINECONSOLES)
+		return -E2BIG;
+	if (!brl_options)
+		selected_console = i;
+	c = &console_cmdline[i];
+	strlcpy(c->name, name, sizeof(c->name));
+	c->options = options;
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	c->brl_options = brl_options;
+#endif
+	c->index = idx;
+	return 0;
+}
+/*
+ * Set up a list of consoles.  Called from init/main.c
+ */
+static int __init console_setup(char *str)
+{
+	char buf[sizeof(console_cmdline[0].name) + 4]; /* 4 for index */
+	char *s, *options, *brl_options = NULL;
+	int idx;
+
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	if (!memcmp(str, "brl,", 4)) {
+		brl_options = "";
+		str += 4;
+	} else if (!memcmp(str, "brl=", 4)) {
+		brl_options = str + 4;
+		str = strchr(brl_options, ',');
+		if (!str) {
+			printk(KERN_ERR "need port name after brl=\n");
+			return 1;
+		}
+		*(str++) = 0;
+	}
+#endif
+
+	/*
+	 * Decode str into name, index, options.
+	 */
+	if (str[0] >= '0' && str[0] <= '9') {
+		strcpy(buf, "ttyS");
+		strncpy(buf + 4, str, sizeof(buf) - 5);
+	} else {
+		strncpy(buf, str, sizeof(buf) - 1);
+	}
+	buf[sizeof(buf) - 1] = 0;
+	if ((options = strchr(str, ',')) != NULL)
+		*(options++) = 0;
+#ifdef __sparc__
+	if (!strcmp(str, "ttya"))
+		strcpy(buf, "ttyS0");
+	if (!strcmp(str, "ttyb"))
+		strcpy(buf, "ttyS1");
+#endif
+	for (s = buf; *s; s++)
+		if ((*s >= '0' && *s <= '9') || *s == ',')
+			break;
+	idx = simple_strtoul(s, NULL, 10);
+	*s = 0;
+
+	__add_preferred_console(buf, idx, options, brl_options);
+	console_set_on_cmdline = 1;
+	return 1;
+}
+__setup("console=", console_setup);
+
+/**
+ * add_preferred_console - add a device to the list of preferred consoles.
+ * @name: device name
+ * @idx: device index
+ * @options: options for this console
+ *
+ * The last preferred console added will be used for kernel messages
+ * and stdin/out/err for init.  Normally this is used by console_setup
+ * above to handle user-supplied console arguments; however it can also
+ * be used by arch-specific code either to override the user or more
+ * commonly to provide a default console (ie from PROM variables) when
+ * the user has not supplied one.
+ */
+int add_preferred_console(char *name, int idx, char *options)
+{
+	return __add_preferred_console(name, idx, options, NULL);
+}
+
+int update_console_cmdline(char *name, int idx, char *name_new, int idx_new,
+			   char *options)
+{
+	struct console_cmdline *c;
+	int i;
+
+	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
+		if (strcmp(console_cmdline[i].name, name) == 0 &&
+		    console_cmdline[i].index == idx) {
+			c = &console_cmdline[i];
+			strlcpy(c->name, name_new, sizeof(c->name));
+			c->name[sizeof(c->name) - 1] = 0;
+			c->options = options;
+			c->index = idx_new;
+			return i;
+		}
+	/* not found */
+	return -1;
+}
+
+bool console_suspend_enabled = 1;
+EXPORT_SYMBOL(console_suspend_enabled);
+
+static int __init console_suspend_disable(char *str)
+{
+	console_suspend_enabled = 0;
+	return 1;
+}
+__setup("no_console_suspend", console_suspend_disable);
+module_param_named(console_suspend, console_suspend_enabled,
+		   bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(console_suspend,
+		 "suspend console during suspend and hibernate operations");
+
+/**
+ * suspend_console - suspend the console subsystem
+ *
+ * This disables printk() while we go into suspend states
+ */
+void suspend_console(void)
+{
+	if (!console_suspend_enabled)
+		return;
+	printk("Suspending console(s) (use no_console_suspend to debug)\n");
+	console_lock();
+	console_suspended = 1;
+	up(&console_sem);
+}
+
+void resume_console(void)
+{
+	if (!console_suspend_enabled)
+		return;
+	down(&console_sem);
+	console_suspended = 0;
+	console_unlock();
+}
+
+/**
+ * console_cpu_notify - print deferred console messages after CPU hotplug
+ * @self: notifier struct
+ * @action: CPU hotplug event
+ * @hcpu: unused
+ *
+ * If printk() is called from a CPU that is not online yet, the messages
+ * will be spooled but will not show up on the console.  This function is
+ * called when a new CPU comes online (or fails to come up), and ensures
+ * that any such output gets printed.
+ */
+int __cpuinit console_cpu_notify(struct notifier_block *self,
+				 unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_DEAD:
+	case CPU_DYING:
+	case CPU_DOWN_FAILED:
+	case CPU_UP_CANCELED:
+		console_lock();
+		console_unlock();
+	}
+	return NOTIFY_OK;
+}
+
+/**
+ * console_lock - lock the console system for exclusive use.
+ *
+ * Acquires a lock which guarantees that the caller has
+ * exclusive access to the console system and the console_drivers list.
+ *
+ * Can sleep, returns nothing.
+ */
+void console_lock(void)
+{
+	BUG_ON(in_interrupt());
+	down(&console_sem);
+	if (console_suspended)
+		return;
+	console_locked = 1;
+	console_may_schedule = 1;
+}
+EXPORT_SYMBOL(console_lock);
+
+/**
+ * console_trylock - try to lock the console system for exclusive use.
+ *
+ * Tried to acquire a lock which guarantees that the caller has
+ * exclusive access to the console system and the console_drivers list.
+ *
+ * returns 1 on success, and 0 on failure to acquire the lock.
+ */
+int console_trylock(void)
+{
+	if (down_trylock(&console_sem))
+		return 0;
+	if (console_suspended) {
+		up(&console_sem);
+		return 0;
+	}
+	console_locked = 1;
+	console_may_schedule = 0;
+	return 1;
+}
+EXPORT_SYMBOL(console_trylock);
+
+int is_console_locked(void)
+{
+	return console_locked;
+}
+
+/**
+ * console_unlock - unlock the console system
+ *
+ * Releases the console_lock which the caller holds on the console system
+ * and the console driver list.
+ *
+ * While the console_lock was held, console output may have been buffered
+ * by printk().  If this is the case, console_unlock(); emits
+ * the output prior to releasing the lock.
+ *
+ * If there is output waiting for klogd, we wake it up.
+ *
+ * console_unlock(); may be called from any context.
+ */
+void console_unlock(void)
+{
+	unsigned long flags;
+	unsigned _con_start, _log_end;
+	unsigned wake_klogd = 0, retry = 0;
+
+	if (console_suspended) {
+		up(&console_sem);
+		return;
+	}
+
+	console_may_schedule = 0;
+
+again:
+	for ( ; ; ) {
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		wake_klogd |= log_start - log_end;
+		if (con_start == log_end)
+			break;			/* Nothing to print */
+		_con_start = con_start;
+		_log_end = log_end;
+		con_start = log_end;		/* Flush */
+		raw_spin_unlock(&logbuf_lock);
+		stop_critical_timings();	/* don't trace print latency */
+		call_console_drivers(_con_start, _log_end);
+		start_critical_timings();
+		local_irq_restore(flags);
+	}
+	console_locked = 0;
+
+	/* Release the exclusive_console once it is used */
+	if (unlikely(exclusive_console))
+		exclusive_console = NULL;
+
+	raw_spin_unlock(&logbuf_lock);
+
+	up(&console_sem);
+
+	/*
+	 * Someone could have filled up the buffer again, so re-check if there's
+	 * something to flush. In case we cannot trylock the console_sem again,
+	 * there's a new owner and the console_unlock() from them will do the
+	 * flush, no worries.
+	 */
+	raw_spin_lock(&logbuf_lock);
+	if (con_start != log_end)
+		retry = 1;
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	if (retry && console_trylock())
+		goto again;
+
+	if (wake_klogd)
+		wake_up_klogd();
+}
+EXPORT_SYMBOL(console_unlock);
+
+/**
+ * console_conditional_schedule - yield the CPU if required
+ *
+ * If the console code is currently allowed to sleep, and
+ * if this CPU should yield the CPU to another task, do
+ * so here.
+ *
+ * Must be called within console_lock();.
+ */
+void __sched console_conditional_schedule(void)
+{
+	if (console_may_schedule)
+		cond_resched();
+}
+EXPORT_SYMBOL(console_conditional_schedule);
+
+void console_unblank(void)
+{
+	struct console *c;
+
+	/*
+	 * console_unblank can no longer be called in interrupt context unless
+	 * oops_in_progress is set to 1..
+	 */
+	if (oops_in_progress) {
+		if (down_trylock(&console_sem) != 0)
+			return;
+	} else
+		console_lock();
+
+	console_locked = 1;
+	console_may_schedule = 0;
+	for_each_console(c)
+		if ((c->flags & CON_ENABLED) && c->unblank)
+			c->unblank();
+	console_unlock();
+}
+
+/*
+ * Return the console tty driver structure and its associated index
+ */
+struct tty_driver *console_device(int *index)
+{
+	struct console *c;
+	struct tty_driver *driver = NULL;
+
+	console_lock();
+	for_each_console(c) {
+		if (!c->device)
+			continue;
+		driver = c->device(c, index);
+		if (driver)
+			break;
+	}
+	console_unlock();
+	return driver;
+}
+
+/*
+ * Prevent further output on the passed console device so that (for example)
+ * serial drivers can disable console output before suspending a port, and can
+ * re-enable output afterwards.
+ */
+void console_stop(struct console *console)
+{
+	console_lock();
+	console->flags &= ~CON_ENABLED;
+	console_unlock();
+}
+EXPORT_SYMBOL(console_stop);
+
+void console_start(struct console *console)
+{
+	console_lock();
+	console->flags |= CON_ENABLED;
+	console_unlock();
+}
+EXPORT_SYMBOL(console_start);
+
+/*
+ * The console driver calls this routine during kernel initialization
+ * to register the console printing procedure with printk() and to
+ * print any messages that were printed by the kernel before the
+ * console driver was initialized.
+ *
+ * This can happen pretty early during the boot process (because of
+ * early_printk) - sometimes before setup_arch() completes - be careful
+ * of what kernel features are used - they may not be initialised yet.
+ *
+ * There are two types of consoles - bootconsoles (early_printk) and
+ * "real" consoles (everything which is not a bootconsole) which are
+ * handled differently.
+ *  - Any number of bootconsoles can be registered at any time.
+ *  - As soon as a "real" console is registered, all bootconsoles
+ *    will be unregistered automatically.
+ *  - Once a "real" console is registered, any attempt to register a
+ *    bootconsoles will be rejected
+ */
+void register_console(struct console *newcon)
+{
+	int i;
+	unsigned long flags;
+	struct console *bcon = NULL;
+
+	/*
+	 * before we register a new CON_BOOT console, make sure we don't
+	 * already have a valid console
+	 */
+	if (console_drivers && newcon->flags & CON_BOOT) {
+		/* find the last or real console */
+		for_each_console(bcon) {
+			if (!(bcon->flags & CON_BOOT)) {
+				printk(KERN_INFO "Too late to register bootconsole %s%d\n",
+				       newcon->name, newcon->index);
+				return;
+			}
+		}
+	}
+
+	if (console_drivers && console_drivers->flags & CON_BOOT)
+		bcon = console_drivers;
+
+	if (preferred_console < 0 || bcon || !console_drivers)
+		preferred_console = selected_console;
+
+	if (newcon->early_setup)
+		newcon->early_setup();
+
+	/*
+	 *	See if we want to use this console driver. If we
+	 *	didn't select a console we take the first one
+	 *	that registers here.
+	 */
+	if (preferred_console < 0) {
+		if (newcon->index < 0)
+			newcon->index = 0;
+		if (newcon->setup == NULL ||
+		    newcon->setup(newcon, NULL) == 0) {
+			newcon->flags |= CON_ENABLED;
+			if (newcon->device) {
+				newcon->flags |= CON_CONSDEV;
+				preferred_console = 0;
+			}
+		}
+	}
+
+	/*
+	 *	See if this console matches one we selected on
+	 *	the command line.
+	 */
+	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0];
+	     i++) {
+		if (strcmp(console_cmdline[i].name, newcon->name) != 0)
+			continue;
+		if (newcon->index >= 0 &&
+		    newcon->index != console_cmdline[i].index)
+			continue;
+		if (newcon->index < 0)
+			newcon->index = console_cmdline[i].index;
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+		if (console_cmdline[i].brl_options) {
+			newcon->flags |= CON_BRL;
+			braille_register_console(newcon,
+						 console_cmdline[i].index,
+						 console_cmdline[i].options,
+						 console_cmdline[i].brl_options);
+			return;
+		}
+#endif
+		if (newcon->setup &&
+		    newcon->setup(newcon, console_cmdline[i].options) != 0)
+			break;
+		newcon->flags |= CON_ENABLED;
+		newcon->index = console_cmdline[i].index;
+		if (i == selected_console) {
+			newcon->flags |= CON_CONSDEV;
+			preferred_console = selected_console;
+		}
+		break;
+	}
+
+	if (!(newcon->flags & CON_ENABLED))
+		return;
+
+	/*
+	 * If we have a bootconsole, and are switching to a real console,
+	 * don't print everything out again, since when the boot console, and
+	 * the real console are the same physical device, it's annoying to
+	 * see the beginning boot messages twice
+	 */
+	if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV))
+		newcon->flags &= ~CON_PRINTBUFFER;
+
+	/*
+	 *	Put this console in the list - keep the
+	 *	preferred driver at the head of the list.
+	 */
+	console_lock();
+	if ((newcon->flags & CON_CONSDEV) || console_drivers == NULL) {
+		newcon->next = console_drivers;
+		console_drivers = newcon;
+		if (newcon->next)
+			newcon->next->flags &= ~CON_CONSDEV;
+	} else {
+		newcon->next = console_drivers->next;
+		console_drivers->next = newcon;
+	}
+	if (newcon->flags & CON_PRINTBUFFER) {
+		/*
+		 * console_unlock(); will print out the buffered messages
+		 * for us.
+		 */
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		con_start = log_start;
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		/*
+		 * We're about to replay the log buffer.  Only do this to the
+		 * just-registered console to avoid excessive message spam to
+		 * the already-registered consoles.
+		 */
+		exclusive_console = newcon;
+	}
+	console_unlock();
+	console_sysfs_notify();
+
+	/*
+	 * By unregistering the bootconsoles after we enable the real console
+	 * we get the "console xxx enabled" message on all the consoles -
+	 * boot consoles, real consoles, etc - this is to ensure that end
+	 * users know there might be something in the kernel's log buffer that
+	 * went to the bootconsole (that they do not see on the real console)
+	 */
+	if (bcon &&
+	    ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV) &&
+	    !keep_bootcon) {
+		/* we need to iterate through twice, to make sure we print
+		 * everything out, before we unregister the console(s)
+		 */
+		printk(KERN_INFO "console [%s%d] enabled, bootconsole disabled\n",
+		       newcon->name, newcon->index);
+		for_each_console(bcon)
+			if (bcon->flags & CON_BOOT)
+				unregister_console(bcon);
+	} else {
+		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
+		       (newcon->flags & CON_BOOT) ? "boot" : "" ,
+		       newcon->name, newcon->index);
+	}
+}
+EXPORT_SYMBOL(register_console);
+
+int unregister_console(struct console *console)
+{
+        struct console *a, *b;
+	int res = 1;
+
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	if (console->flags & CON_BRL)
+		return braille_unregister_console(console);
+#endif
+
+	console_lock();
+	if (console_drivers == console) {
+		console_drivers=console->next;
+		res = 0;
+	} else if (console_drivers) {
+		for (a=console_drivers->next, b=console_drivers ;
+		     a; b=a, a=b->next) {
+			if (a == console) {
+				b->next = a->next;
+				res = 0;
+				break;
+			}
+		}
+	}
+
+	/*
+	 * If this isn't the last console and it has CON_CONSDEV set, we
+	 * need to set it on the next preferred console.
+	 */
+	if (console_drivers != NULL && console->flags & CON_CONSDEV)
+		console_drivers->flags |= CON_CONSDEV;
+
+	console_unlock();
+	console_sysfs_notify();
+	return res;
+}
+EXPORT_SYMBOL(unregister_console);
+
diff --git a/kernel/printk/console.h b/kernel/printk/console.h
new file mode 100644
index 0000000..7e15f6f
--- /dev/null
+++ b/kernel/printk/console.h
@@ -0,0 +1,11 @@
+#ifndef PRINTK_CONSOLE_H
+#define PRINTK_CONSOLE_H
+
+int console_do_syslog(int type, char __user *buf, int len, bool from_file);
+void console_zap_locks(void);
+int console_trylock_for_printk(unsigned int cpu)
+	__releases(&logbuf_lock);
+int __cpuinit console_cpu_notify(struct notifier_block *self,
+				 unsigned long action, void *hcpu);
+
+#endif
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e90818a..3281441 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -37,6 +37,8 @@
 
 #include <asm/uaccess.h>
 
+#include "console.h"
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
@@ -50,17 +52,6 @@ void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
 /* printk's without a loglevel use this.. */
 #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
-/* We show everything that is MORE important than this.. */
-#define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
-#define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
-
-int console_printk[4] = {
-	DEFAULT_CONSOLE_LOGLEVEL,	/* console_loglevel */
-	DEFAULT_MESSAGE_LOGLEVEL,	/* default_message_loglevel */
-	MINIMUM_CONSOLE_LOGLEVEL,	/* minimum_console_loglevel */
-	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
-};
-
 /*
  * Low level drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
@@ -68,61 +59,10 @@ int console_printk[4] = {
 int oops_in_progress;
 EXPORT_SYMBOL(oops_in_progress);
 
-/*
- * console_sem protects the console_drivers list, and also
- * provides serialisation for access to the entire console
- * driver system.
- */
-DEFINE_SEMAPHORE(console_sem);
-
-struct console *console_drivers;
-EXPORT_SYMBOL_GPL(console_drivers);
-
-/*
- * This is used for debugging the mess that is the VT code by
- * keeping track if we have the console semaphore held. It's
- * definitely not the perfect debug tool (we don't know if _WE_
- * hold it are racing, but it helps tracking those weird code
- * path in the console code where we end up in places I want
- * locked without the console sempahore held
- */
-static int console_locked, console_suspended;
-
-/*
- * If exclusive_console is non-NULL then only this console is to be printed to.
- */
-static struct console *exclusive_console;
-
-/*
- *	Array of consoles built from command line options (console=)
- */
-struct console_cmdline
-{
-	char	name[8];			/* Name of the driver	    */
-	int	index;				/* Minor dev. to use	    */
-	char	*options;			/* Options for the driver   */
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	char	*brl_options;			/* Options for braille driver */
-#endif
-};
-
-#define MAX_CMDLINECONSOLES 8
-
-static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
-static int selected_console = -1;
-static int preferred_console = -1;
-int console_set_on_cmdline;
-EXPORT_SYMBOL(console_set_on_cmdline);
-
-/* Flag: console code may call schedule() */
-static int console_may_schedule;
-
 #ifdef CONFIG_PRINTK
 
 #include "log_buf.h"
 
-static int saved_console_loglevel = -1;
-
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static int boot_delay; /* msecs delay after each printk during bootup */
@@ -242,30 +182,13 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		error = log_buf_do_syslog(type, buf, len, from_file);
 		break;
 
-	/* Disable logging to console */
-	case SYSLOG_ACTION_CONSOLE_OFF:
-		if (saved_console_loglevel == -1)
-			saved_console_loglevel = console_loglevel;
-		console_loglevel = minimum_console_loglevel;
-		break;
-	/* Enable logging to console */
-	case SYSLOG_ACTION_CONSOLE_ON:
-		if (saved_console_loglevel != -1) {
-			console_loglevel = saved_console_loglevel;
-			saved_console_loglevel = -1;
-		}
-		break;
-	/* Set level of messages printed to console */
+	case SYSLOG_ACTION_CONSOLE_OFF:	/* Disable logging to console */
+	case SYSLOG_ACTION_CONSOLE_ON:	/* Enable logging to console */
 	case SYSLOG_ACTION_CONSOLE_LEVEL:
-		error = -EINVAL;
-		if (len < 1 || len > 8)
-			goto out;
-		if (len < minimum_console_loglevel)
-			len = minimum_console_loglevel;
-		console_loglevel = len;
-		/* Implicitly re-enable logging to console */
-		saved_console_loglevel = -1;
-		error = 0;
+					/* Set level of messages
+					 * printed to console
+					 */
+		error = console_do_syslog(type, buf, len, from_file);
 		break;
 	default:
 		error = -EINVAL;
@@ -297,59 +220,6 @@ void kdb_syslog_data(char *syslog_data[4])
 #endif	/* CONFIG_KGDB_KDB */
 
 /*
- * Call the console drivers on a range of log_buf
- */
-static void __call_console_drivers(unsigned start, unsigned end)
-{
-	struct console *con;
-
-	for_each_console(con) {
-		if (exclusive_console && con != exclusive_console)
-			continue;
-		if ((con->flags & CON_ENABLED) && con->write &&
-				(cpu_online(smp_processor_id()) ||
-				(con->flags & CON_ANYTIME)))
-			con->write(con, &LOG_BUF(start), end - start);
-	}
-}
-
-static bool __read_mostly ignore_loglevel;
-
-static int __init ignore_loglevel_setup(char *str)
-{
-	ignore_loglevel = 1;
-	printk(KERN_INFO "debug: ignoring loglevel setting.\n");
-
-	return 0;
-}
-
-early_param("ignore_loglevel", ignore_loglevel_setup);
-module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
-	"print all kernel messages to the console.");
-
-/*
- * Write out chars from start to end - 1 inclusive
- */
-static void _call_console_drivers(unsigned start,
-				unsigned end, int msg_log_level)
-{
-	trace_console(&LOG_BUF(0), start, end, log_buf_len);
-
-	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
-			console_drivers && start != end) {
-		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
-			/* wrapped write */
-			__call_console_drivers(start & LOG_BUF_MASK,
-						log_buf_len);
-			__call_console_drivers(0, end & LOG_BUF_MASK);
-		} else {
-			__call_console_drivers(start, end);
-		}
-	}
-}
-
-/*
  * Parse the syslog header <[0-9]*>. The decimal value represents 32bit, the
  * lower 3 bit are the log level, the rest are the log facility. In case
  * userspace passes usual userspace syslog messages to /dev/kmsg or
@@ -363,7 +233,7 @@ static void _call_console_drivers(unsigned start,
  * and returned. If no valid header is found, 0 is returned and the passed
  * variables are not touched.
  */
-static size_t log_prefix(const char *p, unsigned int *level, char *special)
+size_t log_prefix(const char *p, unsigned int *level, char *special)
 {
 	unsigned int lev = 0;
 	char sp = '\0';
@@ -411,50 +281,6 @@ static size_t log_prefix(const char *p, unsigned int *level, char *special)
 	return len;
 }
 
-/*
- * Call the console drivers, asking them to write out
- * log_buf[start] to log_buf[end - 1].
- * The console_lock must be held.
- */
-static void call_console_drivers(unsigned start, unsigned end)
-{
-	unsigned cur_index, start_print;
-	static int msg_level = -1;
-
-	BUG_ON(((int)(start - end)) > 0);
-
-	cur_index = start;
-	start_print = start;
-	while (cur_index != end) {
-		if (msg_level < 0 && ((end - cur_index) > 2)) {
-			/* strip log prefix */
-			cur_index += log_prefix(&LOG_BUF(cur_index), &msg_level, NULL);
-			start_print = cur_index;
-		}
-		while (cur_index != end) {
-			char c = LOG_BUF(cur_index);
-
-			cur_index++;
-			if (c == '\n') {
-				if (msg_level < 0) {
-					/*
-					 * printk() has already given us loglevel tags in
-					 * the buffer.  This code is here in case the
-					 * log buffer has wrapped right round and scribbled
-					 * on those tags
-					 */
-					msg_level = default_message_loglevel;
-				}
-				_call_console_drivers(start_print, cur_index, msg_level);
-				msg_level = -1;
-				start_print = cur_index;
-				break;
-			}
-		}
-	}
-	_call_console_drivers(start_print, end, msg_level);
-}
-
 #if defined(CONFIG_PRINTK_TIME)
 static bool printk_time = 1;
 #else
@@ -465,18 +291,6 @@ module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 static bool always_kmsg_dump;
 module_param_named(always_kmsg_dump, always_kmsg_dump, bool, S_IRUGO | S_IWUSR);
 
-/* Check if we have any console registered that can be called early in boot. */
-static int have_callable_console(void)
-{
-	struct console *con;
-
-	for_each_console(con)
-		if (con->flags & CON_ANYTIME)
-			return 1;
-
-	return 0;
-}
-
 /**
  * printk - print a kernel message
  * @fmt: format string
@@ -520,57 +334,8 @@ asmlinkage int printk(const char *fmt, ...)
 }
 
 /* cpu currently holding logbuf_lock */
-static volatile unsigned int printk_cpu = UINT_MAX;
-
-/*
- * Can we actually use the console at this time on this cpu?
- *
- * Console drivers may assume that per-cpu resources have
- * been allocated. So unless they're explicitly marked as
- * being able to cope (CON_ANYTIME) don't call them until
- * this CPU is officially up.
- */
-static inline int can_use_console(unsigned int cpu)
-{
-	return cpu_online(cpu) || have_callable_console();
-}
-
-/*
- * Try to get console ownership to actually show the kernel
- * messages from a 'printk'. Return true (and with the
- * console_lock held, and 'console_locked' set) if it
- * is successful, false otherwise.
- *
- * This gets called with the 'logbuf_lock' spinlock held and
- * interrupts disabled. It should return with 'lockbuf_lock'
- * released but interrupts still disabled.
- */
-static int console_trylock_for_printk(unsigned int cpu)
-	__releases(&logbuf_lock)
-{
-	int retval = 0, wake = 0;
-
-	if (console_trylock()) {
-		retval = 1;
+volatile unsigned int printk_cpu = UINT_MAX;
 
-		/*
-		 * If we can't use the console, we need to release
-		 * the console semaphore by hand to avoid flushing
-		 * the buffer. We need to hold the console semaphore
-		 * in order to do this test safely.
-		 */
-		if (!can_use_console(cpu)) {
-			console_locked = 0;
-			wake = 1;
-			retval = 0;
-		}
-	}
-	printk_cpu = UINT_MAX;
-	if (wake)
-		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
-	return retval;
-}
 static const char recursion_bug_msg [] =
 		KERN_CRIT "BUG: recent printk recursion!\n";
 static int recursion_bug;
@@ -732,245 +497,8 @@ out_restore_irqs:
 EXPORT_SYMBOL(printk);
 EXPORT_SYMBOL(vprintk);
 
-#else
-
-static void call_console_drivers(unsigned start, unsigned end)
-{
-}
-
 #endif
 
-static int __add_preferred_console(char *name, int idx, char *options,
-				   char *brl_options)
-{
-	struct console_cmdline *c;
-	int i;
-
-	/*
-	 *	See if this tty is not yet registered, and
-	 *	if we have a slot free.
-	 */
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
-		if (strcmp(console_cmdline[i].name, name) == 0 &&
-			  console_cmdline[i].index == idx) {
-				if (!brl_options)
-					selected_console = i;
-				return 0;
-		}
-	if (i == MAX_CMDLINECONSOLES)
-		return -E2BIG;
-	if (!brl_options)
-		selected_console = i;
-	c = &console_cmdline[i];
-	strlcpy(c->name, name, sizeof(c->name));
-	c->options = options;
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	c->brl_options = brl_options;
-#endif
-	c->index = idx;
-	return 0;
-}
-/*
- * Set up a list of consoles.  Called from init/main.c
- */
-static int __init console_setup(char *str)
-{
-	char buf[sizeof(console_cmdline[0].name) + 4]; /* 4 for index */
-	char *s, *options, *brl_options = NULL;
-	int idx;
-
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	if (!memcmp(str, "brl,", 4)) {
-		brl_options = "";
-		str += 4;
-	} else if (!memcmp(str, "brl=", 4)) {
-		brl_options = str + 4;
-		str = strchr(brl_options, ',');
-		if (!str) {
-			printk(KERN_ERR "need port name after brl=\n");
-			return 1;
-		}
-		*(str++) = 0;
-	}
-#endif
-
-	/*
-	 * Decode str into name, index, options.
-	 */
-	if (str[0] >= '0' && str[0] <= '9') {
-		strcpy(buf, "ttyS");
-		strncpy(buf + 4, str, sizeof(buf) - 5);
-	} else {
-		strncpy(buf, str, sizeof(buf) - 1);
-	}
-	buf[sizeof(buf) - 1] = 0;
-	if ((options = strchr(str, ',')) != NULL)
-		*(options++) = 0;
-#ifdef __sparc__
-	if (!strcmp(str, "ttya"))
-		strcpy(buf, "ttyS0");
-	if (!strcmp(str, "ttyb"))
-		strcpy(buf, "ttyS1");
-#endif
-	for (s = buf; *s; s++)
-		if ((*s >= '0' && *s <= '9') || *s == ',')
-			break;
-	idx = simple_strtoul(s, NULL, 10);
-	*s = 0;
-
-	__add_preferred_console(buf, idx, options, brl_options);
-	console_set_on_cmdline = 1;
-	return 1;
-}
-__setup("console=", console_setup);
-
-/**
- * add_preferred_console - add a device to the list of preferred consoles.
- * @name: device name
- * @idx: device index
- * @options: options for this console
- *
- * The last preferred console added will be used for kernel messages
- * and stdin/out/err for init.  Normally this is used by console_setup
- * above to handle user-supplied console arguments; however it can also
- * be used by arch-specific code either to override the user or more
- * commonly to provide a default console (ie from PROM variables) when
- * the user has not supplied one.
- */
-int add_preferred_console(char *name, int idx, char *options)
-{
-	return __add_preferred_console(name, idx, options, NULL);
-}
-
-int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
-{
-	struct console_cmdline *c;
-	int i;
-
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
-		if (strcmp(console_cmdline[i].name, name) == 0 &&
-			  console_cmdline[i].index == idx) {
-				c = &console_cmdline[i];
-				strlcpy(c->name, name_new, sizeof(c->name));
-				c->name[sizeof(c->name) - 1] = 0;
-				c->options = options;
-				c->index = idx_new;
-				return i;
-		}
-	/* not found */
-	return -1;
-}
-
-bool console_suspend_enabled = 1;
-EXPORT_SYMBOL(console_suspend_enabled);
-
-static int __init console_suspend_disable(char *str)
-{
-	console_suspend_enabled = 0;
-	return 1;
-}
-__setup("no_console_suspend", console_suspend_disable);
-module_param_named(console_suspend, console_suspend_enabled,
-		bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(console_suspend, "suspend console during suspend"
-	" and hibernate operations");
-
-/**
- * suspend_console - suspend the console subsystem
- *
- * This disables printk() while we go into suspend states
- */
-void suspend_console(void)
-{
-	if (!console_suspend_enabled)
-		return;
-	printk("Suspending console(s) (use no_console_suspend to debug)\n");
-	console_lock();
-	console_suspended = 1;
-	up(&console_sem);
-}
-
-void resume_console(void)
-{
-	if (!console_suspend_enabled)
-		return;
-	down(&console_sem);
-	console_suspended = 0;
-	console_unlock();
-}
-
-/**
- * console_cpu_notify - print deferred console messages after CPU hotplug
- * @self: notifier struct
- * @action: CPU hotplug event
- * @hcpu: unused
- *
- * If printk() is called from a CPU that is not online yet, the messages
- * will be spooled but will not show up on the console.  This function is
- * called when a new CPU comes online (or fails to come up), and ensures
- * that any such output gets printed.
- */
-static int __cpuinit console_cpu_notify(struct notifier_block *self,
-	unsigned long action, void *hcpu)
-{
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_DEAD:
-	case CPU_DYING:
-	case CPU_DOWN_FAILED:
-	case CPU_UP_CANCELED:
-		console_lock();
-		console_unlock();
-	}
-	return NOTIFY_OK;
-}
-
-/**
- * console_lock - lock the console system for exclusive use.
- *
- * Acquires a lock which guarantees that the caller has
- * exclusive access to the console system and the console_drivers list.
- *
- * Can sleep, returns nothing.
- */
-void console_lock(void)
-{
-	BUG_ON(in_interrupt());
-	down(&console_sem);
-	if (console_suspended)
-		return;
-	console_locked = 1;
-	console_may_schedule = 1;
-}
-EXPORT_SYMBOL(console_lock);
-
-/**
- * console_trylock - try to lock the console system for exclusive use.
- *
- * Tried to acquire a lock which guarantees that the caller has
- * exclusive access to the console system and the console_drivers list.
- *
- * returns 1 on success, and 0 on failure to acquire the lock.
- */
-int console_trylock(void)
-{
-	if (down_trylock(&console_sem))
-		return 0;
-	if (console_suspended) {
-		up(&console_sem);
-		return 0;
-	}
-	console_locked = 1;
-	console_may_schedule = 0;
-	return 1;
-}
-EXPORT_SYMBOL(console_trylock);
-
-int is_console_locked(void)
-{
-	return console_locked;
-}
-
 /*
  * Delayed printk facility, for scheduler-internal messages:
  */
@@ -1008,157 +536,7 @@ void wake_up_klogd(void)
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
 }
 
-/**
- * console_unlock - unlock the console system
- *
- * Releases the console_lock which the caller holds on the console system
- * and the console driver list.
- *
- * While the console_lock was held, console output may have been buffered
- * by printk().  If this is the case, console_unlock(); emits
- * the output prior to releasing the lock.
- *
- * If there is output waiting for klogd, we wake it up.
- *
- * console_unlock(); may be called from any context.
- */
-void console_unlock(void)
-{
-	unsigned long flags;
-	unsigned _con_start, _log_end;
-	unsigned wake_klogd = 0, retry = 0;
-
-	if (console_suspended) {
-		up(&console_sem);
-		return;
-	}
-
-	console_may_schedule = 0;
-
-again:
-	for ( ; ; ) {
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		wake_klogd |= log_start - log_end;
-		if (con_start == log_end)
-			break;			/* Nothing to print */
-		_con_start = con_start;
-		_log_end = log_end;
-		con_start = log_end;		/* Flush */
-		raw_spin_unlock(&logbuf_lock);
-		stop_critical_timings();	/* don't trace print latency */
-		call_console_drivers(_con_start, _log_end);
-		start_critical_timings();
-		local_irq_restore(flags);
-	}
-	console_locked = 0;
-
-	/* Release the exclusive_console once it is used */
-	if (unlikely(exclusive_console))
-		exclusive_console = NULL;
-
-	raw_spin_unlock(&logbuf_lock);
-
-	up(&console_sem);
-
-	/*
-	 * Someone could have filled up the buffer again, so re-check if there's
-	 * something to flush. In case we cannot trylock the console_sem again,
-	 * there's a new owner and the console_unlock() from them will do the
-	 * flush, no worries.
-	 */
-	raw_spin_lock(&logbuf_lock);
-	if (con_start != log_end)
-		retry = 1;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
-
-	if (retry && console_trylock())
-		goto again;
-
-	if (wake_klogd)
-		wake_up_klogd();
-}
-EXPORT_SYMBOL(console_unlock);
-
-/**
- * console_conditional_schedule - yield the CPU if required
- *
- * If the console code is currently allowed to sleep, and
- * if this CPU should yield the CPU to another task, do
- * so here.
- *
- * Must be called within console_lock();.
- */
-void __sched console_conditional_schedule(void)
-{
-	if (console_may_schedule)
-		cond_resched();
-}
-EXPORT_SYMBOL(console_conditional_schedule);
-
-void console_unblank(void)
-{
-	struct console *c;
-
-	/*
-	 * console_unblank can no longer be called in interrupt context unless
-	 * oops_in_progress is set to 1..
-	 */
-	if (oops_in_progress) {
-		if (down_trylock(&console_sem) != 0)
-			return;
-	} else
-		console_lock();
-
-	console_locked = 1;
-	console_may_schedule = 0;
-	for_each_console(c)
-		if ((c->flags & CON_ENABLED) && c->unblank)
-			c->unblank();
-	console_unlock();
-}
-
-/*
- * Return the console tty driver structure and its associated index
- */
-struct tty_driver *console_device(int *index)
-{
-	struct console *c;
-	struct tty_driver *driver = NULL;
-
-	console_lock();
-	for_each_console(c) {
-		if (!c->device)
-			continue;
-		driver = c->device(c, index);
-		if (driver)
-			break;
-	}
-	console_unlock();
-	return driver;
-}
-
-/*
- * Prevent further output on the passed console device so that (for example)
- * serial drivers can disable console output before suspending a port, and can
- * re-enable output afterwards.
- */
-void console_stop(struct console *console)
-{
-	console_lock();
-	console->flags &= ~CON_ENABLED;
-	console_unlock();
-}
-EXPORT_SYMBOL(console_stop);
-
-void console_start(struct console *console)
-{
-	console_lock();
-	console->flags |= CON_ENABLED;
-	console_unlock();
-}
-EXPORT_SYMBOL(console_start);
-
-static int __read_mostly keep_bootcon;
+int __read_mostly keep_bootcon;
 
 static int __init keep_bootcon_setup(char *str)
 {
@@ -1170,216 +548,6 @@ static int __init keep_bootcon_setup(char *str)
 
 early_param("keep_bootcon", keep_bootcon_setup);
 
-/*
- * The console driver calls this routine during kernel initialization
- * to register the console printing procedure with printk() and to
- * print any messages that were printed by the kernel before the
- * console driver was initialized.
- *
- * This can happen pretty early during the boot process (because of
- * early_printk) - sometimes before setup_arch() completes - be careful
- * of what kernel features are used - they may not be initialised yet.
- *
- * There are two types of consoles - bootconsoles (early_printk) and
- * "real" consoles (everything which is not a bootconsole) which are
- * handled differently.
- *  - Any number of bootconsoles can be registered at any time.
- *  - As soon as a "real" console is registered, all bootconsoles
- *    will be unregistered automatically.
- *  - Once a "real" console is registered, any attempt to register a
- *    bootconsoles will be rejected
- */
-void register_console(struct console *newcon)
-{
-	int i;
-	unsigned long flags;
-	struct console *bcon = NULL;
-
-	/*
-	 * before we register a new CON_BOOT console, make sure we don't
-	 * already have a valid console
-	 */
-	if (console_drivers && newcon->flags & CON_BOOT) {
-		/* find the last or real console */
-		for_each_console(bcon) {
-			if (!(bcon->flags & CON_BOOT)) {
-				printk(KERN_INFO "Too late to register bootconsole %s%d\n",
-					newcon->name, newcon->index);
-				return;
-			}
-		}
-	}
-
-	if (console_drivers && console_drivers->flags & CON_BOOT)
-		bcon = console_drivers;
-
-	if (preferred_console < 0 || bcon || !console_drivers)
-		preferred_console = selected_console;
-
-	if (newcon->early_setup)
-		newcon->early_setup();
-
-	/*
-	 *	See if we want to use this console driver. If we
-	 *	didn't select a console we take the first one
-	 *	that registers here.
-	 */
-	if (preferred_console < 0) {
-		if (newcon->index < 0)
-			newcon->index = 0;
-		if (newcon->setup == NULL ||
-		    newcon->setup(newcon, NULL) == 0) {
-			newcon->flags |= CON_ENABLED;
-			if (newcon->device) {
-				newcon->flags |= CON_CONSDEV;
-				preferred_console = 0;
-			}
-		}
-	}
-
-	/*
-	 *	See if this console matches one we selected on
-	 *	the command line.
-	 */
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0];
-			i++) {
-		if (strcmp(console_cmdline[i].name, newcon->name) != 0)
-			continue;
-		if (newcon->index >= 0 &&
-		    newcon->index != console_cmdline[i].index)
-			continue;
-		if (newcon->index < 0)
-			newcon->index = console_cmdline[i].index;
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-		if (console_cmdline[i].brl_options) {
-			newcon->flags |= CON_BRL;
-			braille_register_console(newcon,
-					console_cmdline[i].index,
-					console_cmdline[i].options,
-					console_cmdline[i].brl_options);
-			return;
-		}
-#endif
-		if (newcon->setup &&
-		    newcon->setup(newcon, console_cmdline[i].options) != 0)
-			break;
-		newcon->flags |= CON_ENABLED;
-		newcon->index = console_cmdline[i].index;
-		if (i == selected_console) {
-			newcon->flags |= CON_CONSDEV;
-			preferred_console = selected_console;
-		}
-		break;
-	}
-
-	if (!(newcon->flags & CON_ENABLED))
-		return;
-
-	/*
-	 * If we have a bootconsole, and are switching to a real console,
-	 * don't print everything out again, since when the boot console, and
-	 * the real console are the same physical device, it's annoying to
-	 * see the beginning boot messages twice
-	 */
-	if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV))
-		newcon->flags &= ~CON_PRINTBUFFER;
-
-	/*
-	 *	Put this console in the list - keep the
-	 *	preferred driver at the head of the list.
-	 */
-	console_lock();
-	if ((newcon->flags & CON_CONSDEV) || console_drivers == NULL) {
-		newcon->next = console_drivers;
-		console_drivers = newcon;
-		if (newcon->next)
-			newcon->next->flags &= ~CON_CONSDEV;
-	} else {
-		newcon->next = console_drivers->next;
-		console_drivers->next = newcon;
-	}
-	if (newcon->flags & CON_PRINTBUFFER) {
-		/*
-		 * console_unlock(); will print out the buffered messages
-		 * for us.
-		 */
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		con_start = log_start;
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
-		/*
-		 * We're about to replay the log buffer.  Only do this to the
-		 * just-registered console to avoid excessive message spam to
-		 * the already-registered consoles.
-		 */
-		exclusive_console = newcon;
-	}
-	console_unlock();
-	console_sysfs_notify();
-
-	/*
-	 * By unregistering the bootconsoles after we enable the real console
-	 * we get the "console xxx enabled" message on all the consoles -
-	 * boot consoles, real consoles, etc - this is to ensure that end
-	 * users know there might be something in the kernel's log buffer that
-	 * went to the bootconsole (that they do not see on the real console)
-	 */
-	if (bcon &&
-	    ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV) &&
-	    !keep_bootcon) {
-		/* we need to iterate through twice, to make sure we print
-		 * everything out, before we unregister the console(s)
-		 */
-		printk(KERN_INFO "console [%s%d] enabled, bootconsole disabled\n",
-			newcon->name, newcon->index);
-		for_each_console(bcon)
-			if (bcon->flags & CON_BOOT)
-				unregister_console(bcon);
-	} else {
-		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
-			(newcon->flags & CON_BOOT) ? "boot" : "" ,
-			newcon->name, newcon->index);
-	}
-}
-EXPORT_SYMBOL(register_console);
-
-int unregister_console(struct console *console)
-{
-        struct console *a, *b;
-	int res = 1;
-
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	if (console->flags & CON_BRL)
-		return braille_unregister_console(console);
-#endif
-
-	console_lock();
-	if (console_drivers == console) {
-		console_drivers=console->next;
-		res = 0;
-	} else if (console_drivers) {
-		for (a=console_drivers->next, b=console_drivers ;
-		     a; b=a, a=b->next) {
-			if (a == console) {
-				b->next = a->next;
-				res = 0;
-				break;
-			}
-		}
-	}
-
-	/*
-	 * If this isn't the last console and it has CON_CONSDEV set, we
-	 * need to set it on the next preferred console.
-	 */
-	if (console_drivers != NULL && console->flags & CON_CONSDEV)
-		console_drivers->flags |= CON_CONSDEV;
-
-	console_unlock();
-	console_sysfs_notify();
-	return res;
-}
-EXPORT_SYMBOL(unregister_console);
-
 static int __init printk_late_init(void)
 {
 	struct console *con;
-- 
1.7.8.111.gad25c.dirty

