Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2E0Sm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 14:42:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab2E0Sm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 14:42:57 -0400
Date: Sun, 27 May 2012 20:41:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH -mm v2]
	pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-r
	eaped-v2-fix-fix
Message-ID: <20120527184116.GA13929@redhat.com>
References: <20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com> <20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com> <20120521124414.GA20391@redhat.com> <87d35x5ank.fsf_-_@xmission.com> <20120522122315.c3f2118c.akpm@linux-foundation.org> <20120523145239.GA20378@redhat.com> <20120525151526.GA13111@redhat.com> <87obpceyvw.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obpceyvw.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > 1. Update the comments in zap_pid_ns_processes() and __unhash_process()
>
> In zap_pid_ns_processes I wonder if we should update the big block
> comment with a little more of the theory.  AKA we want as many children
> to self-reap and become EXIT_DEAD children as possible becasue it
> enables more parallelism and is thus faster.

Yes, the comment can be better, I agree.

Ideally it should explain that we need the sys_wait4() loop even if
we ignore SIGCHLD (with your patch), but at the same time we need
the wait-for-empty loop even if SIGCHLD is not ignored.

OK, I tried to make it a bit better, see below. Feel free to rewrite.

> > 2. Move the wake-up-reaper code in __unhash_process() under IS_ENABLED()
>
> I don't really care, it ceartainly looks better than an #ifdef block.
> However come to think of it, it is about time to just plain start
> removing those config options.

Probably, I do not mind if we remove CONFIG_PID_NS. But until we do this,
I think IS_ENABLED(CONFIG_PID_NS) makes sense as a documentation.

> > 3. Re-structure the wait-for-empty-children code in zap_pid_ns_processes()
> The restructuring seems basically sane.

Good.

> > +		 * reaped, notify the child_reaper, see zap_pid_ns_processes().
> >  		 */
>
> How about instead:
> >  		/*
> >  		 * If we are the last child process in a pid namespace to be
> > -		 * reaped, notify the child_reaper.
> > +		 * reaped, wake up the child_reaper sleeping in zap_pid_ns_processes().

OK.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c          |   17 +++++++++--------
 kernel/pid_namespace.c |   22 +++++++++++++++-------
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 231decb..6d66cd2 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -65,8 +65,6 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
 	if (group_dead) {
-		struct task_struct *parent;
-
 		detach_pid(p, PIDTYPE_PGID);
 		detach_pid(p, PIDTYPE_SID);
 
@@ -76,13 +74,16 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
 
 		/*
 		 * If we are the last child process in a pid namespace to be
-		 * reaped, notify the child_reaper.
+		 * reaped, notify the reaper sleeping zap_pid_ns_processes().
 		 */
-		parent = p->real_parent;
-		if ((task_active_pid_ns(p)->child_reaper == parent) &&
-		    list_empty(&parent->children) &&
-		    (parent->flags & PF_EXITING))
-			wake_up_process(parent);
+		if (IS_ENABLED(CONFIG_PID_NS)) {
+			struct task_struct *parent = p->real_parent;
+
+			if ((task_active_pid_ns(p)->child_reaper == parent) &&
+			    list_empty(&parent->children) &&
+			    (parent->flags & PF_EXITING))
+				wake_up_process(parent);
+		}
 	}
 	detach_pid(p, PIDTYPE_PID);
 	list_del_rcu(&p->thread_group);
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 723c948..41ed867 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -179,22 +179,30 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	}
 	read_unlock(&tasklist_lock);
 
+	/* Firstly reap the EXIT_ZOMBIE children we may have. */
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
-	read_lock(&tasklist_lock);
+	/*
+	 * sys_wait4() above can't reap the TASK_DEAD children.
+	 * Make sure they all go away, see __unhash_process().
+	 */
 	for (;;) {
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-		if (list_empty(&current->children))
-			break;
+		bool need_wait = false;
+
+		read_lock(&tasklist_lock);
+		if (!list_empty(&current->children)) {
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+			need_wait = true;
+		}
 		read_unlock(&tasklist_lock);
+
+		if (!need_wait)
+			break;
 		schedule();
-		read_lock(&tasklist_lock);
 	}
-	read_unlock(&tasklist_lock);
-	set_current_state(TASK_RUNNING);
 
 	if (pid_ns->reboot)
 		current->signal->group_exit_code = pid_ns->reboot;
-- 
1.5.5.1


