Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1ASBYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 20:24:12 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38062 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1ASBYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 20:24:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rx2E/T+jAF+/wq9Tv57OhA9jF+4xI00nwiLsBn5JMSBYynhVF33bfSKeGtke9ft/M0
         fBE6/9GRbjgM5pfwDXOpkE+CD+hfJv5PkJS0fz2U1ArrFvREBf5spLbswcqXDhKfwsuJ
         lJ14884fv3RL8Rv4dHXOBB2BXHGVI6WzzkK88=
MIME-Version: 1.0
In-Reply-To: <20110118152844.88cfdc2c.akpm@linux-foundation.org>
References: <E1Pf9Zj-0002td-Ct@pomaz-ex.szeredi.hu>
	<20110118152844.88cfdc2c.akpm@linux-foundation.org>
Date: Wed, 19 Jan 2011 10:24:09 +0900
Message-ID: <AANLkTimh7jq7HLjfxVX0XKdhOhWEQtDn-faGc+iJ-ykd@mail.gmail.com>
Subject: Re: [PATCH v4] mm: add replace_page_cache_page() function
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, kamezawa.hiroyu@jp.fujitsu.com,
        nishimura@mxp.nes.nec.co.jp, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 8:28 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 18 Jan 2011 12:18:11 +0100
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
>> +{
>> +     int error;
>> +     struct mem_cgroup *memcg = NULL;
>
> I'm suspecting that the unneeded initialisation was added to suppress a
> warning?
>
> I removed it, and didn't get a warning.  I expected to.
>
> Really, uninitialized_var() is better.  It avoids adding extra code
> and, unlike "= 0" it is self-documenting.
>
>> +     VM_BUG_ON(!PageLocked(old));
>> +     VM_BUG_ON(!PageLocked(new));
>> +     VM_BUG_ON(new->mapping);
>> +
>> +     /*
>> +      * This is not page migration, but prepare_migration and
>> +      * end_migration does enough work for charge replacement.
>> +      *
>> +      * In the longer term we probably want a specialized function
>> +      * for moving the charge from old to new in a more efficient
>> +      * manner.
>> +      */
>> +     error = mem_cgroup_prepare_migration(old, new, &memcg, gfp_mask);
>> +     if (error)
>> +             return error;
>> +
>> +     error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
>> +     if (!error) {
>> +             struct address_space *mapping = old->mapping;
>> +             pgoff_t offset = old->index;
>> +
>> +             page_cache_get(new);
>> +             new->mapping = mapping;
>> +             new->index = offset;
>> +
>> +             spin_lock_irq(&mapping->tree_lock);
>> +             __remove_from_page_cache(old);
>> +             error = radix_tree_insert(&mapping->page_tree, offset, new);
>> +             BUG_ON(error);
>> +             mapping->nrpages++;
>> +             __inc_zone_page_state(new, NR_FILE_PAGES);
>> +             if (PageSwapBacked(new))
>> +                     __inc_zone_page_state(new, NR_SHMEM);
>> +             spin_unlock_irq(&mapping->tree_lock);
>> +             radix_tree_preload_end();
>> +             page_cache_release(old);
>> +             mem_cgroup_end_migration(memcg, old, new, true);
>
> This is all pretty ugly and inefficient.
>
> We call __remove_from_page_cache() which does a radix-tree lookup and
> then fiddles a bunch of accounting things.
>
> Then we immediately do the same radix-tree lookup and then undo the
> accounting changes which we just did.  And we do it in an open-coded
> fashion, thus giving the kernel yet another code site where various
> operations need to be kept in sync.
>
> Would it not be better to do a single radix_tree_lookup_slot(),
> overwrite the pointer therein and just leave all the ancilliary
> accounting unaltered?

I agree single radix_tree_lookup but accounting still is needed since
newpage could be on another zone. What we can remove is just only
mapping->nrpages.


-- 
Kind regards,
Minchan Kim
