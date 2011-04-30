Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab1D3Pcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:32:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49182 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab1D3PcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:32:13 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=lQztQpZcCqsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=hzJqanYz6aWS7RFxOswA:9 a=geBDE3o6ETdHOpP2jA4A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110430153210.878319847@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 30 Apr 2011 11:30:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/8] ftrace: Remove failures file
References: <20110430153040.354378898@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Remove-failures-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The failures file in the debugfs tracing directory would list the
functions that failed to convert when the old dead ftrace daemon
tried to update code but failed. Since this code is now dead along
with the daemon the failures file is useless. Remove it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   39 ++-------------------------------------
 1 files changed, 2 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f199fb2..97b30f8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1355,9 +1355,8 @@ static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 enum {
 	FTRACE_ITER_FILTER	= (1 << 0),
 	FTRACE_ITER_NOTRACE	= (1 << 1),
-	FTRACE_ITER_FAILURES	= (1 << 2),
-	FTRACE_ITER_PRINTALL	= (1 << 3),
-	FTRACE_ITER_HASH	= (1 << 4),
+	FTRACE_ITER_PRINTALL	= (1 << 2),
+	FTRACE_ITER_HASH	= (1 << 3),
 };
 
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
@@ -1487,12 +1486,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		rec = &iter->pg->records[iter->idx++];
 		if ((rec->flags & FTRACE_FL_FREE) ||
 
-		    (!(iter->flags & FTRACE_ITER_FAILURES) &&
-		     (rec->flags & FTRACE_FL_FAILED)) ||
-
-		    ((iter->flags & FTRACE_ITER_FAILURES) &&
-		     !(rec->flags & FTRACE_FL_FAILED)) ||
-
 		    ((iter->flags & FTRACE_ITER_FILTER) &&
 		     !(rec->flags & FTRACE_FL_FILTER)) ||
 
@@ -1633,24 +1626,6 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-static int
-ftrace_failures_open(struct inode *inode, struct file *file)
-{
-	int ret;
-	struct seq_file *m;
-	struct ftrace_iterator *iter;
-
-	ret = ftrace_avail_open(inode, file);
-	if (!ret) {
-		m = file->private_data;
-		iter = m->private;
-		iter->flags = FTRACE_ITER_FAILURES;
-	}
-
-	return ret;
-}
-
-
 static void ftrace_filter_reset(int enable)
 {
 	struct ftrace_page *pg;
@@ -2448,13 +2423,6 @@ static const struct file_operations ftrace_avail_fops = {
 	.release = seq_release_private,
 };
 
-static const struct file_operations ftrace_failures_fops = {
-	.open = ftrace_failures_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release_private,
-};
-
 static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = seq_read,
@@ -2683,9 +2651,6 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	trace_create_file("available_filter_functions", 0444,
 			d_tracer, NULL, &ftrace_avail_fops);
 
-	trace_create_file("failures", 0444,
-			d_tracer, NULL, &ftrace_failures_fops);
-
 	trace_create_file("set_ftrace_filter", 0644, d_tracer,
 			NULL, &ftrace_filter_fops);
 
-- 
1.7.2.3


