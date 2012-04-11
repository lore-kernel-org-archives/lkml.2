Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965468Ab2DKXZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:25:46 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51056 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965310Ab2DKXYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:24:19 -0400
Message-Id: <20120411231045.314749405@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 58/59] iommu/amd: Make sure IOMMU interrupts are re-enabled on resume
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 9ddd592a191b32f2ee6c4b6ed2bd52665c3a49f5 upstream

Unfortunatly the interrupts for the event log and the
peripheral page-faults are only enabled at boot but not
re-enabled at resume. Fix that for 3.2.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1033,8 +1033,9 @@ static int iommu_setup_msi(struct amd_io
 {
 	int r;
 
-	if (pci_enable_msi(iommu->dev))
-		return 1;
+	r = pci_enable_msi(iommu->dev);
+	if (r)
+		return r;
 
 	r = request_threaded_irq(iommu->dev->irq,
 				 amd_iommu_int_handler,
@@ -1044,24 +1045,33 @@ static int iommu_setup_msi(struct amd_io
 
 	if (r) {
 		pci_disable_msi(iommu->dev);
-		return 1;
+		return r;
 	}
 
 	iommu->int_enabled = true;
-	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
 
 	return 0;
 }
 
 static int iommu_init_msi(struct amd_iommu *iommu)
 {
+	int ret;
+
 	if (iommu->int_enabled)
-		return 0;
+		goto enable_faults;
 
 	if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSI))
-		return iommu_setup_msi(iommu);
+		ret = iommu_setup_msi(iommu);
+	else
+		ret = -ENODEV;
+
+	if (ret)
+		return ret;
 
-	return 1;
+enable_faults:
+	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
+
+	return 0;
 }
 
 /****************************************************************************


