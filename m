Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab2LKSn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:43:26 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:35285
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab2LKSnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:43:25 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: balloon: Fix a memory leak
Date: Tue, 11 Dec 2012 11:07:17 -0800
Message-Id: <1355252837-9827-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The send buffer was being leaked; fix it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Jason Wang <jasowang@redhat.com>
---
 drivers/hv/hv_balloon.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 00c8447..c02a33e 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -882,7 +882,7 @@ static int balloon_probe(struct hv_device *dev,
 			balloon_onchannelcallback, dev);
 
 	if (ret)
-		return ret;
+		goto probe_error0;
 
 	dm_device.dev = dev;
 	dm_device.state = DM_INITIALIZING;
@@ -894,7 +894,7 @@ static int balloon_probe(struct hv_device *dev,
 		 kthread_run(dm_thread_func, &dm_device, "hv_balloon");
 	if (IS_ERR(dm_device.thread)) {
 		ret = PTR_ERR(dm_device.thread);
-		goto probe_error0;
+		goto probe_error1;
 	}
 
 	hv_set_drvdata(dev, &dm_device);
@@ -917,12 +917,12 @@ static int balloon_probe(struct hv_device *dev,
 				VM_PKT_DATA_INBAND,
 				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret)
-		goto probe_error1;
+		goto probe_error2;
 
 	t = wait_for_completion_timeout(&dm_device.host_event, 5*HZ);
 	if (t == 0) {
 		ret = -ETIMEDOUT;
-		goto probe_error1;
+		goto probe_error2;
 	}
 
 	/*
@@ -931,7 +931,7 @@ static int balloon_probe(struct hv_device *dev,
 	 */
 	if (dm_device.state == DM_INIT_ERROR) {
 		ret = -ETIMEDOUT;
-		goto probe_error1;
+		goto probe_error2;
 	}
 	/*
 	 * Now submit our capabilities to the host.
@@ -964,12 +964,12 @@ static int balloon_probe(struct hv_device *dev,
 				VM_PKT_DATA_INBAND,
 				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret)
-		goto probe_error1;
+		goto probe_error2;
 
 	t = wait_for_completion_timeout(&dm_device.host_event, 5*HZ);
 	if (t == 0) {
 		ret = -ETIMEDOUT;
-		goto probe_error1;
+		goto probe_error2;
 	}
 
 	/*
@@ -978,18 +978,20 @@ static int balloon_probe(struct hv_device *dev,
 	 */
 	if (dm_device.state == DM_INIT_ERROR) {
 		ret = -ETIMEDOUT;
-		goto probe_error1;
+		goto probe_error2;
 	}
 
 	dm_device.state = DM_INITIALIZED;
 
 	return 0;
 
-probe_error1:
+probe_error2:
 	kthread_stop(dm_device.thread);
 
-probe_error0:
+probe_error1:
 	vmbus_close(dev->channel);
+probe_error0:
+	kfree(send_buffer);
 	return ret;
 }
 
@@ -1002,6 +1004,7 @@ static int balloon_remove(struct hv_device *dev)
 
 	vmbus_close(dev->channel);
 	kthread_stop(dm->thread);
+	kfree(send_buffer);
 
 	return 0;
 }
-- 
1.7.4.1

