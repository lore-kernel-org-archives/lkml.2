Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab1F2OXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:23:05 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42770
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755743Ab1F2OWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 07/40] Staging: hv: storvsc: Use the newly introduced lock in accessing ext field
Date: Wed, 29 Jun 2011 07:39:04 -0700
Message-Id: <1309358377-8537-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced lock in accessing ext field.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv_storage.h |    6 ++++++
 drivers/staging/hv/storvsc.c        |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hyperv_storage.h b/drivers/staging/hv/hyperv_storage.h
index d93bf93..6b20f1d 100644
--- a/drivers/staging/hv/hyperv_storage.h
+++ b/drivers/staging/hv/hyperv_storage.h
@@ -292,12 +292,15 @@ static inline struct storvsc_device *get_out_stor_device(
 					struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
+	unsigned long flags;
 
+	spin_lock_irqsave(&device->ext_lock, flags);
 	stor_device = (struct storvsc_device *)device->ext;
 	if (stor_device && atomic_read(&stor_device->ref_count) > 1)
 		atomic_inc(&stor_device->ref_count);
 	else
 		stor_device = NULL;
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 
 	return stor_device;
 }
@@ -306,10 +309,13 @@ static inline struct storvsc_device *get_out_stor_device(
 static inline void put_stor_device(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
+	unsigned long flags;
 
+	spin_lock_irqsave(&device->ext_lock, flags);
 	stor_device = (struct storvsc_device *)device->ext;
 
 	atomic_dec(&stor_device->ref_count);
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 }
 
 static inline void storvsc_wait_to_drain(struct storvsc_device *dev)
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 357b08a..d1b6c4e 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -57,12 +57,15 @@ static inline struct storvsc_device *get_in_stor_device(
 					struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
+	unsigned long flags;
 
+	spin_lock_irqsave(&device->ext_lock, flags);
 	stor_device = (struct storvsc_device *)device->ext;
 	if (stor_device && atomic_read(&stor_device->ref_count))
 		atomic_inc(&stor_device->ref_count);
 	else
 		stor_device = NULL;
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 
 	return stor_device;
 }
@@ -87,6 +90,7 @@ static inline struct storvsc_device *final_release_stor_device(
 			struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
+	unsigned long flags;
 
 	stor_device = (struct storvsc_device *)device->ext;
 
@@ -94,7 +98,9 @@ static inline struct storvsc_device *final_release_stor_device(
 	while (atomic_cmpxchg(&stor_device->ref_count, 1, 0) != 1)
 		udelay(100);
 
+	spin_lock_irqsave(&device->ext_lock, flags);
 	device->ext = NULL;
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 	return stor_device;
 }
 
-- 
1.7.4.1

