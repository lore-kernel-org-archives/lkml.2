Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395Ab0KQLTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:19:54 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13044 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933515Ab0KQLTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:19:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0DAPJI40x5LdurgWdsb2JhbACiQRYBARYiIsBNhUsE
Date: Wed, 17 Nov 2010 22:19:47 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/28] [rfc] dcache scaling part 1
Message-ID: <20101117111947.GA5218@amd>
References: <20101116140900.039761100@kernel.dk>
 <877hgcrzgd.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877hgcrzgd.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 11:56:02AM +0100, Andi Kleen wrote:
> Nick Piggin <npiggin@kernel.dk> writes:
> 
> > There are 3 main parts to dcache scaling. This one primarily adds new locks
> > to take over dcache_lock, and some pre/post prep and streamlining patches.
> >
> > The second implements fine grained locking, and is rather trivial after
> > part 1.
> >
> > The third implements rcu-walk. rcu-walk depends on the first part, because it
> > relies on using d_lock to protect the state of the dentry (when converting from
> > rcu-walk to refcounted walk). Without the fine grained locing, we'd need to use
> > dcache_lock for that, which would be a step backwards to put into path walking
> > again.
> >
> > Comments?
> 
> I read 15, 10, 8, 5, 4, 3, 1 so far (weird order, it showed that way in
> my reader :-) There was nothing surprising in any of those and they all
> seem to do what the description advertises.

Thanks for looking.

 
> I was scared a bit by the upto 4 level dcache lock nestings, but I
> assume those will get better again when everything is done.
> At least from a quick look they seem to be all in the right order
> (I assume you attempted some runtime coverage with lockdep too, right?)

Yes of course, it's been finding bugs in other code, actually :P

Lock nesting is primarily an issue in killing a dentry, when it needs to
be taken out of several data structures at the same time. I haven't
tackled un-nesting these yet, because things become far more complex
when you start allowing new types of concurrency like that.

I found that with fine grained locking, lock contention was low enough
that it really didn't matter to take a few locks at once (obviously it's
far better than the existing dcache_lock situation).

If it does become a problem, or we want to unwind some of the locks for
any other reason, we'd probably have a DENTRY_TEARDOWN flag in the
dentry, and dput / reclaim can set it without holding other locks, and
then drop the d_lock and individually remove it from various lists.

Of course that requires audits in every list walker, and list_empty() etc
check everywhere, so it's not appropriate for initial patches.
 

> For some of the hash lists it may become attractive to consider
> the newly posted lockless list, but it wasn't fully clear
> if that was easy to do (the lock protected a bit more than
> just the list node)

Well the first part of the series doesn't fine grain the locks, for
the most part. After this is done, it's really pretty trivial to change
locking schemes for data structures.
 

> For the level file system tree sweep changes it would be nice
> if there were semantic patches available. That would make
> it easier to verify the changes have been consistently
> done, by rerunning the patcher.

I haven't looked at doing semantic patches. I suspect it might be
a bit too hard to write.

Really, *most* filesystems do not play silly games with dcache_lock,
and those that don't are pretty easy. Ones that do need more thought
than semantic patch could probably apply.

 
> You can add a Reviewed-by: Andi Kleen <ak@linux.intel.com>
> to the patches listed above.

Thanks,
Nick

