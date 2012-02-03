Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2BCFzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 00:55:04 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43615 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2BCFzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 00:55:02 -0500
Date: Thu, 2 Feb 2012 21:54:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 14/41] rcu: Limit lazy-callback duration
Message-ID: <20120203055427.GC2380@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202020356.GL29058@leaf>
 <20120202171342.GP2518@linux.vnet.ibm.com>
 <20120203040751.GA3008@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203040751.GA3008@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020305-3270-0000-0000-000003B311BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 08:07:51PM -0800, Josh Triplett wrote:
> On Thu, Feb 02, 2012 at 09:13:42AM -0800, Paul E. McKenney wrote:
> > On Wed, Feb 01, 2012 at 06:03:56PM -0800, Josh Triplett wrote:
> > > On Wed, Feb 01, 2012 at 11:41:32AM -0800, Paul E. McKenney wrote:
> > > > Currently, a given CPU is permitted to remain in dyntick-idle mode
> > > > indefinitely if it has only lazy RCU callbacks queued.  This is vulnerable
> > > > to corner cases in NUMA systems, so limit the time to six seconds by
> > > > default.  (Currently controlled by a cpp macro.)
> > > 
> > > I wonder: should this scale with the number of callbacks, or do we not
> > > want to make estimates about memory usage based on that?
> > 
> > Interesting.  Which way would you scale it?  ;-)
> 
> Heh, I'd figured "don't wait too long if you have a giant pile of
> callbacks", but I can see how the other direction could make sense as
> well. :)

;-)

> > > Interestingly, with kfree_rcu, we actually know at callback queuing time
> > > *exactly* how much memory we'll get back by calling the callback, and we
> > > could sum up those numbers.
> > 
> > We can indeed calculate for kfree_rcu(), but we won't be able to for
> > call_rcu_lazy(), which is my current approach for cases where you cannot
> > use kfree_rcu() due to (for example) freeing up a linked structure.
> > A very large fraction of the call_rcu()s in the kernel could become
> > call_rcu_lazy().
> 
> So, doing anything other than freeing memory makes a callback non-lazy?
> Based on that, I'd find it at least somewhat surprising if any of the
> current callers of call_rcu (other than synchronize_rcu() and similar)
> had non-lazy callbacks.

Yep!  But the caller has to tell me.

Something like 90% of the call_rcu()s could be call_rcu_lazy(), but there
are a significant number that wake someone up, manipulate a reference
counter that someone else is paying attention to, etc.

> > At some point in the future, it might make sense to tie into the
> > low-memory notifier, which could potentially allow the longer timeout
> > to be omitted.
> 
> Exactly the kind of thing that made me wonder about tracking the actual
> amount of memory to free.  Still seems like a potentially useful
> statistic to track on its own.

There is the qlen statistic in the debugfs tracing, tracked on a per-CPU
basis.  But unless it is kfree_rcu(), I have no way to tell how much
memory a given callback frees.

> > My current guess is that the recent change allowing idle CPUs to
> > exhaust their callback lists will make this kind of fine-tuning
> > unnecessary, but we will see!
> 
> Good point; given that fix, idle CPUs should never need to wake up for
> callbacks at all.

Here is hoping!  ;-)

							Thanx, Paul

