Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab0JHOB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:01:57 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:18494 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966Ab0JHOAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:00:43 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9Z5KW-01-A9Q-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/7] oprofile, x86: Introduce struct ibs_state
Date: Fri, 8 Oct 2010 15:56:30 +0200
Message-ID: <1286546192-18593-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
References: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces struct ibs_state that will extended by additinal
members in follow-on patches.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index d5e9dab..9d45097 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -48,7 +48,7 @@ static unsigned long reset_value[NUM_VIRT_COUNTERS];
 
 static u32 ibs_caps;
 
-struct op_ibs_config {
+struct ibs_config {
 	unsigned long op_enabled;
 	unsigned long fetch_enabled;
 	unsigned long max_cnt_fetch;
@@ -57,8 +57,12 @@ struct op_ibs_config {
 	unsigned long dispatched_ops;
 };
 
-static struct op_ibs_config ibs_config;
-static u64 ibs_op_ctl;
+struct ibs_state {
+	u64	ibs_op_ctl;
+};
+
+static struct ibs_config ibs_config;
+static struct ibs_state ibs_state;
 
 /*
  * IBS cpuid feature detection
@@ -219,7 +223,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
-			ctl = op_amd_randomize_ibs_op(ibs_op_ctl);
+			ctl = op_amd_randomize_ibs_op(ibs_state.ibs_op_ctl);
 			wrmsrl(MSR_AMD64_IBSOPCTL, ctl);
 		}
 	}
@@ -232,6 +236,8 @@ static inline void op_amd_start_ibs(void)
 	if (!ibs_caps)
 		return;
 
+	memset(&ibs_state, 0, sizeof(ibs_state));
+
 	if (ibs_config.fetch_enabled) {
 		val = (ibs_config.max_cnt_fetch >> 4) & IBS_FETCH_MAX_CNT;
 		val |= ibs_config.rand_en ? IBS_FETCH_RAND_EN : 0;
@@ -240,13 +246,13 @@ static inline void op_amd_start_ibs(void)
 	}
 
 	if (ibs_config.op_enabled) {
-		ibs_op_ctl = ibs_config.max_cnt_op >> 4;
+		val = ibs_config.max_cnt_op >> 4;
 		if (!(ibs_caps & IBS_CAPS_RDWROPCNT)) {
 			/*
 			 * IbsOpCurCnt not supported.  See
 			 * op_amd_randomize_ibs_op() for details.
 			 */
-			ibs_op_ctl = clamp(ibs_op_ctl, 0x0081ULL, 0xFF80ULL);
+			val = clamp(val, 0x0081ULL, 0xFF80ULL);
 		} else {
 			/*
 			 * The start value is randomized with a
@@ -254,12 +260,13 @@ static inline void op_amd_start_ibs(void)
 			 * with the half of the randomized range. Also
 			 * avoid underflows.
 			 */
-			ibs_op_ctl = min(ibs_op_ctl + IBS_RANDOM_MAXCNT_OFFSET,
-					 IBS_OP_MAX_CNT);
+			val = min(val + IBS_RANDOM_MAXCNT_OFFSET,
+				  IBS_OP_MAX_CNT);
 		}
-		ibs_op_ctl |= ibs_config.dispatched_ops ? IBS_OP_CNT_CTL : 0;
-		ibs_op_ctl |= IBS_OP_ENABLE;
-		val = op_amd_randomize_ibs_op(ibs_op_ctl);
+		val |= ibs_config.dispatched_ops ? IBS_OP_CNT_CTL : 0;
+		val |= IBS_OP_ENABLE;
+		ibs_state.ibs_op_ctl = val;
+		val = op_amd_randomize_ibs_op(ibs_state.ibs_op_ctl);
 		wrmsrl(MSR_AMD64_IBSOPCTL, val);
 	}
 }
-- 
1.7.2.2


