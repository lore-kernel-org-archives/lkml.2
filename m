Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab1CNAvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 20:51:01 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35081 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab1CNAvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 20:51:00 -0400
Date: Sun, 13 Mar 2011 17:50:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "loic.minier@linaro.org" <loic.minier@linaro.org>,
        "dhaval.giani@gmail.com" <dhaval.giani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "houston.jim@comcast.net" <houston.jim@comcast.net>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: Re: JRCU Theory of Operation
Message-ID: <20110314005052.GE2167@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110309221517.GB24670@tsunami.ccur.com>
 <20110310003419.GE2196@linux.vnet.ibm.com>
 <20110310195045.GA22146@tsunami.ccur.com>
 <20110312143629.GT2234@linux.vnet.ibm.com>
 <20110313004336.GA14518@tsunami.ccur.com>
 <20110313055627.GW2234@linux.vnet.ibm.com>
 <20110313235351.GA15931@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110313235351.GA15931@tsunami.ccur.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 07:53:51PM -0400, Joe Korty wrote:
> On Sun, Mar 13, 2011 at 12:56:27AM -0500, Paul E. McKenney wrote:
> > > Even though I keep saying 50msecs for everything, I
> > > suspect that the Q switching meets all the above quiescent
> > > requirements in a few tens of microseconds.  Thus even
> > > a 1 msec JRCU sampling period is expected to be safe,
> > > at least in regard to Q switching.
> > 
> > I would feel better about this is the CPU vendors were willing to give
> > an upper bound...
> 
> I suspect they don't because they don't really know
> themselves .. in that whatever it is, it keeps changing
> from chip to chip, trying to describe such would be beyond
> the english language, and any description would tie them
> down on what they could do in future chip designs.

Indeed!

> But, there is a hint in current behavior.  It is well known
> that many multithreaded apps don't uses barriers at all;
> the authors had no idea what they are for.  Yet such apps
> largely work.  This implies that the chip designers are
> very aggressive in doing implied memory barriers wherever
> possible, and they are very aggressive in pushing out
> stores to caches very quickly even when memory barriers,
> implied or not, are not present.

Ahem.  Or that many barrier-omission failures have a low probability
of occurring.  One case in point is a bug in RCU a few years back,
where ten-hour rcutorture runs produced only a handful of errors (see
http://paulmck.livejournal.com/14639.html).  Other cases are turned up by
Peter Sewell's work, which tests code sequences with and without memory
barriers (http://www.cl.cam.ac.uk/~pes20/).  In many cases, broken code
sequences have failure rates in the parts per billion.

This should not be a surprise.  You can see the same effect with locking.
If you have very contention on a given lock, then there will be a very
low probability of encountering bugs involving forgetting to acquire
that lock.

If the CPU count continues increasing, these sorts of latent bugs
will have increasing probabilities of biting us.

						Thanx, Paul
