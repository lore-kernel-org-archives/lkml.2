Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab1F2OXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:23:12 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:48303
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755850Ab1F2OWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 10/40] Staging: hv: storvsc: Get rid of final_release_stor_device() by inlining code
Date: Wed, 29 Jun 2011 07:39:07 -0700
Message-Id: <1309358377-8537-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of final_release_stor_device() by inlining code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c |   25 +++++--------------------
 1 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index f52e610..c4cb170 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -70,25 +70,6 @@ static inline struct storvsc_device *get_in_stor_device(
 	return stor_device;
 }
 
-/* Drop ref count to 0. No one can use stor_device object. */
-static inline struct storvsc_device *final_release_stor_device(
-			struct hv_device *device)
-{
-	struct storvsc_device *stor_device;
-	unsigned long flags;
-
-	stor_device = (struct storvsc_device *)device->ext;
-
-	/* Busy wait until the ref drop to 1, then set it to 0 */
-	while (atomic_cmpxchg(&stor_device->ref_count, 1, 0) != 1)
-		udelay(100);
-
-	spin_lock_irqsave(&device->ext_lock, flags);
-	device->ext = NULL;
-	spin_unlock_irqrestore(&device->ext_lock, flags);
-	return stor_device;
-}
-
 static int storvsc_channel_init(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
@@ -390,6 +371,7 @@ int storvsc_dev_add(struct hv_device *device,
 int storvsc_dev_remove(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
+	unsigned long flags;
 
 	/*
 	 * Since we currently hold a reference on the stor
@@ -408,7 +390,10 @@ int storvsc_dev_remove(struct hv_device *device)
 
 	storvsc_wait_to_drain(stor_device);
 
-	stor_device = final_release_stor_device(device);
+	spin_lock_irqsave(&device->ext_lock, flags);
+	atomic_set(&stor_device->ref_count, 0);
+	device->ext = NULL;
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 
 	/* Close the channel */
 	vmbus_close(device->channel);
-- 
1.7.4.1

