Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab0LWAkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:40:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:65230 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab0LWAkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:40:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,216,1291622400"; 
   d="scan'208";a="639572551"
Subject: Re: [RFC 1/3] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page optionally
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Dean Nelson <dnelson@redhat.com>
In-Reply-To: <20101222150735.c266c149.akpm@linux-foundation.org>
References: <1292986317-2805-1-git-send-email-ying.huang@intel.com>
	 <1292986317-2805-2-git-send-email-ying.huang@intel.com>
	 <20101222150735.c266c149.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 08:39:59 +0800
Message-ID: <1293064800.8743.128.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

Thanks for comments.

On Thu, 2010-12-23 at 07:07 +0800, Andrew Morton wrote:
> On Wed, 22 Dec 2010 10:51:55 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > Make __get_user_pages return -EHWPOISON for HWPOISON page only if
> > FOLL_HWPOISON is specified.  With this patch, the interested callers
> > can distinguish HWPOISON page from general FAULT page, while other
> > callers will still get -EFAULT for pages, so the user space interface
> > need not to be changed.
> > 
> > get_user_pages_hwpoison is added as a variant of get_user_pages that
> > can return -EHWPOISON for HWPOISON page.
> > 
> > This feature is needed by KVM, where UCR MCE should be relayed to
> > guest for HWPOISON page, while instruction emulation and MMIO will be
> > tried for general FAULT page.
> > 
> > The idea comes from Andrew Morton.
> 
> hm, I don't remember that.  I suspect it came from someone else?

It's long long ago.  I use another solution at that time, but now I
think your one is better.

http://marc.info/?l=linux-kernel&m=127241995131034&w=2

> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >  include/asm-generic/errno.h |    2 +
> >  include/linux/mm.h          |    5 ++++
> >  mm/memory.c                 |   53 +++++++++++++++++++++++++++++++++++++++++---
> >  3 files changed, 57 insertions(+), 3 deletions(-)
> > 
> > --- a/include/asm-generic/errno.h
> > +++ b/include/asm-generic/errno.h
> > @@ -108,4 +108,6 @@
> >  
> >  #define ERFKILL		132	/* Operation not possible due to RF-kill */
> >  
> > +#define EHWPOISON	133	/* Memory page has hardware error */
> 
> So this can be propagated to userspace?
> 
> If so, which syscalls might return EHWPOISON and are there any manpage
> implications?

No. EHWPOISON will only be returned if FOLL_HWPOISON is specified in
parameter flags of __get_user_pages.

> >  #endif
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -860,6 +860,10 @@ int get_user_pages(struct task_struct *t
> >  			struct page **pages, struct vm_area_struct **vmas);
> >  int get_user_pages_fast(unsigned long start, int nr_pages, int write,
> >  			struct page **pages);
> > +int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
> > +			    unsigned long start, int nr_pages, int write,
> > +			    int force, struct page **pages,
> > +			    struct vm_area_struct **vmas);
> >  struct page *get_dump_page(unsigned long addr);
> >  
> >  extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
> > @@ -1415,6 +1419,7 @@ struct page *follow_page(struct vm_area_
> >  #define FOLL_GET	0x04	/* do get_page on page */
> >  #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
> >  #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
> > +#define FOLL_HWPOISON	0x20	/* check page is hwpoisoned */
> >  
> >  typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
> >  			void *data);
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1449,9 +1449,16 @@ int __get_user_pages(struct task_struct
> >  				if (ret & VM_FAULT_ERROR) {
> >  					if (ret & VM_FAULT_OOM)
> >  						return i ? i : -ENOMEM;
> > -					if (ret &
> > -					    (VM_FAULT_HWPOISON|VM_FAULT_HWPOISON_LARGE|
> > -					     VM_FAULT_SIGBUS))
> > +					if (ret & (VM_FAULT_HWPOISON |
> > +						   VM_FAULT_HWPOISON_LARGE)) {
> > +						if (i)
> > +							return i;
> > +						else if (gup_flags & FOLL_HWPOISON)
> > +							return -EHWPOISON;
> > +						else
> > +							return -EFAULT;
> > +					}
> > +					if (ret & VM_FAULT_SIGBUS)
> 
> hm, that function is getting a bit unweildy.

Yes. Do you think the following code is better?

return i ? i : (gup_flags & FOLL_HWPOISON) ? -EHWPOISON : -EFAULT;

> >  /**
> > + * get_user_pages_hwpoison() - pin user pages in memory, return hwpoison status
> > + * @tsk:	task_struct of target task
> > + * @mm:		mm_struct of target mm
> > + * @start:	starting user address
> > + * @nr_pages:	number of pages from start to pin
> > + * @write:	whether pages will be written to by the caller
> > + * @force:	whether to force write access even if user mapping is
> > + *		readonly. This will result in the page being COWed even
> > + *		in MAP_SHARED mappings. You do not want this.
> > + * @pages:	array that receives pointers to the pages pinned.
> > + *		Should be at least nr_pages long. Or NULL, if caller
> > + *		only intends to ensure the pages are faulted in.
> > + * @vmas:	array of pointers to vmas corresponding to each page.
> > + *		Or NULL if the caller does not require them.
> > + *
> > + * Returns number of pages pinned.
> > + *
> > + * If the page table or memory page is hwpoisoned, return -EHWPOISON.
> > + *
> > + * Otherwise, same as get_user_pages.
> > + */
> > +int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
> > +			    unsigned long start, int nr_pages, int write,
> > +			    int force, struct page **pages,
> > +			    struct vm_area_struct **vmas)
> > +{
> > +	int flags = FOLL_TOUCH | FOLL_HWPOISON;
> > +
> > +	if (pages)
> > +		flags |= FOLL_GET;
> > +	if (write)
> > +		flags |= FOLL_WRITE;
> > +	if (force)
> > +		flags |= FOLL_FORCE;
> > +
> > +	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
> > +}
> > +EXPORT_SYMBOL(get_user_pages_hwpoison);
> 
> Seems that this patch will add unused bloat for CONFIG_PAGE_POISONING=n
> kernels?

Sorry. I will enclose this function with
#ifdef CONFIG_MEMORY_FAILURE

Best Regards,
Huang Ying


