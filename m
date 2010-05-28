Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0E1NdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:33:23 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59902 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab0E1NdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:33:19 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH V3] x86, UV: BAU performance and error recovery
Cc: mingo@elte.hu, hpa@zytor.com
Message-Id: <E1OHzgl-0000Pj-6o@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 28 May 2010 08:33:27 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,
This patch updates the patch of the same name, which is in your lastest -tip
  b8f7fb1: x86, UV: Improve BAU performance and error recovery
It does not depend on any other patch.

This patch
- corrects several bugs:
  o the lack of BAU messaging to blade 0 (an uninitialized field)
  o correct message type for a normal shootdown message
  o fix to recovery from timed-out s/w acknowledge resources
  o calculation of the actual destination timeout so that a 'short' timeout can
    be identified
  o fix mishandling of non-consecutive hub and socket numbers
  o identification of a cpu's socket number
  o removal of the check for the h/w stay-busy bug, as under extreme pressure it
    cannot be accurately detected
  o fall back to IPI-method when extreme pressure makes numalink very slow,
    and then resume BAU-method after an interval
- adds BAU broadcasting to the cpu's on the local node
- simplifies the returning of the original cpu bitmap when the BAU attempt
  is given up entirely
- adds modification of tuning variables through /proc/sgi_uv

Diffed against 2.6.34 -tip  (Sheep on Meth)

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/include/asm/uv/uv_bau.h |  154 +++++--
 arch/x86/kernel/tlb_uv.c         |  760 +++++++++++++++++++++++++++++----------
 2 files changed, 685 insertions(+), 229 deletions(-)

Index: 100528.linux-tip/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- 100528.linux-tip.orig/arch/x86/include/asm/uv/uv_bau.h
+++ 100528.linux-tip/arch/x86/include/asm/uv/uv_bau.h
@@ -34,6 +34,7 @@
  */
 
 #define UV_ITEMS_PER_DESCRIPTOR		8
+/* the 'throttle' to prevent the hardware stay-busy bug */
 #define MAX_BAU_CONCURRENT		3
 #define UV_CPUS_PER_ACT_STATUS		32
 #define UV_ACT_STATUS_MASK		0x3
@@ -45,10 +46,24 @@
 #define UV_DESC_BASE_PNODE_SHIFT	49
 #define UV_PAYLOADQ_PNODE_SHIFT		49
 #define UV_PTC_BASENAME			"sgi_uv/ptc_statistics"
+#define UV_BAU_BASENAME			"sgi_uv/bau_tunables"
+#define WHITESPACE			" \t\n"
 #define uv_physnodeaddr(x)		((__pa((unsigned long)(x)) & uv_mmask))
 #define UV_ENABLE_INTD_SOFT_ACK_MODE_SHIFT 15
 #define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHIFT 16
-#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD 0x000000000bUL
+#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD 0x0000000009UL
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
@@ -59,24 +74,21 @@
 #define DESC_STATUS_SOURCE_TIMEOUT	3
 
 /*
- * source side threshholds at which message retries print a warning
+ * delay for 'plugged' timeout retries, in microseconds
  */
-#define SOURCE_TIMEOUT_LIMIT		20
-#define DESTINATION_TIMEOUT_LIMIT	20
-
-/*
- * misc. delays, in microseconds
- */
-#define THROTTLE_DELAY			10
-#define TIMEOUT_DELAY			10
-#define BIOS_TO				1000
-/* BIOS is assumed to set the destination timeout to 1003520 nanoseconds */
+#define PLUGGED_DELAY			10
 
 /*
  * threshholds at which to use IPI to free resources
  */
+/* after this # consecutive 'plugged' timeouts, use IPI to release resources */
 #define PLUGSB4RESET 100
-#define TIMEOUTSB4RESET 100
+/* after this many consecutive timeouts, use IPI to release resources */
+#define TIMEOUTSB4RESET 1
+/* at this number uses of IPI to release resources, giveup the request */
+#define IPI_RESET_LIMIT 1
+/* after this # consecutive successes, bump up the throttle if it was lowered */
+#define COMPLETE_THRESHOLD 5
 
 /*
  * number of entries in the destination side payload queue
@@ -96,6 +108,13 @@
 #define FLUSH_COMPLETE			4
 
 /*
+ * tuning the action when the numalink network is extremely delayed
+ */
+#define CONGESTED_RESPONSE_US 1000 /* 'long' response time, in microseconds */
+#define CONGESTED_REPS 10 /* long delays averaged over this many broadcasts */
+#define CONGESTED_PERIOD 30 /* time for the bau to be disabled, in seconds */
+
+/*
  * Distribution: 32 bytes (256 bits) (bytes 0-0x1f of descriptor)
  * If the 'multilevel' flag in the header portion of the descriptor
  * has been set to 0, then endpoint multi-unicast mode is selected.
@@ -300,37 +319,16 @@ struct bau_payload_queue_entry {
 	/* bytes 24-31 */
 };
 
-/*
- * one per-cpu; to locate the software tables
- */
-struct bau_control {
-	struct bau_desc *descriptor_base;
+struct msg_desc {
+	struct bau_payload_queue_entry *msg;
+	int msg_slot;
+	int sw_ack_slot;
 	struct bau_payload_queue_entry *va_queue_first;
 	struct bau_payload_queue_entry *va_queue_last;
-	struct bau_payload_queue_entry *bau_msg_head;
-	struct bau_control *uvhub_master;
-	struct bau_control *socket_master;
-	unsigned long timeout_interval;
-	atomic_t active_descriptor_count;
-	int max_concurrent;
-	int max_concurrent_constant;
-	int retry_message_scans;
-	int plugged_tries;
-	int timeout_tries;
-	int ipi_attempts;
-	int conseccompletes;
-	short cpu;
-	short uvhub_cpu;
-	short uvhub;
-	short cpus_in_socket;
-	short cpus_in_uvhub;
-	unsigned short message_number;
-	unsigned short uvhub_quiesce;
-	short socket_acknowledge_count[DEST_Q_SIZE];
-	cycles_t send_message;
-	spinlock_t masks_lock;
-	spinlock_t uvhub_lock;
-	spinlock_t queue_lock;
+};
+
+struct reset_args {
+	int sender;
 };
 
 /*
@@ -344,18 +342,25 @@ struct ptc_stats {
 	unsigned long s_dtimeout; /* destination side timeouts */
 	unsigned long s_time; /* time spent in sending side */
 	unsigned long s_retriesok; /* successful retries */
-	unsigned long s_ntargcpu; /* number of cpus targeted */
-	unsigned long s_ntarguvhub; /* number of uvhubs targeted */
-	unsigned long s_ntarguvhub16; /* number of times >= 16 target hubs */
-	unsigned long s_ntarguvhub8; /* number of times >= 8 target hubs */
-	unsigned long s_ntarguvhub4; /* number of times >= 4 target hubs */
-	unsigned long s_ntarguvhub2; /* number of times >= 2 target hubs */
-	unsigned long s_ntarguvhub1; /* number of times == 1 target hub */
+	unsigned long s_ntargcpu; /* total number of cpu's targeted */
+	unsigned long s_ntargself; /* times the sending cpu was targeted */
+	unsigned long s_ntarglocals; /* targets of cpus on the local blade */
+	unsigned long s_ntargremotes; /* targets of cpus on remote blades */
+	unsigned long s_ntarglocaluvhub; /* targets of the local hub */
+	unsigned long s_ntargremoteuvhub; /* remotes hubs targeted */
+	unsigned long s_ntarguvhub; /* total number of uvhubs targeted */
+	unsigned long s_ntarguvhub16; /* number of times target hubs >= 16*/
+	unsigned long s_ntarguvhub8; /* number of times target hubs >= 8 */
+	unsigned long s_ntarguvhub4; /* number of times target hubs >= 4 */
+	unsigned long s_ntarguvhub2; /* number of times target hubs >= 2 */
+	unsigned long s_ntarguvhub1; /* number of times target hubs == 1 */
 	unsigned long s_resets_plug; /* ipi-style resets from plug state */
 	unsigned long s_resets_timeout; /* ipi-style resets from timeouts */
 	unsigned long s_busy; /* status stayed busy past s/w timer */
 	unsigned long s_throttles; /* waits in throttle */
 	unsigned long s_retry_messages; /* retry broadcasts */
+	unsigned long s_bau_reenabled; /* for bau enable/disable */
+	unsigned long s_bau_disabled; /* for bau enable/disable */
 	/* destination statistics */
 	unsigned long d_alltlb; /* times all tlb's on this cpu were flushed */
 	unsigned long d_onetlb; /* times just one tlb on this cpu was flushed */
@@ -368,6 +373,57 @@ struct ptc_stats {
 	unsigned long d_nocanceled; /* retries that found nothing to cancel */
 	unsigned long d_resets; /* number of ipi-style requests processed */
 	unsigned long d_rcanceled; /* number of messages canceled by resets */
+	unsigned long s_ipis;
+	unsigned long s_ipitime;
+};
+
+/*
+ * one per-cpu; to locate the software tables
+ */
+struct bau_control {
+	struct bau_desc *descriptor_base;
+	struct bau_payload_queue_entry *va_queue_first;
+	struct bau_payload_queue_entry *va_queue_last;
+	struct bau_payload_queue_entry *bau_msg_head;
+	struct bau_control *uvhub_master;
+	struct bau_control *socket_master;
+	struct ptc_stats *statp;
+	unsigned long timeout_interval;
+	unsigned long set_bau_on_time;
+	atomic_t active_descriptor_count;
+	int plugged_tries;
+	int timeout_tries;
+	int ipi_attempts;
+	int conseccompletes;
+	int nobau;
+	int bauon;
+	int recovery;
+	int baudisabled;
+	int set_bau_off;
+	short cpu;
+	short uvhub_cpu;
+	short uvhub;
+	short cpus_in_socket;
+	short cpus_in_uvhub;
+	unsigned short message_number;
+	unsigned short uvhub_quiesce;
+	short socket_acknowledge_count[DEST_Q_SIZE];
+	cycles_t send_message;
+	spinlock_t uvhub_lock;
+	spinlock_t queue_lock;
+	/* tunables */
+	int max_bau_concurrent;
+	int max_bau_concurrent_constant;
+	int plugged_delay;
+	int plugsb4reset;
+	int timeoutsb4reset;
+	int ipi_reset_limit;
+	int complete_threshold;
+	int congested_response_us;
+	int congested_reps;
+	int congested_period;
+	cycles_t period_time;
+	long period_requests;
 };
 
 static inline int bau_uvhub_isset(int uvhub, struct bau_target_uvhubmask *dstp)
Index: 100528.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100528.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100528.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -9,7 +9,6 @@
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
 
 #include <asm/mmu_context.h>
 #include <asm/uv/uv.h>
@@ -22,22 +21,41 @@
 #include <asm/irq_vectors.h>
 #include <asm/timer.h>
 
-struct msg_desc {
-	struct bau_payload_queue_entry *msg;
-	int msg_slot;
-	int sw_ack_slot;
-	struct bau_payload_queue_entry *va_queue_first;
-	struct bau_payload_queue_entry *va_queue_last;
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
 };
-
-#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD	0x000000000bUL
-
-static int uv_bau_max_concurrent __read_mostly;
-
+static int timeout_us;
 static int nobau;
+static int baudisabled;
+static int bauon = 1;
+static int bau_timeout_recovery = 1;
+static spinlock_t disable_lock;
+static cycles_t congested_cycles;
+
+/* tunables: */
+static int max_bau_concurrent = MAX_BAU_CONCURRENT;
+static int max_bau_concurrent_constant = MAX_BAU_CONCURRENT;
+static int plugged_delay = PLUGGED_DELAY;
+static int plugsb4reset = PLUGSB4RESET;
+static int timeoutsb4reset = TIMEOUTSB4RESET;
+static int ipi_reset_limit = IPI_RESET_LIMIT;
+static int complete_threshold = COMPLETE_THRESHOLD;
+static int congested_response_us = CONGESTED_RESPONSE_US;
+static int congested_reps = CONGESTED_REPS;
+static int congested_period = CONGESTED_PERIOD;
+
 static int __init setup_nobau(char *arg)
 {
 	nobau = 1;
+	bauon = 0;
 	return 0;
 }
 early_param("nobau", setup_nobau);
@@ -52,10 +70,6 @@ static DEFINE_PER_CPU(struct ptc_stats, 
 static DEFINE_PER_CPU(struct bau_control, bau_control);
 static DEFINE_PER_CPU(cpumask_var_t, uv_flush_tlb_mask);
 
-struct reset_args {
-	int sender;
-};
-
 /*
  * Determine the first node on a uvhub. 'Nodes' are used for kernel
  * memory allocation.
@@ -126,7 +140,7 @@ static inline void uv_bau_process_retry_
 	struct ptc_stats *stat;
 
 	msg = mdp->msg;
-	stat = &per_cpu(ptcstats, bcp->cpu);
+	stat = bcp->statp;
 	stat->d_retries++;
 	/*
 	 * cancel any message from msg+1 to the retry itself
@@ -146,15 +160,14 @@ static inline void uv_bau_process_retry_
 			slot2 = msg2 - mdp->va_queue_first;
 			mmr = uv_read_local_mmr
 				(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
-			msg_res = ((msg2->sw_ack_vector << 8) |
-				   msg2->sw_ack_vector);
+			msg_res = msg2->sw_ack_vector;
 			/*
 			 * This is a message retry; clear the resources held
 			 * by the previous message only if they timed out.
 			 * If it has not timed out we have an unexpected
 			 * situation to report.
 			 */
-			if (mmr & (msg_res << 8)) {
+			if (mmr & (msg_res << UV_SW_ACK_NPENDING)) {
 				/*
 				 * is the resource timed out?
 				 * make everyone ignore the cancelled message.
@@ -164,9 +177,9 @@ static inline void uv_bau_process_retry_
 				cancel_count++;
 				uv_write_local_mmr(
 				    UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS,
-					(msg_res << 8) | msg_res);
-			} else
-				printk(KERN_INFO "note bau retry: no effect\n");
+					(msg_res << UV_SW_ACK_NPENDING) |
+					 msg_res);
+			}
 		}
 	}
 	if (!cancel_count)
@@ -190,7 +203,7 @@ static void uv_bau_process_message(struc
 	 * This must be a normal message, or retry of a normal message
 	 */
 	msg = mdp->msg;
-	stat = &per_cpu(ptcstats, bcp->cpu);
+	stat = bcp->statp;
 	if (msg->address == TLB_FLUSH_ALL) {
 		local_flush_tlb();
 		stat->d_alltlb++;
@@ -274,7 +287,7 @@ uv_do_reset(void *ptr)
 
 	bcp = &per_cpu(bau_control, smp_processor_id());
 	rap = (struct reset_args *)ptr;
-	stat = &per_cpu(ptcstats, bcp->cpu);
+	stat = bcp->statp;
 	stat->d_resets++;
 
 	/*
@@ -302,13 +315,13 @@ uv_do_reset(void *ptr)
 			 */
 			mmr = uv_read_local_mmr
 					(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
-			msg_res = ((msg->sw_ack_vector << 8) |
-						   msg->sw_ack_vector);
+			msg_res = msg->sw_ack_vector;
 			if (mmr & msg_res) {
 				stat->d_rcanceled++;
 				uv_write_local_mmr(
 				    UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS,
-							msg_res);
+					(msg_res << UV_SW_ACK_NPENDING) |
+					 msg_res);
 			}
 		}
 	}
@@ -386,17 +399,12 @@ static int uv_wait_completion(struct bau
 	unsigned long mmr_offset, int right_shift, int this_cpu,
 	struct bau_control *bcp, struct bau_control *smaster, long try)
 {
-	int relaxes = 0;
 	unsigned long descriptor_status;
-	unsigned long mmr;
-	unsigned long mask;
 	cycles_t ttime;
-	cycles_t timeout_time;
-	struct ptc_stats *stat = &per_cpu(ptcstats, this_cpu);
+	struct ptc_stats *stat = bcp->statp;
 	struct bau_control *hmaster;
 
 	hmaster = bcp->uvhub_master;
-	timeout_time = get_cycles() + bcp->timeout_interval;
 
 	/* spin on the status MMR, waiting for it to go idle */
 	while ((descriptor_status = (((unsigned long)
@@ -423,7 +431,8 @@ static int uv_wait_completion(struct bau
 			 * pending.  In that case hardware returns the
 			 * ERROR that looks like a destination timeout.
 			 */
-			if (cycles_2_us(ttime - bcp->send_message) < BIOS_TO) {
+			if (cycles_2_us(ttime - bcp->send_message) <
+							timeout_us) {
 				bcp->conseccompletes = 0;
 				return FLUSH_RETRY_PLUGGED;
 			}
@@ -435,26 +444,6 @@ static int uv_wait_completion(struct bau
 			 * descriptor_status is still BUSY
 			 */
 			cpu_relax();
-			relaxes++;
-			if (relaxes >= 10000) {
-				relaxes = 0;
-				if (get_cycles() > timeout_time) {
-					quiesce_local_uvhub(hmaster);
-
-					/* single-thread the register change */
-					spin_lock(&hmaster->masks_lock);
-					mmr = uv_read_local_mmr(mmr_offset);
-					mask = 0UL;
-					mask |= (3UL < right_shift);
-					mask = ~mask;
-					mmr &= mask;
-					uv_write_local_mmr(mmr_offset, mmr);
-					spin_unlock(&hmaster->masks_lock);
-					end_uvhub_quiesce(hmaster);
-					stat->s_busy++;
-					return FLUSH_GIVEUP;
-				}
-			}
 		}
 	}
 	bcp->conseccompletes++;
@@ -499,49 +488,47 @@ static inline int atomic_inc_unless_ge(s
  *
  * Send a broadcast and wait for it to complete.
  *
- * The flush_mask contains the cpus the broadcast is to be sent to, plus
+ * The flush_mask contains the cpus the broadcast is to be sent to including
  * cpus that are on the local uvhub.
  *
- * Returns NULL if all flushing represented in the mask was done. The mask
- * is zeroed.
- * Returns @flush_mask if some remote flushing remains to be done. The
- * mask will have some bits still set, representing any cpus on the local
- * uvhub (not current cpu) and any on remote uvhubs if the broadcast failed.
- */
-const struct cpumask *uv_flush_send_and_wait(struct bau_desc *bau_desc,
-					     struct cpumask *flush_mask,
-					     struct bau_control *bcp)
+ * Returns 0 if all flushing represented in the mask was done.
+ * Returns 1 if it gives up entirely and the original cpu mask is to be
+ * returned to the kernel.
+ */
+int uv_flush_send_and_wait(struct bau_desc *bau_desc,
+			   struct cpumask *flush_mask, struct bau_control *bcp)
 {
 	int right_shift;
-	int uvhub;
-	int bit;
 	int completion_status = 0;
 	int seq_number = 0;
 	long try = 0;
 	int cpu = bcp->uvhub_cpu;
+	int tcpu;
 	int this_cpu = bcp->cpu;
-	int this_uvhub = bcp->uvhub;
 	unsigned long mmr_offset;
 	unsigned long index;
 	cycles_t time1;
 	cycles_t time2;
-	struct ptc_stats *stat = &per_cpu(ptcstats, bcp->cpu);
+	cycles_t elapsed;
+	cycles_t local_congested_cycles = congested_cycles;
+	struct ptc_stats *stat = bcp->statp;
 	struct bau_control *smaster = bcp->socket_master;
 	struct bau_control *hmaster = bcp->uvhub_master;
+	struct bau_control *tbcp;
 
 	/*
-	 * Spin here while there are hmaster->max_concurrent or more active
+	 * Spin here while there are hmaster->max_bau_concurrent or more active
 	 * descriptors. This is the per-uvhub 'throttle'.
 	 */
 	if (!atomic_inc_unless_ge(&hmaster->uvhub_lock,
 			&hmaster->active_descriptor_count,
-			hmaster->max_concurrent)) {
+			hmaster->max_bau_concurrent)) {
 		stat->s_throttles++;
 		do {
 			cpu_relax();
 		} while (!atomic_inc_unless_ge(&hmaster->uvhub_lock,
 			&hmaster->active_descriptor_count,
-			hmaster->max_concurrent));
+			hmaster->max_bau_concurrent));
 	}
 
 	while (hmaster->uvhub_quiesce)
@@ -570,10 +557,9 @@ const struct cpumask *uv_flush_send_and_
 		 * free any resource held by a previous message from this cpu.
 		 */
 		if (try == 0) {
-			/* use message type set by the caller the first time */
+			bau_desc->header.msg_type = MSG_REGULAR;
 			seq_number = bcp->message_number++;
 		} else {
-			/* use RETRY type on all the rest; same sequence */
 			bau_desc->header.msg_type = MSG_RETRY;
 			stat->s_retry_messages++;
 		}
@@ -595,9 +581,9 @@ const struct cpumask *uv_flush_send_and_
 			 * that case hardware immediately returns the ERROR
 			 * that looks like a destination timeout.
 			 */
-			udelay(TIMEOUT_DELAY);
+			udelay(bcp->plugged_delay);
 			bcp->plugged_tries++;
-			if (bcp->plugged_tries >= PLUGSB4RESET) {
+			if (bcp->plugged_tries >= bcp->plugsb4reset) {
 				bcp->plugged_tries = 0;
 				quiesce_local_uvhub(hmaster);
 				spin_lock(&hmaster->queue_lock);
@@ -609,10 +595,13 @@ const struct cpumask *uv_flush_send_and_
 				stat->s_resets_plug++;
 			}
 		} else if (completion_status == FLUSH_RETRY_TIMEOUT) {
-			hmaster->max_concurrent = 1;
+			if (!bcp->recovery) {
+				completion_status = FLUSH_GIVEUP;
+				break;
+			}
+			hmaster->max_bau_concurrent = 1;
 			bcp->timeout_tries++;
-			udelay(TIMEOUT_DELAY);
-			if (bcp->timeout_tries >= TIMEOUTSB4RESET) {
+			if (bcp->timeout_tries >= bcp->timeoutsb4reset) {
 				bcp->timeout_tries = 0;
 				quiesce_local_uvhub(hmaster);
 				spin_lock(&hmaster->queue_lock);
@@ -624,7 +613,7 @@ const struct cpumask *uv_flush_send_and_
 				stat->s_resets_timeout++;
 			}
 		}
-		if (bcp->ipi_attempts >= 3) {
+		if (bcp->ipi_attempts >= bcp->ipi_reset_limit) {
 			bcp->ipi_attempts = 0;
 			completion_status = FLUSH_GIVEUP;
 			break;
@@ -634,9 +623,14 @@ const struct cpumask *uv_flush_send_and_
 		 (completion_status == FLUSH_RETRY_TIMEOUT));
 	time2 = get_cycles();
 
-	if ((completion_status == FLUSH_COMPLETE) && (bcp->conseccompletes > 5)
-	    && (hmaster->max_concurrent < hmaster->max_concurrent_constant))
-			hmaster->max_concurrent++;
+	bcp->plugged_tries = 0;
+	bcp->timeout_tries = 0;
+
+	if ((completion_status == FLUSH_COMPLETE) &&
+	    (bcp->conseccompletes > bcp->complete_threshold) &&
+	    (hmaster->max_bau_concurrent <
+					hmaster->max_bau_concurrent_constant))
+			hmaster->max_bau_concurrent++;
 
 	/*
 	 * hold any cpu not timing out here; no other cpu currently held by
@@ -647,35 +641,52 @@ const struct cpumask *uv_flush_send_and_
 	atomic_dec(&hmaster->active_descriptor_count);
 
 	/* guard against cycles wrap */
-	if (time2 > time1)
-		stat->s_time += (time2 - time1);
-	else
+	if (time2 > time1) {
+		elapsed = time2 - time1;
+		stat->s_time += elapsed;
+		/* check for a sustained long, non-timeout request times */
+		if ((completion_status == FLUSH_COMPLETE) && (try == 1)) {
+			bcp->period_requests++;
+			bcp->period_time += elapsed;
+			if ((elapsed > local_congested_cycles) &&
+			    (bcp->period_requests > bcp->congested_reps)) {
+				/* let only one cpu do this disabling */
+				spin_lock(&disable_lock);
+				if (!baudisabled && bcp->period_requests &&
+				    ((bcp->period_time / bcp->period_requests) >
+						local_congested_cycles)) {
+					/* it becomes this cpu's job to turn
+					   on the use of the BAU again */
+					baudisabled = 1;
+					bcp->set_bau_off = 1;
+					bcp->set_bau_on_time = get_cycles() +
+					sec_2_cycles(bcp->congested_period);
+					stat->s_bau_disabled++;
+					for_each_present_cpu(tcpu) {
+						tbcp = &per_cpu(bau_control,
+									tcpu);
+						tbcp->baudisabled = 1;
+					}
+				}
+				spin_unlock(&disable_lock);
+			}
+		}
+	} else
 		stat->s_requestor--; /* don't count this one */
 	if (completion_status == FLUSH_COMPLETE && try > 1)
 		stat->s_retriesok++;
 	else if (completion_status == FLUSH_GIVEUP) {
 		/*
 		 * Cause the caller to do an IPI-style TLB shootdown on
-		 * the target cpu's, all of which are still in the mask.
+		 * the target cpu's using the original mask.
 		 */
 		stat->s_giveup++;
-		return flush_mask;
+		return 1;
 	}
-
 	/*
-	 * Success, so clear the remote cpu's from the mask so we don't
-	 * use the IPI method of shootdown on them.
+	 * Success
 	 */
-	for_each_cpu(bit, flush_mask) {
-		uvhub = uv_cpu_to_blade_id(bit);
-		if (uvhub == this_uvhub)
-			continue;
-		cpumask_clear_cpu(bit, flush_mask);
-	}
-	if (!cpumask_empty(flush_mask))
-		return flush_mask;
-
-	return NULL;
+	return 0;
 }
 
 /**
@@ -707,70 +718,94 @@ const struct cpumask *uv_flush_tlb_other
 					  struct mm_struct *mm,
 					  unsigned long va, unsigned int cpu)
 {
-	int remotes;
 	int tcpu;
 	int uvhub;
 	int locals = 0;
+	int remotes = 0;
+	int hubs = 0;
 	struct bau_desc *bau_desc;
 	struct cpumask *flush_mask;
 	struct ptc_stats *stat;
 	struct bau_control *bcp;
+	struct bau_control *tbcp;
 
+	/* kernel was booted 'nobau' */
 	if (nobau)
-		return cpumask;
+		return 0;
 
 	bcp = &per_cpu(bau_control, cpu);
+	stat = bcp->statp;
+
+	/* bau was set off through /proc */
+	if (!bcp->bauon) {
+		return cpumask;
+	}
+
+	/* bau was disabled due to slow response */
+	if (bcp->baudisabled) {
+		/* the cpu that disabled it must re-enable it */
+		if (bcp->set_bau_off) {
+			if (get_cycles() >= bcp->set_bau_on_time) {
+				stat->s_bau_reenabled++;
+				baudisabled = 0;
+				for_each_present_cpu(tcpu) {
+					tbcp = &per_cpu(bau_control, tcpu);
+					tbcp->baudisabled = 0;
+					tbcp->period_requests = 0;
+					tbcp->period_time = 0;
+				}
+			}
+		}
+		return cpumask;
+	}
+
 	/*
 	 * Each sending cpu has a per-cpu mask which it fills from the caller's
-	 * cpu mask.  Only remote cpus are converted to uvhubs and copied.
+	 * cpu mask.  All cpus are converted to uvhubs and copied to the
+	 * activation descriptor.
 	 */
 	flush_mask = (struct cpumask *)per_cpu(uv_flush_tlb_mask, cpu);
-	/*
-	 * copy cpumask to flush_mask, removing current cpu
-	 * (current cpu should already have been flushed by the caller and
-	 *  should never be returned if we return flush_mask)
-	 */
+	/* don't actually do a shootdown of the local cpu */
 	cpumask_andnot(flush_mask, cpumask, cpumask_of(cpu));
 	if (cpu_isset(cpu, *cpumask))
-		locals++;  /* current cpu was targeted */
+		stat->s_ntargself++;
 
 	bau_desc = bcp->descriptor_base;
 	bau_desc += UV_ITEMS_PER_DESCRIPTOR * bcp->uvhub_cpu;
-
 	bau_uvhubs_clear(&bau_desc->distribution, UV_DISTRIBUTION_SIZE);
-	remotes = 0;
+
+	/* cpu statistics */
 	for_each_cpu(tcpu, flush_mask) {
 		uvhub = uv_cpu_to_blade_id(tcpu);
-		if (uvhub == bcp->uvhub) {
-			locals++;
-			continue;
-		}
 		bau_uvhub_set(uvhub, &bau_desc->distribution);
-		remotes++;
-	}
-	if (remotes == 0) {
-		/*
-		 * No off_hub flushing; return status for local hub.
-		 * Return the caller's mask if all were local (the current
-		 * cpu may be in that mask).
-		 */
-		if (locals)
-			return cpumask;
+		if (uvhub == bcp->uvhub)
+			locals++;
 		else
-			return NULL;
+			remotes++;
 	}
-	stat = &per_cpu(ptcstats, cpu);
+	if ((locals + remotes) == 0)
+		return NULL;
 	stat->s_requestor++;
-	stat->s_ntargcpu += remotes;
+	stat->s_ntargcpu += remotes + locals;
+	stat->s_ntargremotes += remotes;
+	stat->s_ntarglocals += locals;
 	remotes = bau_uvhub_weight(&bau_desc->distribution);
-	stat->s_ntarguvhub += remotes;
-	if (remotes >= 16)
+
+	/* uvhub statistics */
+	hubs = bau_uvhub_weight(&bau_desc->distribution);
+	if (locals) {
+		stat->s_ntarglocaluvhub++;
+		stat->s_ntargremoteuvhub += (hubs - 1);
+	} else
+		stat->s_ntargremoteuvhub += hubs;
+	stat->s_ntarguvhub += hubs;
+	if (hubs >= 16)
 		stat->s_ntarguvhub16++;
-	else if (remotes >= 8)
+	else if (hubs >= 8)
 		stat->s_ntarguvhub8++;
-	else if (remotes >= 4)
+	else if (hubs >= 4)
 		stat->s_ntarguvhub4++;
-	else if (remotes >= 2)
+	else if (hubs >= 2)
 		stat->s_ntarguvhub2++;
 	else
 		stat->s_ntarguvhub1++;
@@ -779,10 +814,13 @@ const struct cpumask *uv_flush_tlb_other
 	bau_desc->payload.sending_cpu = cpu;
 
 	/*
-	 * uv_flush_send_and_wait returns null if all cpu's were messaged, or
-	 * the adjusted flush_mask if any cpu's were not messaged.
+	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,
+	 * or 1 if it gave up and the original cpumask should be returned.
 	 */
-	return uv_flush_send_and_wait(bau_desc, flush_mask, bcp);
+	if (!uv_flush_send_and_wait(bau_desc, flush_mask, bcp))
+		return NULL;
+	else
+		return cpumask;
 }
 
 /*
@@ -810,7 +848,7 @@ void uv_bau_message_interrupt(struct pt_
 
 	time_start = get_cycles();
 	bcp = &per_cpu(bau_control, smp_processor_id());
-	stat = &per_cpu(ptcstats, smp_processor_id());
+	stat = bcp->statp;
 	msgdesc.va_queue_first = bcp->va_queue_first;
 	msgdesc.va_queue_last = bcp->va_queue_last;
 	msg = bcp->bau_msg_head;
@@ -908,12 +946,12 @@ static void uv_ptc_seq_stop(struct seq_f
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
@@ -931,15 +969,21 @@ static int uv_ptc_seq_show(struct seq_fi
 
 	if (!cpu) {
 		seq_printf(file,
-			"# cpu sent stime numuvhubs numuvhubs16 numuvhubs8 ");
+			"# cpu sent stime self locals remotes ncpus localhub ");
+		seq_printf(file,
+			"remotehub numuvhubs numuvhubs16 numuvhubs8 ");
 		seq_printf(file,
-			"numuvhubs4 numuvhubs2 numuvhubs1 numcpus dto ");
+			"numuvhubs4 numuvhubs2 numuvhubs1 dto ");
 		seq_printf(file,
 			"retries rok resetp resett giveup sto bz throt ");
 		seq_printf(file,
 			"sw_ack recv rtime all ");
 		seq_printf(file,
-			"one mult none retry canc nocan reset rcan\n");
+			"one mult none retry canc nocan reset rcan ");
+		seq_printf(file,
+			"disable enable ");
+		seq_printf(file,
+			"ipis ipitime\n");
 	}
 	if (cpu < num_possible_cpus() && cpu_online(cpu)) {
 		stat = &per_cpu(ptcstats, cpu);
@@ -947,18 +991,23 @@ static int uv_ptc_seq_show(struct seq_fi
 		seq_printf(file,
 			"cpu %d %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld ",
 			   cpu, stat->s_requestor, cycles_2_us(stat->s_time),
-			   stat->s_ntarguvhub, stat->s_ntarguvhub16,
+			   stat->s_ntargself, stat->s_ntarglocals,
+			   stat->s_ntargremotes, stat->s_ntargcpu,
+			   stat->s_ntarglocaluvhub, stat->s_ntargremoteuvhub,
+			   stat->s_ntarguvhub, stat->s_ntarguvhub16);
+		seq_printf(file, "%ld %ld %ld %ld %ld ",
 			   stat->s_ntarguvhub8, stat->s_ntarguvhub4,
 			   stat->s_ntarguvhub2, stat->s_ntarguvhub1,
-			   stat->s_ntargcpu, stat->s_dtimeout);
+			   stat->s_dtimeout);
 		seq_printf(file, "%ld %ld %ld %ld %ld %ld %ld %ld ",
 			   stat->s_retry_messages, stat->s_retriesok,
 			   stat->s_resets_plug, stat->s_resets_timeout,
 			   stat->s_giveup, stat->s_stimeout,
 			   stat->s_busy, stat->s_throttles);
+
 		/* destination side statistics */
 		seq_printf(file,
-			   "%lx %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld\n",
+			   "%lx %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld ",
 			   uv_read_global_mmr64(uv_cpu_to_pnode(cpu),
 					UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE),
 			   stat->d_requestee, cycles_2_us(stat->d_time),
@@ -966,20 +1015,89 @@ static int uv_ptc_seq_show(struct seq_fi
 			   stat->d_nomsg, stat->d_retries, stat->d_canceled,
 			   stat->d_nocanceled, stat->d_resets,
 			   stat->d_rcanceled);
+		seq_printf(file, "%ld %ld ",
+			stat->s_bau_disabled, stat->s_bau_reenabled);
+		seq_printf(file, "%ld %ld\n",
+			   stat->s_ipis, cycles_2_us(stat->s_ipitime));
 	}
 
 	return 0;
 }
 
 /*
+ * Display any pending software acknowledge hardware resource
+ * bit.
+ */
+static void uv_display_uvhub_swack_resources(void)
+{
+	int uvhub;
+	int pnode;
+	int count = 0;
+	unsigned long dw;
+
+	for_each_possible_blade(uvhub) {
+		pnode = uv_blade_to_pnode(uvhub);
+		dw = uv_read_global_mmr64 (
+			pnode, UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
+		if (dw) {
+			count++;
+			printk(KERN_DEBUG "uvhub %d state: %#lx\n", uvhub, dw);
+		}
+	}
+	if (count == 0)
+		printk(KERN_DEBUG "No nonzero BAU resource state to display\n");
+}
+
+/*
+ * free any software-acknowledge resources
+ */
+static int
+reset_all_baus(void)
+{
+	int uvhub;
+	int pnode;
+	int count = 0;
+	unsigned long dw;
+
+	for_each_possible_blade(uvhub) {
+		pnode = uv_blade_to_pnode(uvhub);
+		dw = uv_read_global_mmr64 (
+			pnode, UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
+		if (dw) {
+			count++;
+			uv_write_global_mmr64 (pnode,
+				UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS, dw);
+		}
+	}
+	return count;
+}
+
+/*
+ * Display the tunables thru /proc.
+ */
+static int uv_bau_show(struct seq_file *file, void *p)
+{
+	seq_printf(file, "max_bau_concurrent plugged_delay plugsb4reset ");
+	seq_printf(file, "timeoutsb4reset ipi_reset_limit complete_threshold ");
+	seq_printf(file, "congested_response_us congested_reps ");
+	seq_printf(file, "congested_period\n");
+	seq_printf(file, "%d %d %d %d %d %d %d %d %d\n",
+		max_bau_concurrent, plugged_delay, plugsb4reset,
+		timeoutsb4reset, ipi_reset_limit, complete_threshold,
+		congested_response_us, congested_reps, congested_period);
+
+	return 0;
+}
+
+/*
  * -1: resetf the statistics
  *  0: display meaning of the statistics
- * >0: maximum concurrent active descriptors per uvhub (throttle)
  */
 static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
 				 size_t count, loff_t *data)
 {
 	int cpu;
+	int ret;
 	long input_arg;
 	char optstr[64];
 	struct ptc_stats *stat;
@@ -1059,32 +1177,235 @@ static ssize_t uv_ptc_proc_write(struct 
 		"reset:    number of ipi-style reset requests processed\n");
 		printk(KERN_DEBUG
 		"rcan:     number messages canceled by reset requests\n");
+		printk(KERN_DEBUG
+		"disable:  number times use of the BAU was disabled\n");
+		printk(KERN_DEBUG
+		"enable:   number times use of the BAU was re-enabled\n");
+		printk(KERN_DEBUG
+		"ipis:     number IPI shootdowns\n");
+		printk(KERN_DEBUG
+		"ipitime:  IPI shootdown time\n");
 	} else if (input_arg == -1) {
 		for_each_present_cpu(cpu) {
 			stat = &per_cpu(ptcstats, cpu);
 			memset(stat, 0, sizeof(struct ptc_stats));
 		}
-	} else {
-		uv_bau_max_concurrent = input_arg;
-		bcp = &per_cpu(bau_control, smp_processor_id());
-		if (uv_bau_max_concurrent < 1 ||
-		    uv_bau_max_concurrent > bcp->cpus_in_uvhub) {
+	} else if (input_arg == -2) {
+		if (nobau) {
 			printk(KERN_DEBUG
-				"Error: BAU max concurrent %d; %d is invalid\n",
-				bcp->max_concurrent, uv_bau_max_concurrent);
+			"cannot turn BAU on; booted nobau\n");
 			return -EINVAL;
 		}
-		printk(KERN_DEBUG "Set BAU max concurrent:%d\n",
-		       uv_bau_max_concurrent);
+		printk(KERN_DEBUG "turned BAU on\n");
+		bauon = 1;
 		for_each_present_cpu(cpu) {
 			bcp = &per_cpu(bau_control, cpu);
-			bcp->max_concurrent = uv_bau_max_concurrent;
+			bcp->bauon = 1;
+		}
+	} else if (input_arg == -3) {
+		printk(KERN_DEBUG "turned BAU off\n");
+		bauon = 0;
+		for_each_present_cpu(cpu) {
+			bcp = &per_cpu(bau_control, cpu);
+			bcp->bauon = 0;
+		}
+	} else if (input_arg == -4) {
+		if (bauon)
+			printk(KERN_DEBUG "BAU is on\n");
+		else
+			printk(KERN_DEBUG "BAU is off\n");
+		uv_display_uvhub_swack_resources();
+		printk(KERN_DEBUG "destination timeout is %dus (%lld cycles)\n",
+			timeout_us,
+			microsec_2_cycles((unsigned long)timeout_us));
+		printk(KERN_DEBUG "congestion: %dus %lld cycles\n",
+			CONGESTED_RESPONSE_US, congested_cycles);
+		printk(KERN_DEBUG "destination timeout recovery is %d\n",
+			bau_timeout_recovery);
+		printk(KERN_DEBUG "baudisabled: %d\n", baudisabled);
+	} else if (input_arg == -5) {
+		if (nobau) {
+ 			printk(KERN_DEBUG
+			"cannot reset or free BAU resources; booted nobau\n");
+ 			return -EINVAL;
+ 		}
+		if (bauon) {
+ 			printk(KERN_DEBUG
+			"cannot reset or free BAU resources; currently on\n");
+ 			return -EINVAL;
+ 		}
+		ret = reset_all_baus();
+		if (!ret)
+			printk(KERN_DEBUG "No BAU resources needed freeing\n");
+		else
+			printk(KERN_DEBUG "BAU resources freed on %d uvhubs\n",
+				ret);
+		baudisabled = 0;
+		for_each_present_cpu(cpu) {
+			bcp = &per_cpu(bau_control, cpu);
+			bcp->baudisabled = 0;
+		}
+		printk(KERN_DEBUG "BAU marked enabled on all cpu's\n");
+	} else if (input_arg == -6) {
+		bau_timeout_recovery = 1;
+		printk(KERN_DEBUG "Turned on BAU timeout recovery\n");
+		for_each_present_cpu(cpu) {
+			bcp = &per_cpu(bau_control, cpu);
+			bcp->recovery = bau_timeout_recovery;
+		}
+	} else if (input_arg == -7) {
+		bau_timeout_recovery = 0;
+		printk(KERN_DEBUG "Turned off BAU timeout recovery\n");
+		for_each_present_cpu(cpu) {
+			bcp = &per_cpu(bau_control, cpu);
+			bcp->recovery = bau_timeout_recovery;
 		}
 	}
 
 	return count;
 }
 
+static int local_atoi(const char *name)
+{
+	int val = 0;
+
+	for (;; name++) {
+		switch (*name) {
+		case '0' ... '9':
+			val = 10*val+(*name-'0');
+			break;
+		default:
+			return val;
+		}
+	}
+}
+
+/*
+ * set the tunables
+ * 0 values reset them to defaults
+ */
+static ssize_t uv_bau_proc_write(struct file *file, const char __user *user,
+				 size_t count, loff_t *data)
+{
+	int cpu;
+	int cnt = 0;
+	int val;
+	char *p;
+	char *q;
+	char instr[64];
+	struct bau_control *bcp;
+
+	if (count == 0 || count > sizeof(instr)-1)
+		return -EINVAL;
+	if (copy_from_user(instr, user, count))
+		return -EFAULT;
+
+	instr[count] = '\0';
+	/* count the fields */
+	p = instr + strspn(instr, WHITESPACE);
+	q = p;
+	for (; *p; p = q + strspn(q, WHITESPACE)) {
+		q = p + strcspn(p, WHITESPACE);
+		cnt++;
+		if (q == p)
+			break;
+	}
+	if (cnt != 9) {
+		printk(KERN_INFO "bau tunable error: should be 9 numbers\n");
+		return -EINVAL;
+	}
+
+	p = instr + strspn(instr, WHITESPACE);
+	q = p;
+	for (cnt = 0; *p; p = q + strspn(q, WHITESPACE), cnt++) {
+		q = p + strcspn(p, WHITESPACE);
+		val = local_atoi(p);
+		switch (cnt) {
+		case 0:
+			if (val == 0) {
+				max_bau_concurrent = MAX_BAU_CONCURRENT;
+				max_bau_concurrent_constant =
+							MAX_BAU_CONCURRENT;
+				continue;
+			}
+			bcp = &per_cpu(bau_control, smp_processor_id());
+			if (val < 1 || val > bcp->cpus_in_uvhub) {
+				printk(KERN_DEBUG
+				"Error: BAU max concurrent %d is invalid\n",
+				val);
+				return -EINVAL;
+			}
+			max_bau_concurrent = val;
+			max_bau_concurrent_constant = val;
+			continue;
+		case 1:
+			if (val == 0)
+				plugged_delay = PLUGGED_DELAY;
+			else
+				plugged_delay = val;
+			continue;
+		case 2:
+			if (val == 0)
+				plugsb4reset = PLUGSB4RESET;
+			else
+				plugsb4reset = val;
+			continue;
+		case 3:
+			if (val == 0)
+				timeoutsb4reset = TIMEOUTSB4RESET;
+			else
+				timeoutsb4reset = val;
+			continue;
+		case 4:
+			if (val == 0)
+				ipi_reset_limit = IPI_RESET_LIMIT;
+			else
+				ipi_reset_limit = val;
+			continue;
+		case 5:
+			if (val == 0)
+				complete_threshold = COMPLETE_THRESHOLD;
+			else
+				complete_threshold = val;
+			continue;
+		case 6:
+			if (val == 0)
+				congested_response_us = CONGESTED_RESPONSE_US;
+			else
+				congested_response_us = val;
+			continue;
+		case 7:
+			if (val == 0)
+				congested_reps = CONGESTED_REPS;
+			else
+				congested_reps = val;
+			continue;
+		case 8:
+			if (val == 0)
+				congested_period = CONGESTED_PERIOD;
+			else
+				congested_period = val;
+			continue;
+		}
+		if (q == p)
+			break;
+	}
+	for_each_present_cpu(cpu) {
+		bcp = &per_cpu(bau_control, cpu);
+		bcp->max_bau_concurrent = max_bau_concurrent;
+		bcp->max_bau_concurrent_constant = max_bau_concurrent;
+		bcp->plugged_delay = plugged_delay;
+		bcp->plugsb4reset = plugsb4reset;
+		bcp->timeoutsb4reset = timeoutsb4reset;
+		bcp->ipi_reset_limit = ipi_reset_limit;
+		bcp->complete_threshold = complete_threshold;
+		bcp->congested_response_us = congested_response_us;
+		bcp->congested_reps = congested_reps;
+		bcp->congested_period = congested_period;
+	}
+	return count;
+}
+
 static const struct seq_operations uv_ptc_seq_ops = {
 	.start		= uv_ptc_seq_start,
 	.next		= uv_ptc_seq_next,
@@ -1097,6 +1418,11 @@ static int uv_ptc_proc_open(struct inode
 	return seq_open(file, &uv_ptc_seq_ops);
 }
 
+static int uv_bau_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, uv_bau_show, NULL);
+}
+
 static const struct file_operations proc_uv_ptc_operations = {
 	.open		= uv_ptc_proc_open,
 	.read		= seq_read,
@@ -1104,10 +1430,18 @@ static const struct file_operations proc
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
+static const struct file_operations proc_uv_bau_operations = {
+	.open		= uv_bau_proc_open,
+	.read		= seq_read,
+	.write		= uv_bau_proc_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
 static int __init uv_ptc_init(void)
 {
 	struct proc_dir_entry *proc_uv_ptc;
+	struct proc_dir_entry *proc_uv_bau;
 
 	if (!is_uv_system())
 		return 0;
@@ -1119,6 +1453,13 @@ static int __init uv_ptc_init(void)
 		       UV_PTC_BASENAME);
 		return -EINVAL;
 	}
+	proc_uv_bau = proc_create(UV_BAU_BASENAME, 0444, NULL,
+				  &proc_uv_bau_operations);
+	if (!proc_uv_bau) {
+		printk(KERN_ERR "unable to create %s proc entry\n",
+		       UV_BAU_BASENAME);
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -1259,15 +1600,44 @@ static void __init uv_init_uvhub(int uvh
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
 {
-	int i, j, k;
+	int i;
 	int cpu;
 	int pnode;
 	int uvhub;
 	short socket = 0;
+	unsigned short socket_mask;
+	unsigned int uvhub_mask;
 	struct bau_control *bcp;
 	struct uvhub_desc *bdp;
 	struct socket_desc *sdp;
@@ -1278,7 +1648,7 @@ static void uv_init_per_cpu(int nuvhubs)
 		short cpu_number[16];
 	};
 	struct uvhub_desc {
-		short num_sockets;
+		unsigned short socket_mask;
 		short num_cpus;
 		short uvhub;
 		short pnode;
@@ -1286,57 +1656,86 @@ static void uv_init_per_cpu(int nuvhubs)
 	};
 	struct uvhub_desc *uvhub_descs;
 
+	timeout_us = calculate_destination_timeout();
+
 	uvhub_descs = (struct uvhub_desc *)
 		kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
 	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
 		memset(bcp, 0, sizeof(struct bau_control));
-		spin_lock_init(&bcp->masks_lock);
-		bcp->max_concurrent = uv_bau_max_concurrent;
 		pnode = uv_cpu_hub_info(cpu)->pnode;
 		uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
+		uvhub_mask |= (1 << uvhub);
 		bdp = &uvhub_descs[uvhub];
 		bdp->num_cpus++;
 		bdp->uvhub = uvhub;
 		bdp->pnode = pnode;
-		/* time interval to catch a hardware stay-busy bug */
-		bcp->timeout_interval = millisec_2_cycles(3);
-		/* kludge: assume uv_hub.h is constant */
-		socket = (cpu_physical_id(cpu)>>5)&1;
-		if (socket >= bdp->num_sockets)
-			bdp->num_sockets = socket+1;
+		/* kludge: 'assuming' one node per socket, and assuming that
+		   disabling a socket just leaves a gap in node numbers */
+		socket = (cpu_to_node(cpu) & 1);;
+		bdp->socket_mask |= (1 << socket);
 		sdp = &bdp->socket[socket];
 		sdp->cpu_number[sdp->num_cpus] = cpu;
 		sdp->num_cpus++;
 	}
-	socket = 0;
-	for_each_possible_blade(uvhub) {
+	uvhub = 0;
+	while (uvhub_mask) {
+		if (!(uvhub_mask & 1))
+			goto nexthub;
 		bdp = &uvhub_descs[uvhub];
-		for (i = 0; i < bdp->num_sockets; i++) {
-			sdp = &bdp->socket[i];
-			for (j = 0; j < sdp->num_cpus; j++) {
-				cpu = sdp->cpu_number[j];
+		socket_mask = bdp->socket_mask;
+		socket = 0;
+		while (socket_mask) {
+			if (!(socket_mask & 1))
+				goto nextsocket;
+			sdp = &bdp->socket[socket];
+			for (i = 0; i < sdp->num_cpus; i++) {
+				cpu = sdp->cpu_number[i];
 				bcp = &per_cpu(bau_control, cpu);
 				bcp->cpu = cpu;
-				if (j == 0) {
+				if (i == 0) {
 					smaster = bcp;
-					if (i == 0)
+					if (socket == 0)
 						hmaster = bcp;
 				}
 				bcp->cpus_in_uvhub = bdp->num_cpus;
 				bcp->cpus_in_socket = sdp->num_cpus;
 				bcp->socket_master = smaster;
+				bcp->uvhub = bdp->uvhub;
 				bcp->uvhub_master = hmaster;
-				for (k = 0; k < DEST_Q_SIZE; k++)
-					bcp->socket_acknowledge_count[k] = 0;
-				bcp->uvhub_cpu =
-				  uv_cpu_hub_info(cpu)->blade_processor_id;
+				bcp->uvhub_cpu = uv_cpu_hub_info(cpu)->
+						blade_processor_id;
 			}
+nextsocket:
 			socket++;
+			socket_mask = (socket_mask >> 1);
 		}
+nexthub:
+		uvhub++;
+		uvhub_mask = (uvhub_mask >> 1);
 	}
 	kfree(uvhub_descs);
+	for_each_present_cpu(cpu) {
+		bcp = &per_cpu(bau_control, cpu);
+		bcp->baudisabled = 0;
+		bcp->statp = &per_cpu(ptcstats, cpu);
+		/* time interval to catch a hardware stay-busy bug */
+		bcp->timeout_interval = microsec_2_cycles(2*timeout_us);
+		bcp->max_bau_concurrent = max_bau_concurrent;
+		bcp->max_bau_concurrent_constant = max_bau_concurrent;
+		bcp->plugged_delay = plugged_delay;
+		bcp->plugsb4reset = plugsb4reset;
+		bcp->timeoutsb4reset = timeoutsb4reset;
+		bcp->ipi_reset_limit = ipi_reset_limit;
+		bcp->complete_threshold = complete_threshold;
+		bcp->congested_response_us = congested_response_us;
+		bcp->congested_reps = congested_reps;
+		bcp->congested_period = congested_period;
+		bcp->nobau = nobau;
+		bcp->bauon = bauon;
+		bcp->recovery = bau_timeout_recovery;
+	}
 }
 
 /*
@@ -1361,10 +1760,11 @@ static int __init uv_bau_init(void)
 		zalloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
 				       GFP_KERNEL, cpu_to_node(cur_cpu));
 
-	uv_bau_max_concurrent = MAX_BAU_CONCURRENT;
 	uv_nshift = uv_hub_info->m_val;
 	uv_mmask = (1UL << uv_hub_info->m_val) - 1;
 	nuvhubs = uv_num_possible_blades();
+	spin_lock_init(&disable_lock);
+	congested_cycles = microsec_2_cycles(congested_response_us);
 
 	uv_init_per_cpu(nuvhubs);
 
