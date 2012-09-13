Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab2IMQww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:52:52 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63481 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2IMQwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:52:49 -0400
MIME-Version: 1.0
In-Reply-To: <5051FA51.9010207@vodafone.de>
References: <1347545629-3474-1-git-send-email-Dmitrii.Cherkasov@amd.com>
	<5051FA51.9010207@vodafone.de>
Date: Thu, 13 Sep 2012 20:52:48 +0400
Message-ID: <CAN0j1dQH-PkY1HFtsAyA9+AjE63CfCufoo2sL9EVRdpUf2Hfhw@mail.gmail.com>
Subject: Re: [PATCH] Add 2-level GPUVM pagetables support to radeon driver.
From: Dmitry Cherkassov <dcherkassov@gmail.com>
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian,

> as I already noted in our internal discussion, the first step to
> hierarchical page table support should be to cleanup the set_page interface.
> Please see the attached patch, it does exactly this. I suggest that you
> rebase on it and try to don't touch the chipset specific code in ni.c any
> more (if you find that you need to change something there move that into
> this cleanup patch instead).
>

Currently we alloc all PTs in one call and they lay at fixed distance
from each other.
Using this knowledge we can setup all PDEs of BO in one pass.

I suggest the following changes to the cleanup patch:
* add BLOCK_SIZE bitfield to bo_va->flags (RADEON_VM_FLAGS)
* shift RADEON_GPU_PAGE_SIZE by BLOCK_SIZE obtained from flags here:

void cayman_vm_set_page(struct radeon_device *rdev, uint64_t pe,
			uint64_t addr, unsigned count, uint32_t flags)
{
+             unsigned block_size = RADEON_EXTRACT_BLOCKSIZE(flags)
	       struct radeon_ring *ring = &rdev->ring[rdev->asic->vm.pt_ring_index];
	       uint32_t r600_flags = cayman_vm_page_flags(rdev, flags);


		} else if (flags & RADEON_VM_PAGE_VALID) {
			value = addr;
-			addr += RADEON_GPU_PAGE_SIZE;
+                      addr += RADEON_GPU_PAGE_SIZE << block_size;
		}


In future when PTt's may be scattered around due to their on-demand
allocation we may devise
a method to supply list of their addresses to this code (array or
callback function, whatever).

What do you think?


> Additionally to that see the notes below:
>
>
> On 13.09.2012 16:13, Dmitry Cherkasov wrote:
>>
>> PDE/PTE update code uses CP ring for memory writes.
>> All page table entries are preallocated for now in alloc_pt().
>>
>> It is made as whole because it's hard to divide it to several patches
>> that compile and doesn't break anything being applied separately.
>>
>> Tested on cayman card.
>>
>> Signed-off-by: Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
>> ---
>> I couldn't test in on SI card, so would be happy if someone could check it
>> there.
>>
>>   drivers/gpu/drm/radeon/ni.c          |   64 ++++++++++++++++++-------
>>   drivers/gpu/drm/radeon/radeon.h      |   79
>> +++++++++++++++++++++++++++---
>>   drivers/gpu/drm/radeon/radeon_asic.c |    1 +
>>   drivers/gpu/drm/radeon/radeon_asic.h |   13 +++--
>>   drivers/gpu/drm/radeon/radeon_gart.c |   88
>> ++++++++++++++++++++++++++++++----
>>   drivers/gpu/drm/radeon/si.c          |    4 +-
>>   6 files changed, 210 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
>> index b238216..31d9027 100644
>> --- a/drivers/gpu/drm/radeon/ni.c
>> +++ b/drivers/gpu/drm/radeon/ni.c
>> @@ -782,7 +782,7 @@ static int cayman_pcie_gart_enable(struct
>> radeon_device *rdev)
>>                (u32)(rdev->dummy_page.addr >> 12));
>>         WREG32(VM_CONTEXT1_CNTL2, 0);
>>         WREG32(VM_CONTEXT1_CNTL, 0);
>> -       WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(0) |
>> +       WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(1) |
>>                                 RANGE_PROTECTION_FAULT_ENABLE_DEFAULT);
>>         cayman_pcie_gart_tlb_flush(rdev);
>> @@ -1517,37 +1517,65 @@ uint32_t cayman_vm_page_flags(struct radeon_device
>> *rdev, uint32_t flags)
>>         return r600_flags;
>>   }
>>   -/**
>> - * cayman_vm_set_page - update the page tables using the CP
>> - *
>> - * @rdev: radeon_device pointer
>> - *
>> - * Update the page tables using the CP (cayman-si).
>> - */
>
> It's probably just a rebase artifact, please never remove those
> documentation lines. Instead fix them if the need arise.
>
>
>> -void cayman_vm_set_page(struct radeon_device *rdev, struct radeon_vm *vm,
>> -                       unsigned pfn, struct ttm_mem_reg *mem,
>> -                       unsigned npages, uint32_t flags)
>> +void cayman_vm_set_page(struct radeon_device *rdev,
>> +                       struct ttm_mem_reg *mem,
>> +                       uint64_t pte_gpu_addr,
>> +                       uint64_t mem_pfn_offset,
>> +                       unsigned count, uint32_t flags)
>>   {
>>         struct radeon_ring *ring =
>> &rdev->ring[rdev->asic->vm.pt_ring_index];
>> -       uint64_t addr, pt = vm->pt_gpu_addr + pfn * 8;
>> +       uint64_t addr;
>>         int i;
>>         addr = flags = cayman_vm_page_flags(rdev, flags);
>>   -     radeon_ring_write(ring, PACKET3(PACKET3_ME_WRITE, 1 + npages *
>> 2));
>> -       radeon_ring_write(ring, pt & 0xffffffff);
>> -       radeon_ring_write(ring, (pt >> 32) & 0xff);
>> -       for (i = 0; i < npages; ++i) {
>> +       radeon_ring_write(ring, PACKET3(PACKET3_ME_WRITE, 1 + count * 2));
>> +       radeon_ring_write(ring, pte_gpu_addr & 0xffffffff);
>> +       radeon_ring_write(ring, (pte_gpu_addr >> 32) & 0xff);
>> +       for (i = 0; i < count; ++i) {
>>                 if (mem) {
>> -                       addr = radeon_vm_get_addr(rdev, mem, i);
>> +                       addr = radeon_vm_get_addr(rdev, mem,
>> +                                                 i + mem_pfn_offset);
>>                         addr = addr & 0xFFFFFFFFFFFFF000ULL;
>>                         addr |= flags;
>>                 }
>> +
>> +               radeon_ring_write(ring, addr & 0xffffffff);
>> +               radeon_ring_write(ring, (addr >> 32) & 0xffffffff);
>> +       }
>> +}
>> +
>> +void cayman_vm_set_pdes(struct radeon_device *rdev,
>> +                       struct ttm_mem_reg *mem,
>> +                       struct radeon_vm *vm,
>> +                       uint64_t pde_index,
>> +                       unsigned pde_count, uint32_t flags)
>> +{
>> +       struct radeon_ring *ring =
>> &rdev->ring[rdev->asic->vm.pt_ring_index];
>> +       uint64_t addr;
>> +       int i;
>> +       uint64_t pde_gpu_addr = RADEON_BASE_GPU_ADDR(vm) +
>> +           PDE_OFFSET(rdev, pde_index);
>> +
>> +       addr = 0;
>> +
>> +       radeon_ring_write(ring, PACKET3(PACKET3_ME_WRITE, 1 + pde_count *
>> 2));
>> +       radeon_ring_write(ring, pde_gpu_addr & 0xffffffff);
>> +       radeon_ring_write(ring, (pde_gpu_addr >> 32) & 0xff);
>> +
>> +       for (i = 0; i < pde_count; ++i) {
>> +               addr = RADEON_BASE_GPU_ADDR(vm) +
>> +                   PTE_OFFSET(rdev, i + pde_index, 0);
>> +               addr = addr & 0xFFFFFFFFFFFFF000ULL;
>> +               addr |= flags;
>> +
>>                 radeon_ring_write(ring, addr & 0xffffffff);
>>                 radeon_ring_write(ring, (addr >> 32) & 0xffffffff);
>>         }
>>   }
>>   +
>> +
>
> Splitting that into two functions should be made unnecessary by the
> interface cleanup patch.
>
>
>>   /**
>>    * cayman_vm_flush - vm flush using the CP
>>    *
>> @@ -1571,7 +1599,7 @@ void cayman_vm_flush(struct radeon_device *rdev,
>> struct radeon_ib *ib)
>>         radeon_ring_write(ring, vm->last_pfn);
>>         radeon_ring_write(ring, PACKET0(VM_CONTEXT0_PAGE_TABLE_BASE_ADDR +
>> (vm->id << 2), 0));
>> -       radeon_ring_write(ring, vm->pt_gpu_addr >> 12);
>> +       radeon_ring_write(ring, vm->pd_gpu_addr >> 12);
>>         /* flush hdp cache */
>>         radeon_ring_write(ring, PACKET0(HDP_MEM_COHERENCY_FLUSH_CNTL, 0));
>> diff --git a/drivers/gpu/drm/radeon/radeon.h
>> b/drivers/gpu/drm/radeon/radeon.h
>> index 4d67f0f..062896f 100644
>> --- a/drivers/gpu/drm/radeon/radeon.h
>> +++ b/drivers/gpu/drm/radeon/radeon.h
>> @@ -655,8 +655,8 @@ struct radeon_vm {
>>         struct list_head                va;
>>         unsigned                        id;
>>         unsigned                        last_pfn;
>> -       u64                             pt_gpu_addr;
>> -       u64                             *pt;
>> +       u64                             pd_gpu_addr;
>> +       u64 __iomem                     *pd_addr;
>
> We probably never need the CPU address of the page directory, except for
> initial clearing it.
>
>
>>         struct radeon_sa_bo             *sa_bo;
>>         struct mutex                    mutex;
>>         /* last fence for cs using this vm */
>> @@ -679,6 +679,57 @@ struct radeon_vm_manager {
>>         bool                            enabled;
>>   };
>>   +
>> +
>> +/* We consider the case where BLOCK_SIZE is 0 */
>> +/* So PDE is 19 bits long, PTE is 9 and OFFSET is 12 */
>> +#define RADEON_BLOCK_SIZE   0
>> +
>> +/* By default there are 512 entries in Page Table */
>> +#define RADEON_DEFAULT_PTE_COUNT (1 << 9)
>> +
>> +/* number of PTEs in Page Table */
>> +#define RADEON_PTE_COUNT (RADEON_DEFAULT_PTE_COUNT << RADEON_BLOCK_SIZE)
>> +
>> +/* Get last PDE number containing nth PTE */
>> +#define RADEON_GET_LAST_PDE_FOR_PFN(_n)        ((_n) / RADEON_PTE_COUNT)
>> +
>> +/* Get PTE number to containing nth pfn */
>> +#define RADEON_GET_PTE_FOR_PFN(_n)     ((_n) % RADEON_PTE_COUNT)
>> +
>> +/* Number of PDE tables to cover n PTEs */
>> +#define RADEON_PDE_COUNT_FOR_N_PAGES(_n) \
>> +       (((_n) + RADEON_PTE_COUNT - 1) / RADEON_PTE_COUNT)
>> +
>> +/* Number of PDE tables to cover max_pfn (maximum number of PTEs) */
>> +#define RADEON_TOTAL_PDE_COUNT(rdev) \
>> +       RADEON_PDE_COUNT_FOR_N_PAGES(rdev->vm_manager.max_pfn)
>> +
>> +#define PTE_SIZE 8
>> +#define PDE_SIZE 8
>> +
>> +/* offset for nth PDE starting from beginning of PDE table */
>> +#define PDE_OFFSET(_rdev, _npde) ((_npde) * PDE_SIZE)
>> +
>> +#define PT_OFFSET(_rdev) \
>> +       (RADEON_GPU_PAGE_ALIGN(RADEON_TOTAL_PDE_COUNT(rdev) * PDE_SIZE))
>> +
>> +/* offset for nth PTE of mth PDE starting from beginning of PDE table */
>> +#define PTE_OFFSET(_rdev, _npde, _npte) \
>> +       (PT_OFFSET(_rdev) +     \
>> +         (_npde) * RADEON_PTE_COUNT   * PTE_SIZE + \
>> +         (_npte) * PTE_SIZE)
>
> All defines should have RADEON_ prefix, also I'm not 100% sure why we need
> that as a global define, only the vm code should deal with that.
>
>
>> +
>> +/* cpu address of gpuvm page table */
>> +#define RADEON_BASE_CPU_ADDR(_vm)                      \
>> +       radeon_sa_bo_cpu_addr(vm->sa_bo)
>> +
>> +/* gpu address of gpuvm page table */
>> +#define RADEON_BASE_GPU_ADDR(_vm)                      \
>> +       radeon_sa_bo_gpu_addr(vm->sa_bo)
>> +
>> +#define RADEON_PDE_FLAG_VALID 1
>> +
>>   /*
>>    * file private structure
>>    */
>> @@ -1141,9 +1192,20 @@ struct radeon_asic {
>>                 void (*fini)(struct radeon_device *rdev);
>>                 u32 pt_ring_index;
>> -               void (*set_page)(struct radeon_device *rdev, struct
>> radeon_vm *vm,
>> -                                unsigned pfn, struct ttm_mem_reg *mem,
>> -                                unsigned npages, uint32_t flags);
>> +               void (*set_page)(
>> +                       struct radeon_device *rdev,
>> +                       struct ttm_mem_reg *mem,
>> +                       uint64_t pte_gpu_addr, uint64_t mem_pfn_offset,
>> +                       unsigned count, uint32_t flags
>> +);
>> +
>> +               void (*set_pdes)(
>> +                       struct radeon_device *rdev,
>> +                       struct ttm_mem_reg *mem,
>> +                       struct radeon_vm *vm,
>> +                       uint64_t pde_index,
>> +                       unsigned pde_count, uint32_t flags);
>> +
>>         } vm;
>>         /* ring specific callbacks */
>>         struct {
>> @@ -1755,7 +1817,12 @@ void radeon_ring_write(struct radeon_ring *ring,
>> uint32_t v);
>>   #define radeon_gart_set_page(rdev, i, p)
>> (rdev)->asic->gart.set_page((rdev), (i), (p))
>>   #define radeon_asic_vm_init(rdev) (rdev)->asic->vm.init((rdev))
>>   #define radeon_asic_vm_fini(rdev) (rdev)->asic->vm.fini((rdev))
>> -#define radeon_asic_vm_set_page(rdev, v, pfn, mem, npages, flags)
>> (rdev)->asic->vm.set_page((rdev), (v), (pfn), (mem), (npages), (flags))
>> +#define radeon_asic_vm_set_page(rdev, mem, start_pte, start_pfn, count,
>> flags) \
>> +((rdev)->asic->vm.set_page((rdev), (mem), (start_pte), (start_pfn),    \
>> +                            (count), (flags)))
>> +#define radeon_asic_vm_set_pdes(rdev, mem, vm, pde_index, pde_count,
>> flags) \
>> +((rdev)->asic->vm.set_pdes((rdev), (mem), (vm), (pde_index), \
>> +                        (pde_count), (flags)))
>>   #define radeon_ring_start(rdev, r, cp)
>> (rdev)->asic->ring[(r)].ring_start((rdev), (cp))
>>   #define radeon_ring_test(rdev, r, cp)
>> (rdev)->asic->ring[(r)].ring_test((rdev), (cp))
>>   #define radeon_ib_test(rdev, r, cp)
>> (rdev)->asic->ring[(r)].ib_test((rdev), (cp))
>> diff --git a/drivers/gpu/drm/radeon/radeon_asic.c
>> b/drivers/gpu/drm/radeon/radeon_asic.c
>> index 2f7adea..0df6a55 100644
>> --- a/drivers/gpu/drm/radeon/radeon_asic.c
>> +++ b/drivers/gpu/drm/radeon/radeon_asic.c
>> @@ -1377,6 +1377,7 @@ static struct radeon_asic cayman_asic = {
>>                 .fini = &cayman_vm_fini,
>>                 .pt_ring_index = RADEON_RING_TYPE_GFX_INDEX,
>>                 .set_page = &cayman_vm_set_page,
>> +               .set_pdes = &cayman_vm_set_pdes,
>>         },
>>         .ring = {
>>                 [RADEON_RING_TYPE_GFX_INDEX] = {
>> diff --git a/drivers/gpu/drm/radeon/radeon_asic.h
>> b/drivers/gpu/drm/radeon/radeon_asic.h
>> index 29b3d05..7a694c0 100644
>> --- a/drivers/gpu/drm/radeon/radeon_asic.h
>> +++ b/drivers/gpu/drm/radeon/radeon_asic.h
>> @@ -442,9 +442,16 @@ int cayman_vm_init(struct radeon_device *rdev);
>>   void cayman_vm_fini(struct radeon_device *rdev);
>>   void cayman_vm_flush(struct radeon_device *rdev, struct radeon_ib *ib);
>>   uint32_t cayman_vm_page_flags(struct radeon_device *rdev, uint32_t
>> flags);
>> -void cayman_vm_set_page(struct radeon_device *rdev, struct radeon_vm *vm,
>> -                       unsigned pfn, struct ttm_mem_reg *mem,
>> -                       unsigned npages, uint32_t flags);
>> +void cayman_vm_set_page(struct radeon_device *rdev,
>> +                       struct ttm_mem_reg *mem,
>> +                       uint64_t pte_gpu_addr, uint64_t mem_pfn_offset,
>> +                       unsigned count, uint32_t flags);
>> +void cayman_vm_set_pdes(struct radeon_device *rdev,
>> +                       struct ttm_mem_reg *mem,
>> +                       struct radeon_vm *vm,
>> +                       uint64_t pde_index,
>> +                       unsigned pde_count, uint32_t flags);
>> +
>>   int evergreen_ib_parse(struct radeon_device *rdev, struct radeon_ib
>> *ib);
>>     /* DCE6 - SI */
>> diff --git a/drivers/gpu/drm/radeon/radeon_gart.c
>> b/drivers/gpu/drm/radeon/radeon_gart.c
>> index 2f28ff3..f9bda6e 100644
>> --- a/drivers/gpu/drm/radeon/radeon_gart.c
>> +++ b/drivers/gpu/drm/radeon/radeon_gart.c
>> @@ -490,7 +490,6 @@ static void radeon_vm_free_pt(struct radeon_device
>> *rdev,
>>         list_del_init(&vm->list);
>>         radeon_sa_bo_free(rdev, &vm->sa_bo, vm->fence);
>> -       vm->pt = NULL;
>>         list_for_each_entry(bo_va, &vm->va, vm_list) {
>>                 bo_va->valid = false;
>> @@ -547,6 +546,10 @@ int radeon_vm_alloc_pt(struct radeon_device *rdev,
>> struct radeon_vm *vm)
>>         struct radeon_vm *vm_evict;
>>         int r;
>>   +     int gpuvm_tables_sz =
>> +           RADEON_GPU_PAGE_ALIGN(RADEON_TOTAL_PDE_COUNT(rdev) * PDE_SIZE)
>> +
>> +           vm->last_pfn  * PTE_SIZE;
>> +
>>         if (vm == NULL) {
>>                 return -EINVAL;
>>         }
>> @@ -560,7 +563,7 @@ int radeon_vm_alloc_pt(struct radeon_device *rdev,
>> struct radeon_vm *vm)
>>     retry:
>>         r = radeon_sa_bo_new(rdev, &rdev->vm_manager.sa_manager,
>> &vm->sa_bo,
>> -                            RADEON_GPU_PAGE_ALIGN(vm->last_pfn * 8),
>> +                            gpuvm_tables_sz,
>>                              RADEON_GPU_PAGE_SIZE, false);
>>         if (r == -ENOMEM) {
>>                 if (list_empty(&rdev->vm_manager.lru_vm)) {
>> @@ -576,9 +579,13 @@ retry:
>>                 return r;
>>         }
>>   -     vm->pt = radeon_sa_bo_cpu_addr(vm->sa_bo);
>> -       vm->pt_gpu_addr = radeon_sa_bo_gpu_addr(vm->sa_bo);
>> -       memset(vm->pt, 0, RADEON_GPU_PAGE_ALIGN(vm->last_pfn * 8));
>> +       DRM_INFO("radeon: reserved %d kb pd & pt tables\n",
>> +                gpuvm_tables_sz/1024);
>> +
>> +       vm->pd_addr = radeon_sa_bo_cpu_addr(vm->sa_bo);
>> +       vm->pd_gpu_addr = radeon_sa_bo_gpu_addr(vm->sa_bo);
>> +       memset(vm->pd_addr, 0, gpuvm_tables_sz);
>> +
>>         list_add_tail(&vm->list, &rdev->vm_manager.lru_vm);
>>         return radeon_vm_bo_update_pte(rdev, vm, rdev->ring_tmp_bo.bo,
>> @@ -861,6 +868,63 @@ u64 radeon_vm_get_addr(struct radeon_device *rdev,
>>   }
>>     /**
>> + * radeon_vm_bo_set_pages - update PDE and PTE for pfn
>> + *
>> + * @rdev: radeon_device pointer
>> + * @first_pfn: first pfn in bo address space to start mapping from
>> + * @mem: ttm mem
>> + * @vm: requested vm
>> + * @bo: radeon buffer object
>> + *
>> + * Update page directory and table entries for pfn (cayman+).
>> + */
>> +
>> +int radeon_vm_bo_set_pages(struct radeon_device *rdev, struct radeon_vm
>> *vm,
>> +                          unsigned first_pfn, struct ttm_mem_reg *mem,
>> +                          unsigned npages, uint32_t flags)
>
> Shouldn't that be a static function?
>
>
>> +{
>> +       u64 pde_num, pte_num, start_pde, pde_count = 0;
>> +
>> +       unsigned pt_total, count, pfn_idx;
>> +       unsigned last_pfn = first_pfn + npages, pfns_to_pt_edge,
>> pfns_to_end;
>> +       unsigned mem_pfn_offset;
>> +
>> +       pt_total = RADEON_PDE_COUNT_FOR_N_PAGES(npages);
>> +       count = RADEON_PTE_COUNT;
>> +
>> +       pfn_idx = first_pfn;
>> +
>> +       for (mem_pfn_offset = 0; mem_pfn_offset < npages;) {
>> +
>> +               pfns_to_end = last_pfn - pfn_idx;
>> +               pfns_to_pt_edge = RADEON_PTE_COUNT -
>> +                   (pfn_idx % RADEON_PTE_COUNT);
>> +
>> +               count = pfns_to_pt_edge < pfns_to_end ?
>> +                   pfns_to_pt_edge : pfns_to_end;
>> +
>> +               pde_num = RADEON_GET_LAST_PDE_FOR_PFN(pfn_idx);
>> +               pte_num = RADEON_GET_PTE_FOR_PFN(pfn_idx);
>> +
>> +               radeon_asic_vm_set_page(rdev, mem,
>> +                                       vm->pd_gpu_addr +
>> +                                       PTE_OFFSET(rdev, pde_num,
>> pte_num),
>> +                                       mem_pfn_offset, count, flags);
>> +               pfn_idx += count;
>> +               mem_pfn_offset += count;
>> +
>> +               pde_count++;
>> +       }
>> +
>> +       start_pde = RADEON_GET_LAST_PDE_FOR_PFN(first_pfn);
>> +
>> +       radeon_asic_vm_set_pdes(rdev, mem, vm,
>> +                               start_pde, pde_count,
>> RADEON_PDE_FLAG_VALID);
>> +
>> +       return 0;
>> +}
>> +
>> +/**
>>    * radeon_vm_bo_update_pte - map a bo into the vm page table
>>    *
>>    * @rdev: radeon_device pointer
>> @@ -882,7 +946,7 @@ int radeon_vm_bo_update_pte(struct radeon_device
>> *rdev,
>>         struct radeon_ring *ring = &rdev->ring[ridx];
>>         struct radeon_semaphore *sem = NULL;
>>         struct radeon_bo_va *bo_va;
>> -       unsigned ngpu_pages, ndw;
>> +       unsigned ngpu_pages, ndw, npdes;
>>         uint64_t pfn;
>>         int r;
>>   @@ -935,10 +999,12 @@ int radeon_vm_bo_update_pte(struct radeon_device
>> *rdev,
>>                 }
>>         }
>>   -     /* estimate number of dw needed */
>> +       npdes = (RADEON_PDE_COUNT_FOR_N_PAGES(pfn + ngpu_pages) -
>> +                RADEON_GET_LAST_PDE_FOR_PFN(pfn));
>> +
>>         ndw = 32;
>> -       ndw += (ngpu_pages >> 12) * 3;
>> -       ndw += ngpu_pages * 2;
>> +       ndw += ngpu_pages * 2 + 3 * npdes;
>> +       ndw += npdes * 2 + 3;
>>         r = radeon_ring_lock(rdev, ring, ndw);
>>         if (r) {
>> @@ -950,7 +1016,7 @@ int radeon_vm_bo_update_pte(struct radeon_device
>> *rdev,
>>                 radeon_fence_note_sync(vm->fence, ridx);
>>         }
>>   -     radeon_asic_vm_set_page(rdev, vm, pfn, mem, ngpu_pages,
>> bo_va->flags);
>> +       radeon_vm_bo_set_pages(rdev, vm, pfn, mem, ngpu_pages,
>> bo_va->flags);
>>         radeon_fence_unref(&vm->fence);
>>         r = radeon_fence_emit(rdev, &vm->fence, ridx);
>> @@ -958,9 +1024,11 @@ int radeon_vm_bo_update_pte(struct radeon_device
>> *rdev,
>>                 radeon_ring_unlock_undo(rdev, ring);
>>                 return r;
>>         }
>> +
>>         radeon_ring_unlock_commit(rdev, ring);
>>         radeon_semaphore_free(rdev, &sem, vm->fence);
>>         radeon_fence_unref(&vm->last_flush);
>> +
>>         return 0;
>>   }
>>   diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
>> index 2a5c337..156c994 100644
>> --- a/drivers/gpu/drm/radeon/si.c
>> +++ b/drivers/gpu/drm/radeon/si.c
>> @@ -2426,7 +2426,7 @@ static int si_pcie_gart_enable(struct radeon_device
>> *rdev)
>>         WREG32(VM_CONTEXT1_PROTECTION_FAULT_DEFAULT_ADDR,
>>                (u32)(rdev->dummy_page.addr >> 12));
>>         WREG32(VM_CONTEXT1_CNTL2, 0);
>> -       WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(0) |
>> +       WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(1) |
>>                                 RANGE_PROTECTION_FAULT_ENABLE_DEFAULT);
>>         si_pcie_gart_tlb_flush(rdev);
>> @@ -2804,7 +2804,7 @@ void si_vm_flush(struct radeon_device *rdev, struct
>> radeon_ib *ib)
>>                 radeon_ring_write(ring,
>> PACKET0(VM_CONTEXT8_PAGE_TABLE_BASE_ADDR
>>                                                 + ((vm->id - 8) << 2),
>> 0));
>>         }
>> -       radeon_ring_write(ring, vm->pt_gpu_addr >> 12);
>> +       radeon_ring_write(ring, vm->pd_gpu_addr >> 12);
>>         /* flush hdp cache */
>>         radeon_ring_write(ring, PACKET0(HDP_MEM_COHERENCY_FLUSH_CNTL, 0));
>
>
> Cheers,
> Christian.
>



-- 
With best regards,
Dmitry
