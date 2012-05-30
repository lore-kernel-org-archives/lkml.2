Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab2E3SQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181Ab2E3SQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:16:51 -0400
Date: Wed, 30 May 2012 20:15:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>, Pavel Emelyanov <xemul@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] pidns: find_new_reaper() can no longer switch to
	init_pid_ns.child_reaper
Message-ID: <20120530181515.GB20130@redhat.com>
References: <20120530175745.GA19327@redhat.com> <20120530181429.GA19989@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530181429.GA19989@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_new_reaper() changes pid_ns->child_reaper, see add0d4df
"pid_ns: zap_pid_ns_processes: fix the ->child_reaper changing".

The original reason has gone away after the previous patch,
->children list must be empty after zap_pid_ns_processes().

However now we can not switch to init_pid_ns.child_reaper.
__unhash_process() relies on the "->child_reaper == parent"
check, but this check does not work if the last exiting task
is also the child reaper.

As Eric sugested, we can change __unhash_process() to use the
parent's pid_ns and remove this code.

Also, with this change we can move detach_pid(PIDTYPE_PID) back,
where it was before the previous fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/exit.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 4fd4c55..ab972a7 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -64,6 +64,7 @@ static void exit_mm(struct task_struct * tsk);
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
+	detach_pid(p, PIDTYPE_PID);
 	if (group_dead) {
 		detach_pid(p, PIDTYPE_PGID);
 		detach_pid(p, PIDTYPE_SID);
@@ -78,13 +79,12 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
 		if (IS_ENABLED(CONFIG_PID_NS)) {
 			struct task_struct *parent = p->real_parent;
 
-			if ((task_active_pid_ns(p)->child_reaper == parent) &&
+			if ((task_active_pid_ns(parent)->child_reaper == parent) &&
 			    list_empty(&parent->children) &&
 			    (parent->flags & PF_EXITING))
 				wake_up_process(parent);
 		}
 	}
-	detach_pid(p, PIDTYPE_PID);
 	list_del_rcu(&p->thread_group);
 }
 
@@ -731,12 +731,6 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 
 		zap_pid_ns_processes(pid_ns);
 		write_lock_irq(&tasklist_lock);
-		/*
-		 * We can not clear ->child_reaper or leave it alone.
-		 * There may by stealth EXIT_DEAD tasks on ->children,
-		 * forget_original_parent() must move them somewhere.
-		 */
-		pid_ns->child_reaper = init_pid_ns.child_reaper;
 	} else if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 
-- 
1.5.5.1


