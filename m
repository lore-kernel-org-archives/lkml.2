Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab1F2O1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:27:16 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42818
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755942Ab1F2OWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 21/40] Staging: hv: netvsc: Leverage the spinlock to manage ref_cnt
Date: Wed, 29 Jun 2011 07:39:18 -0700
Message-Id: <1309358377-8537-21-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using the lock to access the net_device; use this lock to manage the
ref_cnt as well.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv_net.h |    2 +-
 drivers/staging/hv/netvsc.c     |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index c6836be..058ca79 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -369,7 +369,7 @@ struct nvsp_message {
 struct netvsc_device {
 	struct hv_device *dev;
 
-	atomic_t refcnt;
+	int refcnt;
 	atomic_t num_outstanding_sends;
 	bool destroy;
 	bool drain_notify;
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index f930b9e..9ee264c 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -41,7 +41,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 		return NULL;
 
 	/* Set to 2 to allow both inbound and outbound traffic */
-	atomic_set(&net_device->refcnt, 2);
+	net_device->refcnt = 2;
 	net_device->drain_notify = false;
 	net_device->destroy = false;
 	init_waitqueue_head(&net_device->waiting_to_drain);
@@ -60,9 +60,9 @@ static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 
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
@@ -78,8 +78,8 @@ static struct netvsc_device *get_inbound_net_device(struct hv_device *device)
 
 	spin_lock_irqsave(&device->ext_lock, flags);
 	net_device = device->ext;
-	if (net_device && atomic_read(&net_device->refcnt))
-		atomic_inc(&net_device->refcnt);
+	if (net_device && net_device->refcnt)
+		net_device->refcnt++;
 	else
 		net_device = NULL;
 
@@ -96,7 +96,7 @@ static void put_net_device(struct hv_device *device)
 
 	net_device = device->ext;
 
-	atomic_dec(&net_device->refcnt);
+	net_device->refcnt--;
 	spin_unlock_irqrestore(&device->ext_lock, flags);
 }
 
@@ -389,7 +389,7 @@ int netvsc_device_remove(struct hv_device *device)
 	 * it is safe to dereference the ext pointer.
 	 */
 	net_device = (struct netvsc_device *)device->ext;
-	atomic_dec(&net_device->refcnt);
+	net_device->refcnt--;
 	net_device->destroy = true;
 
 	/*
@@ -400,7 +400,7 @@ int netvsc_device_remove(struct hv_device *device)
 	netvsc_disconnect_vsp(net_device);
 
 	spin_lock_irqsave(&device->ext_lock, flags);
-	atomic_set(&net_device->refcnt, 0);
+	net_device->refcnt = 0;
 	device->ext = NULL;
 	spin_unlock_irqrestore(&device->ext_lock, flags);
 
-- 
1.7.4.1

