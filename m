Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab1KDVJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:09:14 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25892 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1KDVJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:09:12 -0400
Date: Fri, 4 Nov 2011 17:08:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        thellstrom@vmware.com, thomas@shipmail.org, airlied@redhat.com,
        bskeggs@redhat.com, xen-devel@lists.xensource.com
Subject: Re: [PATCH] TTM DMA pool v2.2 or [GIT PULL]
 (stable/ttm.dma_pool.v2.3) for 3.3
Message-ID: <20111104210845.GA4566@phenom.dumpdata.com>
References: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
 <20111104183110.GC2015@homer.localdomain>
 <20111104184453.GB1616@phenom.dumpdata.com>
 <20111104192451.GE2015@homer.localdomain>
 <20111104194102.GA15923@phenom.dumpdata.com>
 <20111104205417.GF2015@homer.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104205417.GF2015@homer.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4EB45470.0080,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. snip..
> > Some AMD boxes with the AMD-Vi chipset enable the SWIOTLB b/c not all of
> > the PCI devices are on the IOMMU chipset path. The Intel VT-d does the same
> > thing.
> > 
> > Hmm, I think the reason for those devices to turn SWIOTLB on is that they
> > are not comfortable handling 32-bit devices, and the TTM DMA pool code would
> > only turn itself on when the radeon|nouveau was 32-bit _and_ SWIOTLB was enabled.
> > 
> > .. Testing the patches you posted on my AMD box.
> 
> Yes, swiotlb was enabled (bounce buffer message) thing is when force is
> not set usual ttm memory page allocation works properly ie on pci map
> no bounce buffer is use, but when force is set it does use a bounce
> This is due to :
> if (dma_capable(dev, dev_addr, size) && !swiotlb_force)
> in swiotlb_map_page, i am not sure how much the force argument is
> usefull.
> 
> Anyway i did few benchmark and it seems that the dma allocator isn't
> slower than the other page allocator. But this is limited testing
> (openarena, nexuiz running on composited desktop with firefox).

Hehe. I also run it with perf record to see it before and after.
Albeit with 'swiotlb=force' _everything_ is going throught the bounce buffer
- including your network packets/USB mouse/etc.

This little patch makes it easier to switch between the TTM DMA and
the default one without using the big hammer approach of 'swiotlb=force':

>From d60930d9b515036268cdf9d9a3d4181bb458ac5c Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 4 Nov 2011 16:53:34 -0400
Subject: [PATCH] ttm:dma: Add 'ttm_dma' module to radeon and nouveau to force
 enable the TTM DMA

. irregardless of whether the device is restricted to DMA32. This
patch is for testing purposes.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/radeon/radeon.h     |    1 +
 drivers/gpu/drm/radeon/radeon_drv.c |    4 ++++
 drivers/gpu/drm/radeon/radeon_ttm.c |    6 +++---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 63257ba..9cae9e2 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -94,6 +94,7 @@ extern int radeon_disp_priority;
 extern int radeon_hw_i2c;
 extern int radeon_pcie_gen2;
 
+extern int radeon_ttm_dma;
 /*
  * Copy from radeon_drv.h so we don't have to include both and have conflicting
  * symbol;
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index e71d2ed..ff81748 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -118,6 +118,10 @@ int radeon_audio = 0;
 int radeon_disp_priority = 0;
 int radeon_hw_i2c = 0;
 int radeon_pcie_gen2 = 0;
+int radeon_ttm_dma = 0;
+
+MODULE_PARM_DESC(ttm_dma, "Enable TTM DMA page pool always irregardless of DMA32 flag");
+module_param_named(ttm_dma, radeon_ttm_dma, int, 0444);
 
 MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers");
 module_param_named(no_wb, radeon_no_wb, int, 0444);
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 82119a5..0dc0048 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -593,7 +593,7 @@ static int radeon_ttm_tt_populate(struct ttm_tt *ttm)
 	rdev = radeon_get_rdev(ttm->bdev);
 
 #ifdef CONFIG_SWIOTLB
-	if (rdev->need_dma32 && swiotlb_nr_tbl()) {
+	if ((rdev->need_dma32 && swiotlb_nr_tbl()) || radeon_ttm_dma) {
 		return ttm_dma_populate(ttm, rdev->dev);
 	}
 #endif
@@ -628,7 +628,7 @@ static void radeon_ttm_tt_unpopulate(struct ttm_tt *ttm)
 	rdev = radeon_get_rdev(ttm->bdev);
 
 #ifdef CONFIG_SWIOTLB
-	if (rdev->need_dma32 && swiotlb_nr_tbl()) {
+	if ((rdev->need_dma32 && swiotlb_nr_tbl()) || radeon_ttm_dma) {
 		ttm_dma_unpopulate(ttm, rdev->dev);
 		return;
 	}
@@ -858,7 +858,7 @@ static int radeon_ttm_debugfs_init(struct radeon_device *rdev)
 	radeon_mem_types_list[i].driver_features = 0;
 	radeon_mem_types_list[i++].data = NULL;
 #ifdef CONFIG_SWIOTLB
-	if (rdev->need_dma32 && swiotlb_nr_tbl()) {
+	if ((rdev->need_dma32 && swiotlb_nr_tbl()) || radeon_ttm_dma) {
 		sprintf(radeon_mem_types_names[i], "ttm_dma_page_pool");
 		radeon_mem_types_list[i].name = radeon_mem_types_names[i];
 		radeon_mem_types_list[i].show = &ttm_dma_page_alloc_debugfs;
-- 
1.7.7.1

