Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0KBBtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:49:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57764 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0KBBtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=YxDCFHzAOHg3qZemQo6g0PLQ05hUYuAujFf82fmHa5lnuYxP4EbsZcanCmSth5sJGG
         6g5N6NRMBxhvMuofn8cbFKF+h8NcEbFmVN3FNKBJedbZcDBh6OoS/vAZgHWbfl+Mowdd
         gE2g+TCGvtFNzAOcFUhaOZCSBOVaFuoUejqa8=
Subject: [PATCH] dma: intel_mid_dma: fix double free on mid_setup_dma error
	path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain
Date: Tue, 02 Nov 2010 09:52:17 +0800
Message-Id: <1288662737.20990.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not call kfree(dma) in mid_setup_dma error path because
the memory is allocated in intel_mid_dma_probe and will be freed
in intel_mid_dma_probe error path if mid_setup_dma return error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/dma/intel_mid_dma.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 338bc4e..4c55d45 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1075,7 +1075,6 @@ static int mid_setup_dma(struct pci_dev *pdev)
 	if (NULL == dma->dma_pool) {
 		pr_err("ERR_MDMA:pci_pool_create failed\n");
 		err = -ENOMEM;
-		kfree(dma);
 		goto err_dma_pool;
 	}
 
@@ -1186,7 +1185,6 @@ err_engine:
 	free_irq(pdev->irq, dma);
 err_irq:
 	pci_pool_destroy(dma->dma_pool);
-	kfree(dma);
 err_dma_pool:
 	pr_err("ERR_MDMA:setup_dma failed: %d\n", err);
 	return err;
-- 
1.7.2



