Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2FFOcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:32:16 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56034 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756146Ab2FFOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:32:11 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2012 10:32:05 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAMFmz09bdWOb/2dsb2JhbABFhU6uZ4EHghkBBSMECwFGECUCJgICVwcSiA+kSZJggSOOfIESA5Udj3qCYg
X-IronPort-AV: E=Sophos;i="4.75,724,1330902000"; 
   d="scan'208";a="999999581"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 3/4] Staging: xgifb: disable pci device if there's an error after enabling it.
Date: Wed,  6 Jun 2012 16:22:06 +0200
Message-Id: <1338992527-5659-3-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338992527-5659-1-git-send-email-magomez@igalia.com>
References: <1338992527-5659-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 96abb23..438781f 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1904,7 +1904,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (reg1 != 0xa1) { /*I/O error */
 		pr_err("I/O error!!!");
 		ret = -EIO;
-		goto error;
+		goto error_disable;
 	}
 
 	switch (xgifb_info->chip_id) {
@@ -1927,7 +1927,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		break;
 	default:
 		ret = -ENODEV;
-		goto error;
+		goto error_disable;
 	}
 
 	pr_info("chipid = %x\n", xgifb_info->chip);
@@ -1936,7 +1936,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (XGIfb_get_dram_size(xgifb_info)) {
 		pr_err("Fatal error: Unable to determine RAM size.\n");
 		ret = -ENODEV;
-		goto error;
+		goto error_disable;
 	}
 
 	/* Enable PCI_LINEAR_ADDRESSING and MMIO_ENABLE  */
@@ -1956,7 +1956,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		pr_err("Fatal error: Unable to reserve frame buffer memory\n");
 		pr_err("Is there another framebuffer driver active?\n");
 		ret = -ENODEV;
-		goto error;
+		goto error_disable;
 	}
 
 	if (!request_mem_region(xgifb_info->mmio_base,
@@ -2271,6 +2271,8 @@ error_1:
 	release_mem_region(xgifb_info->mmio_base, xgifb_info->mmio_size);
 error_0:
 	release_mem_region(xgifb_info->video_base, xgifb_info->video_size);
+error_disable:
+	pci_disable_device(pdev);
 error:
 	framebuffer_release(fb_info);
 	return ret;
-- 
1.7.9.5

