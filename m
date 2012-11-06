Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab2KFVCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:02:46 -0500
Received: from relay3.sgi.com ([192.48.152.1]:55893 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752254Ab2KFVCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:02:22 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [RFC 2/2] procfs: /proc/sched_debug fails on very very large machines.
Date: Tue,  6 Nov 2012 15:02:21 -0600
Message-Id: <1352235741-26478-3-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1352235741-26478-2-git-send-email-nzimmer@sgi.com>
References: <1352235741-26478-1-git-send-email-nzimmer@sgi.com>
 <1352235741-26478-2-git-send-email-nzimmer@sgi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems with 4096 cores attemping to read /proc/sched_debug fails.
We are trying to push all the data into a single kmalloc buffer.
The issue is on these very large machines all the data will not fit in 4mb.

A better solution is to not us the single_open mechanism but to provide
our own seq_operations and treat each cpu as an individual record.

The output should be identical to previous version except the trailing '\n'
was dropped.
Does that require incrementing the version?
Or should I find a way to reinclude it?

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org

---
 kernel/sched/debug.c |  101 +++++++++++++++++++++++++++++++++++---------------
 1 files changed, 71 insertions(+), 30 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 6f79596..8c1631f 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -328,54 +328,56 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	unsigned long flags;
 	int cpu;
 
-	local_irq_save(flags);
-	ktime = ktime_to_ns(ktime_get());
-	sched_clk = sched_clock();
-	cpu_clk = local_clock();
-	local_irq_restore(flags);
+	cpu = *(loff_t *)v;
 
-	SEQ_printf(m, "Sched Debug Version: v0.10, %s %.*s\n",
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	if (!cpu) {
+		local_irq_save(flags);
+		ktime = ktime_to_ns(ktime_get());
+		sched_clk = sched_clock();
+		cpu_clk = local_clock();
+		local_irq_restore(flags);
+
+		SEQ_printf(m, "Sched Debug Version: v0.10, %s %.*s\n",
+			init_utsname()->release,
+			(int)strcspn(init_utsname()->version, " "),
+			init_utsname()->version);
 
 #define P(x) \
 	SEQ_printf(m, "%-40s: %Ld\n", #x, (long long)(x))
 #define PN(x) \
 	SEQ_printf(m, "%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
-	PN(ktime);
-	PN(sched_clk);
-	PN(cpu_clk);
-	P(jiffies);
+		PN(ktime);
+		PN(sched_clk);
+		PN(cpu_clk);
+		P(jiffies);
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-	P(sched_clock_stable);
+		P(sched_clock_stable);
 #endif
 #undef PN
 #undef P
 
-	SEQ_printf(m, "\n");
-	SEQ_printf(m, "sysctl_sched\n");
+		SEQ_printf(m, "\n");
+		SEQ_printf(m, "sysctl_sched\n");
 
 #define P(x) \
 	SEQ_printf(m, "  .%-40s: %Ld\n", #x, (long long)(x))
 #define PN(x) \
 	SEQ_printf(m, "  .%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
-	PN(sysctl_sched_latency);
-	PN(sysctl_sched_min_granularity);
-	PN(sysctl_sched_wakeup_granularity);
-	P(sysctl_sched_child_runs_first);
-	P(sysctl_sched_features);
+		PN(sysctl_sched_latency);
+		PN(sysctl_sched_min_granularity);
+		PN(sysctl_sched_wakeup_granularity);
+		P(sysctl_sched_child_runs_first);
+		P(sysctl_sched_features);
 #undef PN
 #undef P
 
-	SEQ_printf(m, "  .%-40s: %d (%s)\n", "sysctl_sched_tunable_scaling",
-		sysctl_sched_tunable_scaling,
-		sched_tunable_scaling_names[sysctl_sched_tunable_scaling]);
+		SEQ_printf(m, "  .%-40s: %d (%s)\n",
+			"sysctl_sched_tunable_scaling",
+			sysctl_sched_tunable_scaling,
+			sched_tunable_scaling_names[sysctl_sched_tunable_scaling]);
+	}
 
-	for_each_online_cpu(cpu)
-		print_cpu(m, cpu);
-
-	SEQ_printf(m, "\n");
+	print_cpu(m, cpu);
 
 	return 0;
 }
@@ -385,16 +387,55 @@ void sysrq_sched_debug_show(void)
 	sched_debug_show(NULL, NULL);
 }
 
+
+static void *sched_debug_start(struct seq_file *file, loff_t *offset)
+{
+	if (cpu_online(*offset))
+		return offset;
+	return NULL;
+}
+
+static void *sched_debug_next(struct seq_file *file, void *data, loff_t *offset)
+{
+	*offset = cpumask_next(*offset, cpu_online_mask);
+	if (cpu_online(*offset))
+		return offset;
+	return NULL;
+}
+
+static void sched_debug_stop(struct seq_file *file, void *data)
+{
+}
+
+
+static const struct seq_operations sched_debug_sops = {
+	.start = sched_debug_start,
+	.next = sched_debug_next,
+	.stop = sched_debug_stop,
+	.show = sched_debug_show,
+};
+
+static int sched_debug_release(struct inode *inode, struct file *file)
+{
+	seq_release(inode, file);
+
+	return 0;
+}
+
 static int sched_debug_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, sched_debug_show, NULL);
+	int ret = 0;
+
+	ret = seq_open(filp, &sched_debug_sops);
+
+	return ret;
 }
 
 static const struct file_operations sched_debug_fops = {
 	.open		= sched_debug_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= sched_debug_release,
 };
 
 static int __init init_sched_debug_procfs(void)
-- 
1.6.0.2

