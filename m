Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab0GTOm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:42:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45709 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761348Ab0GTOm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Z35+B+/rSB/pvaRBaFDDnOmByNJdHt7TczRW8w8OSCo4cv7wFjF6NSfmgR3GCPq+WY
         c4wLFa2xBli3PbvhQ3Au8PLgAtbO3wuey18MRE/83+B/gigh4MZVhOxUi9X7qZi414zH
         97gc6jgC73sWXsaSvRkR9J8zlMweVe/C5pzpE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3] tracing: Use generic_file_llseek for debugfs
Date: Tue, 20 Jul 2010 16:42:05 +0200
Message-Id: <1279636925-5919-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1279636925-5919-1-git-send-regression-fweisbec@gmail.com>
References: <1279636925-5919-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The default for llseek will change to no_llseek,
so the tracing debugfs files need to add explicit
.llseek assignments. Since we're dealing with regular
files from a VFS perspective, use generic_file_llseek.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <1278538820-1392-10-git-send-email-arnd@arndb.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d9a4aa0..c1752da 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2338,6 +2338,7 @@ static const struct file_operations show_traces_fops = {
 	.open		= show_traces_open,
 	.read		= seq_read,
 	.release	= seq_release,
+	.llseek		= seq_lseek,
 };
 
 /*
@@ -2431,6 +2432,7 @@ static const struct file_operations tracing_cpumask_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_cpumask_read,
 	.write		= tracing_cpumask_write,
+	.llseek		= generic_file_llseek,
 };
 
 static int tracing_trace_options_show(struct seq_file *m, void *v)
@@ -2597,6 +2599,7 @@ tracing_readme_read(struct file *filp, char __user *ubuf,
 static const struct file_operations tracing_readme_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_readme_read,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t
@@ -2647,6 +2650,7 @@ tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
 static const struct file_operations tracing_saved_cmdlines_fops = {
     .open       = tracing_open_generic,
     .read       = tracing_saved_cmdlines_read,
+    .llseek	= generic_file_llseek,
 };
 
 static ssize_t
@@ -2976,6 +2980,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	if (iter->trace->pipe_open)
 		iter->trace->pipe_open(iter);
 
+	nonseekable_open(inode, filp);
 out:
 	mutex_unlock(&trace_types_lock);
 	return ret;
@@ -3534,18 +3539,21 @@ static const struct file_operations tracing_max_lat_fops = {
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
@@ -3554,17 +3562,20 @@ static const struct file_operations tracing_pipe_fops = {
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
@@ -3870,6 +3881,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 static const struct file_operations tracing_stats_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_stats_read,
+	.llseek		= generic_file_llseek,
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -3906,6 +3918,7 @@ tracing_read_dyn_info(struct file *filp, char __user *ubuf,
 static const struct file_operations tracing_dyn_info_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_read_dyn_info,
+	.llseek		= generic_file_llseek,
 };
 #endif
 
@@ -4059,6 +4072,7 @@ static const struct file_operations trace_options_fops = {
 	.open = tracing_open_generic,
 	.read = trace_options_read,
 	.write = trace_options_write,
+	.llseek	= generic_file_llseek,
 };
 
 static ssize_t
@@ -4110,6 +4124,7 @@ static const struct file_operations trace_options_core_fops = {
 	.open = tracing_open_generic,
 	.read = trace_options_core_read,
 	.write = trace_options_core_write,
+	.llseek = generic_file_llseek,
 };
 
 struct dentry *trace_create_file(const char *name,
-- 
1.6.2.3

