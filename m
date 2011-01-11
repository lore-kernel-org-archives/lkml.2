Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab1AKLuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:50:46 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:22377 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab1AKLuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:50:44 -0500
X-IronPort-AV: E=Sophos;i="4.60,306,1291611600"; 
   d="scan'208";a="130468337"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
        Stefano.Stabellini@eu.citrix.com, konrad.wilk@oracle.com,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH] xen: use PCI interfaces to request IO and MEM resources on platform device.
Date: Tue, 11 Jan 2011 11:50:28 +0000
Message-Id: <1294746628-20396-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 11 Jan 2011 11:50:43.0633 (UTC) FILETIME=[C6EC4210:01CBB185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the correct interface to use and something has broken the use
of the previous incorrect interface (which fails because the request
conflicts with the resources assigned for the PCI device itself
instead of nesting like the PCI interfaces do).

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: stable@kernel.org # 2.6.37 only
---
 drivers/xen/platform-pci.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index c01b5dd..afbe041 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -105,7 +105,7 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 				       const struct pci_device_id *ent)
 {
 	int i, ret;
-	long ioaddr, iolen;
+	long ioaddr;
 	long mmio_addr, mmio_len;
 	unsigned int max_nr_gframes;
 
@@ -114,7 +114,6 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 		return i;
 
 	ioaddr = pci_resource_start(pdev, 0);
-	iolen = pci_resource_len(pdev, 0);
 
 	mmio_addr = pci_resource_start(pdev, 1);
 	mmio_len = pci_resource_len(pdev, 1);
@@ -125,19 +124,13 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 		goto pci_out;
 	}
 
-	if (request_mem_region(mmio_addr, mmio_len, DRV_NAME) == NULL) {
-		dev_err(&pdev->dev, "MEM I/O resource 0x%lx @ 0x%lx busy\n",
-		       mmio_addr, mmio_len);
-		ret = -EBUSY;
+	ret = pci_request_region(pdev, 1, DRV_NAME);
+	if (ret < 0)
 		goto pci_out;
-	}
 
-	if (request_region(ioaddr, iolen, DRV_NAME) == NULL) {
-		dev_err(&pdev->dev, "I/O resource 0x%lx @ 0x%lx busy\n",
-		       iolen, ioaddr);
-		ret = -EBUSY;
+	ret = pci_request_region(pdev, 0, DRV_NAME);
+	if (ret < 0)
 		goto mem_out;
-	}
 
 	platform_mmio = mmio_addr;
 	platform_mmiolen = mmio_len;
@@ -169,9 +162,9 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 	return 0;
 
 out:
-	release_region(ioaddr, iolen);
+	pci_release_region(pdev, 0);
 mem_out:
-	release_mem_region(mmio_addr, mmio_len);
+	pci_release_region(pdev, 1);
 pci_out:
 	pci_disable_device(pdev);
 	return ret;
-- 
1.5.6.5

