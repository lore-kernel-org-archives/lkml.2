Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2LEQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:09:59 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55554 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab2LEQJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:50 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 43/44] tty/metag_da: Add metag DA TTY driver
Date: Wed, 5 Dec 2012 16:09:01 +0000
Message-ID: <1354723742-6195-44-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a TTY driver for communicating over a Meta DA (Debug Adapter)
channel using the bios channel SWITCH operation.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS                            |    1 +
 arch/metag/Kconfig                     |    4 +-
 arch/metag/configs/meta1_defconfig     |    2 +
 arch/metag/configs/meta2_defconfig     |    2 +
 arch/metag/configs/meta2_smp_defconfig |    2 +
 arch/metag/kernel/setup.c              |   12 +
 drivers/tty/Kconfig                    |   13 +
 drivers/tty/Makefile                   |    1 +
 drivers/tty/metag_da.c                 |  523 ++++++++++++++++++++++++++++++++
 9 files changed, 559 insertions(+), 1 deletions(-)
 create mode 100644 drivers/tty/metag_da.c

diff --git a/MAINTAINERS b/MAINTAINERS
index b2b64ea..9ed766d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4856,6 +4856,7 @@ S:	Maintained
 F:	arch/metag/
 F:	Documentation/metag/
 F:	Documentation/devicetree/bindings/metag/
+F:	drivers/tty/metag_da.c
 
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index 5807964..9489431 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -220,7 +220,9 @@ config METAG_DA
 	  of the DA will be detected automatically at boot, so it is safe to say
 	  Y to this option even when booting without a DA.
 
-	  This enables support for services provided by DA JTAG debug adapters.
+	  This enables support for services provided by DA JTAG debug adapters,
+	  such as:
+	  - communication over DA channels (such as the console driver).
 
 menu "Boot options"
 
diff --git a/arch/metag/configs/meta1_defconfig b/arch/metag/configs/meta1_defconfig
index 76a2d5f..f440e5a 100644
--- a/arch/metag/configs/meta1_defconfig
+++ b/arch/metag/configs/meta1_defconfig
@@ -28,6 +28,8 @@ CONFIG_BLK_DEV_RAM_SIZE=16384
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
 # CONFIG_LEGACY_PTYS is not set
+CONFIG_DA_TTY=y
+CONFIG_DA_CONSOLE=y
 # CONFIG_DEVKMEM is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
diff --git a/arch/metag/configs/meta2_defconfig b/arch/metag/configs/meta2_defconfig
index 0b46722..b9ecdd2 100644
--- a/arch/metag/configs/meta2_defconfig
+++ b/arch/metag/configs/meta2_defconfig
@@ -29,6 +29,8 @@ CONFIG_BLK_DEV_RAM_SIZE=16384
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
 # CONFIG_LEGACY_PTYS is not set
+CONFIG_DA_TTY=y
+CONFIG_DA_CONSOLE=y
 # CONFIG_DEVKMEM is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
diff --git a/arch/metag/configs/meta2_smp_defconfig b/arch/metag/configs/meta2_smp_defconfig
index b254e6c..87b60eb 100644
--- a/arch/metag/configs/meta2_smp_defconfig
+++ b/arch/metag/configs/meta2_smp_defconfig
@@ -30,6 +30,8 @@ CONFIG_BLK_DEV_RAM_SIZE=16384
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
 # CONFIG_LEGACY_PTYS is not set
+CONFIG_DA_TTY=y
+CONFIG_DA_CONSOLE=y
 # CONFIG_DEVKMEM is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index 65e8641..35d129f 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -61,6 +61,11 @@ extern char _heap_start[];
 extern u32 __dtb_start[];
 #endif
 
+#ifdef CONFIG_DA_CONSOLE
+/* Our early channel based console driver */
+extern struct console dash_console;
+#endif
+
 struct machine_desc *machine_desc __initdata;
 
 /*
@@ -184,6 +189,13 @@ void __init setup_arch(char **cmdline_p)
 	int heap_id, i;
 
 	metag_da_probe();
+#ifdef CONFIG_DA_CONSOLE
+	if (metag_da_enabled()) {
+		/* An early channel based console driver */
+		register_console(&dash_console);
+		add_preferred_console("ttyDA", 1, NULL);
+	}
+#endif
 
 	/* try interpreting the argument as a device tree */
 	machine_desc = setup_machine_fdt(original_cmd_line);
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index d8e05ee..182f92b 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -387,3 +387,16 @@ config PPC_EARLY_DEBUG_EHV_BC_HANDLE
 	  If the number you specify is not a valid byte channel handle, then
 	  there simply will be no early console output.  This is true also
 	  if you don't boot under a hypervisor at all.
+
+config DA_TTY
+	bool "DA TTY"
+	depends on METAG_DA
+	select SERIAL_NONSTANDARD
+	help
+	  This enables a TTY on a Dash channel.
+
+config DA_CONSOLE
+	bool "DA Console"
+	depends on DA_TTY
+	help
+	  This enables a console on a Dash channel.
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index 2953059..dbd7745 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -27,5 +27,6 @@ obj-$(CONFIG_SYNCLINK_GT)	+= synclink_gt.o
 obj-$(CONFIG_SYNCLINKMP)	+= synclinkmp.o
 obj-$(CONFIG_SYNCLINK)		+= synclink.o
 obj-$(CONFIG_PPC_EPAPR_HV_BYTECHAN) += ehv_bytechan.o
+obj-$(CONFIG_DA_TTY)	+= metag_da.o
 
 obj-y += ipwireless/
diff --git a/drivers/tty/metag_da.c b/drivers/tty/metag_da.c
new file mode 100644
index 0000000..e46d80b
--- /dev/null
+++ b/drivers/tty/metag_da.c
@@ -0,0 +1,523 @@
+/*
+ *  dashtty.c - tty driver for Dash channels interface.
+ *
+ *  Copyright (C) 2007,2008,2012 Imagination Technologies
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/timer.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+#include <linux/string.h>
+#include <linux/sched.h>
+#include <linux/console.h>
+#include <linux/uaccess.h>
+#include <linux/kthread.h>
+
+#include <asm/da.h>
+
+/* Channel error codes */
+#define CONAOK	0
+#define CONERR	1
+#define CONBAD	2
+#define CONPRM	3
+#define CONADR	4
+#define CONCNT	5
+#define CONCBF	6
+#define CONCBE	7
+#define CONBSY	8
+
+/* Default channel for the console */
+#define CONSOLE_CHANNEL      1
+
+/* First channel available for tty use. */
+#define FIRST_TTY_CHANNEL    0
+
+#define NUM_TTY_CHANNELS     6
+
+/* Auto allocate */
+#define DA_TTY_MAJOR        0
+
+/* A speedy poll rate helps the userland debug process connection response.
+ * But, if you set it too high then no other userland processes get much
+ * of a look in.
+ */
+#define DA_TTY_POLL (HZ / 50)
+
+static int num_channels_need_poll;
+
+static struct timer_list poll_timer;
+
+static struct tty_driver *channel_driver;
+
+static struct task_struct *dashtty_thread;
+
+#define RX_BUF_SIZE 1024
+
+enum {
+	INCHR = 1,
+	OUTCHR,
+	RDBUF,
+	WRBUF,
+	RDSTAT
+};
+
+/* One struct dashtty exists per open channel. */
+struct dashtty {
+	struct tty_struct *tty;
+	struct tty_port *port;
+};
+
+static struct tty_port dashtty_ports[NUM_TTY_CHANNELS];
+
+struct dashbuf {
+	struct list_head entry;
+	struct dashtty *tty;
+	unsigned char *buf;
+	int count;
+	int chan;
+};
+
+static struct dashtty *dashtty_ttys[NUM_TTY_CHANNELS];
+static struct list_head dashtty_output_queue;
+static spinlock_t dashtty_q_lock;
+static wait_queue_head_t dashtty_waitqueue;
+
+static DEFINE_MUTEX(dashtty_mutex);
+
+/*
+ * Low-level DA channel access routines
+ */
+static int chancall(int bios_function, int channel, int arg2, void *arg3,
+			void *arg4)
+{
+	register int   bios_function__ __asm__("D1Ar1") = bios_function;
+	register int   channel__       __asm__("D0Ar2") = channel;
+	register int   arg2__          __asm__("D1Ar3") = arg2;
+	register void *arg3__          __asm__("D0Ar4") = arg3;
+	register void *arg4__          __asm__("D1Ar5") = arg4;
+	register int   bios_call       __asm__("D0Ar6") = 3;
+	register int   result          __asm__("D0Re0");
+
+	__asm__ volatile (
+		"SETL   [A0StP++], %6,%5\n\t"
+		"SETL   [A0StP++], %4,%3\n\t"
+		"SETL   [A0StP++], %2,%1\n\t"
+		"ADD    A0StP, A0StP, #8\n\t"
+		"SWITCH #0x0C30208\n\t"
+		"GETD   %0, [A0StP+#-8]\n\t"
+		"SUB    A0StP, A0StP, #(4*6)+8\n\t"
+		: "=r" (result)/* outs */
+		: "r" (bios_function__), "r" (channel__), "r" (arg2__),
+		  "r" (arg3__), "r" (arg4__), "r" (bios_call) /* ins */
+		: "memory");
+
+	return result;
+}
+
+/*
+ * Attempts to fetch count bytes from channel channel and returns actual count.
+ */
+static int fetch_data(int channel)
+{
+	struct dashtty *dashtty = dashtty_ttys[channel];
+	struct tty_struct *tty = dashtty->tty;
+	int received = 0;
+
+	if (chancall(RDBUF, channel, RX_BUF_SIZE,
+		     (void *)dashtty->port->xmit_buf, &received) == CONAOK) {
+		if (received) {
+			int space;
+			unsigned char *cbuf;
+
+			space = tty_prepare_flip_string(tty, &cbuf, received);
+
+			if (space <= 0)
+				return 0;
+
+			memcpy(cbuf, dashtty->port->xmit_buf, space);
+			tty_flip_buffer_push(tty);
+		}
+	}
+
+	return received;
+}
+
+/*
+ *	Finds the next channel to poll
+ */
+static int find_channel_to_poll(void)
+{
+	static int last_polled_channel = FIRST_TTY_CHANNEL;
+
+	int this_channel = last_polled_channel;
+
+	while (++this_channel != last_polled_channel) {
+		if (this_channel >= NUM_TTY_CHANNELS)
+			this_channel = 0;
+
+		if (dashtty_ttys[this_channel]) {
+			last_polled_channel = this_channel;
+			break;
+		}
+	}
+	return last_polled_channel;
+}
+
+static int put_data(void *arg)
+{
+	struct dashbuf *dbuf;
+	int number_written;
+
+	__set_current_state(TASK_RUNNING);
+	while (!kthread_should_stop()) {
+		/*
+		 * Pick up all the output buffers and write them out.
+		 *
+		 * FIXME: should we check with ASE how much room we have?
+		 * Ideally, this will already have been done by write_room ??
+		 */
+		spin_lock(&dashtty_q_lock);
+
+		while (!list_empty(&dashtty_output_queue)) {
+			dbuf = list_entry(dashtty_output_queue.next,
+					  struct dashbuf, entry);
+
+			chancall(WRBUF, dbuf->chan, dbuf->count,
+				 (void *)dbuf->buf, &number_written);
+
+			if (list_is_last(&dbuf->entry,
+					 &dashtty_output_queue))
+				list_del_init(&dashtty_output_queue);
+			else
+				list_del(&dbuf->entry);
+
+			/*
+			 * FIXME: should we only be doing wake when we
+			 * know something is sleeping?
+			 */
+			tty_wakeup(dbuf->tty->tty);
+
+			kfree(dbuf->buf);
+			kfree(dbuf);
+		}
+		spin_unlock(&dashtty_q_lock);
+
+		wait_event_interruptible(dashtty_waitqueue,
+					 !list_empty(&dashtty_output_queue));
+	}
+
+	return 0;
+}
+
+/*
+ *	This gets called every DA_TTY_POLL and polls the channels for data
+ */
+static void dashtty_timer(unsigned long ignored)
+{
+	struct dashtty *dtty;
+	int this_channel;
+
+	/* If there are no ports open do nothing and don't poll again. */
+	if (num_channels_need_poll == 0)
+		return;
+
+	this_channel = find_channel_to_poll();
+	dtty = dashtty_ttys[this_channel];
+
+	/* Did we find a channel to poll ? */
+	if (dtty)
+		fetch_data(this_channel);
+
+	mod_timer_pinned(&poll_timer, jiffies + DA_TTY_POLL);
+}
+
+static void add_poll_timer(struct timer_list *poll_timer)
+{
+	init_timer(poll_timer);
+
+	poll_timer->function = dashtty_timer;
+	poll_timer->expires = jiffies + DA_TTY_POLL;
+
+	/*
+	 * Always attach the timer to the boot CPU.
+	 */
+	add_timer_on(poll_timer, 0);
+}
+
+static int dashtty_open(struct tty_struct *tty, struct file *filp)
+{
+	struct dashtty *dashtty;
+	int line;
+
+	if (!tty)
+		return -ENODEV;
+
+	line = tty->index;
+
+	if (line < 0 || line >= NUM_TTY_CHANNELS)
+		return -ENODEV;
+
+	mutex_lock(&dashtty_mutex);
+	dashtty = dashtty_ttys[line];
+	if (!dashtty) {
+		dashtty = kzalloc(sizeof(struct dashtty), GFP_KERNEL);
+
+		if (!dashtty)
+			return -ENOMEM;
+
+		dashtty->port = &dashtty_ports[line];
+
+		dashtty->port->xmit_buf = kzalloc(RX_BUF_SIZE, GFP_KERNEL);
+		dashtty->tty = tty;
+		dashtty_ttys[line] = dashtty;
+	}
+
+	dashtty->port->count++;
+	tty_port_tty_set(dashtty->port, tty);
+
+	mutex_unlock(&dashtty_mutex);
+
+	/*
+	 * Don't add the poll timer if we're opening a console. This
+	 * avoids the overhead of polling the Dash but means it is not
+	 * possible to have a login on /dev/console.
+	 *
+	 */
+	if (line == CONSOLE_CHANNEL)
+		return 0;
+
+	if (num_channels_need_poll == 0)
+		add_poll_timer(&poll_timer);
+
+	num_channels_need_poll++;
+
+	return 0;
+}
+
+static void dashtty_close(struct tty_struct *tty, struct file *filp)
+{
+	int line;
+
+	if (!tty)
+		return;
+
+	line = tty->index;
+
+	if (line < 0 || line >= NUM_TTY_CHANNELS)
+		return;
+
+	mutex_lock(&dashtty_mutex);
+	dashtty_ttys[line]->port->count--;
+
+	if (!dashtty_ttys[line]->port->count) {
+		tty_port_tty_set(dashtty_ttys[line]->port, NULL);
+		kfree(dashtty_ttys[line]->port->xmit_buf);
+		kfree(dashtty_ttys[line]);
+		dashtty_ttys[line] = NULL;
+	}
+
+	mutex_unlock(&dashtty_mutex);
+
+	if (line == CONSOLE_CHANNEL)
+		return;
+
+	num_channels_need_poll--;
+
+	if (num_channels_need_poll <= 0)
+		del_timer(&poll_timer);
+}
+
+static int dashtty_write(struct tty_struct *tty, const unsigned char *buf,
+			 int count)
+{
+	struct dashtty *dtty;
+	struct dashbuf *dbuf;
+	int channel;
+
+	if (count <= 0)
+		return 0;
+
+	/* Determine the channel */
+	channel = FIRST_TTY_CHANNEL + tty->index;
+	dtty = dashtty_ttys[channel];
+	BUG_ON(!dtty);
+
+	dbuf = kzalloc(sizeof(*dbuf), GFP_KERNEL);
+	if (!dbuf)
+		return 0;
+
+	dbuf->buf = kzalloc(count, GFP_KERNEL);
+	if (!dbuf->buf) {
+		kfree(dbuf);
+		return 0;
+	}
+
+	memcpy(dbuf->buf, buf, count);
+	dbuf->count = count;
+	dbuf->chan = channel;
+	dbuf->tty = dtty;
+
+	/*
+	 * Enqueue the output buffer.
+	 *
+	 * The reason that we asynchronously write the buffer is because
+	 * there's no way to tell what CPU we're currently executing on.
+	 * If we were to write the buffer synchornously then because dash
+	 * channels are per-CPU the buffer would be written to the channel
+	 * of whatever CPU we're running on.
+	 *
+	 * What we actually want to happen is have all input and output
+	 * done on one CPU.
+	 */
+	spin_lock(&dashtty_q_lock);
+	list_add_tail(&dbuf->entry, &dashtty_output_queue);
+	spin_unlock(&dashtty_q_lock);
+
+	wake_up_interruptible(&dashtty_waitqueue);
+
+	/*
+	 * FIXME: This is slightly optimistic. Because we're deferring
+	 * the output until later it is impossible to predict whether we
+	 * will actually write "count" bytes.
+	 */
+	return count;
+}
+
+/*
+ * Ask the stub how much room there is in the channel
+ */
+static int dashtty_write_room(struct tty_struct *tty)
+{
+	unsigned int data[2];
+	static unsigned int actual_space;
+	int channel;
+
+	if (actual_space)
+		return actual_space;
+
+	channel = FIRST_TTY_CHANNEL + tty->index;
+
+	/* Is there any data waiting ? */
+	if (chancall(RDSTAT, channel, 0, NULL, &data[0]) == CONAOK) {
+		/* There was a bug in LogieDash (1.2.8a at least) where
+		 * the two values were returned the WRONG WAY AROUND!!!
+		 */
+		actual_space = data[1];
+	}
+
+	return actual_space;
+}
+
+static int dashtty_chars_in_buffer(struct tty_struct *tty)
+{
+	return 0;               /* we're not buffering */
+}
+
+static const struct tty_operations dashtty_ops = {
+	.open = dashtty_open,
+	.close = dashtty_close,
+	.write = dashtty_write,
+	.write_room = dashtty_write_room,
+	.chars_in_buffer = dashtty_chars_in_buffer,
+};
+
+static int __init dashtty_init(void)
+{
+	int ret;
+	int nport;
+
+	if (!metag_da_enabled())
+		return -ENODEV;
+
+	channel_driver = tty_alloc_driver(NUM_TTY_CHANNELS, 0);
+	if (IS_ERR(channel_driver))
+		return PTR_ERR(channel_driver);
+
+	channel_driver->owner = THIS_MODULE;
+	channel_driver->driver_name = "ttyDA";
+	channel_driver->name = "ttyDA";
+	channel_driver->major = DA_TTY_MAJOR;
+	channel_driver->minor_start = 0;
+	channel_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	channel_driver->subtype = SERIAL_TYPE_NORMAL;
+	channel_driver->init_termios = tty_std_termios;
+	channel_driver->init_termios.c_cflag =
+	    B38400 | CS8 | CREAD | HUPCL | CLOCAL;
+	channel_driver->flags = TTY_DRIVER_REAL_RAW;
+
+	tty_set_operations(channel_driver, &dashtty_ops);
+	for (nport = 0; nport < NUM_TTY_CHANNELS; nport++) {
+		tty_port_init(&dashtty_ports[nport]);
+		tty_port_link_device(&dashtty_ports[nport], channel_driver,
+				     nport);
+	}
+
+	spin_lock_init(&dashtty_q_lock);
+	INIT_LIST_HEAD(&dashtty_output_queue);
+	init_waitqueue_head(&dashtty_waitqueue);
+	dashtty_thread = kthread_create(put_data, NULL, "ttyDA");
+	if (IS_ERR(dashtty_thread)) {
+		pr_info("Couldn't create dashtty thread\n");
+		return PTR_ERR(dashtty_thread);
+	}
+	kthread_bind(dashtty_thread, 0);
+	wake_up_process(dashtty_thread);
+
+	ret = tty_register_driver(channel_driver);
+
+	if (ret < 0) {
+		pr_info("Couldn't install dashtty driver: err %d\n",
+			ret);
+		put_tty_driver(channel_driver);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void dashtty_exit(void)
+{
+	kthread_stop(dashtty_thread);
+	del_timer(&poll_timer);
+	tty_unregister_driver(channel_driver);
+	put_tty_driver(channel_driver);
+}
+
+module_init(dashtty_init);
+module_exit(dashtty_exit);
+
+#ifdef CONFIG_DA_CONSOLE
+
+static void dash_console_write(struct console *co, const char *s,
+			       unsigned int count)
+{
+	int actually_written;
+
+	chancall(WRBUF, CONSOLE_CHANNEL, count, (void *)s, &actually_written);
+}
+
+static struct tty_driver *dash_console_device(struct console *c, int *index)
+{
+	*index = c->index;
+	return channel_driver;
+}
+
+struct console dash_console = {
+	.name = "ttyDA",
+	.write = dash_console_write,
+	.device = dash_console_device,
+	.flags = CON_PRINTBUFFER,
+	.index = 1,
+};
+
+#endif
-- 
1.7.7.6


