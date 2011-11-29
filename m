Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1K2Mm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:42:58 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:4198 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab1K2Mmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:42:53 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVF9ZB-01-CSN-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 8/9] x86, xsave: add support for non-lazy xstates
Date: Tue, 29 Nov 2011 13:41:27 +0100
Message-ID: <1322570488-21798-9-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
References: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-lazy xstates are, as the name suggests, extended states that cannot
be saved or restored lazily. The state for AMDs LWP feature is a
non-lazy state.

This patch adds support for this kind of xstates. If any such states are
present and supported on the running system, they will always be enabled
in xstate_mask so that they are always restored in switch_to.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/xsave.h |    5 +++--
 arch/x86/kernel/xsave.c      |    6 +++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 12793b6..02f1e1d 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -23,9 +23,10 @@
 /*
  * These are the features that the OS can handle currently.
  */
-#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XCNTXT_LAZY	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XCNTXT_NONLAZY	0
 
-#define XCNTXT_LAZY	XCNTXT_MASK
+#define XCNTXT_MASK	(XCNTXT_LAZY | XCNTXT_NONLAZY)
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 1a11291..988bdef 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -16,6 +16,7 @@
  * Supported feature mask by the CPU and the kernel.
  */
 u64 pcntxt_mask;
+EXPORT_SYMBOL(pcntxt_mask);
 
 /*
  * Represents init state for the supported extended state.
@@ -261,7 +262,7 @@ int restore_xstates_sigframe(void __user *buf, unsigned int size)
 	struct task_struct *tsk = current;
 	struct _fpstate_ia32 __user *fp = buf;
 	struct xsave_struct *xsave;
-	u64 xstate_mask = 0;
+	u64 xstate_mask = pcntxt_mask & XCNTXT_NONLAZY;
 
 	if (!buf) {
 		if (used_math()) {
@@ -478,6 +479,9 @@ static void __init xstate_enable_boot_cpu(void)
 	printk(KERN_INFO "xsave/xrstor: enabled xstate_bv 0x%llx, "
 	       "cntxt size 0x%x\n",
 	       pcntxt_mask, xstate_size);
+
+	if (pcntxt_mask & XCNTXT_NONLAZY)
+		task_thread_info(&init_task)->xstate_mask |= XCNTXT_NONLAZY;
 }
 
 /*
-- 
1.7.5.4


