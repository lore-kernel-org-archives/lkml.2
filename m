Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082Ab2CHA1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 19:27:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2CHA1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 19:27:22 -0500
Date: Wed, 7 Mar 2012 16:27:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: hughd@google.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        Andrew Barry <abarry@cray.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH 2/2] hugepages: Fix use after free bug in "quota"
 handling
Message-Id: <20120307162720.6e9ef6ef.akpm@linux-foundation.org>
In-Reply-To: <1331095694-27780-2-git-send-email-david@gibson.dropbear.id.au>
References: <1331095694-27780-1-git-send-email-david@gibson.dropbear.id.au>
	<1331095694-27780-2-git-send-email-david@gibson.dropbear.id.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Mar 2012 15:48:14 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> hugetlbfs_{get,put}_quota() are badly named.  They don't interact with the
> general quota handling code, and they don't much resemble its behaviour.
> Rather than being about maintaining limits on on-disk block usage by
> particular users, they are instead about maintaining limits on in-memory
> page usage (including anonymous MAP_PRIVATE copied-on-write pages)
> associated with a particular hugetlbfs filesystem instance.
> 
> Worse, they work by having callbacks to the hugetlbfs filesystem code from
> the low-level page handling code, in particular from free_huge_page().
> This is a layering violation of itself, but more importantly, if the kernel
> does a get_user_pages() on hugepages (which can happen from KVM amongst
> others), then the free_huge_page() can be delayed until after the
> associated inode has already been freed.  If an unmount occurs at the
> wrong time, even the hugetlbfs superblock where the "quota" limits are
> stored may have been freed.
> 
> Andrew Barry proposed a patch to fix this by having hugepages, instead of
> storing a pointer to their address_space and reaching the superblock from
> there, had the hugepages store pointers directly to the superblock, bumping
> the reference count as appropriate to avoid it being freed.  Andrew Morton
> rejected that version, however, on the grounds that it made the existing
> layering violation worse.
> 
> This is a reworked version of Andrew's patch, which removes the extra, and
> some of the existing, layering violation.  It works by introducing the
> concept of a hugepage "subpool" at the lower hugepage mm layer - that is
> a finite logical pool of hugepages to allocate from.  hugetlbfs now creates
> a subpool for each filesystem instance with a page limit set, and a pointer
> to the subpool gets added to each allocated hugepage, instead of the
> address_space pointer used now.  The subpool has its own lifetime and is
> only freed once all pages in it _and_ all other references to it (i.e.
> superblocks) are gone.
> 
> subpools are optional - a NULL subpool pointer is taken by the code to mean
> that no subpool limits are in effect.
> 
> Previous discussion of this bug found in:  "Fix refcounting in hugetlbfs
> quota handling.". See:  https://lkml.org/lkml/2011/8/11/28 or
> http://marc.info/?l=linux-mm&m=126928970510627&w=1
> 
> v2: Fixed a bug spotted by Hillf Danton, and removed the extra parameter to
> alloc_huge_page() - since it already takes the vma, it is not necessary.

Looks good - thanks for doing this.

Some comments, nothing serious:

>
> ...
>
> @@ -896,38 +910,12 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
>  	sb->s_root = root;
>  	return 0;
>  out_free:
> +	if (sbinfo->spool)
> +		kfree(sbinfo->spool);

kfree(NULL) is OK, and omitting the NULL test is idiomatic.

>  	kfree(sbinfo);
>  	return -ENOMEM;
>  }
>  
>
> ...
>
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -14,6 +14,15 @@ struct user_struct;
>  #include <linux/shm.h>
>  #include <asm/tlbflush.h>
>  
> +struct hugepage_subpool {
> +	spinlock_t lock;
> +	long count;
> +	long max_hpages, used_hpages;
> +};

Could we get this struct docmented please?  Why it exists, what it is
used for.  Basically a copy-n-paste from the (nice) changelog.

Also please doucment the fields.  I'm sitting here reading the code
trying to work out what these three fields semantically *mean*.  Armed
with enough information to understand the code, I then get to read it
all again :(

I don't think any of these things can go negative, and a negative page
count is absurd.  So perhaps they should have an unsigned type.

And maybe a 32-bit type?  How much memory is 2^32 hugepages, and does
the present code even work correctly in that situation?

> +struct hugepage_subpool *hugepage_new_subpool(long nr_blocks);
> +void hugepage_put_subpool(struct hugepage_subpool *spool);
> +
>  int PageHuge(struct page *page);
>  
>
> ...
>
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -53,6 +53,84 @@ static unsigned long __initdata default_hstate_size;
>   */
>  static DEFINE_SPINLOCK(hugetlb_lock);
>  
> +static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)

Strange name.  unlock_and_release() would be closer?

> +{
> +	bool free = (spool->count == 0) && (spool->used_hpages == 0);

I wish I knew what those fields do.

> +	spin_unlock(&spool->lock);
> +
> +	/* If no pages are used, and no other handles to the subpool
> +	 * remain, free the subpool the subpool remain */

Comment is mangled.

Please use the normal multiline comment layout?  There are examples in
this file.

> +	if (free)
> +		kfree(spool);
> +}
> +
> +struct hugepage_subpool *hugepage_new_subpool(long nr_blocks)

nr_blocks is logically an unsigned thing.  And maybe 32-bit.

> +{
> +	struct hugepage_subpool *spool;
> +
> +	spool = kmalloc(sizeof(*spool), GFP_KERNEL);
> +	if (!spool)
> +		return NULL;
> +
> +	spin_lock_init(&spool->lock);
> +	spool->count = 1;
> +	spool->max_hpages = nr_blocks;
> +	spool->used_hpages = 0;
> +
> +	return spool;
> +}

hm, I wonder why we didn't support a modular hugetlbfs driver.  Perhaps
because of core hugetlb code which fiddles around in hugetlbfs.  I
wonder if this patch fixed that?

> +void hugepage_put_subpool(struct hugepage_subpool *spool)
> +{
> +	spin_lock(&spool->lock);
> +	BUG_ON(!spool->count);
> +	spool->count--;
> +	unlock_or_release_subpool(spool);
> +}

ah-hah!  ->count is in fact a refcount?  Then why didn't we call it
"refcount" to save me all that head scratching?  Here I was thinking it
must count hugepages.

> +static int hugepage_subpool_get_pages(struct hugepage_subpool *spool,
> +				      long delta)
> +{
> +	int ret = 0;
> +
> +	if (!spool)
> +		return 0;
> +
> +	spin_lock(&spool->lock);
> +	if ((spool->used_hpages + delta) <= spool->max_hpages) {
> +		spool->used_hpages += delta;
> +	} else {
> +		ret = -ENOMEM;
> +	}

Can lose all the braces here.

> +	spin_unlock(&spool->lock);
> +
> +	return ret;
> +}

And some documeentation would be nice.  It's strange to have a
foo_get_pages() which doesn't get any pages!  And what does it mean
when spool==0?  Why would anyone call this function without a subpool?

`delta' could be an unsigned int?

> +static void hugepage_subpool_put_pages(struct hugepage_subpool *spool,
> +				       long delta)
> +{
> +	if (!spool)
> +		return;
> +
> +	spin_lock(&spool->lock);
> +	spool->used_hpages -= delta;
> +	/* If hugetlbfs_put_super couldn't free spool due to
> +	* an outstanding quota reference, free it now. */

This is the sole remaining use of the term "quota" in hugetlb (yay). 
Can we make this one go away as well?

> +	unlock_or_release_subpool(spool);
> +}
> +
> +static inline struct hugepage_subpool *subpool_inode(struct inode *inode)
> +{
> +	return HUGETLBFS_SB(inode->i_sb)->spool;
> +}
> +
> +static inline struct hugepage_subpool *subpool_vma(struct vm_area_struct *vma)
> +{
> +	return subpool_inode(vma->vm_file->f_dentry->d_inode);
> +}
> +
>  /*
>   * Region tracking -- allows tracking of reservations and instantiated pages
>   *                    across the pages in a mapping.
> @@ -533,9 +611,9 @@ static void free_huge_page(struct page *page)
>  	 */
>  	struct hstate *h = page_hstate(page);
>  	int nid = page_to_nid(page);
> -	struct address_space *mapping;
> +	struct hugepage_subpool *spool =
> +		(struct hugepage_subpool *)page_private(page);

Could do

	struct hugepage_subpool *spool;
	
	spool = (struct hugepage_subpool *)page_private(page);

and save the Ingo-upsetting 80-col trickery.

I'm shocked that we weren't already using the .private field of hugetlb
head pages.

> -	mapping = (struct address_space *) page_private(page);
>  	set_page_private(page, 0);
>  	page->mapping = NULL;
>  	BUG_ON(page_count(page));
> @@ -551,8 +629,7 @@ static void free_huge_page(struct page *page)
>  		enqueue_huge_page(h, page);
>  	}
>  	spin_unlock(&hugetlb_lock);
> -	if (mapping)
> -		hugetlb_put_quota(mapping, 1);
> +	hugepage_subpool_put_pages(spool, 1);
>  }
>  
>  static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
>
> ...
>
> @@ -2316,7 +2395,7 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
>  	 */
>  	address = address & huge_page_mask(h);
>  	pgoff = vma_hugecache_offset(h, vma, address);
> -	mapping = (struct address_space *)page_private(page);
> +	mapping = vma->vm_file->f_dentry->d_inode->i_mapping;

Does

	mapping = vma->vm_file->f_mapping;

work?  Avoiding all this pointer hopping is why we added f_mapping,
actually.

>  	/*
>  	 * Take the mapping lock for the duration of the table walk. As
>
> ...
>

