Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1EESvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:51:54 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42523 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab1EESvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:51:53 -0400
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
From: john stultz <johnstul@us.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110505081432.GD2641@linux.vnet.ibm.com>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	 <m2oc3jxgtt.fsf@firstfloor.org> <1304564090.2943.36.camel@work-vm>
	 <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
	 <20110505081432.GD2641@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 11:51:16 -0700
Message-ID: <1304621476.20980.2.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 01:14 -0700, Paul E. McKenney wrote:
> On Wed, May 04, 2011 at 11:21:35PM -0700, john stultz wrote:
> > On Thu, 2011-05-05 at 07:44 +0200, Eric Dumazet wrote:
> > > Le mercredi 04 mai 2011 à 19:54 -0700, john stultz a écrit :
> > > > On Tue, 2011-05-03 at 20:52 -0700, Andi Kleen wrote:
> > > > > John Stultz <john.stultz@linaro.org> writes:
> > > > > 
> > > > > > From: John Stultz <johnstul@us.ibm.com>
> > > > > >
> > > > > > So get_seconds() has always been lock free, with the assumption
> > > > > > that accessing a long will be atomic.
> > > > > >
> > > > > > However, recently I came across an odd bug where time() access could
> > > > > > occasionally be inconsistent, but only on power7 hardware. The
> > > > > 
> > > > > Shouldn't a single rmb() be enough to avoid that?
> > > > > 
> > > > > If not then I suspect there's a lot more code buggy on that CPU than
> > > > > just the time.
> > > > 
> > > > So interestingly, I've found that the issue was not as complex as I
> > > > first assumed.  While the rmb() is probably a good idea for
> > > > get_seconds(), but it alone does not solve the issue I was seeing,
> > > > making it clear my theory wasn't correct.
> > > > 
> > > > The problem was reported against the 2.6.32-stable kernel, and had not
> > > > been seen in later kernels. I had assumed the change to logarithmic time
> > > > accumulation basically reduced the window for for the issue to be seen,
> > > > but it would likely still show up eventually.
> > > > 
> > > > When the rmb() alone did not solve this issue, I looked to see why the
> > > > locking did resolve it, and then it was clear: The old
> > > > update_xtime_cache() function doesn't set the xtime_cache values
> > > > atomically.
> > > > 
> > > > Now, the xtime_cache writing is done under the xtime_lock, so the
> > > > get_seconds() locking resolves the issue, but isn't appropriate since
> > > > get_seconds() is called from machine check handlers.
> > > > 
> > > > So the fix here for the 2.6.32-stable tree is to just update xtime_cache
> > > > in one go as done with the following patch.
> > > > 
> > > > I also added the rmb() for good measure, and the rmb() should probably
> > > > also go upstream since theoretically there maybe a platform that could
> > > > do out of order syscalls.
> > > > 
> > > > I suspect the reason this hasn't been triggered on x86 or power6 is due
> > > > to compiler or processor optimizations reordering the assignment to in
> > > > effect make it atomic. Or maybe the timing window to see the issue is
> > > > harder to observe?
> > > > 
> > > > 
> > > > Signed-off-by: John Stultz <johnstul@us.ibm.com>
> > > > 
> > > > Index: linux-2.6.32.y/kernel/time/timekeeping.c
> > > > ===================================================================
> > > > --- linux-2.6.32.y.orig/kernel/time/timekeeping.c	2011-05-04 19:34:21.604314152 -0700
> > > > +++ linux-2.6.32.y/kernel/time/timekeeping.c	2011-05-04 19:39:09.972203989 -0700
> > > > @@ -168,8 +168,10 @@ int __read_mostly timekeeping_suspended;
> > > >  static struct timespec xtime_cache __attribute__ ((aligned (16)));
> > > >  void update_xtime_cache(u64 nsec)
> > > >  {
> > > > -	xtime_cache = xtime;
> > > > -	timespec_add_ns(&xtime_cache, nsec);
> > > > +	/* use temporary timespec so xtime_cache is updated atomically */
> > > 
> > > Atomically is not possible on 32bit platform, so this comment is
> > > misleading.
> > 
> > Well, 32bit/64bit, the time_t .tv_sec portion is a long, so it should be
> > written atomically. 
> > 
> > > What about a comment saying :
> > > 	/*
> > > 	 * use temporary variable so get_seconds() cannot catch
> > > 	 * intermediate value (one second backward)
> > > 	 */
> > 
> > Fair enough. Such a comment is an improvement.
> > 
> > > > +	struct timespec ts = xtime;
> > > > +	timespec_add_ns(&ts, nsec);
> > > > +	xtime_cache = ts;
> > > >  }
> > > >  
> > > >  /* must hold xtime_lock */
> > > > @@ -859,6 +861,7 @@ EXPORT_SYMBOL_GPL(monotonic_to_bootbased
> > > >  
> > > >  unsigned long get_seconds(void)
> > > >  {
> > > > +	rmb();
> > > 
> > > Please dont, this makes no sense, and with no comment anyway.
> > 
> > Would a comment to the effect of "ensure processors don't re-order calls
> > to get_seconds" help, or is it still too opaque (or even still
> > nonsense?).
> 
> A CPU that reordered syscalls reading from or writing to a given memory
> location is broken.  At least if the CPU does such reordering in a way
> that lets the software detect it.  There is quite a bit of code out there
> that assumes cache coherence, so I sure hope that CPUs don't require
> the above memory barrier...

Much appreciated. I'll drop it then.

thanks
-john


