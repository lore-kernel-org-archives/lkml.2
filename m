Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1CWGfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 02:35:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50546 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1CWGff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 02:35:35 -0400
Date: Tue, 22 Mar 2011 23:35:24 -0700
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
Message-ID: <20110323063524.GS2322@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110314035044.GA12990@tsunami.ccur.com>
 <20110314084718.GH2167@linux.vnet.ibm.com>
 <20110314220928.GA1348@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314220928.GA1348@tsunami.ccur.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 06:09:28PM -0400, Joe Korty wrote:
> On Mon, Mar 14, 2011 at 04:47:18AM -0400, Paul E. McKenney wrote:
> > On Sun, Mar 13, 2011 at 11:50:44PM -0400, Joe Korty wrote:
> > > +void rcu_barrier(void)
> > > +{
> > > +	synchronize_sched();
> > > +	synchronize_sched();
> > > +}
> > 
> > This is still broken.  You need to wait until all pre-existing RCU
> > callbacks on all CPUs have been invoked.  Although this does guarantee
> > that all callbacks on the current CPU have been invoked, if one of the
> > other CPUs is busy, it might not yet have processed the callbacks from
> > earlier grace periods.  The usual way to take care of this is to post
> > a callback on each CPU, then wait for them all to be invoked.
> 
> Hi Paul,
> JRCU (eventually) chains together all callbacks from all
> cpus into a single queue and then it expires that single
> queue.  So the double synchronize_sched() should work as
> a rcu_barrier implementation.

Hello, Joe,

So the following grace period is not permitted to start until all of
the callbacks from the prior grace period have been invoked?

Or am I missing something subtle here?

							Thanx, Paul
