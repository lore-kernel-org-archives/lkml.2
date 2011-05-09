Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab1EJIli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:41:38 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35478
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756079Ab1EJIaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 197/206] Staging: hv: Get rid of storvsc_api.h
Date: Mon,  9 May 2011 14:57:59 -0700
Message-Id: <1304978288-22999-197-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of storvsc_api.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_api.h |  162 --------------------------------------
 1 files changed, 0 insertions(+), 162 deletions(-)
 delete mode 100644 drivers/staging/hv/storvsc_api.h

diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
deleted file mode 100644
index b163515..0000000
--- a/drivers/staging/hv/storvsc_api.h
+++ /dev/null
@@ -1,162 +0,0 @@
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
-
-
-#ifndef _STORVSC_API_H_
-#define _STORVSC_API_H_
-
-#include <linux/kernel.h>
-#include <linux/wait.h>
-#include "vstorage.h"
-#include "vmbus_api.h"
-#include "vmbus.h"
-
-/* Defines */
-#define STORVSC_RING_BUFFER_SIZE			(20*PAGE_SIZE)
-#define BLKVSC_RING_BUFFER_SIZE				(20*PAGE_SIZE)
-
-#define STORVSC_MAX_IO_REQUESTS				128
-
-/*
- * In Hyper-V, each port/path/target maps to 1 scsi host adapter.  In
- * reality, the path/target is not used (ie always set to 0) so our
- * scsi host adapter essentially has 1 bus with 1 target that contains
- * up to 256 luns.
- */
-#define STORVSC_MAX_LUNS_PER_TARGET			64
-#define STORVSC_MAX_TARGETS				1
-#define STORVSC_MAX_CHANNELS				1
-
-struct hv_storvsc_request;
-
-/* Matches Windows-end */
-enum storvsc_request_type{
-	WRITE_TYPE,
-	READ_TYPE,
-	UNKNOWN_TYPE,
-};
-
-
-struct hv_storvsc_request {
-	struct hv_storvsc_request *request;
-	struct hv_device *device;
-
-	/* Synchronize the request/response if needed */
-	struct completion wait_event;
-
-	unsigned char *sense_buffer;
-	void *context;
-	void (*on_io_completion)(struct hv_storvsc_request *request);
-	struct hv_multipage_buffer data_buffer;
-
-	struct vstor_packet vstor_packet;
-};
-
-
-struct storvsc_device_info {
-	u32 ring_buffer_size;
-	unsigned int port_number;
-	unsigned char path_id;
-	unsigned char target_id;
-};
-
-struct storvsc_major_info {
-	int major;
-	int index;
-	bool do_register;
-	char *devname;
-	char *diskname;
-};
-
-/* A storvsc device is a device object that contains a vmbus channel */
-struct storvsc_device {
-	struct hv_device *device;
-
-	/* 0 indicates the device is being destroyed */
-	atomic_t ref_count;
-
-	bool	 drain_notify;
-	atomic_t num_outstanding_req;
-
-	wait_queue_head_t waiting_to_drain;
-
-	/*
-	 * Each unique Port/Path/Target represents 1 channel ie scsi
-	 * controller. In reality, the pathid, targetid is always 0
-	 * and the port is set by us
-	 */
-	unsigned int port_number;
-	unsigned char path_id;
-	unsigned char target_id;
-
-	/* Used for vsc/vsp channel reset process */
-	struct hv_storvsc_request init_request;
-	struct hv_storvsc_request reset_request;
-};
-
-
-/* Get the stordevice object iff exists and its refcount > 1 */
-static inline struct storvsc_device *get_stor_device(struct hv_device *device)
-{
-	struct storvsc_device *stor_device;
-
-	stor_device = (struct storvsc_device *)device->ext;
-	if (stor_device && atomic_read(&stor_device->ref_count) > 1)
-		atomic_inc(&stor_device->ref_count);
-	else
-		stor_device = NULL;
-
-	return stor_device;
-}
-
-
-static inline void put_stor_device(struct hv_device *device)
-{
-	struct storvsc_device *stor_device;
-
-	stor_device = (struct storvsc_device *)device->ext;
-
-	atomic_dec(&stor_device->ref_count);
-}
-
-static inline void storvsc_wait_to_drain(struct storvsc_device *dev)
-{
-	dev->drain_notify = true;
-	wait_event(dev->waiting_to_drain,
-		   atomic_read(&dev->num_outstanding_req) == 0);
-	dev->drain_notify = false;
-}
-
-/* Interface */
-
-int storvsc_dev_add(struct hv_device *device,
-				void *additional_info);
-int storvsc_dev_remove(struct hv_device *device);
-
-int storvsc_do_io(struct hv_device *device,
-				struct hv_storvsc_request *request);
-
-int storvsc_get_major_info(struct storvsc_device_info *device_info,
-				struct storvsc_major_info *major_info);
-
-#endif /* _STORVSC_API_H_ */
-- 
1.7.4.1

