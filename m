Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1GORjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:39:44 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60192
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754190Ab1GORaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:07 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 084/117] Staging: hv: storvsc: Get rid of release_stor_device() by inlining the code
Date: Fri, 15 Jul 2011 10:47:12 -0700
Message-Id: <1310752065-27895-84-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of release_stor_device() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
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

