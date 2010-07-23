Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab0GWOHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:07:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53569 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0GWOHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:07:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x+wCS+gzIzHjnOg4K2zXs1fLIZKX+t2FxBgi3GOvHIAUG3fD1OFAaEmt81LBsxgbja
         RhVO5Bo1sr70srM7DFNaP4prEVFvuSUGM084vBY+cFUFBBcgJ93kD6h8jxR3o5gHwGMz
         T6X4rcN8ZGbjEskENtdouVrwfOfL6PRGX5N4Y=
Date: Fri, 23 Jul 2010 16:07:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: "Deng, Dongdong" <dongdong.deng@windriver.com>, will.deacon@arm.com,
        lethal@linux-sh.org, mahesh@linux.vnet.ibm.com,
        prasad@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
        mingo@elte.hu, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] hw-breakpoints, kgdb, x86: add a flag to
	passDIE_DEBUG notification
Message-ID: <20100723140745.GB5255@nowhere>
References: <1279851361-32604-1-git-send-email-dongdong.deng@windriver.com> <20100723130430.GA5255@nowhere> <4C4996FA.2010301@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4996FA.2010301@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 08:19:54AM -0500, Jason Wessel wrote:
> On 07/23/2010 08:04 AM, Frederic Weisbecker wrote:
> > On Fri, Jul 23, 2010 at 10:16:01AM +0800, Dongdong Deng wrote:
> >   
> >> The hw_breakpoint subsystem consumes all the hardware
> >> breakpoint exceptions since it hooks the notify_die
> >> handlers first, this means that kgdb doesn't get the
> >> opportunity to handle hw breakpoint exceptions generated
> >> by kgdb itself.
> >>
> >> This patch adds an extend flag to perf_event_attr for
> >> hw_breakpoint_handler() to decide to pass or stop the
> >> DIE_DEBUG notification.
> >>
> >> As KGDB set that flag, hw_breakpoint_handler() will pass
> >> the DIE_DEBUG notification, thus kgdb have the chance
> >> to take DIE_DEBUG notification.
> >>
> >> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
> >> Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
> >> ---
> >>  arch/x86/kernel/hw_breakpoint.c |   14 ++++++++++++++
> >>  arch/x86/kernel/kgdb.c          |    2 ++
> >>  include/linux/perf_event.h      |    9 +++++++++
> >>  3 files changed, 25 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> >> index a8f1b80..b38f786 100644
> >> --- a/arch/x86/kernel/hw_breakpoint.c
> >> +++ b/arch/x86/kernel/hw_breakpoint.c
> >> @@ -406,6 +406,8 @@ EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
> >>   * ii) When there are more bits than trap<n> set in DR6 register (such
> >>   * as BD, BS or BT) indicating that more than one debug condition is
> >>   * met and requires some more action in do_debug().
> >> + * iii) The source of hw breakpoint event want to handle the event
> >> + * by itself, currently just KGDB have this notion.
> >>   *
> >>   * NOTIFY_STOP returned for all other cases
> >>   *
> >> @@ -464,6 +466,18 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
> >>  			break;
> >>  		}
> >>  
> >> +		if (bp->attr.flag == SKIP_HWBP_EVENT_PERF_FLAG) {
> >> +			/*
> >> +			 * when attr.flag is set to SKIP_HWBP_EVENT_PERF_FLAG
> >> +			 * it indicates currently hw breakpoint event
> >> +			 * source want to handle this event by itself.
> >> +			 * thus return NOTIFY_DONE here.
> >> +			 */
> >> +			rc = NOTIFY_DONE;
> >> +			rcu_read_unlock();
> >> +			break;
> >> +		}
> >> +
> >>     
> >
> >
> >
> > No. We really shouldn't make a user ABI change (adding attr.flag) just
> > to solve an in-kernel-only problem.
> >
> > And moreover we probably don't need flags at all. Why not just turning kgdb handler
> > into a higher priority?
> >
> > I don't even remember why kgdb has its own handler instead of using the
> > struct perf_event:overflow_handler. May be that's because of the early breakpoints.
> >
> >   
> 
> 
> The patch may or may not be the right way to solve the problem.   It is
> worth noting that early breakpoints are handled separately with a direct
> writes to the debug registers so this API does not apply.



But you still need to handle them on the debug exception, right?


 
> This patch effectively causes the events to get passed to the normal
> handlers.
> 
> The source of the original problem (which was merged in 2.6.35) is
> commit: 018cbffe6819f6f8db20a0a3acd9bab9bfd667e4 -     Merge commit
> 'v2.6.33' into perf/core
> 
> Specifically this line right here:
> @@@ -502,6 -486,8 +486,6 @@@ static int __kprobes hw_breakpoint_hand
>           rcu_read_lock();
>  
>           bp = per_cpu(bp_per_reg[i], cpu);
>  -        if (bp)
>  -            rc = NOTIFY_DONE;
> 
> Because the NOTIFY_DONE is never set, a default value of NOTIFY_STOP is
> passed at the end and kgdb never gets to see the break point even that
> was never intended for the perf handler in the first place.
> 
> It is not as easy of course to just revert this patch because it changed
> other logic.
> 
> Jason.



Right.

Actually NOTIFY_DONE is returned when there is more work to do: handling
another exception than breakpoint, or sending a signal. Otherwise yeah,
we return NOTIFY_STOP as we assume there is more work to do.

So the following alternatives appear to me:

- Moving the breakpoint exception handling into the
  struct perf_event:overflow_handler. In fact I can't find the breakpoint
  handling in kgdb.c

- Have a higher priority in kgdb notifier (which means decreasing the one
  of hw_breakpoint.c)

- Always returning NOTIFY_DONE from the breakpoint path.


Is this a regression BTW?

