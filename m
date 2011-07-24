Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab1GXAGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 20:06:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:43945 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1GXAFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 20:05:54 -0400
Date: Sun, 24 Jul 2011 02:05:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, laijs@cn.fujitsu.com,
        darren@dvhart.com, rostedt@goodmis.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] rtmutex: Permit rt_mutex_unlock() to be invoked with
 irqs disabled
In-Reply-To: <alpine.LFD.2.02.1107240118550.2702@ionos>
Message-ID: <alpine.LFD.2.02.1107240202500.2702@ionos>
References: <20110719201410.GA10553@linux.vnet.ibm.com> <1311247968.29152.122.camel@twins> <20110723220348.GD2415@linux.vnet.ibm.com> <alpine.LFD.2.02.1107240118550.2702@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011, Thomas Gleixner wrote:

> On Sat, 23 Jul 2011, Paul E. McKenney wrote:
> 
> > On Thu, Jul 21, 2011 at 01:32:48PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2011-07-19 at 13:14 -0700, Paul E. McKenney wrote:
> > > > Because rcu_read_unlock() can be invoked with interrupts disabled, it can
> > > > in turn invoke rt_mutex_unlock() with interrupts disabled.  This situation
> > > > results in lockdep splats (https://lkml.org/lkml/2011/7/7/362) because the
> > > > rt_mutex structure's ->lock_wait is acquired elsewhere without disabling
> > > > interrupts, which can result in deadlocks.
> > > > 
> > > > This commit therefore changes the rt_mutex structure's ->lock_wait
> > > > acquisitions to disable interrupts.
> > > > 
> > > > An alternative fix is to prohibit invoking rcu_read_unlock() with
> > > > interrupts disabled unless the entire preceding RCU read-side critical
> > > > section has run with interrupts disabled.  However, there is already
> > > > at least one case in mainline where this potential rule is violated,
> > > > and there might well be many more.  These would likely be found one at
> > > > a time using the lockdep-water-torture method, hence the alternative
> > > > fix in the form of this commit.
> > > 
> > > Thomas, I'm inclined to merge this, any objections?
> > 
> > FWIW, it has been passing tests here.
> 
> If it's only the unlock path, I'm fine with that change.
> 
> Acked-by-me

Hrmpft. That's requiring all places to take the lock irq safe. Not
really amused. For -RT that's a hotpath and we can really do without
the irq fiddling there. That needs a bit more thought.


 
