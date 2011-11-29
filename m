Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1K2AkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 19:40:08 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43614 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab1K2AkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:40:05 -0500
Date: Mon, 28 Nov 2011 16:39:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 1/4] rcu: Don't check irq nesting from rcu idle
 entry/exit
Message-ID: <20111129003930.GR2346@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
 <1322515487-18690-2-git-send-email-fweisbec@gmail.com>
 <20111129002244.GO2346@linux.vnet.ibm.com>
 <20111129002558.GA18182@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129002558.GA18182@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112900-9360-0000-0000-0000010C5FF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 01:26:01AM +0100, Frederic Weisbecker wrote:
> On Mon, Nov 28, 2011 at 04:22:44PM -0800, Paul E. McKenney wrote:
> > On Mon, Nov 28, 2011 at 10:24:44PM +0100, Frederic Weisbecker wrote:
> > > rcu_idle_enter() and rcu_idle_exit() don't need to check
> > > the irq nesting as they are not called from irq.
> > > 
> > > Only check dyntick_nesting from rcu_irq_enter() and
> > > rcu_irq_exit().
> > > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > ---
> > >  kernel/rcutree.c |   18 ++++++++----------
> > >  1 files changed, 8 insertions(+), 10 deletions(-)
> > 
> > I have queued this.  I had to update it to deal with a recent conflicting
> > update, please see below for the new version.
> > 
> > 							Thanx, Paul
> 
> Hmm, seems there is a problem. Look below:

Good eyes!  How about the following instead?

------------------------------------------------------------------------

rcu: Don't check irq nesting from rcu idle entry/exit

Because tasks do not nest, rcu_idle_enter() and rcu_idle_exit() do
not need to check for nesting.  This commit therefore moves nesting
checks from rcu_idle_enter_common() to rcu_irq_exit() and from
rcu_idle_exit_common() to rcu_irq_enter().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index bf085d7..860c02c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -350,10 +350,6 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
  */
 static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 {
-	if (rdtp->dynticks_nesting) {
-		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
-		return;
-	}
 	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
@@ -426,7 +422,10 @@ void rcu_irq_exit(void)
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
-	rcu_idle_enter_common(rdtp, oldval);
+	if (rdtp->dynticks_nesting)
+		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
+	else
+		rcu_idle_enter_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
 
@@ -439,10 +438,6 @@ void rcu_irq_exit(void)
  */
 static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 {
-	if (oldval) {
-		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
-		return;
-	}
 	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
@@ -518,7 +513,10 @@ void rcu_irq_enter(void)
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting++;
 	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
-	rcu_idle_exit_common(rdtp, oldval);
+	if (oldval)
+		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
+	else
+		rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
 

