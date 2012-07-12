Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161736Ab2GLWjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:39:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161687Ab2GLWjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:39:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 074/187] drm/radeon: fix VM page table setup on SI
Date: Thu, 12 Jul 2012 15:33:50 -0700
Message-Id: <20120712191529.275203728@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c21b328ea8c7c71cd2daf50557db440bbaa7ef55 upstream.

Cayman and trinity allow for variable sized VM page
tables, but SI requires that all page tables be the
same size.  The current code assumes variablely sized
VM page tables so SI may end up with part of each page
table overlapping with other memory which could end
up being interpreted by the VM hw as garbage.

Change the code to better accomodate SI.  Allocate enough
space for at least 2 full page tables and always set
last_pfn to max_pfn on SI so each VM is backed by a full
page table.  This limits us to only 2 VMs active at any
given time on SI.  This will be rectified and the code can
be reunified once we move to two level page tables.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_gart.c |   13 +++++++++++--
 drivers/gpu/drm/radeon/si.c          |    4 ++--
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -289,8 +289,9 @@ int radeon_vm_manager_init(struct radeon
 	rdev->vm_manager.enabled = false;
 
 	/* mark first vm as always in use, it's the system one */
+	/* allocate enough for 2 full VM pts */
 	r = radeon_sa_bo_manager_init(rdev, &rdev->vm_manager.sa_manager,
-				      rdev->vm_manager.max_pfn * 8,
+				      rdev->vm_manager.max_pfn * 8 * 2,
 				      RADEON_GEM_DOMAIN_VRAM);
 	if (r) {
 		dev_err(rdev->dev, "failed to allocate vm bo (%dKB)\n",
@@ -635,7 +636,15 @@ int radeon_vm_init(struct radeon_device
 	mutex_init(&vm->mutex);
 	INIT_LIST_HEAD(&vm->list);
 	INIT_LIST_HEAD(&vm->va);
-	vm->last_pfn = 0;
+	/* SI requires equal sized PTs for all VMs, so always set
+	 * last_pfn to max_pfn.  cayman allows variable sized
+	 * pts so we can grow then as needed.  Once we switch
+	 * to two level pts we can unify this again.
+	 */
+	if (rdev->family >= CHIP_TAHITI)
+		vm->last_pfn = rdev->vm_manager.max_pfn;
+	else
+		vm->last_pfn = 0;
 	/* map the ib pool buffer at 0 in virtual address space, set
 	 * read only
 	 */
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2527,12 +2527,12 @@ int si_pcie_gart_enable(struct radeon_de
 	WREG32(0x15DC, 0);
 
 	/* empty context1-15 */
-	/* FIXME start with 1G, once using 2 level pt switch to full
+	/* FIXME start with 4G, once using 2 level pt switch to full
 	 * vm size space
 	 */
 	/* set vm size, must be a multiple of 4 */
 	WREG32(VM_CONTEXT1_PAGE_TABLE_START_ADDR, 0);
-	WREG32(VM_CONTEXT1_PAGE_TABLE_END_ADDR, (1 << 30) / RADEON_GPU_PAGE_SIZE);
+	WREG32(VM_CONTEXT1_PAGE_TABLE_END_ADDR, rdev->vm_manager.max_pfn);
 	for (i = 1; i < 16; i++) {
 		if (i < 8)
 			WREG32(VM_CONTEXT0_PAGE_TABLE_BASE_ADDR + (i << 2),


