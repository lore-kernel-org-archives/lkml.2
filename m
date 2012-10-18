Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab2JRPs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:48:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34476 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab2JRPsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:48:25 -0400
Date: Thu, 18 Oct 2012 08:25:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: restore correct batch limiting
Message-ID: <20121018152543.GI2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1350458052.26103.31.camel@edumazet-glaptop>
 <20121018115859.GH2518@linux.vnet.ibm.com>
 <1350564290.26103.1496.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350564290.26103.1496.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101815-8974-0000-0000-00000FC41565
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00183572; UDB=6.00041582; UTC=2012-10-18
 15:48:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 02:44:50PM +0200, Eric Dumazet wrote:
> On Thu, 2012-10-18 at 04:58 -0700, Paul E. McKenney wrote:
> > On Wed, Oct 17, 2012 at 09:14:12AM +0200, Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > > 
> > > Commit 29c00b4a1d9e27 (rcu: Add event-tracing for RCU callback
> > > invocation) added a regression in rcu_do_batch()
> > > 
> > > Under stress, RCU is supposed to allow to process all items in queue,
> > > instead of a batch of 10 items (blimit), but an integer overflow makes
> > > the effective limit being 1.
> > > 
> > > So RCU cannot recover and machine eventually crash because of OOM.
> > > 
> > > Using long instead of int is not really needed, convert everything
> > > to integers.
> > 
> > <facepalm>
> > 
> > Good catch!!!
> > 
> > The reason for favoring long over int is that there are a few systems out
> > there with terabytes of main memory.  In addition, there have been a few
> > bugs over the past few years that could result in RCU CPU stalls of more
> > than a minute.  This makes it impossible to rule out the possibility of
> > a billion callbacks appearing on one CPU.
> > 
> > So, does the following patch fix things, or a I still confused?
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > rcu: Fix batch-limit size problem
> > 
> > Commit 29c00b4a1d9e27 (rcu: Add event-tracing for RCU callback
> > invocation) added a regression in rcu_do_batch()
> > 
> > Under stress, RCU is supposed to allow to process all items in queue,
> > instead of a batch of 10 items (blimit), but an integer overflow makes
> > the effective limit being 1.  So, unless there is frequent idle periods
> > (during which RCU ignores batch limits), RCU can be forced into a
> > state where it cannot keep up with the callback-generation rate,
> > eventually resulting in OOM.
> > 
> > This commit therefore converts a few variables in rcu_do_batch() from
> > int to long to fix this problem.
> > 
> > Reported-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index e36d085..e056e1e 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1823,7 +1823,8 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
> >  {
> >  	unsigned long flags;
> >  	struct rcu_head *next, *list, **tail;
> > -	int bl, count, count_lazy, i;
> > +	long bl, count, count_lazy;
> > +	int i;
> >  
> >  	/* If no callbacks are ready, just return.*/
> >  	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
> > 
> 
> Yes, why not, but global "int blimit" being an int, I really dont see
> the point having a long in struct rcu_data.
> 
> Having 2 billions callbacks on one cpu would be problematic, I really
> hope nobody relies on this ;)

Fair point!  ;-)

But just making everything long makes it quite easy to analyze.

> I guess the 10/infinity switch should be smarter.
> 
> something like the following maybe :
> 
> rdp->blimit = max(blimit, rdp->qlen >> 6);
> 
> (if queue is big, dont wait to hit 10000 before allowing more items to
> be handled per round)

The -rt guys would not be amused.  :-(

But for non-realtime use, increasing rcutree.blimit either at boot or
via sysfs could make sense.  It is also likely that I will move callback
processing to a kthread at some point, which would allow some additional
flexibility.

Furthermore, it would be easy to have one default for non-rt and another
for -rt, if that would help.

> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> Please dont forget stable teams.  (3.2 + )

Added both, please see below!

							Thanx, Paul

------------------------------------------------------------------------

rcu: Fix batch-limit size problem

Commit 29c00b4a1d9e27 (rcu: Add event-tracing for RCU callback
invocation) added a regression in rcu_do_batch()

Under stress, RCU is supposed to allow to process all items in queue,
instead of a batch of 10 items (blimit), but an integer overflow makes
the effective limit being 1.  So, unless there is frequent idle periods
(during which RCU ignores batch limits), RCU can be forced into a
state where it cannot keep up with the callback-generation rate,
eventually resulting in OOM.

This commit therefore converts a few variables in rcu_do_batch() from
int to long to fix this problem, along with the module parameters
controlling the batch limits.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> # 3.2 +

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e36d085..3a7170b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -212,13 +212,13 @@ DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 #endif
 };
 
-static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
-static int qhimark = 10000;	/* If this many pending, ignore blimit. */
-static int qlowmark = 100;	/* Once only this many pending, use blimit. */
+static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
+static long qhimark = 10000;	/* If this many pending, ignore blimit. */
+static long qlowmark = 100;	/* Once only this many pending, use blimit. */
 
-module_param(blimit, int, 0444);
-module_param(qhimark, int, 0444);
-module_param(qlowmark, int, 0444);
+module_param(blimit, long, 0444);
+module_param(qhimark, long, 0444);
+module_param(qlowmark, long, 0444);
 
 int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
 int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
@@ -1823,7 +1823,8 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int bl, count, count_lazy, i;
+	long bl, count, count_lazy;
+	int i;
 
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {

