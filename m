Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2EYPQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:16:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab2EYPQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:16:56 -0400
Date: Fri, 25 May 2012 17:15:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH -mm]
	pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-r
	eaped-v2-fix-fix
Message-ID: <20120525151526.GA13111@redhat.com>
References: <20120516183920.GA19975@redhat.com> <878vgrsv7q.fsf@xmission.com> <20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com> <20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com> <20120521124414.GA20391@redhat.com> <87d35x5ank.fsf_-_@xmission.com> <20120522122315.c3f2118c.akpm@linux-foundation.org> <20120523145239.GA20378@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523145239.GA20378@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So. Eric, Andrew, will you agree with this cleanup on top of
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch
?

1. Update the comments in zap_pid_ns_processes() and __unhash_process()

2. Move the wake-up-reaper code in __unhash_process() under IS_ENABLED()

3. Re-structure the wait-for-empty-children code in zap_pid_ns_processes()

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c          |   17 +++++++++--------
 kernel/pid_namespace.c |   21 ++++++++++++++-------
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 231decb..b3e6e0e 100644
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
+		 * reaped, notify the child_reaper, see zap_pid_ns_processes().
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
index 723c948..c2b0df3 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -184,17 +184,24 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
-	read_lock(&tasklist_lock);
+	/*
+	 * sys_wait4() above can't reap the TASK_DEAD children we may
+	 * have. Make sure they all go away, see __unhash_process().
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

