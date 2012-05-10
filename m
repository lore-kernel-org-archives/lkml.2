Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab2EJI4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:56:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48441 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540Ab2EJI4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:56:49 -0400
Date: Thu, 10 May 2012 01:56:32 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-50e18b94c695644d824381e7574b9c44acc25ffe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1335342219-2782-5-git-send-email-jolsa@redhat.com>
References: <1335342219-2782-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Use seq_*_private interface for some seq files
Git-Commit-ID: 50e18b94c695644d824381e7574b9c44acc25ffe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 01:56:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50e18b94c695644d824381e7574b9c44acc25ffe
Gitweb:     http://git.kernel.org/tip/50e18b94c695644d824381e7574b9c44acc25ffe
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 25 Apr 2012 10:23:39 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 8 May 2012 21:04:12 -0400

tracing: Use seq_*_private interface for some seq files

It's appropriate to use __seq_open_private interface to open
some of trace seq files, because it covers all steps we are
duplicating in tracing code - zallocating the iterator and
setting it as seq_file's private.

Using this for following files:
  trace
  available_filter_functions
  enabled_functions

Link: http://lkml.kernel.org/r/1335342219-2782-5-git-send-email-jolsa@redhat.com

Signed-off-by: Jiri Olsa <jolsa@redhat.com>

[
 Fixed warnings for:
   kernel/trace/trace.c: In function '__tracing_open':
   kernel/trace/trace.c:2418:11: warning: unused variable 'ret' [-Wunused-variable]
   kernel/trace/trace.c:2417:19: warning: unused variable 'm' [-Wunused-variable]
]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   44 +++++++++++---------------------------------
 kernel/trace/trace.c  |   30 +++++-------------------------
 2 files changed, 16 insertions(+), 58 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0fa92f6..cf81f27 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2469,57 +2469,35 @@ static int
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
index f11a285..4fb10ef 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2413,15 +2413,13 @@ static struct trace_iterator *
 __tracing_open(struct inode *inode, struct file *file)
 {
 	long cpu_file = (long) inode->i_private;
-	void *fail_ret = ERR_PTR(-ENOMEM);
 	struct trace_iterator *iter;
-	struct seq_file *m;
-	int cpu, ret;
+	int cpu;
 
 	if (tracing_disabled)
 		return ERR_PTR(-ENODEV);
 
-	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	iter = __seq_open_private(file, &tracer_seq_ops, sizeof(*iter));
 	if (!iter)
 		return ERR_PTR(-ENOMEM);
 
@@ -2478,32 +2476,15 @@ __tracing_open(struct inode *inode, struct file *file)
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
@@ -2539,11 +2520,10 @@ static int tracing_release(struct inode *inode, struct file *file)
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
 
