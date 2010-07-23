Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab0GWQRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:17:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61985 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab0GWQRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=un/VTffyyoIsBlVFTNjYgMnDgkxAoZqpZ/QaB8fSFxayBIzxNfg0pC8jbzvJe9fcm1
         ybkxM2tj0OysXNzVr+RkU3oSx9Kshmy9YVkYwpi1gyHb0KiYtbn554qBTupI+LFEcs3G
         g4D7HrL26UcMWyp3xCh6VDQkCW1XQrAy+5m8w=
Date: Fri, 23 Jul 2010 18:17:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: "Deng, Dongdong" <dongdong.deng@windriver.com>, will.deacon@arm.com,
        lethal@linux-sh.org, mahesh@linux.vnet.ibm.com,
        prasad@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
        mingo@elte.hu, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] hw-breakpoints, kgdb, x86: add a flag
	topassDIE_DEBUG notification
Message-ID: <20100723161746.GD5255@nowhere>
References: <1279851361-32604-1-git-send-email-dongdong.deng@windriver.com> <20100723130430.GA5255@nowhere> <4C4996FA.2010301@windriver.com> <20100723140745.GB5255@nowhere> <4C49BA00.5030200@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C49BA00.5030200@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 10:49:20AM -0500, Jason Wessel wrote:
> On 07/23/2010 09:07 AM, Frederic Weisbecker wrote:
> > On Fri, Jul 23, 2010 at 08:19:54AM -0500, Jason Wessel wrote:
> >   
> >> On 07/23/2010 08:04 AM, Frederic Weisbecker wrote:
> >>     
> >> The patch may or may not be the right way to solve the problem.   It is
> >> worth noting that early breakpoints are handled separately with a direct
> >> writes to the debug registers so this API does not apply.
> >>     
> >
> >
> >
> > But you still need to handle them on the debug exception, right?
> >
> >
> >   
> 
> Yes, but at that point kgdb is first in line for the notifier so it
> works out of the box.


Ok.


 
> > Right.
> >
> > Actually NOTIFY_DONE is returned when there is more work to do: handling
> > another exception than breakpoint, or sending a signal. Otherwise yeah,
> > we return NOTIFY_STOP as we assume there is more work to do.
> >
> >   
> 
> For this specific case the hw_breakpoint handler simply consumed a
> breakpoint which was not intended for it.



Ah right.

But that thing is right:

		/*
		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
		 * exception handling
		 */
		(*dr6_p) &= ~(DR_TRAP0 << i);
		/*
		 * bp can be NULL due to lazy debug register switching
		 * or due to concurrent perf counter removing.
		 */
		if (!bp) {
			rcu_read_unlock();
			break;
		}


We need to prevent from dr7 lazy switches. It means kgdb must first check
its own breakpoints.

 
> > So the following alternatives appear to me:
> >
> > - Moving the breakpoint exception handling into the
> >   struct perf_event:overflow_handler. In fact I can't find the breakpoint
> >   handling in kgdb.c
> >
> >   
> 
> It is in the generic die notification handler for kgdb (looking at
> 2.6.35-rc6)
> 
> arch/x86/kernel/kgdb.c
> 
>     516 static int __kgdb_notify(struct die_args *args, unsigned long cmd)
> ...
>     551         case DIE_DEBUG:
>     552                 if (atomic_read(&kgdb_cpu_doing_single_step) !=
> -1) {
>     553                         if (user_mode(regs))
>     554                                 return single_step_cont(regs, args);
>     555                         break;
>     556                 } else if (test_thread_flag(TIF_SINGLESTEP))
>     557                         /* This means a user thread is single
> stepping
>     558                          * a system call which should be ignored
>     559                          */
>     560                         return NOTIFY_DONE;
>     561                 /* fall through */



But I can't find where the breakpoints are handled there.



> 
> > - Have a higher priority in kgdb notifier (which means decreasing the one
> >   of hw_breakpoint.c)
> >   
> 
> kgdb had always been last in line in arch/x86/kernel/kgdb.c:
> 
>     608 static struct notifier_block kgdb_notifier = {
>     609         .notifier_call  = kgdb_notify,
>     610
>     611         /*
>     612          * Lowest-prio notifier priority, we want to be notified
> last:
>     613          */
>     614         .priority       = -INT_MAX,
>     615 };



Why? It seems to me a kernel debugger should have the highest priority
over anything.



> 
> > - Always returning NOTIFY_DONE from the breakpoint path.
> >
> >   
> 
> Without some further investigation, I am not sure what this will do.



Nothing, this NOTIFY_STOP is only an optimization. But now I think that
won't solve the problem. We still clear a dr6 trap bit for a debug
exception due to lazy dr7 switches we have to handle.

This is why kgdb should have the highest priority, or use the overflow
callback.



> We
> don't want to make things worse of course.  Because kgdb uses the
> request hw_breakpoint api to request slot reservation having an
> attribute to say don't do anything to this HW breakpoint is certainly
> one way to fix it.
>
> > Is this a regression BTW?
> >
> >   
> 
> Absolutely this is a regression.  No change was made in kgdb related to
> this and the kgdb HW breakpoint regression tests (which come with the
> kernel) stopped working and bisect to the commit I mentioned.


Yep, this new breakpoint layer has been a PITA for kgdb :)

