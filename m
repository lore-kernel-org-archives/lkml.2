Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2BCJFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:05:09 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38682 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab2BCJFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:05:00 -0500
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.15.19
Date: Fri, 3 Feb 2012 01:04:49 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 03/41] rcu: Add lockdep-RCU checks for
 simple self-deadlock
Message-ID: <20120203090449.GG3008@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202005553.GD29058@leaf>
 <20120202162017.GH2518@linux.vnet.ibm.com>
 <20120202195638.GA9279@leaf>
 <20120202204206.GH2518@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202204206.GH2518@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 12:42:06PM -0800, Paul E. McKenney wrote:
> On Thu, Feb 02, 2012 at 11:56:38AM -0800, Josh Triplett wrote:
> > On Thu, Feb 02, 2012 at 08:20:17AM -0800, Paul E. McKenney wrote:
> > > On Wed, Feb 01, 2012 at 04:55:54PM -0800, Josh Triplett wrote:
> > > > On Wed, Feb 01, 2012 at 11:41:21AM -0800, Paul E. McKenney wrote:
> > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > 
> > > > > It is illegal to have a grace period within a same-flavor RCU read-side
> > > > > critical section, so this commit adds lockdep-RCU checks to splat when
> > > > > such abuse is encountered.  This commit does not detect more elaborate
> > > > > RCU deadlock situations.  These situations might be a job for lockdep
> > > > > enhancements.
> > > > 
> > > > Since doing so also violates the prohibition on blocking within an RCU
> > > > read-side critical section, wouldn't it suffice to call might_sleep() or
> > > > equivalent, which also detects other problems?  (Obviously this doesn't
> > > > apply to SRCU, but it applies to the other variants of RCU.)
> > > 
> > > Yes, but...
> > > 
> > > The advantage of the lockdep-RCU splat is that it gives you a better
> > > hint as to where the RCU read-side critical section was entered, which
> > > is very helpful when tracking these down, especially when they are
> > > intermittent.
> > 
> > Ah, fair enough.
> > 
> > > And yes, I should also well check for the other variants of RCU read-side
> > > critical section (other than RCU).  Done.
> > 
> > Oh?  What hadn't you checked for?
> 
> Things like synchronize_sched() in rcu_read_lock() critical section
> and vice versa.

Ouch.  Good idea.

That also suggests another interesting possibility: lockdep could tag
pointers used in the flavor-specific rcu_dereference variants and
pointers used in the call_rcu variants to make sure nobody uses multiple
variants on the same pointer. :)  (Assuming we don't want
flavor-specific __rcu_* pointer tags.)

Speaking of which, could kfree_rcu require its argument to have the
__rcu type annotation?  We can't necessarily guarantee that for call_rcu
in all cases, but I think we can for kfree_rcu.

- Josh Triplett
