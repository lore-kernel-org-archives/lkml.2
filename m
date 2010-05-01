Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0EAWXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 18:23:40 -0400
Received: from t21.t-2.net ([84.255.209.100]:35377 "EHLO t21.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab0EAWXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 18:23:38 -0400
Subject: Re: [PATCH] console logging detour via printk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100430154522.489df8bc.rdunlap@xenotime.net>
References: <1272664980.10241.77.camel@itpsd6lap>
	 <20100430154522.489df8bc.rdunlap@xenotime.net>
Content-Type: text/plain
Date: Sun, 02 May 2010 00:23:33 +0200
Message-Id: <1272752613.2147.240.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SGG-UMAMSID: 20100501222336Z19027t21.t-2.net 1O8L60-0004wt-JR
X-SGG-RESULT: 20100501222336Z19027t21.t-2.net C1:OK E1:OK MX1:OK BL:OK SPF:off  CT:Unknown CM: SIP:84.255.254.67 SMF:samo_pogacnik@t-2.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 30.04.2010 (pet) ob 15:45 -0700 je Randy Dunlap zapisal(a):
> On Sat, 01 May 2010 00:03:00 +0200 Samo Pogacnik wrote:
> 
> > Hi,
> 
> > diff --git a_linux-2.6.33.3/drivers/char/Kconfig b_linux-2.6.33.3/drivers/char/Kconfig
> > index e023682..b5d0909 100644
> > --- a_linux-2.6.33.3/drivers/char/Kconfig
> > +++ b_linux-2.6.33.3/drivers/char/Kconfig
> > @@ -66,6 +66,23 @@ config VT_CONSOLE
> >  
> >  	  If unsure, say Y.
> >  
> > +config VT_CONSOLE_DETOUR
> > +	bool "Support for VT console detour via printk"
> > +	depends on VT_CONSOLE
> > +	default n
> > +	---help---
> > +	  If you do say Y here, the support for writing console messages via
> 
> 	  If you say Y here,
> 
> > +	  printk is included into VT console code.
> > +
> > +	  The feature is usefull to catch all console log. In order to use this
> 
> 	                 useful                       log messages.
> 
> > +	  feature, you should specify kernel command line option "detour" or write a
> > +	  positive number into /proc/sys/kernel/console_detour. You can disable
> > +	  the feature on-line by writing zero into the proc file. By writing a
> > +	  negative value into the proc file, the feature is disabled permanently
> > +	  (until next boot).
> > +
> > +	  If unsure, say N.
> > +
> >  config HW_CONSOLE
> >  	bool
> >  	depends on VT && !S390 && !UML
> 
> > diff --git a_linux-2.6.33.3/drivers/serial/Kconfig b_linux-2.6.33.3/drivers/serial/Kconfig
> > index 9ff47db..20acfab 100644
> > --- a_linux-2.6.33.3/drivers/serial/Kconfig
> > +++ b_linux-2.6.33.3/drivers/serial/Kconfig
> > @@ -1031,6 +1031,23 @@ config SERIAL_CORE
> >  config SERIAL_CORE_CONSOLE
> >  	bool
> >  
> > +config SERIAL_CORE_CONSOLE_DETOUR
> > +	bool "Support for serial console detour via printk"
> > +	depends on SERIAL_CORE_CONSOLE
> > +	default n
> > +	---help---
> > +	  If you do say Y here, the support for writing console messages via
> 
> 	  If you say Y here,
> 
> > +	  printk is included into serial console code. 
> > +
> > +	  The feature is usefull to catch all console log. In order to use this
> 
> 	                 useful                       log messages.
> 
> > +	  feature, you should specify kernel command line option "detour" or write a
> > +	  positive number into /proc/sys/kernel/console_detour. You can disable
> > +	  the feature on-line by writing zero into the proc file. By writing a
> > +	  negative value into the proc file, the feature is disabled permanently
> > +	  (until next boot).
> > +
> > +	  If unsure, say N.
> > +
> 
> The kernel command line option needs to be added to Documentation/kernel-parameters.txt
> also, please.
> 
> >  config CONSOLE_POLL
> >  	bool
> >  
> > diff --git a_linux-2.6.33.3/include/linux/console.h b_linux-2.6.33.3/include/linux/console.h
> > index dcca533..bc88030 100644
> > --- a_linux-2.6.33.3/include/linux/console.h
> > +++ b_linux-2.6.33.3/include/linux/console.h
> > @@ -108,6 +108,12 @@ struct console {
> >  	struct	 console *next;
> >  };
> >  
> > +extern int console_detour;
> > +extern void console_printk_detour(const unsigned char *, int);
> 
> Please include parameter names in function prototype(s).
> 
> > +
> > +struct ctl_table;
> > +int detour_sysctl_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
> 
> ditto
> 
> > +
> >  extern int console_set_on_cmdline;
> >  
> >  extern int add_preferred_console(char *name, int idx, char *options);
> 
> 
> Looks interesting/useful to me.  Thanks.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

Hi, 

Here is the updated patch providing your hints and generalized for any
console type.

regards, Samo

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
index 1751c45..953c6ea 100644
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
+int console_detour;
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
+		printk(KERN_INFO "%s", tmp);
+	} while (count > 0);
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


