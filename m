Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab1F2OXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:23:25 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42810
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755947Ab1F2OWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 22/40] Staging: hv: netvsc: Further cleanup reference counting of netvsc_device
Date: Wed, 29 Jun 2011 07:39:19 -0700
Message-Id: <1309358377-8537-22-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 9ee264c..caca82e 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -40,8 +40,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	if (!net_device)
 		return NULL;
 
-	/* Set to 2 to allow both inbound and outbound traffic */
-	net_device->refcnt = 2;
+	net_device->refcnt = 1;
 	net_device->drain_notify = false;
 	net_device->destroy = false;
 	init_waitqueue_head(&net_device->waiting_to_drain);
@@ -52,7 +51,6 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	return net_device;
 }
 
-/* Get the net device object iff exists and its refcount > 1 */
 static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
@@ -60,7 +58,7 @@ static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 
 	spin_lock_irqsave(&device->ext_lock, flags);
 	net_device = device->ext;
-	if (net_device && (net_device->refcnt > 1) &&
+	if (net_device && (net_device->refcnt) &&
 		!net_device->destroy)
 		net_device->refcnt++;
 	else
@@ -70,7 +68,6 @@ static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 	return net_device;
 }
 
-/* Get the net device object iff exists and its refcount > 0 */
 static struct netvsc_device *get_inbound_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
@@ -78,11 +75,21 @@ static struct netvsc_device *get_inbound_net_device(struct hv_device *device)
 
 	spin_lock_irqsave(&device->ext_lock, flags);
 	net_device = device->ext;
-	if (net_device && net_device->refcnt)
-		net_device->refcnt++;
-	else
-		net_device = NULL;
 
+	if (!net_device)
+		goto cleanup;
+
+	/*
+	 * If the device is being destroyed; allow incoming
+	 * traffic only to cleanup outstanding requests.
+	 */
+	if (net_device->destroy &&
+		(atomic_read(&net_device->num_outstanding_sends) == 0))
+		goto cleanup;
+
+	net_device->refcnt++;
+
+cleanup:
 	spin_unlock_irqrestore(&device->ext_lock, flags);
 	return net_device;
 }
-- 
1.7.4.1

