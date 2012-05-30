Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2E3SQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181Ab2E3SQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:16:41 -0400
Date: Wed, 30 May 2012 20:15:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>, Pavel Emelyanov <xemul@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pidns: guarantee that the pidns init will be the last
	pidns process reaped
Message-ID: <20120530181500.GA20130@redhat.com>
References: <20120530175745.GA19327@redhat.com> <20120530181429.GA19989@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530181429.GA19989@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Today we have a two-fold bug.  Sometimes release_task on pid == 1 in a
pid namespace can run before other processes in a pid namespace have had
release task called.  With the result that pid_ns_release_proc can be
called before the last proc_flus_task() is done using
upid->ns->proc_mnt, resulting in the use of a stale pointer.  This same
set of circumstances can lead to waitpid(...) returning for a processes
started with clone(CLONE_NEWPID) before the every process in the pid
namespace has actually exited.

To fix this modify zap_pid_ns_processess wait until all other processes
in the pid namespace have exited, even EXIT_DEAD zombies.

The delay_group_leader and related tests ensure that the thread gruop
leader will be the last thread of a process group to be reaped, or to
become EXIT_DEAD and self reap.  With the change to zap_pid_ns_processes
we get the guarantee that pid == 1 in a pid namespace will be the last
task that release_task is called on.

With pid == 1 being the last task to pass through release_task
pid_ns_release_proc can no longer be called too early nor can wait
return before all of the EXIT_DEAD tasks in a pid namespace have exited.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c          |   14 +++++++++++++-
 kernel/pid_namespace.c |   20 ++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 910a071..4fd4c55 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -64,7 +64,6 @@ static void exit_mm(struct task_struct * tsk);
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
-	detach_pid(p, PIDTYPE_PID);
 	if (group_dead) {
 		detach_pid(p, PIDTYPE_PGID);
 		detach_pid(p, PIDTYPE_SID);
@@ -72,7 +71,20 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
 		list_del_rcu(&p->tasks);
 		list_del_init(&p->sibling);
 		__this_cpu_dec(process_counts);
+		/*
+		 * If we are the last child process in a pid namespace to be
+		 * reaped, notify the reaper sleeping zap_pid_ns_processes().
+		 */
+		if (IS_ENABLED(CONFIG_PID_NS)) {
+			struct task_struct *parent = p->real_parent;
+
+			if ((task_active_pid_ns(p)->child_reaper == parent) &&
+			    list_empty(&parent->children) &&
+			    (parent->flags & PF_EXITING))
+				wake_up_process(parent);
+		}
 	}
+	detach_pid(p, PIDTYPE_PID);
 	list_del_rcu(&p->thread_group);
 }
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 57bc1fd..41ed867 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -179,11 +179,31 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	}
 	read_unlock(&tasklist_lock);
 
+	/* Firstly reap the EXIT_ZOMBIE children we may have. */
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
+	/*
+	 * sys_wait4() above can't reap the TASK_DEAD children.
+	 * Make sure they all go away, see __unhash_process().
+	 */
+	for (;;) {
+		bool need_wait = false;
+
+		read_lock(&tasklist_lock);
+		if (!list_empty(&current->children)) {
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+			need_wait = true;
+		}
+		read_unlock(&tasklist_lock);
+
+		if (!need_wait)
+			break;
+		schedule();
+	}
+
 	if (pid_ns->reboot)
 		current->signal->group_exit_code = pid_ns->reboot;
 
-- 
1.5.5.1


