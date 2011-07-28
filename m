Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab1G1Rme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 13:42:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:57657 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab1G1Rmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:42:32 -0400
Message-ID: <4E319F7F.8040802@windriver.com>
Date: Thu, 28 Jul 2011 12:42:23 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt4
References: <alpine.LFD.2.02.1107272222420.2660@ionos>
In-Reply-To: <alpine.LFD.2.02.1107272222420.2660@ionos>
Content-Type: multipart/mixed;
	boundary="------------030809000503080208030808"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------030809000503080208030808
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 07/27/2011 04:37 PM, Thomas Gleixner wrote:
>  - KGDB (not yet disabled) is reportedly unusable on -rt right now due
>    to missing hacks in the console locking which I dropped on purpose.
>

To work around this in the short term you can use this patch, in addition to the clocksource watchdog patch that Thomas brewed up.

Comments are welcome of course.   Ultimately the right solution is to change separation between the console and the HW to have a polled mode + work queue so as not to introduce any kind of latency.

Thanks,
Jason.

--------------030809000503080208030808
Content-Type: text/x-diff; name="kgdboc_8250_lock_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="kgdboc_8250_lock_fix.patch"

Index: linux-2.6-kgdb/drivers/tty/serial/8250.c
===================================================================
--- linux-2.6-kgdb.orig/drivers/tty/serial/8250.c	2011-07-28 09:07:06.313204001 -0500
+++ linux-2.6-kgdb/drivers/tty/serial/8250.c	2011-07-28 09:21:43.363203854 -0500
@@ -38,6 +38,7 @@
 #include <linux/nmi.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/kdb.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -2894,10 +2895,14 @@
 
 	touch_nmi_watchdog();
 
-	if (up->port.sysrq || oops_in_progress)
-		locked = spin_trylock_irqsave(&up->port.lock, flags);
-	else
-		spin_lock_irqsave(&up->port.lock, flags);
+	if (unlikely(in_kdb_printk())) {
+		locked = 0;
+	} else {
+		if (up->port.sysrq || oops_in_progress)
+			locked = spin_trylock_irqsave(&up->port.lock, flags);
+		else
+			spin_lock_irqsave(&up->port.lock, flags);
+	}
 
 	/*
 	 *	First save the IER then disable the interrupts
Index: linux-2.6-kgdb/include/linux/kdb.h
===================================================================
--- linux-2.6-kgdb.orig/include/linux/kdb.h	2011-07-28 09:09:55.523204135 -0500
+++ linux-2.6-kgdb/include/linux/kdb.h	2011-07-28 09:12:21.183204000 -0500
@@ -153,12 +153,14 @@
 extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
 			       short, kdb_repeat_t);
 extern int kdb_unregister(char *);
+#define in_kdb_printk() (kdb_trap_printk)
 #else /* ! CONFIG_KGDB_KDB */
 #define kdb_printf(...)
 #define kdb_init(x)
 #define kdb_register(...)
 #define kdb_register_repeat(...)
 #define kdb_uregister(x)
+#define in_kdb_printk() (0)
 #endif	/* CONFIG_KGDB_KDB */
 enum {
 	KDB_NOT_INITIALIZED,
Index: linux-2.6-kgdb/kernel/debug/kdb/kdb_io.c
===================================================================
--- linux-2.6-kgdb.orig/kernel/debug/kdb/kdb_io.c	2011-07-28 09:05:40.963204003 -0500
+++ linux-2.6-kgdb/kernel/debug/kdb/kdb_io.c	2011-07-28 09:13:02.463204337 -0500
@@ -539,7 +539,6 @@
 	int diag;
 	int linecount;
 	int logging, saved_loglevel = 0;
-	int saved_trap_printk;
 	int got_printf_lock = 0;
 	int retlen = 0;
 	int fnd, len;
@@ -550,8 +549,6 @@
 	unsigned long uninitialized_var(flags);
 
 	preempt_disable();
-	saved_trap_printk = kdb_trap_printk;
-	kdb_trap_printk = 0;
 
 	/* Serialize kdb_printf if multiple cpus try to write at once.
 	 * But if any cpu goes recursive in kdb, just print the output,
@@ -807,7 +804,6 @@
 	} else {
 		__release(kdb_printf_lock);
 	}
-	kdb_trap_printk = saved_trap_printk;
 	preempt_enable();
 	return retlen;
 }
@@ -817,9 +813,11 @@
 	va_list ap;
 	int r;
 
+	kdb_trap_printk++;
 	va_start(ap, fmt);
 	r = vkdb_printf(fmt, ap);
 	va_end(ap);
+	kdb_trap_printk--;
 
 	return r;
 }

--------------030809000503080208030808--
