Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab0FHU4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:56:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:39433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab0FHU4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:56:40 -0400
Date: Tue, 8 Jun 2010 20:56:10 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1OJvNx-0004Zq-RK@eag09.americas.sgi.com>
References: <E1OJvNx-0004Zq-RK@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Calculate BAU destination timeout
Message-ID: <tip-12a6611fa16e9c6d2f844fe2175d219c6e9bd95d@git.kernel.org>
Git-Commit-ID: 12a6611fa16e9c6d2f844fe2175d219c6e9bd95d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 20:56:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12a6611fa16e9c6d2f844fe2175d219c6e9bd95d
Gitweb:     http://git.kernel.org/tip/12a6611fa16e9c6d2f844fe2175d219c6e9bd95d
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 2 Jun 2010 16:22:01 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Jun 2010 21:13:44 +0200

x86, UV: Calculate BAU destination timeout

Calculate the Broadcast Assist Unit's destination timeout period from the
values in the relevant MMR's.

Store it in each cpu's per-cpu BAU structure so that a destination
timeout can be differentiated from a 'plugged' situation in which all
software ack resources are already allocated and a timeout is pending.
That case returns an immediate destination error.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: gregkh@suse.de
LKML-Reference: <E1OJvNx-0004Zq-RK@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |   12 +++++++++
 arch/x86/kernel/tlb_uv.c         |   51 +++++++++++++++++++++++++++++++++++---
 2 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index aa558ac..458e04c 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
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
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 7fea555..5506836 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
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
@@ -423,7 +436,8 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
 			 * pending.  In that case hardware returns the
 			 * ERROR that looks like a destination timeout.
 			 */
-			if (cycles_2_us(ttime - bcp->send_message) < BIOS_TO) {
+			if (cycles_2_us(ttime - bcp->send_message) <
+							timeout_us) {
 				bcp->conseccompletes = 0;
 				return FLUSH_RETRY_PLUGGED;
 			}
@@ -908,12 +922,12 @@ static void uv_ptc_seq_stop(struct seq_file *file, void *data)
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
@@ -1259,6 +1273,33 @@ static void __init uv_init_uvhub(int uvhub, int vector)
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
