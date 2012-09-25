Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2IYOoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:44:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53646 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2IYOoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:44:37 -0400
From: Dmitry Cherkasov <dcherkassov@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
Subject: [PATCH 1/2] drm/radeon: interface cleanup patch v6
Date: Tue, 25 Sep 2012 18:44:11 +0400
Message-Id: <1348584252-22778-1-git-send-email-Dmitrii.Cherkasov@amd.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add addr_list array to set_page.
if it's not NULL these addresses will be put to the ring.

Signed-off-by: Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
---
to be applied on top of drm/radeon: add 2-level VM pagetables support v9

 drivers/gpu/drm/radeon/ni.c          |   11 ++++++++---
 drivers/gpu/drm/radeon/radeon.h      |    4 ++--
 drivers/gpu/drm/radeon/radeon_asic.h |    2 +-
 drivers/gpu/drm/radeon/radeon_gart.c |    4 ++--
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index f920a2c..9230815 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1524,13 +1524,14 @@ uint32_t cayman_vm_page_flags(struct radeon_device *rdev, uint32_t flags)
  * @addr: dst addr to write into pe
  * @count: number of page entries to update
  * @incr: increase next addr by incr bytes
+ * @addr_list: kmalloced array of u64 addresses to write to pe
  * @flags: access flags
  *
  * Update the page tables using the CP (cayman-si).
  */
 void cayman_vm_set_page(struct radeon_device *rdev, uint64_t pe,
 			uint64_t addr, unsigned count,
-			uint32_t incr, uint32_t flags)
+			uint32_t incr, uint64_t *addr_list, uint32_t flags)
 {
 	struct radeon_ring *ring = &rdev->ring[rdev->asic->vm.pt_ring_index];
 	uint32_t r600_flags = cayman_vm_page_flags(rdev, flags);
@@ -1547,8 +1548,12 @@ void cayman_vm_set_page(struct radeon_device *rdev, uint64_t pe,
 			addr += incr;
 
 		} else if (flags & RADEON_VM_PAGE_VALID) {
-			value = addr;
-			addr += incr;
+			if (addr_list == NULL) {
+				value = addr;
+				addr += incr;
+			} else {
+				value = addr_list[i];
+			}
 		}
 
 		value |= r600_flags;
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 519d8a3..d8a61ed 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1151,7 +1151,7 @@ struct radeon_asic {
 		u32 pt_ring_index;
 		void (*set_page)(struct radeon_device *rdev, uint64_t pe,
 				 uint64_t addr, unsigned count,
-				 uint32_t incr, uint32_t flags);
+				 uint32_t incr, uint64_t *addr_list, uint32_t flags);
 	} vm;
 	/* ring specific callbacks */
 	struct {
@@ -1765,7 +1765,7 @@ void radeon_ring_write(struct radeon_ring *ring, uint32_t v);
 #define radeon_gart_set_page(rdev, i, p) (rdev)->asic->gart.set_page((rdev), (i), (p))
 #define radeon_asic_vm_init(rdev) (rdev)->asic->vm.init((rdev))
 #define radeon_asic_vm_fini(rdev) (rdev)->asic->vm.fini((rdev))
-#define radeon_asic_vm_set_page(rdev, pe, addr, count, incr, flags) ((rdev)->asic->vm.set_page((rdev), (pe), (addr), (count), (incr), (flags)))
+#define radeon_asic_vm_set_page(rdev, pe, addr, count, incr, addr_list, flags) ((rdev)->asic->vm.set_page((rdev), (pe), (addr), (count), (incr), (addr_list), (flags)))
 #define radeon_ring_start(rdev, r, cp) (rdev)->asic->ring[(r)].ring_start((rdev), (cp))
 #define radeon_ring_test(rdev, r, cp) (rdev)->asic->ring[(r)].ring_test((rdev), (cp))
 #define radeon_ib_test(rdev, r, cp) (rdev)->asic->ring[(r)].ib_test((rdev), (cp))
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 9a71f44..6fe8e75 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -446,7 +446,7 @@ void cayman_vm_flush(struct radeon_device *rdev, struct radeon_ib *ib);
 uint32_t cayman_vm_page_flags(struct radeon_device *rdev, uint32_t flags);
 void cayman_vm_set_page(struct radeon_device *rdev, uint64_t pe,
 			uint64_t addr, unsigned count,
-			uint32_t incr, uint32_t flags);
+			uint32_t incr, uint64_t *addr_list, uint32_t flags);
 int evergreen_ib_parse(struct radeon_device *rdev, struct radeon_ib *ib);
 
 /* DCE6 - SI */
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index 753b7ca..31d6bfa 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -977,7 +977,7 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 	pe += (bo_va->soffset / RADEON_GPU_PAGE_SIZE) * 8;
 
 	radeon_asic_vm_set_page(rdev, pe, addr, nptes,
-				RADEON_GPU_PAGE_SIZE, bo_va->flags);
+				RADEON_GPU_PAGE_SIZE, NULL, bo_va->flags);
 
 	/* update page directory entries */
 	addr = pe;
@@ -986,7 +986,7 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 	pe += ((bo_va->soffset / RADEON_GPU_PAGE_SIZE) >> RADEON_VM_BLOCK_SIZE) * 8;
 
 	radeon_asic_vm_set_page(rdev, pe, addr, npdes,
-				RADEON_VM_PTE_COUNT * 8, RADEON_VM_PAGE_VALID);
+				RADEON_VM_PTE_COUNT * 8, NULL, RADEON_VM_PAGE_VALID);
 
 	radeon_fence_unref(&vm->fence);
 	r = radeon_fence_emit(rdev, &vm->fence, ridx);
-- 
1.7.10.4

