Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0LITrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:47:10 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42640 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375Ab0LITrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:47:08 -0500
Date: Thu, 9 Dec 2010 11:47:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: blk-throttle: Correct the placement of smp_rmb()
Message-ID: <20101209194704.GN2239@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101208190918.GI31703@redhat.com>
 <20101208191600.GA32753@redhat.com>
 <20101208193031.GJ31703@redhat.com>
 <20101208193308.GA1044@redhat.com>
 <20101208200750.GA2202@redhat.com>
 <20101208204624.GK31703@redhat.com>
 <20101208213331.GA4895@redhat.com>
 <20101208220640.GB4895@redhat.com>
 <20101209014519.GO2094@linux.vnet.ibm.com>
 <20101209092659.GA2569@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209092659.GA2569@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 10:26:59AM +0100, Oleg Nesterov wrote:
> On 12/08, Paul E. McKenney wrote:
> >
> > On Wed, Dec 08, 2010 at 11:06:40PM +0100, Oleg Nesterov wrote:
> >
> > > 	CPU0 does:
> > >
> > > 		A = 1;
> > > 		wmb();
> > > 		B = 1;
> > >
> > > 	CPU1 does:
> > >
> > > 		B = 0;
> > > 		mb();
> > > 		if (A)
> > > 			A = 2;
> > >
> > > My understanding is: after that we can safely assume that
> > >
> > > 	B == 1 || A == 2
> > >
> > > IOW. Either CPU1 notices that A was changed, or CPU0 "wins"
> > > and sets B = 1 "after" CPU1. But, it is not possible that
> > > CPU1 clears B "after" it was set by CPU0 _and_ sees A == 0.
> > >
> > > Is it true? I think it should be true, but can't prove.
> >
> > I was afraid that a question like this might be coming...  ;-)
> 
> I am proud of myself!

;-)

> > The question is whether you can rely on the modification order of the
> > stores to B to deduce anything useful about the order in which the
> > accesses to A occurred.  The answer currently is I believe you can
> > for a simple example such as the one above, but I am checking with
> > the hardware guys.  In addition, please note that I am not sure if
> > all possible generalizations do what you want.  For example, imagine a
> > 1024-CPU system in which the first 1023 CPUs do:
> >
> > 	A[smp_processor_id()] = 1;
> > 	wmb();
> > 	B = smp_processor_id();
> >
> > where the elements of A are cache-line aligned and padded.  Suppose
> > that the remaining CPU does:
> >
> > 	i = random() % 1023;
> > 	B = -1;
> > 	mb();
> > 	if (A[i])
> > 		A[i] = 2;
> >
> > Are we guaranteed that B!=-1||A[i]==2?
> >
> > In this case, it could take all of the CPUs quite some time to come to
> > agreement on the order of all 1024 assignments to B.  I am bugging some
> > hardware guys about this.
> 
> Yes, thanks a lot. Of course, my example was intentionally oversimplified,
> this generalization is closer to the real life.
> 
> > It has been awhile, so they forgot to run
> > away when they saw me coming.  ;-)
> 
> Hehe. I am very glad you didn't run away when you saw another question
> from me ;)

I did seriously consider doing so.  ;-)

> > > 	CPU0:				CPU1:
> > >
> > > 	A = 1;				B = 1;
> > > 	mb();				mb();
> > > 	if (B)				if (A)
> > > 		printf("Yes");			printf("Yes");
> > >
> > > should print "Yes" at least once. This looks very similar to
> > > the the previous example.
> >
> > From a hardware point of view, this example is very different than the
> > earlier one. You are not using the order of independent CPUs' stores to a
> > single variable here and in addition are using mb() everywhere instead of
> > a combination of mb() and wmb().  So, yes, this one is guaranteed to work.
> 
> OK, thanks.
> 
> > But what the heck are you guys really trying to do, anyway?  ;-)
> 
> Vivek has already answered.
> 
> Basically, we have
> 
> 	update_object(obj)
> 	{
> 		modify_obj(obj);
> 
> 		wmb();
> 
> 		obj->was_changed = true;
> 	}
> 
> It can be called many times. Sooner or later, we will call
> 
> 	process_object(obj)
> 	{
> 		if (!obj->was_changed)
> 			return;

Ah, and if you have a huge number of CPUs executing update_object()
at just this point, we have the scenario you showed my in your initial
email.

> 		obj->was_changed = false;
> 
> 		mb();
> 
> 		do_process_object(obj);
> 	}
> 
> All we need is to ensure that eventually do_process_object(obj)
> will see the result of the last invocation of modify_obj().
> 
> IOW. It is fine to miss the changes in obj, but only if
> obj->was_changed continues to be T, in this case process_object()
> will be called again.
> 
> However, if process_object() clears ->was_changed, we must be sure
> that do_process_object() can't miss the result of the previous
> modify_obj().

I am assuming that process_object() executes reasonably infrequently,
or alternatively that there is usually nothing for it to do.  If my
assumption is correct, I suggest the following, which should not add
much additional overhead and should work regardless of what the hardware
guys end up telling me.  But I am checking with the hardware guys about
this one as well, just in case I have managed to get myself confused.
It wouldn't be the first time...  :-/

	update_object(obj)
	{
		modify_obj(obj);

		wmb();

		atomic_set(&obj->was_changed, true);
	}

	process_object(obj)
	{
		if (!atomic_read(&obj->was_changed))
			return;

		if (!atomic_xchg(&obj->was_changed, false))
			return;

		/* mb(); implied by atomic_xchg(), so no longer needed. */

		do_process_object(obj);
	}

One caution:  The wmb() in update_object() means that modify_object()
might read some variable and get a -newer- value for that variable than
would a subsequent read from that same variable in do_process_object().
If this would cause a problem, the wmb() should instead be an mb().
(See http://paulmck.livejournal.com/20312.html for explanation.)

The reason that I say that this should not take much additional
overhead is that all of the writes were taking cache-miss latencies,
and you had lots of memory barriers that make it difficult for the
CPUs' store buffers to hide that latency.  The only added overhead
is from the atomic instruction, but given that you already had a
cache miss from the original write and a memory barrier, I would not
expect it to be noticeable.

But enough time on my soapbox...  Would this do what you need it to?
If so, hopefully it really does what I think it does.  ;-)

							Thanx, Paul
