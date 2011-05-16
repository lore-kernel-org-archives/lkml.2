Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1EPPxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:53:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756443Ab1EPPxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:53:46 -0400
Date: Mon, 16 May 2011 17:51:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 4/9] ptrace: relocate set_current_state(TASK_TRACED) in
	ptrace_stop()
Message-ID: <20110516155158.GA15918@redhat.com>
References: <1305301580-9924-1-git-send-email-tj@kernel.org> <1305301580-9924-5-git-send-email-tj@kernel.org> <20110516115711.GB4898@redhat.com> <20110516131608.GX23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516131608.GX23665@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> Hey, Oleg.
>
> On Mon, May 16, 2011 at 01:57:11PM +0200, Oleg Nesterov wrote:
> > > and helps future updates to group stop participation.
> >
> > OK, so I assume we need this change.
>
> We don't necessarily need it but it makes things prettier later.
>
> > But the comment looks a bit confusing to me. This is fine, I almost never
> > read them ;) Just I'd like to ensure I din't miss something.
>
> Oleg, IIRC, those comments were taken from your email pointing out
> that set_current_state() needs to happen before clearing of TRAPPING,
> so, if you're confused, I'm confused too. :-)

So, we are both confused. Great!

> > > +	 * We're committing to trapping.  TRACED should be visible before
> > > +	 * TRAPPING is cleared
> >
> > This looks as if you explain the barrier in set_current_state(). And,
> > btw, why can't we use __set_current_state() here ?
> >
> > And. not only TRACED, at least ->exit_code should be visible as well.
>
> The racy part was task_is_stopped_or_traced() in task_stopped_code()
> and the value of exit_code doesn't matter at that point.

Why exit_code doesn't matter? task_stopped_code() needs
task_is_stopped_or_traced() && exit_code != 0. Both changes should be
visible.

> So, we need
> at least smp_wmb() between __set_current_state() and clearing
> TRAPPING.

I don't think so. Please see below,

> > IOW. It is not that TRACED should be visible before jobctl &= ~JOBCTL_TRAPPING,
> > we should correctly update the tracee before __wake_up_sync_key(), and I assume
> > this is what the comment says.
> >
> > Correct?
>
> All we need to update on the tracee is tracee->state and
> ~JOBCTL_TRAPPING and __wake_up_sync_key() can be considered single
> operation.

Yes! IOW, it safe to reorder the memory operations which change ->state,
->exit_code, and ->jobctl. This only important thing is that we should not
wake up the tracer before we change them.


And if I remember correctly this was the problem, the early patches did
something like

	task_clear_jobctl_trapping();
	set_current_state(TASK_TRACED);

Oleg.

