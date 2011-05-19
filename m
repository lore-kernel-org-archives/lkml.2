Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab1ESCM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:12:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab1ESCM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:57 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=P7R3Y0ANyKcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=orXai1FcPfeG1WgOt9cA:9 a=UIO_JIiqGv00OqBu5akA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021255.939888337@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:11:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/13] ftrace: Add enabled_functions file
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-Add-enabled_functions-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the enabled_functions file that is used to show all the
functions that have been enabled for tracing as well as their
ref counts. This helps seeing if any function has been registered
and what functions are being traced.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5dd332c..065f1e6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1703,6 +1703,7 @@ enum {
 	FTRACE_ITER_NOTRACE	= (1 << 1),
 	FTRACE_ITER_PRINTALL	= (1 << 2),
 	FTRACE_ITER_HASH	= (1 << 3),
+	FTRACE_ITER_ENABLED	= (1 << 4),
 };
 
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
@@ -1842,7 +1843,11 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		     !(ftrace_lookup_ip(ops->filter_hash, rec->ip))) ||
 
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
-		     !ftrace_lookup_ip(ops->notrace_hash, rec->ip))) {
+		     !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) ||
+
+		    ((iter->flags & FTRACE_ITER_ENABLED) &&
+		     !(rec->flags & ~FTRACE_FL_MASK))) {
+
 			rec = NULL;
 			goto retry;
 		}
@@ -1944,7 +1949,11 @@ static int t_show(struct seq_file *m, void *v)
 	if (!rec)
 		return 0;
 
-	seq_printf(m, "%ps\n", (void *)rec->ip);
+	seq_printf(m, "%ps", (void *)rec->ip);
+	if (iter->flags & FTRACE_ITER_ENABLED)
+		seq_printf(m, " (%ld)",
+			   rec->flags & ~FTRACE_FL_MASK);
+	seq_printf(m, "\n");
 
 	return 0;
 }
@@ -1983,6 +1992,34 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
+static int
+ftrace_enabled_open(struct inode *inode, struct file *file)
+{
+	struct ftrace_iterator *iter;
+	int ret;
+
+	if (unlikely(ftrace_disabled))
+		return -ENODEV;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
+	iter->pg = ftrace_pages_start;
+	iter->flags = FTRACE_ITER_ENABLED;
+
+	ret = seq_open(file, &show_ftrace_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+
+		m->private = iter;
+	} else {
+		kfree(iter);
+	}
+
+	return ret;
+}
+
 static void ftrace_filter_reset(struct ftrace_hash *hash)
 {
 	mutex_lock(&ftrace_lock);
@@ -2838,6 +2875,13 @@ static const struct file_operations ftrace_avail_fops = {
 	.release = seq_release_private,
 };
 
+static const struct file_operations ftrace_enabled_fops = {
+	.open = ftrace_enabled_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release_private,
+};
+
 static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = seq_read,
@@ -3069,6 +3113,9 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	trace_create_file("available_filter_functions", 0444,
 			d_tracer, NULL, &ftrace_avail_fops);
 
+	trace_create_file("enabled_functions", 0444,
+			d_tracer, NULL, &ftrace_enabled_fops);
+
 	trace_create_file("set_ftrace_filter", 0644, d_tracer,
 			NULL, &ftrace_filter_fops);
 
-- 
1.7.4.4


