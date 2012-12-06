Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2LFVLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:11:09 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:21234
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057Ab2LFVLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:11:07 -0500
X-IronPort-AV: E=Sophos;i="4.84,232,1355094000"; 
   d="scan'208";a="165029376"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: kernel-janitors@vger.kernel.org,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-wireless@vger.kernel.org,
        linux-nfc@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/nfc/nfcwilink.c: use devm_kzalloc
Date: Thu,  6 Dec 2012 23:10:40 +0100
Message-Id: <1354831840-21623-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm_kzalloc allocates memory that is released when a driver detaches.
This patch uses devm_kzalloc for data that is allocated in the probe
function of a platform device and is only freed in the remove function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/nfc/nfcwilink.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index 50b1ee4..c7c182d 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -526,7 +526,7 @@ static int nfcwilink_probe(struct platform_device *pdev)
 
 	nfc_dev_dbg(&pdev->dev, "probe entry");
 
-	drv = kzalloc(sizeof(struct nfcwilink), GFP_KERNEL);
+	drv = devm_kzalloc(&pdev->dev, sizeof(struct nfcwilink), GFP_KERNEL);
 	if (!drv) {
 		rc = -ENOMEM;
 		goto exit;
@@ -547,7 +547,7 @@ static int nfcwilink_probe(struct platform_device *pdev)
 	if (!drv->ndev) {
 		nfc_dev_err(&pdev->dev, "nci_allocate_device failed");
 		rc = -ENOMEM;
-		goto free_exit;
+		goto exit;
 	}
 
 	nci_set_parent_dev(drv->ndev, &pdev->dev);
@@ -566,9 +566,6 @@ static int nfcwilink_probe(struct platform_device *pdev)
 free_dev_exit:
 	nci_free_device(drv->ndev);
 
-free_exit:
-	kfree(drv);
-
 exit:
 	return rc;
 }
@@ -588,8 +585,6 @@ static int nfcwilink_remove(struct platform_device *pdev)
 	nci_unregister_device(ndev);
 	nci_free_device(ndev);
 
-	kfree(drv);
-
 	dev_set_drvdata(&pdev->dev, NULL);
 
 	return 0;

