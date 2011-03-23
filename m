Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab1CWNsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:48:00 -0400
Received: from flusers.ccur.com ([173.221.59.2]:40695 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753140Ab1CWNr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:47:58 -0400
Date: Wed, 23 Mar 2011 09:46:28 -0400
From: Joe Korty <joe.korty@ccur.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Message-ID: <20110323134628.GA4352@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20110314035044.GA12990@tsunami.ccur.com>
 <20110314084718.GH2167@linux.vnet.ibm.com>
 <20110314220928.GA1348@tsunami.ccur.com>
 <20110323063524.GS2322@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323063524.GS2322@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 02:35:24AM -0400, Paul E. McKenney wrote:
> On Mon, Mar 14, 2011 at 06:09:28PM -0400, Joe Korty wrote:
> > On Mon, Mar 14, 2011 at 04:47:18AM -0400, Paul E. McKenney wrote:
> > > On Sun, Mar 13, 2011 at 11:50:44PM -0400, Joe Korty wrote:
> > > > +void rcu_barrier(void)
> > > > +{
> > > > +	synchronize_sched();
> > > > +	synchronize_sched();
> > > > +}
> > > 
> > > This is still broken.  You need to wait until all pre-existing RCU
> > > callbacks on all CPUs have been invoked.  Although this does guarantee
> > > that all callbacks on the current CPU have been invoked, if one of the
> > > other CPUs is busy, it might not yet have processed the callbacks from
> > > earlier grace periods.  The usual way to take care of this is to post
> > > a callback on each CPU, then wait for them all to be invoked.
> > 
> > Hi Paul,
> > JRCU (eventually) chains together all callbacks from all
> > cpus into a single queue and then it expires that single
> > queue.  So the double synchronize_sched() should work as
> > a rcu_barrier implementation.
> 
> Hello, Joe,
> 
> So the following grace period is not permitted to start until all of
> the callbacks from the prior grace period have been invoked?

Yes, it is all synchronized.  Every cpu's current batch is
closed off at the same time.  We tolerate some fuzz in the
timing, but that is not the same as being unsynchronized.

This happens as an automatic side effect of doing
everything (except for call_rcu) from a single CPU.

Joe
