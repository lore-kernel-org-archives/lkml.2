Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2LSHDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:03:11 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44350 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2LSHCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:02:55 -0500
X-AuditID: 85900ec0-d4a78b900000152f-43-50d1669d5038
Subject: [PATCH v3 -tip 2/4] tracing: replace static old_tracer with strcmp
To: rostedt@goodmis.org
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: masami.hiramatsu.pt@hitachi.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 19 Dec 2012 16:02:43 +0900
Message-ID: <20121219070243.31200.73060.stgit@liselsia>
In-Reply-To: <20121219070218.31200.64647.stgit@liselsia>
References: <20121219070218.31200.64647.stgit@liselsia>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, read functions for trace buffer use static "old_tracer"
for detecting changes of current tracer. This is because we can
assume that these functions are used from only one file ("trace").

But we are adding snapshot feature for ftrace, then those functions
are called from two files. So we remove all static "old_tracer", and
replace those with string comparison between current and previous
tracers.

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/trace/trace.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a8ce008..8d05a44 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1948,7 +1948,6 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
 	struct trace_iterator *iter = m->private;
-	static struct tracer *old_tracer;
 	int cpu_file = iter->cpu_file;
 	void *p = NULL;
 	loff_t l = 0;
@@ -1956,10 +1955,9 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(current_trace &&
+		     strcmp(iter->trace->name, current_trace->name) != 0))
 		*iter->trace = *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
 
 	atomic_inc(&trace_record_cmdline_disabled);
@@ -3481,7 +3479,6 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
-	static struct tracer *old_tracer;
 	ssize_t sret;
 
 	/* return any leftover data */
@@ -3493,10 +3490,9 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(current_trace &&
+		     strcmp(iter->trace->name, current_trace->name) != 0))
 		*iter->trace = *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
 
 	/*
@@ -3652,7 +3648,6 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		.ops		= &tracing_pipe_buf_ops,
 		.spd_release	= tracing_spd_release_pipe,
 	};
-	static struct tracer *old_tracer;
 	ssize_t ret;
 	size_t rem;
 	unsigned int i;
@@ -3662,10 +3657,9 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(current_trace &&
+		     strcmp(iter->trace->name, current_trace->name) != 0))
 		*iter->trace = *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
 
 	mutex_lock(&iter->mutex);

