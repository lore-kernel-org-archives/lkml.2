Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab1IMWZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 18:25:52 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42344
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932956Ab1IMWZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 18:25:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, joe@perches.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: netvsc: Cleanup the name and type of link_stat variable
Date: Tue, 13 Sep 2011 15:21:27 -0700
Message-Id: <1315952487-23406-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consistently name the variable tracking the link status. Use a consistent
type for this variable and get rid of some unnecessary parentheses as well.
I would like to thank Joe Perches <joe@perches.com> for suggesting these
changes and patiently helping me get here!

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/rndis_filter.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 963582a..ef43f2e 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -41,7 +41,7 @@ struct rndis_device {
 	struct netvsc_device *net_dev;
 
 	enum rndis_device_state state;
-	u32 link_stat;
+	bool link_state;
 	atomic_t new_req_id;
 
 	spinlock_t request_lock;
@@ -511,10 +511,15 @@ static int rndis_filter_query_device_mac(struct rndis_device *dev)
 static int rndis_filter_query_device_link_status(struct rndis_device *dev)
 {
 	u32 size = sizeof(u32);
+	u32 link_status;
+	int ret;
 
-	return rndis_filter_query_device(dev,
+	ret = rndis_filter_query_device(dev,
 				      RNDIS_OID_GEN_MEDIA_CONNECT_STATUS,
-				      &dev->link_stat, &size);
+				      &link_status, &size);
+	dev->link_state = (link_status != 0) ? true : false;
+
+	return ret;
 }
 
 static int rndis_filter_set_packet_filter(struct rndis_device *dev,
@@ -736,11 +741,11 @@ int rndis_filter_device_add(struct hv_device *dev,
 
 	rndis_filter_query_device_link_status(rndis_device);
 
-	device_info->link_state = rndis_device->link_stat;
+	device_info->link_state = rndis_device->link_state;
 
-	dev_info(&dev->device, "Device MAC %pM link state %s",
+	dev_info(&dev->device, "Device MAC %pM link state %s\n",
 		 rndis_device->hw_mac_adr,
-		 ((device_info->link_state) ? ("down\n") : ("up\n")));
+		 device_info->link_state ? "down" : "up");
 
 	return ret;
 }
-- 
1.7.4.1

