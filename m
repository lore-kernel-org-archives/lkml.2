Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab0JHOVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:21:47 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:36704 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047Ab0JHOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:21:46 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9Z5KW-02-0JD-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 7/7] oprofile, x86: Add support for IBS periodic op counter extension
Date: Fri, 8 Oct 2010 15:56:32 +0200
Message-ID: <1286546192-18593-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
References: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The count value for IBS op sampling has been extended by 7 bits. The
feature is reflected in bit 6 (OpCntExt) of the IBS capability
register (CPUID Fn8000_001B_EAX).

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h |   19 ++++++++++---------
 arch/x86/oprofile/op_model_amd.c  |   22 +++++++++++++++++++---
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 6e742cc..550e26b 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -111,17 +111,18 @@ union cpuid10_edx {
 #define X86_PMC_IDX_FIXED_BTS				(X86_PMC_IDX_FIXED + 16)
 
 /* IbsFetchCtl bits/masks */
-#define IBS_FETCH_RAND_EN		(1ULL<<57)
-#define IBS_FETCH_VAL			(1ULL<<49)
-#define IBS_FETCH_ENABLE		(1ULL<<48)
-#define IBS_FETCH_CNT			0xFFFF0000ULL
-#define IBS_FETCH_MAX_CNT		0x0000FFFFULL
+#define IBS_FETCH_RAND_EN	(1ULL<<57)
+#define IBS_FETCH_VAL		(1ULL<<49)
+#define IBS_FETCH_ENABLE	(1ULL<<48)
+#define IBS_FETCH_CNT		0xFFFF0000ULL
+#define IBS_FETCH_MAX_CNT	0x0000FFFFULL
 
 /* IbsOpCtl bits */
-#define IBS_OP_CNT_CTL			(1ULL<<19)
-#define IBS_OP_VAL			(1ULL<<18)
-#define IBS_OP_ENABLE			(1ULL<<17)
-#define IBS_OP_MAX_CNT			0x0000FFFFULL
+#define IBS_OP_CNT_CTL		(1ULL<<19)
+#define IBS_OP_VAL		(1ULL<<18)
+#define IBS_OP_ENABLE		(1ULL<<17)
+#define IBS_OP_MAX_CNT		0x0000FFFFULL
+#define IBS_OP_MAX_CNT_EXT	0x007FFFFFULL	/* not a register bit mask */
 
 #ifdef CONFIG_PERF_EVENTS
 extern void init_hw_perf_events(void);
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 9de33fa..65f0a1e 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -83,6 +83,7 @@ static struct ibs_state ibs_state;
 #define IBS_CAPS_RDWROPCNT		(1U<<3)
 #define IBS_CAPS_OPCNT			(1U<<4)
 #define IBS_CAPS_BRNTRGT		(1U<<5)
+#define IBS_CAPS_OPCNTEXT		(1U<<6)
 
 #define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
 					 | IBS_CAPS_FETCHSAM	\
@@ -246,8 +247,16 @@ static inline void op_amd_start_ibs(void)
 
 	memset(&ibs_state, 0, sizeof(ibs_state));
 
+	/*
+	 * Note: Since the max count settings may out of range we
+	 * write back the actual used values so that userland can read
+	 * it.
+	 */
+
 	if (ibs_config.fetch_enabled) {
-		val = (ibs_config.max_cnt_fetch >> 4) & IBS_FETCH_MAX_CNT;
+		val = ibs_config.max_cnt_fetch >> 4;
+		val = min(val, IBS_FETCH_MAX_CNT);
+		ibs_config.max_cnt_fetch = val << 4;
 		val |= ibs_config.rand_en ? IBS_FETCH_RAND_EN : 0;
 		val |= IBS_FETCH_ENABLE;
 		wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
@@ -261,6 +270,7 @@ static inline void op_amd_start_ibs(void)
 			 * op_amd_randomize_ibs_op() for details.
 			 */
 			val = clamp(val, 0x0081ULL, 0xFF80ULL);
+			ibs_config.max_cnt_op = val << 4;
 		} else {
 			/*
 			 * The start value is randomized with a
@@ -268,9 +278,15 @@ static inline void op_amd_start_ibs(void)
 			 * with the half of the randomized range. Also
 			 * avoid underflows.
 			 */
-			val = min(val + IBS_RANDOM_MAXCNT_OFFSET,
-				  IBS_OP_MAX_CNT);
+			val += IBS_RANDOM_MAXCNT_OFFSET;
+			if (ibs_caps & IBS_CAPS_OPCNTEXT)
+				val = min(val, IBS_OP_MAX_CNT_EXT);
+			else
+				val = min(val, IBS_OP_MAX_CNT);
+			ibs_config.max_cnt_op =
+				(val - IBS_RANDOM_MAXCNT_OFFSET) << 4;
 		}
+		val = ((val & ~IBS_OP_MAX_CNT) << 4) | (val & IBS_OP_MAX_CNT);
 		val |= ibs_config.dispatched_ops ? IBS_OP_CNT_CTL : 0;
 		val |= IBS_OP_ENABLE;
 		ibs_state.ibs_op_ctl = val;
-- 
1.7.2.2


