Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1KASaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:30:19 -0400
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:38997
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102Ab1KASaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:30:18 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Ben Widawsky <ben@bwidawsk.net>
To: Dave Airlie <airlied@redhat.com>
Cc: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Widawsky <ben@bwidawsk.net>
Subject: [PATCH] drm/i915: iommu workaround related cleanups
Date: Tue,  1 Nov 2011 11:29:49 -0700
Message-Id: <1320172189-3478-1-git-send-email-ben@bwidawsk.net>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <CAPM=9txN-YspvSERzUDjkwdciB-TwOvgHEXiAnG53PKA1PGfgQ@mail.gmail.com>
References: <CAPM=9txN-YspvSERzUDjkwdciB-TwOvgHEXiAnG53PKA1PGfgQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanups recommended by Dave Airlie.

Cc: Keith Packard <keithp@keithp.com>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
---
 drivers/char/agp/intel-agp.h |    6 ++++++
 drivers/char/agp/intel-gtt.c |    7 ++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
index 5da67f1..d8fa7d6 100644
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -238,4 +238,10 @@
 int intel_gmch_probe(struct pci_dev *pdev,
 			       struct agp_bridge_data *bridge);
 void intel_gmch_remove(struct pci_dev *pdev);
+
+#ifdef CONFIG_INTEL_IOMMU
+/* This is a special note from the iommu driver that we are mapped through it */
+extern int intel_iommu_gfx_mapped;
+#endif
+
 #endif
diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index c92424c..11985fb 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1183,14 +1183,13 @@ static void gen6_cleanup(void)
 {
 }
 
+#ifdef CONFIG_INTEL_IOMMU
 /* Certain Gen5 chipsets require require idling the GPU before
  * unmapping anything from the GTT when VT-d is enabled.
  */
 static inline int needs_idle_maps(void)
 {
-#ifdef CONFIG_INTEL_IOMMU
 	const unsigned short gpu_devid = intel_private.pcidev->device;
-	extern int intel_iommu_gfx_mapped;
 
 	/* Query intel_iommu to see if we need the workaround. Presumably that
 	 * was loaded first.
@@ -1199,9 +1198,11 @@ static inline int needs_idle_maps(void)
 	     gpu_devid == PCI_DEVICE_ID_INTEL_IRONLAKE_M_IG) &&
 	     intel_iommu_gfx_mapped)
 		return 1;
-#endif
 	return 0;
 }
+#else
+static inline bool needs_idle_maps(void) { return false; }
+#endif
 
 static int i9xx_setup(void)
 {
-- 
1.7.7.1

