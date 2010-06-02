Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab0FBVV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:21:59 -0400
Received: from relay3.sgi.com ([192.48.152.1]:45296 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932988Ab0FBVVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:21:35 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] x86, UV: BAU broadcast to the local hub
Cc: mingo@elte.hu, hpa@zytor.com, gregkh@suse.de
Message-Id: <E1OJvNy-0004aq-G7@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 02 Jun 2010 16:22:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make the Broadcast Assist Unit driver use the BAU for TLB shootdowns
of cpu's on the local uvhub.

It was previously thought that IPI might be faster to the cpu's on the
local hub.  But the IPI operation would have to follow the completion of
the BAU broadcast anyway.  So we broadcast to the local uvhub in all cases
except when the current cpu was the only local cpu in the mask.

This simplifies uv_flush_send_and_wait() in that it returns either all
shootdowns complete, or none.

Adjust the statistics to account for shootdowns on the local uvhub.

Diffed against 2.6.34 -tip

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |    5 +
 arch/x86/kernel/tlb_uv.c         |  138 ++++++++++++++-------------------------
 2 files changed, 58 insertions(+), 85 deletions(-)

Index: 100531.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100531.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100531.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -400,10 +400,7 @@ static int uv_wait_completion(struct bau
 	unsigned long mmr_offset, int right_shift, int this_cpu,
 	struct bau_control *bcp, struct bau_control *smaster, long try)
 {
-	int relaxes = 0;
 	unsigned long descriptor_status;
-	unsigned long mmr;
-	unsigned long mask;
 	cycles_t ttime;
 	struct ptc_stats *stat = bcp->statp;
 	struct bau_control *hmaster;
@@ -524,25 +521,19 @@ disable_for_congestion(struct bau_contro
  * The flush_mask contains the cpus the broadcast is to be sent to, plus
  * cpus that are on the local uvhub.
  *
- * Returns NULL if all flushing represented in the mask was done. The mask
- * is zeroed.
- * Returns @flush_mask if some remote flushing remains to be done. The
- * mask will have some bits still set, representing any cpus on the local
- * uvhub (not current cpu) and any on remote uvhubs if the broadcast failed.
+ * Returns 0 if all flushing represented in the mask was done.
+ * Returns 1 if it gives up entirely and the original cpu mask is to be
+ * returned to the kernel.
  */
-const struct cpumask *uv_flush_send_and_wait(struct bau_desc *bau_desc,
-					     struct cpumask *flush_mask,
-					     struct bau_control *bcp)
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
 	int this_cpu = bcp->cpu;
-	int this_uvhub = bcp->uvhub;
 	unsigned long mmr_offset;
 	unsigned long index;
 	cycles_t time1;
@@ -552,10 +543,6 @@ const struct cpumask *uv_flush_send_and_
 	struct bau_control *smaster = bcp->socket_master;
 	struct bau_control *hmaster = bcp->uvhub_master;
 
-	/*
-	 * Spin here while there are hmaster->max_bau_concurrent or more active
-	 * descriptors. This is the per-uvhub 'throttle'.
-	 */
 	if (!atomic_inc_unless_ge(&hmaster->uvhub_lock,
 			&hmaster->active_descriptor_count,
 			hmaster->max_bau_concurrent)) {
@@ -591,9 +578,7 @@ const struct cpumask *uv_flush_send_and_
 		index = (1UL << UVH_LB_BAU_SB_ACTIVATION_CONTROL_PUSH_SHFT) |
 			bcp->uvhub_cpu;
 		bcp->send_message = get_cycles();
-
 		uv_write_local_mmr(UVH_LB_BAU_SB_ACTIVATION_CONTROL, index);
-
 		try++;
 		completion_status = uv_wait_completion(bau_desc, mmr_offset,
 			right_shift, this_cpu, bcp, smaster, try);
@@ -652,16 +637,9 @@ const struct cpumask *uv_flush_send_and_
 	    (hmaster->max_bau_concurrent <
 					hmaster->max_bau_concurrent_constant))
 			hmaster->max_bau_concurrent++;
-
-	/*
-	 * hold any cpu not timing out here; no other cpu currently held by
-	 * the 'throttle' should enter the activation code
-	 */
 	while (hmaster->uvhub_quiesce)
 		cpu_relax();
 	atomic_dec(&hmaster->active_descriptor_count);
-
-	/* guard against cycles wrap */
 	if (time2 > time1) {
 		elapsed = time2 - time1;
 		stat->s_time += elapsed;
@@ -674,32 +652,14 @@ const struct cpumask *uv_flush_send_and_
 			}
 		}
 	} else
-		stat->s_requestor--; /* don't count this one */
+		stat->s_requestor--;
 	if (completion_status == FLUSH_COMPLETE && try > 1)
 		stat->s_retriesok++;
 	else if (completion_status == FLUSH_GIVEUP) {
-		/*
-		 * Cause the caller to do an IPI-style TLB shootdown on
-		 * the target cpu's, all of which are still in the mask.
-		 */
 		stat->s_giveup++;
-		return flush_mask;
+		return 1;
 	}
-
-	/*
-	 * Success, so clear the remote cpu's from the mask so we don't
-	 * use the IPI method of shootdown on them.
-	 */
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
@@ -731,10 +691,11 @@ const struct cpumask *uv_flush_tlb_other
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
@@ -768,54 +729,52 @@ const struct cpumask *uv_flush_tlb_other
 
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
@@ -824,10 +783,13 @@ const struct cpumask *uv_flush_tlb_other
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
@@ -976,9 +938,11 @@ static int uv_ptc_seq_show(struct seq_fi
 
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
@@ -994,10 +958,14 @@ static int uv_ptc_seq_show(struct seq_fi
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
Index: 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- 100531.linux-tip.orig/arch/x86/include/asm/uv/uv_bau.h
+++ 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
@@ -346,6 +346,11 @@ struct ptc_stats {
 	unsigned long s_time; /* time spent in sending side */
 	unsigned long s_retriesok; /* successful retries */
 	unsigned long s_ntargcpu; /* total number of cpu's targeted */
+	unsigned long s_ntargself; /* times the sending cpu was targeted */
+	unsigned long s_ntarglocals; /* targets of cpus on the local blade */
+	unsigned long s_ntargremotes; /* targets of cpus on remote blades */
+	unsigned long s_ntarglocaluvhub; /* targets of the local hub */
+	unsigned long s_ntargremoteuvhub; /* remotes hubs targeted */
 	unsigned long s_ntarguvhub; /* total number of uvhubs targeted */
 	unsigned long s_ntarguvhub16; /* number of times target hubs >= 16*/
 	unsigned long s_ntarguvhub8; /* number of times target hubs >= 8 */
