Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1IVU5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:57:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32416 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab1IVU5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:57:31 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Colin Cross <ccross@android.com>
Subject: [PATCH 2/3] sched_stats: use the new seq_reserve function
Date: Thu, 22 Sep 2011 13:57:08 -0700
Message-Id: <1316725029-22737-3-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316725029-22737-1-git-send-email-ccross@android.com>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of writing directly to private members of the seq_file struct,
use the new seq_reserve function to specify the predicted size of the
seq buffer.

Signed-off-by: Colin Cross <ccross@android.com>
---
 fs/proc/stat.c       |   23 ++++++++---------------
 kernel/sched_stats.h |   18 +++++++++---------
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 9758b65..1fdf158 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -6,7 +6,6 @@
 #include <linux/proc_fs.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
-#include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/irqnr.h>
 #include <asm/cputime.h>
@@ -134,24 +133,18 @@ static int show_stat(struct seq_file *p, void *v)
 static int stat_open(struct inode *inode, struct file *file)
 {
 	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
-	char *buf;
 	struct seq_file *m;
 	int res;
 
-	/* don't ask for more than the kmalloc() max size */
-	if (size > KMALLOC_MAX_SIZE)
-		size = KMALLOC_MAX_SIZE;
-	buf = kmalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
 	res = single_open(file, show_stat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = size;
-	} else
-		kfree(buf);
+	if (res)
+		return res;
+
+	m = file->private_data;
+	res = seq_reserve(m, size);
+	if (res)
+		single_release(inode, file);
+
 	return res;
 }
 
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 331e01b..ee05143 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -74,19 +74,19 @@ static int show_schedstat(struct seq_file *seq, void *v)
 static int schedstat_open(struct inode *inode, struct file *file)
 {
 	unsigned int size = PAGE_SIZE * (1 + num_online_cpus() / 32);
-	char *buf = kmalloc(size, GFP_KERNEL);
 	struct seq_file *m;
 	int res;
 
-	if (!buf)
-		return -ENOMEM;
 	res = single_open(file, show_schedstat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = size;
-	} else
-		kfree(buf);
+	if (res)
+		return res;
+
+
+	m = file->private_data;
+	res = seq_reserve(m, size);
+	if (res)
+		single_release(inode, file);
+
 	return res;
 }
 
-- 
1.7.4.1

