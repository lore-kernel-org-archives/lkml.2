Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab0FBVWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:22:04 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37300 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932912Ab0FBVVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:21:35 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/11] x86, UV: calculate BAU destination timeout
Cc: mingo@elte.hu, hpa@zytor.com, gregkh@suse.de
Message-Id: <E1OJvNx-0004Zq-RK@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 02 Jun 2010 16:22:01 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Calculate the Broadcast Assist Unit's destination timeout period from
the values in the relevant MMR's.

Store it in each cpu's per-cpu BAU structure so that a destination timeout
can be differentiated from a 'plugged' situation in which all software ack
resources are already allocated and a timeout is pending.  That case returns
an immediate destination error.

Diffed against 2.6.34 -tip

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |   12 +++++++++
 arch/x86/kernel/tlb_uv.c         |   51 +++++++++++++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 4 deletions(-)

Index: 100531.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100531.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100531.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -30,6 +30,19 @@ struct msg_desc {
 	struct bau_payload_queue_entry *va_queue_last;
 };
 
+/* timeouts in nanoseconds (indexed by UVH_AGING_PRESCALE_SEL urgency7 30:28) */
+static int timeout_base_ns[] = {
+		20,
+		160,
+		1280,
+		10240,
+		81920,
+		655360,
+		5242880,
+		167772160
+};
+static int timeout_us;
+
 #define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD	0x000000000bUL
 
 static int uv_bau_max_concurrent __read_mostly;
@@ -423,7 +436,8 @@ static int uv_wait_completion(struct bau
 			 * pending.  In that case hardware returns the
 			 * ERROR that looks like a destination timeout.
 			 */
-			if (cycles_2_us(ttime - bcp->send_message) < BIOS_TO) {
+			if (cycles_2_us(ttime - bcp->send_message) <
+							timeout_us) {
 				bcp->conseccompletes = 0;
 				return FLUSH_RETRY_PLUGGED;
 			}
@@ -908,12 +922,12 @@ static void uv_ptc_seq_stop(struct seq_f
 }
 
 static inline unsigned long long
-millisec_2_cycles(unsigned long millisec)
+microsec_2_cycles(unsigned long microsec)
 {
 	unsigned long ns;
 	unsigned long long cyc;
 
-	ns = millisec * 1000;
+	ns = microsec * 1000;
 	cyc = (ns << CYC2NS_SCALE_FACTOR)/(per_cpu(cyc2ns, smp_processor_id()));
 	return cyc;
 }
@@ -1259,6 +1273,33 @@ static void __init uv_init_uvhub(int uvh
 }
 
 /*
+ * We will set BAU_MISC_CONTROL with a timeout period.
+ * But the BIOS has set UVH_AGING_PRESCALE_SEL and UVH_TRANSACTION_TIMEOUT.
+ * So the destination timeout period has be be calculated from them.
+ */
+static int
+calculate_destination_timeout(void)
+{
+	unsigned long mmr_image;
+	int mult1;
+	int mult2;
+	int index;
+	int base;
+	int ret;
+	unsigned long ts_ns;
+
+	mult1 = UV_INTD_SOFT_ACK_TIMEOUT_PERIOD & BAU_MISC_CONTROL_MULT_MASK;
+	mmr_image = uv_read_local_mmr(UVH_AGING_PRESCALE_SEL);
+	index = (mmr_image >> BAU_URGENCY_7_SHIFT) & BAU_URGENCY_7_MASK;
+	mmr_image = uv_read_local_mmr(UVH_TRANSACTION_TIMEOUT);
+	mult2 = (mmr_image >> BAU_TRANS_SHIFT) & BAU_TRANS_MASK;
+	base = timeout_base_ns[index];
+	ts_ns = base * mult1 * mult2;
+	ret = ts_ns / 1000;
+	return ret;
+}
+
+/*
  * initialize the bau_control structure for each cpu
  */
 static void uv_init_per_cpu(int nuvhubs)
@@ -1286,6 +1327,8 @@ static void uv_init_per_cpu(int nuvhubs)
 	};
 	struct uvhub_desc *uvhub_descs;
 
+	timeout_us = calculate_destination_timeout();
+
 	uvhub_descs = (struct uvhub_desc *)
 		kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
 	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
@@ -1301,7 +1344,7 @@ static void uv_init_per_cpu(int nuvhubs)
 		bdp->uvhub = uvhub;
 		bdp->pnode = pnode;
 		/* time interval to catch a hardware stay-busy bug */
-		bcp->timeout_interval = millisec_2_cycles(3);
+		bcp->timeout_interval = microsec_2_cycles(2*timeout_us);
 		/* kludge: assume uv_hub.h is constant */
 		socket = (cpu_physical_id(cpu)>>5)&1;
 		if (socket >= bdp->num_sockets)
Index: 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- 100531.linux-tip.orig/arch/x86/include/asm/uv/uv_bau.h
+++ 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
@@ -49,6 +49,18 @@
 #define UV_ENABLE_INTD_SOFT_ACK_MODE_SHIFT 15
 #define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHIFT 16
 #define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD 0x000000000bUL
+/* [19:16] SOFT_ACK timeout period  19: 1 is urgency 7  17:16 1 is multiplier */
+#define BAU_MISC_CONTROL_MULT_MASK 3
+
+#define UVH_AGING_PRESCALE_SEL 0x000000b000UL
+/* [30:28] URGENCY_7  an index into a table of times */
+#define BAU_URGENCY_7_SHIFT 28
+#define BAU_URGENCY_7_MASK 7
+
+#define UVH_TRANSACTION_TIMEOUT 0x000000b200UL
+/* [45:40] BAU - BAU transaction timeout select - a multiplier */
+#define BAU_TRANS_SHIFT 40
+#define BAU_TRANS_MASK 0x3f
 
 /*
  * bits in UVH_LB_BAU_SB_ACTIVATION_STATUS_0/1
