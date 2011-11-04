Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1KDWOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:14:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53515 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab1KDWOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:14:07 -0400
Date: Fri, 4 Nov 2011 15:13:59 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Ken Chen <kenchen@google.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch] hugetlb: add hugepage reservation upon mremap
 expansion.
In-Reply-To: <20111103215421.AF532122186@elm.corp.google.com>
Message-ID: <alpine.LSU.2.00.1111041451590.26175@sister.anvils>
References: <20111103215421.AF532122186@elm.corp.google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011, Ken Chen wrote:

> hugetlb: add hugepage reservation upon mremap expansion
> 
> hugetlb page has a semantics that it reserves pages up front at the time
> of mmap.  We need to extend the same reservation scheme for the mremap
> expansion case.

If you do go this way, then I think there needs to be more to it.

hugetlbfs_file_mmap() has that line near the bottom where it updates
inode->i_size to cover the mapping: without doing something similar
in your hugetlbfs mremap, won't the enlarged mapping just give SIGBUS
on the enlargement (unless it happens to be already mapped elsewhere)?

But changing i_size in mmap and mremap is unusual, if not simply wrong.
The size of mmap or mremap is the size of a userspace mapping, which
is modified by mmap, mremap, munmap.  The size of the underlying object
is usually independent of that, and modified by ftruncate or write.

It was suggested a few years ago that it would be helpful if mremap of
a shared anonymous shmem object would change the size of the underlying
object, instead of just giving SIGBUS on the enlargement; but in the
end I played cautious, and made no change there.

Since hugetlbfs is already peculiar in setting i_size in its mmap,
I guess you would not be wrong to extend that peculiarity to its mremap.
But you will have some trouble with the locking: see "locking order of
mmap_sem and various FS" thread on LKML a couple of days ago -
I think you will need to fix taking i_mutex under mmap_sem somehow.

Hugh

> 
> Signed-off-by: Ken Chen <kenchen@google.com>
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index c36d851..5d22933 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -28,6 +28,8 @@ int hugetlb_mempolicy_sysctl_handler(
>  
>  int move_hugetlb_page_tables(struct vm_area_struct *vma, unsigned long old_addr,
>  			     unsigned long new_addr, unsigned long len);
> +int hugetlb_expand_resv(struct vm_area_struct *vma, unsigned long old_len,
> +			 unsigned long new_len);
>  int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
>  int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
>  			struct page **, struct vm_area_struct **,
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6f5b56f..1f8e333 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2250,6 +2250,34 @@ int move_hugetlb_page_tables(
>  	return len + old_addr - old_end;
>  }
>  
> +int hugetlb_expand_resv(struct vm_area_struct *vma, unsigned long old_len,
> +			 unsigned long new_len)
> +{
> +	struct hstate *h = hstate_vma(vma);
> +	int ret = 0;
> +
> +	if (old_len >= new_len)
> +		goto out;
> +
> +	if (vma->vm_flags & VM_MAYSHARE) {
> +		struct inode *inode = vma->vm_file->f_mapping->host;
> +		unsigned long from, to, vm_flags;
> +
> +		from = (vma->vm_pgoff >> huge_page_order(h)) +
> +			(old_len >> huge_page_shift(h));
> +		to   = (vma->vm_pgoff >> huge_page_order(h)) +
> +			(new_len >> huge_page_shift(h));
> +		vm_flags = vma->vm_flags;
> +
> +		ret = hugetlb_reserve_pages(inode, from, to, vma, vm_flags);
> +	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
> +		long expand = (new_len - old_len) >> huge_page_shift(h);
> +		ret = hugetlb_acct_memory(h, expand);
> +	}
> +out:
> +	return ret;
> +}
> +
>  void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
>  			    unsigned long end, struct page *ref_page)
>  {
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 9f6c903..010f93a 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -410,7 +410,7 @@ unsigned long do_mremap(unsigned long addr,
>  	unsigned long flags, unsigned long new_addr)
>  {
>  	struct mm_struct *mm = current->mm;
> -	struct vm_area_struct *vma;
> +	struct vm_area_struct *vma = NULL;
>  	unsigned long ret = -EINVAL;
>  	unsigned long charged = 0;
>  
> @@ -525,6 +525,15 @@ unsigned long do_mremap(unsigned long addr,
>  out:
>  	if (ret & ~PAGE_MASK)
>  		vm_unacct_memory(charged);
> +	else if (vma && is_vm_hugetlb_page(vma)) {
> +		unsigned long ret2;
> +
> +		ret2 = hugetlb_expand_resv(vma, old_len, new_len);
> +		if (ret2) {
> +			ret = ret2;
> +			vm_unacct_memory(charged);
> +		}
> +	}
>  	return ret;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
