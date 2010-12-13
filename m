Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0LMDbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:31:20 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4472 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756671Ab0LMDbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:31:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACAhBU15LdLl/2dsb2JhbACjf3nAbIVKBA
Date: Mon, 13 Dec 2010 14:31:10 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: scale vfsmount refcount (was Re: rcu-walk and
 dcache scaling tree update and status)
Message-ID: <20101213033110.GA7898@amd>
References: <20101213023733.GB6522@amd>
 <20101213024217.GC6522@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213024217.GC6522@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 01:42:17PM +1100, Nick Piggin wrote:
> On Mon, Dec 13, 2010 at 01:37:33PM +1100, Nick Piggin wrote:
> > Final note:
> > You won't be able to reproduce the parallel path walk scalability
> > numbers that I've posted, because the vfsmount refcounting scalability
> > patch is not included. I have a new idea for that now, so I'll be asking
> > for comments with that soon.
> 
> Here is the patch I've been using, which works but has the problem
> described in the changelog. But it works nicely for testing.
> 
> As I said, I have a promising approach to solving the problem.
> 
> fs: scale mntget/mntput
 
[...]

> [Note: this is not for merging. Un-attached operation (lazy umount) may not be
>  uncommon and will be slowed down and actually have worse scalablilty after
>  this patch. I need to think about how to do fast refcounting with unattached
>  mounts.]

So the problem this patch tries to fix is vfsmount refcount scalability.
We need to take a ref for every successful path lookup, and often
lookups are going to the same mountpoint.

(Yes this little bouncing atomic hurts, badly, even on my small 2s12c
tightly connected system on the parallel git diff workload -- because
there are other bouncing kernel cachelines in this workload).

The fundamental difficulty is that a simple refcount can never be SMP
scalable, because dropping the ref requires we check whether we are
the last reference (which implies communicating with other CPUs that
might have taken references).

We can make them scalable by keeping a local count, and checking the
global sum less frequently. Some possibilities:

- avoid checking global sum while vfsmount is mounted, because the mount
  contributes to the refcount (that is what this patch does, but it
  kills performance inside a lazy umounted subtree).

- check global sum once every time interval (this would delay mount and
  sb garbage collection, so it's probably a showstopper).

- check global sum only if local sum goes to 0 (this is difficult with
  vfsmounts because the 'get' and the 'put' can happen on different
  CPUs, so we'd need to have a per-thread refcount, or carry around the
  CPU number with the refcount, both get horribly ugly, it turns out).

My proposal is a variant / generalisation of the 1st idea, which is to
have "long" refcounts. Normal refcounts will be per-cpu difference of
incs and decs, but dropping a reference will not have to check the
global sum while "long" refcounts are elevated. If the mount is a long
refcount, then that is what this current patch essentially is.

But then I would also have cwd take the long refcount, which allows
detached operation to remain fast while there are processes working
inside the detached namespace.

Details of locking aren't completely worked out -- it's a bit more
tricky because umount can be much heavier than fork() or chdir(), so
there are some difficulties in making long refcount operations faster
(the problem is remaining race-free versus the fast mntput check, but
I think a seqcount to go with the long refcount should do the trick).

