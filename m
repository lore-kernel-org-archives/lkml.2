Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab0LWQON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 11:14:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab0LWQOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 11:14:11 -0500
Date: Thu, 23 Dec 2010 17:06:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 09/16] ptrace: make do_signal_stop() use ptrace_stop()
	if the task is being ptraced
Message-ID: <20101223160648.GA10096@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-10-git-send-email-tj@kernel.org> <20101223122634.GA365@redhat.com> <20101223135330.GA18482@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223135330.GA18482@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Tejun Heo wrote:
>
> > 	int main(void)
> > 	{
> > 		int child, status;
> >
> > 		child = fork();
> > 		if (!child) {
> > 			ptrace(PTRACE_TRACEME);
> >
> > 			kill(getpid(), SIGSTOP);
> >
> > 			return 0;
> > 		}
> >
> > 		wait(&status)
> > 		// the tracee reports the signal
> > 		assert(WIFSTOPPED() && WSTOPSIG() == SIGSTOP);
> > 		// it should stop after that
> > 		ptrace(PTRACE_CONT, child, SIGSTOP);
> >
> > 		wait(&status);
> > 		// now it is stopped
> > 		assert(WIFSTOPPED() && WSTOPSIG() == SIGSTOP);
> >
> > 		kill(child, SIGCONT);
> >
> > 		wait(&status);
> > 		assert(WIFSTOPPED() && WSTOPSIG() == SIGCONT);
> >
> > This won't work with this patch. the last do_wait() will hang forever.
> > Probably this is fine, I do not know. Please take a look and ack/nack
> > explicitly.
>
> Yes, before the change, the task would respond to SIGCONT before the
> first ptrace request succeeds after attach.

Not exactly. But perhaps you meant that even without this change,
any ptrace() request after ptrace(PTRACE_CONT, SIGSTOP) will change
child->state = TASK_TRACED, and kill(SIGCONT) won't work after that.

> To me, this doesn't seem
> to be anything intentional tho.  It seems a lot of ptrace and group
> stop interactions is in the grey area with only the current (quirky,
> I'm afraid) behavior drawing almost arbitrary lines across different
> behaviors.

Agreed.

However. Strangely, I didn't think about this before. With this
change, it is not possible to trace/debug the application so that
it can properly react to SIGCONT. Yes, currently we have a lot
more problems here, including do_wait, so probably this doesn't
matter.

Still I'd like to know what Jan and Roland think. I am paranoid,
yes ;)

> Anyways, pondering and verifying all the possibly visible changes
> definitely is necessary, but that said, we fortunately have rather
> limited number of ptrace users and their usages don't seem to be too
> wild (at least on my cursory investigation), so I think it to be
> doable without breaking anything noticeably.  But yeap we definitely
> need to be careful.

Yes, at least I think it makes sense to document this change in the
changelog. This can simplify the life if we have a bug report blaiming
this patch.

> And, for longer term, I think it would be a good idea to separate
> group stop and ptrace trap mechanisms, so that ptrace trap works
> properly on per-task level and properly transparent from group stop
> handling.  The intertwining between the two across different domains
> of threads inhfferently involves a lot of grey areas where there is no
> good intuitive behavior.

Agreed.

> Not really sure why
> skipping it didn't cause any problem until now tho.

Yes, that was my question.

Oleg.

