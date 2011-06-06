Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab1FFWfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:35:04 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37208
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756640Ab1FFWe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 04/49] Staging: hv: storvsc: Fix a bug in the storvsc_remove() function
Date: Mon,  6 Jun 2011 15:49:28 -0700
Message-Id: <1307400613-13234-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the storvs driver unloads, we need to accomodate disk cache flushes.
Re-order the code to permit this.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 33bce87..fd474d6 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -317,22 +317,20 @@ static int storvsc_remove(struct hv_device *dev)
 	struct hv_host_device *host_dev =
 			(struct hv_host_device *)host->hostdata;
 
+	DPRINT_INFO(STORVSC, "removing host adapter (%p)...", host);
+	scsi_remove_host(host);
+
+	DPRINT_INFO(STORVSC, "releasing host adapter (%p)...", host);
+	scsi_host_put(host);
 	/*
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
 	storvsc_dev_remove(dev);
-
 	if (host_dev->request_pool) {
 		kmem_cache_destroy(host_dev->request_pool);
 		host_dev->request_pool = NULL;
 	}
-
-	DPRINT_INFO(STORVSC, "removing host adapter (%p)...", host);
-	scsi_remove_host(host);
-
-	DPRINT_INFO(STORVSC, "releasing host adapter (%p)...", host);
-	scsi_host_put(host);
 	return 0;
 }
 
-- 
1.7.4.1

