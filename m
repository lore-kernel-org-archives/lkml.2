Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab2IOO6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 10:58:36 -0400
Received: from outgoing.email.vodafone.de ([139.7.28.128]:58599 "EHLO
	outgoing.email.vodafone.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839Ab2IOO6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 10:58:34 -0400
X-Authentication-Info: Sender authenticated as deathsimple@vodafone.de (using CRAM-MD5)
Message-ID: <5054978F.1090205@vodafone.de>
Date: Sat, 15 Sep 2012 16:58:23 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Dmitry Cherkasov <dcherkassov@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
Subject: Re: [PATCH 2/2] Add 2-level GPUVM pagetables support to radeon driver.
 v2
References: <1347644982-17386-1-git-send-email-Dmitrii.Cherkasov@amd.com> <1347644982-17386-2-git-send-email-Dmitrii.Cherkasov@amd.com>
In-Reply-To: <1347644982-17386-2-git-send-email-Dmitrii.Cherkasov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.09.2012 19:49, Dmitry Cherkasov wrote:
> PDE/PTE update code uses CP ring for memory writes.
> All page table entries are preallocated for now in alloc_pt().
>
> It is made as whole because it's hard to divide it to several patches
> that compile and doesn't break anything being applied separately.
>
> Tested on cayman card.
We need some more tests on SI before that can be pushed upstream. Not so 
much of a problem, cause I can do it and AFAIK Michel also had an older 
version of the patch tested on SI.

>
> v2 changes:
> * rebased on top of "refactor set_page chipset interface v2"
> * code cleanups
>
> Signed-off-by: Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
> ---
>   drivers/gpu/drm/radeon/ni.c          |    4 +-
>   drivers/gpu/drm/radeon/radeon.h      |    4 +-
>   drivers/gpu/drm/radeon/radeon_gart.c |  145 +++++++++++++++++++++++++++++++---
>   drivers/gpu/drm/radeon/si.c          |    4 +-
>   4 files changed, 140 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
> index 0355c8d..ffa9f7e 100644
> --- a/drivers/gpu/drm/radeon/ni.c
> +++ b/drivers/gpu/drm/radeon/ni.c
> @@ -782,7 +782,7 @@ static int cayman_pcie_gart_enable(struct radeon_device *rdev)
>   	       (u32)(rdev->dummy_page.addr >> 12));
>   	WREG32(VM_CONTEXT1_CNTL2, 0);
>   	WREG32(VM_CONTEXT1_CNTL, 0);
> -	WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(0) |
> +	WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(1) |
>   				RANGE_PROTECTION_FAULT_ENABLE_DEFAULT);
>   
>   	cayman_pcie_gart_tlb_flush(rdev);
> @@ -1586,7 +1586,7 @@ void cayman_vm_flush(struct radeon_device *rdev, struct radeon_ib *ib)
>   	radeon_ring_write(ring, vm->last_pfn);
>   
>   	radeon_ring_write(ring, PACKET0(VM_CONTEXT0_PAGE_TABLE_BASE_ADDR + (vm->id << 2), 0));
> -	radeon_ring_write(ring, vm->pt_gpu_addr >> 12);
> +	radeon_ring_write(ring, vm->pd_gpu_addr >> 12);
>   
>   	/* flush hdp cache */
>   	radeon_ring_write(ring, PACKET0(HDP_MEM_COHERENCY_FLUSH_CNTL, 0));
> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> index f02ea8e..6231823 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -655,8 +655,8 @@ struct radeon_vm {
>   	struct list_head		va;
>   	unsigned			id;
>   	unsigned			last_pfn;
> -	u64				pt_gpu_addr;
> -	u64				*pt;
> +	u64				pd_gpu_addr;
> +	u64 __iomem                     *pd_addr;
As I already said in the last version of this patch, the CPU shouldn't 
come into the need to access that memory directly, with the exception of 
initial clearing it. So please remove this pointer.

>   	struct radeon_sa_bo		*sa_bo;
>   	struct mutex			mutex;
>   	/* last fence for cs using this vm */
> diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
> index badc835..9c68482 100644
> --- a/drivers/gpu/drm/radeon/radeon_gart.c
> +++ b/drivers/gpu/drm/radeon/radeon_gart.c
> @@ -50,6 +50,59 @@
>    * This file handles the common internal GART management.
>    */
>   
> +/* GPUVM defines */
> +
> +/* We consider the case where BLOCK_SIZE is 0 */
> +/* So PDE is 19 bits long, PTE is 9 and OFFSET is 12 */
> +#define RADEON_BLOCK_SIZE   0
Sorry missed that in my last comment, that define should indeed be 
public, cause the chipset specific code needs to know it when 
initializing the hardware.

Also we should name it in a way that makes it obvious that it belongs to 
the VM code, like RADEON_VM_BLOCK_SIZE, or something like this.

> +
> +/* By default there are 512 entries in Page Table */
> +#define RADEON_DEFAULT_PTE_COUNT (1 << 9)
> +
> +/* number of PTEs in Page Table */
> +#define RADEON_PTE_COUNT (RADEON_DEFAULT_PTE_COUNT << RADEON_BLOCK_SIZE)
Please merge those two defines, RADEON_DEFAULT_PTE_COUNT isn't used 
after the second define, and the fact that nine is actually the minimum 
block size is something chipset specific (there might be larger minimum 
page table sizes in the future). Saying that it might actually also be 
useful to set RADEON_(VM)_BLOCK_SIZE to 9 instead of 0 and let the 
chipset specific code calculate the actually value that gets written 
into the register.

> +
> +/* Get last PDE number containing nth PTE */
> +#define RADEON_GET_LAST_PDE_FOR_PFN(_n)	((_n) / RADEON_PTE_COUNT)
> +
> +/* Get PTE number to containing nth pfn */
> +#define RADEON_GET_PTE_FOR_PFN(_n)	((_n) % RADEON_PTE_COUNT)
> +
> +/* Number of PDE tables to cover n PTEs */
> +#define RADEON_PDE_COUNT_FOR_N_PAGES(_n) \
> +	(((_n) + RADEON_PTE_COUNT - 1) / RADEON_PTE_COUNT)
> +
> +/* Number of PDE tables to cover max_pfn (maximum number of PTEs) */
> +#define RADEON_TOTAL_PDE_COUNT(rdev) \
> +	RADEON_PDE_COUNT_FOR_N_PAGES(rdev->vm_manager.max_pfn)
> +
> +#define RADEON_PTE_SIZE 8
> +#define RADEON_PDE_SIZE 8
> +
> +/* offset for npde-th PDE starting from beginning of PDE table */
> +#define RADEON_PDE_OFFSET(_rdev, _npde) ((_npde) * RADEON_PDE_SIZE)
> +
> +#define RADEON_PT_OFFSET(_rdev) \
> +	(RADEON_GPU_PAGE_ALIGN(RADEON_TOTAL_PDE_COUNT(rdev) * RADEON_PDE_SIZE))
> +
> +/* offset for npte-th PTE of npde-th PDE starting from beginning of PDE table */
> +#define RADEON_PTE_OFFSET(_rdev, _npde, _npte) \
> +	(RADEON_PT_OFFSET(_rdev) +	\
> +	  (_npde) * RADEON_PTE_COUNT   * RADEON_PTE_SIZE + \
> +	  (_npte) * RADEON_PTE_SIZE)
> +
> +
> +#define RADEON_PT_DISTANCE \
> +	(RADEON_PTE_COUNT * RADEON_PTE_SIZE)
> +
> +/* cpu address of gpuvm page table */
> +#define RADEON_BASE_CPU_ADDR(_vm)			\
> +	radeon_sa_bo_cpu_addr(vm->sa_bo)
> +
> +/* gpu address of gpuvm page table */
> +#define RADEON_BASE_GPU_ADDR(_vm)			\
> +	radeon_sa_bo_gpu_addr(vm->sa_bo)
> +
Why are those macros defines? As far as I can see static functions 
should do fine here.

>   /*
>    * Common GART table functions.
>    */
> @@ -490,7 +543,6 @@ static void radeon_vm_free_pt(struct radeon_device *rdev,
>   
>   	list_del_init(&vm->list);
>   	radeon_sa_bo_free(rdev, &vm->sa_bo, vm->fence);
> -	vm->pt = NULL;
>   
>   	list_for_each_entry(bo_va, &vm->va, vm_list) {
>   		bo_va->valid = false;
> @@ -547,6 +599,11 @@ int radeon_vm_alloc_pt(struct radeon_device *rdev, struct radeon_vm *vm)
>   	struct radeon_vm *vm_evict;
>   	int r;
>   
> +	int gpuvm_tables_sz =
> +	    RADEON_GPU_PAGE_ALIGN(
> +		    RADEON_TOTAL_PDE_COUNT(rdev) * RADEON_PDE_SIZE) +
> +	    vm->last_pfn  * RADEON_PTE_SIZE;
> +
Accessing "vm" before the check for vm == NULL isn't such a good idea, 
so move the calculation of table size a bit lower.

>   	if (vm == NULL) {
>   		return -EINVAL;
>   	}
> @@ -560,7 +617,7 @@ int radeon_vm_alloc_pt(struct radeon_device *rdev, struct radeon_vm *vm)
>   
>   retry:
>   	r = radeon_sa_bo_new(rdev, &rdev->vm_manager.sa_manager, &vm->sa_bo,
> -			     RADEON_GPU_PAGE_ALIGN(vm->last_pfn * 8),
> +			     gpuvm_tables_sz,
>   			     RADEON_GPU_PAGE_SIZE, false);
>   	if (r == -ENOMEM) {
>   		if (list_empty(&rdev->vm_manager.lru_vm)) {
> @@ -576,9 +633,10 @@ retry:
>   		return r;
>   	}
>   
> -	vm->pt = radeon_sa_bo_cpu_addr(vm->sa_bo);
> -	vm->pt_gpu_addr = radeon_sa_bo_gpu_addr(vm->sa_bo);
> -	memset(vm->pt, 0, RADEON_GPU_PAGE_ALIGN(vm->last_pfn * 8));
> +	vm->pd_addr = radeon_sa_bo_cpu_addr(vm->sa_bo);
> +	vm->pd_gpu_addr = radeon_sa_bo_gpu_addr(vm->sa_bo);
> +	memset(vm->pd_addr, 0, gpuvm_tables_sz);
> +
Like I already said above, this is the only place "pd_addr" is used, 
please make it a local variable and remove the structure member.

>   
>   	list_add_tail(&vm->list, &rdev->vm_manager.lru_vm);
>   	return radeon_vm_bo_update_pte(rdev, vm, rdev->ring_tmp_bo.bo,
> @@ -845,6 +903,68 @@ uint64_t radeon_vm_map_gart(struct radeon_device *rdev, uint64_t addr)
>   }
>   
>   /**
> + * radeon_vm_bo_set_pages - update PDE and PTE for pfn
> + *
> + * @rdev: radeon_device pointer
> + * @first_pfn: first pfn in bo address space to start mapping from
> + * @mem: ttm mem
> + * @vm: requested vm
> + * @bo: radeon buffer object
> + *
> + * Update page directory and table entries for pfn (cayman+).
> + */
> +
> +static int radeon_vm_bo_set_pages(struct radeon_device *rdev,
> +				  struct radeon_vm *vm,
> +				  unsigned first_pfn, uint64_t addr,
> +				  unsigned npages, uint32_t flags)
> +{
> +	u64 pde_num, pte_num, start_pde, pde_count = 0;
> +
> +	unsigned count, pfn_idx;
> +	unsigned last_pfn = first_pfn + npages, pfns_to_pt_edge, pfns_to_end;
> +	uint64_t mem_pfn_offset;
> +
> +	pfn_idx = first_pfn;
> +
> +	for (mem_pfn_offset = 0; mem_pfn_offset < npages;) {
> +
> +		pfns_to_end = last_pfn - pfn_idx;
> +		pfns_to_pt_edge = RADEON_PTE_COUNT -
> +		    (pfn_idx % RADEON_PTE_COUNT);
> +
> +		count = pfns_to_pt_edge < pfns_to_end ?
> +		    pfns_to_pt_edge : pfns_to_end;
> +
> +		pde_num = RADEON_GET_LAST_PDE_FOR_PFN(pfn_idx);
> +		pte_num = RADEON_GET_PTE_FOR_PFN(pfn_idx);
> +
> +		radeon_asic_vm_set_page(
> +			rdev, vm->pd_gpu_addr +
> +			RADEON_PTE_OFFSET(rdev, pde_num, pte_num),
> +			mem_pfn_offset * RADEON_GPU_PAGE_SIZE +
> +			addr,
> +			count, flags,
> +			0);
> +
> +		pfn_idx += count;
> +		mem_pfn_offset += count;
> +
> +		pde_count++;
> +	}
> +
> +	start_pde = RADEON_GET_LAST_PDE_FOR_PFN(first_pfn);
> +
> +	radeon_asic_vm_set_page(rdev,
> +		vm->pd_gpu_addr + RADEON_PDE_OFFSET(rdev, start_pde),
> +		vm->pd_gpu_addr + RADEON_PTE_OFFSET(rdev, start_pde, 0),
> +		pde_count, RADEON_VM_PDE_VALID, RADEON_PT_DISTANCE
> +		);
> +
> +	return 0;
> +}
Looks complicated, but I' sure that it is actually quite simple. Need 
spend more time with it on Monday, then I can say if that is ok or not.

> +
> +/**
>    * radeon_vm_bo_update_pte - map a bo into the vm page table
>    *
>    * @rdev: radeon_device pointer
> @@ -866,7 +986,7 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
>   	struct radeon_ring *ring = &rdev->ring[ridx];
>   	struct radeon_semaphore *sem = NULL;
>   	struct radeon_bo_va *bo_va;
> -	unsigned ngpu_pages, ndw;
> +	unsigned ngpu_pages, ndw, npdes;
>   	uint64_t pfn, addr;
>   	int r;
>   
> @@ -923,10 +1043,12 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
>   		}
>   	}
>   
> -	/* estimate number of dw needed */
> +	npdes = (RADEON_PDE_COUNT_FOR_N_PAGES(pfn + ngpu_pages) -
> +		 RADEON_GET_LAST_PDE_FOR_PFN(pfn));
> +
>   	ndw = 32;
> -	ndw += (ngpu_pages >> 12) * 3;
> -	ndw += ngpu_pages * 2;
> +	ndw += ngpu_pages * 2 + 3 * npdes;
> +	ndw += npdes * 2 + 3;
>   
>   	r = radeon_ring_lock(rdev, ring, ndw);
>   	if (r) {
> @@ -938,8 +1060,7 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
>   		radeon_fence_note_sync(vm->fence, ridx);
>   	}
>   
> -	radeon_asic_vm_set_page(rdev, vm->pt_gpu_addr + pfn * 8, addr,
> -				ngpu_pages, bo_va->flags, 0);
> +	radeon_vm_bo_set_pages(rdev, vm, pfn, addr, ngpu_pages, bo_va->flags);
>   
>   	radeon_fence_unref(&vm->fence);
>   	r = radeon_fence_emit(rdev, &vm->fence, ridx);
> @@ -947,9 +1068,11 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
>   		radeon_ring_unlock_undo(rdev, ring);
>   		return r;
>   	}
> +
>   	radeon_ring_unlock_commit(rdev, ring);
>   	radeon_semaphore_free(rdev, &sem, vm->fence);
>   	radeon_fence_unref(&vm->last_flush);
> +
>   	return 0;
>   }
>   
> diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
> index 2a5c337..156c994 100644
> --- a/drivers/gpu/drm/radeon/si.c
> +++ b/drivers/gpu/drm/radeon/si.c
> @@ -2426,7 +2426,7 @@ static int si_pcie_gart_enable(struct radeon_device *rdev)
>   	WREG32(VM_CONTEXT1_PROTECTION_FAULT_DEFAULT_ADDR,
>   	       (u32)(rdev->dummy_page.addr >> 12));
>   	WREG32(VM_CONTEXT1_CNTL2, 0);
> -	WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(0) |
> +	WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(1) |
>   				RANGE_PROTECTION_FAULT_ENABLE_DEFAULT);
>   
>   	si_pcie_gart_tlb_flush(rdev);
> @@ -2804,7 +2804,7 @@ void si_vm_flush(struct radeon_device *rdev, struct radeon_ib *ib)
>   		radeon_ring_write(ring, PACKET0(VM_CONTEXT8_PAGE_TABLE_BASE_ADDR
>   						+ ((vm->id - 8) << 2), 0));
>   	}
> -	radeon_ring_write(ring, vm->pt_gpu_addr >> 12);
> +	radeon_ring_write(ring, vm->pd_gpu_addr >> 12);
>   
>   	/* flush hdp cache */
>   	radeon_ring_write(ring, PACKET0(HDP_MEM_COHERENCY_FLUSH_CNTL, 0));

Cheers,
Christian.
