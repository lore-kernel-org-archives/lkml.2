Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2DTA0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:26:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53082 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950Ab2DTA0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:26:37 -0400
Date: Thu, 19 Apr 2012 17:26:25 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-ffc4bc9c6fa4eaf935d96d139bfa7443cac0b88e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        glommer@parallels.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        glommer@parallels.com, tglx@linutronix.de
In-Reply-To: <1334794610-5546-4-git-send-email-hpa@zytor.com>
References: <1334794610-5546-4-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, paravirt:
  Replace GET_CR2_INTO_RCX with GET_CR2_INTO_RAX
Git-Commit-ID: ffc4bc9c6fa4eaf935d96d139bfa7443cac0b88e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 17:26:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffc4bc9c6fa4eaf935d96d139bfa7443cac0b88e
Gitweb:     http://git.kernel.org/tip/ffc4bc9c6fa4eaf935d96d139bfa7443cac0b88e
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 18 Apr 2012 17:16:48 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Apr 2012 15:07:56 -0700

x86, paravirt: Replace GET_CR2_INTO_RCX with GET_CR2_INTO_RAX

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
Link: http://lkml.kernel.org/r/1334794610-5546-4-git-send-email-hpa@zytor.com
Cc: Glauber de Oliveira Costa <glommer@parallels.com>
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
