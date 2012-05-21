Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2EUMpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:45:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2EUMpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:45:44 -0400
Date: Mon, 21 May 2012 14:44:14 +0200
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
Message-ID: <20120521124414.GA20391@redhat.com>
References: <m1zk9rmyh4.fsf@fess.ebiederm.org> <20120501134214.f6b44f4a.akpm@linux-foundation.org> <87havs7rvv.fsf_-_@xmission.com> <8762c87rrd.fsf_-_@xmission.com> <20120516183920.GA19975@redhat.com> <878vgrsv7q.fsf@xmission.com> <20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com> <20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zk95kper.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> >> I think there is something very compelling about your solution,
> >> we do need my bit about making the init process ignore SIGCHLD
> >> so all of init's children self reap.
> >
> > Not sure I understand. This can work with or without 3/3 which
> > changes zap_pid_ns_processes() to ignore SIGCHLD. And just in
> > case, I think 3/3 is fine.
>
> The only issue I see is that without 3/3 we might have processes that
> on one wait(2)s for and so will never have release_task called on.
>
> We do have the wait loop

Yes, and we need this loop anyway, even if SIGCHLD is ignored.
It is possible that we already have a EXIT_ZOMBIE child(s) when
zap_pid_ns_processes().

> but I think there is a race possible there.

Hmm. I do not see any race, but perhaps I missed something.
I think we can trust -ECHILD, or do_wait() is buggy.

Hmm. But there is another (off-topic) problem, security_task_wait()
can return an error if there are some security policy problems...
OK, this shouldn't happen I hope.

> > And once again, this wait_event() + __wake_up_parent() is very
> > simple and straightforward, we can cleanup this code later if
> > needed.
>
> Yes, and it doesn't when you do an UNINTERRUPTIBLE sleep with
> an INTERRUPTIBLE wake up unless I misread the code.

Yes. so we need wait_event_interruptible() or __unhash_process()
should use __wake_up_sync_key(wait_chldexit).

> > Yes. This is the known oddity. We always notify the tracer if the
> > leader exits, even if !thread_group_empty(). But after that the
> > tracer can't detach, and it can't do do_wait(WEXITED).
> >
> > The problem is not that we can't "fix" this. Just any discussed
> > fix adds the subtle/incompatible user-visible change.
>
> Yes and that is nasty.

Agreed. ptrace API is nasty ;)

> and moving detach_pid so we don't have to be super careful about
> where we call task_active_pid_ns.

Yes, I was thinking about this change too,

> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -189,6 +189,17 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  		rc = sys_wait4(-1, NULL, __WALL, NULL);
>  	} while (rc != -ECHILD);
>
> +	read_lock(&tasklist_lock);
> +	for (;;) {
> +		__set_current_state(TASK_INTERRUPTIBLE);
> +		if (list_empty(&current->children))
> +			break;
> +		read_unlock(&tasklist_lock);
> +		schedule();

OK, but then it makes sense to add clear_thread_flag(TIF_SIGPENDING)
before schedule, to avoid the busy-wait loop (like the sys_wait4 loop
does). Or simply use TASK_UNINTERRUPTIBLE, I do not think it is that
important to "fool" /proc/loadavg. But I am fine either way.

Maybe you can also add "ifdef CONFIG_PID_NS" into __unhash_process(),
but this is minor too.

Oleg.

