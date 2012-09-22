Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2IVV7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 17:59:36 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55880 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2IVV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 17:59:34 -0400
Date: Sat, 22 Sep 2012 14:59:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>, fweisbec@gmail.com
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
Message-ID: <20120922215923.GA13161@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com>
 <20120920220130.GN2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
 <20120920232114.GO2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com>
 <20120921185827.GC2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com>
 <20120921195717.GD2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209221836070.10663@utopia.booyaka.com>
 <20120922201043.GE2934@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120922201043.GE2934@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092221-5518-0000-0000-000007DB638B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 01:10:43PM -0700, Paul E. McKenney wrote:
> On Sat, Sep 22, 2012 at 06:42:08PM +0000, Paul Walmsley wrote:
> > On Fri, 21 Sep 2012, Paul E. McKenney wrote:
> > 
> > > Could you please point me to a recipe for creating a minimal userspace?
> > > Just in case it is the userspac erather than the architecture/hardware
> > > that makes the difference.
> > 
> > Tony's suggestion is pretty good.  Note that there may also be differences 
> > in kernel timers -- either between x86 and ARM architectures, or loaded 
> > device drivers -- that may confound the problem.
> 
> For example, there must be at least one RCU callback outstanding after
> the boot sequence quiets down.  Of course, the last time I tried Tony's
> approach, I was doing it on top of my -rcu stack, so am retrying on
> v3.6-rc6.
> 
> > > Just to make sure I understand the combinations:
> > > 
> > > o	All stalls have happened when running a minimal userspace.
> > > o	CONFIG_NO_HZ=n suppresses the stalls.
> > > o	CONFIG_RCU_FAST_NO_HZ (which depends on CONFIG_NO_HZ=y) has
> > > 	no observable effect on the stalls.
> > > 
> > > Did I get that right, or am I missing a combination?
> > 
> > That's correct.
> > 
> > > Indeed, rcu_idle_gp_timer_func() is a bit strange in that it is 
> > > cancelled upon exit from idle, and therefore should (almost) never 
> > > actually execute. Its sole purpose is to wake up the CPU.  ;-)
> > 
> > Right.  Just curious, what would wake up the kernel from idle to handle a 
> > grace period expiration when CONFIG_RCU_FAST_NO_HZ=n?  On a very idle 
> > system, the time between timer ticks could potentially be several tens of 
> > seconds.
> 
> If CONFIG_RCU_FAST_NO_HZ=n, then CPUs with RCU callbacks are not permitted
> to shut off the scheduling-clock tick, so any CPU with RCU callbacks will
> be awakened every jiffy.  The problem is that there appears to be a way
> to get an RCU grace period started without any CPU having any callbacks,
> which, as you surmise, would result in all the CPUs going to sleep and
> the grace period never ending.  So if a CPU is awakened for any reason
> after this everlasting grace period has extended for more than a minute,
> the first thing that CPU will do is print an RCU CPU stall warning.
> 
> I believe that I see how to prevent callback-free grace periods from
> ever starting.  (Famous last words...)

And here is a patch.  I am still having trouble reproducing the problem,
but figured that I should avoid serializing things.

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/rcutree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

rcu: Fix day-one dyntick-idle stall-warning bug

Each grace period is supposed to have at least one callback waiting
for that grace period to complete.  However, if CONFIG_NO_HZ=n, an
extra callback-free grace period is no big problem -- it will chew up
a tiny bit of CPU time, but it will complete normally.  In contrast,
CONFIG_NO_HZ=y kernels have the potential for all the CPUs to go to
sleep indefinitely, in turn indefinitely delaying completion of the
callback-free grace period.  Given that nothing is waiting on this grace
period, this is also not a problem.

Unless RCU CPU stall warnings are also enabled, as they are in recent
kernels.  In this case, if a CPU wakes up after at least one minute
of inactivity, an RCU CPU stall warning will result.  The reason that
no one noticed until quite recently is that most systems have enough
OS noise that they will never remain absolutely idle for a full minute.
But there are some embedded systems with cut-down userspace configurations
that get into this mode quite easily.

All this begs the question of exactly how a callback-free grace period
gets started in the first place.  This can happen due to the fact that
CPUs do not necessarily agree on which grace period is in progress.
If a CPU still believes that the grace period that just completed is
still ongoing, it will believe that it has callbacks that need to wait
for another grace period, never mind the fact that the grace period
that they were waiting for just completed.  This CPU can therefore
erroneously decide to start a new grace period.

Once this CPU notices that the earlier grace period completed, it will
invoke its callbacks.  It then won't have any callbacks left.  If no
other CPU has any callbacks, we now have a callback-free grace period.

This commit therefore makes CPUs check more carefully before starting a
new grace period.  This new check relies on an array of tail pointers
into each CPU's list of callbacks.  If the CPU is up to date on which
grace periods have completed, it checks to see if any callbacks follow
the RCU_DONE_TAIL segment, otherwise it checks to see if any callbacks
follow the RCU_WAIT_TAIL segment.  The reason that this works is that
the RCU_WAIT_TAIL segment will be promoted to the RCU_DONE_TAIL segment
as soon as the CPU figures out that the old grace period has ended.

This change is to cpu_needs_another_gp(), which is called in a number
of places.  The only one that really matters is in rcu_start_gp(), where
the root rcu_node structure's ->lock is held, which prevents any
other CPU from starting or completing a grace period, so that the
comparison that determines whether the CPU is missing the completion
of a grace period is stable.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f280e54..f7bcd9e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -305,7 +305,9 @@ cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
 static int
 cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	return *rdp->nxttail[RCU_DONE_TAIL] && !rcu_gp_in_progress(rsp);
+	return *rdp->nxttail[RCU_DONE_TAIL +
+			     ACCESS_ONCE(rsp->completed) != rdp->completed] &&
+	       !rcu_gp_in_progress(rsp);
 }
 
 /*

