Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab2IDPKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:10:30 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab2IDPK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:26 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLATQSECAFAh8HAgJXBhOIEad7kmCBIZAMgRIDlVmJM4lM
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821815"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 01/16] Staging: ipack/bridges/tpci200: Reorganize tpci200_probe in preparation for functional changes.
Date: Tue,  4 Sep 2012 17:01:06 +0200
Message-Id: <1346770881-4723-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

These changes make it easier to add more initialization steps later on.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 5831af8..eda02e7 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -790,8 +790,8 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 
 	tpci200->info = kzalloc(sizeof(struct tpci200_infos), GFP_KERNEL);
 	if (!tpci200->info) {
-		kfree(tpci200);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_err_info;
 	}
 
 	/* Save struct pci_dev pointer */
@@ -801,10 +801,9 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 	/* register the device and initialize it */
 	ret = tpci200_install(tpci200);
 	if (ret) {
-		dev_err(&pdev->dev, "Error during tpci200 install !\n");
-		kfree(tpci200->info);
-		kfree(tpci200);
-		return -ENODEV;
+		dev_err(&pdev->dev, "error during tpci200 install\n");
+		ret = -ENODEV;
+		goto out_err_install;
 	}
 
 	/* Register the carrier in the industry pack bus driver */
@@ -814,10 +813,8 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 	if (!tpci200->info->ipack_bus) {
 		dev_err(&pdev->dev,
 			"error registering the carrier on ipack driver\n");
-		tpci200_uninstall(tpci200);
-		kfree(tpci200->info);
-		kfree(tpci200);
-		return -EFAULT;
+		ret = -EFAULT;
+		goto out_err_bus_register;
 	}
 
 	/* save the bus number given by ipack to logging purpose */
@@ -831,6 +828,14 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 	for (i = 0; i < TPCI200_NB_SLOT; i++)
 		tpci200->slots[i].dev =
 			ipack_device_register(tpci200->info->ipack_bus, i, i);
+	return 0;
+
+out_err_bus_register:
+	tpci200_uninstall(tpci200);
+out_err_install:
+	kfree(tpci200->info);
+out_err_info:
+	kfree(tpci200);
 	return ret;
 }
 
-- 
1.7.10.4

