Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811Ab0D3WVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 18:21:41 -0400
Received: from t21.t-2.net ([84.255.209.100]:50287 "EHLO t21.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759779Ab0D3WVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 18:21:39 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Apr 2010 18:21:38 EDT
Subject: [PATCH] console logging detour via printk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: linux-embedded <linux-embedded@vger.kernel.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 01 May 2010 00:03:00 +0200
Message-Id: <1272664980.10241.77.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SGG-UMAMSID: 20100430220301Z6684t22.t-2.net 1O7yIX-0001jo-ON
X-SGG-RESULT: 20100430220301Z6684t22.t-2.net C1:OK E1:OK MX1:OK BL:OK SPF:off  CT:Unknown CM: SIP:84.255.254.67 SMF:samo_pogacnik@t-2.net
X-SGG-BadGoodRouted: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while i was searching for effective logging of complete console output
produced by the kernel and user phase of the boot process, it turned out
that only kernel messages imho get systematically cached and stored into
log files (if needed). All userspace processes are on their own to use
syslog, which is fine, but there are also many console messages
reporting the boot status via init scripts, .... I came across the
bootlogd daemo, which handles the job of redirecting console output into
a log file, but i find it problematic to use especialy, when using
initial ram disk image.

So in short i came up with an idea to transform console writes into
printks at appropriate code place of some console drivers (the patch
includes code for VT console and SERIAL_CORE console drivers). Printks
eventually reach console device avoiding the patched part of the console
drivers.

I find this feature very interesting for embedded devices with limited
console abilities as well as for other for normal desktops using initial
ram disk images and / or some splash image to beautify booting. It is
always nice to have the possibility to review the complete boot output
at any time.

The more detail configuration of the feature is described in the Kconfig
files within the patch below.

The patch is also available here:
http://84.255.254.67/console_detour-2.6.33.3.patch

have fun, Samo

--
diff --git a_linux-2.6.33.3/drivers/char/Kconfig b_linux-2.6.33.3/drivers/char/Kconfig
index e023682..b5d0909 100644
--- a_linux-2.6.33.3/drivers/char/Kconfig
+++ b_linux-2.6.33.3/drivers/char/Kconfig
@@ -66,6 +66,23 @@ config VT_CONSOLE
 
 	  If unsure, say Y.
 
+config VT_CONSOLE_DETOUR
+	bool "Support for VT console detour via printk"
+	depends on VT_CONSOLE
+	default n
+	---help---
+	  If you do say Y here, the support for writing console messages via
+	  printk is included into VT console code.
+
+	  The feature is usefull to catch all console log. In order to use this
+	  feature, you should specify kernel command line option "detour" or write a
+	  positive number into /proc/sys/kernel/console_detour. You can disable
+	  the feature on-line by writing zero into the proc file. By writing a
+	  negative value into the proc file, the feature is disabled permanently
+	  (until next boot).
+
+	  If unsure, say N.
+
 config HW_CONSOLE
 	bool
 	depends on VT && !S390 && !UML
diff --git a_linux-2.6.33.3/drivers/char/vt.c b_linux-2.6.33.3/drivers/char/vt.c
index 50faa1f..ba649db 100644
--- a_linux-2.6.33.3/drivers/char/vt.c
+++ b_linux-2.6.33.3/drivers/char/vt.c
@@ -2696,6 +2696,16 @@ static int con_write(struct tty_struct *tty, const unsigned char *buf, int count
 {
 	int	retval;
 
+#ifdef CONFIG_VT_CONSOLE_DETOUR
+	if (console_detour) {
+		int idx = vt_console_driver.index - 1;
+ 
+		if ((idx >= 0) && (idx == tty->index)) {
+			console_printk_detour(buf, count);
+			return count;
+		}
+	}
+#endif
 	retval = do_con_write(tty, buf, count);
 	con_flush_chars(tty);
 
diff --git a_linux-2.6.33.3/drivers/serial/Kconfig b_linux-2.6.33.3/drivers/serial/Kconfig
index 9ff47db..20acfab 100644
--- a_linux-2.6.33.3/drivers/serial/Kconfig
+++ b_linux-2.6.33.3/drivers/serial/Kconfig
@@ -1031,6 +1031,23 @@ config SERIAL_CORE
 config SERIAL_CORE_CONSOLE
 	bool
 
+config SERIAL_CORE_CONSOLE_DETOUR
+	bool "Support for serial console detour via printk"
+	depends on SERIAL_CORE_CONSOLE
+	default n
+	---help---
+	  If you do say Y here, the support for writing console messages via
+	  printk is included into serial console code. 
+
+	  The feature is usefull to catch all console log. In order to use this
+	  feature, you should specify kernel command line option "detour" or write a
+	  positive number into /proc/sys/kernel/console_detour. You can disable
+	  the feature on-line by writing zero into the proc file. By writing a
+	  negative value into the proc file, the feature is disabled permanently
+	  (until next boot).
+
+	  If unsure, say N.
+
 config CONSOLE_POLL
 	bool
 
diff --git a_linux-2.6.33.3/drivers/serial/serial_core.c b_linux-2.6.33.3/drivers/serial/serial_core.c
index 7f28307..5e7e762 100644
--- a_linux-2.6.33.3/drivers/serial/serial_core.c
+++ b_linux-2.6.33.3/drivers/serial/serial_core.c
@@ -513,6 +513,12 @@ uart_write(struct tty_struct *tty, const unsigned char *buf, int count)
 	}
 
 	port = state->uart_port;
+#ifdef CONFIG_SERIAL_CORE_CONSOLE_DETOUR
+	if (console_detour && uart_console(port) && (port->cons->flags & CON_ENABLED)) {
+		console_printk_detour(buf, count);
+		return count;
+	}
+#endif
 	circ = &state->xmit;
 
 	if (!circ->buf)
diff --git a_linux-2.6.33.3/include/linux/console.h b_linux-2.6.33.3/include/linux/console.h
index dcca533..bc88030 100644
--- a_linux-2.6.33.3/include/linux/console.h
+++ b_linux-2.6.33.3/include/linux/console.h
@@ -108,6 +108,12 @@ struct console {
 	struct	 console *next;
 };
 
+extern int console_detour;
+extern void console_printk_detour(const unsigned char *, int);
+
+struct ctl_table;
+int detour_sysctl_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
+
 extern int console_set_on_cmdline;
 
 extern int add_preferred_console(char *name, int idx, char *options);
diff --git a_linux-2.6.33.3/init/main.c b_linux-2.6.33.3/init/main.c
index 512ba15..5b1ba11 100644
--- a_linux-2.6.33.3/init/main.c
+++ b_linux-2.6.33.3/init/main.c
@@ -249,6 +249,15 @@ static int __init loglevel(char *str)
 
 early_param("loglevel", loglevel);
 
+extern int console_detour;
+static int __init detour(char *str)
+{
+	console_detour = 1;
+	return 0;
+}
+
+early_param("detour", detour);
+
 /*
  * Unknown boot options get handed to init, unless they look like
  * unused parameters (modprobe will find them in /proc/cmdline).
diff --git a_linux-2.6.33.3/kernel/printk.c b_linux-2.6.33.3/kernel/printk.c
index 1751c45..5a8056b 100644
--- a_linux-2.6.33.3/kernel/printk.c
+++ b_linux-2.6.33.3/kernel/printk.c
@@ -1368,6 +1368,51 @@ static int __init disable_boot_consoles(void)
 }
 late_initcall(disable_boot_consoles);
 
+/*
+ * This option can be enabled with kernel command line option "detour" or 
+ * through a proc file (/proc/sys/kernel/console_detour). It enables console 
+ * logging through printk, if supported by enabled console.
+ */
+int console_detour = 0;
+EXPORT_SYMBOL(console_detour);
+
+#define DETOUR_STR_SIZE 512
+void console_printk_detour(const unsigned char *buf, int count)
+{
+	char tmp[DETOUR_STR_SIZE + 1];
+
+	do {
+		if (count > DETOUR_STR_SIZE) {
+			memcpy(tmp, buf, DETOUR_STR_SIZE);
+			tmp[DETOUR_STR_SIZE] = '\0';
+		} else {
+			memcpy(tmp, buf, count);
+			tmp[count] = '\0';
+		}
+		count -= DETOUR_STR_SIZE;
+		printk("%s", tmp);
+	} while (count > 0);
+}
+EXPORT_SYMBOL(console_printk_detour);
+
+int detour_sysctl_handler(struct ctl_table *table, int write,
+	void __user *buffer, size_t *length, loff_t *ppos)
+{
+	static int disable_forever = 0;
+
+	proc_dointvec(table, write, buffer, length, ppos);
+	if (write) {
+		if ((console_detour < 0) || (disable_forever != 0)) {
+			disable_forever = 1;
+			console_detour = 0;
+			return 0;
+		}
+		if (console_detour > 1)
+			console_detour = 1;
+	}
+	return 0;
+}
+
 #if defined CONFIG_PRINTK
 
 /*
diff --git a_linux-2.6.33.3/kernel/sysctl.c b_linux-2.6.33.3/kernel/sysctl.c
index 8a68b24..ab644cb 100644
--- a_linux-2.6.33.3/kernel/sysctl.c
+++ b_linux-2.6.33.3/kernel/sysctl.c
@@ -50,6 +50,7 @@
 #include <linux/ftrace.h>
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
+#include <linux/console.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -936,6 +937,13 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+	{
+		.procname	= "console_detour",
+		.data		= &console_detour,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &detour_sysctl_handler,
+	},
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
 

