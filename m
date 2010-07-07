Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab0GGVkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:40:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab0GGVkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 09/18] tracing: use generic_file_llseek for debugfs
Date: Wed,  7 Jul 2010 23:40:11 +0200
Message-Id: <1278538820-1392-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:D0k4/n2V9QDAShcFlF98X0eOOw8B8Doo+T+nq/nQ+Um
 HPKAC8ruAuCtf5aqG01yfPgAHoDMbLBvqp0WC3IYYDnpm+T6dy
 JQeGlv2r64d2QYHIQyY1POZpqA4ROP6Ltr41SGQMp+LWdTKyuA
 SpUU9/Kqg3dF6FzK8+gPSQ93DwN2xfER85rutlOtQUSxEbiapH
 dTejszdGIIpolEH1oY88w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default for llseek will change to no_llseek,
so the tracing debugfs files need to add explicit
.llseek assignments. Since we're dealing with regular
files from a VFS perspective, use generic_file_llseek.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 086d363..de3d6b3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2394,6 +2394,7 @@ static const struct file_operations show_traces_fops = {
 	.open		= show_traces_open,
 	.read		= seq_read,
 	.release	= seq_release,
+	.llseek		= seq_lseek,
 };
 
 /*
@@ -2487,6 +2488,7 @@ static const struct file_operations tracing_cpumask_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_cpumask_read,
 	.write		= tracing_cpumask_write,
+	.llseek		= generic_file_llseek,
 };
 
 static int tracing_trace_options_show(struct seq_file *m, void *v)
@@ -2653,6 +2655,7 @@ tracing_readme_read(struct file *filp, char __user *ubuf,
 static const struct file_operations tracing_readme_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_readme_read,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t
@@ -2703,6 +2706,7 @@ tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
 static const struct file_operations tracing_saved_cmdlines_fops = {
     .open       = tracing_open_generic,
     .read       = tracing_saved_cmdlines_read,
+    .llseek	= generic_file_llseek,
 };
 
 static ssize_t
@@ -3032,6 +3036,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	if (iter->trace->pipe_open)
 		iter->trace->pipe_open(iter);
 
+	nonseekable_open(inode, filp);
 out:
 	mutex_unlock(&trace_types_lock);
 	return ret;
@@ -3590,18 +3595,21 @@ static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
 	.write		= tracing_max_lat_write,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations tracing_ctrl_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_ctrl_read,
 	.write		= tracing_ctrl_write,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations set_tracer_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_set_trace_read,
 	.write		= tracing_set_trace_write,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations tracing_pipe_fops = {
@@ -3610,17 +3618,20 @@ static const struct file_operations tracing_pipe_fops = {
 	.read		= tracing_read_pipe,
 	.splice_read	= tracing_splice_read_pipe,
 	.release	= tracing_release_pipe,
+	.llseek		= no_llseek,
 };
 
 static const struct file_operations tracing_entries_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_entries_read,
 	.write		= tracing_entries_write,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations tracing_mark_fops = {
 	.open		= tracing_open_generic,
 	.write		= tracing_mark_write,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct file_operations trace_clock_fops = {
@@ -3926,6 +3937,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 static const struct file_operations tracing_stats_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_stats_read,
+	.llseek		= generic_file_llseek,
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -3962,6 +3974,7 @@ tracing_read_dyn_info(struct file *filp, char __user *ubuf,
 static const struct file_operations tracing_dyn_info_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_read_dyn_info,
+	.llseek		= generic_file_llseek,
 };
 #endif
 
@@ -4115,6 +4128,7 @@ static const struct file_operations trace_options_fops = {
 	.open = tracing_open_generic,
 	.read = trace_options_read,
 	.write = trace_options_write,
+	.llseek	= generic_file_llseek,
 };
 
 static ssize_t
@@ -4166,6 +4180,7 @@ static const struct file_operations trace_options_core_fops = {
 	.open = tracing_open_generic,
 	.read = trace_options_core_read,
 	.write = trace_options_core_write,
+	.llseek = generic_file_llseek,
 };
 
 struct dentry *trace_create_file(const char *name,
-- 
1.7.1

