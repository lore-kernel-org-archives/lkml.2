Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1FGM6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:58:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48594 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab1FGM6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NEGdfusbcN4h82ciehsumSTw8+KBLRiA2AFx2dwwA37PhinT7lJbSb9cQE28PojGWQ
         76xuFYx3HZRha4cm2Clv6CxrbqKwXaevBHOPYN8ZV/syRyum9D++cmeL/22Waq7M6/cR
         AgGGRVj0Y5laUb59WitDAmjNgtJAlOy1WguUg=
Date: Tue, 7 Jun 2011 14:58:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [1/4] rcu: Detect uses of rcu read side in extended quiescent
 states
Message-ID: <20110607125809.GA23214@somewhere>
References: <1307329858-14999-3-git-send-email-fweisbec@gmail.com>
 <rcu-splat-split-printk@mdm.bga.com>
 <20110606181021.GL3066@linux.vnet.ibm.com>
 <20110607001905.GE17026@somewhere.redhat.com>
 <20110607004250.GZ3066@linux.vnet.ibm.com>
 <20110607013630.GF17026@somewhere.redhat.com>
 <20110607044005.GB2292@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607044005.GB2292@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 09:40:05PM -0700, Paul E. McKenney wrote:> 
> The bit I am missing is how to distinguish between spinlocks (where
> sleeping is illegal) and mutexes (where sleeping is perfectly fine).
> We could teach lockdep the difference, I suppose, but it is not clear
> to me that it is worth it.

Ah, in fact it doesn't pass through any lockdep check.

It's only a function called might_sleep() that is placed in functions
that can sleep. And inside might_sleep() it checks whether it is in a preemptible
area. So it's actually locking-agnostic, it only relies on the preempt_count
and some more for the preempt rcu cases.

I think it is called CONFIG_DEBUG_SPINLOCK_SLEEP because it was first used
for spinlock debugging purposes. But then it has a broader use now: sleep
inside preemptible section, sleep inside interrupts, sleep inside rcu.

It certainly deserves a rename, like CONFIG_DEBUG_ILLEGAL_SLEEP.

> 
> In contrast, with RCU, this is straightforward -- check for rcu_sched
> and rcu_bh, but not SRCU.
> 
> 							Thanx, Paul
> 
