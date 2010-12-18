Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab0LRT64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 14:58:56 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41902 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab0LRT6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 14:58:55 -0500
Date: Sat, 18 Dec 2010 11:58:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 11/20] rcu: fix race condition in
 synchronize_sched_expedited()
Message-ID: <20101218195849.GC2143@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101217205433.GA10199@linux.vnet.ibm.com>
 <1292619291-2468-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <4D0CD8C7.8070604@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0CD8C7.8070604@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 04:52:39PM +0100, Tejun Heo wrote:
> Hello,
> 
> On 12/17/2010 09:54 PM, Paul E. McKenney wrote:
> > The new (early 2010) implementation of synchronize_sched_expedited() uses
> > try_stop_cpu() to force a context switch on every CPU.  It also permits
> > concurrent calls to synchronize_sched_expedited() to share a single call
> > to try_stop_cpu() through use of an atomically incremented
> > synchronize_sched_expedited_count variable.  Unfortunately, this is
> > subject to failure as follows:
> > 
> > o	Task A invokes synchronize_sched_expedited(), try_stop_cpus()
> > 	succeeds, but Task A is preempted before getting to the atomic
> > 	increment of synchronize_sched_expedited_count.
> > 
> > o	Task B also invokes synchronize_sched_expedited(), with exactly
> > 	the same outcome as Task A.
> > 
> > o	Task C also invokes synchronize_sched_expedited(), again with
> > 	exactly the same outcome as Tasks A and B.
> > 
> > o	Task D also invokes synchronize_sched_expedited(), but only
> > 	gets as far as acquiring the mutex within try_stop_cpus()
> > 	before being preempted, interrupted, or otherwise delayed.
> > 
> > o	Task E also invokes synchronize_sched_expedited(), but only
> > 	gets to the snapshotting of synchronize_sched_expedited_count.
> > 
> > o	Tasks A, B, and C all increment synchronize_sched_expedited_count.
> > 
> > o	Task E fails to get the mutex, so checks the new value
> > 	of synchronize_sched_expedited_count.  It finds that the
> > 	value has increased, so (wrongly) assumes that its work
> > 	has been done, returning despite there having been no
> > 	expedited grace period since it began.
> > 
> > The solution is to have the lowest-numbered CPU atomically increment
> > the synchronize_sched_expedited_count variable within the
> > synchronize_sched_expedited_cpu_stop() function, which is under
> > the protection of the mutex acquired by try_stop_cpus().  However, this
> > also requires that piggybacking tasks wait for three rather than two
> > instances of try_stop_cpu(), because we cannot control the order in
> > which the per-CPU callback function occur.
> > 
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Thank you!

> I suppose this should go -stable?

Given that it is only a theoretical bug, I am targeting 2.6.38 rather
than 2.6.37.  But yes, looks to me like a -stable candidate.

							Thanx, Paul
