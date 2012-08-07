Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab2HGXMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:12:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56573 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030465Ab2HGWi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:38:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 043/109] iommu/amd: Fix hotplug with iommu=pt
Date: Tue,  7 Aug 2012 15:35:02 -0700
Message-Id: <20120807222046.882690945@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 2c9195e990297068d0f1f1bd8e2f1d09538009da upstream.

This did not work because devices are not put into the
pt_domain. Fix this.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2254,6 +2254,18 @@ static int device_change_notifier(struct
 
 		iommu_init_device(dev);
 
+		/*
+		 * dev_data is still NULL and
+		 * got initialized in iommu_init_device
+		 */
+		dev_data = get_dev_data(dev);
+
+		if (iommu_pass_through || dev_data->iommu_v2) {
+			dev_data->passthrough = true;
+			attach_device(dev, pt_domain);
+			break;
+		}
+
 		domain = domain_for_device(dev);
 
 		/* allocate a protection domain if a device is added */
@@ -2271,10 +2283,7 @@ static int device_change_notifier(struct
 
 		dev_data = get_dev_data(dev);
 
-		if (!dev_data->passthrough)
-			dev->archdata.dma_ops = &amd_iommu_dma_ops;
-		else
-			dev->archdata.dma_ops = &nommu_dma_ops;
+		dev->archdata.dma_ops = &amd_iommu_dma_ops;
 
 		break;
 	case BUS_NOTIFY_DEL_DEVICE:


