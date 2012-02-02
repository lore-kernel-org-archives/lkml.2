Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab2BBUzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:55:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53256 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2BBUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:55:44 -0500
Message-ID: <1328216139.2480.24.camel@edumazet-laptop>
Subject: [PATCH] sched: reduce /proc/schedstat access times
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 02 Feb 2012 21:55:39 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 16 cpus NUMA machine, we can have quite a long /proc/schedstat

# wc -c /proc/schedstat 
8355 /proc/schedstat

It appears show_schedstat() is called three times, because initial
seq_file buffer size is underestimated.

seq buffer must be reallocated two times and we spend 3x more time than
needed.

A quick fix is to maintain the maximum length reached in
show_schedstat() instead of guessing.

Also use seq_bitmap() to avoid the mask_str temp variable.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/stats.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index 2a581ba..34bb9c8 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -11,15 +11,11 @@
  * format, so that tools can adapt (or abort)
  */
 #define SCHEDSTAT_VERSION 15
+static size_t max_schedstat_len = 4096;
 
 static int show_schedstat(struct seq_file *seq, void *v)
 {
 	int cpu;
-	int mask_len = DIV_ROUND_UP(NR_CPUS, 32) * 9;
-	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
-
-	if (mask_str == NULL)
-		return -ENOMEM;
 
 	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
 	seq_printf(seq, "timestamp %lu\n", jiffies);
@@ -47,9 +43,9 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
 
-			cpumask_scnprintf(mask_str, mask_len,
-					  sched_domain_span(sd));
-			seq_printf(seq, "domain%d %s", dcount++, mask_str);
+			seq_printf(seq, "domain%d ", dcount++);
+			seq_bitmap(seq, cpumask_bits(sched_domain_span(sd)),
+				   nr_cpumask_bits);
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
 				seq_printf(seq, " %u %u %u %u %u %u %u %u",
@@ -73,14 +69,13 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		rcu_read_unlock();
 #endif
 	}
-	kfree(mask_str);
+	max_schedstat_len = max(max_schedstat_len, seq->count);
 	return 0;
 }
 
 static int schedstat_open(struct inode *inode, struct file *file)
 {
-	unsigned int size = PAGE_SIZE * (1 + num_online_cpus() / 32);
-	char *buf = kmalloc(size, GFP_KERNEL);
+	char *buf = kmalloc(max_schedstat_len, GFP_KERNEL);
 	struct seq_file *m;
 	int res;
 
@@ -90,7 +85,7 @@ static int schedstat_open(struct inode *inode, struct file *file)
 	if (!res) {
 		m = file->private_data;
 		m->buf = buf;
-		m->size = size;
+		m->size = ksize(buf);
 	} else
 		kfree(buf);
 	return res;


