Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab0LVCKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 21:10:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35668 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0LVCKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 21:10:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FCa9ZFNYrfw1aUPsQnOZwa/AM69zbBAv90XcqSEOhWz6QZQLVni9mWr1qZCcEnUCYU
         Hhne32XWv87qQaZ5+4j93dRl29X8yD3u8aMkMoTO8aOkPhVYIis6DBKmss9NzvK3lcPN
         U/mfkthcMtOLRhx3BLLZAGiWveTOV5GqwRfE8=
MIME-Version: 1.0
In-Reply-To: <20101221122652.GU13914@csn.ul.ie>
References: <AANLkTiniXU9B5YpQ+hknOSF-mPig2z9UqqBWz-JwQjDL@mail.gmail.com>
	<20101220152335.GR13914@csn.ul.ie>
	<20101220170146.GS13914@csn.ul.ie>
	<rcu-mm-protected-misuse@mdm.bga.com>
	<20101221122652.GU13914@csn.ul.ie>
Date: Wed, 22 Dec 2010 11:10:47 +0900
Message-ID: <AANLkTimu1frzVJ3_5NV-iX0TFYTX5zjKQhaN+zn7=VdU@mail.gmail.com>
Subject: Re: [PATCH] mm: migration: Use rcu_dereference_protected when
 dereferencing the radix tree slot during file page migration
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Milton Miller <miltonm@bga.com>, Andrew Morton <akpm@linux-foundation.org>,
        gerald.schaefer@de.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
        Arun Bhanu <ab@arunbhanu.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 9:26 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Tue, Dec 21, 2010 at 01:16:23AM -0600, Milton Miller wrote:
>>
>> [ Add Paul back to the CC list, and also Dipankar.
>>  Hopefully I killed the mime encodings correctly ]
>>
>> On Tue, 21 Dec 2010 at 08:48:50 +0900, Minchan Kim wrote:
>> > On Tue, Dec 21, 2010 at 2:01 AM, Mel Gorman <mel@csn.ul.ie> wrote:
>> > > On Mon, Dec 20, 2010 at 03:23:36PM +0000, Mel Gorman wrote:
>> > > > migrate_pages() -> unmap_and_move() only calls rcu_read_lock() for anonymous
>> > > > pages, as introduced by git commit 989f89c57e6361e7d16fbd9572b5da7d313b073d.
>> > > > The point of the RCU protection there is part of getting a stable reference
>> > > > to anon_vma and is only held for anon pages as file pages are locked
>> > > > which is sufficient protection against freeing.
>> > > >
>> > > > However, while a file page's mapping is being migrated, the radix
>> > > > tree is double checked to ensure it is the expected page. This uses
>> > > > radix_tree_deref_slot() -> rcu_dereference() without the RCU lock held
>> > > > triggering the following warning under CONFIG_PROVE_RCU.
>> > > >
>> > > > [ 173.674290] ===================================================
>> > > > [ 173.676016] [ INFO: suspicious rcu_dereference_check() usage. ]
>> > > > [ 173.676016] ---------------------------------------------------
>> > > > [ 173.676016] include/linux/radix-tree.h:145 invoked rcu_dereference_check() without protection!
>> > > > [ 173.676016]
>> > > > [ 173.676016] other info that might help us debug this:
>> > > > [ 173.676016]
>> > > > [ 173.676016]
>> > > > [ 173.676016] rcu_scheduler_active = 1, debug_locks = 0
>> > > > [ 173.676016] 1 lock held by hugeadm/2899:
>> > > > [ 173.676016] #0: (&(&inode->i_data.tree_lock)->rlock){..-.-.},at: [<c10e3d2b>] migrate_page_move_mapping+0x40/0x1ab
>> > > > [ 173.676016]
>> > > > [ 173.676016] stack backtrace:
>> > > > [ 173.676016] Pid: 2899, comm: hugeadm Not tainted 2.6.37-rc5-autobuild
>> > > > [ 173.676016] Call Trace:
>> > > > [ 173.676016] [<c128cc01>] ? printk+0x14/0x1b
>> > > > [ 173.676016] [<c1063502>] lockdep_rcu_dereference+0x7d/0x86
>> > > > [ 173.676016] [<c10e3db5>] migrate_page_move_mapping+0xca/0x1ab
>> > > > [ 173.676016] [<c10e41ad>] migrate_page+0x23/0x39
>> > > > [ 173.676016] [<c10e491b>] buffer_migrate_page+0x22/0x107
>> > > > [ 173.676016] [<c10e48f9>] ? buffer_migrate_page+0x0/0x107
>> > > > [ 173.676016] [<c10e425d>] move_to_new_page+0x9a/0x1ae
>> > > > [ 173.676016] [<c10e47e6>] migrate_pages+0x1e7/0x2fa
>> > > >
>> > > > This patch introduces radix_tree_deref_slot_protected() which calls
>> > > > rcu_dereference_protected(). Users of it must pass in the mapping->tree_lock
>> > > > that is protecting this dereference. Holding the tree lock protects against
>> > > > parallel updaters of the radix tree meaning that rcu_dereference_protected
>> > > > is allowable.
>> > > >
>> > > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>> > > > ---
>> > > > include/linux/radix-tree.h |  17 +++++++++++++++++
>> > > > mm/migrate.c        |  4 ++--
>> > > > 2 files changed, 19 insertions(+), 2 deletions(-)
>> > > >
>> > > > diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
>> > > > index ab2baa5..a1f1672 100644
>> > > > --- a/include/linux/radix-tree.h
>> > > > +++ b/include/linux/radix-tree.h
>> > > > @@ -146,6 +146,23 @@ static inline void *radix_tree_deref_slot(void **pslot)
>> > > > }
>> > > >
>> > > > /**
>> > > > + * radix_tree_deref_slot_protected  - dereference a slot without RCUlock but with tree lock held
>> > > > + * @pslot:  pointer to slot, returned by radix_tree_lookup_slot
>> > > > + * Returns: item that was stored in that slot with any direct pointer flag
>> > > > + *      removed.
>> > > > + *
>> > > > + * Similar to radix_tree_deref_slot but only used during migration when a pages
>> > > > + * mapping is being moved. The caller does not hold the RCU read lock but it
>> > > > + * must hold the tree lock to prevent parallel updates.
>> > > > + */
>> > > > +static inline void *radix_tree_deref_slot_protected(void **pslot,
>> > > > +                           spinlock_t *treelock)
>> > > > +{
>> > > > +   BUG_ON(rcu_read_lock_held());
>> >
>> > Hmm.. Why did you add the check?
>> > If rcu_read_lock were already held, we wouldn't need this new API.
>>
>> I'm not Paul but I can read the code in include/linux/rcuupdate.h.
>>
>> Holding rcu_read_lock_held isn't a problem, but using protected with
>> just the read lock is.
>>
>
> Bah, this was extremely careless of me as it's even written in teh
> documentation. In this specific case, it's simply allowed to ignore whether
> the RCU read lock is held or not and the BUG_ON check was unnecessary. The
> tree lock protects against parallel updaters which is what we really care
> about for using _protected.
>
> In a later cycle, I should look at reducing the RCU read lock hold time
> in migration. The main thing it's protecting is getting a stable
> reference to anon_vma and it's held longer than is necessary for that.

Yes.
I think if we want to reduce RCU read lock hold time, we should look
unmap_and_move in case of anon page.
After we hold a reference of anon_vma->external_refcount, anon_vma
would be stable so we can release rcu_read_unlock.
It can save many time.

> In the meantime, can anyone spot a problem with this patch?
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
> [  173.674290] ===================================================
> [  173.676016] [ INFO: suspicious rcu_dereference_check() usage. ]
> [  173.676016] ---------------------------------------------------
> [  173.676016] include/linux/radix-tree.h:145 invoked rcu_dereference_check() without protection!
> [  173.676016]
> [  173.676016] other info that might help us debug this:
> [  173.676016]
> [  173.676016]
> [  173.676016] rcu_scheduler_active = 1, debug_locks = 0
> [  173.676016] 1 lock held by hugeadm/2899:
> [  173.676016]  #0:  (&(&inode->i_data.tree_lock)->rlock){..-.-.}, at: [<c10e3d2b>] migrate_page_move_mapping+0x40/0x1ab
> [  173.676016]
> [  173.676016] stack backtrace:
> [  173.676016] Pid: 2899, comm: hugeadm Not tainted 2.6.37-rc5-autobuild
> [  173.676016] Call Trace:
> [  173.676016]  [<c128cc01>] ? printk+0x14/0x1b
> [  173.676016]  [<c1063502>] lockdep_rcu_dereference+0x7d/0x86
> [  173.676016]  [<c10e3db5>] migrate_page_move_mapping+0xca/0x1ab
> [  173.676016]  [<c10e41ad>] migrate_page+0x23/0x39
> [  173.676016]  [<c10e491b>] buffer_migrate_page+0x22/0x107
> [  173.676016]  [<c10e48f9>] ? buffer_migrate_page+0x0/0x107
> [  173.676016]  [<c10e425d>] move_to_new_page+0x9a/0x1ae
> [  173.676016]  [<c10e47e6>] migrate_pages+0x1e7/0x2fa
>
> This patch introduces radix_tree_deref_slot_protected() which calls
> rcu_dereference_protected(). Users of it must pass in the mapping->tree_lock
> that is protecting this dereference. Holding the tree lock protects
> against parallel updaters of the radix tree meaning that
> rcu_dereference_protected is allowable.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

This is what I want.
Thanks.

-- 
Kind regards,
Minchan Kim
