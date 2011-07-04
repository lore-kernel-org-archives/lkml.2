Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1GDUNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 16:13:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38196 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1GDUNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 16:13:45 -0400
Date: Tue, 5 Jul 2011 00:13:39 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca,
        security@kernel.org, kernel-hardening@lists.openwall.com
Subject: [PATCH v2] proc: fix a race in do_io_accounting()
Message-ID: <20110704201339.GA5645@albatros>
References: <20110703103925.GA2283@albatros>
 <CA+55aFwfr-oAa-2L9O_rd9iZDyVr0b+gFQS=_R5PUxmhh3JEsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwfr-oAa-2L9O_rd9iZDyVr0b+gFQS=_R5PUxmhh3JEsg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a ptrace_may_access() check in do_io_accounting() to prevent
gathering information of setuid'ed and similar binaries.  However, there
is a race against execve().  Holding task->signal->cred_guard_mutex
while gathering the information should protect against the race.

The order of locking is similar to the one inside of
ptrace_attach(): first goes cred_guard_mutex, then lock_task_sighand().

v2 - use mutex_lock_killable() instead of mutex_lock().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: stable@kernel.org
---
 fs/proc/base.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 083a4f2..4b9f159 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2711,9 +2711,16 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 {
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
+	int result;
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
+	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (result)
+		return result;
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		result = -EACCES;
+		goto out_unlock;
+	}
 
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
@@ -2724,7 +2731,7 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 
 		unlock_task_sighand(task, &flags);
 	}
-	return sprintf(buffer,
+	result = sprintf(buffer,
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
@@ -2739,6 +2746,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 			(unsigned long long)acct.read_bytes,
 			(unsigned long long)acct.write_bytes,
 			(unsigned long long)acct.cancelled_write_bytes);
+out_unlock:
+	mutex_unlock(&task->signal->cred_guard_mutex);
+	return result;
 }
 
 static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
-- 
1.7.0.4
