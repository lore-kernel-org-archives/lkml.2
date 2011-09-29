Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab1I2SeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:34:04 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35815
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754741Ab1I2ScT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:32:19 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 17/24] Staging: hv: mousevsc: Get rid of mousevsc_on_device_remove() by inlining code
Date: Thu, 29 Sep 2011 11:54:57 -0700
Message-Id: <1317322504-9788-17-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of mousevsc_on_device_remove() by inlining code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   47 ++++++++++++++--------------------------
 1 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 75ea2db..5324429 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -660,33 +660,6 @@ static int mousevsc_on_device_add(struct hv_device *device,
 	return ret;
 }
 
-static int mousevsc_on_device_remove(struct hv_device *device)
-{
-	struct mousevsc_dev *input_dev;
-	int ret = 0;
-
-
-	input_dev = release_input_device(device);
-
-
-	/*
-	 * At this point, all outbound traffic should be disable. We only
-	 * allow inbound traffic (responses) to proceed
-	 *
-	 * so that outstanding requests can be completed.
-	 */
-
-	input_dev = final_release_input_device(device);
-
-	/* Close the channel */
-	vmbus_close(device->channel);
-
-	free_input_device(input_dev);
-
-	return ret;
-}
-
-
 static int mousevsc_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
@@ -706,11 +679,25 @@ static int mousevsc_remove(struct hv_device *dev)
 		hid_destroy_device(input_dev->hid_device);
 	}
 
+
+	release_input_device(dev);
+
+
 	/*
-	 * Call to the vsc driver to let it know that the device
-	 * is being removed
+	 * At this point, all outbound traffic should be disable. We only
+	 * allow inbound traffic (responses) to proceed
+	 *
+	 * so that outstanding requests can be completed.
 	 */
-	return mousevsc_on_device_remove(dev);
+
+	input_dev = final_release_input_device(dev);
+
+	/* Close the channel */
+	vmbus_close(dev->channel);
+
+	free_input_device(input_dev);
+
+	return 0;
 }
 
 static const struct hv_vmbus_device_id id_table[] = {
-- 
1.7.4.1

