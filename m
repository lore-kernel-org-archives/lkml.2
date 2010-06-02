Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab0FBVVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:21:48 -0400
Received: from relay3.sgi.com ([192.48.152.1]:45283 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932899Ab0FBVVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:21:34 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/11] x86, UV: shorten access to BAU statistics structure
Cc: mingo@elte.hu, hpa@zytor.com, gregkh@suse.de
Message-Id: <E1OJvNy-0004aB-2k@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 02 Jun 2010 16:22:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use a pointer from the per-cpu BAU control structure to the per-cpu
BAU statistics structure.
We nearly always know the first before needing the second.

Diffed against 2.6.34 -tip

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/include/asm/uv/uv_bau.h |    1 +
 arch/x86/kernel/tlb_uv.c         |   16 ++++++++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

Index: 100531.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100531.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100531.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -153,7 +153,7 @@ static inline void uv_bau_process_retry_
 	struct ptc_stats *stat;
 
 	msg = mdp->msg;
-	stat = &per_cpu(ptcstats, bcp->cpu);
+	stat = bcp->statp;
 	stat->d_retries++;
 	/*
 	 * cancel any message from msg+1 to the retry itself
@@ -217,7 +217,7 @@ static void uv_bau_process_message(struc
 	 * This must be a normal message, or retry of a normal message
 	 */
 	msg = mdp->msg;
-	stat = &per_cpu(ptcstats, bcp->cpu);
+	stat = bcp->statp;
 	if (msg->address == TLB_FLUSH_ALL) {
 		local_flush_tlb();
 		stat->d_alltlb++;
@@ -301,7 +301,7 @@ uv_do_reset(void *ptr)
 
 	bcp = &per_cpu(bau_control, smp_processor_id());
 	rap = (struct reset_args *)ptr;
-	stat = &per_cpu(ptcstats, bcp->cpu);
+	stat = bcp->statp;
 	stat->d_resets++;
 
 	/*
@@ -419,7 +419,7 @@ static int uv_wait_completion(struct bau
 	unsigned long mask;
 	cycles_t ttime;
 	cycles_t timeout_time;
-	struct ptc_stats *stat = &per_cpu(ptcstats, this_cpu);
+	struct ptc_stats *stat = bcp->statp;
 	struct bau_control *hmaster;
 
 	hmaster = bcp->uvhub_master;
@@ -583,7 +583,7 @@ const struct cpumask *uv_flush_send_and_
 	cycles_t time1;
 	cycles_t time2;
 	cycles_t elapsed;
-	struct ptc_stats *stat = &per_cpu(ptcstats, bcp->cpu);
+	struct ptc_stats *stat = bcp->statp;
 	struct bau_control *smaster = bcp->socket_master;
 	struct bau_control *hmaster = bcp->uvhub_master;
 
@@ -794,7 +794,7 @@ const struct cpumask *uv_flush_tlb_other
 		return cpumask;
 
 	bcp = &per_cpu(bau_control, cpu);
-	stat = &per_cpu(ptcstats, cpu);
+	stat = bcp->statp;
 
 	/* bau was disabled due to slow response */
 	if (bcp->baudisabled) {
@@ -903,7 +903,7 @@ void uv_bau_message_interrupt(struct pt_
 
 	time_start = get_cycles();
 	bcp = &per_cpu(bau_control, smp_processor_id());
-	stat = &per_cpu(ptcstats, smp_processor_id());
+	stat = bcp->statp;
 	msgdesc.va_queue_first = bcp->va_queue_first;
 	msgdesc.va_queue_last = bcp->va_queue_last;
 	msg = bcp->bau_msg_head;
@@ -1636,6 +1636,7 @@ static void uv_init_per_cpu(int nuvhubs)
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
 		bcp->baudisabled = 0;
+		bcp->statp = &per_cpu(ptcstats, cpu);
 		/* time interval to catch a hardware stay-busy bug */
 		bcp->timeout_interval = microsec_2_cycles(2*timeout_us);
 		bcp->max_bau_concurrent = max_bau_concurrent;
@@ -1673,7 +1674,6 @@ static int __init uv_bau_init(void)
 		zalloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
 				       GFP_KERNEL, cpu_to_node(cur_cpu));
 
-	max_bau_concurrent = MAX_BAU_CONCURRENT;
 	uv_nshift = uv_hub_info->m_val;
 	uv_mmask = (1UL << uv_hub_info->m_val) - 1;
 	nuvhubs = uv_num_possible_blades();
Index: 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- 100531.linux-tip.orig/arch/x86/include/asm/uv/uv_bau.h
+++ 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
@@ -332,6 +332,7 @@ struct bau_control {
 	struct bau_payload_queue_entry *bau_msg_head;
 	struct bau_control *uvhub_master;
 	struct bau_control *socket_master;
+	struct ptc_stats *statp;
 	unsigned long timeout_interval;
 	unsigned long set_bau_on_time;
 	atomic_t active_descriptor_count;
