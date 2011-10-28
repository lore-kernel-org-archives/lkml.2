Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1J1R4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:56:37 -0400
Received: from home.keithp.com ([63.227.221.253]:60663 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1J1R4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:56:35 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>,
        Ben Widawsky <ben@bwidawsk.net>
Subject: [PATCH] agp: iommu_gfx_mapped only available if CONFIG_INTEL_IOMMU is set
Date: Fri, 28 Oct 2011 10:56:29 -0700
Message-Id: <1319824589-18082-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernels with no iommu support cannot ever need the Ironlake
work-around, so never enable it in that case.

Might be better to completely remove the work-around from the kernel
in this case?

Signed-off-by: Keith Packard <keithp@keithp.com>
Cc: Ben Widawsky <ben@bwidawsk.net>
---

Here's a shorter patch which just elides the body of the needs_idle_maps functions

 drivers/char/agp/intel-gtt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 3a8d448..c92424c 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1186,10 +1186,11 @@ static void gen6_cleanup(void)
 /* Certain Gen5 chipsets require require idling the GPU before
  * unmapping anything from the GTT when VT-d is enabled.
  */
-extern int intel_iommu_gfx_mapped;
 static inline int needs_idle_maps(void)
 {
+#ifdef CONFIG_INTEL_IOMMU
 	const unsigned short gpu_devid = intel_private.pcidev->device;
+	extern int intel_iommu_gfx_mapped;
 
 	/* Query intel_iommu to see if we need the workaround. Presumably that
 	 * was loaded first.
@@ -1198,7 +1199,7 @@ static inline int needs_idle_maps(void)
 	     gpu_devid == PCI_DEVICE_ID_INTEL_IRONLAKE_M_IG) &&
 	     intel_iommu_gfx_mapped)
 		return 1;
-
+#endif
 	return 0;
 }
 
-- 
1.7.7

