Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab0EDQDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:03:52 -0400
Received: from mga05.intel.com ([192.55.52.89]:25547 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932084Ab0EDQDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:03:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,327,1270450800"; 
   d="scan'208";a="795335227"
Date: Tue, 4 May 2010 09:03:46 -0700
From: mark gross <mgross@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: markgross@thegnar.org, Len Brown <len.brown@intel.com>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Magnus Damm <damm@igel.co.jp>, linux-pm@lists.linux-foundation.org,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100504160346.GA27938@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20100504051256.GC3043@thegnar.org>
 <Pine.LNX.4.44L0.1005040953510.1729-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005040953510.1729-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 09:59:59AM -0400, Alan Stern wrote:
> On Mon, 3 May 2010, mark gross wrote:
> 
> > You know things would be so much easier if the policy was a one-shot
> > styled thing.  i.e. when enabled it does what it does, but upon resume
> > the policy must be re-enabled by user mode to get the opportunistic
> > behavior.  That way we don't need to grab the suspend blocker from the
> > wake up irq handler all the way up to user mode as the example below
> > calls out.  I suppose doing this would put a burden on the user mode code
> > to keep track of if it has no pending blockers registered after a wake
> > up from the suspend.  but that seems nicer to me than sprinkling
> > overlapping blocker critical sections from the mettle up to user mode.
> > 
> > Please consider making the policy a one shot API that needs to be
> > re-enabled after resume by user mode.  That would remove my issue with
> > the design.
> 
> This won't work right if a second IRQ arrives while the first is being
> processed.  Suppose the kernel driver for the second IRQ doesn't
> activate a suspend blocker, and suppose all the userspace handlers for
> the first IRQ end (and the opportunistic policy is re-enabled) before
> the userspace handler for the second IRQ can start.  Then the system
> will go back to sleep before userspace can handle the second IRQ.
>

What?  If the suspend blocker API was a one shot styled api, after the
suspend, the one shot is over and the behavior is that you do not fall
back into suspend again until user mode re-enables the one-shot
behavior.  

With what I am proposing the next suspend would not happen until the
user mode code re-enables the suspend blocking behavior.  It would much
cleaner for everyone and I see zero down side WRT the example you just
posted.  

If user mode triggers a suspend by releasing the last blocker, you have
until pm_suspend('mem') turns off interrupts to cancel it.  That race
will never go away. 

Let me think this through, please check that I'm understanding the issue
please:
1) one-shot policy enable blocker PM suspend behavior;
2) release last blocker and call pm_suspend('mem') and suspend all the
way down.
3) get wake up event, one-shot policy over, no-blockers in list
4) go all the way to user mode, 
5) user mode decides to not grab a blocker, and re-enables one-shot
policy
6) pm_suspend('mem') called
7) interrupt comes in (say the modem rings)
8) modem driver handler needs to returns fail from pm_suspend call back,
device resumes (I am proposing changing the posted api for doing this.)
9) user mode figures out one-shot needs to be re-enabled and it grabs a
blocker to handle the call and re-enables the one-shot.

So the real problem grabbing blockers from ISR's trying to solve is to
reduce the window of time where a pm_suspend('mem') can be canceled.

My proposal is to;
1) change the kernel blocker api to be
"cancel-one-shot-policy-enable" that can be called from the ISR's for
the wake up devices before the IRQ's are disabled to cancel an in-flight
suspend.  I would make it 2 macros one goes in the pm_suspend callback
to return fail, and the other in the ISR to disable the one-shot-policy.
 
2) make the policy a one shot that user mode must re-enable after each
suspend attempted.

Would it help if I coded up the above proposal as patch to the current
(rev-6) of the blocker patchset?  I'm offering.

Because this part of the current design is broken, in that it demands
the sprinkling of blocker critical sections from the hardware up to the
user mode.  Its ugly, hard to get right and if more folks would take a
look at how well it worked out for the existing kernels on
android.git.kernel.org/kernels/ perhaps it would get more attention.

Finally, as an aside, lets look at the problem with the posted rev-6
patches:
1) enable suspend blocker policy
2) release user-mode blocker
3) start suspend
4) get a modem interrupt (incoming call)
5) ooops, IRQ came in after pm_suspend('mem') turned off interrupts.
bummer for you, thats life with this design.  Better hope your modem
hardware is modified to keep pulling on that wake up line because you're
past the point of no return now and going to suspend.

Grabbing a blocker in the ISR doesn't solve this.  So your hardware
needs to have a persistent wake up trigger that is robust against this
scenario.  And, if you have such hardware then why are we killing
ourselves to maximize the window of time between pm_suspend('mem') and
platform suspend where you can cancel the suspend?  The hardware will
simply wake up anyway.

(further, on my hardware I would modify the platform suspend call back
to make one last check to see if an IRQ came in, and cancel the suspend
there as a last chance.)

 
--mgross

