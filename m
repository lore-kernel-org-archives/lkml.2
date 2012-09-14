Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714Ab2INRuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:50:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59862 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab2INRuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:50:32 -0400
From: Dmitry Cherkasov <dcherkassov@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        Dmitry Cherkassov <Dmitrii.Cherkasov@amd.com>
Subject: [PATCH 1/2] drm/radeon: refactor set_page chipset interface v2
Date: Fri, 14 Sep 2012 21:49:41 +0400
Message-Id: <1347644982-17386-1-git-send-email-Dmitrii.Cherkasov@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian König <deathsimple@vodafone.de>

Cleanup the interface in preparation for hierarchical page tables.
v2: * add incr parameter to set_page for simple scattered PTs uptates
    * added PDE-specific flags to r600_flags and radeon_drm.h
    * removed superflous value masking with 0xffffffff

Signed-off-by: Christian König <deathsimple@vodafone.de>
Signed-off-by: Dmitry Cherkassov <Dmitrii.Cherkasov@amd.com>
---
 drivers/gpu/drm/radeon/ni.c          |   47 ++++++++++++++++++++-----------
 drivers/gpu/drm/radeon/radeon.h      |   14 +++++-----
 drivers/gpu/drm/radeon/radeon_asic.h |    6 ++--
 drivers/gpu/drm/radeon/radeon_gart.c |   51 +++++++++++++---------------------
 include/drm/radeon_drm.h             |    1 +
 5 files changed, 62 insertions(+), 57 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index b238216..0355c8d 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1497,6 +1497,7 @@ void cayman_vm_fini(struct radeon_device *rdev)
 {
 }
 
+#define R600_PDE_VALID     (1 << 0)
 #define R600_PTE_VALID     (1 << 0)
 #define R600_PTE_SYSTEM    (1 << 1)
 #define R600_PTE_SNOOPED   (1 << 2)
@@ -1507,6 +1508,7 @@ uint32_t cayman_vm_page_flags(struct radeon_device *rdev, uint32_t flags)
 {
 	uint32_t r600_flags = 0;
 
+	r600_flags |= (flags & RADEON_VM_PDE_VALID) ? R600_PDE_VALID : 0;
 	r600_flags |= (flags & RADEON_VM_PAGE_VALID) ? R600_PTE_VALID : 0;
 	r600_flags |= (flags & RADEON_VM_PAGE_READABLE) ? R600_PTE_READABLE : 0;
 	r600_flags |= (flags & RADEON_VM_PAGE_WRITEABLE) ? R600_PTE_WRITEABLE : 0;
@@ -1521,30 +1523,43 @@ uint32_t cayman_vm_page_flags(struct radeon_device *rdev, uint32_t flags)
  * cayman_vm_set_page - update the page tables using the CP
  *
  * @rdev: radeon_device pointer
+ * @pe: addr of the page entry
+ * @addr: dst addr to write into pe
+ * @count: number of page entries to update
+ * @flags: access flags
  *
  * Update the page tables using the CP (cayman-si).
  */
-void cayman_vm_set_page(struct radeon_device *rdev, struct radeon_vm *vm,
-			unsigned pfn, struct ttm_mem_reg *mem,
-			unsigned npages, uint32_t flags)
+void cayman_vm_set_page(struct radeon_device *rdev, uint64_t pe,
+			uint64_t addr, unsigned count,
+			uint32_t flags, uint32_t incr)
 {
 	struct radeon_ring *ring = &rdev->ring[rdev->asic->vm.pt_ring_index];
-	uint64_t addr, pt = vm->pt_gpu_addr + pfn * 8;
+	uint32_t r600_flags = cayman_vm_page_flags(rdev, flags);
 	int i;
 
-	addr = flags = cayman_vm_page_flags(rdev, flags);
-
-	radeon_ring_write(ring, PACKET3(PACKET3_ME_WRITE, 1 + npages * 2));
-	radeon_ring_write(ring, pt & 0xffffffff);
-	radeon_ring_write(ring, (pt >> 32) & 0xff);
-	for (i = 0; i < npages; ++i) {
-		if (mem) {
-			addr = radeon_vm_get_addr(rdev, mem, i);
-			addr = addr & 0xFFFFFFFFFFFFF000ULL;
-			addr |= flags;
+	radeon_ring_write(ring, PACKET3(PACKET3_ME_WRITE, 1 + count * 2));
+	radeon_ring_write(ring, pe & 0xffffffff);
+	radeon_ring_write(ring, (pe >> 32) & 0xff);
+	for (i = 0; i < count; ++i) {
+		uint64_t value = 0;
+		if (flags & RADEON_VM_PAGE_SYSTEM) {
+			value = radeon_vm_map_gart(rdev, addr);
+			value &= 0xFFFFFFFFFFFFF000ULL;
+			addr += RADEON_GPU_PAGE_SIZE;
+
+		} else if (flags & RADEON_VM_PAGE_VALID) {
+			value = addr;
+			addr += RADEON_GPU_PAGE_SIZE;
+
+		} else if (flags & RADEON_VM_PDE_VALID) {
+			value = addr;
+			addr += incr;
 		}
-		radeon_ring_write(ring, addr & 0xffffffff);
-		radeon_ring_write(ring, (addr >> 32) & 0xffffffff);
+
+		value |= r600_flags;
+		radeon_ring_write(ring, value);
+		radeon_ring_write(ring, (value >> 32));
 	}
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 4d67f0f..f02ea8e 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1141,9 +1141,9 @@ struct radeon_asic {
 		void (*fini)(struct radeon_device *rdev);
 
 		u32 pt_ring_index;
-		void (*set_page)(struct radeon_device *rdev, struct radeon_vm *vm,
-				 unsigned pfn, struct ttm_mem_reg *mem,
-				 unsigned npages, uint32_t flags);
+		void (*set_page)
+		(struct radeon_device *rdev, uint64_t pe,
+		 uint64_t addr, unsigned count, uint32_t flags, uint32_t incr);
 	} vm;
 	/* ring specific callbacks */
 	struct {
@@ -1755,7 +1755,9 @@ void radeon_ring_write(struct radeon_ring *ring, uint32_t v);
 #define radeon_gart_set_page(rdev, i, p) (rdev)->asic->gart.set_page((rdev), (i), (p))
 #define radeon_asic_vm_init(rdev) (rdev)->asic->vm.init((rdev))
 #define radeon_asic_vm_fini(rdev) (rdev)->asic->vm.fini((rdev))
-#define radeon_asic_vm_set_page(rdev, v, pfn, mem, npages, flags) (rdev)->asic->vm.set_page((rdev), (v), (pfn), (mem), (npages), (flags))
+#define radeon_asic_vm_set_page(rdev, pe, addr, count, flags, incr) \
+	((rdev)->asic->vm.set_page((rdev), (pe), (addr), \
+				 (count), (flags), (incr)))
 #define radeon_ring_start(rdev, r, cp) (rdev)->asic->ring[(r)].ring_start((rdev), (cp))
 #define radeon_ring_test(rdev, r, cp) (rdev)->asic->ring[(r)].ring_test((rdev), (cp))
 #define radeon_ib_test(rdev, r, cp) (rdev)->asic->ring[(r)].ib_test((rdev), (cp))
@@ -1840,9 +1842,7 @@ struct radeon_fence *radeon_vm_grab_id(struct radeon_device *rdev,
 void radeon_vm_fence(struct radeon_device *rdev,
 		     struct radeon_vm *vm,
 		     struct radeon_fence *fence);
-u64 radeon_vm_get_addr(struct radeon_device *rdev,
-                       struct ttm_mem_reg *mem,
-                       unsigned pfn);
+uint64_t radeon_vm_map_gart(struct radeon_device *rdev, uint64_t addr);
 int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 			    struct radeon_vm *vm,
 			    struct radeon_bo *bo,
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 29b3d05..7166d5f 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -442,9 +442,9 @@ int cayman_vm_init(struct radeon_device *rdev);
 void cayman_vm_fini(struct radeon_device *rdev);
 void cayman_vm_flush(struct radeon_device *rdev, struct radeon_ib *ib);
 uint32_t cayman_vm_page_flags(struct radeon_device *rdev, uint32_t flags);
-void cayman_vm_set_page(struct radeon_device *rdev, struct radeon_vm *vm,
-			unsigned pfn, struct ttm_mem_reg *mem,
-			unsigned npages, uint32_t flags);
+void cayman_vm_set_page(struct radeon_device *rdev, uint64_t pe,
+			uint64_t addr, unsigned count,
+			uint32_t flags, uint32_t incr);
 int evergreen_ib_parse(struct radeon_device *rdev, struct radeon_ib *ib);
 
 /* DCE6 - SI */
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index 2f28ff3..badc835 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -822,42 +822,26 @@ int radeon_vm_bo_set_addr(struct radeon_device *rdev,
 }
 
 /**
- * radeon_vm_get_addr - get the physical address of the page
+ * radeon_vm_map_gart - get the physical address of a gart page
  *
  * @rdev: radeon_device pointer
- * @mem: ttm mem
- * @pfn: pfn
+ * @addr: the unmapped addr
  *
  * Look up the physical address of the page that the pte resolves
  * to (cayman+).
  * Returns the physical address of the page.
  */
-u64 radeon_vm_get_addr(struct radeon_device *rdev,
-		       struct ttm_mem_reg *mem,
-		       unsigned pfn)
+uint64_t radeon_vm_map_gart(struct radeon_device *rdev, uint64_t addr)
 {
-	u64 addr = 0;
-
-	switch (mem->mem_type) {
-	case TTM_PL_VRAM:
-		addr = (mem->start << PAGE_SHIFT);
-		addr += pfn * RADEON_GPU_PAGE_SIZE;
-		addr += rdev->vm_manager.vram_base_offset;
-		break;
-	case TTM_PL_TT:
-		/* offset inside page table */
-		addr = mem->start << PAGE_SHIFT;
-		addr += pfn * RADEON_GPU_PAGE_SIZE;
-		addr = addr >> PAGE_SHIFT;
-		/* page table offset */
-		addr = rdev->gart.pages_addr[addr];
-		/* in case cpu page size != gpu page size*/
-		addr += (pfn * RADEON_GPU_PAGE_SIZE) & (~PAGE_MASK);
-		break;
-	default:
-		break;
-	}
-	return addr;
+	uint64_t result;
+
+	/* page table offset */
+	result = rdev->gart.pages_addr[addr >> PAGE_SHIFT];
+
+	/* in case cpu page size != gpu page size*/
+	result |= addr & (~PAGE_MASK);
+
+	return result;
 }
 
 /**
@@ -883,7 +867,7 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 	struct radeon_semaphore *sem = NULL;
 	struct radeon_bo_va *bo_va;
 	unsigned ngpu_pages, ndw;
-	uint64_t pfn;
+	uint64_t pfn, addr;
 	int r;
 
 	/* nothing to do if vm isn't bound */
@@ -908,21 +892,25 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 	ngpu_pages = radeon_bo_ngpu_pages(bo);
 	bo_va->flags &= ~RADEON_VM_PAGE_VALID;
 	bo_va->flags &= ~RADEON_VM_PAGE_SYSTEM;
+	pfn = bo_va->soffset / RADEON_GPU_PAGE_SIZE;
 	if (mem) {
+		addr = mem->start << PAGE_SHIFT;
 		if (mem->mem_type != TTM_PL_SYSTEM) {
 			bo_va->flags |= RADEON_VM_PAGE_VALID;
 			bo_va->valid = true;
 		}
 		if (mem->mem_type == TTM_PL_TT) {
 			bo_va->flags |= RADEON_VM_PAGE_SYSTEM;
+		} else {
+			addr += rdev->vm_manager.vram_base_offset;
 		}
 		if (!bo_va->valid) {
 			mem = NULL;
 		}
 	} else {
+		addr = 0;
 		bo_va->valid = false;
 	}
-	pfn = bo_va->soffset / RADEON_GPU_PAGE_SIZE;
 
 	if (vm->fence && radeon_fence_signaled(vm->fence)) {
 		radeon_fence_unref(&vm->fence);
@@ -950,7 +938,8 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 		radeon_fence_note_sync(vm->fence, ridx);
 	}
 
-	radeon_asic_vm_set_page(rdev, vm, pfn, mem, ngpu_pages, bo_va->flags);
+	radeon_asic_vm_set_page(rdev, vm->pt_gpu_addr + pfn * 8, addr,
+				ngpu_pages, bo_va->flags, 0);
 
 	radeon_fence_unref(&vm->fence);
 	r = radeon_fence_emit(rdev, &vm->fence, ridx);
diff --git a/include/drm/radeon_drm.h b/include/drm/radeon_drm.h
index dc3a8cd..f36ebe5 100644
--- a/include/drm/radeon_drm.h
+++ b/include/drm/radeon_drm.h
@@ -896,6 +896,7 @@ struct drm_radeon_gem_pwrite {
 #define RADEON_VM_PAGE_WRITEABLE	(1 << 2)
 #define RADEON_VM_PAGE_SYSTEM		(1 << 3)
 #define RADEON_VM_PAGE_SNOOPED		(1 << 4)
+#define RADEON_VM_PDE_VALID		(1 << 5)
 
 struct drm_radeon_gem_va {
 	uint32_t		handle;
-- 
1.7.10.4

