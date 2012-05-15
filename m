Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965463Ab2EOCe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:34:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:49824 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965358Ab2EOCR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 144/179] proc: restrict access to /proc/PID/io
Date: Mon, 14 May 2012 22:14:00 -0400
Message-ID: <1337048075-6132-145-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1d1221f375c94ef961ba8574ac4f85c8870ddd51 upstream.

/proc/PID/io may be used for gathering private information.  E.g.  for
openssh and vsftpd daemons wchars/rchars may be used to learn the
precise password length.  Restrict it to processes being able to ptrace
the target process.

ptrace_may_access() is needed to prevent keeping open file descriptor of
"io" file, executing setuid binary and gathering io information of the
setuid'ed process.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/proc/base.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 268f00d..08741b0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2518,6 +2518,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
 
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+		return -EACCES;
+
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
 
@@ -2640,7 +2643,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, proc_tgid_io_accounting),
+	INF("io",	S_IRUSR, proc_tgid_io_accounting),
 #endif
 };
 
@@ -2976,7 +2979,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, proc_tid_io_accounting),
+	INF("io",	S_IRUSR, proc_tid_io_accounting),
 #endif
 };
 
-- 
1.7.9.6

