Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0LKAE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:04:57 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40029 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756709Ab0LKAEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:04:55 -0500
Date: Fri, 10 Dec 2010 16:04:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, laijs@cn.fujitsu.com
Subject: Re: [PATCH 2/2] rcu: Keep gpnum and completed fields synchronized
Message-ID: <20101211000451.GN2125@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1292015471-19227-1-git-send-email-fweisbec@gmail.com>
 <1292015471-19227-3-git-send-email-fweisbec@gmail.com>
 <20101210230200.GK2125@linux.vnet.ibm.com>
 <20101210233920.GA22777@linux.vnet.ibm.com>
 <20101210234709.GC1713@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210234709.GC1713@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 12:47:11AM +0100, Frederic Weisbecker wrote:
> On Fri, Dec 10, 2010 at 03:39:20PM -0800, Paul E. McKenney wrote:
> > On Fri, Dec 10, 2010 at 03:02:00PM -0800, Paul E. McKenney wrote:
> > > On Fri, Dec 10, 2010 at 10:11:11PM +0100, Frederic Weisbecker wrote:
> > > > When a CPU that was in an extended quiescent state wakes
> > > > up and catches up with grace periods that remote CPUs
> > > > completed on its behalf, we update the completed field
> > > > but not the gpnum that keeps a stale value of a backward
> > > > grace period ID.
> > > > 
> > > > Later, note_new_gpnum() will interpret the shift between
> > > > the local CPU and the node grace period ID as some new grace
> > > > period to handle and will then start to hunt quiescent state.
> > > > 
> > > > But if every grace periods have already been completed, this
> > > > interpretation becomes broken. And we'll be stuck in clusters
> > > > of spurious softirqs because rcu_report_qs_rdp() will make
> > > > this broken state run into infinite loop.
> > > > 
> > > > The solution, as suggested by Lai Jiangshan, is to ensure that
> > > > the gpnum and completed fields are well synchronized when we catch
> > > > up with completed grace periods on their behalf by other cpus.
> > > > This way we won't start noting spurious new grace periods.
> > > 
> > > Also good, queued!
> > > 
> > > One issue -- this approach is vulnerable to overflow.  I therefore
> > > followed up with a patch that changes the condition to
> > > 
> > > 	if (ULONG_CMP_LT(rdp->gpnum, rdp->completed))
> > 
> > And here is the follow-up patch, FWIW.
> > 
> > 							Thanx, Paul
> 
> Hmm, it doesn't apply on top of my two patches. It seems you have
> kept my two previous patches, which makes it fail as it lacks them
> as a base.
> 
> Did you intend to keep them? I hope they are quite useless now, otherwise
> it means there is other cases I forgot.

One is indeed useless, while the other is useful in combinations of
dyntick-idle and force_quiescent_state().  I rebased your earlier two
out and reworked mine, please see below.  Work better?

							Thanx, Paul

------------------------------------------------------------------------

commit c808bedd1b1d7c720546a6682fca44c66703af4e
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Fri Dec 10 15:02:47 2010 -0800

    rcu: fine-tune grace-period begin/end checks
    
    Use the CPU's bit in rnp->qsmask to determine whether or not the CPU
    should try to report a quiescent state.  Handle overflow in the check
    for rdp->gpnum having fallen behind.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 368be76..530cdcd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -616,9 +616,17 @@ static void __init check_cpu_stall_init(void)
 static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	if (rdp->gpnum != rnp->gpnum) {
-		rdp->qs_pending = 1;
-		rdp->passed_quiesc = 0;
+		/*
+		 * If the current grace period is waiting for this CPU,
+		 * set up to detect a quiescent state, otherwise don't
+		 * go looking for one.
+		 */
 		rdp->gpnum = rnp->gpnum;
+		if (rnp->qsmask & rdp->grpmask) {
+			rdp->qs_pending = 1;
+			rdp->passed_quiesc = 0;
+		} else
+			rdp->qs_pending = 0;
 	}
 }
 
@@ -680,19 +688,20 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 
 		/*
 		 * If we were in an extended quiescent state, we may have
-		 * missed some grace periods that others CPUs took care on
+		 * missed some grace periods that others CPUs handled on
 		 * our behalf. Catch up with this state to avoid noting
-		 * spurious new grace periods.
+		 * spurious new grace periods.  If another grace period
+		 * has started, then rnp->gpnum will have advanced, so
+		 * we will detect this later on.
 		 */
-		if (rdp->completed > rdp->gpnum)
+		if (ULONG_CMP_LT(rdp->gpnum, rdp->completed))
 			rdp->gpnum = rdp->completed;
 
 		/*
-		 * If another CPU handled our extended quiescent states and
-		 * we have no more grace period to complete yet, then stop
-		 * chasing quiescent states.
+		 * If RCU does not need a quiescent state from this CPU,
+		 * then make sure that this CPU doesn't go looking for one.
 		 */
-		if (rdp->completed == rnp->gpnum)
+		if (rnp->qsmask & rdp->grpmask)
 			rdp->qs_pending = 0;
 	}
 }
