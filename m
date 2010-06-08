Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0FHU5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:57:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:39460 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab0FHU5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:57:05 -0400
Date: Tue, 8 Jun 2010 20:56:48 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1OJvNy-0004a4-0a@eag09.americas.sgi.com>
References: <E1OJvNy-0004a4-0a@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Disable BAU on network congestion
Message-ID: <tip-50fb55acc5bbe5ee29d0a65262f4ec286b14d156@git.kernel.org>
Git-Commit-ID: 50fb55acc5bbe5ee29d0a65262f4ec286b14d156
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 20:56:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50fb55acc5bbe5ee29d0a65262f4ec286b14d156
Gitweb:     http://git.kernel.org/tip/50fb55acc5bbe5ee29d0a65262f4ec286b14d156
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 2 Jun 2010 16:22:02 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Jun 2010 21:13:45 +0200

x86, UV: Disable BAU on network congestion

The numalink network can become so congested that TLB shootdown
using the Broadcast Assist Unit becomes slower than using IPI's.

In that case, disable the use of the BAU for a period of time.
The period is tunable.  When the period expires the use of the
BAU is re-enabled. A count of these actions is added to the
statistics file.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: gregkh@suse.de
LKML-Reference: <E1OJvNy-0004a4-0a@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |    4 ++
 arch/x86/kernel/tlb_uv.c         |   76 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index e5543c1..9b3e750 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
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
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index c866177..dc6a683 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -44,6 +44,9 @@ static int timeout_base_ns[] = {
 };
 static int timeout_us;
 static int nobau;
+static int baudisabled;
+static spinlock_t disable_lock;
+static cycles_t congested_cycles;
 
 /* tunables: */
 static int max_bau_concurrent = MAX_BAU_CONCURRENT;
@@ -519,6 +522,35 @@ static inline int atomic_inc_unless_ge(spinlock_t *lock, atomic_t *v, int u)
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
@@ -681,6 +713,14 @@ const struct cpumask *uv_flush_send_and_wait(struct bau_desc *bau_desc,
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
@@ -747,12 +787,32 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
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
@@ -793,7 +853,6 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 		else
 			return NULL;
 	}
-	stat = &per_cpu(ptcstats, cpu);
 	stat->s_requestor++;
 	stat->s_ntargcpu += remotes;
 	remotes = bau_uvhub_weight(&bau_desc->distribution);
@@ -973,7 +1032,9 @@ static int uv_ptc_seq_show(struct seq_file *file, void *data)
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
@@ -993,7 +1054,7 @@ static int uv_ptc_seq_show(struct seq_file *file, void *data)
 
 		/* destination side statistics */
 		seq_printf(file,
-			   "%lx %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld\n",
+			   "%lx %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld ",
 			   uv_read_global_mmr64(uv_cpu_to_pnode(cpu),
 					UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE),
 			   stat->d_requestee, cycles_2_us(stat->d_time),
@@ -1001,6 +1062,8 @@ static int uv_ptc_seq_show(struct seq_file *file, void *data)
 			   stat->d_nomsg, stat->d_retries, stat->d_canceled,
 			   stat->d_nocanceled, stat->d_resets,
 			   stat->d_rcanceled);
+		seq_printf(file, "%ld %ld\n",
+			stat->s_bau_disabled, stat->s_bau_reenabled);
 	}
 
 	return 0;
@@ -1112,6 +1175,10 @@ static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
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
 
