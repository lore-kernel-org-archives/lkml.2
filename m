Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab2EVAUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:20:43 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50107 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2EVAUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:20:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
References: <m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<87havs7rvv.fsf_-_@xmission.com> <8762c87rrd.fsf_-_@xmission.com>
	<20120516183920.GA19975@redhat.com> <878vgrsv7q.fsf@xmission.com>
	<20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com>
	<20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com>
	<20120521124414.GA20391@redhat.com>
Date: Mon, 21 May 2012 18:20:31 -0600
In-Reply-To: <20120521124414.GA20391@redhat.com> (Oleg Nesterov's message of
	"Mon, 21 May 2012 14:44:14 +0200")
Message-ID: <87d35x5ank.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX198VQuI0oX7mx6grnyKR3jQimhxtB5rvJA=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0008]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: [PATCH] pidns: Guarantee that the pidns init will be the last pidns process reaped. v2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---

Andrew can you replace your earlier version of this patch in your tree
with this one, after Oleg takes a look at it.  I think this is about
as simple and maintainable and obvious as we can make this bug fix.

 kernel/exit.c          |   13 ++++++++++++-
 kernel/pid_namespace.c |   11 +++++++++++
 2 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d8bd3b42..abc4fc0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -64,15 +64,26 @@ static void exit_mm(struct task_struct * tsk);
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
-	detach_pid(p, PIDTYPE_PID);
 	if (group_dead) {
+		struct task_struct *parent;
+
 		detach_pid(p, PIDTYPE_PGID);
 		detach_pid(p, PIDTYPE_SID);
 
 		list_del_rcu(&p->tasks);
 		list_del_init(&p->sibling);
 		__this_cpu_dec(process_counts);
+
+		/* If we are the last child process in a pid namespace
+		 * to be reaped notify the child_reaper.
+		 */
+		parent = p->real_parent;
+		if ((task_active_pid_ns(p)->child_reaper == parent) &&
+		    list_empty(&parent->children) &&
+		    (parent->flags & PF_EXITING))
+			wake_up_process(parent);
 	}
+	detach_pid(p, PIDTYPE_PID);
 	list_del_rcu(&p->thread_group);
 }
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index b98b0ed..ba1cbb8 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -189,6 +189,17 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
+	read_lock(&tasklist_lock);
+	for (;;) {
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		if (list_empty(&current->children))
+			break;
+		read_unlock(&tasklist_lock);
+		schedule();
+		read_lock(&tasklist_lock);
+	}
+	read_unlock(&tasklist_lock);
+
 	if (pid_ns->reboot)
 		current->signal->group_exit_code = pid_ns->reboot;
 
-- 
1.7.5.4

