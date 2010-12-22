Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0LVXHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:07:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245Ab0LVXHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:07:51 -0500
Date: Wed, 22 Dec 2010 15:07:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        Dean Nelson <dnelson@redhat.com>
Subject: Re: [RFC 1/3] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page optionally
Message-Id: <20101222150735.c266c149.akpm@linux-foundation.org>
In-Reply-To: <1292986317-2805-2-git-send-email-ying.huang@intel.com>
References: <1292986317-2805-1-git-send-email-ying.huang@intel.com>
	<1292986317-2805-2-git-send-email-ying.huang@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010 10:51:55 +0800
Huang Ying <ying.huang@intel.com> wrote:

> Make __get_user_pages return -EHWPOISON for HWPOISON page only if
> FOLL_HWPOISON is specified.  With this patch, the interested callers
> can distinguish HWPOISON page from general FAULT page, while other
> callers will still get -EFAULT for pages, so the user space interface
> need not to be changed.
> 
> get_user_pages_hwpoison is added as a variant of get_user_pages that
> can return -EHWPOISON for HWPOISON page.
> 
> This feature is needed by KVM, where UCR MCE should be relayed to
> guest for HWPOISON page, while instruction emulation and MMIO will be
> tried for general FAULT page.
> 
> The idea comes from Andrew Morton.

hm, I don't remember that.  I suspect it came from someone else?

> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/asm-generic/errno.h |    2 +
>  include/linux/mm.h          |    5 ++++
>  mm/memory.c                 |   53 +++++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 57 insertions(+), 3 deletions(-)
> 
> --- a/include/asm-generic/errno.h
> +++ b/include/asm-generic/errno.h
> @@ -108,4 +108,6 @@
>  
>  #define ERFKILL		132	/* Operation not possible due to RF-kill */
>  
> +#define EHWPOISON	133	/* Memory page has hardware error */

So this can be propagated to userspace?

If so, which syscalls might return EHWPOISON and are there any manpage
implications?

>  #endif
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -860,6 +860,10 @@ int get_user_pages(struct task_struct *t
>  			struct page **pages, struct vm_area_struct **vmas);
>  int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  			struct page **pages);
> +int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
> +			    unsigned long start, int nr_pages, int write,
> +			    int force, struct page **pages,
> +			    struct vm_area_struct **vmas);
>  struct page *get_dump_page(unsigned long addr);
>  
>  extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
> @@ -1415,6 +1419,7 @@ struct page *follow_page(struct vm_area_
>  #define FOLL_GET	0x04	/* do get_page on page */
>  #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
>  #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
> +#define FOLL_HWPOISON	0x20	/* check page is hwpoisoned */
>  
>  typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
>  			void *data);
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1449,9 +1449,16 @@ int __get_user_pages(struct task_struct
>  				if (ret & VM_FAULT_ERROR) {
>  					if (ret & VM_FAULT_OOM)
>  						return i ? i : -ENOMEM;
> -					if (ret &
> -					    (VM_FAULT_HWPOISON|VM_FAULT_HWPOISON_LARGE|
> -					     VM_FAULT_SIGBUS))
> +					if (ret & (VM_FAULT_HWPOISON |
> +						   VM_FAULT_HWPOISON_LARGE)) {
> +						if (i)
> +							return i;
> +						else if (gup_flags & FOLL_HWPOISON)
> +							return -EHWPOISON;
> +						else
> +							return -EFAULT;
> +					}
> +					if (ret & VM_FAULT_SIGBUS)

hm, that function is getting a bit unweildy.

>  /**
> + * get_user_pages_hwpoison() - pin user pages in memory, return hwpoison status
> + * @tsk:	task_struct of target task
> + * @mm:		mm_struct of target mm
> + * @start:	starting user address
> + * @nr_pages:	number of pages from start to pin
> + * @write:	whether pages will be written to by the caller
> + * @force:	whether to force write access even if user mapping is
> + *		readonly. This will result in the page being COWed even
> + *		in MAP_SHARED mappings. You do not want this.
> + * @pages:	array that receives pointers to the pages pinned.
> + *		Should be at least nr_pages long. Or NULL, if caller
> + *		only intends to ensure the pages are faulted in.
> + * @vmas:	array of pointers to vmas corresponding to each page.
> + *		Or NULL if the caller does not require them.
> + *
> + * Returns number of pages pinned.
> + *
> + * If the page table or memory page is hwpoisoned, return -EHWPOISON.
> + *
> + * Otherwise, same as get_user_pages.
> + */
> +int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
> +			    unsigned long start, int nr_pages, int write,
> +			    int force, struct page **pages,
> +			    struct vm_area_struct **vmas)
> +{
> +	int flags = FOLL_TOUCH | FOLL_HWPOISON;
> +
> +	if (pages)
> +		flags |= FOLL_GET;
> +	if (write)
> +		flags |= FOLL_WRITE;
> +	if (force)
> +		flags |= FOLL_FORCE;
> +
> +	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
> +}
> +EXPORT_SYMBOL(get_user_pages_hwpoison);

Seems that this patch will add unused bloat for CONFIG_PAGE_POISONING=n
kernels?

