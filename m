Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab0DEPON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:14:13 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60976 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab0DEPOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:14:06 -0400
Date: Mon, 5 Apr 2010 08:14:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100405151401.GA2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100403223328.GA4507@comet.dominikbrodowski.net>
 <Pine.LNX.4.44L0.1004041110010.2750-100000@netrider.rowland.org>
 <20100404163924.GA18428@comet.dominikbrodowski.net>
 <20100404204725.GC2644@linux.vnet.ibm.com>
 <20100404233702.GA24102@linux.vnet.ibm.com>
 <4BB95C85.80205@linux.intel.com>
 <20100405042222.GD2644@linux.vnet.ibm.com>
 <4BB9F657.4050901@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB9F657.4050901@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 07:40:23AM -0700, Arjan van de Ven wrote:
> On 4/4/2010 21:22, Paul E. McKenney wrote:
> >On Sun, Apr 04, 2010 at 08:44:05PM -0700, Arjan van de Ven wrote:
> >>>And you did mention offlining some CPUs above.  The folloiwng patch
> >>>(from Lai Jiangshan) is needed to handle this case.
> >>
> >>btw on x86... don't offline CPUs if you want to save power.. it doesn't.
> >>(at least not during idle.. and when you're busy it might save power,
> >>but it won't save you energy normally)
> >
> >Hmmm...  The fact that offlining CPUs doesn't save power could form
> >the basis of an interesting rationalization for my having ignored
> >offlined CPUs in my original patch, I suppose.  ;-)
> >
> >So the proper approach is to affinity everything away from the CPUs
> >in question so that they stay in dyntick-idle mode?
> 
> that is actually equivalently bad ;)
> 
> > I must confess
> >that I find this quite counter-intuitive -- and I suspect that I am
> >not the only one who would expect offlined CPUs to drop to the
> >lowest possible power consumption.
> 
> on x86 (other archs might be different), nowadays idle is VERY efficient.
> (and the way to offline a cpu is to put it into the same deep C state as idle would)
> 
> the "offline is same power as idle" is only the part where you don't win energy.
> the part where you lose energy is the part where you realize that you can only really put
> the memory controller and memory in power saving state if all cpus are in idle.
> If you offline a cpu (versus leaving it idle), and you have several tasks to run during an
> activity burst (which are more common the more we group activity to save power), it can happen
> that there are so many things to do that all remaining cpus can't handle it without the scheduler
> delaying some tasks. At which point you delay putting the memory (controllers) in low power state
> and you lose. In general, the winning strategy seems to be to finish things as quickly as you can,
> eg on as many cpus as you have in the system to then let them all go idle.
> 
> (this is not always true if you're picking cpu frequency/voltages, but for idle states it tends
> to be true. there's always cases where it isn't.... power is like that)

So the main issue is that for many workloads, it is best to run full bore
and get done quickly, thus allowing the entire machine to be powered down?

If so, it seems likely that there would be some workloads that were sometimes
unable to use all the CPUs, in which case shutting down (idling, offlining,
dyntick-idling, whatever) the excess CPUs might nevertheless be the right
thing to do.

Or am I missing your point?

							Thanx, Paul
