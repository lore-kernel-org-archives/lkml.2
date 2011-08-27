Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1H0SMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:51 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37998
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751063Ab1H0SLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 09/46] Staging: hv: storvsc: Get rid of final_release_stor_device() by inlining code
Date: Sat, 27 Aug 2011 11:31:08 -0700
Message-Id: <1314469905-7058-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of final_release_stor_device() by inlining code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 1976a34..3e9829f 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -67,22 +67,6 @@ static inline struct storvsc_device *get_in_stor_device(
 	return stor_device;
 }
 
-/* Drop ref count to 0. No one can use stor_device object. */
-static inline struct storvsc_device *final_release_stor_device(
-			struct hv_device *device)
-{
-	struct storvsc_device *stor_device;
-
-	stor_device = (struct storvsc_device *)device->ext;
-
-	/* Busy wait until the ref drop to 1, then set it to 0 */
-	while (atomic_cmpxchg(&stor_device->ref_count, 1, 0) != 1)
-		udelay(100);
-
-	device->ext = NULL;
-	return stor_device;
-}
-
 static int storvsc_channel_init(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
@@ -401,7 +385,12 @@ int storvsc_dev_remove(struct hv_device *device)
 
 	storvsc_wait_to_drain(stor_device);
 
-	stor_device = final_release_stor_device(device);
+	/*
+	 * Since we have already drained, we don't need to busy wait
+	 * as was done in final_release_stor_device()
+	 */
+	atomic_set(&stor_device->ref_count, 0);
+	device->ext = NULL;
 
 	/* Close the channel */
 	vmbus_close(device->channel);
-- 
1.7.4.1

