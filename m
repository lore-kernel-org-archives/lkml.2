Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab1GENAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:00:23 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:37131 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab1GENAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:00:22 -0400
X-IronPort-AV: E=Sophos;i="4.65,479,1304308800"; 
   d="scan'208";a="153527739"
From: Ian Campbell <ian.campbell@citrix.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>, x86@kernel.org
Subject: [PATCH 1/3] x86: drop unnecessary kernel_eflags variable from 64 bit.
Date: Tue, 5 Jul 2011 14:00:12 +0100
Message-ID: <1309870814-14181-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20110705111525.GR17941@sun>
References: <20110705111525.GR17941@sun>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For no reason that I can determine 64 bit x86 saves the current eflags
in cpu_init purely for use in ret_from_fork. The equivalent 32 bit
code simply hard codes 0x0202 as the new EFLAGS which seems safer than
relying on a potentially arbitrary EFLAGS saved during cpu_init.

Original i386 changeset
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=47a5c6fa0e204a2b63309c648bb2fde36836c826
Original x86_64 changset
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=658fdbef66e5e9be79b457edc2cbbb3add840aa9

The only comment in the later indicates that it is following the
former, but not why it differs in this way.

This change makes 64 bit use the same mechanism to setup the initial
EFLAGS on fork. Note that 64 bit resets EFLAGS before calling
schedule_tail() as opposed to 32 bit which calls schedule_tail()
first. Therefore the correct value for EFLAGS has opposite IF
bit. This will be fixed in a subsequent patch.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/cpu/common.c |    4 ----
 arch/x86/kernel/entry_64.S   |    2 +-
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22a073d..178c3b4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1077,8 +1077,6 @@ void syscall_init(void)
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
-unsigned long kernel_eflags;
-
 /*
  * Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
@@ -1231,8 +1229,6 @@ void __cpuinit cpu_init(void)
 	fpu_init();
 	xsave_init();
 
-	raw_local_save_flags(kernel_eflags);
-
 	if (is_uv_system())
 		uv_cpu_init();
 }
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e13329d..b50d142 100644
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

