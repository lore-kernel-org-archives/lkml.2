Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2E0TMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 15:12:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab2E0TMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 15:12:38 -0400
Date: Sun, 27 May 2012 21:11:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH v2 -mm 1/1] pidns: find_new_reaper() can no longer switch
	to init_pid_ns.child_reaper
Message-ID: <20120527191106.GC13929@redhat.com>
References: <87zk95kper.fsf@xmission.com> <20120521124414.GA20391@redhat.com> <87d35x5ank.fsf_-_@xmission.com> <20120522122315.c3f2118c.akpm@linux-foundation.org> <20120523145239.GA20378@redhat.com> <20120525151526.GA13111@redhat.com> <20120525155941.GA16885@redhat.com> <20120525160008.GB16885@redhat.com> <87pq9sdjhn.fsf@xmission.com> <20120527191032.GB13929@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120527191032.GB13929@redhat.com>
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
---
 kernel/exit.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 6d66cd2..6424e6b 100644
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
@@ -79,13 +80,12 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
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
 
@@ -732,12 +732,6 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 
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


