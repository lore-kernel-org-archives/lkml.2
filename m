Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0LJXj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:39:26 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58344 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819Ab0LJXjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:39:25 -0500
Date: Fri, 10 Dec 2010 15:39:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, laijs@cn.fujitsu.com
Subject: Re: [PATCH 2/2] rcu: Keep gpnum and completed fields synchronized
Message-ID: <20101210233920.GA22777@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1292015471-19227-1-git-send-email-fweisbec@gmail.com>
 <1292015471-19227-3-git-send-email-fweisbec@gmail.com>
 <20101210230200.GK2125@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210230200.GK2125@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 03:02:00PM -0800, Paul E. McKenney wrote:
> On Fri, Dec 10, 2010 at 10:11:11PM +0100, Frederic Weisbecker wrote:
> > When a CPU that was in an extended quiescent state wakes
> > up and catches up with grace periods that remote CPUs
> > completed on its behalf, we update the completed field
> > but not the gpnum that keeps a stale value of a backward
> > grace period ID.
> > 
> > Later, note_new_gpnum() will interpret the shift between
> > the local CPU and the node grace period ID as some new grace
> > period to handle and will then start to hunt quiescent state.
> > 
> > But if every grace periods have already been completed, this
> > interpretation becomes broken. And we'll be stuck in clusters
> > of spurious softirqs because rcu_report_qs_rdp() will make
> > this broken state run into infinite loop.
> > 
> > The solution, as suggested by Lai Jiangshan, is to ensure that
> > the gpnum and completed fields are well synchronized when we catch
> > up with completed grace periods on their behalf by other cpus.
> > This way we won't start noting spurious new grace periods.
> 
> Also good, queued!
> 
> One issue -- this approach is vulnerable to overflow.  I therefore
> followed up with a patch that changes the condition to
> 
> 	if (ULONG_CMP_LT(rdp->gpnum, rdp->completed))

And here is the follow-up patch, FWIW.

							Thanx, Paul

------------------------------------------------------------------------

commit d864b245030645e3465b3bd7e253b7ccf76e9d35
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Fri Dec 10 15:02:47 2010 -0800

    rcu: fine-tune grace-period begin/end checks
    
    Use the CPU's bit in rnp->qsmask to determine whether or not the CPU
    should try to report a quiescent state.  Handle overflow in the check
    for rdp->gpnum having fallen behind.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f8e4ee7..6103017 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -618,20 +618,16 @@ static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct
 {
 	if (rdp->gpnum != rnp->gpnum) {
 		/*
-		 * Because RCU checks for the prior grace period ending
-		 * before checking for a new grace period starting, it
-		 * is possible for rdp->gpnum to be set to the old grace
-		 * period and rdp->completed to be set to the new grace
-		 * period.  So don't bother checking for a quiescent state
-		 * for the rnp->gpnum grace period unless it really is
-		 * waiting for this CPU.
+		 * If the current grace period is waiting for this CPU,
+		 * set up to detect a quiescent state, otherwise don't
+		 * go looking for one.
 		 */
-		if (rdp->completed != rnp->gpnum) {
+		rdp->gpnum = rnp->gpnum;
+		if (rnp->qsmask & rdp->grpmask) {
 			rdp->qs_pending = 1;
 			rdp->passed_quiesc = 0;
-		}
-
-		rdp->gpnum = rnp->gpnum;
+		} else
+			rdp->qs_pending = 0;
 	}
 }
 
@@ -693,19 +689,20 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 
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
