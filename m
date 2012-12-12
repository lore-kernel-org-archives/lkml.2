Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2LLSWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:22:08 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53370 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:22:04 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Subject: [TRIVIAL PATCH 16/26] x86: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:19:05 -0800
Message-Id: <054f8a88fe46ae0b4c2669d0e155d84c11b66115.1355335228.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   13 +++++++------
 arch/x86/kernel/dumpstack.c      |    5 ++---
 arch/x86/kernel/process_32.c     |    2 +-
 arch/x86/mm/mmio-mod.c           |    4 ++--
 arch/x86/um/sysrq_32.c           |    9 +++------
 5 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 80dbda8..996f98a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -242,13 +242,14 @@ static void print_mce(struct mce *m)
 	       m->extcpu, m->mcgstatus, m->bank, m->status);
 
 	if (m->ip) {
-		pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> ",
-			!(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
-				m->cs, m->ip);
-
 		if (m->cs == __KERNEL_CS)
-			print_symbol("{%s}", m->ip);
-		pr_cont("\n");
+			pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> {%pSR}\n",
+				 !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
+				 m->cs, m->ip, (void *)m->ip);
+		else
+			pr_emerg(HW_ERR "RIP%s %02x:<%016Lx>\n",
+				 !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
+				 m->cs, m->ip);
 	}
 
 	pr_emerg(HW_ERR "TSC %llx ", m->tsc);
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index ae42418b..b6e5bdb 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -281,9 +281,8 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 		sp = kernel_stack_pointer(regs);
 		savesegment(ss, ss);
 	}
-	printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
-	print_symbol("%s", regs->ip);
-	printk(" SS:ESP %04x:%08lx\n", ss, sp);
+	printk(KERN_EMERG "EIP: [<%08lx>] %pSR SS:ESP %04x:%08lx\n",
+	       regs->ip, (void *)regs->ip, ss, sp);
 #else
 	/* Executive summary in case the oops scrolled away */
 	printk(KERN_ALERT "RIP ");
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index b5a8905..0db77e0 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -89,7 +89,7 @@ void __show_regs(struct pt_regs *regs, int all)
 	printk(KERN_DEFAULT "EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
 			(u16)regs->cs, regs->ip, regs->flags,
 			smp_processor_id());
-	print_symbol("EIP is at %s\n", regs->ip);
+	printk(KERN_DEFAULT "EIP is at %pSR\n", (void *)regs->ip);
 
 	printk(KERN_DEFAULT "EAX: %08lx EBX: %08lx ECX: %08lx EDX: %08lx\n",
 		regs->ax, regs->bx, regs->cx, regs->dx);
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index dc0b727..c0ca484 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -123,8 +123,8 @@ static void die_kmmio_nesting_error(struct pt_regs *regs, unsigned long addr)
 	pr_emerg("unexpected fault for address: 0x%08lx, last fault for address: 0x%08lx\n",
 		 addr, my_reason->addr);
 	print_pte(addr);
-	print_symbol(KERN_EMERG "faulting IP is at %s\n", regs->ip);
-	print_symbol(KERN_EMERG "last faulting IP was at %s\n", my_reason->ip);
+	pr_emerg("faulting IP is at %pSR\n", (void *)regs->ip);
+	pr_emerg("last faulting IP was at %pSR\n", (void *)my_reason->ip);
 #ifdef __i386__
 	pr_emerg("eax: %08lx   ebx: %08lx   ecx: %08lx   edx: %08lx\n",
 		 regs->ax, regs->bx, regs->cx, regs->dx);
diff --git a/arch/x86/um/sysrq_32.c b/arch/x86/um/sysrq_32.c
index c9bee5b..30b4200 100644
--- a/arch/x86/um/sysrq_32.c
+++ b/arch/x86/um/sysrq_32.c
@@ -50,18 +50,15 @@ static inline unsigned long print_context_stack(struct thread_info *tinfo,
 #ifdef CONFIG_FRAME_POINTER
 	while (valid_stack_ptr(tinfo, (void *)ebp)) {
 		addr = *(unsigned long *)(ebp + 4);
-		printk("%08lx:  [<%08lx>]", ebp + 4, addr);
-		print_symbol(" %s", addr);
-		printk("\n");
+		printk("%08lx:  [<%08lx>] %pSR\n", ebp + 4, addr, (void *)addr);
 		ebp = *(unsigned long *)ebp;
 	}
 #else
 	while (valid_stack_ptr(tinfo, stack)) {
 		addr = *stack;
 		if (__kernel_text_address(addr)) {
-			printk("%08lx:  [<%08lx>]", (unsigned long) stack, addr);
-			print_symbol(" %s", addr);
-			printk("\n");
+			printk("%08lx:  [<%08lx>] %pSR\n",
+			       (unsigned long)stack, addr, (void *)addr);
 		}
 		stack++;
 	}
-- 
1.7.8.112.g3fd21

