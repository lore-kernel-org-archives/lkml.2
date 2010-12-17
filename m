Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0LQPXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:23:02 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34033 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab0LQPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:22:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kmW4tPSBJapMqtmH5c2mg9wjwe/lMvdnlFEuVT5C9021rEynsmULudM5uvXRGF/wvm
         dkKciON5piXVYZK0cfOyYFQ7+IW2muFtvDv1JXOo/h/aZgU6eAqCb+wtdJX9VdisB69C
         xQEjdDRh2nAToaoas6WpdGgAWn7ieLiZMd9p8=
Date: Sat, 18 Dec 2010 00:22:42 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: gerald.schaefer@de.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        paulmck@linux.vnet.ibm.com, Milton Miller <miltonm@bga.com>,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
        Arun Bhanu <ab@arunbhanu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUG?] memory hotplug: include/linux/radix-tree.h:145 invoked
 rcu_dereference_check() without protection!
Message-ID: <20101217152242.GC1609@barrios-desktop>
References: <20101121173726.GG23423@thunk.org>
 <AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
 <rcu-radix-tree@mdm.bga.com>
 <20101122061619.GA2764@linux.vnet.ibm.com>
 <1291748509.19276.62.camel@thinkpad>
 <20101208101947.b0646226.kamezawa.hiroyu@jp.fujitsu.com>
 <1292507421.4885.19.camel@thinkpad>
 <AANLkTinfTCpdKo-A8gF+xbss24PNQXvQV6Odh51mXxiH@mail.gmail.com>
 <20101217083912.GM13914@csn.ul.ie>
 <20101217092828.GN13914@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101217092828.GN13914@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 09:28:28AM +0000, Mel Gorman wrote:
> On Fri, Dec 17, 2010 at 08:39:12AM +0000, Mel Gorman wrote:
> > On Fri, Dec 17, 2010 at 09:04:13AM +0900, Minchan Kim wrote:
> > > On Thu, Dec 16, 2010 at 10:50 PM, Gerald Schaefer
> > > <gerald.schaefer@de.ibm.com> wrote:
> > > > I got the same warning now after increasing /proc/sys/vm/nr_hugepages, see
> > > > below. Both cases are easily reproducible: memory unplug with big page cache,
> > > > or adding large pages during run-time.
> > > >
> > > > ===================================================
> > > > [ INFO: suspicious rcu_dereference_check() usage. ]
> > > > ---------------------------------------------------
> > > > include/linux/radix-tree.h:145 invoked rcu_dereference_check() without protection!
> > > >
> > > > other info that might help us debug this:
> > > >
> > > >
> > > > rcu_scheduler_active = 1, debug_locks = 0
> > > > 1 lock held by bash/761:
> > > >  #0:  (&(&inode->i_data.tree_lock)->rlock){..-.-.}, at: [<00000000002263ae>] migrate_page_move_mapping+0x4a/0x2d8
> > > >
> > > > stack backtrace:
> > > > CPU: 1 Not tainted 2.6.37-rc6 #4
> > > > Process bash (pid: 761, task: 00000000181b5540, ksp: 00000000181bb7f8)
> > > > 00000000181bb818 00000000181bb798 0000000000000002 0000000000000000
> > > >       00000000181bb838 00000000181bb7b0 00000000181bb7b0 000000000056bafa
> > > >       0000000000000000 000000003f42bdf0 0000000000000002 000000001c43be30
> > > >       000003e00000000d 000003e00000000c 00000000181bb800 0000000000000000
> > > >       0000000000000000 0000000000100bfa 00000000181bb798 00000000181bb7d8
> > > > Call Trace:
> > > > ([<0000000000100b02>] show_trace+0xee/0x144)
> > > >  [<000000000022654e>] migrate_page_move_mapping+0x1ea/0x2d8
> > > >  [<0000000000226c80>] migrate_page+0x38/0x68
> > > >  [<0000000000226d9a>] move_to_new_page+0xea/0x2bc
> > > >  [<000000000022785a>] migrate_pages+0x496/0x568
> > > >  [<000000000021e24e>] compact_zone+0x432/0x7d8
> > > >  [<000000000021e772>] compact_zone_order+0x9e/0xbc
> > > >  [<000000000021ed52>] try_to_compact_pages+0x1ba/0x24c
> > > >  [<00000000001e1afa>] __alloc_pages_nodemask+0x86a/0xa64
> > > >  [<000000000021c80c>] alloc_fresh_huge_page.clone.2+0x68/0x18c
> > > >  [<000000000021cc4c>] set_max_huge_pages.clone.0+0xa4/0x1ac
> > > >  [<000000000021ce06>] hugetlb_sysctl_handler+0xb2/0xcc
> > > >  [<00000000002a6572>] proc_sys_call_handler+0xe6/0x10c
> > > >  [<00000000002a65be>] proc_sys_write+0x26/0x34
> > > >  [<00000000002336e0>] vfs_write+0xac/0x18c
> > > >  [<00000000002338bc>] SyS_write+0x58/0xa8
> > > >  [<0000000000113976>] sysc_noemu+0x16/0x1c
> > > >  [<0000020000162edc>] 0x20000162edc
> > > > INFO: lockdep is turned off.
> > > >
> > > > I honestly do not understand 100% why this is a false positive, seeing that
> > > > e.g. find_get_page() will also use radix_tree_deref_slot(), holding only the
> > > > rcu_read_lock, while migrate_page_move_mapping() has no rcu_read_lock() but
> > > > the &mapping->tree_lock instead. So I'm not quite sure how to fix this
> > > > properly, but simply adding rcu_read_lock/unlock() to the affected code paths,
> > > > even if it is not necessary for synchronization, would get rid of the warning,
> > > > like in the following patch. Any ideas?
> > > 
> > > In case of anon page, we hold rcu_read_lock in unmap_and_move.
> > > The problem is file-backed page. In case of that, we hold lock_page
> > > and mapping->tree_lock as update-side lock.
> > > So we don't need rcu_read_lock.
> > > 
> > > >
> > > > ---
> > > >  fs/hugetlbfs/inode.c |    2 ++
> > > >  mm/migrate.c         |    4 ++++
> > > >  2 files changed, 6 insertions(+)
> > > >
> > > > --- a/fs/hugetlbfs/inode.c
> > > > +++ b/fs/hugetlbfs/inode.c
> > > > @@ -580,7 +580,9 @@ static int hugetlbfs_migrate_page(struct
> > > >  {
> > > >        int rc;
> > > >
> > > > +       rcu_read_lock();
> > > >        rc = migrate_huge_page_move_mapping(mapping, newpage, page);
> > > > +       rcu_read_unlock();
> > > >        if (rc)
> > > >                return rc;
> > > >        migrate_page_copy(newpage, page);
> > > > --- a/mm/migrate.c
> > > > +++ b/mm/migrate.c
> > > > @@ -417,7 +417,9 @@ int migrate_page(struct address_space *m
> > > >
> > > >        BUG_ON(PageWriteback(page));    /* Writeback must be complete */
> > > >
> > > > +       rcu_read_lock();
> > > >        rc = migrate_page_move_mapping(mapping, newpage, page);
> > > > +       rcu_read_unlock();
> > > >
> > > >        if (rc)
> > > >                return rc;
> > > > @@ -444,7 +446,9 @@ int buffer_migrate_page(struct address_s
> > > >
> > > >        head = page_buffers(page);
> > > >
> > > > +       rcu_read_lock();
> > > >        rc = migrate_page_move_mapping(mapping, newpage, page);
> > > > +       rcu_read_unlock();
> > > >
> > > >        if (rc)
> > > >                return rc;
> > > >
> > > >
> > > >
> > > 
> > > 
> > > How about this?
> > > Maybe Paul have better idea.
> > > (It's apparently be word-wrapped.)
> > > 
> > 
> > heh, I wrote a patch almost identical to this and ran it overnight for testing
> > (test was a memory consumer running while a parallel process grew and shrunk
> > the hugepage pool). It passes but that is hardly a surprise. We differed
> > slightly in a number of respects though.
> > 
> 
> For completeness, this is what I tested last night. There are two "confirms"
> in the changelog that I intended to work out today but maybe someone can
> confirm faster.
> 
> ==== CUT HERE ====
> mm: migration: Use rcu_dereference_protected when dereferencing the radix tree slot during file page migration
> 
> migrate_pages() -> unmap_and_move() only calls rcu_read_lock() for anonymous
> pages, as introduced by git commit 989f89c57e6361e7d16fbd9572b5da7d313b073d.
> The point of the RCU protection there is part of getting a stable reference
> to anon_vma and is only held for anon pages as file pages are locked
> which is sufficient protection against freeing.
> 
> However, while a file page's mapping is being migrated, the radix tree
> is double checked to ensure it is the expected page. This uses
> radix_tree_deref_slot() -> rcu_dereference() without the RCU lock held
> triggering the following warning.
> 
> [  173.674290] ===================================================
> [  173.676016] [ INFO: suspicious rcu_dereference_check() usage. ]
> [  173.676016] ---------------------------------------------------
> [  173.676016] include/linux/radix-tree.h:145 invoked rcu_dereference_check() without protection!
> [  173.676016]
> [  173.676016] other info that might help us debug this:
> [  173.676016]
> [  173.676016]
> [  173.676016] rcu_scheduler_active = 1, debug_locks = 0
> [  173.676016] 1 lock held by hugeadm/2899:
> [  173.676016]  #0:  (&(&inode->i_data.tree_lock)->rlock){..-.-.}, at: [<c10e3d2b>] migrate_page_move_mapping+0x40/0x1ab
> [  173.676016]
> [  173.676016] stack backtrace:
> [  173.676016] Pid: 2899, comm: hugeadm Not tainted 2.6.37-rc5-autobuild
> [  173.676016] Call Trace:
> [  173.676016]  [<c128cc01>] ? printk+0x14/0x1b
> [  173.676016]  [<c1063502>] lockdep_rcu_dereference+0x7d/0x86
> [  173.676016]  [<c10e3db5>] migrate_page_move_mapping+0xca/0x1ab
> [  173.676016]  [<c10e41ad>] migrate_page+0x23/0x39
> [  173.676016]  [<c10e491b>] buffer_migrate_page+0x22/0x107
> [  173.676016]  [<c10e48f9>] ? buffer_migrate_page+0x0/0x107
> [  173.676016]  [<c10e425d>] move_to_new_page+0x9a/0x1ae
> [  173.676016]  [<c10e47e6>] migrate_pages+0x1e7/0x2fa
> 
> This patch introduces radix_tree_deref_slot_protected() which calls
> rcu_dereference_protected(). Users of it must pass in the mapping->tree_lock
> that is protecting this dereference. Based on the locking hierarchy described
> in mm/filemap.c, holding the tree lock is protecting the radix tree from
> concurrent updaters in all cases (Confirm that no case has been missed).
> According to Documentation/RCU/lockdep.txt, if there is a guarantee that
> no parallel updaters exist, use of rcu_dereference_protected() is allowed
> (Confirm this is accurate?).
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  include/linux/radix-tree.h |   19 +++++++++++++++++++
>  mm/migrate.c               |    4 ++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
> index ab2baa5..252d21c 100644
> --- a/include/linux/radix-tree.h
> +++ b/include/linux/radix-tree.h
> @@ -146,6 +146,25 @@ static inline void *radix_tree_deref_slot(void **pslot)
>  }
>  
>  /**
> + * radix_tree_deref_slot_protected	- dereference a slot without RCU lock but with tree lock held
> + * @pslot:	pointer to slot, returned by radix_tree_lookup_slot
> + * Returns:	item that was stored in that slot with any direct pointer flag
> + *		removed.
> + *
> + * For use with radix_tree_lookup_slot().  Caller must hold tree read
> + * locked across slot lookup and dereference. Not required if write lock is
> + * held (ie. items cannot be concurrently inserted).
> + *
> + * radix_tree_deref_retry must be used to confirm validity of the pointer if
> + * only the read lock is held.
> + */
> +static inline void *radix_tree_deref_slot_protected(void **pslot,
> +							spinlock_t *treelock)
> +{
> +	return rcu_dereference_protected(*pslot, lockdep_is_held(treelock));
> +}

It seems to be good than mine. Just a nitpick.
Can't we get the mutex lock as update-side lock in future?

-- 
Kind regards,
Minchan Kim
