Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1CITQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:16:14 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18708 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1CITPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:15:20 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LHT1HB-02-10U-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>, <brgerst@gmail.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <eranian@google.com>, <suresh.b.siddha@intel.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 7/8] x86, xsave: add kernel support for AMDs Lightweight Profiling (LWP)
Date: Wed, 9 Mar 2011 20:15:01 +0100
Message-ID: <1299698102-972771-8-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299698102-972771-1-git-send-email-hans.rosenfeld@amd.com>
References: <1299698102-972771-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the xsave structure to support the LWP state. The
xstate feature bit for LWP is added to XCNTXT_NONLAZY, thereby enabling
kernel support for saving/restoring LWP state.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/processor.h  |   12 ++++++++++++
 arch/x86/include/asm/sigcontext.h |   12 ++++++++++++
 arch/x86/include/asm/xsave.h      |    3 ++-
 3 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4c25ab4..df2cbd4 100644
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
index 18401cc..a169115 100644
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
 
 #define XCNTXT_MASK	(XCNTXT_LAZY | XCNTXT_NONLAZY)
 
-- 
1.5.6.5


