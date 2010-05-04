Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab0EDRQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:16:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44837 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932330Ab0EDRQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:16:30 -0400
Date: Tue, 4 May 2010 13:16:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: mark gross <mgross@linux.intel.com>
cc: markgross@thegnar.org, Len Brown <len.brown@intel.com>,
       <linux-doc@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
In-Reply-To: <20100504160346.GA27938@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1005041252480.1729-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010, mark gross wrote:

> On Tue, May 04, 2010 at 09:59:59AM -0400, Alan Stern wrote:
> > On Mon, 3 May 2010, mark gross wrote:
> > 
> > > You know things would be so much easier if the policy was a one-shot
> > > styled thing.  i.e. when enabled it does what it does, but upon resume
> > > the policy must be re-enabled by user mode to get the opportunistic
> > > behavior.  That way we don't need to grab the suspend blocker from the
> > > wake up irq handler all the way up to user mode as the example below
> > > calls out.  I suppose doing this would put a burden on the user mode code
> > > to keep track of if it has no pending blockers registered after a wake
> > > up from the suspend.  but that seems nicer to me than sprinkling
> > > overlapping blocker critical sections from the mettle up to user mode.
> > > 
> > > Please consider making the policy a one shot API that needs to be
> > > re-enabled after resume by user mode.  That would remove my issue with
> > > the design.
> > 
> > This won't work right if a second IRQ arrives while the first is being
> > processed.  Suppose the kernel driver for the second IRQ doesn't
> > activate a suspend blocker, and suppose all the userspace handlers for
> > the first IRQ end (and the opportunistic policy is re-enabled) before
> > the userspace handler for the second IRQ can start.  Then the system
> > will go back to sleep before userspace can handle the second IRQ.
> >
> 
> What?  If the suspend blocker API was a one shot styled api, after the
> suspend, the one shot is over and the behavior is that you do not fall
> back into suspend again until user mode re-enables the one-shot
> behavior.  

I was referring to your sentence: "That way we don't need to grab the 
suspend blocker from the wake up irq handler all the way up to user 
mode..."  The problem arises when kernel handlers don't do _something_ 
to prevent another suspend from occurring too soon.

> With what I am proposing the next suspend would not happen until the
> user mode code re-enables the suspend blocking behavior.  It would much
> cleaner for everyone and I see zero down side WRT the example you just
> posted.  
> 
> If user mode triggers a suspend by releasing the last blocker, you have
> until pm_suspend('mem') turns off interrupts to cancel it.  That race
> will never go away. 

(Actually the kernel can cancel the suspend even after interrupts are
turned off, if it has a reason to do so.)

In theory the race between interrupts and suspend don't need to be a
problem.  In practice it still is -- the PM core needs a few changes to
allow wakeup interrupts to cancel a suspend in progress.  Regardless, 
that's not what I was talking about.

> Let me think this through, please check that I'm understanding the issue
> please:
> 1) one-shot policy enable blocker PM suspend behavior;
> 2) release last blocker and call pm_suspend('mem') and suspend all the
> way down.
> 3) get wake up event, one-shot policy over, no-blockers in list
> 4) go all the way to user mode, 
> 5) user mode decides to not grab a blocker, and re-enables one-shot
> policy
> 6) pm_suspend('mem') called
> 7) interrupt comes in (say the modem rings)
> 8) modem driver handler needs to returns fail from pm_suspend call back,
> device resumes (I am proposing changing the posted api for doing this.)
> 9) user mode figures out one-shot needs to be re-enabled and it grabs a
> blocker to handle the call and re-enables the one-shot.

This is not the scenario I was describing.  Here's what I had in mind:

1) The system is asleep
2) Wakeup event occurs, one-shot policy over
3) Go all the way to user mode
4) A second wakeup interrupt occurs (say the modem rings)
5) The modem driver does not enable any suspend blockers
6) The modem driver queues an input event for userspace
7) The userspace handler invoked during 3) finishes and re-enables
	the one-shot policy
8) No suspend blockers are enabled, so the system goes to sleep
9) The userspace handler for the input event in 6) doesn't get to run

> So the real problem grabbing blockers from ISR's trying to solve is to
> reduce the window of time where a pm_suspend('mem') can be canceled.

No.  The real problem is how ISRs should prevent the system from
suspending before the events they generate can be handled by userspace.

> My proposal is to;
> 1) change the kernel blocker api to be
> "cancel-one-shot-policy-enable" that can be called from the ISR's for
> the wake up devices before the IRQ's are disabled to cancel an in-flight
> suspend.  I would make it 2 macros one goes in the pm_suspend callback
> to return fail, and the other in the ISR to disable the one-shot-policy.
>  
> 2) make the policy a one shot that user mode must re-enable after each
> suspend attempted.

Neither of these solves the race I described.

> Would it help if I coded up the above proposal as patch to the current
> (rev-6) of the blocker patchset?  I'm offering.
> 
> Because this part of the current design is broken, in that it demands
> the sprinkling of blocker critical sections from the hardware up to the
> user mode.  Its ugly, hard to get right and if more folks would take a
> look at how well it worked out for the existing kernels on
> android.git.kernel.org/kernels/ perhaps it would get more attention.

I agree, it is ugly and probably hard to get right.  But something like 
it is necessary to solve this race.

> Finally, as an aside, lets look at the problem with the posted rev-6
> patches:
> 1) enable suspend blocker policy
> 2) release user-mode blocker
> 3) start suspend
> 4) get a modem interrupt (incoming call)
> 5) ooops, IRQ came in after pm_suspend('mem') turned off interrupts.
> bummer for you, thats life with this design.  Better hope your modem
> hardware is modified to keep pulling on that wake up line because you're
> past the point of no return now and going to suspend.

That is not a problem for level-sensitive IRQs.  If interrupts have
been turned off then the modem will not receive any commands telling
it to stop requesting an interrupt.  So the IRQ line will remain active 
until the system goes to sleep, at which point it will immediately 
wake up the system.

For edge-sensitive interrupts the situation isn't as simple.  The
low-level IRQ code must handle this somehow.

> Grabbing a blocker in the ISR doesn't solve this.  So your hardware
> needs to have a persistent wake up trigger that is robust against this
> scenario.  And, if you have such hardware then why are we killing
> ourselves to maximize the window of time between pm_suspend('mem') and
> platform suspend where you can cancel the suspend?  The hardware will
> simply wake up anyway.

That's not what we are killing ourselves for.  The point of suspend
blockers is not to prevent races with the hardware.  It is to prevent 
userspace from being frozen while there's still work to be done.

Alan Stern

