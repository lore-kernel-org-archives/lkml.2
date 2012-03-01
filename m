Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937Ab2CAIzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:55:02 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58474 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab2CAIzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:55:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of andrey.warkentin@gmail.com designates 10.52.36.2 as permitted sender) smtp.mail=andrey.warkentin@gmail.com; dkim=pass header.i=andrey.warkentin@gmail.com
From: Andrei Warkentin <andrey.warkentin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, jason.wessel@windriver.com,
        Andrei Warkentin <andrey.warkentin@gmail.com>
Subject: [PATCH] x86 NMI: Be smarter about invoking panic() inside NMI handler.
Date: Thu,  1 Mar 2012 02:54:43 -0500
Message-Id: <1330588483-30957-1-git-send-email-andrey.warkentin@gmail.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If two (or more) unknown NMIs arrive on different CPUs, there
is a large chance both CPUs will wind up inside panic(). This
is fine, unless you want to enter KDB - KDB cannot round up
all CPUs, because some of them are stuck inside
panic_smp_self_stop with NMI latched. This is
easy to replicate with QEMU. Boot with -smp 4 and
send NMI using the monitor.

Solution for this - attempt to enter panic() from NMI
handler. If panic() is already active in the system,
just exit out of the NMI handler. This lets KDB round
up CPUs.

Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
---
 arch/x86/kernel/nmi.c  |    6 ++--
 include/linux/kernel.h |    1 +
 kernel/panic.c         |   82 +++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 67 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..9e6a69a 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -227,7 +227,7 @@ pci_serr_error(unsigned char reason, struct pt_regs *regs)
 #endif
 
 	if (panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
+		try_panic("NMI: Not continuing");
 
 	pr_emerg("Dazed and confused, but trying to continue\n");
 
@@ -247,7 +247,7 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	show_registers(regs);
 
 	if (panic_on_io_nmi)
-		panic("NMI IOCK error: Not continuing");
+		try_panic("NMI IOCK error: Not continuing");
 
 	/* Re-enable the IOCK line, wait for a few seconds */
 	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
@@ -297,7 +297,7 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 
 	pr_emerg("Do you have a strange power saving mode enabled?\n");
 	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
+		try_panic("NMI: Not continuing");
 
 	pr_emerg("Dazed and confused, but trying to continue\n");
 }
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 01ab0aa..82983f9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -188,6 +188,7 @@ extern long (*panic_blink)(int state);
 __printf(1, 2)
 void panic(const char *fmt, ...)
 	__noreturn __cold;
+void try_panic(const char *fmt, ...) __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
diff --git a/kernel/panic.c b/kernel/panic.c
index 80aed44..9c88b49 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -58,40 +58,26 @@ void __weak panic_smp_self_stop(void)
 		cpu_relax();
 }
 
+static DEFINE_SPINLOCK(panic_lock);
+
 /**
- *	panic - halt the system
+ *	__panic - halt the system
  *	@fmt: The text string to print
+ *	@args: va_list associated with fmt
  *
  *	Display a message, then perform cleanups.
  *
  *	This function never returns.
  */
-void panic(const char *fmt, ...)
+void __noreturn __cold __panic(const char *fmt, va_list args)
 {
-	static DEFINE_SPINLOCK(panic_lock);
 	static char buf[1024];
-	va_list args;
 	long i, i_next = 0;
 	int state = 0;
 
-	/*
-	 * It's possible to come here directly from a panic-assertion and
-	 * not have preempt disabled. Some functions called from here want
-	 * preempt to be disabled. No point enabling it later though...
-	 *
-	 * Only one CPU is allowed to execute the panic code from here. For
-	 * multiple parallel invocations of panic, all other CPUs either
-	 * stop themself or will wait until they are stopped by the 1st CPU
-	 * with smp_send_stop().
-	 */
-	if (!spin_trylock(&panic_lock))
-		panic_smp_self_stop();
-
 	console_verbose();
 	bust_spinlocks(1);
-	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
-	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	/*
@@ -175,8 +161,66 @@ void panic(const char *fmt, ...)
 	}
 }
 
+/**
+ *	panic - halt the system
+ *	@fmt: The text string to print
+ *
+ *	Display a message, then perform cleanups.
+ *
+ *	This function never returns.
+ */
+void panic(const char *fmt, ...)
+{
+	va_list args;
+
+	/*
+	 * It's possible to come here directly from a panic-assertion and
+	 * not have preempt disabled. Some functions called from here want
+	 * preempt to be disabled. No point enabling it later though...
+	 *
+	 * Only one CPU is allowed to execute the panic code from here. For
+	 * multiple parallel invocations of panic, all other CPUs either
+	 * stop themself or will wait until they are stopped by the 1st CPU
+	 * with smp_send_stop().
+	 */
+	if (!spin_trylock(&panic_lock))
+		panic_smp_self_stop();
+
+	va_start(args, fmt);
+	__panic(fmt, args);
+}
+
 EXPORT_SYMBOL(panic);
 
+/**
+ *	try_panic - halt the system, unless
+ *                  another panic is in progress
+ *	@fmt: The text string to print
+ *
+ *	Display a message, then perform cleanups.
+ *
+ *	This function retuns if panic_lock is already taken.
+ *      It is meant to be used in places which can be invoked
+ *      concurrently on several CPUs, but where its undesired
+ *      for the CPU to become wedged if it cannot take
+ *      the panic lock - for example, doing so inside an
+ *      NMI will prevent KDB from working if it's running
+ *      due to an unknown broadcast NMI (won't be able to
+ *      roundup using NMI, since the other CPU is spinning
+ *      inside panic_smp_self_stop with NMI latched).
+ */
+void try_panic(const char *fmt, ...)
+{
+	va_list args;
+
+	if (!spin_trylock(&panic_lock))
+		return;
+
+	va_start(args, fmt);
+	__panic(fmt, args);
+}
+
+EXPORT_SYMBOL(try_panic);
 
 struct tnt {
 	u8	bit;
-- 
1.7.9.2

