Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab0JFRnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 13:43:17 -0400
Received: from smtp.nokia.com ([147.243.1.47]:36319 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759070Ab0JFRnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 13:43:15 -0400
Date: Wed, 6 Oct 2010 20:32:46 +0300
From: David Cohen <david.cohen@nokia.com>
To: ext Fernando Guzman Lugo <x0095840@ti.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "Contreras Felipe (Nokia-MS/Helsinki)" <felipe.contreras@nokia.com>,
        "Palande Ameya (Nokia-MS/Helsinki)" <ameya.palande@nokia.com>,
        "nm@ti.com" <nm@ti.com>,
        "Doyu Hiroshi (Nokia-MS/Espoo)" <hiroshi.doyu@nokia.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCHv3 01/11] staging: tidspbridge: replace iommu custom for
 opensource implementation
Message-ID: <20101006173246.GA21764@esdhcp036161.research.nokia.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
 <1286310944-25035-2-git-send-email-x0095840@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286310944-25035-2-git-send-email-x0095840@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fernando,

I have few comments below.

> diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
> index 5718645..842b8db 100644
> --- a/drivers/staging/tidspbridge/core/io_sm.c
> +++ b/drivers/staging/tidspbridge/core/io_sm.c
> @@ -291,6 +291,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
>         struct cod_manager *cod_man;
>         struct chnl_mgr *hchnl_mgr;
>         struct msg_mgr *hmsg_mgr;
> +       struct iommu *mmu;
>         u32 ul_shm_base;
>         u32 ul_shm_base_offset;
>         u32 ul_shm_limit;
> @@ -313,7 +314,6 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
>         struct bridge_ioctl_extproc ae_proc[BRDIOCTL_NUMOFMMUTLB];
>         struct cfg_hostres *host_res;
>         struct bridge_dev_context *pbridge_context;
> -       u32 map_attrs;
>         u32 shm0_end;
>         u32 ul_dyn_ext_base;
>         u32 ul_seg1_size = 0;
> @@ -337,6 +337,20 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
>                 status = -EFAULT;
>                 goto func_end;
>         }
> +       mmu = pbridge_context->dsp_mmu;
> +
> +       if (mmu)
> +               iommu_put(mmu);
> +       mmu = iommu_get("iva2");
> +
> +       if (IS_ERR_OR_NULL(mmu)) {

You can use IS_ERR() instead.

[snip]

> @@ -1122,217 +1081,81 @@ static int bridge_brd_mem_write(struct bridge_dev_context *dev_ctxt,
>   *
>   *  TODO: Disable MMU while updating the page tables (but that'll stall DSP)
>   */
> -static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctxt,
> -                                 u32 ul_mpu_addr, u32 virt_addr,
> -                                 u32 ul_num_bytes, u32 ul_map_attr,
> -                                 struct page **mapped_pages)
> +static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctx,
> +                       u32 uva, u32 da, u32 size, u32 attr,
> +                       struct page **usr_pgs)
> +
>  {
> -       u32 attrs;
> -       int status = 0;
> -       struct bridge_dev_context *dev_context = dev_ctxt;
> -       struct hw_mmu_map_attrs_t hw_attrs;
> +       int res, w;
> +       unsigned pages, i;
> +       struct iommu *mmu = dev_ctx->dsp_mmu;
>         struct vm_area_struct *vma;
>         struct mm_struct *mm = current->mm;
> -       u32 write = 0;
> -       u32 num_usr_pgs = 0;
> -       struct page *mapped_page, *pg;
> -       s32 pg_num;
> -       u32 va = virt_addr;
> -       struct task_struct *curr_task = current;
> -       u32 pg_i = 0;
> -       u32 mpu_addr, pa;
> -
> -       dev_dbg(bridge,
> -               "%s hDevCtxt %p, pa %x, va %x, size %x, ul_map_attr %x\n",
> -               __func__, dev_ctxt, ul_mpu_addr, virt_addr, ul_num_bytes,
> -               ul_map_attr);
> -       if (ul_num_bytes == 0)
> -               return -EINVAL;
> +       struct sg_table *sgt;
> +       struct scatterlist *sg;
> 
> -       if (ul_map_attr & DSP_MAP_DIR_MASK) {
> -               attrs = ul_map_attr;
> -       } else {
> -               /* Assign default attributes */
> -               attrs = ul_map_attr | (DSP_MAPVIRTUALADDR | DSP_MAPELEMSIZE16);
> -       }
> -       /* Take mapping properties */
> -       if (attrs & DSP_MAPBIGENDIAN)
> -               hw_attrs.endianism = HW_BIG_ENDIAN;
> -       else
> -               hw_attrs.endianism = HW_LITTLE_ENDIAN;
> -
> -       hw_attrs.mixed_size = (enum hw_mmu_mixed_size_t)
> -           ((attrs & DSP_MAPMIXEDELEMSIZE) >> 2);
> -       /* Ignore element_size if mixed_size is enabled */
> -       if (hw_attrs.mixed_size == 0) {
> -               if (attrs & DSP_MAPELEMSIZE8) {
> -                       /* Size is 8 bit */
> -                       hw_attrs.element_size = HW_ELEM_SIZE8BIT;
> -               } else if (attrs & DSP_MAPELEMSIZE16) {
> -                       /* Size is 16 bit */
> -                       hw_attrs.element_size = HW_ELEM_SIZE16BIT;
> -               } else if (attrs & DSP_MAPELEMSIZE32) {
> -                       /* Size is 32 bit */
> -                       hw_attrs.element_size = HW_ELEM_SIZE32BIT;
> -               } else if (attrs & DSP_MAPELEMSIZE64) {
> -                       /* Size is 64 bit */
> -                       hw_attrs.element_size = HW_ELEM_SIZE64BIT;
> -               } else {
> -                       /*
> -                        * Mixedsize isn't enabled, so size can't be
> -                        * zero here
> -                        */
> -                       return -EINVAL;
> -               }
> -       }
> -       if (attrs & DSP_MAPDONOTLOCK)
> -               hw_attrs.donotlockmpupage = 1;
> -       else
> -               hw_attrs.donotlockmpupage = 0;
> +       if (!size || !usr_pgs)
> +               return -EINVAL;
> 
> -       if (attrs & DSP_MAPVMALLOCADDR) {
> -               return mem_map_vmalloc(dev_ctxt, ul_mpu_addr, virt_addr,
> -                                      ul_num_bytes, &hw_attrs);
> -       }
> -       /*
> -        * Do OS-specific user-va to pa translation.
> -        * Combine physically contiguous regions to reduce TLBs.
> -        * Pass the translated pa to pte_update.
> -        */
> -       if ((attrs & DSP_MAPPHYSICALADDR)) {
> -               status = pte_update(dev_context, ul_mpu_addr, virt_addr,
> -                                   ul_num_bytes, &hw_attrs);
> -               goto func_cont;
> -       }
> +       pages = size / PG_SIZE4K;

Can you ensure 'size' is always PG_SIZE4K aligned?
I don't have so much knowledge about the dsp bridge implementation, but you're
testing only if size == 0.

> 
> -       /*
> -        * Important Note: ul_mpu_addr is mapped from user application process
> -        * to current process - it must lie completely within the current
> -        * virtual memory address space in order to be of use to us here!
> -        */
>         down_read(&mm->mmap_sem);
> -       vma = find_vma(mm, ul_mpu_addr);
> -       if (vma)
> -               dev_dbg(bridge,
> -                       "VMAfor UserBuf: ul_mpu_addr=%x, ul_num_bytes=%x, "
> -                       "vm_start=%lx, vm_end=%lx, vm_flags=%lx\n", ul_mpu_addr,
> -                       ul_num_bytes, vma->vm_start, vma->vm_end,
> -                       vma->vm_flags);
> -
> -       /*
> -        * It is observed that under some circumstances, the user buffer is
> -        * spread across several VMAs. So loop through and check if the entire
> -        * user buffer is covered
> -        */
> -       while ((vma) && (ul_mpu_addr + ul_num_bytes > vma->vm_end)) {
> -               /* jump to the next VMA region */
> +       vma = find_vma(mm, uva);
> +       while (vma && (uva + size > vma->vm_end))
>                 vma = find_vma(mm, vma->vm_end + 1);
> -               dev_dbg(bridge,
> -                       "VMA for UserBuf ul_mpu_addr=%x ul_num_bytes=%x, "
> -                       "vm_start=%lx, vm_end=%lx, vm_flags=%lx\n", ul_mpu_addr,
> -                       ul_num_bytes, vma->vm_start, vma->vm_end,
> -                       vma->vm_flags);
> -       }
> +
>         if (!vma) {
>                 pr_err("%s: Failed to get VMA region for 0x%x (%d)\n",
> -                      __func__, ul_mpu_addr, ul_num_bytes);
> -               status = -EINVAL;
> +                                               __func__, uva, size);
>                 up_read(&mm->mmap_sem);
> -               goto func_cont;
> +               return -EINVAL;
>         }
> +       if (vma->vm_flags & (VM_WRITE | VM_MAYWRITE))
> +               w = 1;
> 
> -       if (vma->vm_flags & VM_IO) {
> -               num_usr_pgs = ul_num_bytes / PG_SIZE4K;
> -               mpu_addr = ul_mpu_addr;
> -
> -               /* Get the physical addresses for user buffer */
> -               for (pg_i = 0; pg_i < num_usr_pgs; pg_i++) {
> -                       pa = user_va2_pa(mm, mpu_addr);
> -                       if (!pa) {
> -                               status = -EPERM;
> -                               pr_err("DSPBRIDGE: VM_IO mapping physical"
> -                                      "address is invalid\n");
> -                               break;
> -                       }
> -                       if (pfn_valid(__phys_to_pfn(pa))) {
> -                               pg = PHYS_TO_PAGE(pa);
> -                               get_page(pg);
> -                               if (page_count(pg) < 1) {
> -                                       pr_err("Bad page in VM_IO buffer\n");
> -                                       bad_page_dump(pa, pg);
> -                               }
> -                       }
> -                       status = pte_set(dev_context->pt_attrs, pa,
> -                                        va, HW_PAGE_SIZE4KB, &hw_attrs);
> -                       if (status)
> -                               break;
> +       if (vma->vm_flags & VM_IO)
> +               i = get_io_pages(mm, uva, pages, usr_pgs);
> +       else
> +               i = get_user_pages(current, mm, uva, pages, w, 1,
> +                                                       usr_pgs, NULL);
> +       up_read(&mm->mmap_sem);
> 
> -                       va += HW_PAGE_SIZE4KB;
> -                       mpu_addr += HW_PAGE_SIZE4KB;
> -                       pa += HW_PAGE_SIZE4KB;
> -               }
> -       } else {
> -               num_usr_pgs = ul_num_bytes / PG_SIZE4K;
> -               if (vma->vm_flags & (VM_WRITE | VM_MAYWRITE))
> -                       write = 1;
> -
> -               for (pg_i = 0; pg_i < num_usr_pgs; pg_i++) {
> -                       pg_num = get_user_pages(curr_task, mm, ul_mpu_addr, 1,
> -                                               write, 1, &mapped_page, NULL);
> -                       if (pg_num > 0) {
> -                               if (page_count(mapped_page) < 1) {
> -                                       pr_err("Bad page count after doing"
> -                                              "get_user_pages on"
> -                                              "user buffer\n");
> -                                       bad_page_dump(page_to_phys(mapped_page),
> -                                                     mapped_page);
> -                               }
> -                               status = pte_set(dev_context->pt_attrs,
> -                                                page_to_phys(mapped_page), va,
> -                                                HW_PAGE_SIZE4KB, &hw_attrs);
> -                               if (status)
> -                                       break;
> -
> -                               if (mapped_pages)
> -                                       mapped_pages[pg_i] = mapped_page;
> -
> -                               va += HW_PAGE_SIZE4KB;
> -                               ul_mpu_addr += HW_PAGE_SIZE4KB;
> -                       } else {
> -                               pr_err("DSPBRIDGE: get_user_pages FAILED,"
> -                                      "MPU addr = 0x%x,"
> -                                      "vma->vm_flags = 0x%lx,"
> -                                      "get_user_pages Err"
> -                                      "Value = %d, Buffer"
> -                                      "size=0x%x\n", ul_mpu_addr,
> -                                      vma->vm_flags, pg_num, ul_num_bytes);
> -                               status = -EPERM;
> -                               break;
> -                       }
> -               }
> +       if (i < 0)
> +               return i;
> +
> +       if (i < pages) {
> +               res = -EFAULT;
> +               goto err_pages;
>         }
> -       up_read(&mm->mmap_sem);
> -func_cont:
> -       if (status) {
> -               /*
> -                * Roll out the mapped pages incase it failed in middle of
> -                * mapping
> -                */
> -               if (pg_i) {
> -                       bridge_brd_mem_un_map(dev_context, virt_addr,
> -                                          (pg_i * PG_SIZE4K));
> -               }
> -               status = -EPERM;
> +
> +       sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
> +       if (!sgt) {
> +               res = -ENOMEM;
> +               goto err_pages;
>         }
> -       /*
> -        * In any case, flush the TLB
> -        * This is called from here instead from pte_update to avoid unnecessary
> -        * repetition while mapping non-contiguous physical regions of a virtual
> -        * region
> -        */
> -       flush_all(dev_context);
> -       dev_dbg(bridge, "%s status %x\n", __func__, status);
> -       return status;
> +
> +       res = sg_alloc_table(sgt, pages, GFP_KERNEL);
> +
> +       if (res < 0)
> +               goto err_sg;
> +
> +       for_each_sg(sgt->sgl, sg, sgt->nents, i)
> +               sg_set_page(sg, usr_pgs[i], PAGE_SIZE, 0);
> +
> +       da = iommu_vmap(mmu, da, sgt, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
> +
> +       if (!IS_ERR_VALUE(da))
> +               return 0;

It might be a matter of taste, but you could unconditionally return 0
and add a goto in case of error like you're doing in the rest of the
function. IMO it would improve readability to point out the code for
non-error condition has ended here.

Br,

David

> +       res = (int)da;
> +
> +       sg_free_table(sgt);
> +err_sg:
> +       kfree(sgt);
> +       i = pages;
> +err_pages:
> +       while (i--)
> +               put_page(usr_pgs[i]);
> +       return res;
>  }
> 

