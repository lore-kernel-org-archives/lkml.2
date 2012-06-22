Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab2FVNNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:13:31 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40756 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932740Ab2FVNN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:13:29 -0400
Date: Fri, 22 Jun 2012 08:13:30 -0500
From: Cliff Wickman <cpw@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [PATCH 2/3] x86: UV BAU runtime enable and disable
Message-ID: <20120622131330.GB31884@sgi.com>
References: <E1Si3c5-0008I6-CG@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Si3c5-0008I6-CG@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the BAU to be turned on or off dynamically.

  echo "on"  > /proc/sgi_uv/ptc_statistics
  echo "off" > /proc/sgi_uv/ptc_statistics

The system may be booted with or without the nobau option.

Whether the system currently has the BAU off can be seen in
the /proc file -- normally with the baustats script.
Each cpu will have a 1 in the bauoff field if the BAU was turned off, so
baustats will give a count of cpus that have it off.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |    2 +
 arch/x86/platform/uv/tlb_uv.c    |   76 +++++++++++++++++++++++++++++++--------
 2 files changed, 63 insertions(+), 15 deletions(-)

Index: linus.current/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linus.current.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linus.current/arch/x86/include/asm/uv/uv_bau.h
@@ -520,6 +520,7 @@ struct ptc_stats {
 	unsigned long	s_uv2_wars;		/* uv2 workaround, perm. busy */
 	unsigned long	s_uv2_wars_hw;		/* uv2 workaround, hiwater */
 	unsigned long	s_uv2_war_waits;	/* uv2 workaround, long waits */
+	unsigned long   s_enters;		/* entries to the driver */
 	/* destination statistics */
 	unsigned long	d_alltlb;		/* times all tlb's on this
 						   cpu were flushed */
@@ -586,6 +587,7 @@ struct bau_control {
 	int			timeout_tries;
 	int			ipi_attempts;
 	int			conseccompletes;
+	short			nobau;
 	int			baudisabled;
 	int			set_bau_off;
 	short			cpu;
Index: linus.current/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linus.current.orig/arch/x86/platform/uv/tlb_uv.c
+++ linus.current/arch/x86/platform/uv/tlb_uv.c
@@ -38,6 +38,7 @@ static int timeout_base_ns[] = {
 
 static int timeout_us;
 static int nobau;
+static int nobau_perm;
 static int baudisabled;
 static spinlock_t disable_lock;
 static cycles_t congested_cycles;
@@ -120,6 +121,40 @@ static DEFINE_PER_CPU(struct ptc_stats,
 static DEFINE_PER_CPU(struct bau_control, bau_control);
 static DEFINE_PER_CPU(cpumask_var_t, uv_flush_tlb_mask);
 
+static void
+set_bau_on(void)
+{
+	int cpu;
+	struct bau_control *bcp;
+
+	if (nobau_perm) {
+		pr_info("BAU not initialized; cannot be turned on\n");
+		return;
+	}
+	nobau = 0;
+	for_each_present_cpu(cpu) {
+		bcp = &per_cpu(bau_control, cpu);
+		bcp->nobau = 0;
+	}
+	pr_info("BAU turned on\n");
+	return;
+}
+
+static void
+set_bau_off(void)
+{
+	int cpu;
+	struct bau_control *bcp;
+
+	nobau = 1;
+	for_each_present_cpu(cpu) {
+		bcp = &per_cpu(bau_control, cpu);
+		bcp->nobau = 1;
+	}
+	pr_info("BAU turned off\n");
+	return;
+}
+
 /*
  * Determine the first node on a uvhub. 'Nodes' are used for kernel
  * memory allocation.
@@ -1079,12 +1114,12 @@ const struct cpumask *uv_flush_tlb_other
 	struct ptc_stats *stat;
 	struct bau_control *bcp;
 
-	/* kernel was booted 'nobau' */
-	if (nobau)
-		return cpumask;
-
 	bcp = &per_cpu(bau_control, cpu);
 	stat = bcp->statp;
+	stat->s_enters++;
+
+	if (bcp->nobau)
+		return cpumask;
 
 	/* bau was disabled due to slow response */
 	if (bcp->baudisabled) {
@@ -1338,29 +1373,32 @@ static inline unsigned long long usec_2_
 static int ptc_seq_show(struct seq_file *file, void *data)
 {
 	struct ptc_stats *stat;
+	struct bau_control *bcp;
 	int cpu;
 
 	cpu = *(loff_t *)data;
 	if (!cpu) {
 		seq_printf(file,
-			"# cpu sent stime self locals remotes ncpus localhub ");
+		"# cpu bauoff sent stime self locals remotes ncpus localhub ");
 		seq_printf(file,
 			"remotehub numuvhubs numuvhubs16 numuvhubs8 ");
 		seq_printf(file,
 		    "numuvhubs4 numuvhubs2 numuvhubs1 dto snacks retries rok ");
 		seq_printf(file,
-			"resetp resett giveup sto bz throt swack recv rtime ");
+			"resetp resett giveup sto bz throt enters swack recv rtime ");
 		seq_printf(file,
 			"all one mult none retry canc nocan reset rcan ");
 		seq_printf(file,
 			"disable enable wars warshw warwaits\n");
 	}
 	if (cpu < num_possible_cpus() && cpu_online(cpu)) {
-		stat = &per_cpu(ptcstats, cpu);
+		bcp = &per_cpu(bau_control, cpu);
+		stat = bcp->statp;
 		/* source side statistics */
 		seq_printf(file,
-			"cpu %d %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld ",
-			   cpu, stat->s_requestor, cycles_2_us(stat->s_time),
+			   "cpu %d %d %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld ",
+			   cpu, bcp->nobau, stat->s_requestor,
+			   cycles_2_us(stat->s_time),
 			   stat->s_ntargself, stat->s_ntarglocals,
 			   stat->s_ntargremotes, stat->s_ntargcpu,
 			   stat->s_ntarglocaluvhub, stat->s_ntargremoteuvhub,
@@ -1369,11 +1407,11 @@ static int ptc_seq_show(struct seq_file
 			   stat->s_ntarguvhub8, stat->s_ntarguvhub4,
 			   stat->s_ntarguvhub2, stat->s_ntarguvhub1,
 			   stat->s_dtimeout, stat->s_strongnacks);
-		seq_printf(file, "%ld %ld %ld %ld %ld %ld %ld %ld ",
+		seq_printf(file, "%ld %ld %ld %ld %ld %ld %ld %ld %ld ",
 			   stat->s_retry_messages, stat->s_retriesok,
 			   stat->s_resets_plug, stat->s_resets_timeout,
 			   stat->s_giveup, stat->s_stimeout,
-			   stat->s_busy, stat->s_throttles);
+			   stat->s_busy, stat->s_throttles, stat->s_enters);
 
 		/* destination side statistics */
 		seq_printf(file,
@@ -1438,6 +1476,14 @@ static ssize_t ptc_proc_write(struct fil
 		return -EFAULT;
 	optstr[count - 1] = '\0';
 
+	if (!strcmp(optstr, "on")) {
+		set_bau_on();
+		return count;
+	} else if (!strcmp(optstr, "off")) {
+		set_bau_off();
+		return count;
+	}
+
 	if (strict_strtol(optstr, 10, &input_arg) < 0) {
 		printk(KERN_DEBUG "%s is invalid\n", optstr);
 		return -EINVAL;
@@ -1836,6 +1882,8 @@ static void __init init_per_cpu_tunables
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
 		bcp->baudisabled		= 0;
+		if (nobau)
+			bcp->nobau		= 1;
 		bcp->statp			= &per_cpu(ptcstats, cpu);
 		/* time interval to catch a hardware stay-busy bug */
 		bcp->timeout_interval		= usec_2_cycles(2*timeout_us);
@@ -2069,9 +2117,6 @@ static int __init uv_bau_init(void)
 	if (!is_uv_system())
 		return 0;
 
-	if (nobau)
-		return 0;
-
 	for_each_possible_cpu(cur_cpu) {
 		mask = &per_cpu(uv_flush_tlb_mask, cur_cpu);
 		zalloc_cpumask_var_node(mask, GFP_KERNEL, cpu_to_node(cur_cpu));
@@ -2091,7 +2136,8 @@ static int __init uv_bau_init(void)
 	enable_timeouts();
 
 	if (init_per_cpu(nuvhubs, uv_base_pnode)) {
-		nobau = 1;
+		set_bau_off();
+		nobau_perm = 1;
 		return 0;
 	}
 
