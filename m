Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0DWBKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:10:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48107 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0DWBJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:09:58 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: [PATCH 1/9] PM: Add suspend block api.
Date: Thu, 22 Apr 2010 18:08:50 -0700
Message-Id: <1271984938-13920-2-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1271984938-13920-1-git-send-email-arve@android.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds /sys/power/policy that selects the behaviour of /sys/power/state.
After setting the policy to opportunistic, writes to /sys/power/state
become non-blocking requests that specify which suspend state to enter
when no suspend blockers are active. A special state, "on", stops the
process by activating the "main" suspend blocker.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 Documentation/power/suspend-blockers.txt |   97 +++++++++++++
 include/linux/suspend_blocker.h          |   60 ++++++++
 kernel/power/Kconfig                     |   11 ++
 kernel/power/Makefile                    |    1 +
 kernel/power/main.c                      |   84 +++++++++++-
 kernel/power/power.h                     |    5 +
 kernel/power/suspend.c                   |    4 +-
 kernel/power/suspend_blocker.c           |  219 ++++++++++++++++++++++++++++++
 8 files changed, 477 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/power/suspend-blockers.txt
 create mode 100755 include/linux/suspend_blocker.h
 create mode 100644 kernel/power/suspend_blocker.c

diff --git a/Documentation/power/suspend-blockers.txt b/Documentation/power/suspend-blockers.txt
new file mode 100644
index 0000000..1c48514
--- /dev/null
+++ b/Documentation/power/suspend-blockers.txt
@@ -0,0 +1,97 @@
+Suspend blockers
+================
+
+Suspend blockers provide a mechanism for device drivers and user-space processes
+to prevent the system from entering suspend. By default writing to
+/sys/power/state will ignore suspend blockers. Writing "opportunistic" to
+/sys/power/policy will change the behaviour of /sys/power/state to repeatedly
+enter the requested state when no suspend blockers are active. Writing "on" to
+/sys/power/state will cancel the automatic sleep request. Suspend blockers do
+not affect sleep states entered from idle.
+
+To use a suspend blocker, a device driver needs a struct suspend_blocker object
+that has to be initialized with suspend_blocker_init. When no longer needed,
+the suspend blocker must be destroyed with suspend_blocker_destroy.
+
+A suspend blocker is activated using suspend_block, which prevents the system
+from entering suspend until the suspend blocker is deactivated with
+suspend_unblock. Many suspend blockers may be used simultaneously, and the
+system is prevented from entering suspend as long as at least one of them is
+active.
+
+If the suspend operation has already started when calling suspend_block on a
+suspend_blocker, it will abort the suspend operation as long it has not already
+reached called suspend_ops->enter. This means that calling suspend_block from an
+interrupt handler or a freezeable thread always works, but some or all drivers
+may be temporarily suspended.
+
+In cell phones or other embedded systems where powering the screen is a
+significant drain on the battery, suspend blockers can be used to allow
+user-space to decide whether a keystroke received while the system is suspended
+should cause the screen to be turned back on or allow the system to go back into
+suspend. Use set_irq_wake or a platform specific api to make sure the keypad
+interrupt wakes up the cpu. Once the keypad driver has resumed, the sequence of
+events can look like this:
+
+- The Keypad driver gets an interrupt. It then calls suspend_block on the
+  keypad-scan suspend_blocker and starts scanning the keypad matrix.
+- The keypad-scan code detects a key change and reports it to the input-event
+  driver.
+- The input-event driver sees the key change, enqueues an event, and calls
+  suspend_block on the input-event-queue suspend_blocker.
+- The keypad-scan code detects that no keys are held and calls suspend_unblock
+  on the keypad-scan suspend_blocker.
+- The user-space input-event thread returns from select/poll, calls
+  suspend_block on the process-input-events suspend_blocker and then calls read
+  on the input-event device.
+- The input-event driver dequeues the key-event and, since the queue is now
+  empty, it calls suspend_unblock on the input-event-queue suspend_blocker.
+- The user-space input-event thread returns from read. If it determines that
+  the key should leave the screen off, it calls suspend_unblock on the
+  process_input_events suspend_blocker and then calls select or poll. The
+  system will automatically suspend again, since now no suspend blockers are
+  active.
+
+                 Key pressed   Key released
+                     |             |
+keypad-scan          ++++++++++++++++++
+input-event-queue        +++          +++
+process-input-events       +++          +++
+
+
+Driver API
+==========
+
+A driver can use the suspend block api by adding a suspend_blocker variable to
+its state and calling suspend_blocker_init. For instance:
+struct state {
+	struct suspend_blocker suspend_blocker;
+}
+
+init() {
+	suspend_blocker_init(&state->suspend_blocker, "suspend-blocker-name");
+}
+
+Before freeing the memory, suspend_blocker_destroy must be called:
+
+uninit() {
+	suspend_blocker_destroy(&state->suspend_blocker);
+}
+
+When the driver determines that it needs to run (usually in an interrupt
+handler) it calls suspend_block:
+	suspend_block(&state->suspend_blocker);
+
+When it no longer needs to run it calls suspend_unblock:
+	suspend_unblock(&state->suspend_blocker);
+
+Calling suspend_block when the suspend blocker is active or suspend_unblock when
+it is not active has no effect. This allows drivers to update their state and
+call suspend suspend_block or suspend_unblock based on the result.
+For instance:
+
+if (list_empty(&state->pending_work))
+	suspend_unblock(&state->suspend_blocker);
+else
+	suspend_block(&state->suspend_blocker);
+
diff --git a/include/linux/suspend_blocker.h b/include/linux/suspend_blocker.h
new file mode 100755
index 0000000..21689cd
--- /dev/null
+++ b/include/linux/suspend_blocker.h
@@ -0,0 +1,60 @@
+/* include/linux/suspend_blocker.h
+ *
+ * Copyright (C) 2007-2009 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_SUSPEND_BLOCKER_H
+#define _LINUX_SUSPEND_BLOCKER_H
+
+/**
+ * struct suspend_blocker - the basic suspend_blocker structure
+ * @flags:	Tracks initialized and active state.
+ * @name:	Name used for debugging.
+ *
+ * When a suspend_blocker is active it prevents the system from entering
+ * suspend.
+ *
+ * The suspend_blocker structure must be initialized by suspend_blocker_init()
+ */
+
+struct suspend_blocker {
+#ifdef CONFIG_SUSPEND_BLOCKERS
+	atomic_t            flags;
+	const char         *name;
+#endif
+};
+
+#ifdef CONFIG_SUSPEND_BLOCKERS
+
+void suspend_blocker_init(struct suspend_blocker *blocker, const char *name);
+void suspend_blocker_destroy(struct suspend_blocker *blocker);
+void suspend_block(struct suspend_blocker *blocker);
+void suspend_unblock(struct suspend_blocker *blocker);
+bool suspend_blocker_is_active(struct suspend_blocker *blocker);
+bool suspend_is_blocked(void);
+
+#else
+
+static inline void suspend_blocker_init(struct suspend_blocker *blocker,
+					const char *name) {}
+static inline void suspend_blocker_destroy(struct suspend_blocker *blocker) {}
+static inline void suspend_block(struct suspend_blocker *blocker) {}
+static inline void suspend_unblock(struct suspend_blocker *blocker) {}
+static inline bool suspend_blocker_is_active(struct suspend_blocker *bl)
+								{ return 0; }
+static inline bool suspend_is_blocked(void) { return 0; }
+
+#endif
+
+#endif
+
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 5c36ea9..f8fa246 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -130,6 +130,17 @@ config SUSPEND_FREEZER
 
 	  Turning OFF this setting is NOT recommended! If in doubt, say Y.
 
+config SUSPEND_BLOCKERS
+	bool "Suspend blockers"
+	depends on PM
+	select RTC_LIB
+	default n
+	---help---
+	  Suspend blocker support. Write "opportunistic" to /sys/power/policy
+	  to enable suspend blockers. Then, when user space requests a sleep
+	  state through /sys/power/state, the requested sleep state will be
+	  entered when no suspend blockers are active.
+
 config HIBERNATION_NVS
 	bool
 
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 4319181..f570801 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_PM_SLEEP)		+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
+obj-$(CONFIG_SUSPEND_BLOCKERS)	+= suspend_blocker.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o
 obj-$(CONFIG_HIBERNATION_NVS)	+= hibernate_nvs.o
diff --git a/kernel/power/main.c b/kernel/power/main.c
index b58800b..9061ea0 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/resume-trace.h>
 #include <linux/workqueue.h>
+#include <linux/suspend_blocker.h>
 
 #include "power.h"
 
@@ -20,6 +21,27 @@ DEFINE_MUTEX(pm_mutex);
 unsigned int pm_flags;
 EXPORT_SYMBOL(pm_flags);
 
+struct policy {
+	const char *name;
+	bool (*valid_state)(suspend_state_t state);
+	int (*set_state)(suspend_state_t state);
+};
+static struct policy policies[] = {
+	{
+		.name		= "forced",
+		.valid_state	= valid_state,
+		.set_state	= enter_state,
+	},
+#ifdef CONFIG_SUSPEND_BLOCKERS
+	{
+		.name		= "opportunistic",
+		.valid_state	= request_suspend_valid_state,
+		.set_state	= request_suspend_state,
+	},
+#endif
+};
+static int policy;
+
 #ifdef CONFIG_PM_SLEEP
 
 /* Routines for PM-transition notifications */
@@ -146,6 +168,12 @@ struct kobject *power_kobj;
  *
  *	store() accepts one of those strings, translates it into the 
  *	proper enumerated value, and initiates a suspend transition.
+ *
+ *	If policy is set to opportunistic, store() does not block until the
+ *	system resumes, and it will try to re-enter the state until another
+ *	state is requested. Suspend blockers are respected and the requested
+ *	state will only be entered when no suspend blockers are active.
+ *	Write "on" to cancel.
  */
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 			  char *buf)
@@ -155,7 +183,7 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 	int i;
 
 	for (i = 0; i < PM_SUSPEND_MAX; i++) {
-		if (pm_states[i] && valid_state(i))
+		if (pm_states[i] && policies[policy].valid_state(i))
 			s += sprintf(s,"%s ", pm_states[i]);
 	}
 #endif
@@ -173,7 +201,7 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 			   const char *buf, size_t n)
 {
 #ifdef CONFIG_SUSPEND
-	suspend_state_t state = PM_SUSPEND_STANDBY;
+	suspend_state_t state = PM_SUSPEND_ON;
 	const char * const *s;
 #endif
 	char *p;
@@ -195,7 +223,7 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 			break;
 	}
 	if (state < PM_SUSPEND_MAX && *s)
-		error = enter_state(state);
+		error = policies[policy].set_state(state);
 #endif
 
  Exit:
@@ -204,6 +232,55 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 
 power_attr(state);
 
+/**
+ *	policy - set policy for state
+ */
+
+static ssize_t policy_show(struct kobject *kobj,
+			   struct kobj_attribute *attr, char *buf)
+{
+	char *s = buf;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(policies); i++) {
+		if (i == policy)
+			s += sprintf(s, "[%s] ", policies[i].name);
+		else
+			s += sprintf(s, "%s ", policies[i].name);
+	}
+	if (s != buf)
+		/* convert the last space to a newline */
+		*(s-1) = '\n';
+	return (s - buf);
+}
+
+static ssize_t policy_store(struct kobject *kobj,
+			    struct kobj_attribute *attr,
+			    const char *buf, size_t n)
+{
+	const char *s;
+	char *p;
+	int len;
+	int i;
+
+	p = memchr(buf, '\n', n);
+	len = p ? p - buf : n;
+
+	for (i = 0; i < ARRAY_SIZE(policies); i++) {
+		s = policies[i].name;
+		if (s && len == strlen(s) && !strncmp(buf, s, len)) {
+			mutex_lock(&pm_mutex);
+			policies[policy].set_state(PM_SUSPEND_ON);
+			policy = i;
+			mutex_unlock(&pm_mutex);
+			return n;
+		}
+	}
+	return -EINVAL;
+}
+
+power_attr(policy);
+
 #ifdef CONFIG_PM_TRACE
 int pm_trace_enabled;
 
@@ -231,6 +308,7 @@ power_attr(pm_trace);
 
 static struct attribute * g[] = {
 	&state_attr.attr,
+	&policy_attr.attr,
 #ifdef CONFIG_PM_TRACE
 	&pm_trace_attr.attr,
 #endif
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 46c5a26..9b468d7 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -236,3 +236,8 @@ static inline void suspend_thaw_processes(void)
 {
 }
 #endif
+
+/* kernel/power/suspend_block.c */
+extern int request_suspend_state(suspend_state_t state);
+extern bool request_suspend_valid_state(suspend_state_t state);
+
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 56e7dbb..dc42006 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -16,10 +16,12 @@
 #include <linux/cpu.h>
 #include <linux/syscalls.h>
 #include <linux/gfp.h>
+#include <linux/suspend_blocker.h>
 
 #include "power.h"
 
 const char *const pm_states[PM_SUSPEND_MAX] = {
+	[PM_SUSPEND_ON]		= "on",
 	[PM_SUSPEND_STANDBY]	= "standby",
 	[PM_SUSPEND_MEM]	= "mem",
 };
@@ -157,7 +159,7 @@ static int suspend_enter(suspend_state_t state)
 
 	error = sysdev_suspend(PMSG_SUSPEND);
 	if (!error) {
-		if (!suspend_test(TEST_CORE))
+		if (!suspend_is_blocked() && !suspend_test(TEST_CORE))
 			error = suspend_ops->enter(state);
 		sysdev_resume();
 	}
diff --git a/kernel/power/suspend_blocker.c b/kernel/power/suspend_blocker.c
new file mode 100644
index 0000000..1b345d1
--- /dev/null
+++ b/kernel/power/suspend_blocker.c
@@ -0,0 +1,219 @@
+/* kernel/power/suspend_blocker.c
+ *
+ * Copyright (C) 2005-2010 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/rtc.h>
+#include <linux/suspend.h>
+#include <linux/suspend_blocker.h>
+#include "power.h"
+
+enum {
+	DEBUG_EXIT_SUSPEND = 1U << 0,
+	DEBUG_WAKEUP = 1U << 1,
+	DEBUG_USER_STATE = 1U << 2,
+	DEBUG_SUSPEND = 1U << 3,
+	DEBUG_SUSPEND_BLOCKER = 1U << 4,
+};
+static int debug_mask = DEBUG_EXIT_SUSPEND | DEBUG_WAKEUP | DEBUG_USER_STATE;
+module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
+
+#define SB_INITIALIZED            (1U << 8)
+#define SB_ACTIVE                 (1U << 9)
+
+static DEFINE_SPINLOCK(state_lock);
+static atomic_t suspend_block_count;
+static atomic_t current_event_num;
+struct workqueue_struct *suspend_work_queue;
+struct suspend_blocker main_suspend_blocker;
+static suspend_state_t requested_suspend_state = PM_SUSPEND_MEM;
+static bool enable_suspend_blockers;
+
+#define pr_info_time(fmt, args...) \
+	do { \
+		struct timespec ts; \
+		struct rtc_time tm; \
+		getnstimeofday(&ts); \
+		rtc_time_to_tm(ts.tv_sec, &tm); \
+		pr_info(fmt "(%d-%02d-%02d %02d:%02d:%02d.%09lu UTC)\n" , \
+			args, \
+			tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, \
+			tm.tm_hour, tm.tm_min, tm.tm_sec, ts.tv_nsec); \
+	} while (0);
+
+/**
+ * suspend_is_blocked() - Check if suspend should be blocked
+ *
+ * suspend_is_blocked can be used by generic power management code to abort
+ * suspend.
+ *
+ * To preserve backward compatibility suspend_is_blocked returns 0 unless it
+ * is called during suspend initiated from the suspend_block code.
+ */
+bool suspend_is_blocked(void)
+{
+	if (!enable_suspend_blockers)
+		return 0;
+	return !!atomic_read(&suspend_block_count);
+}
+
+static void suspend_worker(struct work_struct *work)
+{
+	int ret;
+	int entry_event_num;
+
+	enable_suspend_blockers = true;
+	while (!suspend_is_blocked()) {
+		entry_event_num = atomic_read(&current_event_num);
+		if (debug_mask & DEBUG_SUSPEND)
+			pr_info("suspend: enter suspend\n");
+		ret = pm_suspend(requested_suspend_state);
+		if (debug_mask & DEBUG_EXIT_SUSPEND)
+			pr_info_time("suspend: exit suspend, ret = %d ", ret);
+		if (atomic_read(&current_event_num) == entry_event_num)
+			pr_info("suspend: pm_suspend returned with no event\n");
+	}
+	enable_suspend_blockers = false;
+}
+static DECLARE_WORK(suspend_work, suspend_worker);
+
+/**
+ * suspend_blocker_init() - Initialize a suspend blocker
+ * @blocker:	The suspend blocker to initialize.
+ * @name:	The name of the suspend blocker to show in debug messages.
+ *
+ * The suspend blocker struct and name must not be freed before calling
+ * suspend_blocker_destroy.
+ */
+void suspend_blocker_init(struct suspend_blocker *blocker, const char *name)
+{
+	WARN_ON(!name);
+
+	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
+		pr_info("suspend_blocker_init name=%s\n", name);
+
+	blocker->name = name;
+	atomic_set(&blocker->flags, SB_INITIALIZED);
+}
+EXPORT_SYMBOL(suspend_blocker_init);
+
+/**
+ * suspend_blocker_destroy() - Destroy a suspend blocker
+ * @blocker:	The suspend blocker to destroy.
+ */
+void suspend_blocker_destroy(struct suspend_blocker *blocker)
+{
+	int flags;
+	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
+		pr_info("suspend_blocker_destroy name=%s\n", blocker->name);
+	flags = atomic_xchg(&blocker->flags, 0);
+	WARN(!(flags & SB_INITIALIZED), "suspend_blocker_destroy called on "
+					"uninitialized suspend_blocker\n");
+	if (flags == (SB_INITIALIZED | SB_ACTIVE))
+		if (atomic_dec_and_test(&suspend_block_count))
+			queue_work(suspend_work_queue, &suspend_work);
+}
+EXPORT_SYMBOL(suspend_blocker_destroy);
+
+/**
+ * suspend_block() - Block suspend
+ * @blocker:	The suspend blocker to use
+ */
+void suspend_block(struct suspend_blocker *blocker)
+{
+	WARN_ON(!(atomic_read(&blocker->flags) & SB_INITIALIZED));
+
+	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
+		pr_info("suspend_block: %s\n", blocker->name);
+	if (atomic_cmpxchg(&blocker->flags, SB_INITIALIZED,
+	    SB_INITIALIZED | SB_ACTIVE) == SB_INITIALIZED)
+		atomic_inc(&suspend_block_count);
+
+	atomic_inc(&current_event_num);
+}
+EXPORT_SYMBOL(suspend_block);
+
+/**
+ * suspend_unblock() - Unblock suspend
+ * @blocker:	The suspend blocker to unblock.
+ *
+ * If no other suspend blockers block suspend, the system will suspend.
+ */
+void suspend_unblock(struct suspend_blocker *blocker)
+{
+	WARN_ON(!(atomic_read(&blocker->flags) & SB_INITIALIZED));
+
+	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
+		pr_info("suspend_unblock: %s\n", blocker->name);
+
+	if (atomic_cmpxchg(&blocker->flags, SB_INITIALIZED | SB_ACTIVE,
+	    SB_INITIALIZED) == (SB_INITIALIZED | SB_ACTIVE))
+		if (atomic_dec_and_test(&suspend_block_count))
+			queue_work(suspend_work_queue, &suspend_work);
+}
+EXPORT_SYMBOL(suspend_unblock);
+
+/**
+ * suspend_blocker_is_active() - Test if a suspend blocker is blocking suspend
+ * @blocker:	The suspend blocker to check.
+ *
+ * Returns true if the suspend_blocker is currently active.
+ */
+bool suspend_blocker_is_active(struct suspend_blocker *blocker)
+{
+	WARN_ON(!(atomic_read(&blocker->flags) & SB_INITIALIZED));
+
+	return !!(atomic_read(&blocker->flags) & SB_ACTIVE);
+}
+EXPORT_SYMBOL(suspend_blocker_is_active);
+
+bool request_suspend_valid_state(suspend_state_t state)
+{
+	return (state == PM_SUSPEND_ON) || valid_state(state);
+}
+
+int request_suspend_state(suspend_state_t state)
+{
+	unsigned long irqflags;
+
+	if (!request_suspend_valid_state(state))
+		return -ENODEV;
+
+	spin_lock_irqsave(&state_lock, irqflags);
+	if (debug_mask & DEBUG_USER_STATE)
+		pr_info_time("request_suspend_state: %s (%d->%d) at %lld ",
+			     state != PM_SUSPEND_ON ? "sleep" : "wakeup",
+			     requested_suspend_state, state,
+			     ktime_to_ns(ktime_get()));
+	requested_suspend_state = state;
+	if (state == PM_SUSPEND_ON)
+		suspend_block(&main_suspend_blocker);
+	else
+		suspend_unblock(&main_suspend_blocker);
+	spin_unlock_irqrestore(&state_lock, irqflags);
+	return 0;
+}
+
+static int __init suspend_block_init(void)
+{
+	suspend_work_queue = create_singlethread_workqueue("suspend");
+	if (!suspend_work_queue)
+		return -ENOMEM;
+
+	suspend_blocker_init(&main_suspend_blocker, "main");
+	suspend_block(&main_suspend_blocker);
+	return 0;
+}
+
+core_initcall(suspend_block_init);
-- 
1.6.5.1

