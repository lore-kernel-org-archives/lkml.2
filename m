Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946306Ab2ESADz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:03:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33581 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946141Ab2ESADw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:03:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
References: <20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<87havs7rvv.fsf_-_@xmission.com> <8762c87rrd.fsf_-_@xmission.com>
	<20120516183920.GA19975@redhat.com> <878vgrsv7q.fsf@xmission.com>
	<20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com>
	<20120518123911.GA417@redhat.com>
Date: Fri, 18 May 2012 18:03:40 -0600
In-Reply-To: <20120518123911.GA417@redhat.com> (Oleg Nesterov's message of
	"Fri, 18 May 2012 14:39:11 +0200")
Message-ID: <87zk95kper.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18aG9dzEn6FockJGmAJ4DeU/v6voQ3Yoms=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1647]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/3] pidns: Guarantee that the pidns init will be the last pidns process reaped.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 05/17, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > What do you think?
>>
>> I think there is something very compelling about your solution,
>> we do need my bit about making the init process ignore SIGCHLD
>> so all of init's children self reap.
>
> Not sure I understand. This can work with or without 3/3 which
> changes zap_pid_ns_processes() to ignore SIGCHLD. And just in
> case, I think 3/3 is fine.

The only issue I see is that without 3/3 we might have processes that
on one wait(2)s for and so will never have release_task called on.

We do have the wait loop but I think there is a race possible there.

> And once again, this wait_event() + __wake_up_parent() is very
> simple and straightforward, we can cleanup this code later if
> needed.

Yes, and it doesn't when you do an UNINTERRUPTIBLE sleep with
an INTERRUPTIBLE wake up unless I misread the code.

>> > Do you mean the "if (tsk->ptrace)" code in exit_notify() ? Nobody
>> > understand it ;) Last time this code was modified by me (iirc), but
>> > I simply tried to preserve the previous behaviour.
>>
>> Yes.  It is some pretty strange code.
>
> Yes. In particular, I think it should always use SIGCHLD.
>
>> Especially where we are reading
>> a return result which is always false.  I think there is a bug somewhere
>> between that code and ptrace detach
>
> Yes. This is the known oddity. We always notify the tracer if the
> leader exits, even if !thread_group_empty(). But after that the
> tracer can't detach, and it can't do do_wait(WEXITED).
>
> The problem is not that we can't "fix" this. Just any discussed
> fix adds the subtle/incompatible user-visible change.

Yes and that is nasty.

I need to sit down and write a good change log and do a bit more testing
(hopefully tonight) but this is what I have come up with so far.

It is based on your first version of the patch with a few changes
a TASK_INTERRUPTIBLE sleep so that we don't count in the load average,
and moving detach_pid so we don't have to be super careful about
where we call task_active_pid_ns.

Eric


---
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
index b98b0ed..ce96627 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -189,6 +189,17 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
+	read_lock(&tasklist_lock);
+	for (;;) {
+		__set_current_state(TASK_INTERRUPTIBLE);
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

