Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab1LGUCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:02:53 -0500
Received: from smtp-cpk.frontbridge.com ([204.231.192.41]:34521 "EHLO
	WA2EHSNDR005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757496Ab1LGUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:02:51 -0500
X-BigFish: VPS33(z667jizzz1202hzz8275bhz2dh668h839h)
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 33
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVUNOF-02-N45-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, <andi@firstfloor.org>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>, <brgerst@gmail.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 8/8] x86, xsave: add kernel support for AMDs Lightweight Profiling (LWP)
Date: Wed, 7 Dec 2011 21:00:23 +0100
Message-ID: <1323288023-26147-2-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323288023-26147-1-git-send-email-hans.rosenfeld@amd.com>
References: <20111207195753.GD665@escobedo.osrc.amd.com>
 <1323288023-26147-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
Reply-To: <Hans.Rosenfeld@amd.com>
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the xsave structure to support the LWP state. The
xstate feature bit for LWP is added to XCNTXT_NONLAZY, thereby enabling
kernel support for saving/restoring LWP state. The LWP state is also
saved/restored on signal entry/return, just like all other xstates. LWP
state needs to be reset (disabled) when entering a signal handler.

v2:
When copying xstates for fork/clone, disable LWP in the new copy so that
new tasks start with LWP disabled as required by the LWP specification.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/i387.h       |    4 ++++
 arch/x86/include/asm/msr-index.h  |    1 +
 arch/x86/include/asm/processor.h  |   12 ++++++++++++
 arch/x86/include/asm/sigcontext.h |   12 ++++++++++++
 arch/x86/include/asm/xsave.h      |    3 ++-
 arch/x86/kernel/xsave.c           |    5 +++++
 6 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 7812d55..cfd0be9 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -326,6 +326,10 @@ static inline void fpu_free(struct fpu *fpu)
 static inline void fpu_copy(struct fpu *dst, struct fpu *src)
 {
 	memcpy(dst->state, src->state, xstate_size);
+
+	/* disable LWP in the copy */
+	if (pcntxt_mask & XSTATE_LWP)
+		dst->state->xsave.xsave_hdr.xstate_bv &= ~XSTATE_LWP;
 }
 
 extern void fpu_finit(struct fpu *fpu);
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d52609a..2d9cf3c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -136,6 +136,7 @@
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
 #define MSR_AMD64_IBSCTL		0xc001103a
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
+#define MSR_AMD64_LWP_CBADDR		0xc0000106
 
 /* Fam 15h MSRs */
 #define MSR_F15H_PERF_CTL		0xc0010200
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0d1171c..bb31ab6 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -353,6 +353,17 @@ struct ymmh_struct {
 	u32 ymmh_space[64];
 };
 
+struct lwp_struct {
+	u64 lwpcb_addr;
+	u32 flags;
+	u32 buf_head_offset;
+	u64 buf_base;
+	u32 buf_size;
+	u32 filters;
+	u64 saved_event_record[4];
+	u32 event_counter[16];
+};
+
 struct xsave_hdr_struct {
 	u64 xstate_bv;
 	u64 reserved1[2];
@@ -363,6 +374,7 @@ struct xsave_struct {
 	struct i387_fxsave_struct i387;
 	struct xsave_hdr_struct xsave_hdr;
 	struct ymmh_struct ymmh;
+	struct lwp_struct lwp;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
 
diff --git a/arch/x86/include/asm/sigcontext.h b/arch/x86/include/asm/sigcontext.h
index 04459d2..0a58b82 100644
--- a/arch/x86/include/asm/sigcontext.h
+++ b/arch/x86/include/asm/sigcontext.h
@@ -274,6 +274,17 @@ struct _ymmh_state {
 	__u32 ymmh_space[64];
 };
 
+struct _lwp_state {
+	__u64 lwpcb_addr;
+	__u32 flags;
+	__u32 buf_head_offset;
+	__u64 buf_base;
+	__u32 buf_size;
+	__u32 filters;
+	__u64 saved_event_record[4];
+	__u32 event_counter[16];
+};
+
 /*
  * Extended state pointed by the fpstate pointer in the sigcontext.
  * In addition to the fpstate, information encoded in the xstate_hdr
@@ -284,6 +295,7 @@ struct _xstate {
 	struct _fpstate fpstate;
 	struct _xsave_hdr xstate_hdr;
 	struct _ymmh_state ymmh;
+	struct _lwp_state lwp;
 	/* new processor state extensions go here */
 };
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 10e0e45..789a140 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -9,6 +9,7 @@
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
 #define XSTATE_YMM	0x4
+#define XSTATE_LWP	(1ULL << 62)
 
 #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
 
@@ -24,7 +25,7 @@
  * These are the features that the OS can handle currently.
  */
 #define XCNTXT_LAZY	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
-#define XCNTXT_NONLAZY	0
+#define XCNTXT_NONLAZY	(XSTATE_LWP)
 
 #ifdef CONFIG_NONLAZY_XSTATES
 #define XCNTXT_MASK	(XCNTXT_LAZY | XCNTXT_NONLAZY)
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index ce329ff..2022069 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -249,6 +249,11 @@ int save_xstates_sigframe(void __user *buf, unsigned int size)
 			return err;
 	}
 
+	if (pcntxt_mask & XSTATE_LWP) {
+		xsave->xsave_hdr.xstate_bv &= ~XSTATE_LWP;
+		wrmsrl(MSR_AMD64_LWP_CBADDR, 0);
+	}
+
 	return 1;
 }
 
-- 
1.7.5.4


