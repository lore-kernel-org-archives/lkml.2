Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1BRKlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:41:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:50729 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab1BRKk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:40:58 -0500
Date: Fri, 18 Feb 2011 10:40:30 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, jbeulich@novell.com, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, jbeulich@novell.com, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <4D5D521C0200007800032702@vpn.id2.novell.com>
References: <4D5D521C0200007800032702@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Remove die_nmi()
Message-ID: <tip-02ca752e4181e219e243cd61a60dd1da47251f11@git.kernel.org>
Git-Commit-ID: 02ca752e4181e219e243cd61a60dd1da47251f11
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 10:40:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02ca752e4181e219e243cd61a60dd1da47251f11
Gitweb:     http://git.kernel.org/tip/02ca752e4181e219e243cd61a60dd1da47251f11
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 17 Feb 2011 15:51:40 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Feb 2011 08:54:05 +0100

x86: Remove die_nmi()

With no caller left, the function and the DIE_NMIWATCHDOG
enumerator can both go away.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Don Zickus <dzickus@redhat.com>
LKML-Reference: <4D5D521C0200007800032702@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/kdebug.h |    1 -
 arch/x86/include/asm/nmi.h    |    1 -
 arch/x86/kernel/dumpstack.c   |   25 -------------------------
 arch/x86/kernel/kgdb.c        |    9 ---------
 4 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index ca242d3..518bbbb 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -13,7 +13,6 @@ enum die_val {
 	DIE_PANIC,
 	DIE_NMI,
 	DIE_DIE,
-	DIE_NMIWATCHDOG,
 	DIE_KERNELDEBUG,
 	DIE_TRAP,
 	DIE_GPF,
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c76f5b9..07f4601 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -7,7 +7,6 @@
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
-extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
 extern void release_perfctr_nmi(unsigned int);
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index df20723..220a1c1 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -320,31 +320,6 @@ void die(const char *str, struct pt_regs *regs, long err)
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
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index a413000..7c64c42 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -533,15 +533,6 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
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
