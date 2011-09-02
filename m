Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1IBS2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:28:13 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48414 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab1IBS2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:28:10 -0400
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org
Cc: containers@lists.linux-foundation.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] freezer: set PF_NOFREEZE on a dying task right before TASK_DEAD setting bug in freezer_change_state()
Date: Sat,  3 Sep 2011 03:27:46 +0900
Message-Id: <1314988070-12244-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314988070-12244-1-git-send-email-tj@kernel.org>
References: <1314988070-12244-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3fb45733df "freezer: make exiting tasks properly unfreezable" removed
clear_freeze_flag() from exit path and set PF_NOFREEZE right after
PTRACE_EVENT_EXIT; however, Oleg pointed out that following exit paths
may cause interaction with device drivers after PM freezer consider
the system frozen.

There's no try_to_freeze() call in the exit path and the only
necessary guarantee is that freezer doesn't hang waiting for zombies.
Set PF_NOFREEZE right before setting tsk->state to TASK_DEAD instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/exit.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index ac58259..7b6c4fa 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -913,12 +913,6 @@ NORET_TYPE void do_exit(long code)
 
 	ptrace_event(PTRACE_EVENT_EXIT, code);
 
-	/*
-	 * With ptrace notification done, there's no point in freezing from
-	 * here on.  Disallow freezing.
-	 */
-	current->flags |= PF_NOFREEZE;
-
 	validate_creds_for_do_exit(tsk);
 
 	/*
@@ -1044,6 +1038,10 @@ NORET_TYPE void do_exit(long code)
 
 	preempt_disable();
 	exit_rcu();
+
+	/* this task is now dead and freezer should ignore it */
+	current->flags |= PF_NOFREEZE;
+
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
 	schedule();
-- 
1.7.6

