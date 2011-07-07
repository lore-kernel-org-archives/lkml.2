Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab1GGTgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab1GGTgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:36:00 -0400
Date: Thu, 7 Jul 2011 21:33:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] has_stopped_jobs: s/task_is_stopped/SIGNAL_STOP_STOPPED/
Message-ID: <20110707193354.GA27600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

has_stopped_jobs() naively checks task_is_stopped(group_leader). This
was always wrong even without ptrace, group_leader can be dead. And
given that ptrace can change the state to TRACED this is wrong even
in the single-threaded case.

Change the code to check SIGNAL_STOP_STOPPED and simplify the code,
retval + break/continue doesn't make this trivial code more readable.

We could probably add the usual "|| signal->group_stop_count" check
but I don't think this makes sense, the task can start the group-stop
right after the check anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- ptrace/kernel/exit.c~2_has_stopped_jobs	2011-06-28 17:50:27.000000000 +0200
+++ ptrace/kernel/exit.c	2011-07-07 21:09:00.000000000 +0200
@@ -266,18 +266,16 @@ int is_current_pgrp_orphaned(void)
 	return retval;
 }
 
-static int has_stopped_jobs(struct pid *pgrp)
+static bool has_stopped_jobs(struct pid *pgrp)
 {
-	int retval = 0;
 	struct task_struct *p;
 
 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
-		if (!task_is_stopped(p))
-			continue;
-		retval = 1;
-		break;
+		if (p->signal->flags & SIGNAL_STOP_STOPPED)
+			return true;
 	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
-	return retval;
+
+	return false;
 }
 
 /*

