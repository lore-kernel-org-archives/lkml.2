Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1EQORb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:17:31 -0400
Received: from relay3.sgi.com ([192.48.152.1]:34259 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754793Ab1EQOR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:17:29 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV uv_tlb.c cleanup
Cc: mingo@elte.hu
Message-Id: <E1QML7f-00070E-36@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 17 May 2011 09:19:43 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


General readability cleanup of tlb_uv.c (as promised to Ingo). Now:
- no function has over 50 non-comment lines
- very few statements of over 80 characters need to be broken

Split long functions into shorter logical functions.
Shortened some variable and structure member names.
Added special functions for reads and writes of MMR regs with very long names.
Added the 'tunables' table to shortened tunables_write().
Added the 'stat_description' table to shorten uv_ptc_proc_write().
Pass fewer 'stat' arguments where it can be derived from the 'bcp' argument.
Function definitions consistent on one line, and inline in few (short) cases.
Moved some small structures and an atomic inline function to the header file.
Moved some local variables to the blocks where they are used.
Updated copyright date.

One logic difference:
Breaking uv_init_per_cpu() into get_cpu_topology() and summarize_uvhub_sockets()
actually corrects a possible bug for the theoretical case in which there is a
missing socket on a blade. An 'smaster' (socket master) had been expected for
every socket.

Diffed against 2.6.39.rc7

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/include/asm/uv/uv_bau.h |  168 ++++-
 arch/x86/platform/uv/tlb_uv.c    | 1254 +++++++++++++++++++--------------------
 2 files changed, 776 insertions(+), 646 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linux/arch/x86/include/asm/uv/uv_bau.h
@@ -35,9 +35,9 @@
 
 #define MAX_CPUS_PER_UVHUB		64
 #define MAX_CPUS_PER_SOCKET		32
-#define UV_ADP_SIZE			64 /* hardware-provided max. */
-#define UV_CPUS_PER_ACT_STATUS		32 /* hardware-provided max. */
-#define UV_ITEMS_PER_DESCRIPTOR		8
+#define ADP_SZ				64 /* hardware-provided max. */
+#define UV_CPUS_PER_AS			32 /* hardware-provided max. */
+#define ITEMS_PER_DESC			8
 /* the 'throttle' to prevent the hardware stay-busy bug */
 #define MAX_BAU_CONCURRENT		3
 #define UV_ACT_STATUS_MASK		0x3
@@ -48,7 +48,7 @@
 #define UV2_NET_ENDPOINT_INTD		0x28
 #define UV_NET_ENDPOINT_INTD		(is_uv1_hub() ?			\
 			UV1_NET_ENDPOINT_INTD : UV2_NET_ENDPOINT_INTD)
-#define UV_DESC_BASE_PNODE_SHIFT	49
+#define UV_DESC_PSHIFT			49
 #define UV_PAYLOADQ_PNODE_SHIFT		49
 #define UV_PTC_BASENAME			"sgi_uv/ptc_statistics"
 #define UV_BAU_BASENAME			"sgi_uv/bau_tunables"
@@ -85,12 +85,20 @@
 #define BAU_TRANS_MASK 0x3f
 
 /*
+ * shorten some awkward names
+ */
+#define AS_PUSH_SHIFT UVH_LB_BAU_SB_ACTIVATION_CONTROL_PUSH_SHFT
+#define SOFTACK_MSHIFT UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT
+#define SOFTACK_PSHIFT UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT
+#define SOFTACK_TIMEOUT_PERIOD UV_INTD_SOFT_ACK_TIMEOUT_PERIOD
+
+/*
  * bits in UVH_LB_BAU_SB_ACTIVATION_STATUS_0/1
  */
-#define DESC_STATUS_IDLE		0
-#define DESC_STATUS_ACTIVE		1
-#define DESC_STATUS_DESTINATION_TIMEOUT	2
-#define DESC_STATUS_SOURCE_TIMEOUT	3
+#define DS_IDLE			0
+#define DS_ACTIVE		1
+#define DS_DESTINATION_TIMEOUT	2
+#define DS_SOURCE_TIMEOUT	3
 /*
  * bits put together from HRP_LB_BAU_SB_ACTIVATION_STATUS_0/1/2
  * values 1 and 5 will not occur
@@ -259,7 +267,7 @@ struct bau_msg_header {
 
 	unsigned int rsvd_4:7;	/* must be zero */
 	/* bits 88:82 */
-	unsigned int sw_ack_flag:1;/* software acknowledge flag */
+	unsigned int swack_flag:1;/* software acknowledge flag */
 	/* bit 89 */
 				/* INTD trasactions at destination are to
 				   wait for software acknowledge */
@@ -315,7 +323,7 @@ struct bau_desc {
  * are 32 bytes (2 micropackets) (256 bits) in length, but contain only 17
  * bytes of usable data, including the sw ack vector in byte 15 (bits 127:120)
  * (12 bytes come from bau_msg_payload, 3 from payload_1, 2 from
- *  sw_ack_vector and payload_2)
+ *  swack_vec and payload_2)
  * "Enabling Software Acknowledgment mode (see Section 4.3.3 Software
  *  Acknowledge Processing) also selects 32 byte (17 bytes usable) payload
  *  operation."
@@ -343,7 +351,7 @@ struct bau_payload_queue_entry {
 	unsigned char unused2;		/* not currently using */
 	/* byte 14 */
 
-	unsigned char sw_ack_vector;	/* filled in by the hardware */
+	unsigned char swack_vec;	/* filled in by the hardware */
 	/* byte 15 (bits 127:120) */
 
 	unsigned short sequence;	/* message sequence number */
@@ -361,7 +369,7 @@ struct bau_payload_queue_entry {
 struct msg_desc {
 	struct bau_payload_queue_entry *msg;
 	int msg_slot;
-	int sw_ack_slot;
+	int swack_slot;
 	struct bau_payload_queue_entry *va_queue_first;
 	struct bau_payload_queue_entry *va_queue_last;
 };
@@ -414,10 +422,29 @@ struct ptc_stats {
 	unsigned long d_rcanceled; /* number of messages canceled by resets */
 };
 
+struct tunables {
+	int *tunp;
+	int deflt;
+};
+
 struct hub_and_pnode {
 	short uvhub;
 	short pnode;
 };
+
+struct socket_desc {
+	short num_cpus;
+	short cpu_number[MAX_CPUS_PER_SOCKET];
+};
+
+struct uvhub_desc {
+	unsigned short socket_mask;
+	short num_cpus;
+	short uvhub;
+	short pnode;
+	struct socket_desc socket[2];
+};
+
 /*
  * one per-cpu; to locate the software tables
  */
@@ -452,21 +479,96 @@ struct bau_control {
 	spinlock_t uvhub_lock;
 	spinlock_t queue_lock;
 	/* tunables */
-	int max_bau_concurrent;
-	int max_bau_concurrent_constant;
+	int max_concurr;
+	int max_concurr_const;
 	int plugged_delay;
 	int plugsb4reset;
 	int timeoutsb4reset;
 	int ipi_reset_limit;
 	int complete_threshold;
-	int congested_response_us;
-	int congested_reps;
-	int congested_period;
+	int cong_response_us;
+	int cong_reps;
+	int cong_period;
 	cycles_t period_time;
 	long period_requests;
-	struct hub_and_pnode *target_hub_and_pnode;
+	struct hub_and_pnode *thp;
 };
 
+static unsigned long read_mmr_uv2_status(void)
+{
+	return uv_read_local_mmr(UV2H_LB_BAU_SB_ACTIVATION_STATUS_2);
+}
+
+static void write_mmr_data_broadcast(int pnode, unsigned long mmr_image)
+{
+	uv_write_global_mmr64(pnode, UVH_BAU_DATA_BROADCAST, mmr_image);
+}
+
+static void write_mmr_descriptor_base(int pnode, unsigned long mmr_image)
+{
+	uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE, mmr_image);
+}
+
+static void write_mmr_activation(unsigned long index)
+{
+	uv_write_local_mmr(UVH_LB_BAU_SB_ACTIVATION_CONTROL, index);
+}
+
+static void write_global_mmr_activation(int pnode, unsigned long mmr_image)
+{
+	uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_ACTIVATION_CONTROL,
+								mmr_image);
+}
+
+static void write_mmr_payload_first(int pnode, unsigned long mmr_image)
+{
+	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST,
+								mmr_image);
+}
+
+static void write_mmr_payload_tail(int pnode, unsigned long mmr_image)
+{
+	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL,
+								mmr_image);
+}
+
+static void write_mmr_payload_last(int pnode, unsigned long mmr_image)
+{
+	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST,
+								mmr_image);
+}
+
+static void write_mmr_misc_control(int pnode, unsigned long mmr_image)
+{
+	uv_write_global_mmr64(pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
+}
+
+static unsigned long read_mmr_misc_control(int pnode)
+{
+	return uv_read_global_mmr64(pnode, UVH_LB_BAU_MISC_CONTROL);
+}
+
+static void write_mmr_sw_ack(unsigned long mr)
+{
+	uv_write_local_mmr(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS, mr);
+}
+
+static unsigned long read_mmr_sw_ack(void)
+{
+	return uv_read_local_mmr(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
+}
+
+static unsigned long read_global_mmr_sw_ack(int pnode)
+{
+	return uv_read_global_mmr64(pnode,
+					UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
+}
+
+static void write_mmr_data_config(int pnode, unsigned long mr)
+{
+	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG, mr);
+}
+
 static inline int bau_uvhub_isset(int uvhub, struct bau_target_uvhubmask *dstp)
 {
 	return constant_test_bit(uvhub, &dstp->bits[0]);
@@ -501,7 +603,7 @@ struct atomic_short {
 	short counter;
 };
 
-/**
+/*
  * atomic_read_short - read a short atomic variable
  * @v: pointer of type atomic_short
  *
@@ -512,14 +614,14 @@ static inline int atomic_read_short(cons
 	return v->counter;
 }
 
-/**
- * atomic_add_short_return - add and return a short int
+/*
+ * atom_asr - add and return a short int
  * @i: short value to add
  * @v: pointer of type atomic_short
  *
  * Atomically adds @i to @v and returns @i + @v
  */
-static inline int atomic_add_short_return(short i, struct atomic_short *v)
+static inline int atom_asr(short i, struct atomic_short *v)
 {
 	short __i = i;
 	asm volatile(LOCK_PREFIX "xaddw %0, %1"
@@ -528,4 +630,26 @@ static inline int atomic_add_short_retur
 	return i + __i;
 }
 
+/*
+ * conditionally add 1 to *v, unless *v is >= u
+ * return 0 if we cannot add 1 to *v because it is >= u
+ * return 1 if we can add 1 to *v because it is < u
+ * the add is atomic
+ *
+ * This is close to atomic_add_unless(), but this allows the 'u' value
+ * to be lowered below the current 'v'.  atomic_add_unless can only stop
+ * on equal.
+ */
+static inline int atomic_inc_unless_ge(spinlock_t *lock, atomic_t *v, int u)
+{
+	spin_lock(lock);
+	if (atomic_read(v) >= u) {
+		spin_unlock(lock);
+		return 0;
+	}
+	atomic_inc(v);
+	spin_unlock(lock);
+	return 1;
+}
+
 #endif /* _ASM_X86_UV_UV_BAU_H */
Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1,7 +1,7 @@
 /*
  *	SGI UltraViolet TLB flush routines.
  *
- *	(c) 2008-2010 Cliff Wickman <cpw@sgi.com>, SGI.
+ *	(c) 2008-2011 Cliff Wickman <cpw@sgi.com>, SGI.
  *
  *	This code is released under the GNU General Public License version 2 or
  *	later.
@@ -35,6 +35,7 @@ static int timeout_base_ns[] = {
 		5242880,
 		167772160
 };
+
 static int timeout_us;
 static int nobau;
 static int baudisabled;
@@ -42,8 +43,8 @@ static spinlock_t disable_lock;
 static cycles_t congested_cycles;
 
 /* tunables: */
-static int max_bau_concurrent = MAX_BAU_CONCURRENT;
-static int max_bau_concurrent_constant = MAX_BAU_CONCURRENT;
+static int max_concurr = MAX_BAU_CONCURRENT;
+static int max_concurr_const = MAX_BAU_CONCURRENT;
 static int plugged_delay = PLUGGED_DELAY;
 static int plugsb4reset = PLUGSB4RESET;
 static int timeoutsb4reset = TIMEOUTSB4RESET;
@@ -52,10 +53,57 @@ static int complete_threshold = COMPLETE
 static int congested_response_us = CONGESTED_RESPONSE_US;
 static int congested_reps = CONGESTED_REPS;
 static int congested_period = CONGESTED_PERIOD;
+static struct tunables tunables[] = {
+	{&max_concurr, MAX_BAU_CONCURRENT}, /* must be [0] */
+	{&plugged_delay, PLUGGED_DELAY},
+	{&plugsb4reset, PLUGSB4RESET},
+	{&timeoutsb4reset, TIMEOUTSB4RESET},
+	{&ipi_reset_limit, IPI_RESET_LIMIT},
+	{&complete_threshold, COMPLETE_THRESHOLD},
+	{&congested_response_us, CONGESTED_RESPONSE_US},
+	{&congested_reps, CONGESTED_REPS},
+	{&congested_period, CONGESTED_PERIOD}
+};
 static struct dentry *tunables_dir;
 static struct dentry *tunables_file;
+/* these correspond to the statistics printed by uv_ptc_seq_show() */
+static char *stat_description[] = {
+	"sent:     number of shootdown messages sent",
+	"stime:    time spent sending messages",
+	"numuvhubs: number of hubs targeted with shootdown",
+	"numuvhubs16: number times 16 or more hubs targeted",
+	"numuvhubs8: number times 8 or more hubs targeted",
+	"numuvhubs4: number times 4 or more hubs targeted",
+	"numuvhubs2: number times 2 or more hubs targeted",
+	"numuvhubs1: number times 1 hub targeted",
+	"numcpus:  number of cpus targeted with shootdown",
+	"dto:      number of destination timeouts",
+	"retries:  destination timeout retries sent",
+	"rok:   :  destination timeouts successfully retried",
+	"resetp:   ipi-style resource resets for plugs",
+	"resett:   ipi-style resource resets for timeouts",
+	"giveup:   fall-backs to ipi-style shootdowns",
+	"sto:      number of source timeouts",
+	"bz:       number of stay-busy's",
+	"throt:    number times spun in throttle",
+	"swack:   image of UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE",
+	"recv:     shootdown messages received",
+	"rtime:    time spent processing messages",
+	"all:      shootdown all-tlb messages",
+	"one:      shootdown one-tlb messages",
+	"mult:     interrupts that found multiple messages",
+	"none:     interrupts that found no messages",
+	"retry:    number of retry messages processed",
+	"canc:     number messages canceled by retries",
+	"nocan:    number retries that found nothing to cancel",
+	"reset:    number of ipi-style reset requests processed",
+	"rcan:     number messages canceled by reset requests",
+	"disable:  number times use of the BAU was disabled",
+	"enable:   number times use of the BAU was re-enabled"
+};
 
-static int __init setup_nobau(char *arg)
+static int __init
+setup_nobau(char *arg)
 {
 	nobau = 1;
 	return 0;
@@ -63,7 +111,7 @@ static int __init setup_nobau(char *arg)
 early_param("nobau", setup_nobau);
 
 /* base pnode in this partition */
-static int uv_partition_base_pnode __read_mostly;
+static int uv_base_pnode __read_mostly;
 /* position of pnode (which is nasid>>1): */
 static int uv_nshift __read_mostly;
 static unsigned long uv_mmask __read_mostly;
@@ -109,40 +157,34 @@ static int __init uvhub_to_first_apicid(
  * clear of the Timeout bit (as well) will free the resource. No reply will
  * be sent (the hardware will only do one reply per message).
  */
-static inline void uv_reply_to_message(struct msg_desc *mdp,
-				       struct bau_control *bcp)
+static void uv_reply_to_message(struct msg_desc *mdp, struct bau_control *bcp)
 {
 	unsigned long dw;
 	struct bau_payload_queue_entry *msg;
 
 	msg = mdp->msg;
 	if (!msg->canceled) {
-		dw = (msg->sw_ack_vector << UV_SW_ACK_NPENDING) |
-						msg->sw_ack_vector;
-		uv_write_local_mmr(
-				UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS, dw);
+		dw = (msg->swack_vec << UV_SW_ACK_NPENDING) | msg->swack_vec;
+		write_mmr_sw_ack(dw);
 	}
 	msg->replied_to = 1;
-	msg->sw_ack_vector = 0;
+	msg->swack_vec = 0;
 }
 
 /*
  * Process the receipt of a RETRY message
  */
-static inline void uv_bau_process_retry_msg(struct msg_desc *mdp,
-					    struct bau_control *bcp)
+static void uv_bau_process_retry_msg(struct msg_desc *mdp,
+					struct bau_control *bcp)
 {
 	int i;
 	int cancel_count = 0;
-	int slot2;
 	unsigned long msg_res;
 	unsigned long mmr = 0;
-	struct bau_payload_queue_entry *msg;
+	struct bau_payload_queue_entry *msg = mdp->msg;
 	struct bau_payload_queue_entry *msg2;
-	struct ptc_stats *stat;
+	struct ptc_stats *stat = bcp->statp;
 
-	msg = mdp->msg;
-	stat = bcp->statp;
 	stat->d_retries++;
 	/*
 	 * cancel any message from msg+1 to the retry itself
@@ -155,14 +197,12 @@ static inline void uv_bau_process_retry_
 
 		/* same conditions for cancellation as uv_do_reset */
 		if ((msg2->replied_to == 0) && (msg2->canceled == 0) &&
-		    (msg2->sw_ack_vector) && ((msg2->sw_ack_vector &
-			msg->sw_ack_vector) == 0) &&
+		    (msg2->swack_vec) && ((msg2->swack_vec &
+			msg->swack_vec) == 0) &&
 		    (msg2->sending_cpu == msg->sending_cpu) &&
 		    (msg2->msg_type != MSG_NOOP)) {
-			slot2 = msg2 - mdp->va_queue_first;
-			mmr = uv_read_local_mmr
-				(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
-			msg_res = msg2->sw_ack_vector;
+			mmr = read_mmr_sw_ack();
+			msg_res = msg2->swack_vec;
 			/*
 			 * This is a message retry; clear the resources held
 			 * by the previous message only if they timed out.
@@ -170,6 +210,7 @@ static inline void uv_bau_process_retry_
 			 * situation to report.
 			 */
 			if (mmr & (msg_res << UV_SW_ACK_NPENDING)) {
+				unsigned long mr;
 				/*
 				 * is the resource timed out?
 				 * make everyone ignore the cancelled message.
@@ -177,10 +218,8 @@ static inline void uv_bau_process_retry_
 				msg2->canceled = 1;
 				stat->d_canceled++;
 				cancel_count++;
-				uv_write_local_mmr(
-				    UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS,
-					(msg_res << UV_SW_ACK_NPENDING) |
-					 msg_res);
+				mr = (msg_res << UV_SW_ACK_NPENDING) | msg_res;
+				write_mmr_sw_ack(mr);
 			}
 		}
 	}
@@ -193,19 +232,19 @@ static inline void uv_bau_process_retry_
  * Other cpu's may come here at the same time for this message.
  */
 static void uv_bau_process_message(struct msg_desc *mdp,
-				   struct bau_control *bcp)
+					struct bau_control *bcp)
 {
 	int msg_ack_count;
 	short socket_ack_count = 0;
-	struct ptc_stats *stat;
-	struct bau_payload_queue_entry *msg;
+	short *sp;
+	struct atomic_short *asp;
+	struct ptc_stats *stat = bcp->statp;
+	struct bau_payload_queue_entry *msg = mdp->msg;
 	struct bau_control *smaster = bcp->socket_master;
 
 	/*
 	 * This must be a normal message, or retry of a normal message
 	 */
-	msg = mdp->msg;
-	stat = bcp->statp;
 	if (msg->address == TLB_FLUSH_ALL) {
 		local_flush_tlb();
 		stat->d_alltlb++;
@@ -225,21 +264,22 @@ static void uv_bau_process_message(struc
 		uv_bau_process_retry_msg(mdp, bcp);
 
 	/*
-	 * This is a sw_ack message, so we have to reply to it.
+	 * This is a swack message, so we have to reply to it.
 	 * Count each responding cpu on the socket. This avoids
 	 * pinging the count's cache line back and forth between
 	 * the sockets.
 	 */
-	socket_ack_count = atomic_add_short_return(1, (struct atomic_short *)
-			&smaster->socket_acknowledge_count[mdp->msg_slot]);
+	sp = &smaster->socket_acknowledge_count[mdp->msg_slot];
+	asp = (struct atomic_short *)sp;
+	socket_ack_count = atom_asr(1, asp);
 	if (socket_ack_count == bcp->cpus_in_socket) {
 		/*
 		 * Both sockets dump their completed count total into
 		 * the message's count.
 		 */
 		smaster->socket_acknowledge_count[mdp->msg_slot] = 0;
-		msg_ack_count = atomic_add_short_return(socket_ack_count,
-				(struct atomic_short *)&msg->acknowledge_count);
+		asp = (struct atomic_short *)&msg->acknowledge_count;
+		msg_ack_count = atom_asr(socket_ack_count, asp);
 
 		if (msg_ack_count == bcp->cpus_in_uvhub) {
 			/*
@@ -268,19 +308,15 @@ static int uvhub_to_first_cpu(int uvhub)
  * Last resort when we get a large number of destination timeouts is
  * to clear resources held by a given cpu.
  * Do this with IPI so that all messages in the BAU message queue
- * can be identified by their nonzero sw_ack_vector field.
+ * can be identified by their nonzero swack_vec field.
  *
  * This is entered for a single cpu on the uvhub.
  * The sender want's this uvhub to free a specific message's
- * sw_ack resources.
+ * swack resources.
  */
-static void
-uv_do_reset(void *ptr)
+static void uv_do_reset(void *ptr)
 {
 	int i;
-	int slot;
-	int count = 0;
-	unsigned long mmr;
 	unsigned long msg_res;
 	struct bau_control *bcp;
 	struct reset_args *rap;
@@ -294,7 +330,7 @@ uv_do_reset(void *ptr)
 
 	/*
 	 * We're looking for the given sender, and
-	 * will free its sw_ack resource.
+	 * will free its swack resource.
 	 * If all cpu's finally responded after the timeout, its
 	 * message 'replied_to' was set.
 	 */
@@ -304,26 +340,23 @@ uv_do_reset(void *ptr)
 		if ((msg->replied_to == 0) &&
 		    (msg->canceled == 0) &&
 		    (msg->sending_cpu == rap->sender) &&
-		    (msg->sw_ack_vector) &&
+		    (msg->swack_vec) &&
 		    (msg->msg_type != MSG_NOOP)) {
+			unsigned long mmr;
+			unsigned long mr;
 			/*
 			 * make everyone else ignore this message
 			 */
 			msg->canceled = 1;
-			slot = msg - bcp->va_queue_first;
-			count++;
 			/*
 			 * only reset the resource if it is still pending
 			 */
-			mmr = uv_read_local_mmr
-					(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
-			msg_res = msg->sw_ack_vector;
+			mmr = read_mmr_sw_ack();
+			msg_res = msg->swack_vec;
+			mr = (msg_res << UV_SW_ACK_NPENDING) | msg_res;
 			if (mmr & msg_res) {
 				stat->d_rcanceled++;
-				uv_write_local_mmr(
-				    UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS,
-					(msg_res << UV_SW_ACK_NPENDING) |
-					 msg_res);
+				write_mmr_sw_ack(mr);
 			}
 		}
 	}
@@ -335,38 +368,38 @@ uv_do_reset(void *ptr)
  * a given sending cpu number.
  */
 static void uv_reset_with_ipi(struct bau_target_uvhubmask *distribution,
-			      int sender)
+				int sender)
 {
 	int uvhub;
 	int cpu;
+	int maskbits;
 	cpumask_t mask;
 	struct reset_args reset_args;
 
 	reset_args.sender = sender;
-
 	cpus_clear(mask);
 	/* find a single cpu for each uvhub in this distribution mask */
-	for (uvhub = 0;
-		    uvhub < sizeof(struct bau_target_uvhubmask) * BITSPERBYTE;
-		    uvhub++) {
+	maskbits = sizeof(struct bau_target_uvhubmask) * BITSPERBYTE;
+	for (uvhub = 0; uvhub < maskbits; uvhub++) {
 		if (!bau_uvhub_isset(uvhub, distribution))
 			continue;
 		/* find a cpu for this uvhub */
 		cpu = uvhub_to_first_cpu(uvhub);
 		cpu_set(cpu, mask);
 	}
-	/* IPI all cpus; Preemption is already disabled */
+	/* IPI all cpus; preemption is already disabled */
 	smp_call_function_many(&mask, uv_do_reset, (void *)&reset_args, 1);
 	return;
 }
 
-static inline unsigned long
-cycles_2_us(unsigned long long cyc)
+static inline unsigned long cycles_2_us(unsigned long long cyc)
 {
 	unsigned long long ns;
 	unsigned long us;
-	ns =  (cyc * per_cpu(cyc2ns, smp_processor_id()))
-						>> CYC2NS_SCALE_FACTOR;
+	int cpu;
+
+	cpu = smp_processor_id();
+	ns =  (cyc * per_cpu(cyc2ns, cpu)) >> CYC2NS_SCALE_FACTOR;
 	us = ns / 1000;
 	return us;
 }
@@ -376,21 +409,27 @@ cycles_2_us(unsigned long long cyc)
  * leaves uvhub_quiesce set so that no new broadcasts are started by
  * bau_flush_send_and_wait()
  */
-static inline void
-quiesce_local_uvhub(struct bau_control *hmaster)
+static inline void quiesce_local_uvhub(struct bau_control *hmaster)
 {
-	atomic_add_short_return(1, (struct atomic_short *)
-		 &hmaster->uvhub_quiesce);
+	atom_asr(1, (struct atomic_short *)&hmaster->uvhub_quiesce);
 }
 
 /*
  * mark this quiet-requestor as done
  */
-static inline void
-end_uvhub_quiesce(struct bau_control *hmaster)
+static inline void end_uvhub_quiesce(struct bau_control *hmaster)
+{
+	atom_asr(-1, (struct atomic_short *)&hmaster->uvhub_quiesce);
+}
+
+static unsigned long uv1_read_status(unsigned long mmr_offset, int right_shift)
 {
-	atomic_add_short_return(-1, (struct atomic_short *)
-		&hmaster->uvhub_quiesce);
+	unsigned long descriptor_status;
+
+	descriptor_status = uv_read_local_mmr(mmr_offset);
+	descriptor_status >>= right_shift;
+	descriptor_status &= UV_ACT_STATUS_MASK;
+	return descriptor_status;
 }
 
 /*
@@ -398,31 +437,28 @@ end_uvhub_quiesce(struct bau_control *hm
  * return COMPLETE, RETRY(PLUGGED or TIMEOUT) or GIVEUP
  */
 static int uv1_wait_completion(struct bau_desc *bau_desc,
-	unsigned long mmr_offset, int right_shift, int this_cpu,
-	struct bau_control *bcp, struct bau_control *smaster, long try)
+				unsigned long mmr_offset, int right_shift,
+				struct bau_control *bcp, long try)
 {
 	unsigned long descriptor_status;
-	cycles_t ttime;
+	cycles_t ttm;
 	struct ptc_stats *stat = bcp->statp;
 
+	descriptor_status = uv1_read_status(mmr_offset, right_shift);
 	/* spin on the status MMR, waiting for it to go idle */
-	while ((descriptor_status = (((unsigned long)
-		uv_read_local_mmr(mmr_offset) >>
-			right_shift) & UV_ACT_STATUS_MASK)) !=
-			DESC_STATUS_IDLE) {
+	while ((descriptor_status != DS_IDLE)) {
 		/*
 		 * Our software ack messages may be blocked because
 		 * there are no swack resources available.  As long
 		 * as none of them has timed out hardware will NACK
 		 * our message and its state will stay IDLE.
 		 */
-		if (descriptor_status == DESC_STATUS_SOURCE_TIMEOUT) {
+		if (descriptor_status == DS_SOURCE_TIMEOUT) {
 			stat->s_stimeout++;
 			return FLUSH_GIVEUP;
-		} else if (descriptor_status ==
-				DESC_STATUS_DESTINATION_TIMEOUT) {
+		} else if (descriptor_status == DS_DESTINATION_TIMEOUT) {
 			stat->s_dtimeout++;
-			ttime = get_cycles();
+			ttm = get_cycles();
 
 			/*
 			 * Our retries may be blocked by all destination
@@ -430,8 +466,7 @@ static int uv1_wait_completion(struct ba
 			 * pending.  In that case hardware returns the
 			 * ERROR that looks like a destination timeout.
 			 */
-			if (cycles_2_us(ttime - bcp->send_message) <
-							timeout_us) {
+			if (cycles_2_us(ttm - bcp->send_message) < timeout_us) {
 				bcp->conseccompletes = 0;
 				return FLUSH_RETRY_PLUGGED;
 			}
@@ -444,93 +479,108 @@ static int uv1_wait_completion(struct ba
 			 */
 			cpu_relax();
 		}
+		descriptor_status = uv1_read_status(mmr_offset, right_shift);
 	}
 	bcp->conseccompletes++;
 	return FLUSH_COMPLETE;
 }
 
-static int uv2_wait_completion(struct bau_desc *bau_desc,
-	unsigned long mmr_offset, int right_shift, int this_cpu,
-	struct bau_control *bcp, struct bau_control *smaster, long try)
+/*
+ * UV2 has an extra bit of status in the ACTIVATION_STATUS_2 register.
+ */
+static unsigned long uv2_read_status(unsigned long mmr_offset, int right_shift,
+					 int cpu)
 {
 	unsigned long descriptor_status;
 	unsigned long descriptor_status2;
+
+	descriptor_status = ((uv_read_local_mmr(mmr_offset) >> right_shift) &
+							UV_ACT_STATUS_MASK);
+	descriptor_status2 = (read_mmr_uv2_status() >> cpu) & 0x1UL;
+	descriptor_status = (descriptor_status << 1) | descriptor_status2;
+	return descriptor_status;
+}
+
+static int uv2_wait_completion(struct bau_desc *bau_desc,
+				unsigned long mmr_offset, int right_shift,
+				struct bau_control *bcp, long try)
+{
+	unsigned long descriptor_stat;
 	int cpu;
-	cycles_t ttime;
+	cycles_t ttm;
 	struct ptc_stats *stat = bcp->statp;
 
-	/* UV2 has an extra bit of status */
 	cpu = bcp->uvhub_cpu;
+	descriptor_stat = uv2_read_status(mmr_offset, right_shift, cpu);
 	/* spin on the status MMR, waiting for it to go idle */
-	descriptor_status = (((unsigned long)(uv_read_local_mmr
-		(mmr_offset)) >> right_shift) & UV_ACT_STATUS_MASK);
-	descriptor_status2 = (((unsigned long)uv_read_local_mmr
-		(UV2H_LB_BAU_SB_ACTIVATION_STATUS_2) >> cpu) & 0x1UL);
-	descriptor_status = (descriptor_status << 1) |
-		descriptor_status2;
-	while (descriptor_status != UV2H_DESC_IDLE) {
+	while (descriptor_stat != UV2H_DESC_IDLE) {
 		/*
 		 * Our software ack messages may be blocked because
 		 * there are no swack resources available.  As long
 		 * as none of them has timed out hardware will NACK
 		 * our message and its state will stay IDLE.
 		 */
-		if ((descriptor_status == UV2H_DESC_SOURCE_TIMEOUT) ||
-		    (descriptor_status == UV2H_DESC_DEST_STRONG_NACK) ||
-		    (descriptor_status == UV2H_DESC_DEST_PUT_ERR)) {
+		if ((descriptor_stat == UV2H_DESC_SOURCE_TIMEOUT) ||
+		    (descriptor_stat == UV2H_DESC_DEST_STRONG_NACK) ||
+		    (descriptor_stat == UV2H_DESC_DEST_PUT_ERR)) {
 			stat->s_stimeout++;
 			return FLUSH_GIVEUP;
-		} else if (descriptor_status == UV2H_DESC_DEST_TIMEOUT) {
+		} else if (descriptor_stat == UV2H_DESC_DEST_TIMEOUT) {
 			stat->s_dtimeout++;
-			ttime = get_cycles();
-
+			ttm = get_cycles();
 			/*
 			 * Our retries may be blocked by all destination
 			 * swack resources being consumed, and a timeout
 			 * pending.  In that case hardware returns the
 			 * ERROR that looks like a destination timeout.
 			 */
-			if (cycles_2_us(ttime - bcp->send_message) <
-							timeout_us) {
+			if (cycles_2_us(ttm - bcp->send_message) < timeout_us) {
 				bcp->conseccompletes = 0;
 				return FLUSH_RETRY_PLUGGED;
 			}
-
 			bcp->conseccompletes = 0;
 			return FLUSH_RETRY_TIMEOUT;
 		} else {
 			/*
-			 * descriptor_status is still BUSY
+			 * descriptor_stat is still BUSY
 			 */
 			cpu_relax();
 		}
-		descriptor_status = (((unsigned long)(uv_read_local_mmr
-			(mmr_offset)) >> right_shift) &
-			UV_ACT_STATUS_MASK);
-		descriptor_status2 = (((unsigned long)uv_read_local_mmr
-			(UV2H_LB_BAU_SB_ACTIVATION_STATUS_2) >> cpu) &
-			0x1UL);
-		descriptor_status = (descriptor_status << 1) |
-			descriptor_status2;
+		descriptor_stat = uv2_read_status(mmr_offset, right_shift, cpu);
 	}
 	bcp->conseccompletes++;
 	return FLUSH_COMPLETE;
 }
 
+/*
+ * There are 2 status registers; each and array[32] of 2 bits. Set up for
+ * which register to read and position in that register based on cpu in
+ * current hub.
+ */
 static int uv_wait_completion(struct bau_desc *bau_desc,
-	unsigned long mmr_offset, int right_shift, int this_cpu,
-	struct bau_control *bcp, struct bau_control *smaster, long try)
+				struct bau_control *bcp, long try)
 {
+	int right_shift;
+	unsigned long mmr_offset;
+	int cpu = bcp->uvhub_cpu;
+
+	if (cpu < UV_CPUS_PER_AS) {
+		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_0;
+		right_shift = cpu * UV_ACT_STATUS_SIZE;
+	} else {
+		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_1;
+		right_shift = ((cpu - UV_CPUS_PER_AS) * UV_ACT_STATUS_SIZE);
+	}
+
 	if (is_uv1_hub())
 		return uv1_wait_completion(bau_desc, mmr_offset, right_shift,
-				   this_cpu, bcp, smaster, try);
+								bcp, try);
 	else
 		return uv2_wait_completion(bau_desc, mmr_offset, right_shift,
-				   this_cpu, bcp, smaster, try);
+								bcp, try);
 }
 
-static inline cycles_t
-sec_2_cycles(unsigned long sec)
+static inline cycles_t sec_2_cycles(unsigned long sec)
 {
 	unsigned long ns;
 	cycles_t cyc;
@@ -541,34 +591,12 @@ sec_2_cycles(unsigned long sec)
 }
 
 /*
- * conditionally add 1 to *v, unless *v is >= u
- * return 0 if we cannot add 1 to *v because it is >= u
- * return 1 if we can add 1 to *v because it is < u
- * the add is atomic
- *
- * This is close to atomic_add_unless(), but this allows the 'u' value
- * to be lowered below the current 'v'.  atomic_add_unless can only stop
- * on equal.
- */
-static inline int atomic_inc_unless_ge(spinlock_t *lock, atomic_t *v, int u)
-{
-	spin_lock(lock);
-	if (atomic_read(v) >= u) {
-		spin_unlock(lock);
-		return 0;
-	}
-	atomic_inc(v);
-	spin_unlock(lock);
-	return 1;
-}
-
-/*
- * Our retries are blocked by all destination swack resources being
+ * Our retries are blocked by all destination sw ack resources being
  * in use, and a timeout is pending. In that case hardware immediately
  * returns the ERROR that looks like a destination timeout.
  */
-static void
-destination_plugged(struct bau_desc *bau_desc, struct bau_control *bcp,
+static void destination_plugged(struct bau_desc *bau_desc,
+			struct bau_control *bcp,
 			struct bau_control *hmaster, struct ptc_stats *stat)
 {
 	udelay(bcp->plugged_delay);
@@ -585,11 +613,11 @@ destination_plugged(struct bau_desc *bau
 	}
 }
 
-static void
-destination_timeout(struct bau_desc *bau_desc, struct bau_control *bcp,
-			struct bau_control *hmaster, struct ptc_stats *stat)
+static void destination_timeout(struct bau_desc *bau_desc,
+			struct bau_control *bcp, struct bau_control *hmaster,
+			struct ptc_stats *stat)
 {
-	hmaster->max_bau_concurrent = 1;
+	hmaster->max_concurr = 1;
 	bcp->timeout_tries++;
 	if (bcp->timeout_tries >= bcp->timeoutsb4reset) {
 		bcp->timeout_tries = 0;
@@ -607,8 +635,8 @@ destination_timeout(struct bau_desc *bau
  * Completions are taking a very long time due to a congested numalink
  * network.
  */
-static void
-disable_for_congestion(struct bau_control *bcp, struct ptc_stats *stat)
+static void disable_for_congestion(struct bau_control *bcp,
+					struct ptc_stats *stat)
 {
 	int tcpu;
 	struct bau_control *tbcp;
@@ -621,20 +649,87 @@ disable_for_congestion(struct bau_contro
 		   BAU again */
 		baudisabled = 1;
 		bcp->set_bau_off = 1;
-		bcp->set_bau_on_time = get_cycles() +
-			sec_2_cycles(bcp->congested_period);
+		bcp->set_bau_on_time = get_cycles();
+		bcp->set_bau_on_time += sec_2_cycles(bcp->cong_period);
 		stat->s_bau_disabled++;
 		for_each_present_cpu(tcpu) {
 			tbcp = &per_cpu(bau_control, tcpu);
-				tbcp->baudisabled = 1;
+			tbcp->baudisabled = 1;
 		}
 	}
 	spin_unlock(&disable_lock);
 }
 
-/**
- * uv_flush_send_and_wait
- *
+static void count_max_concurr(int stat, struct bau_control *bcp,
+				struct bau_control *hmaster)
+{
+	bcp->plugged_tries = 0;
+	bcp->timeout_tries = 0;
+	if (stat != FLUSH_COMPLETE)
+		return;
+	if (bcp->conseccompletes <= bcp->complete_threshold)
+		return;
+	if (hmaster->max_concurr >= hmaster->max_concurr_const)
+		return;
+	hmaster->max_concurr++;
+}
+
+static void __init record_send_stats(cycles_t time1, cycles_t time2,
+		struct bau_control *bcp, struct ptc_stats *stat,
+		int completion_status, int try)
+{
+	cycles_t elapsed;
+
+	if (time2 > time1) {
+		elapsed = time2 - time1;
+		stat->s_time += elapsed;
+		if ((completion_status == FLUSH_COMPLETE) && (try == 1)) {
+			bcp->period_requests++;
+			bcp->period_time += elapsed;
+			if ((elapsed > congested_cycles) &&
+			    (bcp->period_requests > bcp->cong_reps))
+				disable_for_congestion(bcp, stat);
+		}
+	} else
+		stat->s_requestor--;
+	if (completion_status == FLUSH_COMPLETE && try > 1)
+		stat->s_retriesok++;
+	else if (completion_status == FLUSH_GIVEUP)
+		stat->s_giveup++;
+}
+
+/*
+ * Because of a uv1 hardware bug only a limited number of concurrent
+ * requests can be made.
+ */
+static void uv1_throttle(struct bau_control *hmaster, struct ptc_stats *stat)
+{
+	spinlock_t *lock = &hmaster->uvhub_lock;
+	atomic_t *v;
+
+	v = &hmaster->active_descriptor_count;
+	if (!atomic_inc_unless_ge(lock, v, hmaster->max_concurr)) {
+		stat->s_throttles++;
+		do {
+			cpu_relax();
+		} while (!atomic_inc_unless_ge(lock, v, hmaster->max_concurr));
+	}
+}
+
+/*
+ * Handle the completion status of a message send.
+ */
+static void handle_cmplt(int completion_status, struct bau_desc *bau_desc,
+			struct bau_control *bcp, struct bau_control *hmaster,
+			struct ptc_stats *stat)
+{
+	if (completion_status == FLUSH_RETRY_PLUGGED)
+		destination_plugged(bau_desc, bcp, hmaster, stat);
+	else if (completion_status == FLUSH_RETRY_TIMEOUT)
+		destination_timeout(bau_desc, bcp, hmaster, stat);
+}
+
+/*
  * Send a broadcast and wait for it to complete.
  *
  * The flush_mask contains the cpus the broadcast is to be sent to including
@@ -645,45 +740,21 @@ disable_for_congestion(struct bau_contro
  * returned to the kernel.
  */
 int uv_flush_send_and_wait(struct bau_desc *bau_desc,
-			   struct cpumask *flush_mask, struct bau_control *bcp)
+			struct cpumask *flush_mask, struct bau_control *bcp)
 {
-	int right_shift;
-	int completion_status = 0;
+	int completion_stat = 0;
 	int seq_number = 0;
 	long try = 0;
-	int cpu = bcp->uvhub_cpu;
-	int this_cpu = bcp->cpu;
-	unsigned long mmr_offset;
 	unsigned long index;
 	cycles_t time1;
 	cycles_t time2;
-	cycles_t elapsed;
 	struct ptc_stats *stat = bcp->statp;
-	struct bau_control *smaster = bcp->socket_master;
 	struct bau_control *hmaster = bcp->uvhub_master;
 
-	if (is_uv1_hub()  &&
-			!atomic_inc_unless_ge(&hmaster->uvhub_lock,
-			&hmaster->active_descriptor_count,
-			hmaster->max_bau_concurrent)) {
-		stat->s_throttles++;
-		do {
-			cpu_relax();
-		} while (!atomic_inc_unless_ge(&hmaster->uvhub_lock,
-			&hmaster->active_descriptor_count,
-			hmaster->max_bau_concurrent));
-	}
+	if (is_uv1_hub())
+		uv1_throttle(hmaster, stat);
 	while (hmaster->uvhub_quiesce)
 		cpu_relax();
-
-	if (cpu < UV_CPUS_PER_ACT_STATUS) {
-		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_0;
-		right_shift = cpu * UV_ACT_STATUS_SIZE;
-	} else {
-		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_1;
-		right_shift =
-		    ((cpu - UV_CPUS_PER_ACT_STATUS) * UV_ACT_STATUS_SIZE);
-	}
 	time1 = get_cycles();
 	do {
 		if (try == 0) {
@@ -694,63 +765,121 @@ int uv_flush_send_and_wait(struct bau_de
 			stat->s_retry_messages++;
 		}
 		bau_desc->header.sequence = seq_number;
-		index = (1UL << UVH_LB_BAU_SB_ACTIVATION_CONTROL_PUSH_SHFT) |
-			bcp->uvhub_cpu;
+		index = (1UL << AS_PUSH_SHIFT) | bcp->uvhub_cpu;
 		bcp->send_message = get_cycles();
-		uv_write_local_mmr(UVH_LB_BAU_SB_ACTIVATION_CONTROL, index);
+		write_mmr_activation(index);
 		try++;
-		completion_status = uv_wait_completion(bau_desc, mmr_offset,
-			right_shift, this_cpu, bcp, smaster, try);
-
-		if (completion_status == FLUSH_RETRY_PLUGGED) {
-			destination_plugged(bau_desc, bcp, hmaster, stat);
-		} else if (completion_status == FLUSH_RETRY_TIMEOUT) {
-			destination_timeout(bau_desc, bcp, hmaster, stat);
-		}
+		completion_stat = uv_wait_completion(bau_desc, bcp, try);
+		handle_cmplt(completion_stat, bau_desc, bcp, hmaster, stat);
 		if (bcp->ipi_attempts >= bcp->ipi_reset_limit) {
 			bcp->ipi_attempts = 0;
-			completion_status = FLUSH_GIVEUP;
+			completion_stat = FLUSH_GIVEUP;
 			break;
 		}
 		cpu_relax();
-	} while ((completion_status == FLUSH_RETRY_PLUGGED) ||
-		 (completion_status == FLUSH_RETRY_TIMEOUT));
+	} while ((completion_stat == FLUSH_RETRY_PLUGGED) ||
+		 (completion_stat == FLUSH_RETRY_TIMEOUT));
 	time2 = get_cycles();
-	bcp->plugged_tries = 0;
-	bcp->timeout_tries = 0;
-	if ((completion_status == FLUSH_COMPLETE) &&
-	    (bcp->conseccompletes > bcp->complete_threshold) &&
-	    (hmaster->max_bau_concurrent <
-					hmaster->max_bau_concurrent_constant))
-			hmaster->max_bau_concurrent++;
+	count_max_concurr(completion_stat, bcp, hmaster);
 	while (hmaster->uvhub_quiesce)
 		cpu_relax();
 	atomic_dec(&hmaster->active_descriptor_count);
-	if (time2 > time1) {
-		elapsed = time2 - time1;
-		stat->s_time += elapsed;
-		if ((completion_status == FLUSH_COMPLETE) && (try == 1)) {
-			bcp->period_requests++;
-			bcp->period_time += elapsed;
-			if ((elapsed > congested_cycles) &&
-			    (bcp->period_requests > bcp->congested_reps)) {
-				disable_for_congestion(bcp, stat);
+	record_send_stats(time1, time2, bcp, stat, completion_stat, try);
+	if (completion_stat == FLUSH_GIVEUP)
+		return 1;
+	return 0;
+}
+
+/*
+ * The BAU is disabled. When the disabled time period has expired, the cpu
+ * that disabled it must re-enable it.
+ * Return 0 if it is re-enabled for all cpus.
+ */
+static int check_enable(struct bau_control *bcp, struct ptc_stats *stat)
+{
+	int tcpu;
+	struct bau_control *tbcp;
+
+	if (bcp->set_bau_off) {
+		if (get_cycles() >= bcp->set_bau_on_time) {
+			stat->s_bau_reenabled++;
+			baudisabled = 0;
+			for_each_present_cpu(tcpu) {
+				tbcp = &per_cpu(bau_control, tcpu);
+				tbcp->baudisabled = 0;
+				tbcp->period_requests = 0;
+				tbcp->period_time = 0;
 			}
+			return 0;
 		}
+	}
+	return -1;
+}
+
+static void record_send_statistics(struct ptc_stats *stat, int locals, int hubs,
+				int remotes, struct bau_desc *bau_desc)
+{
+	stat->s_requestor++;
+	stat->s_ntargcpu += remotes + locals;
+	stat->s_ntargremotes += remotes;
+	stat->s_ntarglocals += locals;
+	remotes = bau_uvhub_weight(&bau_desc->distribution);
+
+	/* uvhub statistics */
+	hubs = bau_uvhub_weight(&bau_desc->distribution);
+	if (locals) {
+		stat->s_ntarglocaluvhub++;
+		stat->s_ntargremoteuvhub += (hubs - 1);
 	} else
-		stat->s_requestor--;
-	if (completion_status == FLUSH_COMPLETE && try > 1)
-		stat->s_retriesok++;
-	else if (completion_status == FLUSH_GIVEUP) {
-		stat->s_giveup++;
-		return 1;
+		stat->s_ntargremoteuvhub += hubs;
+	stat->s_ntarguvhub += hubs;
+	if (hubs >= 16)
+		stat->s_ntarguvhub16++;
+	else if (hubs >= 8)
+		stat->s_ntarguvhub8++;
+	else if (hubs >= 4)
+		stat->s_ntarguvhub4++;
+	else if (hubs >= 2)
+		stat->s_ntarguvhub2++;
+	else
+		stat->s_ntarguvhub1++;
+}
+
+/*
+ * Translate a cpu mask to the uvhub distribution mask in the BAU
+ * activation descriptor.
+ */
+static int set_distrib_bits(struct cpumask *flush_mask, struct bau_control *bcp,
+			struct bau_desc *bau_desc, int *localsp, int *remotesp)
+{
+	int cpu;
+	int pnode;
+	int cnt = 0;
+	struct hub_and_pnode *hpp;
+
+	for_each_cpu(cpu, flush_mask) {
+		/*
+		 * The distribution vector is a bit map of pnodes, relative
+		 * to the partition base pnode (and the partition base nasid
+		 * in the header).
+		 * Translate cpu to pnode and hub using a local memory array.
+		 */
+		hpp = &bcp->socket_master->thp[cpu];
+		pnode = hpp->pnode - bcp->partition_base_pnode;
+		bau_uvhub_set(pnode, &bau_desc->distribution);
+		cnt++;
+		if (hpp->uvhub == bcp->uvhub)
+			(*localsp)++;
+		else
+			(*remotesp)++;
 	}
+	if (!cnt)
+		return 1;
 	return 0;
 }
 
-/**
- * uv_flush_tlb_others - globally purge translation cache of a virtual
- * address or all TLB's
+/*
+ * globally purge translation cache of a virtual address or all TLB's
  * @cpumask: mask of all cpu's in which the address is to be removed
  * @mm: mm_struct containing virtual address range
  * @va: virtual address to be removed (or TLB_FLUSH_ALL for all TLB's on cpu)
@@ -774,46 +903,27 @@ int uv_flush_send_and_wait(struct bau_de
  * done.  The returned pointer is valid till preemption is re-enabled.
  */
 const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
-					  struct mm_struct *mm,
-					  unsigned long va, unsigned int cpu)
+				struct mm_struct *mm, unsigned long va,
+				unsigned int cpu)
 {
 	int locals = 0;
 	int remotes = 0;
 	int hubs = 0;
-	int tcpu;
-	int tpnode;
 	struct bau_desc *bau_desc;
 	struct cpumask *flush_mask;
 	struct ptc_stats *stat;
 	struct bau_control *bcp;
-	struct bau_control *tbcp;
-	struct hub_and_pnode *hpp;
 
 	/* kernel was booted 'nobau' */
 	if (nobau)
 		return cpumask;
-
 	bcp = &per_cpu(bau_control, cpu);
 	stat = bcp->statp;
-
 	/* bau was disabled due to slow response */
 	if (bcp->baudisabled) {
-		/* the cpu that disabled it must re-enable it */
-		if (bcp->set_bau_off) {
-			if (get_cycles() >= bcp->set_bau_on_time) {
-				stat->s_bau_reenabled++;
-				baudisabled = 0;
-				for_each_present_cpu(tcpu) {
-					tbcp = &per_cpu(bau_control, tcpu);
-					tbcp->baudisabled = 0;
-					tbcp->period_requests = 0;
-					tbcp->period_time = 0;
-				}
-			}
-		}
-		return cpumask;
+		if (check_enable(bcp, stat))
+			return cpumask;
 	}
-
 	/*
 	 * Each sending cpu has a per-cpu mask which it fills from the caller's
 	 * cpu mask.  All cpus are converted to uvhubs and copied to the
@@ -824,57 +934,14 @@ const struct cpumask *uv_flush_tlb_other
 	cpumask_andnot(flush_mask, cpumask, cpumask_of(cpu));
 	if (cpu_isset(cpu, *cpumask))
 		stat->s_ntargself++;
-
 	bau_desc = bcp->descriptor_base;
-	bau_desc += UV_ITEMS_PER_DESCRIPTOR * bcp->uvhub_cpu;
+	bau_desc += ITEMS_PER_DESC * bcp->uvhub_cpu;
 	bau_uvhubs_clear(&bau_desc->distribution, UV_DISTRIBUTION_SIZE);
-
-	for_each_cpu(tcpu, flush_mask) {
-		/*
-		 * The distribution vector is a bit map of pnodes, relative
-		 * to the partition base pnode (and the partition base nasid
-		 * in the header).
-		 * Translate cpu to pnode and hub using an array stored
-		 * in local memory.
-		 */
-		hpp = &bcp->socket_master->target_hub_and_pnode[tcpu];
-		tpnode = hpp->pnode - bcp->partition_base_pnode;
-		bau_uvhub_set(tpnode, &bau_desc->distribution);
-		if (hpp->uvhub == bcp->uvhub)
-			locals++;
-		else
-			remotes++;
-	}
-	if ((locals + remotes) == 0)
+	if (set_distrib_bits(flush_mask, bcp, bau_desc, &locals, &remotes))
 		return NULL;
-	stat->s_requestor++;
-	stat->s_ntargcpu += remotes + locals;
-	stat->s_ntargremotes += remotes;
-	stat->s_ntarglocals += locals;
-	remotes = bau_uvhub_weight(&bau_desc->distribution);
-
-	/* uvhub statistics */
-	hubs = bau_uvhub_weight(&bau_desc->distribution);
-	if (locals) {
-		stat->s_ntarglocaluvhub++;
-		stat->s_ntargremoteuvhub += (hubs - 1);
-	} else
-		stat->s_ntargremoteuvhub += hubs;
-	stat->s_ntarguvhub += hubs;
-	if (hubs >= 16)
-		stat->s_ntarguvhub16++;
-	else if (hubs >= 8)
-		stat->s_ntarguvhub8++;
-	else if (hubs >= 4)
-		stat->s_ntarguvhub4++;
-	else if (hubs >= 2)
-		stat->s_ntarguvhub2++;
-	else
-		stat->s_ntarguvhub1++;
-
+	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
 	bau_desc->payload.address = va;
 	bau_desc->payload.sending_cpu = cpu;
-
 	/*
 	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,
 	 * or 1 if it gave up and the original cpumask should be returned.
@@ -914,10 +981,10 @@ void uv_bau_message_interrupt(struct pt_
 	msgdesc.va_queue_first = bcp->va_queue_first;
 	msgdesc.va_queue_last = bcp->va_queue_last;
 	msg = bcp->bau_msg_head;
-	while (msg->sw_ack_vector) {
+	while (msg->swack_vec) {
 		count++;
 		msgdesc.msg_slot = msg - msgdesc.va_queue_first;
-		msgdesc.sw_ack_slot = ffs(msg->sw_ack_vector) - 1;
+		msgdesc.swack_slot = ffs(msg->swack_vec) - 1;
 		msgdesc.msg = msg;
 		uv_bau_process_message(&msgdesc, bcp);
 		msg++;
@@ -934,9 +1001,7 @@ void uv_bau_message_interrupt(struct pt_
 }
 
 /*
- * uv_enable_timeouts
- *
- * Each target uvhub (i.e. a uvhub that has no cpu's) needs to have
+ * Each target uvhub (i.e. a uvhub that has cpu's) needs to have
  * shootdown message timeouts enabled.  The timeout does not cause
  * an interrupt, but causes an error message to be returned to
  * the sender.
@@ -955,41 +1020,33 @@ static void __init uv_enable_timeouts(vo
 			continue;
 
 		pnode = uv_blade_to_pnode(uvhub);
-		mmr_image =
-		    uv_read_global_mmr64(pnode, UVH_LB_BAU_MISC_CONTROL);
+		mmr_image = read_mmr_misc_control(pnode);
 		/*
 		 * Set the timeout period and then lock it in, in three
 		 * steps; captures and locks in the period.
 		 *
 		 * To program the period, the SOFT_ACK_MODE must be off.
 		 */
-		mmr_image &= ~((unsigned long)1 <<
-		    UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT);
-		uv_write_global_mmr64
-		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
+		mmr_image &= ~(1L << SOFTACK_MSHIFT);
+		write_mmr_misc_control(pnode, mmr_image);
 		/*
 		 * Set the 4-bit period.
 		 */
-		mmr_image &= ~((unsigned long)0xf <<
-		     UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT);
-		mmr_image |= (UV_INTD_SOFT_ACK_TIMEOUT_PERIOD <<
-		     UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT);
-		uv_write_global_mmr64
-		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
+		mmr_image &= ~((unsigned long)0xf << SOFTACK_PSHIFT);
+		mmr_image |= (SOFTACK_TIMEOUT_PERIOD << SOFTACK_PSHIFT);
+		write_mmr_misc_control(pnode, mmr_image);
 		/*
 		 * UV1:
 		 * Subsequent reversals of the timebase bit (3) cause an
 		 * immediate timeout of one or all INTD resources as
 		 * indicated in bits 2:0 (7 causes all of them to timeout).
 		 */
-		mmr_image |= ((unsigned long)1 <<
-		    UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT);
+		mmr_image |= (1L << SOFTACK_MSHIFT);
 		if (is_uv2_hub()) {
-			mmr_image |= ((unsigned long)1 << UV2_LEG_SHFT);
-			mmr_image |= ((unsigned long)1 << UV2_EXT_SHFT);
+			mmr_image |= (1L << UV2_LEG_SHFT);
+			mmr_image |= (1L << UV2_EXT_SHFT);
 		}
-		uv_write_global_mmr64
-		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
+		write_mmr_misc_control(pnode, mmr_image);
 	}
 }
 
@@ -1012,8 +1069,7 @@ static void uv_ptc_seq_stop(struct seq_f
 {
 }
 
-static inline unsigned long long
-microsec_2_cycles(unsigned long microsec)
+static inline unsigned long long microsec_2_cycles(unsigned long microsec)
 {
 	unsigned long ns;
 	unsigned long long cyc;
@@ -1024,8 +1080,9 @@ microsec_2_cycles(unsigned long microsec
 }
 
 /*
- * Display the statistics thru /proc.
+ * Display the statistics thru /proc/sgi_uv/ptc_statistics
  * 'data' points to the cpu number
+ * Note: see the descriptions in stat_description[].
  */
 static int uv_ptc_seq_show(struct seq_file *file, void *data)
 {
@@ -1033,20 +1090,17 @@ static int uv_ptc_seq_show(struct seq_fi
 	int cpu;
 
 	cpu = *(loff_t *)data;
-
 	if (!cpu) {
 		seq_printf(file,
 			"# cpu sent stime self locals remotes ncpus localhub ");
 		seq_printf(file,
 			"remotehub numuvhubs numuvhubs16 numuvhubs8 ");
 		seq_printf(file,
-			"numuvhubs4 numuvhubs2 numuvhubs1 dto ");
-		seq_printf(file,
-			"retries rok resetp resett giveup sto bz throt ");
+			"numuvhubs4 numuvhubs2 numuvhubs1 dto retries rok ");
 		seq_printf(file,
-			"sw_ack recv rtime all ");
+			"resetp resett giveup sto bz throt swack recv rtime ");
 		seq_printf(file,
-			"one mult none retry canc nocan reset rcan ");
+			"all one mult none retry canc nocan reset rcan ");
 		seq_printf(file,
 			"disable enable\n");
 	}
@@ -1073,8 +1127,7 @@ static int uv_ptc_seq_show(struct seq_fi
 		/* destination side statistics */
 		seq_printf(file,
 			   "%lx %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld ",
-			   uv_read_global_mmr64(uv_cpu_to_pnode(cpu),
-					UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE),
+			   read_global_mmr_sw_ack(uv_cpu_to_pnode(cpu)),
 			   stat->d_requestee, cycles_2_us(stat->d_time),
 			   stat->d_alltlb, stat->d_onetlb, stat->d_multmsg,
 			   stat->d_nomsg, stat->d_retries, stat->d_canceled,
@@ -1083,7 +1136,6 @@ static int uv_ptc_seq_show(struct seq_fi
 		seq_printf(file, "%ld %ld\n",
 			stat->s_bau_disabled, stat->s_bau_reenabled);
 	}
-
 	return 0;
 }
 
@@ -1091,16 +1143,16 @@ static int uv_ptc_seq_show(struct seq_fi
  * Display the tunables thru debugfs
  */
 static ssize_t tunables_read(struct file *file, char __user *userbuf,
-						size_t count, loff_t *ppos)
+				size_t count, loff_t *ppos)
 {
 	char *buf;
 	int ret;
 
 	buf = kasprintf(GFP_KERNEL, "%s %s %s\n%d %d %d %d %d %d %d %d %d\n",
-		"max_bau_concurrent plugged_delay plugsb4reset",
+		"max_concur plugged_delay plugsb4reset",
 		"timeoutsb4reset ipi_reset_limit complete_threshold",
 		"congested_response_us congested_reps congested_period",
-		max_bau_concurrent, plugged_delay, plugsb4reset,
+		max_concurr, plugged_delay, plugsb4reset,
 		timeoutsb4reset, ipi_reset_limit, complete_threshold,
 		congested_response_us, congested_reps, congested_period);
 
@@ -1113,13 +1165,16 @@ static ssize_t tunables_read(struct file
 }
 
 /*
- * -1: resetf the statistics
+ * handle a write to /proc/sgi_uv/ptc_statistics
+ * -1: reset the statistics
  *  0: display meaning of the statistics
  */
 static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
-				 size_t count, loff_t *data)
+				size_t count, loff_t *data)
 {
 	int cpu;
+	int i;
+	int elements;
 	long input_arg;
 	char optstr[64];
 	struct ptc_stats *stat;
@@ -1135,73 +1190,11 @@ static ssize_t uv_ptc_proc_write(struct
 	}
 
 	if (input_arg == 0) {
+		elements = sizeof(stat_description)/sizeof(*stat_description);
 		printk(KERN_DEBUG "# cpu:      cpu number\n");
 		printk(KERN_DEBUG "Sender statistics:\n");
-		printk(KERN_DEBUG
-		"sent:     number of shootdown messages sent\n");
-		printk(KERN_DEBUG
-		"stime:    time spent sending messages\n");
-		printk(KERN_DEBUG
-		"numuvhubs: number of hubs targeted with shootdown\n");
-		printk(KERN_DEBUG
-		"numuvhubs16: number times 16 or more hubs targeted\n");
-		printk(KERN_DEBUG
-		"numuvhubs8: number times 8 or more hubs targeted\n");
-		printk(KERN_DEBUG
-		"numuvhubs4: number times 4 or more hubs targeted\n");
-		printk(KERN_DEBUG
-		"numuvhubs2: number times 2 or more hubs targeted\n");
-		printk(KERN_DEBUG
-		"numuvhubs1: number times 1 hub targeted\n");
-		printk(KERN_DEBUG
-		"numcpus:  number of cpus targeted with shootdown\n");
-		printk(KERN_DEBUG
-		"dto:      number of destination timeouts\n");
-		printk(KERN_DEBUG
-		"retries:  destination timeout retries sent\n");
-		printk(KERN_DEBUG
-		"rok:   :  destination timeouts successfully retried\n");
-		printk(KERN_DEBUG
-		"resetp:   ipi-style resource resets for plugs\n");
-		printk(KERN_DEBUG
-		"resett:   ipi-style resource resets for timeouts\n");
-		printk(KERN_DEBUG
-		"giveup:   fall-backs to ipi-style shootdowns\n");
-		printk(KERN_DEBUG
-		"sto:      number of source timeouts\n");
-		printk(KERN_DEBUG
-		"bz:       number of stay-busy's\n");
-		printk(KERN_DEBUG
-		"throt:    number times spun in throttle\n");
-		printk(KERN_DEBUG "Destination side statistics:\n");
-		printk(KERN_DEBUG
-		"sw_ack:   image of UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE\n");
-		printk(KERN_DEBUG
-		"recv:     shootdown messages received\n");
-		printk(KERN_DEBUG
-		"rtime:    time spent processing messages\n");
-		printk(KERN_DEBUG
-		"all:      shootdown all-tlb messages\n");
-		printk(KERN_DEBUG
-		"one:      shootdown one-tlb messages\n");
-		printk(KERN_DEBUG
-		"mult:     interrupts that found multiple messages\n");
-		printk(KERN_DEBUG
-		"none:     interrupts that found no messages\n");
-		printk(KERN_DEBUG
-		"retry:    number of retry messages processed\n");
-		printk(KERN_DEBUG
-		"canc:     number messages canceled by retries\n");
-		printk(KERN_DEBUG
-		"nocan:    number retries that found nothing to cancel\n");
-		printk(KERN_DEBUG
-		"reset:    number of ipi-style reset requests processed\n");
-		printk(KERN_DEBUG
-		"rcan:     number messages canceled by reset requests\n");
-		printk(KERN_DEBUG
-		"disable:  number times use of the BAU was disabled\n");
-		printk(KERN_DEBUG
-		"enable:   number times use of the BAU was re-enabled\n");
+		for (i = 0; i < elements; i++)
+			printk(KERN_DEBUG "%s\n", stat_description[i]);
 	} else if (input_arg == -1) {
 		for_each_present_cpu(cpu) {
 			stat = &per_cpu(ptcstats, cpu);
@@ -1228,27 +1221,18 @@ static int local_atoi(const char *name)
 }
 
 /*
- * set the tunables
- * 0 values reset them to defaults
+ * Parse the values written to /sys/kernel/debug/sgi_uv/bau_tunables.
+ * Zero values reset them to defaults.
  */
-static ssize_t tunables_write(struct file *file, const char __user *user,
-				 size_t count, loff_t *data)
+static int parse_tunables_write(struct bau_control *bcp, char *instr,
+				int count)
 {
-	int cpu;
-	int cnt = 0;
-	int val;
 	char *p;
 	char *q;
-	char instr[64];
-	struct bau_control *bcp;
-
-	if (count == 0 || count > sizeof(instr)-1)
-		return -EINVAL;
-	if (copy_from_user(instr, user, count))
-		return -EFAULT;
+	int cnt = 0;
+	int val;
+	int e = sizeof(tunables) / sizeof(*tunables);
 
-	instr[count] = '\0';
-	/* count the fields */
 	p = instr + strspn(instr, WHITESPACE);
 	q = p;
 	for (; *p; p = q + strspn(q, WHITESPACE)) {
@@ -1257,11 +1241,10 @@ static ssize_t tunables_write(struct fil
 		if (q == p)
 			break;
 	}
-	if (cnt != 9) {
-		printk(KERN_INFO "bau tunable error: should be 9 numbers\n");
+	if (cnt != e) {
+		printk(KERN_INFO "bau tunable error: should be %d values\n", e);
 		return -EINVAL;
 	}
-
 	p = instr + strspn(instr, WHITESPACE);
 	q = p;
 	for (cnt = 0; *p; p = q + strspn(q, WHITESPACE), cnt++) {
@@ -1270,85 +1253,64 @@ static ssize_t tunables_write(struct fil
 		switch (cnt) {
 		case 0:
 			if (val == 0) {
-				max_bau_concurrent = MAX_BAU_CONCURRENT;
-				max_bau_concurrent_constant =
-							MAX_BAU_CONCURRENT;
+				max_concurr = MAX_BAU_CONCURRENT;
+				max_concurr_const = MAX_BAU_CONCURRENT;
 				continue;
 			}
-			bcp = &per_cpu(bau_control, smp_processor_id());
 			if (val < 1 || val > bcp->cpus_in_uvhub) {
 				printk(KERN_DEBUG
 				"Error: BAU max concurrent %d is invalid\n",
 				val);
 				return -EINVAL;
 			}
-			max_bau_concurrent = val;
-			max_bau_concurrent_constant = val;
-			continue;
-		case 1:
-			if (val == 0)
-				plugged_delay = PLUGGED_DELAY;
-			else
-				plugged_delay = val;
-			continue;
-		case 2:
-			if (val == 0)
-				plugsb4reset = PLUGSB4RESET;
-			else
-				plugsb4reset = val;
-			continue;
-		case 3:
-			if (val == 0)
-				timeoutsb4reset = TIMEOUTSB4RESET;
-			else
-				timeoutsb4reset = val;
-			continue;
-		case 4:
-			if (val == 0)
-				ipi_reset_limit = IPI_RESET_LIMIT;
-			else
-				ipi_reset_limit = val;
-			continue;
-		case 5:
-			if (val == 0)
-				complete_threshold = COMPLETE_THRESHOLD;
-			else
-				complete_threshold = val;
-			continue;
-		case 6:
-			if (val == 0)
-				congested_response_us = CONGESTED_RESPONSE_US;
-			else
-				congested_response_us = val;
+			max_concurr = val;
+			max_concurr_const = val;
 			continue;
-		case 7:
-			if (val == 0)
-				congested_reps = CONGESTED_REPS;
-			else
-				congested_reps = val;
-			continue;
-		case 8:
+		default:
 			if (val == 0)
-				congested_period = CONGESTED_PERIOD;
+				*tunables[cnt].tunp = tunables[cnt].deflt;
 			else
-				congested_period = val;
+				*tunables[cnt].tunp = val;
 			continue;
 		}
 		if (q == p)
 			break;
 	}
+	return 0;
+}
+
+/*
+ * Handle a write to debugfs. (/sys/kernel/debug/sgi_uv/bau_tunables)
+ */
+static ssize_t tunables_write(struct file *file, const char __user *user,
+				size_t count, loff_t *data)
+{
+	int cpu;
+	int ret;
+	char instr[100];
+	struct bau_control *bcp;
+
+	if (count == 0 || count > sizeof(instr)-1)
+		return -EINVAL;
+	if (copy_from_user(instr, user, count))
+		return -EFAULT;
+	instr[count] = '\0';
+	bcp = &per_cpu(bau_control, smp_processor_id());
+	ret = parse_tunables_write(bcp, instr, count);
+	if (ret)
+		return ret;
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
-		bcp->max_bau_concurrent = max_bau_concurrent;
-		bcp->max_bau_concurrent_constant = max_bau_concurrent;
+		bcp->max_concurr = max_concurr;
+		bcp->max_concurr_const = max_concurr;
 		bcp->plugged_delay = plugged_delay;
 		bcp->plugsb4reset = plugsb4reset;
 		bcp->timeoutsb4reset = timeoutsb4reset;
 		bcp->ipi_reset_limit = ipi_reset_limit;
 		bcp->complete_threshold = complete_threshold;
-		bcp->congested_response_us = congested_response_us;
-		bcp->congested_reps = congested_reps;
-		bcp->congested_period = congested_period;
+		bcp->cong_response_us = congested_response_us;
+		bcp->cong_reps = congested_reps;
+		bcp->cong_period = congested_period;
 	}
 	return count;
 }
@@ -1407,7 +1369,7 @@ static int __init uv_ptc_init(void)
 		return -EINVAL;
 	}
 	tunables_file = debugfs_create_file(UV_BAU_TUNABLES_FILE, 0600,
-			tunables_dir, NULL, &tunables_fops);
+					tunables_dir, NULL, &tunables_fops);
 	if (!tunables_file) {
 		printk(KERN_ERR "unable to create debugfs file %s\n",
 		       UV_BAU_TUNABLES_FILE);
@@ -1419,24 +1381,24 @@ static int __init uv_ptc_init(void)
 /*
  * Initialize the sending side's sending buffers.
  */
-static void
-uv_activation_descriptor_init(int node, int pnode, int base_pnode)
+static void uv_activation_descriptor_init(int node, int pnode, int base_pnode)
 {
 	int i;
 	int cpu;
 	unsigned long pa;
 	unsigned long m;
 	unsigned long n;
+	size_t dsize;
 	struct bau_desc *bau_desc;
 	struct bau_desc *bd2;
 	struct bau_control *bcp;
 
 	/*
-	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
-	 * per cpu; and one per cpu on the uvhub (UV_ADP_SIZE)
+	 * each bau_desc is 64 bytes; there are 8 (ITEMS_PER_DESC)
+	 * per cpu; and one per cpu on the uvhub (ADP_SZ)
 	 */
-	bau_desc = kmalloc_node(sizeof(struct bau_desc) * UV_ADP_SIZE
-				* UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
+	dsize = sizeof(struct bau_desc) * ADP_SZ * ITEMS_PER_DESC;
+	bau_desc = kmalloc_node(dsize, GFP_KERNEL, node);
 	BUG_ON(!bau_desc);
 
 	pa = uv_gpa(bau_desc); /* need the real nasid*/
@@ -1444,17 +1406,15 @@ uv_activation_descriptor_init(int node,
 	m = pa & uv_mmask;
 
 	/* the 14-bit pnode */
-	uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE,
-			      (n << UV_DESC_BASE_PNODE_SHIFT | m));
+	write_mmr_descriptor_base(pnode, (n << UV_DESC_PSHIFT | m));
 	/*
-	 * Initializing all 8 (UV_ITEMS_PER_DESCRIPTOR) descriptors for each
+	 * Initializing all 8 (ITEMS_PER_DESC) descriptors for each
 	 * cpu even though we only use the first one; one descriptor can
 	 * describe a broadcast to 256 uv hubs.
 	 */
-	for (i = 0, bd2 = bau_desc; i < (UV_ADP_SIZE*UV_ITEMS_PER_DESCRIPTOR);
-		i++, bd2++) {
+	for (i = 0, bd2 = bau_desc; i < (ADP_SZ * ITEMS_PER_DESC); i++, bd2++) {
 		memset(bd2, 0, sizeof(struct bau_desc));
-		bd2->header.sw_ack_flag = 1;
+		bd2->header.swack_flag = 1;
 		/*
 		 * The base_dest_nasid set in the message header is the nasid
 		 * of the first uvhub in the partition. The bit map will
@@ -1484,22 +1444,23 @@ uv_activation_descriptor_init(int node,
  * - node is first node (kernel memory notion) on the uvhub
  * - pnode is the uvhub's physical identifier
  */
-static void
-uv_payload_queue_init(int node, int pnode)
+static void uv_payload_queue_init(int node, int pnode)
 {
-	int pn;
 	int cpu;
+	size_t plsize;
 	char *cp;
-	unsigned long pa;
+	void *vp;
+	unsigned long pn;
+	unsigned long first;
+	unsigned long pn_first;
+	unsigned long last;
 	struct bau_payload_queue_entry *pqp;
-	struct bau_payload_queue_entry *pqp_malloc;
 	struct bau_control *bcp;
 
-	pqp = kmalloc_node((DEST_Q_SIZE + 1)
-			   * sizeof(struct bau_payload_queue_entry),
-			   GFP_KERNEL, node);
+	plsize = (DEST_Q_SIZE + 1) * sizeof(struct bau_payload_queue_entry);
+	vp = kmalloc_node(plsize, GFP_KERNEL, node);
+	pqp = (struct bau_payload_queue_entry *)vp;
 	BUG_ON(!pqp);
-	pqp_malloc = pqp;
 
 	cp = (char *)pqp + 31;
 	pqp = (struct bau_payload_queue_entry *)(((unsigned long)cp >> 5) << 5);
@@ -1516,17 +1477,13 @@ uv_payload_queue_init(int node, int pnod
 	/*
 	 * need the pnode of where the memory was really allocated
 	 */
-	pa = uv_gpa(pqp);
-	pn = pa >> uv_nshift;
-	uv_write_global_mmr64(pnode,
-			      UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST,
-			      ((unsigned long)pn << UV_PAYLOADQ_PNODE_SHIFT) |
-			      uv_physnodeaddr(pqp));
-	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL,
-			      uv_physnodeaddr(pqp));
-	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST,
-			      (unsigned long)
-			      uv_physnodeaddr(pqp + (DEST_Q_SIZE - 1)));
+	pn = uv_gpa(pqp) >> uv_nshift;
+	first = uv_physnodeaddr(pqp);
+	pn_first = ((unsigned long)pn << UV_PAYLOADQ_PNODE_SHIFT) | first;
+	last = uv_physnodeaddr(pqp + (DEST_Q_SIZE - 1));
+	write_mmr_payload_first(pnode, pn_first);
+	write_mmr_payload_tail(pnode, first);
+	write_mmr_payload_last(pnode, last);
 	/* in effect, all msg_type's are set to MSG_NOOP */
 	memset(pqp, 0, sizeof(struct bau_payload_queue_entry) * DEST_Q_SIZE);
 }
@@ -1549,17 +1506,15 @@ static void __init uv_init_uvhub(int uvh
 	 * messaging IRQ will be determined by the OS.
 	 */
 	apicid = uvhub_to_first_apicid(uvhub) | uv_apicid_hibits;
-	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
-				      ((apicid << 32) | vector));
+	write_mmr_data_config(pnode, ((apicid << 32) | vector));
 }
 
 /*
  * We will set BAU_MISC_CONTROL with a timeout period.
  * But the BIOS has set UVH_AGING_PRESCALE_SEL and UVH_TRANSACTION_TIMEOUT.
- * So the destination timeout period has be be calculated from them.
+ * So the destination timeout period has to be calculated from them.
  */
-static int
-calculate_destination_timeout(void)
+static int calculate_destination_timeout(void)
 {
 	unsigned long mmr_image;
 	int mult1;
@@ -1570,8 +1525,7 @@ calculate_destination_timeout(void)
 	unsigned long ts_ns;
 
 	if (is_uv1_hub()) {
-		mult1 = UV1_INTD_SOFT_ACK_TIMEOUT_PERIOD &
-			BAU_MISC_CONTROL_MULT_MASK;
+		mult1 = SOFTACK_TIMEOUT_PERIOD & BAU_MISC_CONTROL_MULT_MASK;
 		mmr_image = uv_read_local_mmr(UVH_AGING_PRESCALE_SEL);
 		index = (mmr_image >> BAU_URGENCY_7_SHIFT) & BAU_URGENCY_7_MASK;
 		mmr_image = uv_read_local_mmr(UVH_TRANSACTION_TIMEOUT);
@@ -1583,7 +1537,7 @@ calculate_destination_timeout(void)
 		/* 4 bits  0/1 for 10/80us, 3 bits of multiplier */
 		mmr_image = uv_read_local_mmr(UVH_AGING_PRESCALE_SEL);
 		mmr_image = (mmr_image & UV_SA_MASK) >> UV_SA_SHFT;
-		if (mmr_image & ((unsigned long)1 << UV2_ACK_UNITS_SHFT))
+		if (mmr_image & (1L << UV2_ACK_UNITS_SHFT))
 			mult1 = 80;
 		else
 			mult1 = 10;
@@ -1593,56 +1547,57 @@ calculate_destination_timeout(void)
 	return ret;
 }
 
+static void __init init_per_cpu_tunables(void)
+{
+	int cpu;
+	struct bau_control *bcp;
+
+	for_each_present_cpu(cpu) {
+		bcp = &per_cpu(bau_control, cpu);
+		bcp->baudisabled = 0;
+		bcp->statp = &per_cpu(ptcstats, cpu);
+		/* time interval to catch a hardware stay-busy bug */
+		bcp->timeout_interval = microsec_2_cycles(2*timeout_us);
+		bcp->max_concurr = max_concurr;
+		bcp->max_concurr_const = max_concurr;
+		bcp->plugged_delay = plugged_delay;
+		bcp->plugsb4reset = plugsb4reset;
+		bcp->timeoutsb4reset = timeoutsb4reset;
+		bcp->ipi_reset_limit = ipi_reset_limit;
+		bcp->complete_threshold = complete_threshold;
+		bcp->cong_response_us = congested_response_us;
+		bcp->cong_reps = congested_reps;
+		bcp->cong_period = congested_period;
+	}
+}
+
 /*
- * initialize the bau_control structure for each cpu
+ * Scan all cpus to collect blade and socket summaries.
  */
-static int __init uv_init_per_cpu(int nuvhubs, int base_part_pnode)
+static int __init get_cpu_topology(int base_pnode,
+					struct uvhub_desc *uvhub_descs,
+					unsigned char *uvhub_mask)
 {
-	int i;
 	int cpu;
-	int tcpu;
 	int pnode;
 	int uvhub;
-	int have_hmaster;
-	short socket = 0;
-	unsigned short socket_mask;
-	unsigned char *uvhub_mask;
+	int socket;
 	struct bau_control *bcp;
 	struct uvhub_desc *bdp;
 	struct socket_desc *sdp;
-	struct bau_control *hmaster = NULL;
-	struct bau_control *smaster = NULL;
-	struct socket_desc {
-		short num_cpus;
-		short cpu_number[MAX_CPUS_PER_SOCKET];
-	};
-	struct uvhub_desc {
-		unsigned short socket_mask;
-		short num_cpus;
-		short uvhub;
-		short pnode;
-		struct socket_desc socket[2];
-	};
-	struct uvhub_desc *uvhub_descs;
-
-	timeout_us = calculate_destination_timeout();
 
-	uvhub_descs = kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
-	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
-	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
 		memset(bcp, 0, sizeof(struct bau_control));
 		pnode = uv_cpu_hub_info(cpu)->pnode;
-		if ((pnode - base_part_pnode) >= UV_DISTRIBUTION_SIZE) {
+		if ((pnode - base_pnode) >= UV_DISTRIBUTION_SIZE) {
 			printk(KERN_EMERG
 				"cpu %d pnode %d-%d beyond %d; BAU disabled\n",
-				cpu, pnode, base_part_pnode,
-				UV_DISTRIBUTION_SIZE);
+				cpu, pnode, base_pnode, UV_DISTRIBUTION_SIZE);
 			return 1;
 		}
 		bcp->osnode = cpu_to_node(cpu);
-		bcp->partition_base_pnode = uv_partition_base_pnode;
+		bcp->partition_base_pnode = base_pnode;
 		uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
 		*(uvhub_mask + (uvhub/8)) |= (1 << (uvhub%8));
 		bdp = &uvhub_descs[uvhub];
@@ -1657,84 +1612,133 @@ static int __init uv_init_per_cpu(int nu
 		sdp->cpu_number[sdp->num_cpus] = cpu;
 		sdp->num_cpus++;
 		if (sdp->num_cpus > MAX_CPUS_PER_SOCKET) {
-			printk(KERN_EMERG "%d cpus per socket invalid\n", sdp->num_cpus);
+			printk(KERN_EMERG "%d cpus per socket invalid\n",
+				sdp->num_cpus);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Each socket is to get a local array of pnodes/hubs.
+ */
+static void make_per_cpu_thp(struct bau_control *smaster)
+{
+	int cpu;
+	size_t hpsz = sizeof(struct hub_and_pnode) * num_possible_cpus();
+
+	smaster->thp = kmalloc_node(hpsz, GFP_KERNEL, smaster->osnode);
+	memset(smaster->thp, 0, hpsz);
+	for_each_present_cpu(cpu) {
+		smaster->thp[cpu].pnode = uv_cpu_hub_info(cpu)->pnode;
+		smaster->thp[cpu].uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
+	}
+}
+
+/*
+ * Initialize all the per_cpu information for the cpu's on a given socket,
+ * given what has been gathered into the socket_desc struct.
+ * And reports the chosen hub and socket masters back to the caller.
+ */
+static int scan_sock(struct socket_desc *sdp, struct uvhub_desc *bdp,
+			struct bau_control **smasterp,
+			struct bau_control **hmasterp)
+{
+	int i;
+	int cpu;
+	struct bau_control *bcp;
+
+	for (i = 0; i < sdp->num_cpus; i++) {
+		cpu = sdp->cpu_number[i];
+		bcp = &per_cpu(bau_control, cpu);
+		bcp->cpu = cpu;
+		if (i == 0) {
+			*smasterp = bcp;
+			if (!(*hmasterp))
+				*hmasterp = bcp;
+		}
+		bcp->cpus_in_uvhub = bdp->num_cpus;
+		bcp->cpus_in_socket = sdp->num_cpus;
+		bcp->socket_master = *smasterp;
+		bcp->uvhub = bdp->uvhub;
+		bcp->uvhub_master = *hmasterp;
+		bcp->uvhub_cpu = uv_cpu_hub_info(cpu)->
+					blade_processor_id;
+		if (bcp->uvhub_cpu >= MAX_CPUS_PER_UVHUB) {
+			printk(KERN_EMERG "%d cpus per uvhub invalid\n",
+				bcp->uvhub_cpu);
 			return 1;
 		}
 	}
+	return 0;
+}
+
+/*
+ * Summarize the blade and socket topology into the per_cpu structures.
+ */
+static int __init summarize_uvhub_sockets(int nuvhubs,
+			struct uvhub_desc *uvhub_descs,
+			unsigned char *uvhub_mask)
+{
+	int socket;
+	int uvhub;
+	unsigned short socket_mask;
+
 	for (uvhub = 0; uvhub < nuvhubs; uvhub++) {
+		struct uvhub_desc *bdp;
+		struct bau_control *smaster = NULL;
+		struct bau_control *hmaster = NULL;
 		if (!(*(uvhub_mask + (uvhub/8)) & (1 << (uvhub%8))))
 			continue;
-		have_hmaster = 0;
 		bdp = &uvhub_descs[uvhub];
 		socket_mask = bdp->socket_mask;
 		socket = 0;
 		while (socket_mask) {
-			if (!(socket_mask & 1))
-				goto nextsocket;
-			sdp = &bdp->socket[socket];
-			for (i = 0; i < sdp->num_cpus; i++) {
-				cpu = sdp->cpu_number[i];
-				bcp = &per_cpu(bau_control, cpu);
-				bcp->cpu = cpu;
-				if (i == 0) {
-					smaster = bcp;
-					if (!have_hmaster) {
-						have_hmaster++;
-						hmaster = bcp;
-					}
-				}
-				bcp->cpus_in_uvhub = bdp->num_cpus;
-				bcp->cpus_in_socket = sdp->num_cpus;
-				bcp->socket_master = smaster;
-				bcp->uvhub = bdp->uvhub;
-				bcp->uvhub_master = hmaster;
-				bcp->uvhub_cpu = uv_cpu_hub_info(cpu)->
-						blade_processor_id;
-				if (bcp->uvhub_cpu >= MAX_CPUS_PER_UVHUB) {
-					printk(KERN_EMERG
-						"%d cpus per uvhub invalid\n",
-						bcp->uvhub_cpu);
+			struct socket_desc *sdp;
+			if ((socket_mask & 1)) {
+				sdp = &bdp->socket[socket];
+				if (scan_sock(sdp, bdp, &smaster, &hmaster))
 					return 1;
-				}
+				make_per_cpu_thp(smaster);
 			}
-nextsocket:
 			socket++;
 			socket_mask = (socket_mask >> 1);
-			/* each socket gets a local array of pnodes/hubs */
-			bcp = smaster;
-			bcp->target_hub_and_pnode = kmalloc_node(
-				sizeof(struct hub_and_pnode) *
-				num_possible_cpus(), GFP_KERNEL, bcp->osnode);
-			memset(bcp->target_hub_and_pnode, 0,
-				sizeof(struct hub_and_pnode) *
-				num_possible_cpus());
-			for_each_present_cpu(tcpu) {
-				bcp->target_hub_and_pnode[tcpu].pnode =
-					uv_cpu_hub_info(tcpu)->pnode;
-				bcp->target_hub_and_pnode[tcpu].uvhub =
-					uv_cpu_hub_info(tcpu)->numa_blade_id;
-			}
 		}
 	}
+	return 0;
+}
+
+/*
+ * initialize the bau_control structure for each cpu
+ */
+static int __init uv_init_per_cpu(int nuvhubs, int base_part_pnode)
+{
+	unsigned char *uvhub_mask;
+	void *vp;
+	struct uvhub_desc *uvhub_descs;
+
+	timeout_us = calculate_destination_timeout();
+
+	vp = kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
+	uvhub_descs = (struct uvhub_desc *)vp;
+	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
+	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
+
+	if (get_cpu_topology(base_part_pnode, uvhub_descs, uvhub_mask)) {
+		kfree(uvhub_descs);
+		kfree(uvhub_mask);
+		return 1;
+	}
+	if (summarize_uvhub_sockets(nuvhubs, uvhub_descs, uvhub_mask)) {
+		kfree(uvhub_descs);
+		kfree(uvhub_mask);
+		return 1;
+	}
+
 	kfree(uvhub_descs);
 	kfree(uvhub_mask);
-	for_each_present_cpu(cpu) {
-		bcp = &per_cpu(bau_control, cpu);
-		bcp->baudisabled = 0;
-		bcp->statp = &per_cpu(ptcstats, cpu);
-		/* time interval to catch a hardware stay-busy bug */
-		bcp->timeout_interval = microsec_2_cycles(2*timeout_us);
-		bcp->max_bau_concurrent = max_bau_concurrent;
-		bcp->max_bau_concurrent_constant = max_bau_concurrent;
-		bcp->plugged_delay = plugged_delay;
-		bcp->plugsb4reset = plugsb4reset;
-		bcp->timeoutsb4reset = timeoutsb4reset;
-		bcp->ipi_reset_limit = ipi_reset_limit;
-		bcp->complete_threshold = complete_threshold;
-		bcp->congested_response_us = congested_response_us;
-		bcp->congested_reps = congested_reps;
-		bcp->congested_period = congested_period;
-	}
+	init_per_cpu_tunables();
 	return 0;
 }
 
@@ -1747,8 +1751,9 @@ static int __init uv_bau_init(void)
 	int pnode;
 	int nuvhubs;
 	int cur_cpu;
+	int cpus;
 	int vector;
-	unsigned long mmr;
+	cpumask_var_t *mask;
 
 	if (!is_uv_system())
 		return 0;
@@ -1756,9 +1761,10 @@ static int __init uv_bau_init(void)
 	if (nobau)
 		return 0;
 
-	for_each_possible_cpu(cur_cpu)
-		zalloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
-				       GFP_KERNEL, cpu_to_node(cur_cpu));
+	for_each_possible_cpu(cur_cpu) {
+		mask = &per_cpu(uv_flush_tlb_mask, cur_cpu);
+		zalloc_cpumask_var_node(mask, GFP_KERNEL, cpu_to_node(cur_cpu));
+	}
 
 	uv_nshift = uv_hub_info->m_val;
 	uv_mmask = (1UL << uv_hub_info->m_val) - 1;
@@ -1766,14 +1772,14 @@ static int __init uv_bau_init(void)
 	spin_lock_init(&disable_lock);
 	congested_cycles = microsec_2_cycles(congested_response_us);
 
-	uv_partition_base_pnode = 0x7fffffff;
+	uv_base_pnode = 0x7fffffff;
 	for (uvhub = 0; uvhub < nuvhubs; uvhub++) {
-		if (uv_blade_nr_possible_cpus(uvhub) &&
-			(uv_blade_to_pnode(uvhub) < uv_partition_base_pnode))
-			uv_partition_base_pnode = uv_blade_to_pnode(uvhub);
+		cpus = uv_blade_nr_possible_cpus(uvhub);
+		if (cpus && (uv_blade_to_pnode(uvhub) < uv_base_pnode))
+			uv_base_pnode = uv_blade_to_pnode(uvhub);
 	}
 
-	if (uv_init_per_cpu(nuvhubs, uv_partition_base_pnode)) {
+	if (uv_init_per_cpu(nuvhubs, uv_base_pnode)) {
 		nobau = 1;
 		return 0;
 	}
@@ -1781,21 +1787,21 @@ static int __init uv_bau_init(void)
 	vector = UV_BAU_MESSAGE;
 	for_each_possible_blade(uvhub)
 		if (uv_blade_nr_possible_cpus(uvhub))
-			uv_init_uvhub(uvhub, vector, uv_partition_base_pnode);
+			uv_init_uvhub(uvhub, vector, uv_base_pnode);
 
 	uv_enable_timeouts();
 	alloc_intr_gate(vector, uv_bau_message_intr1);
 
 	for_each_possible_blade(uvhub) {
 		if (uv_blade_nr_possible_cpus(uvhub)) {
+			unsigned long val;
+			unsigned long mmr;
 			pnode = uv_blade_to_pnode(uvhub);
 			/* INIT the bau */
-			uv_write_global_mmr64(pnode,
-					UVH_LB_BAU_SB_ACTIVATION_CONTROL,
-					((unsigned long)1 << 63));
+			val = 1L << 63;
+			write_global_mmr_activation(pnode, val);
 			mmr = 1; /* should be 1 to broadcast to both sockets */
-			uv_write_global_mmr64(pnode, UVH_BAU_DATA_BROADCAST,
-						mmr);
+			write_mmr_data_broadcast(pnode, mmr);
 		}
 	}
 
