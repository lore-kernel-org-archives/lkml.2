Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2BBQlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:41:25 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42076 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab2BBQlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:41:23 -0500
Date: Thu, 2 Feb 2012 08:34:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 05/41] rcu: Avoid waking up CPUs having
 only kfree_rcu() callbacks
Message-ID: <20120202163435.GK2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202011552.GG29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202011552.GG29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020216-1976-0000-0000-00000A12681F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 05:15:52PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:23AM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > When CONFIG_RCU_FAST_NO_HZ is enabled, RCU will allow a given CPU to
> > enter dyntick-idle mode even if it still has RCU callbacks queued.
> > RCU avoids system hangs in this case by scheduling a timer for several
> > jiffies in the future.  However, if all of the callbacks on that CPU
> > are from kfree_rcu(), there is no reason to wake the CPU up, as it is
> > not a problem to defer freeing of memory.
> > 
> > This commit therefore tracks the number of callbacks on a given CPU
> > that are from kfree_rcu(), and avoids scheduling the timer if all of
> > a given CPU's callbacks are from kfree_rcu().
> 
> Minor nit: I think it would make much more sense to track the number of
> "strict" callbacks *not* from kfree_rcu, and check for that number != 0,
> rather than tracking the number of "lazy" callbacks from kfree_rcu and
> checking for all != lazy.  You can always compute one number from the
> other, but since you only ever need to know the strict count, not the
> lazy count, why not directly track the thing you care about?

I will think about this.  My guess is that when I add call_rcu_lazy(),
the naming will outweigh the slowpath subtraction, but will see.

> Also, any way this could hide the new kfree_call_rcu internally rather
> than adding it as a new export?  In particular, why introduce a new
> exported API only suitable for internal use or foot-shooting?

It is called from __kfree_rcu, which is a static inline in
include/linux/rcupdate.h, so needs to be exported so that modules can
use kfree_rcu().

Of course, if I take the earlier patch that removes the first
BUILD_BUG_ON() from __kfree_rcu(), then I could move __kfree_rcu()
to rcupdate.c, and then I could move the export from kfree_call_rcu()
to __kfree_rcu().  But either way I would be exporting a function that
should not be invoked directly.

My concern with the earlier patch is that someone might have something
silly like a structure with an array with an rcu_head in each element.
Calling kfree_rcu() on such a beast would be ill-advised.  This might
just be me being overly paranoid, though, hence my lack of additional
response to that patch.

							Thanx, Paul

