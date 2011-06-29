Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1F2OXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:23:22 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42826
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755957Ab1F2OWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 27/40] Staging: hv: storvsc: Handle IDE devices correctly in storvsc_remove()
Date: Wed, 29 Jun 2011 07:39:24 -0700
Message-Id: <1309358377-8537-27-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly deal with cleaning up of resources on storvsc_remove().
Keep in mind that while on the scsi side, we don't get called for each
scsi disk configured for the guest, on the IDE side, we will get called
for each IDE device that was probed. Perform all the cleanup in the 
context of the HBA owner.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index c0d6e16..a6da132 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -350,6 +350,7 @@ static int storvsc_remove(struct hv_device *dev)
 	struct hv_host_device *host_dev =
 			(struct hv_host_device *)host->hostdata;
 	struct storvsc_device *stor_dev = dev->ext;
+	int i;
 
 	if (!stor_dev->hba_owner)
 		return 0;
@@ -359,6 +360,14 @@ static int storvsc_remove(struct hv_device *dev)
 	scsi_host_put(host);
 
 	storvsc_dev_remove(dev);
+
+	for (i = 0; i < 4; i++) {
+		struct hv_device *d = ide_devices[i];
+
+		if (d)
+			storvsc_dev_remove(d);
+	}
+
 	if (host_dev->request_pool) {
 		kmem_cache_destroy(host_dev->request_pool);
 		host_dev->request_pool = NULL;
-- 
1.7.4.1

