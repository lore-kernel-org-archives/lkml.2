Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab2DTSyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:54:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51805 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab2DTSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:54:19 -0400
Date: Fri, 20 Apr 2012 11:54:01 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
In-Reply-To: <20120420004303.GB6871@ZenIV.linux.org.uk>
Message-ID: <alpine.LSU.2.00.1204201133340.1450@eggly.anvils>
References: <1334754302.2137.8.camel@falcor> <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org> <1334772473.2137.22.camel@falcor> <20120418183938.GH6589@ZenIV.linux.org.uk> <1334865448.2429.35.camel@falcor> <20120420004303.GB6871@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012, Al Viro wrote:
> On Thu, Apr 19, 2012 at 03:57:28PM -0400, Mimi Zohar wrote:
> 
> > Has the discussion here moved from deferring the __fput() for the
> > mmap_sem/i_mutex lockdep side case, to taking the i_mutex in __fput() in
> > general?  Lockdep has not reported any problems, other than for the
> > mmap_sem/i_mutex scenario.
> > 
> > > This
> > > is not a way to go; that kind of kludges leads to locking code that is
> > > impossible to reason about.
> > 
> > Are you referring to defering the __fput() or taking the i_mutex in
> > __fput() in general?
> 
> I'm referring to having "are we holding ->mmap_sem" logics anywhere in fput().
> Note that your "lockdep has not reported..." is a symptom of the same
> problem - it's *NOT* enough to show the lack of deadlocks from the change
> of locking rules.  And after that change we'll get even worse situation,
> since proving the safety will become harder (and even more so if we end
> up adding other cases when we need to defer).
> 
> Summary for those who'd been spared the earlier fun: IMA stuff wants to grab
> ->i_mutex on the final fput() in some cases.  That violates the locking
> order in at least one way - final fput() may come under ->mmap_sem, in
> which case grabbing ->i_mutex would be a Bloody Bad Idea(tm).  "Solution"
> proposed: a bit of spectaculary ugly logics checking in final fput() whether
> we have ->mmap_sem locked.  If we do, said final fput() becomes non-final
> and is done asynchronously.  This is fundamentally flawed, of course,
> since "is ->mmap_sem unlocked" is used as "is it safe to have ->i_mutex
> grabbed", and it's both unproven and brittle as hell even if it happens
> to be true right now (and I wouldn't bet on that, TBH).

I can see that the discussion has since moved on quite a way from here.

But it looks to me fairly easy for mm to stop doing fput() under mmap_sem.

That's already the case when exiting (no mmap_sem held), and shouldn't add
observable cost when unmapping (we already work on a chain of vmas to be
freed, and when unmapping that chain will usually just be of one: shouldn't
matter to defer a final pass until after mmap_sem is dropped).  Unless I'm
mistaken, the fput() buried in vma_adjust() can never be a final fput.

Is it worth my trying to implement that?  Or do you see an immediate
gotcha that I'm missing?  Or are you happy enough with your deferred
fput() ideas, that it would be a waste of time to rearrange the mm end?

Hugh

> 
> If it had been IMA alone, I would've cheerfully told them where to stuff
> the whole thing.  Unfortunately, fput() *is* lock-heavy even without them.
> Note that it can easily end up triggering such things as final
> deactivate_super().  Now, ->mmap_sem is irrelevant here - after all,
> any inodes involved won't be mmapped, or deactivate_super() wouldn't
> be final.  However, fput() is called e.g. under rtnl_lock() and I'm
> not at all sure that something like NFS won't try to grab it from its
> ->kill_sb().
> 
> So the question is, do we have any reasonable way to get to the situation
> where the __fput() would only be done without any locks held?  It might
> be worth trying. What we CAN'T do:
> 	* defer all __fput() (i.e. always do final fput() async).  Obviously
> no-go, for performance reasons alone.
> 	* check some predicate about the set of locks held and defer if it's
> false.  That's what IMA folks have tried to do; no-go for the reasons described
> above.
> 	* add a new helper (fput_carefully() or something like that) that would
> defer final __fput(), leaving fput() with the current behaviour.  And convert
> the potentially unsafe callers to it (starting with everything that holds
> ->mmap_sem).  No-go since it's not maintainable - a change pretty far away
> from a function that does (currently safe) fput() can end up requiring the
> conversion to fput_carefully().  Too easy to miss, so this will decay and it
> won't be easy to verify correctness several years down the road.
> 
> However, there's an approach that might be feasible.  Most of the time
> the final fput() *is* done without any locks held and there's a very
> large subclass of those call sites - those that come via fput_light().  
> What we could do, and what might be maintainable is:
> 	* prohibit fput_light() with locks held.  Right now we are very
> close to that (or already there - I haven't finished checking).
> 	* convert low-hanging fget/fput in syscalls to fget_light/fput_light.
> Makes sense anyway.
> 	* split off fput_nodefer() (identical to what fput() is right now),
> make fput_light() call it instead of fput().  Switch path_lookupat() and
> path_openat() to fput_nodefer() as well.  Ditto for sys_socketpair() and
> sys_accept4().
> 	* make fput() (now almost never leading to __fput()) defer the sucker
> in very rare cases when it ends up dropping the last reference.
> At that point we would have __fput() always done without any locks held,
> which would remove all restrictions on the locks that can be taken from it.
> 
> Comments?
> 
> Disclaimer: I have not finished going through the call sites (note that
> there are wrappers - e.g. sockfd_put() *and* sockfd_lookup()), so there might
> be obstacles.  In particular, I'm still not sure about SCM_RIGHTS datagrams
> handling - IIRC, we had an interesting kludge in there, with a kinda-sorta
> deferral/batching.  BTW, I wonder about deadlocks around that one -
> drivers/vhost/net.c is doing ->recvmsg() while holding vq->mutex and if
> an SCM_RIGHTS datagram comes in, we'll get a bunch of fput() done.  Which
> can lead to final umount of a network filesystem, etc.  If that thing can
> lead to handle_rx() on the same sucker, we have a deadlock...
> --
