Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2EMQMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:12:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab2EMQMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:12:32 -0400
Date: Sun, 13 May 2012 18:11:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com
Subject: Re: [PATCH v2 2/4] coredump: ensure the fpu state is flushed for
	proper multi-threaded core dump
Message-ID: <20120513161117.GA6684@redhat.com>
References: <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com> <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com> <1336692811-30576-2-git-send-email-suresh.b.siddha@intel.com> <20120511165128.GA21511@redhat.com> <1336763121.12610.13.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336763121.12610.13.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Suresh Siddha wrote:
>
> On Fri, 2012-05-11 at 18:51 +0200, Oleg Nesterov wrote:
> > On 05/10, Suresh Siddha wrote:
> > >
> > > --- a/fs/exec.c
> > > +++ b/fs/exec.c
> > > @@ -1930,8 +1930,21 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
> > >  		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
> > >  	up_write(&mm->mmap_sem);
> > >
> > > -	if (core_waiters > 0)
> > > +	if (core_waiters > 0) {
> > > +		struct core_thread *ptr;
> > > +
> > >  		wait_for_completion(&core_state->startup);
> > > +		/*
> > > +		 * Wait for all the threads to become inactive, so that
> > > +		 * all the thread context (extended register state, like
> > > +		 * fpu etc) gets copied to the memory.
> > > +		 */
> > > +		ptr = core_state->dumper.next;
> > > +		while (ptr != NULL) {
> > > +			wait_task_inactive(ptr->task, 0);
> > > +			ptr = ptr->next;
> > > +		}
> > > +	}
> >
> > OK, but this adds the unnecessary penalty if we are not going to dump
> > the core.
>
> If we are not planning to dump the core, then we will not be in the
> coredump_wait() right?

No. coredump_wait() is always called if sig_kernel_coredump(sig) == T.
Ignoring the __get_dumpable() security checks. And if RLIMIT_CORE == 0
we do not actually dump the core (unless ispipe of course).

Btw, I do not know if this is essential or not. I mean, we could probably
add the "fast path" check and simply return, the whole process will be
killed anyway by do_group_exit(), it is faster than coredump_wait().
But note that coredump_wait() kills all ->mm users (not only sub-threads),
perhaps we shouldn't/can't change this behaviour, I dunno.

And yes, do_coredump() does other unnecessary work like override_creds()
in this case, probably this needs some cleanups.

> coredump_wait() already waits for all the threads to respond (referring
> to the existing wait_for_completion() line before the proposed
> addition).

Yes,

> and in most cases, wait_task_inactive() will
> return success immediately.

I agree. Still, we add the O(n) loop which needs task_rq_lock() at least.

> And in the corner cases (where we hit the
> bug_on before) we will spin a bit now while the other thread is still on
> the rq.

Plus the possible schedule_hrtimeout().

But once again, I agree that this all is not very important.

> > Perhaps it makes sense to create a separate helper and call it from
> > do_coredump() right before "retval = binfmt->core_dump(&cprm)" ?
>
> I didn't want to spread the core dump waits at multiple places.
> coredump_wait() seems to be the natural place, as we are already waiting
> for other threads to join.

OK. We can shift this code later if needed.

In fact, perhaps we should move the whole "if (core_waiters > 0)" logic,
including wait_for_completion() to increase the parallelize. Not sure,
this will complicate the error handling.

And, perhaps, we should use wait_task_inactive(TASK_UNINTERRUPTIBLE) and
change exit_mm() to do set_task_state() before atomic_dec_and_test(), but
this is almost off-topic.


I believe the patch is correct.

Oleg.

