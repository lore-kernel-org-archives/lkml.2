Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab1GRHBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 03:01:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:40576 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab1GRHBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 03:01:48 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Shan Hai <haishan.bai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E23D728.7090406@gmail.com>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop>  <1310944453.25044.262.camel@pasglop>
	 <1310961691.25044.274.camel@pasglop>  <4E23D728.7090406@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 17:01:02 +1000
Message-ID: <1310972462.25044.292.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 14:48 +0800, Shan Hai wrote:

> It could not fix the problem, refer the following reply for
> the reasons.

 .../...

> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index fe28dc2..02adff7 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -355,8 +355,8 @@ static int fault_in_user_writeable(u32 __user *uaddr)
> >   	int ret;
> >
> >   	down_read(&mm->mmap_sem);
> > -	ret = get_user_pages(current, mm, (unsigned long)uaddr,
> > -			     1, 1, 0, NULL, NULL);
> > +	ret = __get_user_pages(current, mm, (unsigned long)uaddr, 1,
> > +			       FOLL_WRITE | FOLL_FIXFAULT, NULL, NULL, NULL);
> 
> the FOLL_FIXFAULT is filtered out at the following code
> get_user_pages()
>      if (write)
>                  flags |= FOLL_WRITE;
> 

I'm not sure what you're talking about here, you may notice that I'm
calling __get_user_pages() not get_user_pages(). Make sure you get my
-second- post of the patch (the one with a proper description & s-o-b)
since the first one was a mis-send of an wip version.

> > +
> > +	if (flags&  FOLL_FIXFAULT)
> > +		handle_pte_sw_young_dirty(vma, address, ptep,
> > +					  flags&  FOLL_WRITE);
> >   	if (flags&  FOLL_TOUCH) {
> >   		if ((flags&  FOLL_WRITE)&&
> >   		!pte_dirty(pte)&&  !PageDirty(page))
> 
> call handle_pte_sw_young_dirty before !pte_dirty(pte)
> might has problems.

No this is on purpose. 

My initial patch was only calling it under the same condition as the
FOLL_TOUCH case, but I got concerned by this whole
flush_tlb_fix_spurious_fault() business.

Basically, our generic code is designed so that relaxing write
protection on a PTE can be done without flushing the TLB on all CPUs, so
that a "spurrious" fault on a secondary CPU will flush the TLB at that
point.

I don't know which arch relies on this feature (ARM maybe ?) but if we
are going to be semantically equivalent to a real fault, we must also do
that, so the right thing to do here is to always call in there if
FOLL_FIXFAULT is set.

It's up to the caller to only set FOLL_FIXFAULT when really trying to
deal with an -EFAULT, to avoid possible unnecessary overhead, but in
this case I think we are fine, this is all a fallback slow path.

 .../...

> So what about the following?
> diff --git a/mm/memory.c b/mm/memory.c
> index 9b8a01d..fb48122 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1442,6 +1442,7 @@ struct page *follow_page(struct vm_area_struct 
> *vma, unsig
>          spinlock_t *ptl;
>          struct page *page;
>          struct mm_struct *mm = vma->vm_mm;
> +       int fix_write_permission = false;
> 
>          page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
>          if (!IS_ERR(page)) {
> @@ -1519,6 +1520,11 @@ split_fallthrough:
>                  if ((flags & FOLL_WRITE) &&
>                      !pte_dirty(pte) && !PageDirty(page))
>                          set_page_dirty(page);
> +
> +#ifdef CONFIG_FIXUP_WRITE_PERMISSION
> +               if ((flags & FOLL_WRITE) && !pte_dirty(pte))
> +                       fix_write_permission = true;
> +#endif
>                  /*
>                   * pte_mkyoung() would be more correct here, but atomic 
> care
>                   * is needed to avoid losing the dirty bit: it is 
> easier to use
> @@ -1551,7 +1557,7 @@ split_fallthrough:
>   unlock:
>          pte_unmap_unlock(ptep, ptl);
>   out:
> -       return page;
> +       return (fix_write_permission == true) ? NULL: page;
> 
>   bad_page:
>          pte_unmap_unlock(ptep, ptl);

You patch not only is uglier (more ifdef's) but also incomplete since it
doesn't handle the young case and it doesn't handle the spurious fault
case either.

What the futex code is trying to do is use gup() as a way to fixup from
a fault which means essentially to have the -exact- same semantics as a
normal fault would have.

Thus by factoring the common fault fixup code and using that exact same
code in gup(), we get a much more robust guarantee that this will work
in the long run.

I don't expect gup to be that commonly used to fixup access after an
attempt at doing a user access with page faults disabled, only those
case will need to be modified to use the new flag. 

>  From the CONFIG_FIXUP_WRITE_PERMISSION and
> (flags & FOLL_WRITE) && !pte_dirty(pte) the follow_page()
> could figure out that the caller want to write to the
> (present && writable && non-dirty) pte, and the architecture
> want to fixup the problem by indicating CONFIG_FIXUP_WRITE_PERMISSION,
> so let the follow_page() return NULL to the __get_user_pages, and
> let the handle_mm_fault to fixup dirty/young tracking.
> 
> Checking the following code we can conclude that the handle_mm_fault
> is ready to handle the faults and the write permission violation is
> a kind of fault, so why don't we let the handle_mm_fault to
> handle that fault?
> 
> __get_user_pages()
>       while (!(page = follow_page(vma, start, foll_flags))) {
>          ...
>          ret = handle_mm_fault(mm, vma, start,
>                                                          fault_flags);
>          ...
>      }

Cheers,
Ben.


