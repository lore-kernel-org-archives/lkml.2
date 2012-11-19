Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2KSPyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:54:43 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35627 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753492Ab2KSPym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:54:42 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: davej@redhat.com, Nathan Zimmer <nzimmer@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] procfs: /proc/schedstat fails on very very large machines.
Date: Mon, 19 Nov 2012 09:54:39 -0600
Message-Id: <1353340480-31962-2-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1353340480-31962-1-git-send-email-nzimmer@sgi.com>
References: <1353340480-31962-1-git-send-email-nzimmer@sgi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems with 4096 cores doing a cat /proc/schedstat fails.
We are trying to push all the data into a single kmalloc buffer.
The issue is on these very large machines all the data will not fit in 4mb.
The failure can occur on smaller systems when memory fragmentation is high.

A better solution is to not us the single_open mechanism but to provide
our own seq_operations.

The output should be identical to previous version and thus not need the
version number.


Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Reported-by: Dave Jones <davej@redhat.com>
---
 kernel/sched/stats.c |   73 ++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 53 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index 903ffa9..33a85c9 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -21,9 +21,13 @@ static int show_schedstat(struct seq_file *seq, void *v)
 	if (mask_str == NULL)
 		return -ENOMEM;
 
-	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
-	seq_printf(seq, "timestamp %lu\n", jiffies);
-	for_each_online_cpu(cpu) {
+	if (v == (void *)1) {
+		seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
+		seq_printf(seq, "timestamp %lu\n", jiffies);
+	} else {
+
+		cpu = (unsigned long)(v - 2);
+
 		struct rq *rq = cpu_rq(cpu);
 #ifdef CONFIG_SMP
 		struct sched_domain *sd;
@@ -72,35 +76,64 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		}
 		rcu_read_unlock();
 #endif
+		kfree(mask_str);
 	}
-	kfree(mask_str);
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
+	return NULL;
+}
+
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
 }
 
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

