Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1GORgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:36:15 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33360
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754223Ab1GORaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:09 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 095/117] Staging: hv: netvsc: Leverage the spinlock to manage refcnt
Date: Fri, 15 Jul 2011 10:47:23 -0700
Message-Id: <1310752065-27895-95-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a spin lock protecting the device pointer, use it to also
protect the refrence count.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv_net.h |    2 +-
 drivers/staging/hv/netvsc.c     |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index 0b347c1..5c8fc31 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -369,7 +369,7 @@ struct nvsp_message {
 struct netvsc_device {
 	struct hv_device *dev;
 
-	atomic_t refcnt;
+	int refcnt;
 	atomic_t num_outstanding_sends;
 	bool destroy;
 	/*
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 0411332..3b234a3 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -41,7 +41,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 		return NULL;
 
 	/* Set to 2 to allow both inbound and outbound traffic */
-	atomic_set(&net_device->refcnt, 2);
+	net_device->refcnt = 2;
 
 	net_device->destroy = false;
 	net_device->dev = device;
@@ -58,9 +58,9 @@ static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 
 	spin_lock_irqsave(&device->ext_lock, flags);
 	net_device = device->ext;
-	if (net_device && (atomic_read(&net_device->refcnt) > 1) &&
+	if (net_device && (net_device->refcnt > 1) &&
 		!net_device->destroy)
-		atomic_inc(&net_device->refcnt);
+		net_device->refcnt++;
 	else
 		net_device = NULL;
 	spin_unlock_irqrestore(&device->ext_lock, flags);
@@ -76,8 +76,8 @@ static struct netvsc_device *get_inbound_net_device(struct hv_device *device)
 
 	spin_lock_irqsave(&device->ext_lock, flags);
 	net_device = device->ext;
-	if (net_device && atomic_read(&net_device->refcnt))
-		atomic_inc(&net_device->refcnt);
+	if (net_device && net_device->refcnt)
+		net_device->refcnt++;
 	else
 		net_device = NULL;
 
@@ -94,7 +94,7 @@ static void put_net_device(struct hv_device *device)
 
 	net_device = device->ext;
 
-	atomic_dec(&net_device->refcnt);
+	net_device->refcnt--;
 	spin_unlock_irqrestore(&device->ext_lock, flags);
 }
 
@@ -385,7 +385,7 @@ int netvsc_device_remove(struct hv_device *device)
 		spin_unlock_irqrestore(&device->ext_lock, flags);
 		return -ENODEV;
 	}
-	atomic_dec(&net_device->refcnt);
+	net_device->refcnt--;
 	net_device->destroy = true;
 	spin_unlock_irqrestore(&device->ext_lock, flags);
 
@@ -401,7 +401,7 @@ int netvsc_device_remove(struct hv_device *device)
 	netvsc_disconnect_vsp(net_device);
 
 	spin_lock_irqsave(&device->ext_lock, flags);
-	atomic_dec(&net_device->refcnt);
+	net_device->refcnt--;
 	device->ext = NULL;
 	spin_unlock_irqrestore(&device->ext_lock, flags);
 
@@ -414,7 +414,7 @@ int netvsc_device_remove(struct hv_device *device)
 	 * Since the send path is non-blocking, it is reasonable to busy
 	 * wait here.
 	 */
-	while (atomic_read(&net_device->refcnt))
+	while (net_device->refcnt != 0)
 		udelay(100);
 
 	/* At this point, no one should be accessing netDevice except in here */
-- 
1.7.4.1

