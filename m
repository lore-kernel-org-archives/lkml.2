Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0JTDFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:05:09 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:44106 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926Ab0JTDFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:05:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMj4vUx5LdoF/2dsb2JhbAChVnLCZYJ4glIE
Date: Wed, 20 Oct 2010 14:05:01 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 00/35] my inode scaling series for review
Message-ID: <20101020030501.GG3740@amd>
References: <20101019034216.319085068@kernel.dk>
 <20101019162207.GA3555@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019162207.GA3555@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:22:07PM -0400, Christoph Hellwig wrote:
> On Tue, Oct 19, 2010 at 02:42:16PM +1100, npiggin@kernel.dk wrote:
> > * My locking design allows i_lock to lock the entire state of the icache
> >   for a particular inode. Not so with Dave's, and he had to add code not
> >   required with inode_lock synchronisation or my i_lock synchronisation.
> >   I prefer being very conservative about making changes, especially before
> >   inode_lock is lifted (which will be the end-point of bisection for any
> >   locking breakage before it).
> 
> Which code exaxtly?  I've done a diff between his inode.c and yours - 

I pointed it out earlier (not that you replied).

> and Dave's is a lot simpler.  Mostly due to the more regular and simpler
> locking, but also because he did various cleanups before tackling the
> actual locking.  See the diff at the end of this mail for a direct
> comparism.

How can you say it is more regular and simpler locking? _Acquiring_
locks is not the difficult part of a locking rewrite. Verifying that
no unhandled concurrency is introduced is.

At first glance there are parts of my code that is more complex, that
is because it is actually more regular locking model that is easier to
verify when you lift inode_lock away.

Like I said to Dave when he first looked at my series: he's welcome to
submit a small incremental change to reduce i_lock coverage or put
the lock order another way and we can see what the impact looks like.

Locking changes should start simpler and more conservative.

 
> > * As far as I can tell, I have addressed all Dave and Christoph's real
> >   concerns.  The disagreement about the i_lock locking model can easily be
> >   solved if they post a couple of small incremental patches to the end of the
> >   series, making i_lock locking less regular and no longer protecting icache
> >   state of that given inode (like inode_lock was able to pre-patchset). I've
> >   repeatedly disagreed with this approach, however.
> 
> The diff below and looking over the other patches doesn't make it look
> like you have actually picked up much at all, neither of the feedback
> from me, nor Dave nor Andrew or Al. 

I picked up most of it. I missed the per-cpu one from Andrew because
I was waiting for Eric's new API.

I did pick up feedback from you or Dave, and where I didn't, I replied
with my reasons.


> Even worse than that none of the sometimes quite major bug fixes were
> picked up either.  The get_new_inode re-lookup locking is still wrong,

I see, yes, I missed that point.


> the exofs fix is not there.

It doesn't belong there.


> And the fix for mapping move of the
> block devices which we unfortunately still have seems to be paper
> over by passing the bdi_writeback to the requing helpers instead
> of fixing it.  While this makes the assert_spin_lock panic go away
> it still leaves a really nasty race as your version locks a different
> bdi than the one that it actually modifies.

Yeah Dave's fix got omitted from my series for some reason. I
agreed it is needed and I just had it commented out for some
reason. Thanks.

 
> There's also another bug which was there in your very first version
> with an XXX but that Dave AFAIK never picked up: invalidate_inodes is
> called from a lot of other places than umount, and unlocked list
> access is everything but safe there.

No, I didn't ignore that. It is quite definitely already buggy upstream
if there is concurrent list modification there. I noticed that Al was
thinking about it and I was going to wait until he replied with
something definitive.


> Anyway, below is the diff between the two trees.  I've cut down the
> curn in filesystem a bit - every related to the gratious i_ref vs i_ref
> and iref vs inode_get difference, as well as the call_rcu boilerplat
> additions and get_next_ino calls are removed to make it somewhat
> readable.
> 
> To me the inode.c and especially fs-writeback.c code in Dave's version
> looks a lot more polished.

Well, like I said, I disagree. I don't like how the icache state
of the inode is not locked (as it is with inode_lock) when the
inode is being manipulated.

I see any such step in that direction as an incremental patch,
and shouldn't be lumped in with lock breaking work. That's just
not how to structure a series that adds fine grained locking.
As I said, I am willing to review and comment on such an incremental
patch with an open mind. But I would have to see a good justification
and a reason why RCU or another technique would not work.

You also missed my feedback that he didn't add required RCU, didn't
structure the series properly for a serious scalability rework,
didn't break out the rest of the global locks, and hadn't had it
tested with the rest of the vfs stack.

But your review so far has been very helpful, thanks.

