Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945979Ab2JLPz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:55:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945918Ab2JLPz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:55:26 -0400
Message-ID: <1350057318.2299.88.camel@kjgkr>
Subject: Re: [PATCH 06/16] f2fs: add node operations
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: =?euc-kr?Q?=B1=E8=C0=E7=B1=D8?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Sat, 13 Oct 2012 00:55:18 +0900
In-Reply-To: <20121011091712.410a3a71@notabene.brown>
References: <000d01cda2f1$037771b0$0a665510$%kim@samsung.com>
	 <20121011091712.410a3a71@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-11 (목), 09:17 +1100, NeilBrown:
> On Fri, 05 Oct 2012 21:00:29 +0900 김재극 <jaegeuk.kim@samsung.com> wrote:
> 
> 
> > +static struct nat_entry *grab_nat_entry(struct f2fs_nm_info *nm_i, nid_t nid)
> > +{
> > +	struct nat_entry *new;
> > +
> > +	new = kmem_cache_alloc(nat_entry_slab, __GFP_HIGH | __GFP_NOFAIL);
> > +	memset(new, 0, sizeof(struct nat_entry));
> > +	nat_set_nid(new, nid);
> > +	__add_to_nat_cache(nm_i, new);
> > +	return new;
> > +}
> > +
> > +static void cache_nat_entry(struct f2fs_nm_info *nm_i, nid_t nid,
> > +						struct f2fs_nat_entry *ne)
> > +{
> > +	struct nat_entry *e;
> > +
> > +	write_lock(&nm_i->nat_tree_lock);
> > +	e = __lookup_nat_cache(nm_i, nid);
> > +	if (!e) {
> > +		e = grab_nat_entry(nm_i, nid);
> > +		nat_set_blkaddr(e, le32_to_cpu(ne->block_addr));
> > +		nat_set_ino(e, le32_to_cpu(ne->ino));
> > +		nat_set_version(e, ne->version);
> > +		e->checkpointed = true;
> > +	}
> > +	write_unlock(&nm_i->nat_tree_lock);
> > +}
> 
> Hi,
> 
> cache_nat_entry takes an rwlock (like a spinlock), then calls grab_nat_cache,
> which calls kmem_cache_alloc().  Doing mem alloc under a spinlock is not
> really a good idea, though it is sometimes OK for GFP_ATOMIC.
> 
> You use __GFP_HIGH which is equivalent to GFP_ATOMIC, but add __GFP_NOFAIL.
> I'm not really sure exactly what this will do when memory is tight, but I
> suspect it will spin trying to find memory and there by slow down any other
> code that is trying to free memory.
> 
> Also, there is a comment in page_alloc.c:
> 			 * __GFP_NOFAIL is not to be used in new code.
> 			 *
> 			 * All __GFP_NOFAIL callers should be fixed so that they
> 			 * properly detect and handle allocation failures.
> 			 *
> 
> I suggest you fix this code to follow the standard pattern where if the
> lookup_nat_cache fails you check if you have already allocated something and
> if so use it.  If not, drop the lock, do the allocation with GFP_KERNEL, then
> loop back to the top.
> At the end, if you allocated something without using it, kfree it.
> 

Yes, right.
Initially I wrote like that, but to remove redundant loops with "goto",
I added __GFP_NOFAIL.
I'll apply this comment in v2.

> > +static int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
> > +{
> > +	struct f2fs_nm_info *nm_i = NM_I(sbi);
> > +
> > +	if (nm_i->nat_cnt < 2 * NM_WOUT_THRESHOLD)
> > +		return 0;
> > +
> > +	write_lock(&nm_i->nat_tree_lock);
> > +	while (nr_shrink-- && !list_empty(&nm_i->nat_entries)) {
> > +		struct nat_entry *ne;
> > +		ne = list_first_entry(&nm_i->nat_entries,
> > +					struct nat_entry, list);
> > +		__del_from_nat_cache(nm_i, ne);
> > +	}
> > +	write_unlock(&nm_i->nat_tree_lock);
> > +	return nr_shrink;
> > +}
> 
> 
> This code looks wrong to me, in a small way.
> The return value is only ever tested for whether it is zero or not.
> For that last 'return', nr_shrink will only be zero if the original nr_shrink
> is exactly one more than the number of items in nat_entries.  If nr_shrink is
> more than that, the function will return "-1".
> I suspect that is not what is desired.
> 
> I would suggest changing the test in the while loop to
>       while (nr_shrink && !list_empty(...)) {
> and add
>       nr_shrink--;
> somewhere inside the loop.
> 

Agree.
Thank you. :)

> Regards,
> NeilBrown

-- 
Jaegeuk Kim
Samsung

