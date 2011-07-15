Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1GORgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:36:10 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33338
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754227Ab1GORaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:09 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 087/117] Staging: hv: storvsc: Further cleanup reference counting of stor_device
Date: Fri, 15 Jul 2011 10:47:15 -0700
Message-Id: <1310752065-27895-87-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further cleanup reference counting of stor_device - when the device is being
destroyed, we will permit incoming traffic only to drain outstanding
requests.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv_storage.h |    3 +--
 drivers/staging/hv/storvsc.c        |   22 +++++++++++++---------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/hyperv_storage.h b/drivers/staging/hv/hyperv_storage.h
index d946211..a1f3e27 100644
--- a/drivers/staging/hv/hyperv_storage.h
+++ b/drivers/staging/hv/hyperv_storage.h
@@ -287,7 +287,6 @@ struct storvsc_device {
 };
 
 
-/* Get the stordevice object iff exists and its refcount > 1 */
 static inline struct storvsc_device *get_out_stor_device(
 					struct hv_device *device)
 {
@@ -296,7 +295,7 @@ static inline struct storvsc_device *get_out_stor_device(
 
 	spin_lock_irqsave(&device->ext_lock, flags);
 	stor_device = (struct storvsc_device *)device->ext;
-	if (stor_device && (stor_device->ref_count > 1) &&
+	if (stor_device && (stor_device->ref_count) &&
 		!stor_device->destroy)
 		stor_device->ref_count++;
 	else
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index a41be2a..4d13044 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -40,9 +40,7 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 	if (!stor_device)
 		return NULL;
 
-	/* Set to 2 to allow both inbound and outbound traffics */
-	/* (ie get_out_stor_device() and get_in_stor_device()) to proceed. */
-	stor_device->ref_count = 2;
+	stor_device->ref_count = 1;
 	stor_device->destroy = false;
 	init_waitqueue_head(&stor_device->waiting_to_drain);
 	stor_device->device = device;
@@ -51,8 +49,6 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 	return stor_device;
 }
 
-
-/* Get the stordevice object iff exists and its refcount > 0 */
 static inline struct storvsc_device *get_in_stor_device(
 					struct hv_device *device)
 {
@@ -61,10 +57,18 @@ static inline struct storvsc_device *get_in_stor_device(
 
 	spin_lock_irqsave(&device->ext_lock, flags);
 	stor_device = (struct storvsc_device *)device->ext;
-	if (stor_device && stor_device->ref_count)
-		stor_device->ref_count++;
-	else
-		stor_device = NULL;
+	if (!stor_device)
+		goto cleanup;
+
+	/*
+	 * If the device is being destroyed; allow incoming
+	 * traffic only to cleanup outstanding requests.
+	 */
+	if (stor_device->destroy &&
+		 (atomic_read(&stor_device->num_outstanding_req) == 0))
+		goto cleanup;
+	stor_device->ref_count++;
+cleanup:
 	spin_unlock_irqrestore(&device->ext_lock, flags);
 
 	return stor_device;
-- 
1.7.4.1

