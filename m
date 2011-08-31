Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1HaKVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:21:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44431 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab1HaKVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:21:51 -0400
Date: Wed, 31 Aug 2011 12:21:43 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>,
        Paul Menage <paul@paulmenage.org>
Cc: containers@lists.linux-foundation.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH pm-freezer 2/4] freezer: set PF_NOFREEZE on a dying task
 right before TASK_DEAD setting bug in freezer_change_state()
Message-ID: <20110831102143.GB2828@mtj.dyndns.org>
References: <20110831102100.GA2828@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831102100.GA2828@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: work/kernel/exit.c
===================================================================
--- work.orig/kernel/exit.c
+++ work/kernel/exit.c
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
