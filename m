Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab1BQPuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:50:52 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:56044 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1BQPuu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 17 Feb 2011 10:50:50 -0500
Message-Id: <4D5D521C0200007800032702@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 17 Feb 2011 15:51:40 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove die_nmi()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With no caller left, the function and the DIE_NMIWATCHDOG enumerator
can both go away.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/kdebug.h |    1 -
 arch/x86/include/asm/nmi.h    |    1 -
 arch/x86/kernel/dumpstack.c   |   25 -------------------------
 arch/x86/kernel/kgdb.c        |    9 ---------
 4 files changed, 36 deletions(-)

--- 2.6.38-rc5/arch/x86/include/asm/kdebug.h
+++ 2.6.38-rc5-x86-no-die_nmi/arch/x86/include/asm/kdebug.h
@@ -13,7 +13,6 @@ enum die_val {
 	DIE_PANIC,
 	DIE_NMI,
 	DIE_DIE,
-	DIE_NMIWATCHDOG,
 	DIE_KERNELDEBUG,
 	DIE_TRAP,
 	DIE_GPF,
--- 2.6.38-rc5/arch/x86/include/asm/nmi.h
+++ 2.6.38-rc5-x86-no-die_nmi/arch/x86/include/asm/nmi.h
@@ -7,7 +7,6 @@
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
-extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
 extern void release_perfctr_nmi(unsigned int);
--- 2.6.38-rc5/arch/x86/kernel/dumpstack.c
+++ 2.6.38-rc5-x86-no-die_nmi/arch/x86/kernel/dumpstack.c
@@ -320,31 +320,6 @@ void die(const char *str, struct pt_regs
 	oops_end(flags, regs, sig);
 }
 
-void notrace __kprobes
-die_nmi(char *str, struct pt_regs *regs, int do_panic)
-{
-	unsigned long flags;
-
-	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	/*
-	 * We are in trouble anyway, lets at least try
-	 * to get a message out.
-	 */
-	flags = oops_begin();
-	printk(KERN_EMERG "%s", str);
-	printk(" on CPU%d, ip %08lx, registers:\n",
-		smp_processor_id(), regs->ip);
-	show_registers(regs);
-	oops_end(flags, regs, 0);
-	if (do_panic || panic_on_oops)
-		panic("Non maskable interrupt");
-	nmi_exit();
-	local_irq_enable();
-	do_exit(SIGBUS);
-}
-
 static int __init oops_setup(char *s)
 {
 	if (!s)
--- 2.6.38-rc5/arch/x86/kernel/kgdb.c
+++ 2.6.38-rc5-x86-no-die_nmi/arch/x86/kernel/kgdb.c
@@ -533,15 +533,6 @@ static int __kgdb_notify(struct die_args
 		}
 		return NOTIFY_DONE;
 
-	case DIE_NMIWATCHDOG:
-		if (atomic_read(&kgdb_active) != -1) {
-			/* KGDB CPU roundup: */
-			kgdb_nmicallback(raw_smp_processor_id(), regs);
-			return NOTIFY_STOP;
-		}
-		/* Enter debugger: */
-		break;
-
 	case DIE_DEBUG:
 		if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
 			if (user_mode(regs))



