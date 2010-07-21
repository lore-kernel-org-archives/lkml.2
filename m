Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0GUUw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:52:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:37512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab0GUUwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:52:53 -0400
Date: Wed, 21 Jul 2010 20:52:25 GMT
From: tip-bot for Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jkacur@redhat.com, lizf@cn.fujitsu.com, arnd@arndb.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkacur@redhat.com, lizf@cn.fujitsu.com, arnd@arndb.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1278538820-1392-10-git-send-email-arnd@arndb.de>
References: <1278538820-1392-10-git-send-email-arnd@arndb.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Use generic_file_llseek for debugfs
Message-ID: <tip-b444786f1a797a7f84e2561346a670649f9c7b3c@git.kernel.org>
Git-Commit-ID: b444786f1a797a7f84e2561346a670649f9c7b3c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 20:52:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b444786f1a797a7f84e2561346a670649f9c7b3c
Gitweb:     http://git.kernel.org/tip/b444786f1a797a7f84e2561346a670649f9c7b3c
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Wed, 7 Jul 2010 23:40:11 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 20 Jul 2010 14:31:24 +0200

tracing: Use generic_file_llseek for debugfs

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
