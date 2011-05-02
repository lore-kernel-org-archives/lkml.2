Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab1EBIXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:23:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45523 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1EBIXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:23:46 -0400
Date: Mon, 2 May 2011 01:23:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 09/86] rcu: avoid hammering sched with yet
 another bound RT kthread
Message-ID: <20110502082334.GU2297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-9-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110501154858.GE14829@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501154858.GE14829@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 08:48:58AM -0700, Josh Triplett wrote:
> On Sun, May 01, 2011 at 06:20:49AM -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > The scheduler does not appear to take kindly to having multiple
> > real-time threads bound to a CPU that is going offline.  So this
> > commit is a temporary hack-around to avoid that happening.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutorture.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index c224da4..4d256db 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -163,11 +163,11 @@ static int stutter_pause_test;
> >  #endif
> >  int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
> >  
> > -#ifdef CONFIG_RCU_BOOST
> > +#if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU)
> >  #define rcu_can_boost() 1
> > -#else /* #ifdef CONFIG_RCU_BOOST */
> > +#else /* #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
> >  #define rcu_can_boost() 0
> > -#endif /* #else #ifdef CONFIG_RCU_BOOST */
> > +#endif /* #else #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
> 
> So, this disables boosting entirely when CONFIG_HOTPLUG_CPU=y?  Other
> patches in this series take various steps to un-bound or un-realtime the
> RCU threads on a CPU when it goes offline; do those fix this problem?
> Which patch disables this hack-around?

No, it just flips the default.  You can still test boosting in this case
by specifying test_boost=2 when loading rcutorture.

As near as I can tell, the sensitivity is a scheduler bug.  Once this
is fixed, I will revert this patch.

	http://comments.gmane.org/gmane.linux.kernel/1131000

> Also, it seems like your patch series introduces boosting, and then
> disables it for CONFIG_HOTPLUG_CPU=y, which suggests that in the middle
> of this patch series you can have a broken kernel if you build with
> CONFIG_HOTPLUG_CPU=y and CONFIG_RCU_BOOST=y.  Please consider reordering
> the patches (and possibly merging this patch into the original
> introduction of RCU boosting) to make sure that kernels in the middle of
> the patch series don't have this potential brokenness.

I need to have the patch separate so that I can revert it later, when
the underlying problem is fixed.  And if someone is bisecting based
on running rcutorture with priority boosting, they are going to have
to handle the introduction of priority boosting specially anyway --
otherwise, they get artifacts when testing before the introduction of
RCU_TREE priority boosting.

So, while I definitely am a fan of bisectability, I don't believe that
the location of this patch introduces any additional problems.

							Thanx, Paul
