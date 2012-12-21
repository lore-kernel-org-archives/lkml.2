Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab2LUAeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 19:34:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab2LUAeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 19:34:03 -0500
Date: Fri, 21 Dec 2012 01:34:01 +0100
From: Jan Kara <jack@suse.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 2/4] mm: Update file times when inodes are written
 after mmaped writes
Message-ID: <20121221003401.GB13474@quack.suse.cz>
References: <cover.1356043686.git.luto@amacapital.net>
 <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-12-12 15:10:10, Andy Lutomirski wrote:
> The onus is currently on filesystems to call file_update_time
> somewhere in the page_mkwrite path.  This is unfortunate for three
> reasons:
> 
> 1. page_mkwrite on a locked page should be fast.  ext4, for example,
>    often sleeps while dirtying inodes.
> 
> 2. The current behavior is surprising -- the timestamp resulting from
>    an mmaped write will be before the write, not after.  This contradicts
>    the mmap(2) manpage, which says:
> 
>      The st_ctime and st_mtime field for a file mapped with  PROT_WRITE  and
>      MAP_SHARED  will  be  updated  after  a write to the mapped region, and
>      before a subsequent msync(2) with the MS_SYNC or MS_ASYNC flag, if  one
>      occurs.
  I agree your behavior is more correct wrt to the manpage / spec. OTOH I
could dig out several emails where users complain time stamps magically
change some time after the file was written via mmap (because writeback
happened at that time and it did some allocation to the inode). People hit
this e.g. when compiling something, ld(1) writes final binary through mmap,
the package / archive the final binary and later some sanity check finds
the time stamp on the binary is newer than the package / archive.

Looking more into the patch you end up updating timestamps on munmap(2)
(thus on file close in particular). That should avoid the most surprising
cases and users hopefully won't notice the difference. Good. But please
mention this explicitely in the changelog.


 
> 3. (An ulterior motive) I'd like to use hardware dirty tracking for
>    shared, locked, writable mappings (instead of page faults).  Moving
>    important work out of the page_mkwrite path is an important first step.
> 
> The next patch will remove the now-unnecessary file_update_time calls.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  fs/inode.c              | 37 +++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h      |  1 +
>  include/linux/pagemap.h |  3 +++
>  mm/memory.c             |  2 +-
>  mm/mmap.c               |  4 ++++
>  mm/page-writeback.c     | 30 ++++++++++++++++++++++++++++--
>  6 files changed, 74 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 64999f1..d881d0b 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1688,6 +1688,43 @@ int file_update_time(struct file *file)
>  }
>  EXPORT_SYMBOL(file_update_time);
>  
> +/**
> + *	inode_update_time_writable	-	update mtime and ctime time
> + *	@inode: inode accessed
> + *
> + *	This is like file_update_time, but it assumes the mnt is writable
> + *	and takes an inode parameter instead.
> + */
> +
> +int inode_update_time_writable(struct inode *inode)
> +{
> +	struct timespec now;
> +	int sync_it = 0;
> +	int ret;
> +
> +	/* First try to exhaust all avenues to not sync */
> +	if (IS_NOCMTIME(inode))
> +		return 0;
> +
> +	now = current_fs_time(inode->i_sb);
> +	if (!timespec_equal(&inode->i_mtime, &now))
> +		sync_it = S_MTIME;
> +
> +	if (!timespec_equal(&inode->i_ctime, &now))
> +		sync_it |= S_CTIME;
> +
> +	if (IS_I_VERSION(inode))
> +		sync_it |= S_VERSION;
> +
> +	if (!sync_it)
> +		return 0;
> +
> +	ret = update_time(inode, &now, sync_it);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(inode_update_time_writable);
> +
  So this differs from file_update_time() only by not calling
__mnt_want_write(). Why this special function? It is actually unsafe wrt
remounts read-only or filesystem freezing... For that you need to call
sb_start_write() / sb_end_write() around the timestamp update. Umm, or
better sb_start_pagefault() / sb_end_pagefault() because the call in
remove_vma() gets called under mmap_sem so we are in a rather similar
situation to ->page_mkwrite.

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 3913262..60301dc 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -223,6 +223,10 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
>  	struct vm_area_struct *next = vma->vm_next;
>  
>  	might_sleep();
> +
> +	if (vma->vm_file)
> +		mapping_flush_cmtime(vma->vm_file->f_mapping);
> +
>  	if (vma->vm_ops && vma->vm_ops->close)
>  		vma->vm_ops->close(vma);
>  	if (vma->vm_file)
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index cdea11a..8cbb7fb 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1910,6 +1910,13 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  		ret = mapping->a_ops->writepages(mapping, wbc);
>  	else
>  		ret = generic_writepages(mapping, wbc);
> +
> +	/*
> +	 * This is after writepages because the AS_CMTIME bit won't
> +	 * bet set until writepages is called.
> +	 */
> +	mapping_flush_cmtime(mapping);
> +
>  	return ret;
>  }
>  
> @@ -2117,8 +2124,17 @@ EXPORT_SYMBOL(set_page_dirty);
>   */
>  int set_page_dirty_from_pte(struct page *page)
>  {
> -	/* Doesn't do anything interesting yet. */
> -	return set_page_dirty(page);
> +	int ret = set_page_dirty(page);
> +
> +	/*
> +	 * We may be out of memory and/or have various locks held, so
> +	 * there isn't much we can do in here.
> +	 */
> +	struct address_space *mapping = page_mapping(page);
  Declarations should go together please. So something like:
	int ret = set_page_dirty(page);
	struct address_space *mapping = page_mapping(page);

	/* comment... */

> +	if (mapping)
> +		set_bit(AS_CMTIME, &mapping->flags);
> +
> +	return ret;
>  }
>  
>  /*
> @@ -2287,3 +2303,13 @@ int mapping_tagged(struct address_space *mapping, int tag)
>  	return radix_tree_tagged(&mapping->page_tree, tag);
>  }
>  EXPORT_SYMBOL(mapping_tagged);
> +
> +/*
> + * Call from any context from which inode_update_time_writable would be okay
> + * to flush deferred cmtime changes.
> + */
> +void mapping_flush_cmtime(struct address_space *mapping)
> +{
> +	if (test_and_clear_bit(AS_CMTIME, &mapping->flags))
> +		inode_update_time_writable(mapping->host);
> +}

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
