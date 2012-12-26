Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2LZCx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 21:53:28 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44550 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2LZCxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 21:53:23 -0500
X-AuditID: 85900ec0-d687bb900000152f-ec-50da66a004db
Subject: [PATCH v4 -tip 1/3] tracing: replace static old_tracer with trace
 iterator's pointer to the original tracer's name
To: rostedt@goodmis.org
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: masami.hiramatsu.pt@hitachi.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 26 Dec 2012 11:52:52 +0900
Message-ID: <20121226025252.3252.9276.stgit@liselsia>
In-Reply-To: <20121226025243.3252.61095.stgit@liselsia>
References: <20121226025243.3252.61095.stgit@liselsia>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the trace buffer read functions use a static variable
"old_tracer" for detecting if the current tracer changes. This
was suitable for a single trace file ("trace"), but to add a
snapshot feature that will use the same function for its file,
a check against a static variable is not sufficient.

To use the output functions for two different files, instead of
storing the current tracer in a static variable, as the trace
iterator descriptor contains a pointer to the original current
tracer's name, that pointer can now be used to check if the
current tracer has changed between different reads of the trace
file.

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/trace/trace.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a8ce008..1787304 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1948,18 +1948,20 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
 	struct trace_iterator *iter = m->private;
-	static struct tracer *old_tracer;
 	int cpu_file = iter->cpu_file;
 	void *p = NULL;
 	loff_t l = 0;
 	int cpu;
 
-	/* copy the tracer to avoid using a global lock all around */
+	/*
+	 * copy the tracer to avoid using a global lock all around.
+	 * iter->trace is a copy of current_trace, the pointer to the
+	 * name may be used instead of a strcmp(), as iter->trace->name
+	 * will point to the same string as current_trace->name.
+	 */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(current_trace && iter->trace->name != current_trace->name))
 		*iter->trace = *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
 
 	atomic_inc(&trace_record_cmdline_disabled);
@@ -3481,7 +3483,6 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
-	static struct tracer *old_tracer;
 	ssize_t sret;
 
 	/* return any leftover data */
@@ -3493,10 +3494,8 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(current_trace && iter->trace->name != current_trace->name))
 		*iter->trace = *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
 
 	/*
@@ -3652,7 +3651,6 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		.ops		= &tracing_pipe_buf_ops,
 		.spd_release	= tracing_spd_release_pipe,
 	};
-	static struct tracer *old_tracer;
 	ssize_t ret;
 	size_t rem;
 	unsigned int i;
@@ -3662,10 +3660,8 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(current_trace && iter->trace->name != current_trace->name))
 		*iter->trace = *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
 
 	mutex_lock(&iter->mutex);

