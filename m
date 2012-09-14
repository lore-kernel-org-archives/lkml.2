Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2INGUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:20:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab2INGUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:20:10 -0400
Date: Thu, 13 Sep 2012 23:19:42 -0700
From: tip-bot for Ian Campbell <ian.campbell@citrix.com>
Message-ID: <tip-6eebdda35e6b18d0dddb2a44e34211bd94f0cad6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl, brgerst@gmail.com,
        penberg@kernel.org, ian.campbell@citrix.com, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, brgerst@gmail.com, a.p.zijlstra@chello.nl,
        ian.campbell@citrix.com, penberg@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <20120824195847.GA31628@moon>
References: <20120824195847.GA31628@moon>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86:
  Drop unnecessary kernel_eflags variable on 64-bit
Git-Commit-ID: 6eebdda35e6b18d0dddb2a44e34211bd94f0cad6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:19:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6eebdda35e6b18d0dddb2a44e34211bd94f0cad6
Gitweb:     http://git.kernel.org/tip/6eebdda35e6b18d0dddb2a44e34211bd94f0cad6
Author:     Ian Campbell <ian.campbell@citrix.com>
AuthorDate: Fri, 24 Aug 2012 23:58:47 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 17:32:47 +0200

x86: Drop unnecessary kernel_eflags variable on 64-bit

On 64 bit x86 we save the current eflags in cpu_init for use in
ret_from_fork. Strictly speaking reserved bits in EFLAGS should
be read as written but in practise it is unlikely that EFLAGS
could ever be extended in this way and the kernel alread clears
any undefined flags early on.

The equivalent 32 bit code simply hard codes 0x0202 as the new
EFLAGS.

This change makes 64 bit use the same mechanism to setup the
initial EFLAGS on fork. Note that 64 bit resets EFLAGS before
calling schedule_tail() as opposed to 32 bit which calls
schedule_tail() first. Therefore the correct value for EFLAGS
has opposite IF bit.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/20120824195847.GA31628@moon
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/processor.h |    1 -
 arch/x86/kernel/cpu/common.c     |    4 ----
 arch/x86/kernel/entry_64.S       |    2 +-
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d048cad..9738b39 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -423,7 +423,6 @@ DECLARE_INIT_PER_CPU(irq_stack_union);
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
-extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a5fbc3c..9961e2e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1116,8 +1116,6 @@ void syscall_init(void)
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
-unsigned long kernel_eflags;
-
 /*
  * Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
@@ -1299,8 +1297,6 @@ void __cpuinit cpu_init(void)
 	fpu_init();
 	xsave_init();
 
-	raw_local_save_flags(kernel_eflags);
-
 	if (is_uv_system())
 		uv_cpu_init();
 }
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 69babd8..b1dac12 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -440,7 +440,7 @@ ENTRY(ret_from_fork)
 
 	LOCK ; btr $TIF_FORK,TI_flags(%r8)
 
-	pushq_cfi kernel_eflags(%rip)
+	pushq_cfi $0x0002
 	popfq_cfi				# reset kernel eflags
 
 	call schedule_tail			# rdi: 'prev' task parameter
