Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1EWPuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:50:10 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46367
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755255Ab1EWPuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:50:08 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 3/6] staging: hv: change rndis_filter_device_remove() to void return type
Date: Mon, 23 May 2011 09:03:47 -0700
Message-Id: <1306166630-17336-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306166630-17336-1-git-send-email-haiyangz@microsoft.com>
References: <1306166630-17336-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rndis_filter_device_remove() always return 0, so change it to void return
type. Also cleaned up the error checking in the caller.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/hyperv_net.h   |    2 +-
 drivers/staging/hv/netvsc_drv.c   |    9 ++-------
 drivers/staging/hv/rndis_filter.c |    4 +---
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index 315097d..6226dd3 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -101,7 +101,7 @@ int rndis_filter_open(struct hv_device *dev);
 int rndis_filter_close(struct hv_device *dev);
 int rndis_filte_device_add(struct hv_device *dev,
 			void *additional_info);
-int rndis_filter_device_remove(struct hv_device *dev);
+void rndis_filter_device_remove(struct hv_device *dev);
 int rndis_filter_receive(struct hv_device *dev,
 			struct hv_netvsc_packet *pkt);
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index e716d4d..ad25433 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -387,7 +387,6 @@ static int netvsc_probe(struct hv_device *dev)
 static int netvsc_remove(struct hv_device *dev)
 {
 	struct net_device *net = dev_get_drvdata(&dev->device);
-	int ret;
 
 	if (net == NULL) {
 		dev_err(&dev->device, "No net device to remove\n");
@@ -404,14 +403,10 @@ static int netvsc_remove(struct hv_device *dev)
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	ret = rndis_filter_device_remove(dev);
-	if (ret != 0) {
-		/* TODO: */
-		netdev_err(net, "unable to remove vsc device (ret %d)\n", ret);
-	}
+	rndis_filter_device_remove(dev);
 
 	free_netdev(net);
-	return ret;
+	return 0;
 }
 
 /* The one and only one */
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 60ebdb1..572cec6 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -741,7 +741,7 @@ int rndis_filte_device_add(struct hv_device *dev,
 	return ret;
 }
 
-int rndis_filter_device_remove(struct hv_device *dev)
+void rndis_filter_device_remove(struct hv_device *dev)
 {
 	struct netvsc_device *net_dev = dev->ext;
 	struct rndis_device *rndis_dev = net_dev->extension;
@@ -753,8 +753,6 @@ int rndis_filter_device_remove(struct hv_device *dev)
 	net_dev->extension = NULL;
 
 	netvsc_device_remove(dev);
-
-	return 0;
 }
 
 
-- 
1.6.3.2

