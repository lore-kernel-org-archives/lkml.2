Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab2AECGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:06:09 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52005 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab2AECGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:06:07 -0500
Date: Thu, 5 Jan 2012 03:06:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: Improve detection of illegal synchronize_rcu() call
 from RCU read side
Message-ID: <20120105020601.GE1143@somewhere>
References: <1324901803.31721.4.camel@lappy>
 <20111226163148.GC2435@linux.vnet.ibm.com>
 <20111226163734.GF28309@somewhere.redhat.com>
 <20111226195656.GD2435@linux.vnet.ibm.com>
 <20120104190336.GC1143@somewhere>
 <20120104213035.GF2448@linux.vnet.ibm.com>
 <20120105014518.GD1143@somewhere>
 <20120105020108.GQ2448@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105020108.GQ2448@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 06:01:08PM -0800, Paul E. McKenney wrote:
> On Thu, Jan 05, 2012 at 02:45:20AM +0100, Frederic Weisbecker wrote:
> > On Wed, Jan 04, 2012 at 01:30:35PM -0800, Paul E. McKenney wrote:
> > > On Wed, Jan 04, 2012 at 08:03:39PM +0100, Frederic Weisbecker wrote:
> > > > Actually for the case of RCU, the wait_for_completion() called by synchronize_rcu()
> > > > has a might_sleep() call that triggers a warning in this case.
> > > > 
> > > > But in the case of SMP with 1 online CPU, the rcu_blocking_is_gp()
> > > > checks returns right away on rcutree. So probably we need this?
> > > 
> > > I modified this to push the might_sleep() down into the
> > > rcu_blocking_is_gp() function, queued the result, and retained your
> > > Signed-off-by.  (Please let me know if there is any problem with this.)
> > > 
> > > This does work for TREE_PREEMPT_RCU and for synchronize_rcu_bh() in
> > > TREE_RCU, but not for synchronize_sched() in TREE_RCU.  This is because
> > > rcu_read_lock() and rcu_read_unlock() are no-ops in the TREE_RCU case.
> > 
> > Not sure about that. This calls preempt_disable() which, in any case with
> > CONFIG_DEBUG_ATOMIC_SLEEP, handles the preempt count. And that even if
> > !CONFIG_PREEMPT.
> 
> Ah, of course!  I keep forgetting that CONFIG_DEBUG_ATOMIC_SLEEP selects
> CONFIG_PREEMPT_COUNT.
> 
> > > So I queued up a separate patch using rcu_lockdep_assert() to check for
> > > illegal RCU grace period within the same-type RCU read-side critical
> > > section, including for SRCU.  This is also a partial solution, as it
> > > does not handle things like this:
> > > 
> > > 	void foo(void)
> > > 	{
> > > 		mutex_lock(&my_mutex);
> > > 		. . .
> > > 		synchronize_srcu(&my_srcu);
> > > 		. . .
> > > 		mutex_unlock(&my_mutex);
> > > 	}
> > > 
> > > 	void bar(void)
> > > 	{
> > > 		int idx;
> > > 
> > > 		idx = rcu_read_lock(&m_srcu);
> > > 		. . .
> > > 		mutex_lock(&my_mutex);
> > > 		. . .
> > > 		mutex_unlock(&my_mutex);
> > > 		. . .
> > > 		srcu_read_unlock(&m_srcu, idx);
> > > 	}
> > > 
> > > This can be extended into a chain of locks and a chain of SRCU instances.
> > > For an example of the latter, consider an SRCU-A read-side critical
> > > section containing an SRCU-B grace period, an SRCU-B read-side critical
> > > section containing an SRCU-C grace period, and so on, with the SRCU-Z
> > > read-side critical section containing an RCU-A grace period.
> > 
> > Heh! Indeed...
> > 
> > > But it
> > > is OK to hold a mutex across one SRCU read-side critical section while
> > > acquiring that same mutex within another same-flavor SRCU read-side
> > > critical section.  So the analogy with reader-writer locking only goes
> > > so far.
> > > 
> > > At the moment, a full solution seems to require some surgery on lockdep
> > > itself, but perhaps there is a better way.
> > 
> > Ok.
> > 
> > > 
> > > > rcutiny seems to be fine with the cond_resched() call, but srcu needs
> > > > a special treatment.
> > > 
> > > For the moment, I just applied rcu_lockdep_assert() everywhere -- zero
> > > cost on non-lockdep kernels, and fully handles all of the RCU simple
> > > self-deadlock cases.
> > 
> > So, for RCU I'm not sure this is useful given the might_sleep() things.
> > But for srcu it is.
> 
> One nice thing about the lockdep approach is that it tracks where the
> conflicting RCU read-side critical section started.  But I am planning
> for these to be 3.4 material, so we do have some time to refine them.

Yeah sure. And in any case it's still good to keep might_sleep() early
to spot other sources of illegal atomic sections (irqs disabled and co)
