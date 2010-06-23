Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab0FWIJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:09:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:51102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0FWIJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:09:07 -0400
Subject: Re: [GIT PULL rcu/urgent] yet more lockdep-RCU splat fixes
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, daniel.blueman@gmail.com,
       lizf@cn.fujitsu.com, miles.lane@gmail.com, manfred@colorfullife.com
In-Reply-To: <20100622204433.GJ2290@linux.vnet.ibm.com>
References: <20100616042224.GA3892@linux.vnet.ibm.com>
	 <20100616055358.GB17936@elte.hu> <1276669431.1745.595.camel@laptop>
	 <20100616224110.GI2457@linux.vnet.ibm.com>
	 <1276764554.27822.26.camel@twins>
	 <20100622204433.GJ2290@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Jun 2010 10:08:47 +0200
Message-ID: <1277280527.1875.782.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 13:44 -0700, Paul E. McKenney wrote:

> I am probably missing something, but I see wake_affine() only called
> from select_task_rq_fair(), which is one of the possible values for
> ->select_task_rq().  This can be called from select_task_rq(), which
> claims that it can be called without holding rq->lock.  I do not see
> any rq->lock acquisition on the path from select_task_rq() to the
> call to wake_affine().
> 
You're right, although try_to_wake_up(), wake_up_new_task() and
sched_exec() all hold a rq->lock (not sufficient to cover both
task_group() callers though).

I posted a patch yesterday that makes try_to_wake_up() call
select_task_rq() without any rq->lock held (although its a scary patch
and needs more work).

> rcu: apply RCU protection to wake_affine()
> 
> The task_group() function returns a pointer that must be protected
> by either RCU, the ->alloc_lock, or the cgroup lock (see the
> rcu_dereference_check() in task_subsys_state(), which is invoked by
> task_group()).  The wake_affine() function currently does none of these,
> which means that a concurrent update would be within its rights to free
> the structure returned by task_group().  Because wake_affine() uses this
> structure only to compute load-balancing heuristics, there is no reason
> to acquire either of the two locks.
> 
> Therefore, this commit introduces an RCU read-side critical section that
> starts before the first call to task_group() and ends after the last use
> of the "tg" pointer returned from task_group().  Thanks to Li Zefan for
> pointing out the need to extend the RCU read-side critical section from
> that proposed by the original patch.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

OK, fair enough, thanks!
