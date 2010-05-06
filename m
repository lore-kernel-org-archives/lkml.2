Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab0EFXJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:09:26 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43292 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab0EFXJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:09:25 -0400
Date: Thu, 6 May 2010 16:09:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/rcu 01/48] rcu: optionally leave lockdep
	enabled after RCU lockdep splat
Message-ID: <20100506230917.GJ2325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100504201934.GA19234@linux.vnet.ibm.com>
 <1273004398-19760-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100505224641.GA15359@Krystal>
 <20100505230557.GD2439@linux.vnet.ibm.com>
 <20100505232457.GA1313@Krystal>
 <20100505233601.GG2439@linux.vnet.ibm.com>
 <20100506020532.GA16547@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506020532.GA16547@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 10:05:32PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Wed, May 05, 2010 at 07:24:57PM -0400, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Wed, May 05, 2010 at 06:46:41PM -0400, Mathieu Desnoyers wrote:
> > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > From: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > > > > 
> > > > > > There is no need to disable lockdep after an RCU lockdep splat,
> > > > > > so remove the debug_lockdeps_off() from lockdep_rcu_dereference().
> > > > > > To avoid repeated lockdep splats, use a static variable in the inlined
> > > > > > rcu_dereference_check() and rcu_dereference_protected() macros so that
> > > > > > a given instance splats only once, but so that multiple instances can
> > > > > > be detected per boot.
> > > > > > 
> > > > > > This is controlled by a new config variable CONFIG_PROVE_RCU_REPEATEDLY,
> > > > > > which is disabled by default.  This provides the normal lockdep behavior
> > > > > > by default, but permits people who want to find multiple RCU-lockdep
> > > > > > splats per boot to easily do so.
> > > > > 
> > > > > I'll play the devil's advocate here. (just because that's so much fun)
> > > > > ;-)
> > > > > 
> > > > > If we look at:
> > > > > 
> > > > > include/linux/debug_locks.h:
> > > > > 
> > > > > static inline int __debug_locks_off(void)
> > > > > {
> > > > >         return xchg(&debug_locks, 0);
> > > > > }
> > > > > 
> > > > > We see that all code following a call to "debug_locks_off()" can assume
> > > > > that it cannot possibly run concurrently with other code following
> > > > > "debug_locks_off()". Now, I'm not saying that the code we currently have
> > > > > will necessarily break, but I think it is worth asking if there is any
> > > > > assumption in lockdep (or RCU lockdep more specifically) about mutual
> > > > > exclusion after debug_locks_off() ?
> > > > > 
> > > > > Because if there is, then this patch is definitely breaking something by
> > > > > not protecting lockdep against multiple concurrent executions.
> > > > 
> > > > So what in lockdep_rcu_dereference() needs to be protected from concurrent
> > > > execution?  All that happens beyond that point is a bunch of printk()s,
> > > > printing the locks held by this task, and dumping this task's stack.
> > > > 
> > > > 							Thanx, Paul
> > > 
> > > I agree with you that printing the current task information should be safe.
> > > However, I am not sure that concurrent updates to the lock_class while printk()
> > > is showing its information will end up doing what we expect it to do.
> > > 
> > > It could be acceptable to have unreliable information in these rare cases, but
> > > the important thing would be to ensure that the kernel does not OOPS.
> > 
> > But any races other than the printk()s can already happen as follows:
> > 
> > o	CPU 0 needs to update some information about the lock.  It
> > 	checks debug_locks and finds that it is non-zero.
> > 
> > o	CPU 1 detects a deadlock, and invokes __debug_locks_off(),
> > 	which atomically sets debug_locks to zero.
> > 
> > o	CPU 1 then proceeds to printk() information that CPU 0
> > 	is concurrently modifying.  Which looks to be OK in any case.
> > 
> > Or is there some other race that cannot already happen that I am
> > introducing?
> 
> Nope, I don't think so. Although it's probably worth putting a comment in
> lockdep_rcu_dereference() to state that lockdep can be used by multiple
> concurrent instances here, just in case someone ever consider adding code
> to this splat handler thinking lockdep is always only used by a single "splat"
> at a time.

Done!

							Thanx, Paul
