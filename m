Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2IJEQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 00:16:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63952 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab2IJEQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 00:16:45 -0400
Date: Sun, 9 Sep 2012 21:14:12 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: [PATCH 10/14] tty/serial: Add kgdb_nmi driver
Message-ID: <20120910041412.GJ29537@lizard>
References: <20120910040802.GA1261@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120910040802.GA1261@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This special driver makes it possible to temporary use NMI debugger port
as a normal console by issuing 'nmi_console' command (assuming that the
port is attached to KGDB).

Unlike KDB's disable_nmi command, with this driver you are always able
to go back to the debugger using KGDB escape sequence ($3#33).  This is
because this console driver processes the input in NMI context, and thus
is able to intercept the magic sequence.

Note that since the console interprets input and uses polling
communication methods, for things like PPP it is still better to fully
detach debugger port from the KGDB NMI (i.e. disable_nmi), and use raw
console.

Usually, to enter the debugger one have to type the magic sequence, so
initially the kernel will print the following prompt on the NMI debugger
console:

	Type $3#33 to enter the debugger>

For convenience, there is a kgdb_fiq.knock kernel command line option,
when set to 0, this turns the special command to just a return key
press, so the kernel will be printing this:

	Hit <return> to enter the debugger>

This is more convenient for long debugging sessions, although it makes
nmi_console feature somewhat useless.

And for the cases when NMI connected to a dedicated button, the knocking
can be disabled altogether by setting kgdb_fiq.knock to -1.

Suggested-by: Colin Cross <ccross@android.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/tty/serial/Kconfig    |  19 +++
 drivers/tty/serial/Makefile   |   1 +
 drivers/tty/serial/kgdb_nmi.c | 352 ++++++++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/kgdboc.c   |   6 +
 include/linux/kgdb.h          |  10 ++
 5 files changed, 388 insertions(+)
 create mode 100644 drivers/tty/serial/kgdb_nmi.c

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 4720b4b..32d6d3f 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -141,6 +141,25 @@ config SERIAL_ATMEL_TTYAT
 
 	  Say Y if you have an external 8250/16C550 UART.  If unsure, say N.
 
+config SERIAL_KGDB_NMI
+	bool "Serial console over KGDB NMI debugger port"
+	depends on KGDB_SERIAL_CONSOLE
+	help
+	  This special driver allows you to temporary use NMI debugger port
+	  as a normal console (assuming that the port is attached to KGDB).
+
+	  Unlike KDB's disable_nmi command, with this driver you are always
+	  able to go back to the debugger using KGDB escape sequence ($3#33).
+	  This is because this console driver processes the input in NMI
+	  context, and thus is able to intercept the magic sequence.
+
+	  Note that since the console interprets input and uses polling
+	  communication methods, for things like PPP you still must fully
+	  detach debugger port from the KGDB NMI (i.e. disable_nmi), and
+	  use raw console.
+
+	  If unsure, say N.
+
 config SERIAL_KS8695
 	bool "Micrel KS8695 (Centaur) serial port support"
 	depends on ARCH_KS8695
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index 7257c5d..7a61d52 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_SERIAL_MSM_HS) += msm_serial_hs.o
 obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
 obj-$(CONFIG_SERIAL_OF_PLATFORM) += of_serial.o
 obj-$(CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL) += nwpserial.o
+obj-$(CONFIG_SERIAL_KGDB_NMI) += kgdb_nmi.o
 obj-$(CONFIG_SERIAL_KS8695) += serial_ks8695.o
 obj-$(CONFIG_SERIAL_OMAP) += omap-serial.o
 obj-$(CONFIG_SERIAL_ALTERA_UART) += altera_uart.o
diff --git a/drivers/tty/serial/kgdb_nmi.c b/drivers/tty/serial/kgdb_nmi.c
new file mode 100644
index 0000000..697cf13
--- /dev/null
+++ b/drivers/tty/serial/kgdb_nmi.c
@@ -0,0 +1,352 @@
+/*
+ * KGDB NMI serial console
+ *
+ * Copyright 2010 Google, Inc.
+ *		  Arve Hjønnevåg <arve@android.com>
+ *		  Colin Cross <ccross@android.com>
+ * Copyright 2012 Linaro Ltd.
+ *		  Anton Vorontsov <anton.vorontsov@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/mutex.h>
+#include <linux/atomic.h>
+#include <linux/console.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+#include <linux/interrupt.h>
+#include <linux/hrtimer.h>
+#include <linux/tick.h>
+#include <linux/kfifo.h>
+#include <linux/kgdb.h>
+#include <linux/kdb.h>
+
+static int kgdb_nmi_knock = 1;
+module_param_named(knock, kgdb_nmi_knock, int, 0600);
+MODULE_PARM_DESC(knock, "if set to 1 (default), the special '$3#33' command "
+			"must be used to enter the debugger; when set to 0, "
+			"hitting return key is enough to enter the debugger; "
+			"when set to -1, the debugger is entered immediately "
+			"upon NMI");
+
+static char *kgdb_nmi_magic = "$3#33";
+module_param_named(magic, kgdb_nmi_magic, charp, 0600);
+MODULE_PARM_DESC(magic, "magic sequence to enter NMI debugger (default $3#33)");
+
+static bool kgdb_nmi_tty_enabled;
+
+static void kgdb_nmi_console_write(struct console *co, const char *s, uint c)
+{
+	int i;
+
+	if (!kgdb_nmi_tty_enabled || atomic_read(&kgdb_active) >= 0)
+		return;
+
+	for (i = 0; i < c; i++)
+		dbg_io_ops->write_char(s[i]);
+}
+
+static struct tty_driver *kgdb_nmi_tty_driver;
+
+static struct tty_driver *kgdb_nmi_console_device(struct console *co, int *idx)
+{
+	*idx = co->index;
+	return kgdb_nmi_tty_driver;
+}
+
+static struct console kgdb_nmi_console = {
+	.name	= "ttyNMI",
+	.write	= kgdb_nmi_console_write,
+	.device	= kgdb_nmi_console_device,
+	.flags	= CON_PRINTBUFFER | CON_ANYTIME | CON_ENABLED,
+	.index	= -1,
+};
+
+/*
+ * This is usually the maximum rate on debug ports. We make fifo large enough
+ * to make copy-pasting to the terminal usable.
+ */
+#define KGDB_NMI_BAUD		115200
+#define KGDB_NMI_FIFO_SIZE	roundup_pow_of_two(KGDB_NMI_BAUD / 8 / HZ)
+
+struct kgdb_nmi_tty_priv {
+	int opened;
+	struct tty_struct *tty;
+	struct tasklet_struct tlet;
+	STRUCT_KFIFO(char, KGDB_NMI_FIFO_SIZE) fifo;
+};
+
+/*
+ * Our debugging console is polled in a tasklet, so we'll check for input
+ * every tick. In HZ-less mode, we should program the next tick.  We have
+ * to use the lowlevel stuff as no locks should be grabbed.
+ */
+#ifdef CONFIG_HIGH_RES_TIMERS
+static void kgdb_tty_poke(void)
+{
+	tick_program_event(ktime_get(), 0);
+}
+#else
+static inline void kgdb_tty_poke(void) {}
+#endif
+
+static struct tty_struct *kgdb_nmi_tty;
+
+static void kgdb_tty_recv(int ch)
+{
+	struct kgdb_nmi_tty_priv *priv;
+	char c = ch;
+
+	if (!kgdb_nmi_tty || ch < 0)
+		return;
+
+	priv = kgdb_nmi_tty->driver_data;
+	kfifo_in(&priv->fifo, &c, 1);
+	kgdb_tty_poke();
+}
+
+static int kgdb_nmi_poll_one_knock(void)
+{
+	static int n;
+	int c = -1;
+	const char *magic = kgdb_nmi_magic;
+	size_t m = strlen(magic);
+	bool printch = 0;
+
+	c = dbg_io_ops->read_char();
+	if (c == NO_POLL_CHAR)
+		return c;
+
+	if (!kgdb_nmi_knock && (c == '\r' || c == '\n')) {
+		return 1;
+	} else if (c == magic[n]) {
+		n = (n + 1) % m;
+		if (!n)
+			return 1;
+		printch = 1;
+	} else {
+		n = 0;
+	}
+
+	if (kgdb_nmi_tty_enabled) {
+		kgdb_tty_recv(c);
+		return 0;
+	}
+
+	if (printch) {
+		kdb_printf("%c", c);
+		return 0;
+	}
+
+	kdb_printf("\r%s %s to enter the debugger> %*s",
+		   kgdb_nmi_knock ? "Type" : "Hit",
+		   kgdb_nmi_knock ? magic  : "<return>", m, "");
+	while (m--)
+		kdb_printf("\b");
+	return 0;
+}
+
+/**
+ * kgdb_nmi_poll_knock - Check if it is time to enter the debugger
+ *
+ * "Serial ports are often noisy, especially when muxed over another port (we
+ * often use serial over the headset connector). Noise on the async command
+ * line just causes characters that are ignored, on a command line that blocked
+ * execution noise would be catastrophic." -- Colin Cross
+ *
+ * So, this function implements KGDB/KDB knocking on the serial line: we won't
+ * enter the debugger until we receive a known magic phrase (which is actually
+ * "$3#33", known as "escape to KDB" command. There is also a relaxed variant
+ * of knocking, i.e. just pressing the return key is enough to enter the
+ * debugger. And if knocking is disabled, the function always returns 1.
+ */
+bool kgdb_nmi_poll_knock(void)
+{
+	if (kgdb_nmi_knock < 0)
+		return 1;
+
+	dbg_io_ops->clear_irqs();
+
+	while (1) {
+		int ret;
+
+		ret = kgdb_nmi_poll_one_knock();
+		if (ret == NO_POLL_CHAR)
+			return 0;
+		else if (ret == 1)
+			break;
+	}
+	return 1;
+}
+
+static void kgdb_nmi_tty_receiver(unsigned long data)
+{
+	struct kgdb_nmi_tty_priv *priv = (void *)data;
+	char ch;
+
+	tasklet_schedule(&priv->tlet);
+
+	if (likely(!kgdb_nmi_tty_enabled || !kfifo_len(&priv->fifo)))
+		return;
+
+	while (kfifo_out(&priv->fifo, &ch, 1))
+		tty_insert_flip_char(priv->tty, ch, TTY_NORMAL);
+	tty_flip_buffer_push(priv->tty);
+}
+
+static DEFINE_MUTEX(kgdb_nmi_tty_mutex);
+
+static int kgdb_nmi_tty_open(struct tty_struct *tty, struct file *file)
+{
+	struct kgdb_nmi_tty_priv *priv;
+	int ret = 0;
+
+	mutex_lock(&kgdb_nmi_tty_mutex);
+
+	priv = tty->driver_data;
+	if (priv)
+		goto out;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	kgdb_nmi_tty = tty;
+	priv->tty = tty;
+	INIT_KFIFO(priv->fifo);
+	tty->driver_data = priv;
+
+	/*
+	 * The tasklet is cheap, it does not cause wakeups when reschedules
+	 * itself, instead it waits for the next tick.
+	 */
+	tasklet_init(&priv->tlet, kgdb_nmi_tty_receiver, (unsigned long)priv);
+	tasklet_schedule(&priv->tlet);
+out:
+	priv->opened++;
+err:
+	mutex_unlock(&kgdb_nmi_tty_mutex);
+	return ret;
+}
+
+static void kgdb_nmi_tty_close(struct tty_struct *tty, struct file *file)
+{
+	struct kgdb_nmi_tty_priv *priv;
+
+	mutex_lock(&kgdb_nmi_tty_mutex);
+
+	priv = tty->driver_data;
+	if (--priv->opened)
+		goto out;
+
+	tasklet_kill(&priv->tlet);
+	kgdb_nmi_tty = NULL;
+	kfree(priv);
+out:
+	mutex_unlock(&kgdb_nmi_tty_mutex);
+}
+
+static int kgdb_nmi_tty_write_room(struct tty_struct *tty)
+{
+	/* Actually, we can handle any amount as we use polled writes. */
+	return 2048;
+}
+
+static int kgdb_nmi_tty_write(struct tty_struct *tty, const unchar *buf, int c)
+{
+	int i;
+
+	for (i = 0; i < c; i++)
+		dbg_io_ops->write_char(buf[i]);
+	return c;
+}
+
+static const struct tty_operations kgdb_nmi_tty_ops = {
+	.open		= kgdb_nmi_tty_open,
+	.close		= kgdb_nmi_tty_close,
+	.write_room	= kgdb_nmi_tty_write_room,
+	.write		= kgdb_nmi_tty_write,
+};
+
+static int kgdb_nmi_enable_console(int argc, const char *argv[])
+{
+	kgdb_nmi_tty_enabled = !(argc == 1 && !strcmp(argv[1], "off"));
+	return 0;
+}
+
+int kgdb_register_nmi_console(void)
+{
+	int ret;
+
+	kgdb_nmi_tty_driver = alloc_tty_driver(1);
+	if (!kgdb_nmi_tty_driver) {
+		pr_err("%s: cannot allocate tty\n", __func__);
+		return -ENOMEM;
+	}
+	kgdb_nmi_tty_driver->driver_name	= "ttyNMI";
+	kgdb_nmi_tty_driver->name		= "ttyNMI";
+	kgdb_nmi_tty_driver->type		= TTY_DRIVER_TYPE_SERIAL;
+	kgdb_nmi_tty_driver->subtype		= SERIAL_TYPE_NORMAL;
+	kgdb_nmi_tty_driver->flags		= TTY_DRIVER_REAL_RAW |
+						  TTY_DRIVER_DYNAMIC_DEV;
+	kgdb_nmi_tty_driver->init_termios	= tty_std_termios;
+	tty_termios_encode_baud_rate(&kgdb_nmi_tty_driver->init_termios,
+				     KGDB_NMI_BAUD, KGDB_NMI_BAUD);
+	tty_set_operations(kgdb_nmi_tty_driver, &kgdb_nmi_tty_ops);
+
+	ret = tty_register_driver(kgdb_nmi_tty_driver);
+	if (ret) {
+		pr_err("%s: unable to register tty: %d\n", __func__, ret);
+		goto err_tty_reg;
+	}
+
+	ret = kdb_register("nmi_console", kgdb_nmi_enable_console, "[off]",
+			   "switch to Linux NMI console", 0);
+	if (ret) {
+		pr_err("%s: unable to register kdb command: %d\n",
+		       __func__, ret);
+		goto err_kdb_reg;
+	}
+
+	register_console(&kgdb_nmi_console);
+	kgdb_enable_nmi(1);
+
+	return 0;
+err_kdb_reg:
+	tty_unregister_driver(kgdb_nmi_tty_driver);
+err_tty_reg:
+	put_tty_driver(kgdb_nmi_tty_driver);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kgdb_register_nmi_console);
+
+int kgdb_unregister_nmi_console(void)
+{
+	int ret;
+
+	kgdb_enable_nmi(0);
+
+	ret = tty_unregister_driver(kgdb_nmi_tty_driver);
+	if (ret)
+		return ret;
+	put_tty_driver(kgdb_nmi_tty_driver);
+
+	ret = unregister_console(&kgdb_nmi_console);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kgdb_unregister_nmi_console);
diff --git a/drivers/tty/serial/kgdboc.c b/drivers/tty/serial/kgdboc.c
index 0aa08c8..bb69803 100644
--- a/drivers/tty/serial/kgdboc.c
+++ b/drivers/tty/serial/kgdboc.c
@@ -145,6 +145,8 @@ __setup("kgdboc=", kgdboc_option_setup);
 
 static void cleanup_kgdboc(void)
 {
+	if (kgdb_unregister_nmi_console())
+		return;
 	kgdboc_unregister_kbd();
 	if (configured == 1)
 		kgdb_unregister_io_module(&kgdboc_io_ops);
@@ -198,6 +200,10 @@ do_register:
 	if (err)
 		goto noconfig;
 
+	err = kgdb_register_nmi_console();
+	if (err)
+		goto noconfig;
+
 	configured = 1;
 
 	return 0;
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 1fd1cf0..fb7c55c 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -245,6 +245,16 @@ extern void kgdb_arch_enable_nmi(bool on);
  */
 extern int kgdb_enable_nmi(bool on);
 
+#ifdef CONFIG_SERIAL_KGDB_NMI
+extern int kgdb_register_nmi_console(void);
+extern int kgdb_unregister_nmi_console(void);
+extern bool kgdb_nmi_poll_knock(void);
+#else
+static inline int kgdb_register_nmi_console(void) { return 0; }
+static inline int kgdb_unregister_nmi_console(void) { return 0; }
+static inline bool kgdb_nmi_poll_knock(void) { return 1; }
+#endif
+
 /**
  * struct kgdb_arch - Describe architecture specific values.
  * @gdb_bpt_instr: The instruction to trigger a breakpoint.
-- 
1.7.11.5

