Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1GORkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:40:39 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60179
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754171Ab1GORaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:06 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 078/117] Staging: hv: storvsc: Rename get_stor_device()
Date: Fri, 15 Jul 2011 10:47:06 -0700
Message-Id: <1310752065-27895-78-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for cleaning up how we manage reference counts on the stor
device, clearly distinguish why we are attempting to acquire a reference.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv_storage.h |    3 ++-
 drivers/staging/hv/storvsc.c        |    8 ++++----
 drivers/staging/hv/storvsc_drv.c    |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/hyperv_storage.h b/drivers/staging/hv/hyperv_storage.h
index a01f9a0..a224413 100644
--- a/drivers/staging/hv/hyperv_storage.h
+++ b/drivers/staging/hv/hyperv_storage.h
@@ -288,7 +288,8 @@ struct storvsc_device {
 
 
 /* Get the stordevice object iff exists and its refcount > 1 */
-static inline struct storvsc_device *get_stor_device(struct hv_device *device)
+static inline struct storvsc_device *get_out_stor_device(
+					struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 89708b1..313a3f8 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -41,7 +41,7 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 		return NULL;
 
 	/* Set to 2 to allow both inbound and outbound traffics */
-	/* (ie get_stor_device() and get_in_stor_device()) to proceed. */
+	/* (ie get_out_stor_device() and get_in_stor_device()) to proceed. */
 	atomic_cmpxchg(&stor_device->ref_count, 0, 2);
 
 	init_waitqueue_head(&stor_device->waiting_to_drain);
@@ -67,7 +67,7 @@ static inline struct storvsc_device *get_in_stor_device(
 	return stor_device;
 }
 
-/* Drop ref count to 1 to effectively disable get_stor_device() */
+/* Drop ref count to 1 to effectively disable get_out_stor_device() */
 static inline struct storvsc_device *release_stor_device(
 					struct hv_device *device)
 {
@@ -105,7 +105,7 @@ static int storvsc_channel_init(struct hv_device *device)
 	struct vstor_packet *vstor_packet;
 	int ret, t;
 
-	stor_device = get_stor_device(device);
+	stor_device = get_out_stor_device(device);
 	if (!stor_device)
 		return -ENODEV;
 
@@ -427,7 +427,7 @@ int storvsc_do_io(struct hv_device *device,
 	int ret = 0;
 
 	vstor_packet = &request->vstor_packet;
-	stor_device = get_stor_device(device);
+	stor_device = get_out_stor_device(device);
 
 	if (!stor_device)
 		return -ENODEV;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index bc71024..0f2fc2f 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -346,7 +346,7 @@ static int storvsc_host_reset(struct hv_device *device)
 	int ret, t;
 
 
-	stor_device = get_stor_device(device);
+	stor_device = get_out_stor_device(device);
 	if (!stor_device)
 		return -ENODEV;
 
-- 
1.7.4.1

