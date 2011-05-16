Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab1EPQgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:36:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab1EPQgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:36:15 -0400
Date: Mon, 16 May 2011 18:34:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 4/9] ptrace: relocate set_current_state(TASK_TRACED) in
	ptrace_stop()
Message-ID: <20110516163454.GA17928@redhat.com>
References: <1305301580-9924-1-git-send-email-tj@kernel.org> <1305301580-9924-5-git-send-email-tj@kernel.org> <20110516115711.GB4898@redhat.com> <20110516131608.GX23665@htj.dyndns.org> <20110516155158.GA15918@redhat.com> <20110516155935.GB20624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516155935.GB20624@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> Hello,
>
> On Mon, May 16, 2011 at 05:51:58PM +0200, Oleg Nesterov wrote:
> > > The racy part was task_is_stopped_or_traced() in task_stopped_code()
> > > and the value of exit_code doesn't matter at that point.
> >
> > Why exit_code doesn't matter? task_stopped_code() needs
> > task_is_stopped_or_traced() && exit_code != 0. Both changes should be
> > visible.
>
> Because the actual exit_code is checked only after grabbing siglock.

OK, this is true after the next 8/9 patch.

> As long as task_is_stopped_or_traced() is true, ptracer will grab
> siglock

Hmm. No? task_is_stopped_or_traced() is also checked under ->siglock?

Confused.

> > > All we need to update on the tracee is tracee->state and
> > > ~JOBCTL_TRAPPING and __wake_up_sync_key() can be considered single
> > > operation.
> >
> > Yes! IOW, it safe to reorder the memory operations which change ->state,
> > ->exit_code, and ->jobctl. This only important thing is that we should not
> > wake up the tracer before we change them.
> >
> > And if I remember correctly this was the problem, the early patches did
> > something like
> >
> > 	task_clear_jobctl_trapping();
> > 	set_current_state(TASK_TRACED);
>
> Right, try_to_wake_up() already contains smp_wmb().

Well, I do not think try_to_wake_up()->smp_wmb() is needed in this case,
wait_queue_head_t->lock helps. This wmb() is needed to ensure we do not
change (or even read) task->state before the preceding LOAD's completes.
It is not needed for wait_event-like code.

> We'll be fine
> with __set_current_state().  Can we do it in a later patch?

Sure, this is minor and needs a separate patch anyway.

Oleg.

