Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1EJItj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:49:39 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53093
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755996Ab1EJIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 160/206] Staging: hv: Add the contents of vmbus_api.h
Date: Mon,  9 May 2011 14:57:22 -0700
Message-Id: <1304978288-22999-160-git-send-email-kys@microsoft.com>
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
 include/linux/hyperv.h |   95 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index fc05036..3707fcb 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -32,6 +32,36 @@
 #include <linux/completion.h>
 #include <linux/scatterlist.h>
 
+#define MAX_PAGE_BUFFER_COUNT				16
+#define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
+
+#pragma pack(push, 1)
+
+/* Single-page buffer */
+struct hv_page_buffer {
+	u32 len;
+	u32 offset;
+	u64 pfn;
+};
+
+/* Multiple-page buffer */
+struct hv_multipage_buffer {
+	/* Length and Offset determines the # of pfns in the array */
+	u32 len;
+	u32 offset;
+	u64 pfn_array[MAX_MULTIPAGE_BUFFER_COUNT];
+};
+
+/* 0x18 includes the proprietary packet header */
+#define MAX_PAGE_BUFFER_PACKET		(0x18 +			\
+					(sizeof(struct hv_page_buffer) * \
+					 MAX_PAGE_BUFFER_COUNT))
+#define MAX_MULTIPAGE_BUFFER_PACKET	(0x18 +			\
+					 sizeof(struct hv_multipage_buffer))
+
+
+#pragma pack(pop)
+
 struct hv_ring_buffer {
 	/* Offset in bytes from the start of ring data below */
 	u32 write_index;
@@ -726,4 +756,69 @@ extern unsigned int vmbus_loglevel;
  */
 #define HV_DRV_VERSION           "3.1"
 
+
+#include <linux/device.h>
+#include <linux/workqueue.h>
+
+
+struct hv_driver;
+struct hv_device;
+
+struct hv_dev_port_info {
+	u32 int_mask;
+	u32 read_idx;
+	u32 write_idx;
+	u32 bytes_avail_toread;
+	u32 bytes_avail_towrite;
+};
+
+struct hv_device_info {
+	u32 chn_id;
+	u32 chn_state;
+	struct hv_guid chn_type;
+	struct hv_guid chn_instance;
+
+	u32 monitor_id;
+	u32 server_monitor_pending;
+	u32 server_monitor_latency;
+	u32 server_monitor_conn_id;
+	u32 client_monitor_pending;
+	u32 client_monitor_latency;
+	u32 client_monitor_conn_id;
+
+	struct hv_dev_port_info inbound;
+	struct hv_dev_port_info outbound;
+};
+
+/* Base driver object */
+struct hv_driver {
+	const char *name;
+
+	/* the device type supported by this driver */
+	struct hv_guid dev_type;
+
+	struct device_driver driver;
+
+	int (*probe)(struct hv_device *);
+	int (*remove)(struct hv_device *);
+	void (*shutdown)(struct hv_device *);
+
+};
+
+/* Base device object */
+struct hv_device {
+	/* the device type id of this device */
+	struct hv_guid dev_type;
+
+	/* the device instance id of this device */
+	struct hv_guid dev_instance;
+
+	struct device device;
+
+	struct vmbus_channel *channel;
+
+	/* Device extension; */
+	void *ext;
+};
+
 #endif /* _HYPERV_H_ */
-- 
1.7.4.1

