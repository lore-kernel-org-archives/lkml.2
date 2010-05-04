Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934584Ab0EDXHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 19:07:43 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49654 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934507Ab0EDXHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 19:07:42 -0400
Date: Tue, 4 May 2010 16:07:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Christopher Li <sparse@chrisli.org>
Subject: Re: [PATCH tip/core/rcu 31/48] rcu: define __rcu address space
 modifier for sparse
Message-ID: <20100504230737.GG2639@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100504201934.GA19234@linux.vnet.ibm.com>
 <1273004398-19760-31-git-send-email-paulmck@linux.vnet.ibm.com>
 <201005042258.20390.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005042258.20390.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 10:58:19PM +0200, Arnd Bergmann wrote:
> On Tuesday 04 May 2010 22:19:41 Paul E. McKenney wrote:
> > This patch defines an __rcu annotation that permits sparse to check for
> > correct use of RCU-protected pointers.  If a pointer that is annotated
> > with __rcu is accessed directly (as opposed to via rcu_dereference(),
> > rcu_assign_pointer(), or one of their variants), sparse can be made
> > to complain.  To enable such complaints, use the new default-disabled
> > CONFIG_SPARSE_RCU_POINTER kernel configuration option.  Please note that
> > these sparse complaints are intended to be a debugging aid, -not- a
> > code-style-enforcement mechanism.
> 
> To add more background, I was thinking that it might make sense to
> always leave the address space attribute in place but to make part
> part of the checking optional.
> 
> The idea would be that we always make sure that an __rcu annotated
> pointer cannot be dereferenced or cast directly, while we would
> only complain about non-annotated pointers being passed to rcu_dereference
> and rcu_assign_pointer if CONFIG_SPARSE_RCU_POINTER is set.
> 
> Most of the work I had spent on my tree was about fixing all the
> false positives from that, but more work would be needed to get
> a clean build from it even with the modified CONFIG_SPARSE_RCU_POINTER
> disabled. Since you managed to find the real bugs and fix them,
> your series by itself is probably more useful than the full set
> that I originally had.

Find thus far -- actually fixing the bugs is still on my list.  ;-)

> > +/*
> > + * Helper functions for rcu_dereference_check(), rcu_dereference_protected()
> > + * and rcu_assign_pointer().  Some of these could be folded into their
> > + * callers, but they are left separate in order to ease introduction of
> > + * multiple flavors of pointers to match the multiple flavors of RCU
> > + * (e.g., __rcu_bh, * __rcu_sched, and __srcu), should this make sense in
> > + * the future.
> > + */
> > +#define __rcu_access_pointer(p, space) \
> > +	({ \
> > +		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> > +		(void) (((typeof (*p) space *)p) == p); \
> > +		((typeof(*p) __force __kernel *)(_________p1)); \
> > +	})
> 
> Do you have specific plans to add these (__rcu_bh etc) back in the future,
> or do you just want to leave the options open?

No specific plans at the moment.  But having the underlying plumbing all
in one place greatly improves the readability.

> Anyway, good to see that you found your way through my patches and got them
> into shape. 

Thank -you- for making this happen!!!

							Thanx, Paul
