Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0LNHbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 02:31:49 -0500
Received: from smtp-out.google.com ([74.125.121.35]:51639 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab0LNHbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 02:31:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ycgoCbmLrK1km6Xe1+AljDDIBvB10tkQhsJy7O07nONRy2HwxXqzWkJdiwEKD68n+f
         N3LhfvtaS+cHMmH3ccQg==
Date: Mon, 13 Dec 2010 23:31:34 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Miklos Szeredi <miklos@szeredi.hu>,
        Michael Leun <lkml20101129@newton.leun.net>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: kernel BUG at mm/truncate.c:475!
In-Reply-To: <20101213142059.643f8080.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1012132246580.6071@sister.anvils>
References: <20101130194945.58962c44@xenia.leun.net> <alpine.LSU.2.00.1011301453090.12516@tigran.mtv.corp.google.com> <E1PNjsI-0005Bk-NB@pomaz-ex.szeredi.hu> <20101201124528.6809c539@xenia.leun.net> <E1PNqO1-0005px-9h@pomaz-ex.szeredi.hu>
 <20101202084159.6bff7355@xenia.leun.net> <20101202091552.4a63f717@xenia.leun.net> <E1PO5gh-00079U-Ma@pomaz-ex.szeredi.hu> <20101202115722.1c00afd5@xenia.leun.net> <20101203085350.55f94057@xenia.leun.net> <E1PPaIw-0004pW-Mk@pomaz-ex.szeredi.hu>
 <20101206204303.1de6277b@xenia.leun.net> <E1PRQDn-0007jZ-5S@pomaz-ex.szeredi.hu> <20101213142059.643f8080.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010, Andrew Morton wrote:
> On Sat, 11 Dec 2010 15:14:47 +0100
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > On Mon, 6 Dec 2010, Michael Leun wrote:
> > > At the moment I'm trying to create an easy to reproduce scenario.
> > > 
> > 
> > I've managed to reproduce the BUG.  First I thought it has to do with
> > fork() racing with invalidate_inode_pages2_range() but it turns out,
> > just two parallel invocation of invalidate_inode_pages2_range() with
> > some page faults going on can trigger it.

Thanks a lot for working this out, Miklos.

(I don't see any explanation here for the madvise fuzzing page_mapped bug,
but that's not your fault!  I'll have to do my own thinking on that one.)

> > 
> > The problem is: unmap_mapping_range() is not prepared for more than
> > one concurrent invocation per inode.  For example:

Yes, I knowingly built that assumption into it 6 years ago.

> > 
> >   thread1: going through a big range, stops in the middle of a vma and
> >      stores the restart address in vm_truncate_count.
> > 
> >   thread2: comes in with a small (e.g. single page) unmap request on
> >      the same vma, somewhere before restart_address, finds that the
> 
> "restart_addr", please.
> 
> >      vma was already unmapped up to the restart address and happily
> >      returns without doing anything.
> > 
> > Another scenario would be two big unmap requests, both having to
> > restart the unmapping and each one setting vm_truncate_count to its
> > own value.  This could go on forever without any of them being able to
> > finish.
> > 
> > Truncate and hole punching already serialize with i_mutex.  Other
> > callers of unmap_mapping_range() do not, however, and I see difficulty
> > with doing it in the callers.  I think the proper solution is to add
> > serialization to unmap_mapping_range() itself.
> > 
> > Attached patch attempts to do this without adding more fields to
> > struct address_space.  It fixes the bug in my testing.
> > 
> 
> That's a pretty old bug, isn't it?  5+ years.

Did you work out how it came about?  About 2.6.10, I was observing that
unmap_mapping_range() is always called with i_mutex (and usually also
i_alloc_sem) held; whereas around the same time you were adding calls to
unmap_mapping_range() into invalidate_inode_pages2(), which has a much
looser definition than truncation, and does not (necessarily) have
i_mutex held.  We raced.

One fix might be to take i_mutex in invalidate_inode_pages2(); but
I suspect a thorough search would show some calls do already hold it.
Truncation/invalidation have grown a lot more paths since those days,
hard work auditing through them all.  generic_error_remove_page() is
also exceptional to be truncating without i_mutex, but I can never
care very deeply about what might go wrong with hwpoison.

> > 
> > ---
> >  include/linux/pagemap.h |    1 +
> >  mm/memory.c             |   14 ++++++++++++++
> >  2 files changed, 15 insertions(+)
> > 
> > Index: linux.git/include/linux/pagemap.h
> > ===================================================================
> > --- linux.git.orig/include/linux/pagemap.h	2010-11-26 10:52:17.000000000 +0100
> > +++ linux.git/include/linux/pagemap.h	2010-12-11 13:39:32.000000000 +0100
> > @@ -24,6 +24,7 @@ enum mapping_flags {
> >  	AS_ENOSPC	= __GFP_BITS_SHIFT + 1,	/* ENOSPC on async write */
> >  	AS_MM_ALL_LOCKS	= __GFP_BITS_SHIFT + 2,	/* under mm_take_all_locks() */
> >  	AS_UNEVICTABLE	= __GFP_BITS_SHIFT + 3,	/* e.g., ramdisk, SHM_LOCK */
> > +	AS_UNMAPPING	= __GFP_BITS_SHIFT + 4, /* for unmap_mapping_range() */
> >  };
> >  
> >  static inline void mapping_set_error(struct address_space *mapping, int error)
> > Index: linux.git/mm/memory.c
> > ===================================================================
> > --- linux.git.orig/mm/memory.c	2010-12-11 13:07:28.000000000 +0100
> > +++ linux.git/mm/memory.c	2010-12-11 14:09:42.000000000 +0100
> > @@ -2535,6 +2535,12 @@ static inline void unmap_mapping_range_l
> >  	}
> >  }
> >  
> > +static int mapping_sleep(void *x)
> > +{
> > +	schedule();
> > +	return 0;
> > +}
> > +
> >  /**
> >   * unmap_mapping_range - unmap the portion of all mmaps in the specified address_space corresponding to the specified page range in the underlying file.
> >   * @mapping: the address space containing mmaps to be unmapped.
> > @@ -2572,6 +2578,9 @@ void unmap_mapping_range(struct address_
> >  		details.last_index = ULONG_MAX;
> >  	details.i_mmap_lock = &mapping->i_mmap_lock;
> >  
> > +	wait_on_bit_lock(&mapping->flags, AS_UNMAPPING, mapping_sleep,
> > +			 TASK_UNINTERRUPTIBLE);
> > +
> >  	spin_lock(&mapping->i_mmap_lock);
> >  
> >  	/* Protect against endless unmapping loops */
> > @@ -2588,6 +2597,11 @@ void unmap_mapping_range(struct address_
> >  	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
> >  		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
> >  	spin_unlock(&mapping->i_mmap_lock);
> > +
> > +	clear_bit_unlock(AS_UNMAPPING, &mapping->flags);
> > +	smp_mb__after_clear_bit();
> > +	wake_up_bit(&mapping->flags, AS_UNMAPPING);
> > +
> 
> I do think this was premature optimisation.  The open-coded lock is
> hidden from lockdep so we won't find out if this introduces potential
> deadlocks.  It would be better to add a new mutex at least temporarily,
> then look at replacing it with a MiklosLock later on, when the code is
> bedded in.
> 
> At which time, replacing mutexes with MiklosLocks becomes part of a
> general "shrink the address_space" exercise in which there's no reason
> to exclusively concentrate on that new mutex!

Yes, I very much agree with you there: valiant effort by Miklos to
avoid bloat, but we're better off using a known primitive for now.

> 
> How hard is it to avoid adding a new lock and using an existing one,
> presumablt i_mutex?  Because if we can get i_mutex coverage over
> unmap_mapping_range()

invalidate_inode_pages2() calls are the ones to check for that; but I
got tired, and maybe Miklos already found problems with that approach.

> then I suspect all the vm_truncate_count/restart_addr stuff can go away?

That would be lovely, but in fact no: it's guarding against operations on
vmas, things like munmap and mprotect, which can shuffle the prio_tree
when i_mmap_lock is dropped, without i_mutex ever being taken.

However, if we adopt Peter's preemptible mmu_gather patches, i_mmap_lock
becomes a mutex, so there's then no need for any of this (I think Peter
just did a straight conversion here, leaving it in, but it becomes
pointless and would gladly be removed).

Hugh
