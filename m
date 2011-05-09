Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab1EIWLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:11:44 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48569
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751847Ab1EIVon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:43 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 021/206] Staging: hv: Introduce a function to wait to drain outgoing I/O
Date: Mon,  9 May 2011 14:55:03 -0700
Message-Id: <1304978288-22999-21-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than busy loop waiting to drain I/O, introduce a function 
that does not burn CPU cycles waiting.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c     |    6 +++++-
 drivers/staging/hv/storvsc_api.h |   12 ++++++++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 8ee1ad0..36458b8 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -47,6 +47,7 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 	/* (ie get_stor_device() and must_get_stor_device()) to proceed. */
 	atomic_cmpxchg(&stor_device->ref_count, 0, 2);
 
+	init_waitqueue_head(&stor_device->waiting_to_drain);
 	stor_device->device = device;
 	device->ext = stor_device;
 
@@ -332,7 +333,10 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 
 	request->on_io_completion(request);
 
-	atomic_dec(&stor_device->num_outstanding_req);
+	if (atomic_dec_and_test(&stor_device->num_outstanding_req) &&
+		stor_device->drain_notify)
+		wake_up(&stor_device->waiting_to_drain);
+
 
 	put_stor_device(device);
 }
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 32228c0..1887940 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -26,6 +26,7 @@
 #define _STORVSC_API_H_
 
 #include <linux/kernel.h>
+#include <linux/wait.h>
 #include "vstorage.h"
 #include "vmbus_api.h"
 #include "vmbus.h"
@@ -108,8 +109,11 @@ struct storvsc_device {
 	/* 0 indicates the device is being destroyed */
 	atomic_t ref_count;
 
+	bool	 drain_notify;
 	atomic_t num_outstanding_req;
 
+	wait_queue_head_t waiting_to_drain;
+
 	/*
 	 * Each unique Port/Path/Target represents 1 channel ie scsi
 	 * controller. In reality, the pathid, targetid is always 0
@@ -161,6 +165,14 @@ struct storvsc_driver *drv_to_stordrv(struct device_driver *d)
 	return hvdr_to_stordr(hvdrv);
 }
 
+static inline void storvsc_wait_to_drain(struct storvsc_device *dev)
+{
+	dev->drain_notify = true;
+	wait_event(dev->waiting_to_drain,
+		   atomic_read(&dev->num_outstanding_req) == 0);
+	dev->drain_notify = false;
+}
+
 /* Interface */
 
 int storvsc_dev_add(struct hv_device *device,
-- 
1.7.4.1

