Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab2KSPyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:54:44 -0500
Received: from relay3.sgi.com ([192.48.152.1]:47056 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753501Ab2KSPym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:54:42 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: davej@redhat.com, Nathan Zimmer <nzimmer@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] procfs: /proc/sched_debug fails on very very large machines.
Date: Mon, 19 Nov 2012 09:54:40 -0600
Message-Id: <1353340480-31962-3-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1353340480-31962-2-git-send-email-nzimmer@sgi.com>
References: <1353340480-31962-1-git-send-email-nzimmer@sgi.com>
 <1353340480-31962-2-git-send-email-nzimmer@sgi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems with 4096 cores attemping to read /proc/sched_debug fails.
We are trying to push all the data into a single kmalloc buffer.
The issue is on these very large machines all the data will not fit in 4mb.
The failure can occur on smaller systems when memory fragmentation is high.

A better solution is to not us the single_open mechanism but to provide
our own seq_operations and treat each cpu as an individual record.
Also sysrq_sched_debug_show must be updated to to not use the new 
sched_debug_show. 

The output should be identical to previous version.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Reported-by: Dave Jones <davej@redhat.com>
---
 kernel/sched/debug.c |   84 +++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 6f79596..1ffdd42 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -253,11 +253,11 @@ static void print_cpu(struct seq_file *m, int cpu)
 	{
 		unsigned int freq = cpu_khz ? : 1;
 
-		SEQ_printf(m, "\ncpu#%d, %u.%03u MHz\n",
+		SEQ_printf(m, "cpu#%d, %u.%03u MHz\n",
 			   cpu, freq / 1000, (freq % 1000));
 	}
 #else
-	SEQ_printf(m, "\ncpu#%d\n", cpu);
+	SEQ_printf(m, "cpu#%d\n", cpu);
 #endif
 
 #define P(x)								\
@@ -314,6 +314,7 @@ do {									\
 	print_rq(m, rq, cpu);
 	rcu_read_unlock();
 	spin_unlock_irqrestore(&sched_debug_lock, flags);
+	SEQ_printf(m, "\n");
 }
 
 static const char *sched_tunable_scaling_names[] = {
@@ -322,11 +323,10 @@ static const char *sched_tunable_scaling_names[] = {
 	"linear"
 };
 
-static int sched_debug_show(struct seq_file *m, void *v)
+static void sched_debug_header(struct seq_file *m)
 {
 	u64 ktime, sched_clk, cpu_clk;
 	unsigned long flags;
-	int cpu;
 
 	local_irq_save(flags);
 	ktime = ktime_to_ns(ktime_get());
@@ -368,33 +368,95 @@ static int sched_debug_show(struct seq_file *m, void *v)
 #undef PN
 #undef P
 
-	SEQ_printf(m, "  .%-40s: %d (%s)\n", "sysctl_sched_tunable_scaling",
+	SEQ_printf(m, "  .%-40s: %d (%s)\n",
+		"sysctl_sched_tunable_scaling",
 		sysctl_sched_tunable_scaling,
 		sched_tunable_scaling_names[sysctl_sched_tunable_scaling]);
+	SEQ_printf(m, "\n");
+}
 
-	for_each_online_cpu(cpu)
-		print_cpu(m, cpu);
+static int sched_debug_show(struct seq_file *m, void *v)
+{
+	int cpu = (unsigned long)(v - 2);
 
-	SEQ_printf(m, "\n");
+	if (cpu != -1)
+		print_cpu(m, cpu);
+	else
+		sched_debug_header(m);
 
 	return 0;
 }
 
 void sysrq_sched_debug_show(void)
 {
-	sched_debug_show(NULL, NULL);
+	int cpu;
+
+	sched_debug_header(NULL);
+	for_each_online_cpu(cpu)
+		print_cpu(NULL, cpu);
+
+}
+
+static void *sched_debug_start(struct seq_file *file, loff_t *offset)
+{
+	unsigned long n = *offset;
+
+	if (n == 0)
+		return (void *) 1;
+
+	n--;
+
+	if (n > 0)
+		n = cpumask_next(n - 1, cpu_online_mask);
+	else
+		n = cpumask_first(cpu_online_mask);
+
+	*offset = n + 1;
+
+	if (n < nr_cpu_ids)
+		return (void *)(unsigned long)(n + 2);
+	return NULL;
+}
+
+static void *sched_debug_next(struct seq_file *file, void *data, loff_t *offset)
+{
+	(*offset)++;
+	return sched_debug_start(file, offset);
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
 }
 
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

