Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab2FPUbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 16:31:25 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:58564 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab2FPUbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 16:31:24 -0400
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.46.74
Date: Sat, 16 Jun 2012 13:31:06 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 02/15] rcu: Size rcu_node tree from
 nr_cpu_ids rather than NR_CPUS
Message-ID: <20120616203106.GA12293@leaf>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615214726.GT31184@leaf>
 <20120616003714.GS2389@linux.vnet.ibm.com>
 <20120616051712.GA8252@leaf>
 <20120616063848.GB2420@linux.vnet.ibm.com>
 <20120616091733.GD8252@leaf>
 <20120616144453.GE2420@linux.vnet.ibm.com>
 <20120616145154.GA10128@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616145154.GA10128@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 07:51:54AM -0700, Paul E. McKenney wrote:
> On Sat, Jun 16, 2012 at 07:44:53AM -0700, Paul E. McKenney wrote:
> > On Sat, Jun 16, 2012 at 02:17:33AM -0700, Josh Triplett wrote:
> > > On Fri, Jun 15, 2012 at 11:38:48PM -0700, Paul E. McKenney wrote:
> > > > On Fri, Jun 15, 2012 at 10:17:12PM -0700, Josh Triplett wrote:
> > > > > On Fri, Jun 15, 2012 at 05:37:14PM -0700, Paul E. McKenney wrote:
> > > > > > On Fri, Jun 15, 2012 at 02:47:26PM -0700, Josh Triplett wrote:
> > > > > > > On Fri, Jun 15, 2012 at 02:05:57PM -0700, Paul E. McKenney wrote:
> > > > > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > > > > 
> > > > > > > > The rcu_node tree array is sized based on compile-time constants,
> > > > > > > > including NR_CPUS.  Although this approach has worked well in the past,
> > > > > > > > the recent trend by many distros to define NR_CPUS=4096 results in
> > > > > > > > excessive grace-period-initialization latencies.
> > > > > > > > 
> > > > > > > > This commit therefore substitutes the run-time computed nr_cpu_ids for
> > > > > > > > the compile-time NR_CPUS when building the tree.  This can result in
> > > > > > > > much of the compile-time-allocated rcu_node array being unused.  If
> > > > > > > > this is a major problem, you are in a specialized situation anyway,
> > > > > > > > so you can manually adjust the NR_CPUS, RCU_FANOUT, and RCU_FANOUT_LEAF
> > > > > > > > kernel config parameters.
> > > > > > > > 
> > > > > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > > > > ---
> > > > > > > >  kernel/rcutree.c        |    2 +-
> > > > > > > >  kernel/rcutree_plugin.h |    2 ++
> > > > > > > >  2 files changed, 3 insertions(+), 1 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > > > > > > index a151184..9098910 100644
> > > > > > > > --- a/kernel/rcutree.c
> > > > > > > > +++ b/kernel/rcutree.c
> > > > > > > > @@ -2672,7 +2672,7 @@ static void __init rcu_init_geometry(void)
> > > > > > > >  {
> > > > > > > >  	int i;
> > > > > > > >  	int j;
> > > > > > > > -	int n = NR_CPUS;
> > > > > > > > +	int n = nr_cpu_ids;
> > > > > > > 
> > > > > > > Same question as before: why have this as a variable when it never
> > > > > > > changes?
> > > > > > 
> > > > > > Ah, that explains why.  This prevented me from forgetting the random
> > > > > > NR_CPUS.
> > > > > 
> > > > > Does that mean it can go away now that you've written the patches?
> > > > 
> > > > If I don't have to change from nr_cpu_ids to yet another thing over
> > > > the next while, then it might be worth changing.
> > > 
> > > That sounds like an argument for a #define or a static const, rather
> > > than a local variable. :)
> > 
> > OK, static const it is!
> 
> Except that the compiler doesn't like the run-time initialization of
> a static const variable.
> 
> Can't have everything, I guess.  ;-)

Ah, right, nr_cpu_ids is not a static const.

In that case, just waiting until you think this definition won't churn
anymore and substituting nr_cpu_ids for n everywhere seems like the
right solution.

- Josh Triplett
