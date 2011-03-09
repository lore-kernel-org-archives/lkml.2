Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1CITP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:15:27 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:54735 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1CITPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:15:20 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LHT1HA-02-10S-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>, <brgerst@gmail.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <eranian@google.com>, <suresh.b.siddha@intel.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 6/8] x86, xsave: add support for non-lazy xstates
Date: Wed, 9 Mar 2011 20:15:00 +0100
Message-ID: <1299698102-972771-7-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299698102-972771-1-git-send-email-hans.rosenfeld@amd.com>
References: <1299698102-972771-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-lazy xstates are, as the name suggests,  extended states that cannot
be saved or restored lazily. The state for AMDs LWP feature is an
example of this.

This patch adds support for this kind of xstates. If any such states are
present and supported on the running system, they will always be enabled
in xstate_mask so that they are always restored in switch_to. Since lazy
allocation of the xstate area won't work when non-lazy xstates are used,
all tasks will always have a xstate area preallocated.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/i387.h  |   11 +++++++++++
 arch/x86/include/asm/xsave.h |    5 +++--
 arch/x86/kernel/process_32.c |    2 +-
 arch/x86/kernel/process_64.c |    2 +-
 arch/x86/kernel/xsave.c      |    9 +++++++++
 5 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index c81b63e..b3b3f17 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -335,6 +335,17 @@ static inline void fpu_copy(struct fpu *dst, struct fpu *src)
 
 extern void fpu_finit(struct fpu *fpu);
 
+static inline void fpu_clear(struct fpu *fpu)
+{
+	if (pcntxt_mask & XCNTXT_NONLAZY) {
+		memset(fpu->state, 0, xstate_size);
+		fpu_finit(fpu);
+		set_used_math();
+	} else {
+		fpu_free(fpu);
+	}
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_I387_H */
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index fbbc7db..18401cc 100644
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
index 67c5838..67a6bc9 100644
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
index b6d6f38..d4050fa 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -16,6 +16,7 @@
  * Supported feature mask by the CPU and the kernel.
  */
 u64 pcntxt_mask;
+EXPORT_SYMBOL(pcntxt_mask);
 
 /*
  * Represents init state for the supported extended state.
@@ -479,6 +480,14 @@ static void __init xstate_enable_boot_cpu(void)
 	printk(KERN_INFO "xsave/xrstor: enabled xstate_bv 0x%llx, "
 	       "cntxt size 0x%x\n",
 	       pcntxt_mask, xstate_size);
+
+	if (pcntxt_mask & XCNTXT_NONLAZY) {
+		static union thread_xstate x;
+
+		task_thread_info(&init_task)->xstate_mask |= XCNTXT_NONLAZY;
+		init_task.thread.fpu.state = &x;
+		fpu_finit(&init_task.thread.fpu);
+	}
 }
 
 /*
-- 
1.5.6.5


