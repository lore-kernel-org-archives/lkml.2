Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab1CaRDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:03:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758491Ab1CaRDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:03:05 -0400
Date: Thu, 31 Mar 2011 19:02:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
Message-ID: <20110331170244.GA13271@redhat.com>
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D94A788.1050806@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stas,

On 03/31, Stas Sergeev wrote:
>
> I found some time to get back to that patch and
> to address all of the problems you pointed.
> What do you think about the attached patch?
> I didn't expect it would became that big.

	 fs/proc/array.c               |    7 -
	 include/asm-generic/siginfo.h |    3 
	 include/linux/init_task.h     |    2 
	 include/linux/prctl.h         |    2 
	 include/linux/sched.h         |   21 +++-
	 kernel/exit.c                 |  200 +++++++++++++++++++++++++++++++++++-------
	 kernel/fork.c                 |    4 
	 kernel/signal.c               |   59 +++++++-----
	 kernel/sys.c                  |   45 +++++++++
	 9 files changed, 281 insertions(+), 62 deletions(-)

Eek! Not only it is big. It is complex and changes a lot of core
kernel code.

Sorry Stas, I am not going to try to review it carefully. As I said,
you need to convince lkml we need this feature first. And iirc you
are not going to suggest this change for everyone.

I guess, the main complication is that you are trying to ensure the
old parent can do wait() without -ECHLD... This complicates everything
soooooooooo much. I _feel_ this can be simplified.... but in any case
we need the nasty complications. And for what?


I only looked at sys_prctl() code, and almost every line looks wrong.
Hmm... in fact, the changes in exit.c look wrong too, but I didn't really
try to understand them.

> @@ -1736,6 +1737,50 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  			else
>  				error = PR_MCE_KILL_DEFAULT;
>  			break;
> +		case PR_DETACH: {
> +			struct task_struct *p, *old_parent;
> +			int notif = DEATH_REAP;
> +			error = -EPERM;
> +			/* not detaching from init */
> +			if (me->real_parent == init_pid_ns.child_reaper)

2 problems. You shouldn't use init_pid_ns, you need the task's namespace.
Also, the task can be the child of /sbin/init's sub-thread.

> +			write_lock_irq(&tasklist_lock);
> +			old_parent = me->real_parent;
> +			me->detach_code = arg2 << 8;
> +			if (!task_detached(me))
> +				notif = do_signal_parent(me, me->exit_signal,
> +					CLD_DETACHED, arg2);

This is simply wrong. We reparent the whole thread group, we should
always notify the old parent. Or never. but this shouldn't depend on
the thread.

> +			if (notif != DEATH_REAP) {
> +				list_add_tail(&me->detached_sibling,
> +					&me->real_parent->detached_children);
> +				me->exit_state = EXIT_DETACHED;

No, no, we can't set ->exit_state != 0. This means the task is dead.

> +			if (!ptrace_reparented(me))
> +				me->parent = init_pid_ns.child_reaper;

Again, this shouldn't use init_pid_ns.child_reaper. But the main problem,
you can't trust ptrace_reparented(). What if the old parent ptraces this
task?

> +			/* detaching makes us a group leader */
> +			me->group_leader = me;

How? Now, we can't change ->group_leader, this is simply not possible
and very wrong. If nothing else, think about tid/tgid, but there are
a lot more problems.

> +			while_each_thread(me, p) {
> +				if (p->real_parent != old_parent)
> +					continue;
> +				if (!ptrace_reparented(p))
> +					p->parent = init_pid_ns.child_reaper;
> +				p->real_parent = init_pid_ns.child_reaper;

The same problems as above, pluse "p->real_parent != old_parent" looks
bogus.


Well. Once again, I never argue with new features, but you need to
convince lkml. Probably it is simple to implement PR_DETACH so that
the task just "disappears" from the old_parent's radar. Otherwise
we need more complications, but I'd rather add the fake TASK_ZOMBIE
task_struct for that. This will be much, much simply although not
pretty anyway.

Oleg.

