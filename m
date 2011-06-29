Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab1F2OXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:23:00 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42763
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755542Ab1F2OWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 09/40] Staging: hv: storvsc: Get rid of release_stor_device() by inlining the code
Date: Wed, 29 Jun 2011 07:39:06 -0700
Message-Id: <1309358377-8537-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of release_stor_device() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index d1b6c4e..f52e610 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -70,21 +70,6 @@ static inline struct storvsc_device *get_in_stor_device(
 	return stor_device;
 }
 
-/* Drop ref count to 1 to effectively disable get_out_stor_device() */
-static inline struct storvsc_device *release_stor_device(
-					struct hv_device *device)
-{
-	struct storvsc_device *stor_device;
-
-	stor_device = (struct storvsc_device *)device->ext;
-
-	/* Busy wait until the ref drop to 2, then set it to 1 */
-	while (atomic_cmpxchg(&stor_device->ref_count, 2, 1) != 2)
-		udelay(100);
-
-	return stor_device;
-}
-
 /* Drop ref count to 0. No one can use stor_device object. */
 static inline struct storvsc_device *final_release_stor_device(
 			struct hv_device *device)
@@ -406,7 +391,13 @@ int storvsc_dev_remove(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
 
-	stor_device = release_stor_device(device);
+	/*
+	 * Since we currently hold a reference on the stor
+	 * device, it is safe to dereference the ext
+	 * pointer.
+	 */
+	stor_device = (struct storvsc_device *)device->ext;
+	atomic_dec(&stor_device->ref_count);
 	stor_device->destroy = true;
 
 	/*
-- 
1.7.4.1

