Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab2DSASQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:18:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43454 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab2DSARq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:17:46 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 3/5] x86, paravirt: Replace GET_CR2_INTO_RCX with GET_CR2_INTO_RAX
Date: Wed, 18 Apr 2012 17:16:48 -0700
Message-Id: <1334794610-5546-4-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1334794610-5546-1-git-send-email-hpa@zytor.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 18 Apr 2012 17:17:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

GET_CR2_INTO_RCX is asinine: it is only used in one place, the actual
paravirt call returns the value in %rax, not %rcx; and the one place
that wants it wants the result in %r9.  We actually generate as a
result of this call:

       call ...
       movq %rax, %rcx
       xorq %rax, %rax		/* this value isn't even used... */
       movq %rcx, %r9

At least make the macro do what the paravirt call does, which is put
the value into %rax.

Nevermind the fact that the macro clobbers all the volatile registers.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/include/asm/paravirt.h |    6 ++----
 arch/x86/kernel/head_64.S       |    6 +++---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index aa0f913..6cbbabf 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1023,10 +1023,8 @@ extern void default_banner(void);
 		  call PARA_INDIRECT(pv_cpu_ops+PV_CPU_swapgs)		\
 		 )
 
-#define GET_CR2_INTO_RCX				\
-	call PARA_INDIRECT(pv_mmu_ops+PV_MMU_read_cr2);	\
-	movq %rax, %rcx;				\
-	xorq %rax, %rax;
+#define GET_CR2_INTO_RAX				\
+	call PARA_INDIRECT(pv_mmu_ops+PV_MMU_read_cr2)
 
 #define PARAVIRT_ADJUST_EXCEPTION_FRAME					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_adjust_exception_frame), \
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index adf52e8..d1e112c 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -23,8 +23,9 @@
 #ifdef CONFIG_PARAVIRT
 #include <asm/asm-offsets.h>
 #include <asm/paravirt.h>
+#define GET_CR2_INTO(reg) GET_CR2_INTO_RAX ; movq %rax, reg
 #else
-#define GET_CR2_INTO_RCX movq %cr2, %rcx
+#define GET_CR2_INTO(reg) movq %cr2, reg
 #endif
 
 /* we are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -286,8 +287,7 @@ ENTRY(early_idt_handler)
 	cmpl $2,early_recursion_flag(%rip)
 	jz  1f
 	incl early_recursion_flag(%rip)
-	GET_CR2_INTO_RCX
-	movq %rcx,%r9
+	GET_CR2_INTO(%r9)
 	xorl %r8d,%r8d		# zero for error code
 	movl %esi,%ecx		# get vector number
 	# Test %ecx against mask of vectors that push error code.
-- 
1.7.6.5

