Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab1FGStJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:49:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46218 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab1FGStH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sTjjFsaFNWiHajhKaVG4XkpBqW1yPKMKuZc7d2cNuyKBYh3QtwVq7M/iOQMhbjnebY
         UwNHO3BhE0eyZm3M55Volc+IzyQmUidH+nVPLdzpoFb7B6WrYF5OOSfc6xG0woz2TYAR
         0RNXqXdwfJjZZbDF9kTs2JhWs6R6MQtbeAp3E=
Date: Tue, 7 Jun 2011 20:49:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [1/4] rcu: Detect uses of rcu read side in extended quiescent
 states
Message-ID: <20110607184857.GC23214@somewhere>
References: <1307329858-14999-3-git-send-email-fweisbec@gmail.com>
 <rcu-splat-split-printk@mdm.bga.com>
 <20110606181021.GL3066@linux.vnet.ibm.com>
 <20110607001905.GE17026@somewhere.redhat.com>
 <20110607004250.GZ3066@linux.vnet.ibm.com>
 <20110607013630.GF17026@somewhere.redhat.com>
 <20110607044005.GB2292@linux.vnet.ibm.com>
 <20110607125809.GA23214@somewhere>
 <20110607183414.GF2286@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607183414.GF2286@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 11:34:14AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 07, 2011 at 02:58:13PM +0200, Frederic Weisbecker wrote:
> > On Mon, Jun 06, 2011 at 09:40:05PM -0700, Paul E. McKenney wrote:> 
> > > The bit I am missing is how to distinguish between spinlocks (where
> > > sleeping is illegal) and mutexes (where sleeping is perfectly fine).
> > > We could teach lockdep the difference, I suppose, but it is not clear
> > > to me that it is worth it.
> > 
> > Ah, in fact it doesn't pass through any lockdep check.
> > 
> > It's only a function called might_sleep() that is placed in functions
> > that can sleep. And inside might_sleep() it checks whether it is in a preemptible
> > area. So it's actually locking-agnostic, it only relies on the preempt_count
> > and some more for the preempt rcu cases.
> > 
> > I think it is called CONFIG_DEBUG_SPINLOCK_SLEEP because it was first used
> > for spinlock debugging purposes. But then it has a broader use now: sleep
> > inside preemptible section, sleep inside interrupts, sleep inside rcu.
> 
> But the __might_sleep() function can only differentiate between
> spinlocks and sleeplocks if CONFIG_PREEMPT=y.

It doesn't differentiate between locks but checks on the lowest level
by looking at the preempt count. But yeah it only works if CONFIG_PREEMPT,
which is why I proposed to inc/dec the preempt count also when we have
that DEBUG_SPINLOCK_SLEEP.

> 
> > It certainly deserves a rename, like CONFIG_DEBUG_ILLEGAL_SLEEP.
> 
> Hmmm...  It already checks for sleeping in the middle of a
> preempt_disable() as well as in a spinlock critical section.
> So the need for a rename is independent of any RCU checking.

Sure, rcu just adds itself to the pile of users of might_sleep(), thus
it would be a nice cleanup to rename the option to something more
generic. But that rename is not necessary to improve RCU checking.

> 
> > > In contrast, with RCU, this is straightforward -- check for rcu_sched
> > > and rcu_bh, but not SRCU.
> 
> Actually it makes sense to keep the checks in rcu_note_context_switch(),
> as there are places that call schedule() directly without a might_sleep().
> Perhaps having checks in both places is the correct approach?

In this case it makes more sense to add your checks in schedule_debug(),
so that we don't wait for a context switch to detect the bug.
