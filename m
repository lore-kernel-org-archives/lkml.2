Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1HSOTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:19:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39818 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab1HSOQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:16:40 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Date: Fri, 19 Aug 2011 16:16:12 +0200
Message-Id: <1313763382-12341-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313763382-12341-1-git-send-email-tj@kernel.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in freezing an exiting task.  The current code
seemingly tries that by calling clear_freeze_flag() from exit_mm() but
it's racy as freeze might happen afterwards.

This patch removes the racy clear_freeze_flag() makes do_exit() set
PF_NOFREEZE after PTRACE_EVENT_EXIT, after which freezing doesn't make
sense.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/exit.c          |    8 ++++++--
 kernel/power/process.c |    3 +--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 2913b35..ac58259 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -679,8 +679,6 @@ static void exit_mm(struct task_struct * tsk)
 	tsk->mm = NULL;
 	up_read(&mm->mmap_sem);
 	enter_lazy_tlb(mm, current);
-	/* We don't want this task to be frozen prematurely */
-	clear_freeze_flag(tsk);
 	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 		atomic_dec(&mm->oom_disable_count);
 	task_unlock(tsk);
@@ -915,6 +913,12 @@ NORET_TYPE void do_exit(long code)
 
 	ptrace_event(PTRACE_EVENT_EXIT, code);
 
+	/*
+	 * With ptrace notification done, there's no point in freezing from
+	 * here on.  Disallow freezing.
+	 */
+	current->flags |= PF_NOFREEZE;
+
 	validate_creds_for_do_exit(tsk);
 
 	/*
diff --git a/kernel/power/process.c b/kernel/power/process.c
index bec09c3..ddfaba4 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -25,8 +25,7 @@
 static inline int freezable(struct task_struct * p)
 {
 	if ((p == current) ||
-	    (p->flags & PF_NOFREEZE) ||
-	    (p->exit_state != 0))
+	    (p->flags & PF_NOFREEZE))
 		return 0;
 	return 1;
 }
-- 
1.7.6

