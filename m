Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab1CXAXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:23:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33413 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406Ab1CXAXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:23:46 -0400
Date: Wed, 23 Mar 2011 17:23:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "loic.minier@linaro.org" <loic.minier@linaro.org>,
        "dhaval.giani@gmail.com" <dhaval.giani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "houston.jim@comcast.net" <houston.jim@comcast.net>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] jrcu: fix broken rcu_barrier
Message-ID: <20110324002340.GE2322@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110314035044.GA12990@tsunami.ccur.com>
 <20110314084718.GH2167@linux.vnet.ibm.com>
 <20110314220928.GA1348@tsunami.ccur.com>
 <20110323063524.GS2322@linux.vnet.ibm.com>
 <20110323134628.GA4352@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323134628.GA4352@tsunami.ccur.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 09:46:28AM -0400, Joe Korty wrote:
> On Wed, Mar 23, 2011 at 02:35:24AM -0400, Paul E. McKenney wrote:
> > On Mon, Mar 14, 2011 at 06:09:28PM -0400, Joe Korty wrote:
> > > On Mon, Mar 14, 2011 at 04:47:18AM -0400, Paul E. McKenney wrote:
> > > > On Sun, Mar 13, 2011 at 11:50:44PM -0400, Joe Korty wrote:
> > > > > +void rcu_barrier(void)
> > > > > +{
> > > > > +	synchronize_sched();
> > > > > +	synchronize_sched();
> > > > > +}
> > > > 
> > > > This is still broken.  You need to wait until all pre-existing RCU
> > > > callbacks on all CPUs have been invoked.  Although this does guarantee
> > > > that all callbacks on the current CPU have been invoked, if one of the
> > > > other CPUs is busy, it might not yet have processed the callbacks from
> > > > earlier grace periods.  The usual way to take care of this is to post
> > > > a callback on each CPU, then wait for them all to be invoked.
> > > 
> > > Hi Paul,
> > > JRCU (eventually) chains together all callbacks from all
> > > cpus into a single queue and then it expires that single
> > > queue.  So the double synchronize_sched() should work as
> > > a rcu_barrier implementation.
> > 
> > Hello, Joe,
> > 
> > So the following grace period is not permitted to start until all of
> > the callbacks from the prior grace period have been invoked?
> 
> Yes, it is all synchronized.  Every cpu's current batch is
> closed off at the same time.  We tolerate some fuzz in the
> timing, but that is not the same as being unsynchronized.
> 
> This happens as an automatic side effect of doing
> everything (except for call_rcu) from a single CPU.

Got it -- the rcu_delimit_batches() doesn't return until all callbacks
have been invoked, and a new grace period cannot start until this function
returns.  I am not yet sure whether this is a good thing or a bad thing.
Given your 50-millisecond grace periods, it is less of a bad thing than
it would be for shorter grace periods, I suppose.  ;-)

							Thanx, Paul
