Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab0FBVVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:21:37 -0400
Received: from relay3.sgi.com ([192.48.152.1]:45278 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932805Ab0FBVVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:21:34 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/11] x86, UV: disable BAU on network congestion
Cc: mingo@elte.hu, hpa@zytor.com, gregkh@suse.de
Message-Id: <E1OJvNy-0004a4-0a@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 02 Jun 2010 16:22:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The numalink network can become so congested that TLB shootdown using
the Broadcast Assist Unit becomes slower than using IPI's.

In that case, disable the use of the BAU for a period of time. The period is
tunable.  When the period expires the use of the BAU is re-enabled.
A count of these actions is added to the statistics file.

Diffed against 2.6.34 -tip

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |    4 ++
 arch/x86/kernel/tlb_uv.c         |   76 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 77 insertions(+), 3 deletions(-)

Index: 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- 100531.linux-tip.orig/arch/x86/include/asm/uv/uv_bau.h
+++ 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
@@ -34,6 +34,7 @@
  */
 
 #define UV_ITEMS_PER_DESCRIPTOR		8
+/* the 'throttle' to prevent the hardware stay-busy bug */
 #define MAX_BAU_CONCURRENT		3
 #define UV_CPUS_PER_ACT_STATUS		32
 #define UV_ACT_STATUS_MASK		0x3
@@ -338,6 +339,7 @@ struct bau_control {
 	int timeout_tries;
 	int ipi_attempts;
 	int conseccompletes;
+	int baudisabled;
 	int set_bau_off;
 	short cpu;
 	short uvhub_cpu;
@@ -389,6 +391,8 @@ struct ptc_stats {
 	unsigned long s_busy; /* status stayed busy past s/w timer */
 	unsigned long s_throttles; /* waits in throttle */
 	unsigned long s_retry_messages; /* retry broadcasts */
+	unsigned long s_bau_reenabled; /* for bau enable/disable */
+	unsigned long s_bau_disabled; /* for bau enable/disable */
 	/* destination statistics */
 	unsigned long d_alltlb; /* times all tlb's on this cpu were flushed */
 	unsigned long d_onetlb; /* times just one tlb on this cpu was flushed */
Index: 100531.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100531.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100531.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -44,6 +44,9 @@ static int timeout_base_ns[] = {
 };
 static int timeout_us;
 static int nobau;
+static int baudisabled;
+static spinlock_t disable_lock;
+static cycles_t congested_cycles;
 
 /* tunables: */
 static int max_bau_concurrent = MAX_BAU_CONCURRENT;
@@ -519,6 +522,35 @@ static inline int atomic_inc_unless_ge(s
 	return 1;
 }
 
+/*
+ * Completions are taking a very long time due to a congested numalink
+ * network.
+ */
+static void
+disable_for_congestion(struct bau_control *bcp, struct ptc_stats *stat)
+{
+	int tcpu;
+	struct bau_control *tbcp;
+
+	/* let only one cpu do this disabling */
+	spin_lock(&disable_lock);
+	if (!baudisabled && bcp->period_requests &&
+	    ((bcp->period_time / bcp->period_requests) > congested_cycles)) {
+		/* it becomes this cpu's job to turn on the use of the
+		   BAU again */
+		baudisabled = 1;
+		bcp->set_bau_off = 1;
+		bcp->set_bau_on_time = get_cycles() +
+			sec_2_cycles(bcp->congested_period);
+		stat->s_bau_disabled++;
+		for_each_present_cpu(tcpu) {
+			tbcp = &per_cpu(bau_control, tcpu);
+				tbcp->baudisabled = 1;
+		}
+	}
+	spin_unlock(&disable_lock);
+}
+
 /**
  * uv_flush_send_and_wait
  *
@@ -681,6 +713,14 @@ const struct cpumask *uv_flush_send_and_
 	if (time2 > time1) {
 		elapsed = time2 - time1;
 		stat->s_time += elapsed;
+		if ((completion_status == FLUSH_COMPLETE) && (try == 1)) {
+			bcp->period_requests++;
+			bcp->period_time += elapsed;
+			if ((elapsed > congested_cycles) &&
+			    (bcp->period_requests > bcp->congested_reps)) {
+				disable_for_congestion(bcp, stat);
+			}
+		}
 	} else
 		stat->s_requestor--; /* don't count this one */
 	if (completion_status == FLUSH_COMPLETE && try > 1)
@@ -747,12 +787,32 @@ const struct cpumask *uv_flush_tlb_other
 	struct cpumask *flush_mask;
 	struct ptc_stats *stat;
 	struct bau_control *bcp;
+	struct bau_control *tbcp;
 
 	/* kernel was booted 'nobau' */
 	if (nobau)
 		return cpumask;
 
 	bcp = &per_cpu(bau_control, cpu);
+	stat = &per_cpu(ptcstats, cpu);
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
 
 	/*
 	 * Each sending cpu has a per-cpu mask which it fills from the caller's
@@ -793,7 +853,6 @@ const struct cpumask *uv_flush_tlb_other
 		else
 			return NULL;
 	}
-	stat = &per_cpu(ptcstats, cpu);
 	stat->s_requestor++;
 	stat->s_ntargcpu += remotes;
 	remotes = bau_uvhub_weight(&bau_desc->distribution);
@@ -973,7 +1032,9 @@ static int uv_ptc_seq_show(struct seq_fi
 		seq_printf(file,
 			"sw_ack recv rtime all ");
 		seq_printf(file,
-			"one mult none retry canc nocan reset rcan\n");
+			"one mult none retry canc nocan reset rcan ");
+		seq_printf(file,
+			"disable enable\n");
 	}
 	if (cpu < num_possible_cpus() && cpu_online(cpu)) {
 		stat = &per_cpu(ptcstats, cpu);
@@ -993,7 +1054,7 @@ static int uv_ptc_seq_show(struct seq_fi
 
 		/* destination side statistics */
 		seq_printf(file,
-			   "%lx %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld\n",
+			   "%lx %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld ",
 			   uv_read_global_mmr64(uv_cpu_to_pnode(cpu),
 					UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE),
 			   stat->d_requestee, cycles_2_us(stat->d_time),
@@ -1001,6 +1062,8 @@ static int uv_ptc_seq_show(struct seq_fi
 			   stat->d_nomsg, stat->d_retries, stat->d_canceled,
 			   stat->d_nocanceled, stat->d_resets,
 			   stat->d_rcanceled);
+		seq_printf(file, "%ld %ld\n",
+			stat->s_bau_disabled, stat->s_bau_reenabled);
 	}
 
 	return 0;
@@ -1112,6 +1175,10 @@ static ssize_t uv_ptc_proc_write(struct 
 		"reset:    number of ipi-style reset requests processed\n");
 		printk(KERN_DEBUG
 		"rcan:     number messages canceled by reset requests\n");
+		printk(KERN_DEBUG
+		"disable:  number times use of the BAU was disabled\n");
+		printk(KERN_DEBUG
+		"enable:   number times use of the BAU was re-enabled\n");
 	} else if (input_arg == -1) {
 		for_each_present_cpu(cpu) {
 			stat = &per_cpu(ptcstats, cpu);
@@ -1568,6 +1635,7 @@ static void uv_init_per_cpu(int nuvhubs)
 	kfree(uvhub_descs);
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
+		bcp->baudisabled = 0;
 		/* time interval to catch a hardware stay-busy bug */
 		bcp->timeout_interval = microsec_2_cycles(2*timeout_us);
 		bcp->max_bau_concurrent = max_bau_concurrent;
@@ -1609,6 +1677,8 @@ static int __init uv_bau_init(void)
 	uv_nshift = uv_hub_info->m_val;
 	uv_mmask = (1UL << uv_hub_info->m_val) - 1;
 	nuvhubs = uv_num_possible_blades();
+	spin_lock_init(&disable_lock);
+	congested_cycles = microsec_2_cycles(congested_response_us);
 
 	uv_init_per_cpu(nuvhubs);
 
