Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1DEVy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:54:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58840 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1DEVy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:54:56 -0400
Date: Tue, 5 Apr 2011 14:54:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110405215450.GK2247@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D92DA32.2010809@cn.fujitsu.com>
 <20110330105505.GA3195@sepie.suse.cz>
 <1301482656.4859.171.camel@twins>
 <4D931814.9090100@suse.cz>
 <4D93D29C.5010702@cn.fujitsu.com>
 <1301558691.2250.486.camel@laptop>
 <4D944E60.8080704@cn.fujitsu.com>
 <1301570320.4859.242.camel@twins>
 <4D953121.6090901@cn.fujitsu.com>
 <1301657749.4859.531.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301657749.4859.531.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 01:35:49PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-04-01 at 09:57 +0800, Lai Jiangshan wrote:
> > 
> > We are trying to use inlined read_read_[un]lock(), it is required that sched.h
> > needs include rcupdate.h which causes many recursive including. Splitting rcupdate.h
> > only does not help. 
> 
> You're not making any kind of sense there.
> 
> linux-2.6# cat kernel/sched_tmp.c 
> 
> #include <linux/sched.h>
> 
> linux-2.6# make kernel/sched_tmp.i
> linux-2.6# awk '/^#/ { t=$0 } /rcu_read_lock/ { print t " " $0 }' kernel/sched_tmp.i
> # 60 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline void __rcu_read_lock_bh(void)
> # 60 "/usr/src/linux-2.6/include/linux/rcupdate.h" extern void __rcu_read_lock(void);
> # 258 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline int rcu_read_lock_held(void)
> # 258 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline int rcu_read_lock_bh_held(void)
> # 258 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline int rcu_read_lock_sched_held(void)
> # 559 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline void rcu_read_lock(void)
> # 559 "/usr/src/linux-2.6/include/linux/rcupdate.h"  __rcu_read_lock();
> # 600 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline void rcu_read_lock_bh(void)
> # 600 "/usr/src/linux-2.6/include/linux/rcupdate.h"  __rcu_read_lock_bh();
> # 627 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline void rcu_read_lock_sched(void)
> # 627 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline __attribute__((no_instrument_function)) void rcu_read_lock_sched_notrace(void)
> # 70 "/usr/src/linux-2.6/include/linux/srcu.h" int __srcu_read_lock(struct srcu_struct *sp) ;
> # 103 "/usr/src/linux-2.6/include/linux/srcu.h" static inline int srcu_read_lock_held(struct srcu_struct *sp)
> # 149 "/usr/src/linux-2.6/include/linux/srcu.h" static inline int srcu_read_lock(struct srcu_struct *sp)
> # 149 "/usr/src/linux-2.6/include/linux/srcu.h"  int retval = __srcu_read_lock(sp);
> # 1227 "/usr/src/linux-2.6/include/linux/sched.h"  int rcu_read_lock_nesting;
> # 1786 "/usr/src/linux-2.6/include/linux/sched.h"  p->rcu_read_lock_nesting = 0;
> 
> There isn't a single rcu_read_lock() user in the include chain of
> sched.h, therefore its possible to split rcupdate.h such that one part
> includes the bits needed for sched.h and another part that includes
> sched.h and provides rcu_read_lock().

Yep, you can easily split struct rcu_head out into its own header file,
and then include that into sched.h in place of rcupdate.h without trouble
(at least in the few builds I tried).

The trouble comes when you take the next step and include sched.h
into include/linux/rcutree.h, which would be needed to allow
TREE_PREEMPT_RCU's rcu_read_lock() and rcu_read_unlock() to be
inlined.  This pulls sched.h into files that it was not already
included into, and we do get build failures (the first of which
requires changes local to RCU, FWIW).

Of course, it would be good to straighten this out.

							Thanx, Paul
