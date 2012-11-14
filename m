Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2KNAGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:06:39 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47560 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab2KNAGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:06:38 -0500
Date: Tue, 13 Nov 2012 16:03:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20121114000259.GK2489@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com>
 <20121113211602.GA30150@linux.vnet.ibm.com>
 <20121113133922.47144a50@chromoly>
 <20121113222350.GH2489@linux.vnet.ibm.com>
 <50A2CD77.7000403@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A2CD77.7000403@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111400-5112-0000-0000-00000E87BE4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 02:45:11PM -0800, Arjan van de Ven wrote:
> On 11/13/2012 2:23 PM, Paul E. McKenney wrote:
> > On Tue, Nov 13, 2012 at 01:39:22PM -0800, Jacob Pan wrote:
> >> On Tue, 13 Nov 2012 13:16:02 -0800
> >> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >>
> >>>> Please refer to Documentation/thermal/intel_powerclamp.txt for more
> >>>> details.  
> >>>
> >>> If I read this correctly, this forces a group of CPUs into idle for
> >>> about 600 milliseconds at a time.  This would indeed delay grace
> >>> periods, which could easily result in user complaints.  Also, given
> >>> the default RCU_BOOST_DELAY of 500 milliseconds in kernels enabling
> >>> RCU_BOOST, you would see needless RCU priority boosting.
> >>>
> >> the default idle injection duration is 6ms. we adjust the sleep
> >> interval to ensure idle ratio. So the idle duration stays the same once
> >> set. So would it be safe to delay grace period for this small amount in
> >> exchange for less over head in each injection period?
> > 
> > Ah, 6ms of delay is much better than 600ms.  Should be OK (famous last
> > words!).
> 
> well... power clamping is not "free".
> You're going to lose performance as a trade off for dropping instantaneous power consumption....
> in the measurements we've done comparing various methods.. this one is doing remarkably well.

No argument here.  My concern is not performance in this situation, but
rather in-kernel confusion, particularly any such confusion involving RCU.

And understood, you can get similar effects from virtualization.
For all I know, the virtualization guys might leverage your experience
with power clamping to push for gang scheduling once more.  ;-)

> > For most kernel configuration options, it does use softirq.  And yes,
> > the kthread you are using would yield to softirqs -- but only as long
> > as softirq processing hasn't moved over to ksoftirqd.  Longer term,
> > RCU will be moving from softirq to kthreads, though, and these might be
> > prempted by your powerclamp kthread, depending on priorities.  It looks
> > like you use RT prio 50, which would usually preempt the RCU kthreads
> > (unless someone changed the priorities).
> 
> we tried to pick a "middle of the road" value, so that usages that really really
> want to run, still get to run, but things that are more loose about it, get put on hold.

Makes sense.

> >>> It looks like you could end up with part of the system powerclamped
> >>> in some situations, and with all of it powerclamped in other
> >>> situations. Is that the case, or am I confused?
> >>>
> >> could you explain the part that is partially powerclamped?
> > 
> > Suppose that a given system has two sockets.  Are the two sockets
> > powerclamped independently, or at the same time?  My guess was the
> > former, but looking at the code again, it looks like the latter.
> > So it is a good thing I asked, I guess.  ;-)
> 
> they are clamped together, and they have to.
> you don't get (on the systems where this driver works) any "package" C state unless
> all packages are idle completely.
> And it's these package C states where the real deep power savings happen, that's
> why they are such a juicy target for power clamping ;-)

OK, so the point of clamping all sockets simultaneously is to be able
to power down the electronics surrounding the sockets as well as the
sockets themselves?  If all you cared about was the individual sockets,
I don't see why you couldn't power the sockets down individually rather
than in sync with each other.

Just to make sure I am really understanding what is happening, let's
suppose we have a HZ=1000 system that has a few tasks that occasionally
run at prio 99.  These tasks would run during the clamp interval,
but would (for example) see the jiffies counter remaining at the
value at the beginning of the clamp interval until the end of that
interval, when the jiffies counter would suddenly jump by roughly
six counts, right?

If so, this could cause some (minor) RCU issues, such as RCU
deciding to force quiescent states right at the end of a clamping
interval, even though none of the RCU readers would have had a
chance to do anything in the meantime.  Shouldn't result in a
bug though, just wasted motion.

I think I know, but I feel the need to ask anyway.  Why not tell
RCU about the clamping?

							Thanx, Paul

