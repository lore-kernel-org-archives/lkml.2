Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1HaJWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 05:22:47 -0400
Received: from smtp.citrix.com ([66.165.176.89]:19124 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab1HaJWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 05:22:46 -0400
X-IronPort-AV: E=Sophos;i="4.68,306,1312171200"; 
   d="scan'208";a="16590101"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ian Campbell <ian.campbell@citrix.com>, x86@kernel.org
Subject: [PATCH 1/2] x86: drop unnecessary kernel_eflags variable from 64 bit.
Date: Wed, 31 Aug 2011 10:22:39 +0100
Message-ID: <1314782560-19146-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1314782541.28989.37.camel@zakaz.uk.xensource.com>
References: <1314782541.28989.37.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64 bit x86 we save the current eflags in cpu_init for use in ret_from_fork.
Strictly speaking reserved bits in EFLAGS should be read as written but in
practise it is unlikely that EFLAGS could ever be extended in this way and the
kernel alread clears any undefined flags early on.

The equivalent 32 bit code simply hard codes 0x0202 as the new EFLAGS.

This change makes 64 bit use the same mechanism to setup the initial EFLAGS on
fork. Note that 64 bit resets EFLAGS before calling schedule_tail() as opposed
to 32 bit which calls schedule_tail() first. Therefore the correct value for
EFLAGS has opposite IF bit. This will be fixed in a subsequent patch.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: x86@kernel.org
---
 arch/x86/include/asm/processor.h |    1 -
 arch/x86/kernel/cpu/common.c     |    4 ----
 arch/x86/kernel/entry_64.S       |    2 +-
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0d1171c..3065557 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -398,7 +398,6 @@ DECLARE_INIT_PER_CPU(irq_stack_union);
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
-extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index aa003b1..1a11da2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1082,8 +1082,6 @@ void syscall_init(void)
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
-unsigned long kernel_eflags;
-
 /*
  * Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
@@ -1236,8 +1234,6 @@ void __cpuinit cpu_init(void)
 	fpu_init();
 	xsave_init();
 
-	raw_local_save_flags(kernel_eflags);
-
 	if (is_uv_system())
 		uv_cpu_init();
 }
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 6419bb0..f0deb4e 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -396,7 +396,7 @@ ENTRY(ret_from_fork)
 
 	LOCK ; btr $TIF_FORK,TI_flags(%r8)
 
-	pushq_cfi kernel_eflags(%rip)
+	pushq_cfi $0x0002
 	popfq_cfi				# reset kernel eflags
 
 	call schedule_tail			# rdi: 'prev' task parameter
-- 
1.7.2.5

