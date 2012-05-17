Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301Ab2EQRBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:01:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967436Ab2EQRBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:01:36 -0400
Date: Thu, 17 May 2012 19:00:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/3] pidns: Guarantee that the pidns init will be the
	last pidns process reaped.
Message-ID: <20120517170015.GA12436@redhat.com>
References: <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org> <20120429165846.GA19054@redhat.com> <1335754867.17899.4.camel@marge.simpson.net> <m1zk9rmyh4.fsf@fess.ebiederm.org> <20120501134214.f6b44f4a.akpm@linux-foundation.org> <87havs7rvv.fsf_-_@xmission.com> <8762c87rrd.fsf_-_@xmission.com> <20120516183920.GA19975@redhat.com> <878vgrsv7q.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vgrsv7q.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > Hmm. I don't think the patch is 100% correct. Afaics, this needs more
> > delay_pidns_leader() checks.
> >
> > For example. Suppose we have a CLONE_NEWPID zombie I, it has an
> > EXIT_DEAD child D so delay_pidns_leader(I) == T.
> >
> > Now suppose that I->real_parent exits, lets denote this task as P.
> >
> > Suppose that P->real_parent ignores SIGCHLD.
> >
> > In this case P will do release_task(I) prematurely. And worse, when
> > D finally does realease_task(D) it will do realease_task(I) again.
>
> Good point.  I will fix that and post a patch shortly.  It doesn't
> need a full delay_pidns_leader test just a test for children.

This will add more complications. And even this is not enough, I guess.
For example __ptrace_detach()...

I agree, the idea to "hack" release_task() so that it switches to
init is clever, but imho this is too clever ;)

Seriously, what do you think about the patch below? Or something
like this. It is still based on your suggestion to check ->children,
but it is much, much more simple and understandable.

Just in case... Even with the PF_EXITING check __wake_up_parent()
can be wrong, but this is very unlikely and harmless.

What do you think?

> In looking for any other weird corner case bugs I am noticing that
> I don't think I handled the case of a ptraced init quite right.
> I don't understand the change signaling semantics when the
> ptracer is our parent.

Do you mean the "if (tsk->ptrace)" code in exit_notify() ? Nobody
understand it ;) Last time this code was modified by me (iirc), but
I simply tried to preserve the previous behaviour.

Oleg.

--- x/kernel/exit.c
+++ x/kernel/exit.c
@@ -63,6 +63,13 @@ static void exit_mm(struct task_struct *
 
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
+	struct task_struct *parent = p->parent;
+	bool parent_is_init = false;
+
+#ifdef CONFIG_PID_NS
+	parent_is_init = (task_active_pid_ns(p)->child_reaper == parent);
+#endif
+
 	nr_threads--;
 	detach_pid(p, PIDTYPE_PID);
 	if (group_dead) {
@@ -72,6 +79,11 @@ static void __unhash_process(struct task
 		list_del_rcu(&p->tasks);
 		list_del_init(&p->sibling);
 		__this_cpu_dec(process_counts);
+
+		if (parent_is_init && (parent->flags & PF_EXITING)) {
+			if (list_empty(&parent->children))
+				__wake_up_parent(p, parent);
+		}
 	}
 	list_del_rcu(&p->thread_group);
 }
--- x/kernel/pid_namespace.c
+++ x/kernel/pid_namespace.c
@@ -184,6 +184,9 @@ void zap_pid_ns_processes(struct pid_nam
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
+	wait_event(&current->signal->wait_chldexit,
+			list_empty(&current->children));
+
 	if (pid_ns->reboot)
 		current->signal->group_exit_code = pid_ns->reboot;
 

