Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab2LMM65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 07:58:57 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49418 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab2LMM64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 07:58:56 -0500
MIME-Version: 1.0
X-Originating-IP: [178.70.154.20]
In-Reply-To: <50C9BCA8.3010504@citrix.com>
References: <1355350178-22315-1-git-send-email-mats.petersson@citrix.com>
 <CACaajQu9VexhRWXK8U_fjtjFSL6Bwk=0e8OdWhshh7UERmiuQg@mail.gmail.com> <50C9BCA8.3010504@citrix.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Thu, 13 Dec 2012 16:58:40 +0400
X-Google-Sender-Auth: H1qSuoo7XGRDc4-Q7pjMmZBMwJw
Message-ID: <CACaajQs+0TkdYYewCkX-DLaT514ve_VTSR0zr6bNBYciWvOiqw@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH V4] xen/privcmd: improve-performance-of-mapping-of-guest
To: Mats Petersson <mats.petersson@citrix.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "mats@planetcatfish.com" <mats@planetcatfish.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, i'm try.

2012/12/13 Mats Petersson <mats.petersson@citrix.com>:
> On 13/12/12 11:27, Vasiliy Tolstov wrote:
>>
>> If i apply this patch to kernel 3.6.7 does it needs to apply another
>> patches to work?
>
> No, it should "just work". Obviously, if it doesn't, let me know.
>
> --
> Mats
>
>>
>> 2012/12/13 Mats Petersson <mats.petersson@citrix.com>:
>>>
>>> One comment asked for more details on the improvements:
>>> Using a small test program to map Guest memory into Dom0 (repeatedly
>>> for "Iterations" mapping the same first "Num Pages")
>>> Iterations    Num Pages    Time 3.7rc4  Time With this patch
>>> 5000          4096         76.107       37.027
>>> 10000         2048         75.703       37.177
>>> 20000         1024         75.893       37.247
>>> So a little better than twice as fast.
>>>
>>> Using this patch in migration, using "time" to measure the overall
>>> time it take to migrate a guest (Debian Squeeze 6.0, 1024MB guest
>>> memory, one network card, one disk, guest at login prompt):
>>> Time 3.7rc5             Time With this patch
>>> 6.697                   5.667
>>> Since migration involves a whole lot of other things, it's only about
>>> 15% faster - but still a good improvement. Similar measurement with a
>>> guest that is running code to "dirty" memory shows about 23%
>>> improvement, as it spends more time copying dirtied memory.
>>>
>>> As discussed elsewhere, a good deal more can be had from improving the
>>> munmap system call, but it is a little tricky to get this in without
>>> worsening non-PVOPS kernel, so I will have another look at this.
>>>
>>> ---
>>> Update since last posting:
>>> I have just run some benchmarks of a 16GB guest, and the improvement
>>> with this patch is around 23-30% for the overall copy time, and 42%
>>> shorter downtime on a "busy" guest (writing in a loop to about 8GB of
>>> memory). I think this is definitely worth having.
>>>
>>> The V4 patch consists of cosmetic adjustments (spelling mistake in
>>> comment and reversing condition in an if-statement to avoid having an
>>> "else" branch, a random empty line added by accident now reverted back
>>> to previous state). Thanks to Jan Beulich for the comments.
>>>
>>> The V3 of the patch contains suggested improvements from:
>>> David Vrabel - make it two distinct external functions, doc-comments.
>>> Ian Campbell - use one common function for the main work.
>>> Jan Beulich  - found a bug and pointed out some whitespace problems.
>>>
>>>
>>>
>>> Signed-off-by: Mats Petersson <mats.petersson@citrix.com>
>>>
>>> ---
>>>   arch/x86/xen/mmu.c    |  132
>>> +++++++++++++++++++++++++++++++++++++++++++------
>>>   drivers/xen/privcmd.c |   55 +++++++++++++++++----
>>>   include/xen/xen-ops.h |    5 ++
>>>   3 files changed, 169 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
>>> index dcf5f2d..a67774f 100644
>>> --- a/arch/x86/xen/mmu.c
>>> +++ b/arch/x86/xen/mmu.c
>>> @@ -2477,7 +2477,8 @@ void __init xen_hvm_init_mmu_ops(void)
>>>   #define REMAP_BATCH_SIZE 16
>>>
>>>   struct remap_data {
>>> -       unsigned long mfn;
>>> +       unsigned long *mfn;
>>> +       bool contiguous;
>>>          pgprot_t prot;
>>>          struct mmu_update *mmu_update;
>>>   };
>>> @@ -2486,7 +2487,13 @@ static int remap_area_mfn_pte_fn(pte_t *ptep,
>>> pgtable_t token,
>>>                                   unsigned long addr, void *data)
>>>   {
>>>          struct remap_data *rmd = data;
>>> -       pte_t pte = pte_mkspecial(pfn_pte(rmd->mfn++, rmd->prot));
>>> +       pte_t pte = pte_mkspecial(pfn_pte(*rmd->mfn, rmd->prot));
>>> +       /* If we have a contigious range, just update the mfn itself,
>>> +          else update pointer to be "next mfn". */
>>> +       if (rmd->contiguous)
>>> +               (*rmd->mfn)++;
>>> +       else
>>> +               rmd->mfn++;
>>>
>>>          rmd->mmu_update->ptr = virt_to_machine(ptep).maddr;
>>>          rmd->mmu_update->val = pte_val_ma(pte);
>>> @@ -2495,16 +2502,34 @@ static int remap_area_mfn_pte_fn(pte_t *ptep,
>>> pgtable_t token,
>>>          return 0;
>>>   }
>>>
>>> -int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
>>> -                              unsigned long addr,
>>> -                              unsigned long mfn, int nr,
>>> -                              pgprot_t prot, unsigned domid)
>>> -{
>>> +/* do_remap_mfn() - helper function to map foreign pages
>>> + * @vma:     the vma for the pages to be mapped into
>>> + * @addr:    the address at which to map the pages
>>> + * @mfn:     pointer to array of MFNs to map
>>> + * @nr:      the number entries in the MFN array
>>> + * @err_ptr: pointer to array
>>> + * @prot:    page protection mask
>>> + * @domid:   id of the domain that we are mapping from
>>> + *
>>> + * This function takes an array of mfns and maps nr pages from that into
>>> + * this kernel's memory. The owner of the pages is defined by domid.
>>> Where the
>>> + * pages are mapped is determined by addr, and vma is used for
>>> "accounting" of
>>> + * the pages.
>>> + *
>>> + * Return value is zero for success, negative for failure.
>>> + *
>>> + * Note that err_ptr is used to indicate whether *mfn
>>> + * is a list or a "first mfn of a contiguous range". */
>>> +static int do_remap_mfn(struct vm_area_struct *vma,
>>> +                       unsigned long addr,
>>> +                       unsigned long *mfn, int nr,
>>> +                       int *err_ptr, pgprot_t prot,
>>> +                       unsigned domid)
>>> +{
>>> +       int err, last_err = 0;
>>>          struct remap_data rmd;
>>>          struct mmu_update mmu_update[REMAP_BATCH_SIZE];
>>> -       int batch;
>>>          unsigned long range;
>>> -       int err = 0;
>>>
>>>          if (xen_feature(XENFEAT_auto_translated_physmap))
>>>                  return -EINVAL;
>>> @@ -2515,9 +2540,15 @@ int xen_remap_domain_mfn_range(struct
>>> vm_area_struct *vma,
>>>
>>>          rmd.mfn = mfn;
>>>          rmd.prot = prot;
>>> +       /* We use the err_ptr to indicate if there we are doing a
>>> contigious
>>> +        * mapping or a discontigious mapping. */
>>> +       rmd.contiguous = !err_ptr;
>>>
>>>          while (nr) {
>>> -               batch = min(REMAP_BATCH_SIZE, nr);
>>> +               int index = 0;
>>> +               int done = 0;
>>> +               int batch = min(REMAP_BATCH_SIZE, nr);
>>> +               int batch_left = batch;
>>>                  range = (unsigned long)batch << PAGE_SHIFT;
>>>
>>>                  rmd.mmu_update = mmu_update;
>>> @@ -2526,19 +2557,92 @@ int xen_remap_domain_mfn_range(struct
>>> vm_area_struct *vma,
>>>                  if (err)
>>>                          goto out;
>>>
>>> -               err = HYPERVISOR_mmu_update(mmu_update, batch, NULL,
>>> domid);
>>> -               if (err < 0)
>>> -                       goto out;
>>> +               /* We record the error for each page that gives an error,
>>> but
>>> +                * continue mapping until the whole set is done */
>>> +               do {
>>> +                       err = HYPERVISOR_mmu_update(&mmu_update[index],
>>> +                                                   batch_left, &done,
>>> domid);
>>> +                       if (err < 0) {
>>> +                               if (!err_ptr)
>>> +                                       goto out;
>>> +                               /* increment done so we skip the error
>>> item */
>>> +                               done++;
>>> +                               last_err = err_ptr[index] = err;
>>> +                       }
>>> +                       batch_left -= done;
>>> +                       index += done;
>>> +               } while (batch_left);
>>>
>>>                  nr -= batch;
>>>                  addr += range;
>>> +               if (err_ptr)
>>> +                       err_ptr += batch;
>>>          }
>>>
>>> -       err = 0;
>>> +       err = last_err;
>>>   out:
>>>
>>>          xen_flush_tlb_all();
>>>
>>>          return err;
>>>   }
>>> +
>>> +/* xen_remap_domain_mfn_range() - Used to map foreign pages
>>> + * @vma:   the vma for the pages to be mapped into
>>> + * @addr:  the address at which to map the pages
>>> + * @mfn:   the first MFN to map
>>> + * @nr:    the number of consecutive mfns to map
>>> + * @prot:  page protection mask
>>> + * @domid: id of the domain that we are mapping from
>>> + *
>>> + * This function takes a mfn and maps nr pages on from that into this
>>> kernel's
>>> + * memory. The owner of the pages is defined by domid. Where the pages
>>> are
>>> + * mapped is determined by addr, and vma is used for "accounting" of the
>>> + * pages.
>>> + *
>>> + * Return value is zero for success, negative ERRNO value for failure.
>>> + */
>>> +int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
>>> +                              unsigned long addr,
>>> +                              unsigned long mfn, int nr,
>>> +                              pgprot_t prot, unsigned domid)
>>> +{
>>> +       return do_remap_mfn(vma, addr, &mfn, nr, NULL, prot, domid);
>>> +}
>>>   EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
>>> +
>>> +/* xen_remap_domain_mfn_array() - Used to map an array of foreign pages
>>> + * @vma:     the vma for the pages to be mapped into
>>> + * @addr:    the address at which to map the pages
>>> + * @mfn:     pointer to array of MFNs to map
>>> + * @nr:      the number entries in the MFN array
>>> + * @err_ptr: pointer to array of integers, one per MFN, for an error
>>> + *           value for each page. The err_ptr must not be NULL.
>>> + * @prot:    page protection mask
>>> + * @domid:   id of the domain that we are mapping from
>>> + *
>>> + * This function takes an array of mfns and maps nr pages from that into
>>> this
>>> + * kernel's memory. The owner of the pages is defined by domid. Where
>>> the pages
>>> + * are mapped is determined by addr, and vma is used for "accounting" of
>>> the
>>> + * pages. The err_ptr array is filled in on any page that is not
>>> sucessfully
>>> + * mapped in.
>>> + *
>>> + * Return value is zero for success, negative ERRNO value for failure.
>>> + * Note that the error value -ENOENT is considered a "retry", so when
>>> this
>>> + * error code is seen, another call should be made with the list of
>>> pages that
>>> + * are marked as -ENOENT in the err_ptr array.
>>> + */
>>> +int xen_remap_domain_mfn_array(struct vm_area_struct *vma,
>>> +                              unsigned long addr,
>>> +                              unsigned long *mfn, int nr,
>>> +                              int *err_ptr, pgprot_t prot,
>>> +                              unsigned domid)
>>> +{
>>> +       /* We BUG_ON because it's a programmer error to pass a NULL
>>> err_ptr,
>>> +        * and the consequences later is quite hard to detect what the
>>> actual
>>> +        * cause of "wrong memory was mapped in".
>>> +        */
>>> +       BUG_ON(err_ptr == NULL);
>>> +       return do_remap_mfn(vma, addr, mfn, nr, err_ptr, prot, domid);
>>> +}
>>> +EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_array);
>>> diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
>>> index 71f5c45..75f6e86 100644
>>> --- a/drivers/xen/privcmd.c
>>> +++ b/drivers/xen/privcmd.c
>>> @@ -151,6 +151,40 @@ static int traverse_pages(unsigned nelem, size_t
>>> size,
>>>          return ret;
>>>   }
>>>
>>> +/*
>>> + * Similar to traverse_pages, but use each page as a "block" of
>>> + * data to be processed as one unit.
>>> + */
>>> +static int traverse_pages_block(unsigned nelem, size_t size,
>>> +                               struct list_head *pos,
>>> +                               int (*fn)(void *data, int nr, void
>>> *state),
>>> +                               void *state)
>>> +{
>>> +       void *pagedata;
>>> +       unsigned pageidx;
>>> +       int ret = 0;
>>> +
>>> +       BUG_ON(size > PAGE_SIZE);
>>> +
>>> +       pageidx = PAGE_SIZE;
>>> +
>>> +       while (nelem) {
>>> +               int nr = (PAGE_SIZE/size);
>>> +               struct page *page;
>>> +               if (nr > nelem)
>>> +                       nr = nelem;
>>> +               pos = pos->next;
>>> +               page = list_entry(pos, struct page, lru);
>>> +               pagedata = page_address(page);
>>> +               ret = (*fn)(pagedata, nr, state);
>>> +               if (ret)
>>> +                       break;
>>> +               nelem -= nr;
>>> +       }
>>> +
>>> +       return ret;
>>> +}
>>> +
>>>   struct mmap_mfn_state {
>>>          unsigned long va;
>>>          struct vm_area_struct *vma;
>>> @@ -250,7 +284,7 @@ struct mmap_batch_state {
>>>           *      0 for no errors
>>>           *      1 if at least one error has happened (and no
>>>           *          -ENOENT errors have happened)
>>> -        *      -ENOENT if at least 1 -ENOENT has happened.
>>> +        *      -ENOENT if at least one -ENOENT has happened.
>>>           */
>>>          int global_error;
>>>          /* An array for individual errors */
>>> @@ -260,17 +294,20 @@ struct mmap_batch_state {
>>>          xen_pfn_t __user *user_mfn;
>>>   };
>>>
>>> -static int mmap_batch_fn(void *data, void *state)
>>> +static int mmap_batch_fn(void *data, int nr, void *state)
>>>   {
>>>          xen_pfn_t *mfnp = data;
>>>          struct mmap_batch_state *st = state;
>>>          int ret;
>>>
>>> -       ret = xen_remap_domain_mfn_range(st->vma, st->va & PAGE_MASK,
>>> *mfnp, 1,
>>> -                                        st->vma->vm_page_prot,
>>> st->domain);
>>> +       BUG_ON(nr < 0);
>>>
>>> -       /* Store error code for second pass. */
>>> -       *(st->err++) = ret;
>>> +       ret = xen_remap_domain_mfn_array(st->vma,
>>> +                                        st->va & PAGE_MASK,
>>> +                                        mfnp, nr,
>>> +                                        st->err,
>>> +                                        st->vma->vm_page_prot,
>>> +                                        st->domain);
>>>
>>>          /* And see if it affects the global_error. */
>>>          if (ret < 0) {
>>> @@ -282,7 +319,7 @@ static int mmap_batch_fn(void *data, void *state)
>>>                                  st->global_error = 1;
>>>                  }
>>>          }
>>> -       st->va += PAGE_SIZE;
>>> +       st->va += PAGE_SIZE * nr;
>>>
>>>          return 0;
>>>   }
>>> @@ -378,8 +415,8 @@ static long privcmd_ioctl_mmap_batch(void __user
>>> *udata, int version)
>>>          state.err           = err_array;
>>>
>>>          /* mmap_batch_fn guarantees ret == 0 */
>>> -       BUG_ON(traverse_pages(m.num, sizeof(xen_pfn_t),
>>> -                            &pagelist, mmap_batch_fn, &state));
>>> +       BUG_ON(traverse_pages_block(m.num, sizeof(xen_pfn_t),
>>> +                                   &pagelist, mmap_batch_fn, &state));
>>>
>>>          up_write(&mm->mmap_sem);
>>>
>>> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
>>> index 6a198e4..22cad75 100644
>>> --- a/include/xen/xen-ops.h
>>> +++ b/include/xen/xen-ops.h
>>> @@ -29,4 +29,9 @@ int xen_remap_domain_mfn_range(struct vm_area_struct
>>> *vma,
>>>                                 unsigned long mfn, int nr,
>>>                                 pgprot_t prot, unsigned domid);
>>>
>>> +int xen_remap_domain_mfn_array(struct vm_area_struct *vma,
>>> +                              unsigned long addr,
>>> +                              unsigned long *mfn, int nr,
>>> +                              int *err_ptr, pgprot_t prot,
>>> +                              unsigned domid);
>>>   #endif /* INCLUDE_XEN_OPS_H */
>>> --
>>> 1.7.9.5
>>>
>>>
>>> _______________________________________________
>>> Xen-devel mailing list
>>> Xen-devel@lists.xen.org
>>> http://lists.xen.org/xen-devel
>>
>>
>>
>> --
>> Vasiliy Tolstov,
>> Clodo.ru
>> e-mail: v.tolstov@selfip.ru
>> jabber: vase@selfip.ru
>
>



-- 
Vasiliy Tolstov,
Clodo.ru
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
