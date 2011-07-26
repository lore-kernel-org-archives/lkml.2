Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab1GZMFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:05:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:49208 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab1GZMFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:05:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexey Skidanov <alexey-s@orbotech.com>
Subject: Re: =?utf-8?b?dmlydF90b19wYWdl?= for userspace pointers
Date: Tue, 26 Jul 2011 12:03:00 +0000 (UTC)
Message-ID: <loom.20110726T134944-182@post.gmane.org>
References: <87k4hgn8qa.fsf@inspiron.ap.columbia.edu> <878vxuxkfr.fsf@inspiron.ap.columbia.edu> <4D4DC2D6.8030905@ens-lyon.org> <4D583E17.80606@rath.org> <87tyg6utdl.fsf@inspiron.ap.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 192.118.27.253 (Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikolaus Rath <Nikolaus <at> rath.org> writes:

> 
> Nikolaus Rath <Nikolaus <at> rath.org> writes:
> > On 02/05/2011 04:36 PM, Brice Goglin wrote:
> >>> Is there an equivalent function to virt_to_page (and virt_to_phys) that
> >>> works with userspace pointers? Or do I have to manually walk through the
> >>> page tables? In the later case, are there any examples of this kind of
> >>> search that I could use as a basis?
> >>>   
> >> 
> >> You probably want get_user_pages() (or get_user_pages_fast()).
> >
> > Thanks for the pointer, that already helped a lot!
> >
> > I would, however, prefer a more primitive function that just gives me
> > the struct page without locking it. And if the page is swapped out, I'd
> > rather get a NULL pointer than having a page frame allocated.  Is there
> > anything like that?
> 
> After studying the source for get_user_pages(), I believe the following
> should do what I want:
> 
>     vma = find_extend_vma(current->mm, (unsigned long) data.vi_buf);
>     if(vma == NULL) {
>         err("find_extend_vma failed for VI.");
>     }
>     acq_dev->vi_pg = follow_page(vma, (unsigned long) data.vi_buf, 0);
>     if(acq_dev->vi_pg == NULL) {
>         err("follow_page failed for VI.");
>     }
> 
> Unfortunately, I'm getting into trouble at link time when using these
> functions:
> 
>   MODPOST 1 modules
> WARNING: "follow_page" 
[/home/nikratio/control/acq196_hostdrv/acq200_hostdrv.ko] undefined!
> WARNING: "find_extend_vma" 
[/home/nikratio/control/acq196_hostdrv/acq200_hostdrv.ko] undefined!
> 
> Can they only be used in the kernel itself, but not in kernel modules?
> 
> Thanks,
> 
>    -Nikolaus
> 


Hi,
I had the same problem working with NVIDIA GPU driver. The NVIDIA driver mmap 
allocated memory using vm_insert_page() - allowing inserting single page into 
the vma. So you need to translate go over the whole vma and translate it page 
by page. I just implemented the function to translate the virtual address to 
pfn. It mostly the same as follow_page:

/**
 * This function walks through page tables and get the PFN of virtual address
 */
long get_pfn_of_virtual_address(struct vm_area_struct *vma, unsigned long 
address, unsigned long& pfn) {

    pgd_t *pgd;
    pud_t *pud;
    pmd_t *pmd;
    pte_t *ptep;
    spinlock_t *ptl;
    struct mm_struct *mm = vma->vm_mm;

    pgd = pgd_offset(mm, address);
    if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
        return -EFAULT;

    pud = pud_offset(pgd, address);
    if (pud_none(*pud) || unlikely(pud_bad(*pud)))
        return -EFAULT;

    pmd = pmd_offset(pud, address);
    if (pmd_none(*pmd))
        return -EFAULT;

    ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
    pfn =  pte_pfn(*ptep);
    pte_unmap_unlock(ptep, ptl);

    return 0;

} 

