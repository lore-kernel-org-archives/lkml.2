Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1EJIc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:32:59 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42736
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756117Ab1EJIay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 175/206] Staging: hv: Include the contents of netvsc_api.h
Date: Mon,  9 May 2011 14:57:37 -0700
Message-Id: <1304978288-22999-175-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv_net.h |  107 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index ce27244..2a00730 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -21,3 +21,110 @@
  *   K. Y. Srinivasan <kys@microsoft.com>
  *
  */
+
+#ifndef _HYPERV_NET_H
+#define _HYPERV_NET_H
+
+#include <linux/list.h>
+
+
+/* Fwd declaration */
+struct hv_netvsc_packet;
+
+/* Represent the xfer page packet which contains 1 or more netvsc packet */
+struct xferpage_packet {
+	struct list_head list_ent;
+
+	/* # of netvsc packets this xfer packet contains */
+	u32 count;
+};
+
+/* The number of pages which are enough to cover jumbo frame buffer. */
+#define NETVSC_PACKET_MAXPAGE		4
+
+/*
+ * Represent netvsc packet which contains 1 RNDIS and 1 ethernet frame
+ * within the RNDIS
+ */
+struct hv_netvsc_packet {
+	/* Bookkeeping stuff */
+	struct list_head list_ent;
+
+	struct hv_device *device;
+	bool is_data_pkt;
+
+	/*
+	 * Valid only for receives when we break a xfer page packet
+	 * into multiple netvsc packets
+	 */
+	struct xferpage_packet *xfer_page_pkt;
+
+	union {
+		struct {
+			u64 recv_completion_tid;
+			void *recv_completion_ctx;
+			void (*recv_completion)(void *context);
+		} recv;
+		struct {
+			u64 send_completion_tid;
+			void *send_completion_ctx;
+			void (*send_completion)(void *context);
+		} send;
+	} completion;
+
+	/* This points to the memory after page_buf */
+	void *extension;
+
+	u32 total_data_buflen;
+	/* Points to the send/receive buffer where the ethernet frame is */
+	u32 page_buf_cnt;
+	struct hv_page_buffer page_buf[NETVSC_PACKET_MAXPAGE];
+};
+
+/* Represents the net vsc driver */
+struct netvsc_driver {
+	/* Must be the first field */
+	/* Which is a bug FIXME! */
+	struct hv_driver base;
+
+	u32 ring_buf_size;
+	u32 req_ext_size;
+
+	/*
+	 * This is set by the caller to allow us to callback when we
+	 * receive a packet from the "wire"
+	 */
+	int (*recv_cb)(struct hv_device *dev,
+				 struct hv_netvsc_packet *packet);
+	void (*link_status_change)(struct hv_device *dev, u32 status);
+
+	/* Specific to this driver */
+	int (*send)(struct hv_device *dev, struct hv_netvsc_packet *packet);
+
+	void *ctx;
+};
+
+static inline
+struct netvsc_driver *drv_to_netvscdrv(struct device_driver *d)
+{
+	struct hv_driver *hvdrv = drv_to_hv_drv(d);
+	return container_of(hvdrv, struct netvsc_driver, base);
+}
+
+struct netvsc_device_info {
+	unsigned char mac_adr[6];
+	bool link_state;	/* 0 - link up, 1 - link down */
+};
+
+/* Interface */
+int netvsc_device_add(struct hv_device *device, void *additional_info);
+int netvsc_device_remove(struct hv_device *device);
+int netvsc_initialize(struct hv_driver *drv);
+int rndis_filter_open(struct hv_device *dev);
+int rndis_filter_close(struct hv_device *dev);
+int rndis_filte_device_add(struct hv_device *dev,
+			void *additional_info);
+int rndis_filter_device_remove(struct hv_device *dev);
+
+
+#endif /* _HYPERV_NET_H */
-- 
1.7.4.1

