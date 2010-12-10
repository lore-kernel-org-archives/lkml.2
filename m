Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab0LJQxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:53:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973Ab0LJQxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:53:32 -0500
Date: Fri, 10 Dec 2010 17:46:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: blk-throttle: Correct the placement of smp_rmb()
Message-ID: <20101210164645.GA4247@redhat.com>
References: <20101208191600.GA32753@redhat.com> <20101208193031.GJ31703@redhat.com> <20101208193308.GA1044@redhat.com> <20101208200750.GA2202@redhat.com> <20101208204624.GK31703@redhat.com> <20101208213331.GA4895@redhat.com> <20101208220640.GB4895@redhat.com> <20101209014519.GO2094@linux.vnet.ibm.com> <20101209092659.GA2569@redhat.com> <20101209194704.GN2239@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209194704.GN2239@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09, Paul E. McKenney wrote:
>
> On Thu, Dec 09, 2010 at 10:26:59AM +0100, Oleg Nesterov wrote:
> >
> > 	update_object(obj)
> > 	{
> > 		modify_obj(obj);
> >
> > 		wmb();
> >
> > 		obj->was_changed = true;
> > 	}
> >
> > It can be called many times. Sooner or later, we will call
> >
> > 	process_object(obj)
> > 	{
> > 		if (!obj->was_changed)
> > 			return;
>
> Ah, and if you have a huge number of CPUs executing update_object()
> at just this point, we have the scenario you showed my in your initial
> email.

Yes.

> 	update_object(obj)
> 	{
> 		modify_obj(obj);
>
> 		wmb();
>
> 		atomic_set(&obj->was_changed, true);
> 	}
>
> 	process_object(obj)
> 	{
> 		if (!atomic_read(&obj->was_changed))
> 			return;
>
> 		if (!atomic_xchg(&obj->was_changed, false))
> 			return;
>
> 		/* mb(); implied by atomic_xchg(), so no longer needed. */
>
> 		do_process_object(obj);
> 	}

This is what we were going to do initially. Except, I think the
plain bool/xchg can be used instead of atomic_t/atomic_xchg ?

But then we decided to discuss the alternatives. Partly because
this looked like the interesting question, but mostly to keep
you busy ;)

> One caution:  The wmb() in update_object() means that modify_object()
> might read some variable and get a -newer- value for that variable than
> would a subsequent read from that same variable in do_process_object().
> If this would cause a problem, the wmb() should instead be an mb().

Yes. And in this case I even _seem_ to understand why we need
s/wmb/mb/ change.

But the original code (I mean, the code we are trying to fix/change)
doesn't have the load-load dependency, so I think wmb() is enough.

> The reason that I say that this should not take much additional
> overhead is that all of the writes were taking cache-miss latencies,
> and you had lots of memory barriers that make it difficult for the
> CPUs' store buffers to hide that latency.  The only added overhead
> is from the atomic instruction, but given that you already had a
> cache miss from the original write and a memory barrier, I would not
> expect it to be noticeable.
>
> But enough time on my soapbox...  Would this do what you need it to?
> If so, hopefully it really does what I think it does.  ;-)

OK, thanks Paul.

So I guess it would be safer to return to initial plan and use xchg().

> (See http://paulmck.livejournal.com/20312.html for explanation.)

Oh. Very interesting. Transitive memory barriers.

You know, I always wanted to understand this aspect. May be you can
look at

	http://marc.info/?l=linux-kernel&m=118944341320665

starting from "To simplify the example above". This pseudo-code tries
to resemble the real-life code we discussed, that is why it uses the
pointers (dereference lack read_barrier_depends(), please ignore).

And no, I can't understand why foo_1() needs the full barrier :/
Or may be I can? Suppose that CPU 0 and CPU 1 share the store-buffer
(no, no, I do not pretend I _really_ understand what this actually
 means;). In this case, perhaps we can forget abou CPU 0 and rewrite
this code as

	void foo_1(void)
	{
		X = 1;	/* it was actually written by CPU 0 */

		r1 = x;
		smp_rmb();  /* The only change. */
		r2 = y;
	}

	void foo_2(void)
	{
		y = 1;
		smp_mb();
		r3 = x;
	}

In this case smp_rmb() obviously can't help. Does it make any sense?


But, when I look at the link I sent you again, I feel I am totatlly
confused. Nothing new, I always knew that memory barriers were specially
designed to drive me crazy.

Oleg.

