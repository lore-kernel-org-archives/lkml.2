Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2DYIYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:24:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046Ab2DYIXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:23:52 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/4] tracing: Use seq_*_private interface for some seq files
Date: Wed, 25 Apr 2012 10:23:39 +0200
Message-Id: <1335342219-2782-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
References: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's appropriate to use __seq_open_private interface to open
some of trace seq files, because it covers all steps we are
duplicating in tracing code - zallocating the iterator and
setting it as seq_file's private.

Using this for following files:
  trace
  available_filter_functions
  enabled_functions

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c |   44 +++++++++++---------------------------------
 kernel/trace/trace.c  |   27 ++++-----------------------
 2 files changed, 15 insertions(+), 56 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e67f5b3..14989a7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2359,57 +2359,35 @@ static int
 ftrace_avail_open(struct inode *inode, struct file *file)
 {
 	struct ftrace_iterator *iter;
-	int ret;
 
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
-	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter)
-		return -ENOMEM;
-
-	iter->pg = ftrace_pages_start;
-	iter->ops = &global_ops;
-
-	ret = seq_open(file, &show_ftrace_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-
-		m->private = iter;
-	} else {
-		kfree(iter);
+	iter = __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
+	if (iter) {
+		iter->pg = ftrace_pages_start;
+		iter->ops = &global_ops;
 	}
 
-	return ret;
+	return iter ? 0 : -ENOMEM;
 }
 
 static int
 ftrace_enabled_open(struct inode *inode, struct file *file)
 {
 	struct ftrace_iterator *iter;
-	int ret;
 
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
-	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter)
-		return -ENOMEM;
-
-	iter->pg = ftrace_pages_start;
-	iter->flags = FTRACE_ITER_ENABLED;
-	iter->ops = &global_ops;
-
-	ret = seq_open(file, &show_ftrace_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-
-		m->private = iter;
-	} else {
-		kfree(iter);
+	iter = __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
+	if (iter) {
+		iter->pg = ftrace_pages_start;
+		iter->flags = FTRACE_ITER_ENABLED;
+		iter->ops = &global_ops;
 	}
 
-	return ret;
+	return iter ? 0 : -ENOMEM;
 }
 
 static void ftrace_filter_reset(struct ftrace_hash *hash)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ed7b5d1..cf382a4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2332,7 +2332,6 @@ static struct trace_iterator *
 __tracing_open(struct inode *inode, struct file *file)
 {
 	long cpu_file = (long) inode->i_private;
-	void *fail_ret = ERR_PTR(-ENOMEM);
 	struct trace_iterator *iter;
 	struct seq_file *m;
 	int cpu, ret;
@@ -2340,7 +2339,7 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (tracing_disabled)
 		return ERR_PTR(-ENODEV);
 
-	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	iter = __seq_open_private(file, &tracer_seq_ops, sizeof(*iter));
 	if (!iter)
 		return ERR_PTR(-ENOMEM);
 
@@ -2397,32 +2396,15 @@ __tracing_open(struct inode *inode, struct file *file)
 		tracing_iter_reset(iter, cpu);
 	}
 
-	ret = seq_open(file, &tracer_seq_ops);
-	if (ret < 0) {
-		fail_ret = ERR_PTR(ret);
-		goto fail_buffer;
-	}
-
-	m = file->private_data;
-	m->private = iter;
-
 	mutex_unlock(&trace_types_lock);
 
 	return iter;
 
- fail_buffer:
-	for_each_tracing_cpu(cpu) {
-		if (iter->buffer_iter[cpu])
-			ring_buffer_read_finish(iter->buffer_iter[cpu]);
-	}
-	free_cpumask_var(iter->started);
-	tracing_start();
  fail:
 	mutex_unlock(&trace_types_lock);
 	kfree(iter->trace);
-	kfree(iter);
-
-	return fail_ret;
+	seq_release_private(inode, file);
+	return ERR_PTR(-ENOMEM);
 }
 
 int tracing_open_generic(struct inode *inode, struct file *filp)
@@ -2458,11 +2440,10 @@ static int tracing_release(struct inode *inode, struct file *file)
 	tracing_start();
 	mutex_unlock(&trace_types_lock);
 
-	seq_release(inode, file);
 	mutex_destroy(&iter->mutex);
 	free_cpumask_var(iter->started);
 	kfree(iter->trace);
-	kfree(iter);
+	seq_release_private(inode, file);
 	return 0;
 }
 
-- 
1.7.1

