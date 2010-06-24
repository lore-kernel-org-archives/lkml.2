Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0FXRWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 13:22:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42150 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0FXRWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:22:21 -0400
Subject: Re: [patch 16/52] fs: dcache RCU for multi-step operaitons
From: john stultz <johnstul@us.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Frank Mayhar <fmayhar@google.com>
In-Reply-To: <20100624150334.GE10441@laptop>
References: <20100624030212.676457061@suse.de>
	 <20100624030728.129875799@suse.de> <1277366290.1875.891.camel@laptop>
	 <20100624150334.GE10441@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 10:22:11 -0700
Message-ID: <1277400131.15264.29.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 01:03 +1000, Nick Piggin wrote:
> On Thu, Jun 24, 2010 at 09:58:10AM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> > > plain text document attachment (fs-dcache_lock-multi-step.patch)
> > > The remaining usages for dcache_lock is to allow atomic, multi-step read-side
> > > operations over the directory tree by excluding modifications to the tree.
> > > Also, to walk in the leaf->root direction in the tree where we don't have
> > > a natural d_lock ordering.
> > > 
> > > This could be accomplished by taking every d_lock, but this would mean a
> > > huge number of locks and actually gets very tricky.
> > > 
> > > Solve this instead by using the rename seqlock for multi-step read-side
> > > operations. Insert operations are not serialised. Delete operations are
> > > tricky when walking up the directory our parent might have been deleted
> > > when dropping locks so also need to check and retry for that.
> > > 
> > > XXX: hmm, we could of course just take the rename lock if there is any worry
> > > about livelock. Most of these are slow paths.
> > 
> > 
> > Ah, does this address John's issue? 
> 
> This is where John's issue is introduced. I actually again couldn't
> see the problem (thought I saw a problem, then lost it!).

Ok. So I need to review this new set in full, but the issue we tripped
with the patches in -rt was the following:

In select parent, when it does the dentry ascending, it has to release
the current dentry lock so it can aquire the parents dentry (for proper
ordering). At the point it released the lock, before it grabs the
parent's lock, there is nothing that is preventing dput from being
called on the next dentry, it grabbing the parent and dentry's d_lock
and killing it. Then back in select_parent, when we try to lock the next
entry, it no longer exists and we oops.

So I can't see anything that is protecting the dentry (or even the new
parent dentry, should everything be killed under it) at this point. The
dentries d_count might be zero, we don't hold the d_lock, and we don't
hold the parent's d_lock. What am I missing here?


> Got to think about it and test more... I couldn't reproduce the problem
> mind you, but I was testing mainline wheras bug was seen on -rt.

Yea, -rt may be allowing the race to more easily occur (I only found I
could trigger it on a UP machine) since we can be preempted right after
we released the dentry lock as we tried to grab the parent. Then dput
would jump in and wreck things. I had some pretty clear trace logs that
were easily repeated (well, took about an hour or two to trigger), that
showed about the same order of operations every time.

I don't remember if there's another lock being held at the point
select_parent is called, so on mainline it might be harder to trigger
(having to actually get the dput race on another cpu timed right).


thanks
-john


