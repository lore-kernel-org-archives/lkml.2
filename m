Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0LQPIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:08:42 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58180 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab0LQPIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:08:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=d7jzepyV61/mchRC3ioqoJ4CK+47G+gx4nMm0qASyFWIDvmvC+oKHnh1YI+8DG8/7N
         haogHzE7dPxpN+LYGigaF1R+S0xyu7TtJ1x0fsfURyknTo/TJphnokidln/Uuh/bu0h1
         beJYd9R8wE+0TRiZKYgukp8QXiTAYVOUvV7iY=
Date: Sat, 18 Dec 2010 00:08:27 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: gerald.schaefer@de.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, linux-ext4@vger.kernel.org,
        "Ted Ts'o" <tytso@mit.edu>, Arun Bhanu <ab@arunbhanu.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUG?] memory hotplug: include/linux/radix-tree.h:145 invoked
 rcu_dereference_check() without protection!
Message-ID: <20101217150827.GA1609@barrios-desktop>
References: <20101121153949.GD20947@barrios-desktop>
 <20101121173726.GG23423@thunk.org>
 <AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
 <rcu-radix-tree@mdm.bga.com>
 <20101122061619.GA2764@linux.vnet.ibm.com>
 <1291748509.19276.62.camel@thinkpad>
 <20101208101947.b0646226.kamezawa.hiroyu@jp.fujitsu.com>
 <1292507421.4885.19.camel@thinkpad>
 <AANLkTinfTCpdKo-A8gF+xbss24PNQXvQV6Odh51mXxiH@mail.gmail.com>
 <20101217054722.GG2253@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101217054722.GG2253@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 09:47:22PM -0800, Paul E. McKenney wrote:
> On Fri, Dec 17, 2010 at 09:04:13AM +0900, Minchan Kim wrote:
> > On Thu, Dec 16, 2010 at 10:50 PM, Gerald Schaefer
> > <gerald.schaefer@de.ibm.com> wrote:
> > > I got the same warning now after increasing /proc/sys/vm/nr_hugepages, see
> > > below. Both cases are easily reproducible: memory unplug with big page cache,
> > > or adding large pages during run-time.
> > >
> > > ===================================================
> > > [ INFO: suspicious rcu_dereference_check() usage. ]
> > > ---------------------------------------------------
> > > include/linux/radix-tree.h:145 invoked rcu_dereference_check() without protection!
> > >
> > > other info that might help us debug this:
> > >
> > >
> > > rcu_scheduler_active = 1, debug_locks = 0
> > > 1 lock held by bash/761:
> > >  #0:  (&(&inode->i_data.tree_lock)->rlock){..-.-.}, at: [<00000000002263ae>] migrate_page_move_mapping+0x4a/0x2d8
> > >
> > > stack backtrace:
> > > CPU: 1 Not tainted 2.6.37-rc6 #4
> > > Process bash (pid: 761, task: 00000000181b5540, ksp: 00000000181bb7f8)
> > > 00000000181bb818 00000000181bb798 0000000000000002 0000000000000000
> > >       00000000181bb838 00000000181bb7b0 00000000181bb7b0 000000000056bafa
> > >       0000000000000000 000000003f42bdf0 0000000000000002 000000001c43be30
> > >       000003e00000000d 000003e00000000c 00000000181bb800 0000000000000000
> > >       0000000000000000 0000000000100bfa 00000000181bb798 00000000181bb7d8
> > > Call Trace:
> > > ([<0000000000100b02>] show_trace+0xee/0x144)
> > >  [<000000000022654e>] migrate_page_move_mapping+0x1ea/0x2d8
> > >  [<0000000000226c80>] migrate_page+0x38/0x68
> > >  [<0000000000226d9a>] move_to_new_page+0xea/0x2bc
> > >  [<000000000022785a>] migrate_pages+0x496/0x568
> > >  [<000000000021e24e>] compact_zone+0x432/0x7d8
> > >  [<000000000021e772>] compact_zone_order+0x9e/0xbc
> > >  [<000000000021ed52>] try_to_compact_pages+0x1ba/0x24c
> > >  [<00000000001e1afa>] __alloc_pages_nodemask+0x86a/0xa64
> > >  [<000000000021c80c>] alloc_fresh_huge_page.clone.2+0x68/0x18c
> > >  [<000000000021cc4c>] set_max_huge_pages.clone.0+0xa4/0x1ac
> > >  [<000000000021ce06>] hugetlb_sysctl_handler+0xb2/0xcc
> > >  [<00000000002a6572>] proc_sys_call_handler+0xe6/0x10c
> > >  [<00000000002a65be>] proc_sys_write+0x26/0x34
> > >  [<00000000002336e0>] vfs_write+0xac/0x18c
> > >  [<00000000002338bc>] SyS_write+0x58/0xa8
> > >  [<0000000000113976>] sysc_noemu+0x16/0x1c
> > >  [<0000020000162edc>] 0x20000162edc
> > > INFO: lockdep is turned off.
> > >
> > > I honestly do not understand 100% why this is a false positive, seeing that
> > > e.g. find_get_page() will also use radix_tree_deref_slot(), holding only the
> > > rcu_read_lock, while migrate_page_move_mapping() has no rcu_read_lock() but
> > > the &mapping->tree_lock instead. So I'm not quite sure how to fix this
> > > properly, but simply adding rcu_read_lock/unlock() to the affected code paths,
> > > even if it is not necessary for synchronization, would get rid of the warning,
> > > like in the following patch. Any ideas?
> > 
> > In case of anon page, we hold rcu_read_lock in unmap_and_move.
> > The problem is file-backed page. In case of that, we hold lock_page
> > and mapping->tree_lock as update-side lock.
> > So we don't need rcu_read_lock.
> > 
> > >
> > > ---
> > >  fs/hugetlbfs/inode.c |    2 ++
> > >  mm/migrate.c         |    4 ++++
> > >  2 files changed, 6 insertions(+)
> > >
> > > --- a/fs/hugetlbfs/inode.c
> > > +++ b/fs/hugetlbfs/inode.c
> > > @@ -580,7 +580,9 @@ static int hugetlbfs_migrate_page(struct
> > >  {
> > >        int rc;
> > >
> > > +       rcu_read_lock();
> > >        rc = migrate_huge_page_move_mapping(mapping, newpage, page);
> > > +       rcu_read_unlock();
> > >        if (rc)
> > >                return rc;
> > >        migrate_page_copy(newpage, page);
> > > --- a/mm/migrate.c
> > > +++ b/mm/migrate.c
> > > @@ -417,7 +417,9 @@ int migrate_page(struct address_space *m
> > >
> > >        BUG_ON(PageWriteback(page));    /* Writeback must be complete */
> > >
> > > +       rcu_read_lock();
> > >        rc = migrate_page_move_mapping(mapping, newpage, page);
> > > +       rcu_read_unlock();
> > >
> > >        if (rc)
> > >                return rc;
> > > @@ -444,7 +446,9 @@ int buffer_migrate_page(struct address_s
> > >
> > >        head = page_buffers(page);
> > >
> > > +       rcu_read_lock();
> > >        rc = migrate_page_move_mapping(mapping, newpage, page);
> > > +       rcu_read_unlock();
> > >
> > >        if (rc)
> > >                return rc;
> > >
> > >
> > >
> > 
> > 
> > How about this?
> > Maybe Paul have better idea.
> > (It's apparently be word-wrapped.)
> > 
> > diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
> > index ab2baa5..135af1e 100644
> > --- a/include/linux/radix-tree.h
> > +++ b/include/linux/radix-tree.h
> > @@ -146,6 +146,20 @@ static inline void *radix_tree_deref_slot(void **pslot)
> >  }
> > 
> >  /**
> > + * radix_tree_deref_slot_nocheck       - dereference a slot without RCU check
> > + * @pslot:     pointer to slot, returned by radix_tree_lookup_slot
> > + * Returns:    item that was stored in that slot with any direct pointer flag
> > + *             removed.
> > + *
> > + * This functions works like radix_tree_deref_slot except it doesn't check
> > + * RCU rule. Normally this funcion is used with update-side lock.
> > + * You should use this function very carefully.
> > + */
> > +static inline void *radix_tree_deref_slot_nocheck(void **pslot)
> > +{
> > +       return rcu_dereference_protected(*pslot, 1);
> 
> I suggest replacing the "1" with lockdep expressions for the locks
> that you say might be held:

It's not hard.

> 
> 	return rcu_dereference_check(*pslot,
> 				     lockdep_is_held(&mapping->tree_lock));

rcu_dereference_check still pass rcu_read_lock_held check we don't want.
I think rcu_dereference_protected is proper.

Why I don't add lockdep expressions is radix_tree_deref_slot is general API.
It might be used anywhere where it doesn't related to mapping->tree_lock.
If we add argument 'mapping', it has a very strong dependency with address_space.
so I decided making the function general and then caller must use it very carefully.
But I am not strong in this point.

> 
> This assumes that when you said "and" you meant both lock_page() and
> mapping->tree_lock.  Also you need to pass in the mapping, which
> should not be a problem given likely inlining.
> 
> If you meant that either mapping->tree_lock or page_lock() might be
> held, I suppose that the page_lock() state could be passed in, but
> perhaps better to take a general lockdep expression.
> 
> So, either or both?  ;-)
> 
> 						Thanx, Paul

I think either is okay. That's because remove_from_page_cache/__remove_from_page_cache
needs both locks so we can't prevent update if we get a either lock.
In code context, I think mapping->tree_lock is more readable since it is used near by.

Thanks for the comment, Paul.

-- 
Kind regards,
Minchan Kim
