Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab2BON7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:59:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab2BON7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:59:49 -0500
Date: Wed, 15 Feb 2012 14:53:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: Use SEND_SIG_FORCED instead of force_sig()
Message-ID: <20120215135306.GA11174@redhat.com>
References: <13288070803232@kroah.org> <20120210201008.GA21009@redhat.com> <20120214225017.GA12360@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214225017.GA12360@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Anton Vorontsov wrote:
>
> Change send_sig_all() to use do_send_sig_info(SEND_SIG_FORCED)
> instead of force_sig(SIGKILL). With the recent changes we do not
> need force_ to kill the CLONE_NEWPID tasks.

ACK.

Just one note. This change makes no difference for sysrq_handle_kill().
But it obviously changes the behaviour sysrq_handle_term(). I think
this is fine, if you want to really kill the task which blocks/ignores
SIGTERM you can use sysrq_handle_kill().

Even ignoring the reasons why force_sig() is simply wrong here,
force_sig(SIGTERM) looks strange. The task won't be killed if it has
a handler, but SIG_IGN can't help. However if it has the handler
but blocks SIGTERM temporary (this is very common) it will be killed.

> And this is more correct. force_sig() can race with the exiting
> thread, while do_send_sig_info(group => true) kill the whole
> process.

Yes, except the word "race" doesn't look accurate. force_sig()
can't kill the process if the main thread has already exited.
IOW, it is trivial to create the process which can't be killed
by sysrq.

> > > @@ -324,9 +324,12 @@ static void send_sig_all(int sig)
> > >
> > >  	read_lock(&tasklist_lock);
> > >  	for_each_process(p) {
> > > -		if (p->mm && !is_global_init(p))
> > > -			/* Not swapper, init nor kernel thread */
> > > -			force_sig(sig, p);
> > > +		if (p->flags & PF_KTHREAD)
> > > +			continue;
> > > +		if (is_global_init(p))
> > > +			continue;
> > > +
> > > +		force_sig(sig, p);
> > >  	}
> > >  	read_unlock(&tasklist_lock);
> >
> > Obviously I agree with this change.
> >
> > But where does this read_lock(tasklist) come from?
>
> It came from this patch: http://lkml.org/lkml/2012/2/7/24
>
> > We discussed this with Anton. Yes, tasklist ensures that
> > force_sig() can't crash the kernel. But it is still wrong
> > and should not be used.
> >
> > I think send_sig_all() should use SEND_SIG_FORCED (this
> > depends on the patches I sent to Andrew), in this case
> > tasklist is not needed.
>
> Well, I think the lock is still a good thing: we don't want
> any new processes to be created while we kill others.

Yes, but

> I might be wrong, but copy_process() issues recalc_sigpending()
> under tasklist lock especially the for this scenario.

note that it checks recalc_sigpending() under ->siglock. This
means copy_process() can't race with do_send_sig_info() which
takes the same lock. Either the forking task should see
TIF_SIGPENDING, or send_sig_all() should see the result of
list_add_tail_rcu(&p->tasks, &init_task.tasks).

However, we can race with exec. This needs the trivial fix, but:

> Sysrq is a rare thing, so there is actually should be no problem
> with holding the lock.

OK. This looks simpler.

> So, how about this patch?
>
> Greg, can we take it via -mm tree, as it depends on a few
> sched patches?
>
>  drivers/tty/sysrq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
> index 8db9125..5ab8039 100644
> --- a/drivers/tty/sysrq.c
> +++ b/drivers/tty/sysrq.c
> @@ -329,7 +329,7 @@ static void send_sig_all(int sig)
>  		if (is_global_init(p))
>  			continue;
>
> -		force_sig(sig, p);
> +		do_send_sig_info(sig, SEND_SIG_FORCED, p, true);

Acked-by: Oleg Nesterov <oleg@redhat.com>

