Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1CWRmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:42:38 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:51793
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756113Ab1CWRkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:40:39 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 11/16] Staging: hv: Get rid of the file blkvsc.c
Date: Wed, 23 Mar 2011 10:50:29 -0700
Message-Id: <1300902635-1347-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300902635-1347-1-git-send-email-kys@microsoft.com>
References: <1300902537-1290-1-git-send-email-kys@microsoft.com>
 <1300902635-1347-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now delete the file.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc.c |  103 -------------------------------------------
 1 files changed, 0 insertions(+), 103 deletions(-)
 delete mode 100644 drivers/staging/hv/blkvsc.c

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
deleted file mode 100644
index ebe511a..0000000
--- a/drivers/staging/hv/blkvsc.c
+++ /dev/null
@@ -1,103 +0,0 @@
-/*
- *
- * Copyright (c) 2009, Microsoft Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
- *
- * Authors:
- *   Haiyang Zhang <haiyangz@microsoft.com>
- *   Hank Janssen  <hjanssen@microsoft.com>
- *
- */
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include "logging.h"
-#include "hv_api.h"
-#include "storvsc_api.h"
-
-static const char *g_blk_driver_name = "blkvsc";
-
-/* {32412632-86cb-44a2-9b5c-50d1417354f5} */
-static const struct hv_guid g_blk_device_type = {
-	.data = {
-		0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
-		0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
-	}
-};
-
-static int blk_vsc_on_device_add(struct hv_device *device, void *additional_info)
-{
-	struct storvsc_device_info *device_info;
-	int ret = 0;
-
-	device_info = (struct storvsc_device_info *)additional_info;
-
-	ret = stor_vsc_on_device_add(device, additional_info);
-	if (ret != 0)
-		return ret;
-
-	/*
-	 * We need to use the device instance guid to set the path and target
-	 * id. For IDE devices, the device instance id is formatted as
-	 * <bus id> * - <device id> - 8899 - 000000000000.
-	 */
-	device_info->path_id = device->dev_instance.data[3] << 24 |
-			     device->dev_instance.data[2] << 16 |
-			     device->dev_instance.data[1] << 8  |
-			     device->dev_instance.data[0];
-
-	device_info->target_id = device->dev_instance.data[5] << 8 |
-			       device->dev_instance.data[4];
-
-	return ret;
-}
-
-int blk_vsc_initialize(struct hv_driver *driver)
-{
-	struct storvsc_driver_object *stor_driver;
-	int ret = 0;
-
-	stor_driver = (struct storvsc_driver_object *)driver;
-
-	/* Make sure we are at least 2 pages since 1 page is used for control */
-	/* ASSERT(stor_driver->RingBufferSize >= (PAGE_SIZE << 1)); */
-
-	driver->name = g_blk_driver_name;
-	memcpy(&driver->dev_type, &g_blk_device_type, sizeof(struct hv_guid));
-
-	stor_driver->request_ext_size = sizeof(struct storvsc_request_extension);
-
-	/*
-	 * Divide the ring buffer data size (which is 1 page less than the ring
-	 * buffer size since that page is reserved for the ring buffer indices)
-	 * by the max request size (which is
-	 * vmbus_channel_packet_multipage_buffer + struct vstor_packet + u64)
-	 */
-	stor_driver->max_outstanding_req_per_channel =
-		((stor_driver->ring_buffer_size - PAGE_SIZE) /
-		  ALIGN(MAX_MULTIPAGE_BUFFER_PACKET +
-			   sizeof(struct vstor_packet) + sizeof(u64),
-			   sizeof(u64)));
-
-	DPRINT_INFO(BLKVSC, "max io outstd %u",
-		    stor_driver->max_outstanding_req_per_channel);
-
-	/* Setup the dispatch table */
-	stor_driver->base.dev_add = blk_vsc_on_device_add;
-	stor_driver->base.dev_rm = stor_vsc_on_device_remove;
-	stor_driver->base.cleanup = stor_vsc_on_cleanup;
-	stor_driver->on_io_request = stor_vsc_on_io_request;
-
-	return ret;
-}
-- 
1.7.4.1

