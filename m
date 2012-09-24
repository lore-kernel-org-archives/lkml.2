Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab2IXNSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:18:31 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40729 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab2IXNS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:18:29 -0400
Date: Mon, 24 Sep 2012 06:18:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>, "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>, fweisbec@gmail.com
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
Message-ID: <20120924131806.GA2477@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
 <20120920232114.GO2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com>
 <20120921185827.GC2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com>
 <20120921195717.GD2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209221836070.10663@utopia.booyaka.com>
 <20120922201043.GE2934@linux.vnet.ibm.com>
 <20120922215923.GA13161@linux.vnet.ibm.com>
 <CAMQu2gwZE+oXg6YfCj_Ua0PQxAk8ADjCga193UKMDTBTgoo4fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMQu2gwZE+oXg6YfCj_Ua0PQxAk8ADjCga193UKMDTBTgoo4fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092413-7606-0000-0000-000003E9BBA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 03:11:34PM +0530, Shilimkar, Santosh wrote:
> On Sun, Sep 23, 2012 at 3:29 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Sat, Sep 22, 2012 at 01:10:43PM -0700, Paul E. McKenney wrote:
> >> On Sat, Sep 22, 2012 at 06:42:08PM +0000, Paul Walmsley wrote:
> >> > On Fri, 21 Sep 2012, Paul E. McKenney wrote:
> 
> [...]
> 
> >
> > And here is a patch.  I am still having trouble reproducing the problem,
> > but figured that I should avoid serializing things.
> >
> >                                                         Thanx, Paul
> >
> > ------------------------------------------------------------------------
> >
> >  b/kernel/rcutree.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > rcu: Fix day-one dyntick-idle stall-warning bug
> >
> > Each grace period is supposed to have at least one callback waiting
> > for that grace period to complete.  However, if CONFIG_NO_HZ=n, an
> > extra callback-free grace period is no big problem -- it will chew up
> > a tiny bit of CPU time, but it will complete normally.  In contrast,
> > CONFIG_NO_HZ=y kernels have the potential for all the CPUs to go to
> > sleep indefinitely, in turn indefinitely delaying completion of the
> > callback-free grace period.  Given that nothing is waiting on this grace
> > period, this is also not a problem.
> >
> > Unless RCU CPU stall warnings are also enabled, as they are in recent
> > kernels.  In this case, if a CPU wakes up after at least one minute
> > of inactivity, an RCU CPU stall warning will result.  The reason that
> > no one noticed until quite recently is that most systems have enough
> > OS noise that they will never remain absolutely idle for a full minute.
> > But there are some embedded systems with cut-down userspace configurations
> > that get into this mode quite easily.
> >
> > All this begs the question of exactly how a callback-free grace period
> > gets started in the first place.  This can happen due to the fact that
> > CPUs do not necessarily agree on which grace period is in progress.
> > If a CPU still believes that the grace period that just completed is
> > still ongoing, it will believe that it has callbacks that need to wait
> > for another grace period, never mind the fact that the grace period
> > that they were waiting for just completed.  This CPU can therefore
> > erroneously decide to start a new grace period.
> >
> > Once this CPU notices that the earlier grace period completed, it will
> > invoke its callbacks.  It then won't have any callbacks left.  If no
> > other CPU has any callbacks, we now have a callback-free grace period.
> >
> > This commit therefore makes CPUs check more carefully before starting a
> > new grace period.  This new check relies on an array of tail pointers
> > into each CPU's list of callbacks.  If the CPU is up to date on which
> > grace periods have completed, it checks to see if any callbacks follow
> > the RCU_DONE_TAIL segment, otherwise it checks to see if any callbacks
> > follow the RCU_WAIT_TAIL segment.  The reason that this works is that
> > the RCU_WAIT_TAIL segment will be promoted to the RCU_DONE_TAIL segment
> > as soon as the CPU figures out that the old grace period has ended.
> >
> > This change is to cpu_needs_another_gp(), which is called in a number
> > of places.  The only one that really matters is in rcu_start_gp(), where
> > the root rcu_node structure's ->lock is held, which prevents any
> > other CPU from starting or completing a grace period, so that the
> > comparison that determines whether the CPU is missing the completion
> > of a grace period is stable.
> >
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >
> As already confirmed by Paul W and others, I too no longer see the rcu dumps
> any more with above patch. Thanks a lot for the fix.

Glad it finally works!

							Thanx, Paul

