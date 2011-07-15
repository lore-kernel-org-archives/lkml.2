Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab1GORiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:38:09 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33352
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754202Ab1GORaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 091/117] Staging: hv: netvsc:  Use the newly introduced lock in accessing ext field
Date: Fri, 15 Jul 2011 10:47:19 -0700
Message-Id: <1310752065-27895-91-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced lock in accessing ext field.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   33 ++++++++++++++++++++++++++++++---
 1 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 67cf7fb..c38c669 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -54,12 +54,15 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
+	unsigned long flags;
 
+	spin_lock_irqsave(&device->ext_lock, flags);
 	net_device = device->ext;
 	if (net_device && atomic_read(&net_device->refcnt) > 1)
 		atomic_inc(&net_device->refcnt);
 	else
 		net_device = NULL;
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 
 	return net_device;
 }
@@ -68,33 +71,46 @@ static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 static struct netvsc_device *get_inbound_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
+	unsigned long flags;
 
+	spin_lock_irqsave(&device->ext_lock, flags);
 	net_device = device->ext;
 	if (net_device && atomic_read(&net_device->refcnt))
 		atomic_inc(&net_device->refcnt);
 	else
 		net_device = NULL;
 
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 	return net_device;
 }
 
 static void put_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
+	unsigned long flags;
+
+	spin_lock_irqsave(&device->ext_lock, flags);
 
 	net_device = device->ext;
 
 	atomic_dec(&net_device->refcnt);
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 }
 
 static struct netvsc_device *release_outbound_net_device(
 		struct hv_device *device)
 {
 	struct netvsc_device *net_device;
+	unsigned long flags;
 
+	spin_lock_irqsave(&device->ext_lock, flags);
 	net_device = device->ext;
-	if (net_device == NULL)
+	if (net_device == NULL) {
+		spin_unlock_irqrestore(&device->ext_lock, flags);
 		return NULL;
+	}
+
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 
 	/* Busy wait until the ref drop to 2, then set it to 1 */
 	while (atomic_cmpxchg(&net_device->refcnt, 2, 1) != 2)
@@ -107,16 +123,23 @@ static struct netvsc_device *release_inbound_net_device(
 		struct hv_device *device)
 {
 	struct netvsc_device *net_device;
+	unsigned long flags;
 
+	spin_lock_irqsave(&device->ext_lock, flags);
 	net_device = device->ext;
-	if (net_device == NULL)
+	if (net_device == NULL) {
+		spin_unlock_irqrestore(&device->ext_lock, flags);
 		return NULL;
+	}
 
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 	/* Busy wait until the ref drop to 1, then set it to 0 */
 	while (atomic_cmpxchg(&net_device->refcnt, 1, 0) != 1)
 		udelay(100);
 
+	spin_lock_irqsave(&device->ext_lock, flags);
 	device->ext = NULL;
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 	return net_device;
 }
 
@@ -397,6 +420,8 @@ int netvsc_device_remove(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 	struct hv_netvsc_packet *netvsc_packet, *pos;
+	unsigned long flags;
+
 
 	/* Stop outbound traffic ie sends and receives completions */
 	net_device = release_outbound_net_device(device);
@@ -404,8 +429,10 @@ int netvsc_device_remove(struct hv_device *device)
 		dev_err(&device->device, "No net device present!!");
 		return -ENODEV;
 	}
-
+	spin_lock_irqsave(&device->ext_lock, flags);
 	net_device->destroy = true;
+	spin_unlock_irqrestore(&device->ext_lock, flags);
+
 
 	/* Wait for all send completions */
 	while (atomic_read(&net_device->num_outstanding_sends)) {
-- 
1.7.4.1

