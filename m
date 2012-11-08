Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2KHPN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:13:28 -0500
Received: from relay1.sgi.com ([192.48.179.29]:37463 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab2KHPNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:13:22 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC v2 1/2] procfs: /proc/sched_stat fails on very very large machines.
Date: Thu,  8 Nov 2012 09:13:19 -0600
Message-Id: <1352387600-19389-2-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1352387600-19389-1-git-send-email-nzimmer@sgi.com>
References: <1352387600-19389-1-git-send-email-nzimmer@sgi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems with 4096 cores doing a cat /proc/sched_stat fails.
We are trying to push all the data into a single kmalloc buffer.
The issue is on these very large machines all the data will not fit in 4mb.

A better solution is to not us the single_open mechanism but to provide
our own seq_operations.

The output should be identical to previous version and thus not need the
version number.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
CC: Al Viro <viro@zeniv.linux.org.uk>

---
 kernel/sched/stats.c |  154 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 94 insertions(+), 60 deletions(-)

diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index 903ffa9..21f7bc2 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -21,86 +21,120 @@ static int show_schedstat(struct seq_file *seq, void *v)
 	if (mask_str == NULL)
 		return -ENOMEM;
 
-	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
-	seq_printf(seq, "timestamp %lu\n", jiffies);
-	for_each_online_cpu(cpu) {
-		struct rq *rq = cpu_rq(cpu);
+	if (v == (void *)1) {
+		seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
+		seq_printf(seq, "timestamp %lu\n", jiffies);
+		return 0;
+	}
+
+	cpu = (unsigned long)(v - 2);
+
+	struct rq *rq = cpu_rq(cpu);
 #ifdef CONFIG_SMP
-		struct sched_domain *sd;
-		int dcount = 0;
+	struct sched_domain *sd;
+	int dcount = 0;
 #endif
 
-		/* runqueue-specific stats */
-		seq_printf(seq,
-		    "cpu%d %u 0 %u %u %u %u %llu %llu %lu",
-		    cpu, rq->yld_count,
-		    rq->sched_count, rq->sched_goidle,
-		    rq->ttwu_count, rq->ttwu_local,
-		    rq->rq_cpu_time,
-		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
+	/* runqueue-specific stats */
+	seq_printf(seq,
+	    "cpu%d %u 0 %u %u %u %u %llu %llu %lu",
+	    cpu, rq->yld_count,
+	    rq->sched_count, rq->sched_goidle,
+	    rq->ttwu_count, rq->ttwu_local,
+	    rq->rq_cpu_time,
+	    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
 
-		seq_printf(seq, "\n");
+	seq_printf(seq, "\n");
 
 #ifdef CONFIG_SMP
-		/* domain-specific stats */
-		rcu_read_lock();
-		for_each_domain(cpu, sd) {
-			enum cpu_idle_type itype;
-
-			cpumask_scnprintf(mask_str, mask_len,
-					  sched_domain_span(sd));
-			seq_printf(seq, "domain%d %s", dcount++, mask_str);
-			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
-					itype++) {
-				seq_printf(seq, " %u %u %u %u %u %u %u %u",
-				    sd->lb_count[itype],
-				    sd->lb_balanced[itype],
-				    sd->lb_failed[itype],
-				    sd->lb_imbalance[itype],
-				    sd->lb_gained[itype],
-				    sd->lb_hot_gained[itype],
-				    sd->lb_nobusyq[itype],
-				    sd->lb_nobusyg[itype]);
-			}
-			seq_printf(seq,
-				   " %u %u %u %u %u %u %u %u %u %u %u %u\n",
-			    sd->alb_count, sd->alb_failed, sd->alb_pushed,
-			    sd->sbe_count, sd->sbe_balanced, sd->sbe_pushed,
-			    sd->sbf_count, sd->sbf_balanced, sd->sbf_pushed,
-			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
-			    sd->ttwu_move_balance);
+	/* domain-specific stats */
+	rcu_read_lock();
+	for_each_domain(cpu, sd) {
+		enum cpu_idle_type itype;
+
+		cpumask_scnprintf(mask_str, mask_len,
+				  sched_domain_span(sd));
+		seq_printf(seq, "domain%d %s", dcount++, mask_str);
+		for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
+				itype++) {
+			seq_printf(seq, " %u %u %u %u %u %u %u %u",
+			    sd->lb_count[itype],
+			    sd->lb_balanced[itype],
+			    sd->lb_failed[itype],
+			    sd->lb_imbalance[itype],
+			    sd->lb_gained[itype],
+			    sd->lb_hot_gained[itype],
+			    sd->lb_nobusyq[itype],
+			    sd->lb_nobusyg[itype]);
 		}
-		rcu_read_unlock();
-#endif
+		seq_printf(seq,
+			   " %u %u %u %u %u %u %u %u %u %u %u %u\n",
+		    sd->alb_count, sd->alb_failed, sd->alb_pushed,
+		    sd->sbe_count, sd->sbe_balanced, sd->sbe_pushed,
+		    sd->sbf_count, sd->sbf_balanced, sd->sbf_pushed,
+		    sd->ttwu_wake_remote, sd->ttwu_move_affine,
+		    sd->ttwu_move_balance);
 	}
+	rcu_read_unlock();
+#endif
 	kfree(mask_str);
 	return 0;
 }
 
-static int schedstat_open(struct inode *inode, struct file *file)
+static void *schedstat_start(struct seq_file *file, loff_t *offset)
 {
-	unsigned int size = PAGE_SIZE * (1 + num_online_cpus() / 32);
-	char *buf = kmalloc(size, GFP_KERNEL);
-	struct seq_file *m;
-	int res;
+	unsigned long n = *offset;
 
-	if (!buf)
-		return -ENOMEM;
-	res = single_open(file, show_schedstat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = size;
-	} else
-		kfree(buf);
-	return res;
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
+
+	return NULL;
 }
 
+static void *schedstat_next(struct seq_file *file, void *data, loff_t *offset)
+{
+	(*offset)++;
+	return schedstat_start(file, offset);
+}
+
+static void schedstat_stop(struct seq_file *file, void *data)
+{
+}
+
+static const struct seq_operations schedstat_sops = {
+	.start = schedstat_start,
+	.next  = schedstat_next,
+	.stop  = schedstat_stop,
+	.show  = show_schedstat,
+};
+
+static int schedstat_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &schedstat_sops);
+}
+
+static int schedstat_release(struct inode *inode, struct file *file)
+{
+	return 0;
+};
+
 static const struct file_operations proc_schedstat_operations = {
 	.open    = schedstat_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = single_release,
+	.release = schedstat_release,
 };
 
 static int __init proc_schedstat_init(void)
-- 
1.6.0.2

