Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab1GMW2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:28:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42076 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1GMW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:28:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=LCbhZmxYpuk3giFRwCfT1go0/EiwIIYHM+EYc1y+6ZG2uZ8+gbkHWquFmWeXUkkQl
	246ayiSLYzuINDnQ4oYGg==
Date: Wed, 13 Jul 2011 15:27:58 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/12] radix_tree: exceptional entries and indices
In-Reply-To: <20110712162431.75bfe77b.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1107131525240.2689@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils> <alpine.LSU.2.00.1106140341070.29206@sister.anvils> <20110617163854.49225203.akpm@linux-foundation.org> <alpine.LSU.2.00.1106171702150.1345@sister.anvils> <20110618144832.cfc665b0.akpm@linux-foundation.org>
 <alpine.LSU.2.00.1107121536100.2112@sister.anvils> <20110712162431.75bfe77b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011, Andrew Morton wrote:
> Hugh Dickins <hughd@google.com> wrote:
> > On Sat, 18 Jun 2011, Andrew Morton wrote:
> > > On Fri, 17 Jun 2011 17:13:38 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> > > > 
> > > > I couldn't see how to use tags without losing the "lockless" lookups:
> > > 
> > > So lockless pagecache broke the radix-tree tag-versus-item coherency as
> > > well as the address_space nrpages-vs-radix-tree coherency.
> > 
> > I don't think that remark is fair to lockless pagecache at all.  If we
> > want the scalability advantage of lockless lookup, yes, we don't have
> > strict coherency with tagging at that time.  But those places that need
> > to worry about that coherency, can lock to do so.
> 
> Nobody thought about these issues, afaik.  Things have broken and the
> code has become significantly more complex/fragile.
> 
> Does the locking in mapping_tagged() make any sense?

Not really, but it's reassuring for mapping_mapped(),
which doesn't know how radix_tree_tagged() is implemented nowadays :)

I think the "lockless pagecache" change there was a blanket replacement
of read_lock_irqsave() by rcu_read_lock().  The effective change came
two years earlier, when radix_tree_tagged() changed from looking at
an array in the rnode to looking at a bit in the root.

> 
> > > Isn't it fun learning these things.
> > > 
> > > > because the tag is a separate bit from the entry itself, unless you're
> > > > under tree_lock, there would be races when changing from page pointer
> > > > to swap entry or back, when slot was updated but tag not or vice versa.
> > > 
> > > So...  take tree_lock?
> > 
> > I wouldn't call that an improvement...
> 
> I wouldn't call the proposed changes to radix-tree.c an improvement,
> either.  It's an expedient, once-off, single-caller hack.

I do hope you're using "radix-tree.c" there as shorthand for the
scattered little additions to filemap.c and radix-tree.h.  (And
I just did a diffstat on the filemap.c changes, they stand at 44
insertions, 44 deletions - mapping_cap_swap_backed stuff goes away.)

The only change to radix-tree.c is adding an indices argument to
radix_tree_gang_lookup_slot() and __lookup(): because hitherto the
gang lookup code has implicitly assumed that it's being used on
struct page pointers, or something like, from which each index
can be deduced by the caller.

Whilst that addition offers nothing to existing users who can deduce
the index of each item found, I claim that it's a clear improvement
to the interface.

If that's unacceptable to you, then perhaps shmem.c needs its own
variant of the code in radix-tree.c, to fill in that lacuna.  I chose
that approach for some parts of the code (e.g. shmem_file_splice_read),
but I'd really prefer not to duplicate large parts of radix-tree.c.
No, it would be better to stick with shmem.c's own peculiar radix tree
in that case, though I don't relish extending it to larger filesizes.

(I should warn that I do have an expedient, once-off, single-caller
hack to come for radix-tree.c.  As was admitted in the changelog, the
loser in these shmem.c changes is swapoff, where shmem_unuse does get
slower.  I had a shock when I found it 20 times slower on this laptop:
though later the most of that turned out to be an artifact of lockdep
and prove_rcu.  But even without the debug, I've found the gang lookup
method too slow, tried a number of different things including tagging,
but the only change which has given clear benefit is doing the lookup
directly on the rnodes, instead of gang lookup going back and forth.)

> 
> If the cost of adding locking is negligible then that is a superior fix.

Various people, first at SGI then more recently at Intel, have chipped
away at the locking in shmem_getpage(), citing this or that benchmark.
Locking here is not negligible for them, and I'm trying to extend their
work, not regress it.

> 
> > > What effect does that have?
> > 
> > ... but admit I have not measured: I rather assume that if we now change
> > tmpfs from lockless to locked lookup, someone else will soon come up with
> > the regression numbers.
> > 
> > > It'd better be
> > > "really bad", because this patchset does nothing at all to improve core
> > > MM maintainability :(
> > 
> > I was aiming to improve shmem.c maintainability; and you have good grounds
> > to accuse me of hurting shmem.c maintainability when I highmem-ized the
> > swap vector nine years ago.
> > 
> > I was not aiming to improve core MM maintainability, nor to harm it.
> > I am extending the use to which the radix-tree can be put, but is that
> > so bad?
> 
> I find it hard to believe that this wart added to the side of the
> radix-tree code will find any other users.  And the wart spreads
> contagion into core filemap pagecache lookup.
> 
> It's pretty nasty stuff.  Please, what is a better way of doing all this?

I cannot offer you a better way of doing this: if I thought there were
a better way, then that's what I would have implemented.  But I can list
some alternative ways, which I think are inferior, but you might prefer.

Though before that, I'd better remind us of the reasons for making any
change at all: support MAX_LFS_FILESIZE; simpler and more maintainable
shmem.c; more scalable shmem_getpage(); less memory consumption.

Alternatives:

1. Stick with the status quo, whether that's defined as what's in
   2.6.39, or what's in 3.0-rc, or what's in 3.0-rc plus mmotm patches
   prior to tmpfs-clone-shmem_file_splice_read, or what's in 3.0-rc plus
   mmotm patches prior to radix_tree-exceptional-entries-and-indices.
   There is one scalability fix in there (tmpfs-no-need-to-use-i_lock),
   and some shmem_getpage simplification, though not as much as I'd like.
   Does nothing for MAX_LFS_FILESIZE, maintainability, memory consumption.

2. Same as 1, plus work to extend shmem's own radix tree (swap vector)
   to MAX_LFS_FILESIZE.  No doubt doable, but reduces maintainabilty,
   increases memory consumption slightly (by added code at least) -
   and FWIW not work that I'm at all attracted to doing!

3. Same as 1, plus work to change shmem over to a different radix tree
   to meet MAX_LFS_FILESIZE: let's use the kind served by radix-tree.c,
   and assume that the indices addition there is acceptable after all.
   Keep away from filemap.c changes by using two radix trees for each
   shmem inode, a pagecache tree and a swap entry tree.  Manage the
   two trees together in the same way as at present, shmem_getpage
   holding info->lock to prevent races between them at awkward moments.
   Improves maintainability (gets rid of the highmem swap vector), may
   reduce memory consumption somewhat (less code, less-than-pagesize
   radix tree nodes), but no scalability or shmem_getpage simplification,
   and less efficient checks on swap entries (more cacheline accesses
   than before) - lowering performance when initially populating pages.

4. Same as 3, but combine those two radix trees into one, since the
   empty slots in one are precisely the occupied slots in the other:
   so fit swap entries into pagecache radix tree in the same spirit
   as we have always fitted swap entries into the pagetables.
   Keep away from filemap.c changes: avoid those unlikely path
   radix_tree_exceptional_entry tests in find_get_page, find_lock_page,
   find_get_pages, find_get_pages_contig by duplicating such code into
   static internal shmem_ variants of each.  May still need a hack in
   invalidate_mapping_pages or find_get_pages, I believe that's one way
   generic code can still arrive at shmem.  Consider tagging swap entries
   instead of marking them exceptional, but I think that will add overhead
   to shmem_getpage and shmem_truncate fast paths (need separate descent
   to tags to get type of each entry found, unless radix-tree.c extended
   to pass that info back from the same descent).  This approach achieves
   most of the goals, but duplicates code, increasing kernel size.

5. What's already in mmotm (plus further comments in filemap.c, and
   radix_tree_locate_item patch to increase speed of shmem swapoff).

Hugh
