Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0FBJpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:45:52 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:5278 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab0FBJpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ivOHpA9UsBghGEhAK3JcFNIAhuNJStYXWjTiTmZHRozpIcypyE7o5fUniYGRBBvBu2
         w5mpnyErO15+exoa3kPa5FDxtDl+xYQKGTB060XSIXUwGrwCkRSWJ2TiDlILcDNWbnsM
         N0ywO8cNXimiSLGkvMbE5FiIS28hZ/e/o69qI=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 2/5] x86: Split __show_regs()
Date: Wed,  2 Jun 2010 09:39:16 +0200
Message-Id: <1275464359-1566-3-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__show_regs dumps content of pt_regs and does other things beside
it. This patch moves pt_regs dumping part into separate function:
__show_main_regs.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 arch/x86/include/asm/kdebug.h |    1 +
 arch/x86/kernel/process_32.c  |   22 ++++++++++++++--------
 arch/x86/kernel/process_64.c  |   20 ++++++++++++--------
 3 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index fa7c0b9..fd346c8 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -30,6 +30,7 @@ extern void show_registers(struct pt_regs *regs);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
 extern void __show_regs(struct pt_regs *regs, int all);
+extern void __show_main_regs(struct pt_regs *regs);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8d12878..e67cad7 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -119,10 +119,8 @@ void cpu_idle(void)
 	}
 }
 
-void __show_regs(struct pt_regs *regs, int all)
+void __show_main_regs(struct pt_regs *regs)
 {
-	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
-	unsigned long d0, d1, d2, d3, d6, d7;
 	unsigned long sp;
 	unsigned short ss, gs;
 
@@ -135,12 +133,9 @@ void __show_regs(struct pt_regs *regs, int all)
 		savesegment(ss, ss);
 		savesegment(gs, gs);
 	}
+	printk(KERN_DEFAULT "EIP: %04x:[<%08lx>] EFLAGS: %08lx\n",
+	       (u16)regs->cs, regs->ip, regs->flags);
 
-	show_regs_common();
-
-	printk(KERN_DEFAULT "EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
-			(u16)regs->cs, regs->ip, regs->flags,
-			smp_processor_id());
 	print_symbol("EIP is at %s\n", regs->ip);
 
 	printk(KERN_DEFAULT "EAX: %08lx EBX: %08lx ECX: %08lx EDX: %08lx\n",
@@ -149,6 +144,17 @@ void __show_regs(struct pt_regs *regs, int all)
 		regs->si, regs->di, regs->bp, sp);
 	printk(KERN_DEFAULT " DS: %04x ES: %04x FS: %04x GS: %04x SS: %04x\n",
 	       (u16)regs->ds, (u16)regs->es, (u16)regs->fs, gs, ss);
+}
+
+void __show_regs(struct pt_regs *regs, int all)
+{
+	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
+	unsigned long d0, d1, d2, d3, d6, d7;
+
+
+	show_regs_common();
+
+	__show_main_regs(regs);
 
 	if (!all)
 		return;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3c2422a..00a6614 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -151,15 +151,8 @@ void cpu_idle(void)
 	}
 }
 
-/* Prints also some state that isn't saved in the pt_regs */
-void __show_regs(struct pt_regs *regs, int all)
+void __show_main_regs(struct pt_regs *regs)
 {
-	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
-	unsigned long d0, d1, d2, d3, d6, d7;
-	unsigned int fsindex, gsindex;
-	unsigned int ds, cs, es;
-
-	show_regs_common();
 	printk(KERN_DEFAULT "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
 	printk_address(regs->ip, 1);
 	printk(KERN_DEFAULT "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
@@ -174,7 +167,18 @@ void __show_regs(struct pt_regs *regs, int all)
 	       regs->r10, regs->r11, regs->r12);
 	printk(KERN_DEFAULT "R13: %016lx R14: %016lx R15: %016lx\n",
 	       regs->r13, regs->r14, regs->r15);
+}
 
+/* Prints also some state that isn't saved in the pt_regs */
+void __show_regs(struct pt_regs *regs, int all)
+{
+	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
+	unsigned long d0, d1, d2, d3, d6, d7;
+	unsigned int fsindex, gsindex;
+	unsigned int ds, cs, es;
+
+	show_regs_common();
+	__show_main_regs(regs);
 	asm("movl %%ds,%0" : "=r" (ds));
 	asm("movl %%cs,%0" : "=r" (cs));
 	asm("movl %%es,%0" : "=r" (es));
-- 
1.7.1

