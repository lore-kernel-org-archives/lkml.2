Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab0F1T5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:57:53 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33905 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab0F1T5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:57:52 -0400
Date: Mon, 28 Jun 2010 12:57:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: simplify the usage of percpu data
Message-ID: <20100628195747.GA30400@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4C285C60.90801@cn.fujitsu.com>
 <4C285F8F.3040707@kernel.org>
 <20100628165654.GA2357@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628165654.GA2357@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 09:56:54AM -0700, Paul E. McKenney wrote:
> On Mon, Jun 28, 2010 at 10:38:39AM +0200, Tejun Heo wrote:
> > On 06/28/2010 10:25 AM, Lai Jiangshan wrote:
> > > &percpu_data is compatible with allocated percpu data.
> > > 
> > > And we use it and remove the "rda[NR_CPUS]" array.
> > > 
> > > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > Looks good to me.
> > 
> > Reviewed-by: Tejun Heo <tj@kernel.org>
> 
> Thank you both!!!  I have queued this.

FYI, I added the patchlet below to make it build for CONFIG_RCU_TRACE
kernels.

							Thanx, Paul

------------------------------------------------------------------------

rcu: apply ->rda changes to rcutree_trace.c
    
The print_rcu_pendings() function used the ->rda[] array, so this
commit makes it instead use per_cpu_ptr().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 36c95b4..458e032 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -262,7 +262,7 @@ static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
 	struct rcu_data *rdp;
 
 	for_each_possible_cpu(cpu) {
-		rdp = rsp->rda[cpu];
+		rdp = per_cpu_ptr(rsp->rda, cpu);
 		if (rdp->beenonline)
 			print_one_rcu_pending(m, rdp);
 	}
