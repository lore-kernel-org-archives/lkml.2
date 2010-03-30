Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab0C3GUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:20:18 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34946 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab0C3GUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O4x7eOQQ9/SExvWUOb+Ol7r7hzfS6yFM6mam+/9ddKXGdNj/2Mi/NHWfSJQ1jD/0Dk
         /qX0fdYA1C25sOru47LUyfSUW7Cn4r8O+amWhdzuC7fpBew36zGgAer4Ax9vjYThBtZb
         XnEwOIPdAmAFznqFMIX3vY2vCPqdczvh74N1o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/6] procfs: Kill BKL in llseek on proc base
Date: Tue, 30 Mar 2010 08:20:10 +0200
Message-Id: <1269930015-863-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

We don't use the BKL elsewhere, so use generic_file_llseek
so we can avoid default_llseek taking the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[restore proc_fdinfo_file_operations as non-seekable]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 fs/proc/base.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index a731084..95d91cf 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -728,6 +728,7 @@ out_no_task:
 
 static const struct file_operations proc_info_file_operations = {
 	.read		= proc_info_read,
+	.llseek		= generic_file_llseek,
 };
 
 static int proc_single_show(struct seq_file *m, void *v)
@@ -985,6 +986,7 @@ out_no_task:
 
 static const struct file_operations proc_environ_operations = {
 	.read		= environ_read,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t oom_adjust_read(struct file *file, char __user *buf,
@@ -1058,6 +1060,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 static const struct file_operations proc_oom_adjust_operations = {
 	.read		= oom_adjust_read,
 	.write		= oom_adjust_write,
+	.llseek		= generic_file_llseek,
 };
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -1129,6 +1132,7 @@ out_free_page:
 static const struct file_operations proc_loginuid_operations = {
 	.read		= proc_loginuid_read,
 	.write		= proc_loginuid_write,
+	.llseek		= generic_file_llseek,
 };
 
 static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
@@ -1149,6 +1153,7 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
 
 static const struct file_operations proc_sessionid_operations = {
 	.read		= proc_sessionid_read,
+	.llseek		= generic_file_llseek,
 };
 #endif
 
@@ -1200,6 +1205,7 @@ static ssize_t proc_fault_inject_write(struct file * file,
 static const struct file_operations proc_fault_inject_operations = {
 	.read		= proc_fault_inject_read,
 	.write		= proc_fault_inject_write,
+	.llseek		= generic_file_llseek,
 };
 #endif
 
@@ -1941,7 +1947,7 @@ static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
 }
 
 static const struct file_operations proc_fdinfo_file_operations = {
-	.open		= nonseekable_open,
+	.open           = nonseekable_open,
 	.read		= proc_fdinfo_read,
 };
 
@@ -2225,6 +2231,7 @@ out_no_task:
 static const struct file_operations proc_pid_attr_operations = {
 	.read		= proc_pid_attr_read,
 	.write		= proc_pid_attr_write,
+	.llseek		= generic_file_llseek,
 };
 
 static const struct pid_entry attr_dir_stuff[] = {
@@ -2345,6 +2352,7 @@ static ssize_t proc_coredump_filter_write(struct file *file,
 static const struct file_operations proc_coredump_filter_operations = {
 	.read		= proc_coredump_filter_read,
 	.write		= proc_coredump_filter_write,
+	.llseek		= generic_file_llseek,
 };
 #endif
 
-- 
1.6.2.3

