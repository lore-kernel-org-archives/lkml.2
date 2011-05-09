Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1EJIic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:38:32 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42597
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756090Ab1EJIaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 132/206] Staging: hv: Compute max_outstanding_req_per_channel where it is needed
Date: Mon,  9 May 2011 14:56:54 -0700
Message-Id: <1304978288-22999-132-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compute max_outstanding_req_per_channel where it is needed.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 07db877..7d8b8f9 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -90,20 +90,6 @@ static int storvsc_initialize(struct hv_driver *driver)
 	memcpy(&driver->dev_type, &gStorVscDeviceType,
 	       sizeof(struct hv_guid));
 
-
-	/*
-	 * Divide the ring buffer data size (which is 1 page less
-	 * than the ring buffer size since that page is reserved for
-	 * the ring buffer indices) by the max request size (which is
-	 * vmbus_channel_packet_multipage_buffer + struct vstor_packet + u64)
-	 */
-	stor_driver->max_outstanding_req_per_channel =
-		((stor_driver->ring_buffer_size - PAGE_SIZE) /
-		  ALIGN(MAX_MULTIPAGE_BUFFER_PACKET +
-			   sizeof(struct vstor_packet) + sizeof(u64),
-			   sizeof(u64)));
-
-
 	return 0;
 }
 
@@ -797,13 +783,27 @@ static int storvsc_drv_init(void)
 	int ret;
 	struct storvsc_driver *storvsc_drv_obj = &storvsc_drv;
 	struct hv_driver *drv = &storvsc_drv.base;
+	u32 max_outstanding_req_per_channel;
+
+	/*
+	 * Divide the ring buffer data size (which is 1 page less
+	 * than the ring buffer size since that page is reserved for
+	 * the ring buffer indices) by the max request size (which is
+	 * vmbus_channel_packet_multipage_buffer + struct vstor_packet + u64)
+	 */
+
+	max_outstanding_req_per_channel =
+	((storvsc_ringbuffer_size - PAGE_SIZE) /
+	ALIGN(MAX_MULTIPAGE_BUFFER_PACKET +
+	sizeof(struct vstor_packet) + sizeof(u64),
+	sizeof(u64)));
 
 	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
 
 	/* Callback to client driver to complete the initialization */
 	storvsc_initialize(&storvsc_drv_obj->base);
 
-	if (storvsc_drv_obj->max_outstanding_req_per_channel <
+	if (max_outstanding_req_per_channel <
 	    STORVSC_MAX_IO_REQUESTS)
 		return -1;
 
-- 
1.7.4.1

