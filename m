Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2KUQsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:48:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab2KUQsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:48:50 -0500
Subject: [PATCH] vfio-pci: Enable device before attempting reset
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Wed, 21 Nov 2012 09:48:49 -0700
Message-ID: <20121121164837.27832.38020.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices making use of PM reset are getting incorrectly identified as
not supporting reset because pci_pm_reset() fails unless the device is
in D0 power state.  When first attached to vfio_pci devices are
typically in an unknown power state.  We can fix this by explicitly
setting the power state or simply calling pci_enable_device() before
attempting a pci_reset_function().  We need to enable the device
anyway, so move this up in our vfio_pci_enable() function, which also
simplifies the error path a bit.

Note that pci_disable_device() does not explicitly set the power
state, so there's no need to re-order vfio_pci_disable().

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 306b90c..b28e66c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -43,6 +43,10 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	u16 cmd;
 	u8 msix_pos;
 
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
 	vdev->reset_works = (pci_reset_function(pdev) == 0);
 	pci_save_state(pdev);
 	vdev->pci_saved_state = pci_store_saved_state(pdev);
@@ -51,8 +55,11 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 			 __func__, dev_name(&pdev->dev));
 
 	ret = vfio_config_init(vdev);
-	if (ret)
-		goto out;
+	if (ret) {
+		pci_load_and_free_saved_state(pdev, &vdev->pci_saved_state);
+		pci_disable_device(pdev);
+		return ret;
+	}
 
 	if (likely(!nointxmask))
 		vdev->pci_2_3 = pci_intx_mask_supported(pdev);
@@ -77,17 +84,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	} else
 		vdev->msix_bar = 0xFF;
 
-	ret = pci_enable_device(pdev);
-	if (ret)
-		goto out;
-
-	return ret;
-
-out:
-	kfree(vdev->pci_saved_state);
-	vdev->pci_saved_state = NULL;
-	vfio_config_free(vdev);
-	return ret;
+	return 0;
 }
 
 static void vfio_pci_disable(struct vfio_pci_device *vdev)

