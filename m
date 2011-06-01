Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab1FADM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:12:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36757 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653Ab1FADKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:10:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jZ2jXAN1Rk8Ha08GLl6yMYfhFhfM2sR442PwXaNJ3z4txEnMpgdCi+nsmdUyVlXrn9
         CYxcE3C97r5Yz3nH1okx5tzbVJZyk1LI4K89jV5uTPW4mkNxRnUV3xRJncJs7FD0bP3j
         yZOYCQh5tLD0G0oJhdsnm1OI7AUPvJ2q11MhM=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        Will Drewry <wad@chromium.org>
Subject: [PATCH v3 04/13] seccomp_filter: add process state reporting
Date: Tue, 31 May 2011 22:10:36 -0500
Message-Id: <1306897845-9393-4-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds seccomp and seccomp_filter status reporting to proc.
/proc/<pid>/seccomp_filter provides the current seccomp mode
and the list of allowed or dynamically filtered system calls.

v3: changed to using filters directly.
v2: removed status entry, added seccomp file.
    (requested by kosaki.motohiro@jp.fujitsu.com)
    allowed S_IRUGO reading of entries
    (requested by viro@zeniv.linux.org.uk)
    added flags
    got rid of the seccomp_t type
    dropped seccomp file

Signed-off-by: Will Drewry <wad@chromium.org>
---
 fs/proc/base.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index dfa5327..01473fe 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -73,6 +73,7 @@
 #include <linux/security.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
+#include <linux/seccomp.h>
 #include <linux/cgroup.h>
 #include <linux/cpuset.h>
 #include <linux/audit.h>
@@ -579,6 +580,24 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
 }
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
+/*
+ * Print out the current seccomp filter set for the task.
+ */
+#ifdef CONFIG_SECCOMP_FILTER
+int proc_pid_seccomp_filter_show(struct seq_file *m, struct pid_namespace *ns,
+				 struct pid *pid, struct task_struct *task)
+{
+	struct seccomp_filters *filters;
+
+	rcu_read_lock();
+	filters = get_seccomp_filters(task->seccomp.filters);
+	rcu_read_unlock();
+	seccomp_show_filters(filters, m);
+	put_seccomp_filters(filters);
+	return 0;
+}
+#endif /* CONFIG_SECCOMP_FILTER */
+
 /************************************************************************/
 /*                       Here the fs part begins                        */
 /************************************************************************/
@@ -2838,6 +2857,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",    S_IRUGO, proc_pid_syscall),
 #endif
+#ifdef CONFIG_SECCOMP_FILTER
+	ONE("seccomp_filter",     S_IRUGO, proc_pid_seccomp_filter_show),
+#endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
@@ -3180,6 +3202,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",   S_IRUGO, proc_pid_syscall),
 #endif
+#ifdef CONFIG_SECCOMP_FILTER
+	ONE("seccomp_filter",     S_IRUGO, proc_pid_seccomp_filter_show),
+#endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
-- 
1.7.0.4

