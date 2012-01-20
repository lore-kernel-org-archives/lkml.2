Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2ATP7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:59:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63610 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab2ATP72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:59:28 -0500
Message-ID: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: [PATCH] proc:  speedup /proc/stat handling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Date: Fri, 20 Jan 2012 16:59:24 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a typical 16 cpus machine, "cat /proc/stat" gives more than 4096
bytes, and is slow :

# strace -T -o /tmp/STRACE cat /proc/stat | wc -c
5826
# grep "cpu " /tmp/STRACE
read(0, "cpu  1949310 19 2144714 12117253"..., 32768) = 5826 <0.001504>


Thats partly because show_stat() must be called twice since initial
buffer size is too small (4096 bytes for less than 32 possible cpus)

Fix this by :

1) Taking into account nr_irqs in the initial buffer sizing.

2) Using ksize() to allow better filling of initial buffer.

3) Reduce the bloat on "intr ..." line :
   Dont output trailing " 0" values at the end of irq range.

An alternative to 1) would be to remember the largest m->count reached
in show_stat()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Tuner <pjt@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/stat.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 121f77c..78db0fa 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -49,6 +49,20 @@ static u64 get_iowait_time(int cpu)
 	return iowait;
 }
 
+/*
+ * Most irqs at the end of the range are never used.
+ * Find the upper limit, to not output trailing " 0" values
+ */
+static int highest_irq_used(void)
+{
+	int nr;
+
+	for (nr = nr_irqs; nr; nr--)
+		if (kstat_irqs(nr - 1))
+			break;
+	return nr;
+}
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
@@ -129,10 +143,10 @@ static int show_stat(struct seq_file *p, void *v)
 			(unsigned long long)cputime64_to_clock_t(guest_nice));
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
-
-	/* sum again ? it could be updated? */
-	for_each_irq_nr(j)
-		seq_printf(p, " %u", kstat_irqs(j));
+	/* Note that the "sum" value can already be obsolete. */
+	j = highest_irq_used();
+	for (i = 0; i < j; i++)
+		seq_printf(p, " %u", kstat_irqs(i));
 
 	seq_printf(p,
 		"\nctxt %llu\n"
@@ -157,14 +171,17 @@ static int show_stat(struct seq_file *p, void *v)
 
 static int stat_open(struct inode *inode, struct file *file)
 {
-	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
+	unsigned size = 1024 + 128 * num_possible_cpus();
 	char *buf;
 	struct seq_file *m;
 	int res;
 
+	/* minimum size to display a 0 count per interrupt : 2 bytes */
+	size += 2 * nr_irqs;
+
 	/* don't ask for more than the kmalloc() max size */
-	if (size > KMALLOC_MAX_SIZE)
-		size = KMALLOC_MAX_SIZE;
+	size = min_t(unsigned, size, KMALLOC_MAX_SIZE);
+
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -173,7 +190,7 @@ static int stat_open(struct inode *inode, struct file *file)
 	if (!res) {
 		m = file->private_data;
 		m->buf = buf;
-		m->size = size;
+		m->size = ksize(buf);
 	} else
 		kfree(buf);
 	return res;


