Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab1I2TsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:48:16 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:56980
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757128Ab1I2TsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:48:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 18/24] Staging: hv: mousevsc: Now cleanup mousevsc_remove()
Date: Thu, 29 Sep 2011 11:54:58 -0700
Message-Id: <1317322504-9788-18-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, cleanup mousevsc_remove(). The mouse driver once initialized only
receives data from the host. So, by closing the channel first in the
unload path, we can properly deal with inflight packets. So, we don't need
the machinery for managing the life-cycle of the mousevsc_dev object.
Get rid of the unnecessary code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   53 ++--------------------------------------
 1 files changed, 3 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 5324429..317d2be 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -197,9 +197,9 @@ static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 
 static void free_input_device(struct mousevsc_dev *device)
 {
-	WARN_ON(atomic_read(&device->ref_count) != 0);
 	kfree(device->hid_desc);
 	kfree(device->report_desc);
+	hv_set_drvdata(device->device, NULL);
 	kfree(device);
 }
 
@@ -229,39 +229,6 @@ static void put_input_device(struct hv_device *device)
 	atomic_dec(&input_dev->ref_count);
 }
 
-/*
- * Drop ref count to 1 to effectively disable get_input_device()
- */
-static struct mousevsc_dev *release_input_device(struct hv_device *device)
-{
-	struct mousevsc_dev *input_dev;
-
-	input_dev = hv_get_drvdata(device);
-
-	/* Busy wait until the ref drop to 2, then set it to 1  */
-	while (atomic_cmpxchg(&input_dev->ref_count, 2, 1) != 2)
-		udelay(100);
-
-	return input_dev;
-}
-
-/*
- * Drop ref count to 0. No one can use input_device object.
- */
-static struct mousevsc_dev *final_release_input_device(struct hv_device *device)
-{
-	struct mousevsc_dev *input_dev;
-
-	input_dev = hv_get_drvdata(device);
-
-	/* Busy wait until the ref drop to 1, then set it to 0  */
-	while (atomic_cmpxchg(&input_dev->ref_count, 1, 0) != 1)
-		udelay(100);
-
-	hv_set_drvdata(device, NULL);
-	return input_dev;
-}
-
 
 static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 				struct synthhid_device_info *device_info)
@@ -673,28 +640,14 @@ static int mousevsc_remove(struct hv_device *dev)
 {
 	struct mousevsc_dev *input_dev = hv_get_drvdata(dev);
 
+	vmbus_close(dev->channel);
+
 	if (input_dev->connected) {
 		hidinput_disconnect(input_dev->hid_device);
 		input_dev->connected = 0;
 		hid_destroy_device(input_dev->hid_device);
 	}
 
-
-	release_input_device(dev);
-
-
-	/*
-	 * At this point, all outbound traffic should be disable. We only
-	 * allow inbound traffic (responses) to proceed
-	 *
-	 * so that outstanding requests can be completed.
-	 */
-
-	input_dev = final_release_input_device(dev);
-
-	/* Close the channel */
-	vmbus_close(dev->channel);
-
 	free_input_device(input_dev);
 
 	return 0;
-- 
1.7.4.1

