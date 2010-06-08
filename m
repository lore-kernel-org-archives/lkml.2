Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab0FHU5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:57:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:39488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508Ab0FHU5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:57:30 -0400
Date: Tue, 8 Jun 2010 20:57:06 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1OJvNy-0004aB-2k@eag09.americas.sgi.com>
References: <E1OJvNy-0004aB-2k@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Shorten access to BAU statistics structure
Message-ID: <tip-712157aa703a01f58c7c17452096ab00b774d0a9@git.kernel.org>
Git-Commit-ID: 712157aa703a01f58c7c17452096ab00b774d0a9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 20:57:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  712157aa703a01f58c7c17452096ab00b774d0a9
Gitweb:     http://git.kernel.org/tip/712157aa703a01f58c7c17452096ab00b774d0a9
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 2 Jun 2010 16:22:02 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Jun 2010 21:13:45 +0200

x86, UV: Shorten access to BAU statistics structure

Use a pointer from the per-cpu BAU control structure to the
per-cpu BAU statistics structure.
We nearly always know the first before needing the second.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: gregkh@suse.de
LKML-Reference: <E1OJvNy-0004aB-2k@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |    1 +
 arch/x86/kernel/tlb_uv.c         |   16 ++++++++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 9b3e750..6a42d42 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -332,6 +332,7 @@ struct bau_control {
 	struct bau_payload_queue_entry *bau_msg_head;
 	struct bau_control *uvhub_master;
 	struct bau_control *socket_master;
+	struct ptc_stats *statp;
 	unsigned long timeout_interval;
 	unsigned long set_bau_on_time;
 	atomic_t active_descriptor_count;
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index dc6a683..261b965 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -153,7 +153,7 @@ static inline void uv_bau_process_retry_msg(struct msg_desc *mdp,
 	struct ptc_stats *stat;
 
 	msg = mdp->msg;
-	stat = &per_cpu(ptcstats, bcp->cpu);
+	stat = bcp->statp;
 	stat->d_retries++;
 	/*
 	 * cancel any message from msg+1 to the retry itself
@@ -217,7 +217,7 @@ static void uv_bau_process_message(struct msg_desc *mdp,
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
@@ -419,7 +419,7 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
 	unsigned long mask;
 	cycles_t ttime;
 	cycles_t timeout_time;
-	struct ptc_stats *stat = &per_cpu(ptcstats, this_cpu);
+	struct ptc_stats *stat = bcp->statp;
 	struct bau_control *hmaster;
 
 	hmaster = bcp->uvhub_master;
@@ -583,7 +583,7 @@ const struct cpumask *uv_flush_send_and_wait(struct bau_desc *bau_desc,
 	cycles_t time1;
 	cycles_t time2;
 	cycles_t elapsed;
-	struct ptc_stats *stat = &per_cpu(ptcstats, bcp->cpu);
+	struct ptc_stats *stat = bcp->statp;
 	struct bau_control *smaster = bcp->socket_master;
 	struct bau_control *hmaster = bcp->uvhub_master;
 
@@ -794,7 +794,7 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 		return cpumask;
 
 	bcp = &per_cpu(bau_control, cpu);
-	stat = &per_cpu(ptcstats, cpu);
+	stat = bcp->statp;
 
 	/* bau was disabled due to slow response */
 	if (bcp->baudisabled) {
@@ -903,7 +903,7 @@ void uv_bau_message_interrupt(struct pt_regs *regs)
 
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
