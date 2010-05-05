Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0EEXGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 19:06:05 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57135 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab0EEXGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 19:06:01 -0400
Date: Wed, 5 May 2010 16:05:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/rcu 01/48] rcu: optionally leave lockdep
	enabled after RCU lockdep splat
Message-ID: <20100505230557.GD2439@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100504201934.GA19234@linux.vnet.ibm.com>
 <1273004398-19760-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100505224641.GA15359@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505224641.GA15359@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 06:46:41PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > From: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > There is no need to disable lockdep after an RCU lockdep splat,
> > so remove the debug_lockdeps_off() from lockdep_rcu_dereference().
> > To avoid repeated lockdep splats, use a static variable in the inlined
> > rcu_dereference_check() and rcu_dereference_protected() macros so that
> > a given instance splats only once, but so that multiple instances can
> > be detected per boot.
> > 
> > This is controlled by a new config variable CONFIG_PROVE_RCU_REPEATEDLY,
> > which is disabled by default.  This provides the normal lockdep behavior
> > by default, but permits people who want to find multiple RCU-lockdep
> > splats per boot to easily do so.
> 
> I'll play the devil's advocate here. (just because that's so much fun)
> ;-)
> 
> If we look at:
> 
> include/linux/debug_locks.h:
> 
> static inline int __debug_locks_off(void)
> {
>         return xchg(&debug_locks, 0);
> }
> 
> We see that all code following a call to "debug_locks_off()" can assume
> that it cannot possibly run concurrently with other code following
> "debug_locks_off()". Now, I'm not saying that the code we currently have
> will necessarily break, but I think it is worth asking if there is any
> assumption in lockdep (or RCU lockdep more specifically) about mutual
> exclusion after debug_locks_off() ?
> 
> Because if there is, then this patch is definitely breaking something by
> not protecting lockdep against multiple concurrent executions.

So what in lockdep_rcu_dereference() needs to be protected from concurrent
execution?  All that happens beyond that point is a bunch of printk()s,
printing the locks held by this task, and dumping this task's stack.

							Thanx, Paul
