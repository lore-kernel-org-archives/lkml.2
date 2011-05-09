Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1EJJy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:54:56 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42644
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752777Ab1EJJyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:54:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 192/206] Staging: hv: Get rid of netvsc_api.h
Date: Mon,  9 May 2011 14:57:54 -0700
Message-Id: <1304978288-22999-192-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of netvsc_api.h

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc_api.h |  130 ---------------------------------------
 1 files changed, 0 insertions(+), 130 deletions(-)
 delete mode 100644 drivers/staging/hv/netvsc_api.h

diff --git a/drivers/staging/hv/netvsc_api.h b/drivers/staging/hv/netvsc_api.h
deleted file mode 100644
index b385c9d..0000000
--- a/drivers/staging/hv/netvsc_api.h
+++ /dev/null
@@ -1,130 +0,0 @@
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
-#ifndef _NETVSC_API_H_
-#define _NETVSC_API_H_
-
-#include "vmbus_api.h"
-#include "vmbus.h"
-
-/* Fwd declaration */
-struct hv_netvsc_packet;
-
-/* Represent the xfer page packet which contains 1 or more netvsc packet */
-struct xferpage_packet {
-	struct list_head list_ent;
-
-	/* # of netvsc packets this xfer packet contains */
-	u32 count;
-};
-
-/* The number of pages which are enough to cover jumbo frame buffer. */
-#define NETVSC_PACKET_MAXPAGE		4
-
-/*
- * Represent netvsc packet which contains 1 RNDIS and 1 ethernet frame
- * within the RNDIS
- */
-struct hv_netvsc_packet {
-	/* Bookkeeping stuff */
-	struct list_head list_ent;
-
-	struct hv_device *device;
-	bool is_data_pkt;
-
-	/*
-	 * Valid only for receives when we break a xfer page packet
-	 * into multiple netvsc packets
-	 */
-	struct xferpage_packet *xfer_page_pkt;
-
-	union {
-		struct{
-			u64 recv_completion_tid;
-			void *recv_completion_ctx;
-			void (*recv_completion)(void *context);
-		} recv;
-		struct{
-			u64 send_completion_tid;
-			void *send_completion_ctx;
-			void (*send_completion)(void *context);
-		} send;
-	} completion;
-
-	/* This points to the memory after page_buf */
-	void *extension;
-
-	u32 total_data_buflen;
-	/* Points to the send/receive buffer where the ethernet frame is */
-	u32 page_buf_cnt;
-	struct hv_page_buffer page_buf[NETVSC_PACKET_MAXPAGE];
-};
-
-/* Represents the net vsc driver */
-struct netvsc_driver {
-	/* Must be the first field */
-	/* Which is a bug FIXME! */
-	struct hv_driver base;
-
-	u32 ring_buf_size;
-	u32 req_ext_size;
-
-	/*
-	 * This is set by the caller to allow us to callback when we
-	 * receive a packet from the "wire"
-	 */
-	int (*recv_cb)(struct hv_device *dev,
-				 struct hv_netvsc_packet *packet);
-	void (*link_status_change)(struct hv_device *dev, u32 status);
-
-	/* Specific to this driver */
-	int (*send)(struct hv_device *dev, struct hv_netvsc_packet *packet);
-
-	void *ctx;
-};
-
-static inline
-struct netvsc_driver *drv_to_netvscdrv(struct device_driver *d)
-{
-	struct hv_driver *hvdrv = drv_to_hv_drv(d);
-	return container_of(hvdrv, struct netvsc_driver, base);
-}
-
-struct netvsc_device_info {
-	unsigned char mac_adr[6];
-	bool link_state;	/* 0 - link up, 1 - link down */
-};
-
-/* Interface */
-int netvsc_device_add(struct hv_device *device, void *additional_info);
-int netvsc_device_remove(struct hv_device *device);
-int netvsc_initialize(struct hv_driver *drv);
-int rndis_filter_open(struct hv_device *dev);
-int rndis_filter_close(struct hv_device *dev);
-int rndis_filte_device_add(struct hv_device *dev,
-			void *additional_info);
-int rndis_filter_device_remove(struct hv_device *dev);
-
-
-#endif /* _NETVSC_API_H_ */
-- 
1.7.4.1

