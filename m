Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab1KHQhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:37:40 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:34300
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754376Ab1KHQg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:36:26 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 04/11] Staging: hv: storvsc: Fix error handling storvsc_host_reset()
Date: Tue,  8 Nov 2011 09:01:43 -0800
Message-Id: <1320771710-29139-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1320771710-29139-1-git-send-email-kys@microsoft.com>
References: <1320771677-29095-1-git-send-email-kys@microsoft.com>
 <1320771710-29139-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix error handling storvsc_host_reset(). I would like to thank
Long Li <longli@microsoft.com> for reporting this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Long Li <longli@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index e16c7a3..a145245 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1019,7 +1019,7 @@ static int storvsc_host_reset(struct hv_device *device)
 
 	stor_device = get_out_stor_device(device);
 	if (!stor_device)
-		return -ENODEV;
+		return FAILED;
 
 	request = &stor_device->reset_request;
 	vstor_packet = &request->vstor_packet;
@@ -1036,13 +1036,11 @@ static int storvsc_host_reset(struct hv_device *device)
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0)
-		goto cleanup;
+		return FAILED;
 
 	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-	if (t == 0) {
-		ret = -ETIMEDOUT;
-		goto cleanup;
-	}
+	if (t == 0)
+		return TIMEOUT_ERROR;
 
 
 	/*
@@ -1050,8 +1048,7 @@ static int storvsc_host_reset(struct hv_device *device)
 	 * should have been flushed out and return to us
 	 */
 
-cleanup:
-	return ret;
+	return SUCCESS;
 }
 
 
@@ -1060,16 +1057,11 @@ cleanup:
  */
 static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 {
-	int ret;
 	struct hv_host_device *host_dev =
 		(struct hv_host_device *)scmnd->device->host->hostdata;
 	struct hv_device *dev = host_dev->dev;
 
-	ret = storvsc_host_reset(dev);
-	if (ret != 0)
-		return ret;
-
-	return ret;
+	return storvsc_host_reset(dev);
 }
 
 
-- 
1.7.4.1

