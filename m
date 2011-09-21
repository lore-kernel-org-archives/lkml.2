Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1IUV4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33832 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1IUV4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:39 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 21/26] dynamic_debug: add $DBGFS/dynamic_debug/pending file
Date: Wed, 21 Sep 2011 15:55:10 -0600
Message-Id: <1316642115-20029-22-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Add pending file so user can see queries that are pending.  Output
format imitates that used to submit commands/queries.  This simplifies
cut-paste-edit to delete pending queries when they're no longer wanted.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |  191 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 188 insertions(+), 3 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index d7b71a6..80b5322 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -64,6 +64,10 @@ struct ddebug_iter {
 	unsigned int idx;
 };
 
+struct pending_iter {
+	struct pending_query *elem;
+};
+
 static DEFINE_MUTEX(ddebug_lock);
 static LIST_HEAD(ddebug_tables);
 static int verbose = 0;
@@ -842,7 +846,8 @@ static void *ddebug_proc_start(struct seq_file *m, loff_t *pos)
 	int n = *pos;
 
 	if (verbose >= VERBOSE_PROC)
-		pr_info("called m=%p *pos=%lld\n", m, (unsigned long long)*pos);
+		pr_info("called m=%p *pos=%lld\n",
+			m, (unsigned long long)*pos);
 
 	mutex_lock(&ddebug_lock);
 
@@ -963,7 +968,180 @@ static const struct file_operations ddebug_proc_fops = {
 	.write = ddebug_proc_write
 };
 
-/* apply matching queries in pending-queries list */
+/*
+ * Set the iterator to point to the first pending_query object
+ * and return a pointer to that first object.  Returns
+ * NULL if there are no pending_querys at all.
+ */
+static struct pending_query *pending_iter_first(struct pending_iter *iter)
+{
+	if (list_empty(&pending_queries)) {
+		iter->elem = NULL;
+		return NULL;
+	}
+	iter->elem = list_entry(pending_queries.next,
+				 struct pending_query, link);
+	return iter->elem;
+}
+
+/*
+ * Advance the iterator to point to the next pending_query
+ * object from the one the iterator currently points at,
+ * and returns a pointer to the new pending_query.  Returns
+ * NULL if the iterator has seen all the pending_querys.
+ */
+static struct pending_query *pending_iter_next(struct pending_iter *iter)
+{
+	if (iter->elem == NULL)
+		return NULL;
+	if (list_is_last(&iter->elem->link, &pending_queries)) {
+		iter->elem = NULL;
+		return NULL;
+	}
+	iter->elem = list_entry(iter->elem->link.next,
+				struct pending_query, link);
+	return iter->elem;
+}
+
+/*
+ * Seq_ops start method.  Called at the start of every read() call on
+ * pending file from userspace.  Takes the ddebug_lock and seeks the
+ * seq_file's iterator to the given position.
+ */
+static void *pending_proc_start(struct seq_file *m, loff_t *pos)
+{
+	struct pending_iter *iter = m->private;
+	struct pending_query *pq;
+	int n = *pos;
+
+	if (verbose >= VERBOSE_PROC)
+		pr_info("called m=%p *pos=%lld\n",
+			m, (unsigned long long)*pos);
+
+	mutex_lock(&ddebug_lock);
+
+	if (!n)
+		return SEQ_START_TOKEN;
+	if (n < 0)
+		return NULL;
+	pq = pending_iter_first(iter);
+	while (pq != NULL && --n > 0)
+		pq = pending_iter_next(iter);
+	return pq;
+}
+
+/*
+ * Seq_ops next method.  Called several times within a read()
+ * call from userspace, with pending_lock held.  Walks to the
+ * next pending_query object with a special case for the header line.
+ */
+static void *pending_proc_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct pending_iter *iter = m->private;
+	struct pending_query *pq;
+
+	if (verbose >= VERBOSE_PROC_SHOW)
+		pr_info("called m=%p p=%p *pos=%lld\n",
+			m, p, (unsigned long long)*pos);
+
+	if (p == SEQ_START_TOKEN)
+		pq = pending_iter_first(iter);
+	else
+		pq = pending_iter_next(iter);
+	++*pos;
+	return pq;
+}
+
+/*
+ * Seq_ops show method.  Called several times within a read()
+ * call from userspace, with pending_lock held.  Formats the
+ * current pending_query as a single human-readable line, with a
+ * special case for the header line.
+ */
+static int pending_proc_show(struct seq_file *m, void *p)
+{
+	struct pending_iter *iter = m->private;
+	struct pending_query *pq = iter->elem;
+	struct ddebug_query *q = &pq->query;
+	char flagsbuf[10];
+
+	if (verbose >= VERBOSE_PROC_SHOW)
+		pr_info("called m=%p p=%p\n", m, p);
+
+	if (p == SEQ_START_TOKEN) {
+		seq_puts(m, "# func file module format line flags mask\n");
+		return 0;
+	}
+
+	seq_printf(m, "%s%s%s%s%s%s%s%s line %d-%d %s\n",
+		q->module ? "module " : "",
+		q->module ? q->module : "",
+		q->function ? " func " : "",
+		q->function ? q->function : "",
+		q->filename ? " file " : "",
+		q->filename ? q->filename : "",
+		q->format ? " format " : "",
+		q->format ? q->format : "",
+		q->first_lineno, q->last_lineno,
+		ddebug_describe_flags(pq->flags, flagsbuf, sizeof(flagsbuf)));
+
+	return 0;
+}
+
+/*
+ * Seq_ops stop method.  Called at the end of each read()
+ * call from userspace.  Drops pending_lock.
+ */
+static void pending_proc_stop(struct seq_file *m, void *p)
+{
+	if (verbose >= VERBOSE_PROC)
+		pr_info("called m=%p p=%p\n", m, p);
+	mutex_unlock(&ddebug_lock);
+}
+
+static const struct seq_operations pending_proc_seqops = {
+	.start = pending_proc_start,
+	.next = pending_proc_next,
+	.show = pending_proc_show,
+	.stop = pending_proc_stop
+};
+
+/*
+ * File_ops->open method for <debugfs>/dynamic_debug/control.  Does the seq_file
+ * setup dance, and also creates an iterator to walk the pending_querys.
+ * Note that we create a seq_file always, even for O_WRONLY files
+ * where it's not needed, as doing so simplifies the ->release method.
+ */
+static int pending_proc_open(struct inode *inode, struct file *file)
+{
+	struct pending_iter *iter;
+	int err;
+
+	if (verbose)
+		pr_info("called\n");
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (iter == NULL)
+		return -ENOMEM;
+
+	err = seq_open(file, &pending_proc_seqops);
+	if (err) {
+		kfree(iter);
+		return err;
+	}
+	((struct seq_file *) file->private_data)->private = iter;
+	return 0;
+}
+
+static const struct file_operations pending_proc_fops = {
+	.owner = THIS_MODULE,
+	.open = pending_proc_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release_private,
+};
+
+/* apply matching queries in pending-queries list. Called with lock held */
 static void apply_pending_queries(struct ddebug_table *dt)
 {
 	struct pending_query *pq, *pqnext;
@@ -1063,7 +1241,7 @@ static __initdata int ddebug_init_success;
 
 static int __init dynamic_debug_init_debugfs(void)
 {
-	struct dentry *dir, *file;
+	struct dentry *dir, *file, *file2;
 
 	if (!ddebug_init_success)
 		return -ENODEV;
@@ -1077,6 +1255,13 @@ static int __init dynamic_debug_init_debugfs(void)
 		debugfs_remove(dir);
 		return -ENOMEM;
 	}
+	file2 = debugfs_create_file("pending", 0444, dir, NULL,
+					&pending_proc_fops);
+	if (!file2) {
+		debugfs_remove(file);
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
 	return 0;
 }
 
-- 
1.7.4.4

