Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab0D3Vka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 17:40:30 -0400
Received: from tex.lwn.net ([70.33.254.29]:36255 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759694Ab0D3VkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 17:40:09 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/3] viafb: Fix initialization error paths
Date: Fri, 30 Apr 2010 15:39:48 -0600
Message-Id: <1272663589-4950-3-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272663589-4950-1-git-send-email-corbet@lwn.net>
References: <1272663589-4950-1-git-send-email-corbet@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly localize error cleanup, and make sure that the iomem regions are
unmapped if framebuffer initialization fails.

Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via-core.c |   36 +++++++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index 58256d0..1c6835e 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -453,26 +453,40 @@ static int viafb_get_fb_size_from_pci(int chip_type)
  */
 static int __devinit via_pci_setup_mmio(struct viafb_dev *vdev)
 {
+	int ret;
 	/*
-	 * Hook up to the device registers.
+	 * Hook up to the device registers.  Note that we soldier
+	 * on if it fails; the framebuffer can operate (without
+	 * acceleration) without this region.
 	 */
 	vdev->engine_start = pci_resource_start(vdev->pdev, 1);
 	vdev->engine_len = pci_resource_len(vdev->pdev, 1);
-	/* If this fails, others will notice later */
 	vdev->engine_mmio = ioremap_nocache(vdev->engine_start,
 			vdev->engine_len);
-
+	if (vdev->engine_mmio == NULL)
+		dev_err(&vdev->pdev->dev,
+				"Unable to map engine MMIO; operation will be "
+				"slow and crippled.\n");
 	/*
-	 * Likewise with I/O memory.
+	 * Map in framebuffer memory.  For now, failure here is
+	 * fatal.  Unfortunately, in the absence of significant
+	 * vmalloc space, failure here is also entirely plausible.
+	 * Eventually we want to move away from mapping this
+	 * entire region.
 	 */
 	vdev->fbmem_start = pci_resource_start(vdev->pdev, 0);
-	vdev->fbmem_len = viafb_get_fb_size_from_pci(vdev->chip_type);
-	if (vdev->fbmem_len < 0)
-		return vdev->fbmem_len;
+	ret = vdev->fbmem_len = viafb_get_fb_size_from_pci(vdev->chip_type);
+	if (ret < 0)
+		goto out_unmap;
 	vdev->fbmem = ioremap_nocache(vdev->fbmem_start, vdev->fbmem_len);
-	if (vdev->fbmem == NULL)
-		return -ENOMEM;
+	if (vdev->fbmem == NULL) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
 	return 0;
+out_unmap:
+	iounmap(vdev->engine_mmio);
+	return ret;
 }
 
 static void __devexit via_pci_teardown_mmio(struct viafb_dev *vdev)
@@ -565,13 +579,13 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	spin_lock_init(&global_dev.reg_lock);
 	ret = via_pci_setup_mmio(&global_dev);
 	if (ret)
-		goto out_teardown;
+		return ret;
 	/*
 	 * Set up the framebuffer device
 	 */
 	ret = via_fb_pci_probe(&global_dev);
 	if (ret)
-		return ret;
+		goto out_teardown;
 	/*
 	 * Create our subdevices.
 	 */
-- 
1.7.0.1

