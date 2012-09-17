Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2IQNzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:55:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51155 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2IQNzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:55:01 -0400
From: Dmitry Cherkasov <dcherkassov@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
Subject: [PATCH 2/2] Add 2-level GPUVM pagetables support to radeon v3
Date: Mon, 17 Sep 2012 17:53:12 +0400
Message-Id: <1347889993-24702-2-git-send-email-Dmitrii.Cherkasov@amd.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347889993-24702-1-git-send-email-Dmitrii.Cherkasov@amd.com>
References: <1347889993-24702-1-git-send-email-Dmitrii.Cherkasov@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PDE/PTE update code uses CP ring for memory writes.
All page table entries are preallocated for now in alloc_pt().

It is made as whole because it's hard to divide it to several patches
that compile and doesn't break anything being applied separately.

Tested on cayman card.

v3 changes:
* rebased on top of "refactor set_page chipset interface v3"
* switched offsets calc macros to inline funcs where possible
* remove pd_addr from radeon_vm
* switched RADEON_BLOCK_SIZE define to 9 (and PTE_COUNT to 1 << BLOCK_SIZE)

Signed-off-by: Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
---
 drivers/gpu/drm/radeon/ni.c          |    5 +-
 drivers/gpu/drm/radeon/radeon.h      |   12 ++-
 drivers/gpu/drm/radeon/radeon_gart.c |  148 +++++++++++++++++++++++++++++++---
 drivers/gpu/drm/radeon/si.c          |    4 +-
 4 files changed, 153 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index cea8aea..9f442df 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -782,7 +782,7 @@ static int cayman_pcie_gart_enable(struct radeon_device *rdev)
 	       (u32)(rdev->dummy_page.addr >> 12));
 	WREG32(VM_CONTEXT1_CNTL2, 0);
 	WREG32(VM_CONTEXT1_CNTL, 0);
-	WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(0) |
+	WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(1) |
 				RANGE_PROTECTION_FAULT_ENABLE_DEFAULT);
 
 	cayman_pcie_gart_tlb_flush(rdev);
@@ -1523,6 +1523,7 @@ uint32_t cayman_vm_page_flags(struct radeon_device *rdev, uint32_t flags)
  * @pe: addr of the page entry
  * @addr: dst addr to write into pe
  * @count: number of page entries to update
+ * @incr: increase next addr by incr bytes
  * @flags: access flags
  *
  * Update the page tables using the CP (cayman-si).
@@ -1579,7 +1580,7 @@ void cayman_vm_flush(struct radeon_device *rdev, struct radeon_ib *ib)
 	radeon_ring_write(ring, vm->last_pfn);
 
 	radeon_ring_write(ring, PACKET0(VM_CONTEXT0_PAGE_TABLE_BASE_ADDR + (vm->id << 2), 0));
-	radeon_ring_write(ring, vm->pt_gpu_addr >> 12);
+	radeon_ring_write(ring, vm->pd_gpu_addr >> 12);
 
 	/* flush hdp cache */
 	radeon_ring_write(ring, PACKET0(HDP_MEM_COHERENCY_FLUSH_CNTL, 0));
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 0eaa434..53cd03e 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -655,8 +655,7 @@ struct radeon_vm {
 	struct list_head		va;
 	unsigned			id;
 	unsigned			last_pfn;
-	u64				pt_gpu_addr;
-	u64				*pt;
+	u64				pd_gpu_addr;
 	struct radeon_sa_bo		*sa_bo;
 	struct mutex			mutex;
 	/* last fence for cs using this vm */
@@ -665,6 +664,15 @@ struct radeon_vm {
 	struct radeon_fence		*last_flush;
 };
 
+/* GPUVM defines */
+
+/* We consider the case where PAGE_TABLE_BLOCK_SIZE is 0 */
+/* So PDE is 19 bits long, PTE is 9 and OFFSET is 12 */
+#define RADEON_VM_BLOCK_SIZE   9
+
+/* number of PTEs in Page Table */
+#define RADEON_PTE_COUNT (1 << RADEON_VM_BLOCK_SIZE)
+
 struct radeon_vm_manager {
 	struct mutex			lock;
 	struct list_head		lru_vm;
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index bb9fc59..ebca931 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -50,6 +50,64 @@
  * This file handles the common internal GART management.
  */
 
+/* GPUVM defines */
+
+/* current distance in bytes between two adjacent page tables */
+#define RADEON_PT_DISTANCE \
+	(RADEON_PTE_COUNT * RADEON_PTE_SIZE)
+
+#define RADEON_PTE_SIZE 8
+#define RADEON_PDE_SIZE 8
+
+/* Get last PDE number containing nth PTE */
+static __inline__ uint32_t radeon_get_pde_for_pfn(uint32_t n)
+{
+	return n / RADEON_PTE_COUNT;
+}
+
+/* Get PTE number to containing nth pfn */
+static __inline__ uint32_t radeon_get_pte_for_pfn(uint32_t n)
+{
+	return n % RADEON_PTE_COUNT;
+}
+
+
+/* Number of PDE tables to cover n PTEs */
+static __inline__ uint32_t radeon_pde_count_for_n_pages(uint32_t n)
+{
+	return (n + RADEON_PTE_COUNT - 1) / RADEON_PTE_COUNT;
+}
+
+
+/* Number of PDE tables to cover max_pfn (maximum number of PTEs) */
+static __inline__ uint32_t radeon_total_pde_count(struct radeon_device *rdev)
+{
+	return radeon_pde_count_for_n_pages(rdev->vm_manager.max_pfn);
+}
+
+/* offset for npde-th PDE starting from beginning of PDE table */
+static __inline__ uint64_t radeon_pde_offset(struct radeon_device *rdev, uint32_t npde)
+{
+	return npde * RADEON_PDE_SIZE;
+}
+
+/* offset for page tables start */
+static __inline__ uint64_t radeon_pt_offset(struct radeon_device *rdev)
+{
+	return RADEON_GPU_PAGE_ALIGN(radeon_total_pde_count(rdev) *
+				     RADEON_PDE_SIZE);
+}
+
+/* offset for npte-th PTE of npde-th PDE starting from beginning of PDE table */
+static __inline__ uint64_t radeon_pte_offset(struct radeon_device *rdev,
+					     uint32_t npde, uint32_t npte)
+{
+	return 	radeon_pt_offset(rdev) +
+		npde * RADEON_PTE_COUNT * RADEON_PTE_SIZE +
+		npte * RADEON_PTE_SIZE;
+}
+
+
 /*
  * Common GART table functions.
  */
@@ -490,7 +548,6 @@ static void radeon_vm_free_pt(struct radeon_device *rdev,
 
 	list_del_init(&vm->list);
 	radeon_sa_bo_free(rdev, &vm->sa_bo, vm->fence);
-	vm->pt = NULL;
 
 	list_for_each_entry(bo_va, &vm->va, vm_list) {
 		bo_va->valid = false;
@@ -546,11 +603,17 @@ int radeon_vm_alloc_pt(struct radeon_device *rdev, struct radeon_vm *vm)
 {
 	struct radeon_vm *vm_evict;
 	int r;
+	u64 __iomem *pd_addr;
+	int gpuvm_tables_sz;
 
 	if (vm == NULL) {
 		return -EINVAL;
 	}
 
+	gpuvm_tables_sz = RADEON_GPU_PAGE_ALIGN(
+		radeon_total_pde_count(rdev) * RADEON_PDE_SIZE) +
+		vm->last_pfn  * RADEON_PTE_SIZE;
+
 	if (vm->sa_bo != NULL) {
 		/* update lru */
 		list_del_init(&vm->list);
@@ -560,7 +623,7 @@ int radeon_vm_alloc_pt(struct radeon_device *rdev, struct radeon_vm *vm)
 
 retry:
 	r = radeon_sa_bo_new(rdev, &rdev->vm_manager.sa_manager, &vm->sa_bo,
-			     RADEON_GPU_PAGE_ALIGN(vm->last_pfn * 8),
+			     gpuvm_tables_sz,
 			     RADEON_GPU_PAGE_SIZE, false);
 	if (r == -ENOMEM) {
 		if (list_empty(&rdev->vm_manager.lru_vm)) {
@@ -576,9 +639,9 @@ retry:
 		return r;
 	}
 
-	vm->pt = radeon_sa_bo_cpu_addr(vm->sa_bo);
-	vm->pt_gpu_addr = radeon_sa_bo_gpu_addr(vm->sa_bo);
-	memset(vm->pt, 0, RADEON_GPU_PAGE_ALIGN(vm->last_pfn * 8));
+	pd_addr = radeon_sa_bo_cpu_addr(vm->sa_bo);
+	vm->pd_gpu_addr = radeon_sa_bo_gpu_addr(vm->sa_bo);
+	memset(pd_addr, 0, gpuvm_tables_sz);
 
 	list_add_tail(&vm->list, &rdev->vm_manager.lru_vm);
 	return radeon_vm_bo_update_pte(rdev, vm, rdev->ring_tmp_bo.bo,
@@ -845,6 +908,69 @@ uint64_t radeon_vm_map_gart(struct radeon_device *rdev, uint64_t addr)
 }
 
 /**
+ * radeon_vm_bo_set_pages - update PDE and PTE for pfn
+ *
+ * @rdev: radeon_device pointer
+ * @vm: requested vm
+ * @first_pfn: first pfn in bo address space to start mapping from
+ * @addr: bo start address in vm address space
+ * @npages: number of pages to map
+ * @flags: page flags
+ *
+ * Update page directory and table entries for pfn (cayman+).
+ */
+
+static int radeon_vm_bo_set_pages(struct radeon_device *rdev,
+				  struct radeon_vm *vm,
+				  unsigned first_pfn, uint64_t addr,
+				  unsigned npages, uint32_t flags)
+{
+	u64 pde_num, pte_num, start_pde, pde_count = 0;
+
+	unsigned count, pfn_idx;
+	unsigned last_pfn = first_pfn + npages, pfns_to_pt_edge, pfns_to_end;
+	uint64_t mem_pfn_offset;
+
+	pfn_idx = first_pfn;
+
+	for (mem_pfn_offset = 0; mem_pfn_offset < npages;) {
+
+		pfns_to_end = last_pfn - pfn_idx;
+		pfns_to_pt_edge = RADEON_PTE_COUNT -
+		    (pfn_idx % RADEON_PTE_COUNT);
+
+		count = pfns_to_pt_edge < pfns_to_end ?
+		    pfns_to_pt_edge : pfns_to_end;
+
+		pde_num = radeon_get_pde_for_pfn(pfn_idx);
+		pte_num = radeon_get_pte_for_pfn(pfn_idx);
+
+		radeon_asic_vm_set_page(
+			rdev, vm->pd_gpu_addr +
+			radeon_pte_offset(rdev, pde_num, pte_num),
+			mem_pfn_offset * RADEON_GPU_PAGE_SIZE +
+			addr,
+			count, RADEON_GPU_PAGE_SIZE,
+			flags);
+
+		pfn_idx += count;
+		mem_pfn_offset += count;
+
+		pde_count++;
+	}
+
+	start_pde = radeon_get_pde_for_pfn(first_pfn);
+
+	radeon_asic_vm_set_page(rdev,
+		vm->pd_gpu_addr + radeon_pde_offset(rdev, start_pde),
+		vm->pd_gpu_addr + radeon_pte_offset(rdev, start_pde, 0),
+		pde_count, RADEON_PT_DISTANCE, RADEON_VM_PAGE_VALID 
+		);
+
+	return 0;
+}
+
+/**
  * radeon_vm_bo_update_pte - map a bo into the vm page table
  *
  * @rdev: radeon_device pointer
@@ -866,7 +992,7 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 	struct radeon_ring *ring = &rdev->ring[ridx];
 	struct radeon_semaphore *sem = NULL;
 	struct radeon_bo_va *bo_va;
-	unsigned ngpu_pages, ndw;
+	unsigned ngpu_pages, ndw, npdes;
 	uint64_t pfn, addr;
 	int r;
 
@@ -921,9 +1047,12 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 	}
 
 	/* estimate number of dw needed */
+	npdes = (radeon_pde_count_for_n_pages(pfn + ngpu_pages) -
+		 radeon_get_pde_for_pfn(pfn));
+
 	ndw = 32;
-	ndw += (ngpu_pages >> 12) * 3;
-	ndw += ngpu_pages * 2;
+	ndw += ngpu_pages * 2 + 3 * npdes;
+	ndw += npdes * 2 + 3;
 
 	r = radeon_ring_lock(rdev, ring, ndw);
 	if (r) {
@@ -935,8 +1064,7 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 		radeon_fence_note_sync(vm->fence, ridx);
 	}
 
-	radeon_asic_vm_set_page(rdev, vm->pt_gpu_addr + pfn * 8, addr,
-				ngpu_pages, RADEON_GPU_PAGE_SIZE, bo_va->flags);
+	radeon_vm_bo_set_pages(rdev, vm, pfn, addr, ngpu_pages, bo_va->flags);
 
 	radeon_fence_unref(&vm->fence);
 	r = radeon_fence_emit(rdev, &vm->fence, ridx);
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 2a5c337..156c994 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2426,7 +2426,7 @@ static int si_pcie_gart_enable(struct radeon_device *rdev)
 	WREG32(VM_CONTEXT1_PROTECTION_FAULT_DEFAULT_ADDR,
 	       (u32)(rdev->dummy_page.addr >> 12));
 	WREG32(VM_CONTEXT1_CNTL2, 0);
-	WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(0) |
+	WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(1) |
 				RANGE_PROTECTION_FAULT_ENABLE_DEFAULT);
 
 	si_pcie_gart_tlb_flush(rdev);
@@ -2804,7 +2804,7 @@ void si_vm_flush(struct radeon_device *rdev, struct radeon_ib *ib)
 		radeon_ring_write(ring, PACKET0(VM_CONTEXT8_PAGE_TABLE_BASE_ADDR
 						+ ((vm->id - 8) << 2), 0));
 	}
-	radeon_ring_write(ring, vm->pt_gpu_addr >> 12);
+	radeon_ring_write(ring, vm->pd_gpu_addr >> 12);
 
 	/* flush hdp cache */
 	radeon_ring_write(ring, PACKET0(HDP_MEM_COHERENCY_FLUSH_CNTL, 0));
-- 
1.7.10.4

