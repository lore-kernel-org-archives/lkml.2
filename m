Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2IYOoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:44:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49108 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab2IYOom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:44:42 -0400
From: Dmitry Cherkasov <dcherkassov@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
Subject: [PATCH 2/2] drm/radeon: implement dynamic PTs allocation via SA
Date: Tue, 25 Sep 2012 18:44:12 +0400
Message-Id: <1348584252-22778-2-git-send-email-Dmitrii.Cherkasov@amd.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348584252-22778-1-git-send-email-Dmitrii.Cherkasov@amd.com>
References: <1348584252-22778-1-git-send-email-Dmitrii.Cherkasov@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make dynamic allocation of page tables on demand in radeon_vm_update_pte

Signed-off-by: Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
---
 drivers/gpu/drm/radeon/radeon.h      |   12 ++++
 drivers/gpu/drm/radeon/radeon_gart.c |  106 ++++++++++++++++++++++++++++++----
 2 files changed, 107 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index d8a61ed..f1dcdbe 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -659,6 +659,15 @@ struct radeon_ring {
 /* number of entries in page table */
 #define RADEON_VM_PTE_COUNT (1 << RADEON_VM_BLOCK_SIZE)
 
+struct radeon_pt {
+	/* BO containing the page table */
+	/* radeon_sa_bo_gpu_addr(sa_bo); */
+	struct radeon_sa_bo *bo;
+
+	/* GPU address of page table */
+	u64 gpu_addr;
+};
+
 struct radeon_vm {
 	struct list_head		list;
 	struct list_head		va;
@@ -671,6 +680,9 @@ struct radeon_vm {
 	struct radeon_fence		*fence;
 	/* last flush or NULL if we still need to flush */
 	struct radeon_fence		*last_flush;
+
+	/* page tables list */
+	struct radeon_pt *vm_pts;
 };
 
 struct radeon_vm_manager {
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index 31d6bfa..ada8471 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -500,6 +500,19 @@ static void radeon_vm_free_pt(struct radeon_device *rdev,
 				    struct radeon_vm *vm)
 {
 	struct radeon_bo_va *bo_va;
+	int i;
+
+	int driver_table_entries = (rdev->vm_manager.max_pfn >>
+				    RADEON_VM_BLOCK_SIZE);
+
+	if (vm->id != 0 && vm->vm_pts) {
+		for (i = 0;i < driver_table_entries; i++) {
+			if (vm->vm_pts->bo)
+				radeon_sa_bo_free(rdev, &vm->vm_pts->bo, vm->fence);
+		}
+
+		kfree (vm->vm_pts);
+	}
 
 	if (!vm->sa_bo)
 		return;
@@ -563,6 +576,9 @@ int radeon_vm_alloc_pt(struct radeon_device *rdev, struct radeon_vm *vm)
 	int r;
 	u64 *pd_addr;
 	int tables_size;
+	int driver_table_size = (rdev->vm_manager.max_pfn >>
+				 RADEON_VM_BLOCK_SIZE) *
+		sizeof(struct radeon_pt);
 
 	if (vm == NULL) {
 		return -EINVAL;
@@ -570,7 +586,6 @@ int radeon_vm_alloc_pt(struct radeon_device *rdev, struct radeon_vm *vm)
 
 	/* allocate enough to cover the current VM size */
 	tables_size = RADEON_GPU_PAGE_ALIGN(radeon_vm_directory_size(rdev));
-	tables_size += RADEON_GPU_PAGE_ALIGN(vm->last_pfn * 8);
 
 	if (vm->sa_bo != NULL) {
 		/* update lru */
@@ -600,6 +615,16 @@ retry:
 	vm->pd_gpu_addr = radeon_sa_bo_gpu_addr(vm->sa_bo);
 	memset(pd_addr, 0, tables_size);
 
+	vm->vm_pts = kmalloc(driver_table_size, GFP_KERNEL);
+	
+	if (vm->vm_pts == NULL) {
+		DRM_ERROR("Cannot allocate space for driver PDE table: %d kb \n",
+			  driver_table_size / 1024);
+		return -ENOMEM;
+	}
+
+	memset(vm->vm_pts, 0, tables_size);
+
 	list_add_tail(&vm->list, &rdev->vm_manager.lru_vm);
 	return radeon_vm_bo_update_pte(rdev, vm, rdev->ring_tmp_bo.bo,
 				       &rdev->ring_tmp_bo.bo->tbo.mem);
@@ -864,6 +889,8 @@ uint64_t radeon_vm_map_gart(struct radeon_device *rdev, uint64_t addr)
 	return result;
 }
 
+
+
 /**
  * radeon_vm_bo_update_pte - map a bo into the vm page table
  *
@@ -886,10 +913,15 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 	struct radeon_ring *ring = &rdev->ring[ridx];
 	struct radeon_semaphore *sem = NULL;
 	struct radeon_bo_va *bo_va;
-	unsigned nptes, npdes, ndw;
+	struct radeon_pt *pt;
+	unsigned nptes, npdes, ndw, count;
 	uint64_t pe, addr;
 	uint64_t pfn;
+	uint32_t first_pde, pfns_to_pt_edge, pfns_to_end, pde_count;
+	uint64_t *addr_list;
 	int r;
+	uint64_t mem_pfn_offset;
+	uint64_t pfn_idx, last_pfn, pde_num, pte_num;
 
 	/* nothing to do if vm isn't bound */
 	if (vm->sa_bo == NULL)
@@ -947,6 +979,8 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 
 	pfn = (bo_va->soffset / RADEON_GPU_PAGE_SIZE);
 
+	first_pde = pfn / RADEON_VM_PTE_COUNT;
+
 	/* handle cases where a bo spans several pdes  */
 	npdes = (ALIGN(pfn + nptes, RADEON_VM_PTE_COUNT) -
 		 (pfn & ~(RADEON_VM_PTE_COUNT - 1))) >> RADEON_VM_BLOCK_SIZE;
@@ -971,22 +1005,72 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 		radeon_fence_note_sync(vm->fence, ridx);
 	}
 
-	/* update page table entries */
-	pe = vm->pd_gpu_addr;
-	pe += radeon_vm_directory_size(rdev);
-	pe += (bo_va->soffset / RADEON_GPU_PAGE_SIZE) * 8;
+	addr_list = kmalloc(npdes * sizeof(uint64_t), GFP_KERNEL);
 
-	radeon_asic_vm_set_page(rdev, pe, addr, nptes,
-				RADEON_GPU_PAGE_SIZE, NULL, bo_va->flags);
+	if (!addr_list) {
+		DRM_ERROR("cannot alloc memory for addr list\n");
+		return -ENOMEM;
+	}
+
+	pfn_idx = pfn;
+	last_pfn = pfn_idx + nptes;
+
+	/*
+	  On each iteration map count ptes.
+	  count is the least of these two numbers:
+	  # of ptes to PDE span boundary (RADEON_VM_PTE_COUNT multiple) or
+	  # of ptes left to map
+	 */
+
+	for (mem_pfn_offset = 0, pde_count = 0; mem_pfn_offset < nptes;) {
+		pfns_to_end = last_pfn - pfn_idx;
+		pfns_to_pt_edge = RADEON_VM_PTE_COUNT -
+			(pfn_idx % RADEON_VM_PTE_COUNT);
+
+		count = pfns_to_pt_edge < pfns_to_end ?
+			pfns_to_pt_edge : pfns_to_end;
+
+		pde_num = pfn_idx / RADEON_VM_PTE_COUNT;
+		pte_num = pfn_idx % RADEON_VM_PTE_COUNT;
+
+		pt = &vm->vm_pts[pde_num];
+		if (pt->bo == NULL) {
+			r = radeon_sa_bo_new(rdev, &rdev->vm_manager.sa_manager,
+					     &pt->bo,
+					     RADEON_VM_PTE_COUNT * 8,
+					     RADEON_GPU_PAGE_SIZE, false);
+			pt->gpu_addr = radeon_sa_bo_gpu_addr(pt->bo);
+
+			if (r == -ENOMEM) {
+				DRM_ERROR("cannot allocate driver page table"
+					  "for vmid = %d", vm->id);
+				return r;
+			}
+		}
+		addr_list[pde_count] = pt->gpu_addr;
+
+		pe = pt->gpu_addr;
+		pe += pte_num * 8;
+
+		radeon_asic_vm_set_page(rdev, pe,
+					addr + mem_pfn_offset * RADEON_GPU_PAGE_SIZE,
+					count,	RADEON_GPU_PAGE_SIZE, NULL, bo_va->flags);
+
+		pfn_idx += count;
+		mem_pfn_offset += count;
+		pde_count++;
+	}
 
 	/* update page directory entries */
-	addr = pe;
+	addr = (uint64_t) &vm->vm_pts[first_pde];
 
 	pe = vm->pd_gpu_addr;
 	pe += ((bo_va->soffset / RADEON_GPU_PAGE_SIZE) >> RADEON_VM_BLOCK_SIZE) * 8;
 
-	radeon_asic_vm_set_page(rdev, pe, addr, npdes,
-				RADEON_VM_PTE_COUNT * 8, NULL, RADEON_VM_PAGE_VALID);
+	radeon_asic_vm_set_page(rdev, pe, 0, npdes,
+				0, addr_list, RADEON_VM_PAGE_VALID);
+
+	kfree(addr_list);
 
 	radeon_fence_unref(&vm->fence);
 	r = radeon_fence_emit(rdev, &vm->fence, ridx);
-- 
1.7.10.4

