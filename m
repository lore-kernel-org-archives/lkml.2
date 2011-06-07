Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab1FGSeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:34:21 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55781 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab1FGSeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:34:20 -0400
Date: Tue, 7 Jun 2011 11:34:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [1/4] rcu: Detect uses of rcu read side in extended quiescent
 states
Message-ID: <20110607183414.GF2286@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307329858-14999-3-git-send-email-fweisbec@gmail.com>
 <rcu-splat-split-printk@mdm.bga.com>
 <20110606181021.GL3066@linux.vnet.ibm.com>
 <20110607001905.GE17026@somewhere.redhat.com>
 <20110607004250.GZ3066@linux.vnet.ibm.com>
 <20110607013630.GF17026@somewhere.redhat.com>
 <20110607044005.GB2292@linux.vnet.ibm.com>
 <20110607125809.GA23214@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607125809.GA23214@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 02:58:13PM +0200, Frederic Weisbecker wrote:
> On Mon, Jun 06, 2011 at 09:40:05PM -0700, Paul E. McKenney wrote:> 
> > The bit I am missing is how to distinguish between spinlocks (where
> > sleeping is illegal) and mutexes (where sleeping is perfectly fine).
> > We could teach lockdep the difference, I suppose, but it is not clear
> > to me that it is worth it.
> 
> Ah, in fact it doesn't pass through any lockdep check.
> 
> It's only a function called might_sleep() that is placed in functions
> that can sleep. And inside might_sleep() it checks whether it is in a preemptible
> area. So it's actually locking-agnostic, it only relies on the preempt_count
> and some more for the preempt rcu cases.
> 
> I think it is called CONFIG_DEBUG_SPINLOCK_SLEEP because it was first used
> for spinlock debugging purposes. But then it has a broader use now: sleep
> inside preemptible section, sleep inside interrupts, sleep inside rcu.

But the __might_sleep() function can only differentiate between
spinlocks and sleeplocks if CONFIG_PREEMPT=y.

> It certainly deserves a rename, like CONFIG_DEBUG_ILLEGAL_SLEEP.

Hmmm...  It already checks for sleeping in the middle of a
preempt_disable() as well as in a spinlock critical section.
So the need for a rename is independent of any RCU checking.

> > In contrast, with RCU, this is straightforward -- check for rcu_sched
> > and rcu_bh, but not SRCU.

Actually it makes sense to keep the checks in rcu_note_context_switch(),
as there are places that call schedule() directly without a might_sleep().
Perhaps having checks in both places is the correct approach?

							Thanx, Paul
