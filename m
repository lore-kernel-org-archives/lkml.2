Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1FXMJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:09:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47957 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab1FXMJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=YB2/qco49SErp8Os4mshWJZDNwthe77rgEF1fZWIMfhB3Llvmh5PBpb/cgWhGGQxDE
         QAqlMspNqGcTT5M9gpIGzOVN8ehOyJ1fCWcXrZf3MavwI+uDc4rycGgarP5Aq8gT0kit
         CG115+Qwc/KsCXqXwoUoFkQCwa136MvN6W56M=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org,
        Eric Paris <eparis@redhat.com>, Solar Designer <solar@openwall.com>
Subject: [PATCH 1/2] proc: restrict access to /proc/PID/io
Date: Fri, 24 Jun 2011 16:08:38 +0400
Message-Id: <1308917318-4749-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/PID/io may be used for gathering private information.  E.g. for
openssh and vsftpd daemons wchars/rchars may be used to learn the
precise password length.  Restrict it to processes being able to ptrace
the target process.

ptrace_may_access() is needed to prevent keeping open file descriptor of
"io" file, executing setuid binary and gathering io information of the
setuid'ed process.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/proc/base.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 14def99..5ae25d1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2712,6 +2712,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
 
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+		return -EACCES;
+
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
 
@@ -2843,7 +2846,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, proc_tgid_io_accounting),
+	INF("io",	S_IRUSR, proc_tgid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
 	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
@@ -3185,7 +3188,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, proc_tid_io_accounting),
+	INF("io",	S_IRUSR, proc_tid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
 	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
-- 
1.7.0.4

