Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1FNXF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 19:05:58 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60828 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751404Ab1FNXF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 19:05:56 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4 of 6] x86, UV: correct reset_with_ipi()
Cc: mingo@elte.hu
Message-Id: <E1QWchM-0004NL-M6@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 14 Jun 2011 18:07:04 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Fix reset_with_ipi() to look up a cpu for a blade based on the
distribution map being indexed by the potentially sparsely numbered pnode
(relative to the partition base pnode). (It had been doing it based on
0-based, consecutive blade id.)
Rename 'hubmask' to 'pnmask' for clarity.

And remove the stack-resident cpumask_t from reset_with_ipi() by allocating
one per uvhub.

(applies with fuzz if not after earlier patches)

Diffed against 3.0.0-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |   13 +++++----
 arch/x86/platform/uv/tlb_uv.c
 arch/x86/include/asm/uv/uv_bau.h |   13 +++++----
 arch/x86/platform/uv/tlb_uv.c    |   54 ++++++++++++++++++++++++++-------------
 2 files changed, 44 insertions(+), 23 deletions(-)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -296,14 +296,18 @@ static void bau_process_message(struct m
 }
 
 /*
- * Determine the first cpu on a uvhub.
+ * Determine the first cpu on a pnode.
  */
-static int uvhub_to_first_cpu(int uvhub)
+static int pnode_to_first_cpu(int pnode, struct bau_control *smaster)
 {
 	int cpu;
-	for_each_present_cpu(cpu)
-		if (uvhub == uv_cpu_to_blade_id(cpu))
+	struct hub_and_pnode *hpp;
+
+	for_each_present_cpu(cpu) {
+		hpp = &smaster->thp[cpu];
+		if (pnode == hpp->pnode)
 			return cpu;
+	}
 	return -1;
 }
 
@@ -366,28 +370,33 @@ static void do_reset(void *ptr)
  * Use IPI to get all target uvhubs to release resources held by
  * a given sending cpu number.
  */
-static void reset_with_ipi(struct bau_targ_hubmask *distribution, int sender)
+static void reset_with_ipi(struct pnmask *distribution, struct bau_control *bcp)
 {
-	int uvhub;
+	int pnode;
+	int apnode;
 	int maskbits;
-	cpumask_t mask;
+	int sender = bcp->cpu;
+	cpumask_t *mask = bcp->uvhub_master->cpumask;
+	struct bau_control *smaster = bcp->socket_master;
 	struct reset_args reset_args;
 
 	reset_args.sender = sender;
-	cpus_clear(mask);
+	cpus_clear(*mask);
 	/* find a single cpu for each uvhub in this distribution mask */
-	maskbits = sizeof(struct bau_targ_hubmask) * BITSPERBYTE;
-	for (uvhub = 0; uvhub < maskbits; uvhub++) {
+	maskbits = sizeof(struct pnmask) * BITSPERBYTE;
+	/* each bit is a pnode relative to the partition base pnode */
+	for (pnode = 0; pnode < maskbits; pnode++) {
 		int cpu;
-		if (!bau_uvhub_isset(uvhub, distribution))
+
+		if (!bau_uvhub_isset(pnode, distribution))
 			continue;
-		/* find a cpu for this uvhub */
-		cpu = uvhub_to_first_cpu(uvhub);
-		cpu_set(cpu, mask);
+		apnode = pnode + bcp->partition_base_pnode;
+		cpu = pnode_to_first_cpu(apnode, smaster);
+		cpu_set(cpu, *mask);
 	}
 
 	/* IPI all cpus; preemption is already disabled */
-	smp_call_function_many(&mask, do_reset, (void *)&reset_args, 1);
+	smp_call_function_many(mask, do_reset, (void *)&reset_args, 1);
 	return;
 }
 
@@ -604,7 +613,7 @@ static void destination_plugged(struct b
 		quiesce_local_uvhub(hmaster);
 
 		spin_lock(&hmaster->queue_lock);
-		reset_with_ipi(&bau_desc->distribution, bcp->cpu);
+		reset_with_ipi(&bau_desc->distribution, bcp);
 		spin_unlock(&hmaster->queue_lock);
 
 		end_uvhub_quiesce(hmaster);
@@ -626,7 +635,7 @@ static void destination_timeout(struct b
 		quiesce_local_uvhub(hmaster);
 
 		spin_lock(&hmaster->queue_lock);
-		reset_with_ipi(&bau_desc->distribution, bcp->cpu);
+		reset_with_ipi(&bau_desc->distribution, bcp);
 		spin_unlock(&hmaster->queue_lock);
 
 		end_uvhub_quiesce(hmaster);
@@ -1689,6 +1698,16 @@ static void make_per_cpu_thp(struct bau_
 }
 
 /*
+ * Each uvhub is to get a local cpumask.
+ */
+static void make_per_hub_cpumask(struct bau_control *hmaster)
+{
+	int sz = sizeof(cpumask_t);
+
+	hmaster->cpumask = kzalloc_node(sz, GFP_KERNEL, hmaster->osnode);
+}
+
+/*
  * Initialize all the per_cpu information for the cpu's on a given socket,
  * given what has been gathered into the socket_desc struct.
  * And reports the chosen hub and socket masters back to the caller.
@@ -1758,6 +1777,7 @@ static int __init summarize_uvhub_socket
 			socket++;
 			socket_mask = (socket_mask >> 1);
 		}
+		make_per_hub_cpumask(hmaster);
 	}
 	return 0;
 }
Index: linux/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linux/arch/x86/include/asm/uv/uv_bau.h
@@ -183,7 +183,7 @@
  * 'base_dest_nasid' field of the header corresponds to the
  * destination nodeID associated with that specified bit.
  */
-struct bau_targ_hubmask {
+struct pnmask {
 	unsigned long		bits[BITS_TO_LONGS(UV_DISTRIBUTION_SIZE)];
 };
 
@@ -314,7 +314,7 @@ struct bau_msg_header {
  * Should be 64 bytes
  */
 struct bau_desc {
-	struct bau_targ_hubmask	distribution;
+	struct pnmask		distribution;
 	/*
 	 * message template, consisting of header and payload:
 	 */
@@ -488,6 +488,7 @@ struct bau_control {
 	struct bau_control	*uvhub_master;
 	struct bau_control	*socket_master;
 	struct ptc_stats	*statp;
+	cpumask_t		*cpumask;
 	unsigned long		timeout_interval;
 	unsigned long		set_bau_on_time;
 	atomic_t		active_descriptor_count;
@@ -596,20 +597,20 @@ static inline void write_mmr_data_config
 	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG, mr);
 }
 
-static inline int bau_uvhub_isset(int uvhub, struct bau_targ_hubmask *dstp)
+static inline int bau_uvhub_isset(int uvhub, struct pnmask *dstp)
 {
 	return constant_test_bit(uvhub, &dstp->bits[0]);
 }
-static inline void bau_uvhub_set(int pnode, struct bau_targ_hubmask *dstp)
+static inline void bau_uvhub_set(int pnode, struct pnmask *dstp)
 {
 	__set_bit(pnode, &dstp->bits[0]);
 }
-static inline void bau_uvhubs_clear(struct bau_targ_hubmask *dstp,
+static inline void bau_uvhubs_clear(struct pnmask *dstp,
 				    int nbits)
 {
 	bitmap_zero(&dstp->bits[0], nbits);
 }
-static inline int bau_uvhub_weight(struct bau_targ_hubmask *dstp)
+static inline int bau_uvhub_weight(struct pnmask *dstp)
 {
 	return bitmap_weight((unsigned long *)&dstp->bits[0],
 				UV_DISTRIBUTION_SIZE);
