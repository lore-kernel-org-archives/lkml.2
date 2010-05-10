Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0EJRCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:02:09 -0400
Received: from t23.t-2.net ([84.255.209.102]:47311 "EHLO t23.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab0EJRCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:02:05 -0400
Subject: [PATCH] tagged console logging detour via printk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: linux-embedded <linux-embedded@vger.kernel.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 May 2010 19:02:00 +0200
Message-Id: <1273510920.6998.76.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SGG-UMAMSID: 20100510170201Z16633t23.t-2.net 1OBWMj-0004KH-UB
X-SGG-RESULT: 20100510170201Z16633t23.t-2.net C1:OK E1:OK MX1:OK BL:OK SPF:off  CT:Unknown CM: SIP:84.255.254.67 SMF:samo_pogacnik@t-2.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This version of console detour patch provides tagging of console
messages, when sent to printk. This may result in logs like this:
...
May  6 22:41:27 lap1 kernel: [    1.092979] Freeing unused kernel memory: 548k freed
May  6 22:41:27 lap1 kernel: [    1.094503] Write protecting the kernel text: 3564k
May  6 22:41:27 lap1 kernel: [    1.094739] Write protecting the kernel read-only data: 1736k
May  6 22:41:27 lap1 kernel: [C][    1.099902] Mounting proc filesystem
May  6 22:41:27 lap1 kernel: [C][    1.100165] Mounting sysfs filesystem
May  6 22:41:27 lap1 kernel: [C][    1.100440] Creating /dev
May  6 22:41:27 lap1 kernel: [C][    1.101835] Creating initial device nodes
...
...
May  6 22:41:27 lap1 kernel: [C][   25.313917] Bringing up interface eth0:  \
May  6 22:41:27 lap1 kernel: [   25.433672] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
May  6 22:41:27 lap1 kernel: [C][   30.863244] ESC[60G\
May  6 22:41:27 lap1 kernel: [C][   30.863319] [\
May  6 22:41:27 lap1 kernel: [C][   30.863443] ESC[0;32m\
May  6 22:41:27 lap1 kernel: [C][   30.863499]   OK  \
May  6 22:41:27 lap1 kernel: [C][   30.863617] ESC[0;39m\
May  6 22:41:27 lap1 kernel: [C][   30.863663] ]\
May  6 22:41:27 lap1 kernel: [C][   30.863710] ^
...
May  6 22:41:27 lap1 kernel: [C][   31.327576] Starting system logger: \
...

It would have been possible for the system logger to use the console tag
and replace the "kernel" with e.g. "console" word for console messages.
The other thing the system logger could do is to fix its time stamps for
messages generated before logger start-up based on printk time stamp
(see the last message in the example log)...

regards, 
Samo

p.s.
I'll provide also an independent detour tty driver as Alan suggested.

---
Signed-off-by: Samo Pogacnik <samo_pogacnik@t-2.net>
diff --git a_linux-2.6.33.3/Documentation/kernel-parameters.txt b_linux-2.6.33.3/Documentation/kernel-parameters.txt
index e2c7487..ab0072c 100644
--- a_linux-2.6.33.3/Documentation/kernel-parameters.txt
+++ b_linux-2.6.33.3/Documentation/kernel-parameters.txt
@@ -628,6 +628,8 @@ and is between 256 and 4096 characters. It is defined in the file
 			Defaults to the default architecture's huge page size
 			if not specified.
 
+	detour		[KNL] Enable console logging detour via printk.
+
 	dhash_entries=	[KNL]
 			Set number of hash buckets for dentry cache.
 
diff --git a_linux-2.6.33.3/drivers/char/Kconfig b_linux-2.6.33.3/drivers/char/Kconfig
index e023682..43c552e 100644
--- a_linux-2.6.33.3/drivers/char/Kconfig
+++ b_linux-2.6.33.3/drivers/char/Kconfig
@@ -88,6 +88,22 @@ config VT_HW_CONSOLE_BINDING
 	 information. For framebuffer console users, please refer to
 	 <file:Documentation/fb/fbcon.txt>.
 
+config CONSOLE_DETOUR
+	bool "Support for console detour via printk"
+	default n
+	---help---
+	  If you say Y here, the support for writing console messages via
+	  printk is included into the console code.
+
+	  The feature is useful to catch all console log messages.
+	  In order to use this feature, you should specify kernel command line
+	  option "detour" or write a positive number into
+	  /proc/sys/kernel/console_detour. You can disable the feature on-line
+	  by writing zero into the proc file. By writing a negative value into
+	  the proc file, the feature is disabled permanently (until next boot).
+
+	  If unsure, say N.
+
 config DEVKMEM
 	bool "/dev/kmem virtual device support"
 	default y
diff --git a_linux-2.6.33.3/drivers/char/tty_io.c b_linux-2.6.33.3/drivers/char/tty_io.c
index 76253cf..f77de34 100644
--- a_linux-2.6.33.3/drivers/char/tty_io.c
+++ b_linux-2.6.33.3/drivers/char/tty_io.c
@@ -1087,6 +1087,13 @@ ssize_t redirected_tty_write(struct file *file, const char __user *buf,
 	}
 	spin_unlock(&redirect_lock);
 
+#ifdef CONFIG_CONSOLE_DETOUR
+	if (console_detour) {
+		console_printk_detour(buf, count);
+		if (!p)
+			return count;
+	}
+#endif
 	if (p) {
 		ssize_t res;
 		res = vfs_write(p, buf, count, &p->f_pos);
diff --git a_linux-2.6.33.3/include/linux/console.h b_linux-2.6.33.3/include/linux/console.h
index dcca533..354a7a8 100644
--- a_linux-2.6.33.3/include/linux/console.h
+++ b_linux-2.6.33.3/include/linux/console.h
@@ -108,6 +108,13 @@ struct console {
 	struct	 console *next;
 };
 
+extern int console_detour;
+extern void console_printk_detour(const unsigned char *buf, int count);
+
+struct ctl_table;
+int detour_sysctl_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *length, loff_t *ppos);
+
 extern int console_set_on_cmdline;
 
 extern int add_preferred_console(char *name, int idx, char *options);
diff --git a_linux-2.6.33.3/init/main.c b_linux-2.6.33.3/init/main.c
index 512ba15..add9e95 100644
--- a_linux-2.6.33.3/init/main.c
+++ b_linux-2.6.33.3/init/main.c
@@ -25,6 +25,7 @@
 #include <linux/bootmem.h>
 #include <linux/acpi.h>
 #include <linux/tty.h>
+#include <linux/console.h>
 #include <linux/gfp.h>
 #include <linux/percpu.h>
 #include <linux/kmod.h>
@@ -249,6 +250,14 @@ static int __init loglevel(char *str)
 
 early_param("loglevel", loglevel);
 
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
index 1751c45..9897ecb 100644
--- a_linux-2.6.33.3/kernel/printk.c
+++ b_linux-2.6.33.3/kernel/printk.c
@@ -655,6 +655,8 @@ static int recursion_bug;
 static int new_text_line = 1;
 static char printk_buf[1024];
 
+static const char *detour_tag = "[C]";
+
 int printk_delay_msec __read_mostly;
 
 static inline void printk_delay(void)
@@ -753,6 +755,15 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 			printed_len += 3;
 			new_text_line = 0;
 
+			if ((p[0] == detour_tag[0]) &&
+			    (p[1] == detour_tag[1]) &&
+			    (p[2] == detour_tag[2])) {
+				int i;
+
+				for (i = 0; i < 3; i++, p++)
+					emit_log_char(*p);
+			}
+
 			if (printk_time) {
 				/* Follow the token with the time */
 				char tbuf[50], *tp;
@@ -1368,6 +1379,80 @@ static int __init disable_boot_consoles(void)
 }
 late_initcall(disable_boot_consoles);
 
+/*
+ * This option can be enabled with kernel command line option "detour" or
+ * through a proc file (/proc/sys/kernel/console_detour). It enables console
+ * logging through printk, if supported by enabled console.
+ */
+int console_detour;
+EXPORT_SYMBOL(console_detour);
+
+#define DETOUR_STR_SIZE 508
+void console_printk_detour(const unsigned char *buf, int count)
+{
+	static char tmp[DETOUR_STR_SIZE + 4];
+	static int curr;
+	int i;
+
+	for (i = 0; i < count; i++) {
+		tmp[curr] = buf[i];
+		if (curr < DETOUR_STR_SIZE) {
+			switch (buf[i]) {
+			case '\r':
+				tmp[curr] = '^';
+				tmp[curr + 1] = '\n';
+				tmp[curr + 2] = '\0';
+				printk(KERN_INFO "%s%s", detour_tag, tmp);
+				curr = 0;
+				if (buf[i + 1] == '\n')
+					i++;
+				break;
+			case '\n':
+				tmp[curr + 1] = '\0';
+				printk(KERN_INFO "%s%s", detour_tag, tmp);
+				curr = 0;
+				break;
+			default:
+				curr++;
+			}
+		} else {
+			/* end of tmp buffer reached: cut the message in two */
+			tmp[curr + 1] = '\\';
+			tmp[curr + 2] = '\n';
+			tmp[curr + 3] = '\0';
+			printk(KERN_INFO "%s%s", detour_tag, tmp);
+			curr = 0;
+		}
+	}
+	if (curr > 0) {
+		/* not nl or cr terminated message */
+		tmp[curr + 0] = '\\';
+		tmp[curr + 1] = '\n';
+		tmp[curr + 2] = '\0';
+		printk(KERN_INFO "%s%s", detour_tag, tmp);
+		curr = 0;
+	}
+}
+EXPORT_SYMBOL(console_printk_detour);
+
+int detour_sysctl_handler(struct ctl_table *table, int write,
+	void __user *buffer, size_t *length, loff_t *ppos)
+{
+	static int disable_forever;
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



