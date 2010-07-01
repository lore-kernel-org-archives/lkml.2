Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab0GAWJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:09:35 -0400
Received: from kroah.org ([198.145.64.141]:47487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab0GAUuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:18 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:32 2010
Message-Id: <20100701173432.537908522@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 068/164] x86/amd-iommu: Fix crash when request_mem_region fails
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit e82752d8b5a7e0a5e4d607fd8713549e2a4e2741 upstream.

When request_mem_region fails the error path tries to
disable the IOMMUs. This accesses the mmio-region which was
not allocated leading to a kernel crash. This patch fixes
the issue.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu_init.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -286,8 +286,12 @@ static u8 * __init iommu_map_mmio_space(
 {
 	u8 *ret;
 
-	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu"))
+	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu")) {
+		pr_err("AMD-Vi: Can not reserve memory region %llx for mmio\n",
+			address);
+		pr_err("AMD-Vi: This is a BIOS bug. Please contact your hardware vendor\n");
 		return NULL;
+	}
 
 	ret = ioremap_nocache(address, MMIO_REGION_LENGTH);
 	if (ret != NULL)
@@ -1296,7 +1300,7 @@ static int __init amd_iommu_init(void)
 		ret = amd_iommu_init_dma_ops();
 
 	if (ret)
-		goto free;
+		goto free_disable;
 
 	amd_iommu_init_api();
 
@@ -1314,9 +1318,10 @@ static int __init amd_iommu_init(void)
 out:
 	return ret;
 
-free:
+free_disable:
 	disable_iommus();
 
+free:
 	amd_iommu_uninit_devices();
 
 	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,


