Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1DEPw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:52:29 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:41472
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013Ab1DEPwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:52:24 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ6S14-01-Q6K-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <brgerst@gmail.com>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC v3 6/8] x86, xsave: add support for non-lazy xstates
Date: Tue, 5 Apr 2011 17:50:54 +0200
Message-ID: <1302018656-586370-7-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4D91FA76.1010908@zytor.com>
References: <4D91FA76.1010908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-lazy xstates are, as the name suggests, extended states that cannot
be saved or restored lazily. The state for AMDs LWP feature is an
example of this.

This patch adds support for this kind of xstates. If any such states are
present and supported on the running system, they will always be enabled
in xstate_mask so that they are always restored in switch_to. Since lazy
allocation of the xstate area won't work when non-lazy xstates are used,
all user tasks will always have a xstate area preallocated.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/i387.h  |   17 +++++++++++++++++
 arch/x86/include/asm/xsave.h |    5 +++--
 arch/x86/kernel/process_32.c |    2 +-
 arch/x86/kernel/process_64.c |    2 +-
 arch/x86/kernel/xsave.c      |    6 +++++-
 5 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index b8f9617..efe1476 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -329,6 +329,23 @@ static inline void fpu_copy(struct fpu *dst, struct fpu *src)
 }
 
 extern void fpu_finit(struct fpu *fpu);
+static union thread_xstate __init_xstate, *init_xstate = &__init_xstate;
+
+static inline void fpu_clear(struct fpu *fpu)
+{
+	if (pcntxt_mask & XCNTXT_NONLAZY) {
+		if (!fpu_allocated(fpu)) {
+			BUG_ON(init_xstate == NULL);
+			fpu->state = init_xstate;
+			init_xstate = NULL;
+		}
+		memset(fpu->state, 0, xstate_size);
+		fpu_finit(fpu);
+		set_used_math();
+	} else {
+		fpu_free(fpu);
+	}
+}
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index b8861d4..4ccee3c 100644
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
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8df07c3..a878736 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -257,7 +257,7 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 	/*
 	 * Free the old FP and other extended state
 	 */
-	free_thread_xstate(current);
+	fpu_clear(&current->thread.fpu);
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index cbf1a67..8ff35fc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -344,7 +344,7 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	/*
 	 * Free the old FP and other extended state
 	 */
-	free_thread_xstate(current);
+	fpu_clear(&current->thread.fpu);
 }
 
 void
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index d42810f..56ab3d3 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -16,6 +16,7 @@
  * Supported feature mask by the CPU and the kernel.
  */
 u64 pcntxt_mask;
+EXPORT_SYMBOL(pcntxt_mask);
 
 /*
  * Represents init state for the supported extended state.
@@ -260,7 +261,7 @@ int restore_xstates_sigframe(void __user *buf, unsigned int size)
 	struct task_struct *tsk = current;
 	struct _fpstate_ia32 __user *fp = buf;
 	struct xsave_struct *xsave;
-	u64 xstate_mask = 0;
+	u64 xstate_mask = pcntxt_mask & XCNTXT_NONLAZY;
 	int err;
 
 	if (!buf) {
@@ -477,6 +478,9 @@ static void __init xstate_enable_boot_cpu(void)
 	printk(KERN_INFO "xsave/xrstor: enabled xstate_bv 0x%llx, "
 	       "cntxt size 0x%x\n",
 	       pcntxt_mask, xstate_size);
+
+	if (pcntxt_mask & XCNTXT_NONLAZY)
+		task_thread_info(&init_task)->xstate_mask |= XCNTXT_NONLAZY;
 }
 
 /*
-- 
1.5.6.5


