Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2JEK2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:28:06 -0400
Received: from outgoing.email.vodafone.de ([139.7.28.128]:34572 "EHLO
	outgoing.email.vodafone.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab2JEK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:28:04 -0400
X-Authentication-Info: Sender authenticated as deathsimple@vodafone.de (using CRAM-MD5)
Message-ID: <506EB627.3030501@vodafone.de>
Date: Fri, 05 Oct 2012 12:27:51 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dmitry Cherkasov <dcherkassov@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Michel Daenzer <michel.daenzer@amd.com>, jcmvbkbc@gmail.com,
        Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
Subject: Re: [RFC] drm/radeon: make dynamic allocation of page tables on demand
 in radeon_vm_update_pte v2
References: <1349361147-12712-1-git-send-email-Dmitrii.Cherkasov@amd.com>
In-Reply-To: <1349361147-12712-1-git-send-email-Dmitrii.Cherkasov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to resolve the remaining bugs today. Expect an v3 of the patch 
this evening or Monday morning.

Cheers,
Christian.

On 04.10.2012 16:32, Dmitry Cherkasov wrote:
> v2: setup and alloc number of contiguous PTs if possible
>
> Warning: Heaven benchmark /sometimes/ fails with this patch after
> 10 or 15 minutes of working, so any insight is greatly appreciated.
>
> The code is a bit bloated because it's a question how a decent optimization
> should be made: via macros? using structs? etc.
>
> The rationale for struct radeon_pt is that BO may contain several contiguous
> PTs and we should have that u64 gpu_addr to point to actual begining of PT.
>
> I've only tested it on cayman card, should work on SI but who knows? ;)
>
> Please say your ideas.
> ---
>   drivers/gpu/drm/radeon/radeon.h      |   12 ++
>   drivers/gpu/drm/radeon/radeon_gart.c |  263 ++++++++++++++++++++++++++++++++--
>   2 files changed, 260 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> index b04c064..38d4eda 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -659,6 +659,15 @@ struct radeon_ring {
>   /* number of entries in page table */
>   #define RADEON_VM_PTE_COUNT (1 << RADEON_VM_BLOCK_SIZE)
>   
> +struct radeon_pt {
> +	/* BO containing the page table */
> +	/* radeon_sa_bo_gpu_addr(sa_bo); */
> +	struct radeon_sa_bo *bo;
> +
> +	/* GPU address of page table */
> +	u64 gpu_addr;
> +};
> +
>   struct radeon_vm {
>   	struct list_head		list;
>   	struct list_head		va;
> @@ -671,6 +680,9 @@ struct radeon_vm {
>   	struct radeon_fence		*fence;
>   	/* last flush or NULL if we still need to flush */
>   	struct radeon_fence		*last_flush;
> +
> +	/* page tables list */
> +	struct radeon_pt *vm_pts;
>   };
>   
>   struct radeon_vm_manager {
> diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
> index 753b7ca..cea918d 100644
> --- a/drivers/gpu/drm/radeon/radeon_gart.c
> +++ b/drivers/gpu/drm/radeon/radeon_gart.c
> @@ -500,6 +500,10 @@ static void radeon_vm_free_pt(struct radeon_device *rdev,
>   				    struct radeon_vm *vm)
>   {
>   	struct radeon_bo_va *bo_va;
> +	int i;
> +
> +	int driver_table_entries = (rdev->vm_manager.max_pfn >>
> +				    RADEON_VM_BLOCK_SIZE);
>   
>   	if (!vm->sa_bo)
>   		return;
> @@ -510,6 +514,14 @@ static void radeon_vm_free_pt(struct radeon_device *rdev,
>   	list_for_each_entry(bo_va, &vm->va, vm_list) {
>   		bo_va->valid = false;
>   	}
> +
> +	if (vm->vm_pts == NULL)
> +		return;
> +
> +	for (i = 0;i < driver_table_entries; i++)
> +		radeon_sa_bo_free(rdev, &vm->vm_pts[i].bo, vm->fence);
> +
> +	kfree (vm->vm_pts);
>   }
>   
>   /**
> @@ -563,6 +575,9 @@ int radeon_vm_alloc_pt(struct radeon_device *rdev, struct radeon_vm *vm)
>   	int r;
>   	u64 *pd_addr;
>   	int tables_size;
> +	int driver_table_size = (rdev->vm_manager.max_pfn >>
> +				 RADEON_VM_BLOCK_SIZE) *
> +		sizeof(struct radeon_pt);
>   
>   	if (vm == NULL) {
>   		return -EINVAL;
> @@ -570,7 +585,6 @@ int radeon_vm_alloc_pt(struct radeon_device *rdev, struct radeon_vm *vm)
>   
>   	/* allocate enough to cover the current VM size */
>   	tables_size = RADEON_GPU_PAGE_ALIGN(radeon_vm_directory_size(rdev));
> -	tables_size += RADEON_GPU_PAGE_ALIGN(vm->last_pfn * 8);
>   
>   	if (vm->sa_bo != NULL) {
>   		/* update lru */
> @@ -600,6 +614,16 @@ retry:
>   	vm->pd_gpu_addr = radeon_sa_bo_gpu_addr(vm->sa_bo);
>   	memset(pd_addr, 0, tables_size);
>   
> +	vm->vm_pts = kmalloc(driver_table_size, GFP_KERNEL);
> +
> +	if (vm->vm_pts == NULL) {
> +		DRM_ERROR("Cannot allocate space for driver page table\n");
> +		radeon_sa_bo_free(rdev, &vm->sa_bo, vm->fence);
> +		return -ENOMEM;
> +	}
> +
> +	memset(vm->vm_pts, 0, driver_table_size);
> +
>   	list_add_tail(&vm->list, &rdev->vm_manager.lru_vm);
>   	return radeon_vm_bo_update_pte(rdev, vm, rdev->ring_tmp_bo.bo,
>   				       &rdev->ring_tmp_bo.bo->tbo.mem);
> @@ -864,6 +888,69 @@ uint64_t radeon_vm_map_gart(struct radeon_device *rdev, uint64_t addr)
>   	return result;
>   }
>   
> +/* setup @count pfns starting at @addr to PTEs starting at @pt_start and
> + * @pde_count pdes starting at @pd_start */
> +
> +static void radeon_vm_map_pfns (struct radeon_device *rdev,
> +				uint64_t pt_addr, uint64_t pt_offset,
> +				uint64_t addr, uint64_t pte_count,
> +				uint64_t pd_start, uint32_t pde_count, uint32_t flags)
> +{
> +	if (pde_count == 0 && pte_count == 0)
> +		return;
> +
> +	radeon_asic_vm_set_page(rdev, pt_addr + pt_offset, addr,
> +				pte_count,
> +				RADEON_GPU_PAGE_SIZE, flags);
> +
> +	radeon_asic_vm_set_page(rdev, pd_start, pt_addr,
> +				pde_count,
> +				RADEON_VM_PTE_COUNT * 8, RADEON_VM_PAGE_VALID);
> +}
> +
> +int radeon_suballoc_pts(struct radeon_device *rdev, struct radeon_vm *vm, uint64_t start_pt, uint32_t count)
> +{
> +	uint32_t i;
> +	int r;
> +	struct radeon_vm *vm_evict;
> +	struct radeon_pt *pt = &vm->vm_pts[start_pt], *pti;
> +retry:
> +	r = radeon_sa_bo_new(rdev, &rdev->vm_manager.sa_manager,
> +			     &pt->bo,
> +			     RADEON_VM_PTE_COUNT * 8 * count,
> +			     RADEON_GPU_PAGE_SIZE, false);
> +
> +	if (r == -ENOMEM) {
> +		if (list_empty(&rdev->vm_manager.lru_vm)) {
> +			DRM_ERROR("cannot allocate driver page table"
> +				  "for vmid = %d", vm->id);
> +			return r;
> +		}
> +
> +		vm_evict = list_first_entry(&rdev->vm_manager.lru_vm,
> +					    struct radeon_vm, list);
> +
> +		mutex_lock(&vm_evict->mutex);
> +		radeon_vm_free_pt(rdev, vm_evict);
> +		mutex_unlock(&vm_evict->mutex);
> +
> +		DRM_INFO("run out of SA memory for PT. Trying to free LRU vm id = %d\n", vm_evict->id);
> +
> +		goto retry;
> +	}
> +
> +	pt->gpu_addr = radeon_sa_bo_gpu_addr(pt->bo);
> +
> +	for (i = 1; i < count; i++) {
> +		pti = &vm->vm_pts[start_pt + i];
> +		pti->bo = NULL;
> +		pti->gpu_addr = pt->gpu_addr + i * RADEON_VM_PTE_COUNT * 8;
> +	}
> +
> +	return 0;
> +}
> +
> +
>   /**
>    * radeon_vm_bo_update_pte - map a bo into the vm page table
>    *
> @@ -886,10 +973,18 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
>   	struct radeon_ring *ring = &rdev->ring[ridx];
>   	struct radeon_semaphore *sem = NULL;
>   	struct radeon_bo_va *bo_va;
> -	unsigned nptes, npdes, ndw;
> -	uint64_t pe, addr;
> +	struct radeon_pt *pt;
> +	unsigned nptes, npdes, ndw, count;
> +	uint64_t  addr;
>   	uint64_t pfn;
> +	uint32_t pfns_to_pt_edge, pfns_to_end;
>   	int r;
> +	uint64_t mem_pfn_offset;
> +	uint64_t pfn_idx, last_pfn, pde_num, pte_num;
> +	uint64_t pfn_map_start, pde_map_start, pte_map_start, pde_map_count, pte_map_count;
> +	uint64_t prev_gpu_addr;
> +	char need_alloc, need_map;
> +
>   
>   	/* nothing to do if vm isn't bound */
>   	if (vm->sa_bo == NULL)
> @@ -971,22 +1066,159 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
>   		radeon_fence_note_sync(vm->fence, ridx);
>   	}
>   
> -	/* update page table entries */
> -	pe = vm->pd_gpu_addr;
> -	pe += radeon_vm_directory_size(rdev);
> -	pe += (bo_va->soffset / RADEON_GPU_PAGE_SIZE) * 8;
> +	pfn_idx = pfn;
> +	last_pfn = pfn_idx + nptes;
> +
> +	pfn_map_start = 0;
> +	pde_map_start = pfn_idx / RADEON_VM_PTE_COUNT;
> +	pte_map_start = pfn_idx % RADEON_VM_PTE_COUNT;
> +	pde_map_count = 0;
> +	pte_map_count = 0;
> +	pte_num = pfn_idx % RADEON_VM_PTE_COUNT;
> +	pde_num = pfn_idx / RADEON_VM_PTE_COUNT;
> +	pt = &vm->vm_pts[pde_num];
> +	prev_gpu_addr = 0;
> +
> +	need_alloc = 0;
> +	need_map = 0;
> +
> +	for (mem_pfn_offset = 0; mem_pfn_offset < nptes;) {
> +		pfns_to_end = last_pfn - pfn_idx;
> +		pfns_to_pt_edge = RADEON_VM_PTE_COUNT -
> +			(pfn_idx % RADEON_VM_PTE_COUNT);
> +
> +		count = pfns_to_pt_edge < pfns_to_end ?
> +			pfns_to_pt_edge : pfns_to_end;
> +
> +		pde_num = pfn_idx / RADEON_VM_PTE_COUNT;
> +		pte_num = pfn_idx % RADEON_VM_PTE_COUNT;
> +
> +		pt = &vm->vm_pts[pde_num];
> +
> +		if (pt->gpu_addr == 0 && prev_gpu_addr == -1) {
> +			/* case 1 */
> +			/* pt for current pfn_idx is unmapped */
> +			/* previous ptes are unmapped */
> +			need_alloc = 1;
> +			need_map = 1;
> +		}
> +		else if (pt->gpu_addr != 0 && prev_gpu_addr != -1) {
> +			/* case 4 */
> +			/* pt for current pfn_idx is mapped */
> +			/* previous ptes are mapped */
> +
> +			if ( pt->gpu_addr != prev_gpu_addr + RADEON_VM_PTE_COUNT * 8) {
> +				/* current pt is not contiguous with previous
> +				   one */
> +				/* flush prior pts */
> +
> +				radeon_vm_map_pfns(
> +					rdev, vm->vm_pts[pde_map_start].gpu_addr,
> +					pte_map_start * 8,
> +					addr + pfn_map_start * RADEON_GPU_PAGE_SIZE,
> +					pte_map_count,
> +					vm->pd_gpu_addr + pde_map_start * 8,
> +					pde_map_count,
> +					bo_va->flags);
> +
> +				pfn_map_start = mem_pfn_offset;
> +				pde_map_start = pfn_idx / RADEON_VM_PTE_COUNT;
> +				pte_map_start = pfn_idx % RADEON_VM_PTE_COUNT;
> +
> +				pde_map_count = 0;
> +				pte_map_count = 0;
> +			}
> +
> +			prev_gpu_addr = pt->gpu_addr;
> +
> +			need_alloc = 0;
> +			need_map = 1;
> +		}
> +		else	if (pt->gpu_addr == 0 && prev_gpu_addr != -1) {
> +			/* case 2 */
> +			/* pt for current pfn_idx is unmapped */
> +			/* previous ptes are mapped */
>   
> -	radeon_asic_vm_set_page(rdev, pe, addr, nptes,
> -				RADEON_GPU_PAGE_SIZE, bo_va->flags);
> +			/* setup prior pdes & ptes here */
>   
> -	/* update page directory entries */
> -	addr = pe;
> +			radeon_vm_map_pfns(
> +				rdev, vm->vm_pts[pde_map_start].gpu_addr,
> +				pte_map_start * 8,
> +				addr + pfn_map_start * RADEON_GPU_PAGE_SIZE,
> +				pte_map_count,
> +				vm->pd_gpu_addr + pde_map_start * 8,
> +				pde_map_count,
> +				bo_va->flags);
>   
> -	pe = vm->pd_gpu_addr;
> -	pe += ((bo_va->soffset / RADEON_GPU_PAGE_SIZE) >> RADEON_VM_BLOCK_SIZE) * 8;
> +			pfn_map_start = mem_pfn_offset;
> +			pde_map_start = pfn_idx / RADEON_VM_PTE_COUNT;
> +			pte_map_start = pfn_idx % RADEON_VM_PTE_COUNT;
>   
> -	radeon_asic_vm_set_page(rdev, pe, addr, npdes,
> -				RADEON_VM_PTE_COUNT * 8, RADEON_VM_PAGE_VALID);
> +			pde_map_count = 0;
> +			pte_map_count = 0;
> +
> +			prev_gpu_addr = -1;
> +
> +			need_alloc = 1;
> +			need_map = 1;
> +		}
> +		else if (pt->gpu_addr != 0 && prev_gpu_addr == -1) {
> +			/* case 3 */
> +			/* pt for current pfn_idx is mapped */
> +			/* previous ptes are unmapped */
> +
> +			/* map prior pfns if there are any */
> +			if (pfn_map_start < mem_pfn_offset) {
> +				radeon_suballoc_pts(rdev, vm,
> +						    pde_map_start, pde_map_count);
> +				radeon_vm_map_pfns(
> +					rdev, vm->vm_pts[pde_map_start].gpu_addr,
> +					pte_map_start * 8,
> +					addr + pfn_map_start * RADEON_GPU_PAGE_SIZE,
> +					pte_map_count,
> +					vm->pd_gpu_addr + pde_map_start * 8,
> +					pde_map_count,
> +					bo_va->flags);
> +			}
> +
> +			pfn_map_start = mem_pfn_offset;
> +			pde_map_start = pfn_idx / RADEON_VM_PTE_COUNT;
> +			pte_map_start = pfn_idx % RADEON_VM_PTE_COUNT;
> +
> +			pde_map_count = 0;
> +			pte_map_count = 0;
> +			
> +			prev_gpu_addr = pt->gpu_addr;
> +
> +			need_alloc = 0;
> +			need_map = 1;
> +
> +		}
> +
> +		pde_map_count++;
> +		pte_map_count += count;
> +
> +		pfn_idx += count;
> +		mem_pfn_offset += count;
> +	}
> +
> +	if (need_alloc) {
> +		radeon_suballoc_pts(rdev, vm, pde_map_start, pde_map_count);
> +	}
> +
> +	if (need_map) {
> +		if (vm->vm_pts[pde_map_start].gpu_addr == 0)
> +			DRM_ERROR("gpu_addr == 0. smth is wrong\n");
> +
> +		radeon_vm_map_pfns(
> +			rdev, vm->vm_pts[pde_map_start].gpu_addr,
> +			pte_map_start * 8,
> +			addr + pfn_map_start * RADEON_GPU_PAGE_SIZE,
> +			pte_map_count,
> +			vm->pd_gpu_addr + pde_map_start * 8,
> +			pde_map_count,
> +			bo_va->flags);
> +	}
>   
>   	radeon_fence_unref(&vm->fence);
>   	r = radeon_fence_emit(rdev, &vm->fence, ridx);
> @@ -997,6 +1229,7 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
>   	radeon_ring_unlock_commit(rdev, ring);
>   	radeon_semaphore_free(rdev, &sem, vm->fence);
>   	radeon_fence_unref(&vm->last_flush);
> +
>   	return 0;
>   }
>   

