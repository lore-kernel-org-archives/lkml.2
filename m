Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2GNUUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:20:23 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:41503
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752370Ab2GNUTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:19:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 02/15] Drivers: hv: Add KVP definitions for IP address injection
Date: Sat, 14 Jul 2012 13:34:07 -0700
Message-Id: <1342298060-12662-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1342298060-12662-1-git-send-email-kys@microsoft.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary definitions for supporting the IP injection functionality.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_util.c     |    4 ++--
 include/linux/hyperv.h   |   30 ++++++++++++++++++++++++++++++
 tools/hv/hv_kvp_daemon.c |    2 +-
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index d3ac6a4..a0667de 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -263,7 +263,7 @@ static int util_probe(struct hv_device *dev,
 		(struct hv_util_service *)dev_id->driver_data;
 	int ret;
 
-	srv->recv_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	srv->recv_buffer = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
 	if (!srv->recv_buffer)
 		return -ENOMEM;
 	if (srv->util_init) {
@@ -274,7 +274,7 @@ static int util_probe(struct hv_device *dev,
 		}
 	}
 
-	ret = vmbus_open(dev->channel, 2 * PAGE_SIZE, 2 * PAGE_SIZE, NULL, 0,
+	ret = vmbus_open(dev->channel, 4 * PAGE_SIZE, 4 * PAGE_SIZE, NULL, 0,
 			srv->util_cb, dev->channel);
 	if (ret)
 		goto error;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 68ed7f7..38b561a 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -127,6 +127,8 @@ enum hv_kvp_exchg_op {
 	KVP_OP_SET,
 	KVP_OP_DELETE,
 	KVP_OP_ENUMERATE,
+	KVP_OP_GET_IP_INFO,
+	KVP_OP_SET_IP_INFO,
 	KVP_OP_REGISTER,
 	KVP_OP_COUNT /* Number of operations, must be last. */
 };
@@ -140,6 +142,26 @@ enum hv_kvp_exchg_pool {
 	KVP_POOL_COUNT /* Number of pools, must be last. */
 };
 
+#define ADDR_FAMILY_NONE	0x00
+#define ADDR_FAMILY_IPV4	0x01
+#define ADDR_FAMILY_IPV6	0x02
+
+#define MAX_ADAPTER_ID_SIZE	128
+#define MAX_IP_ADDR_SIZE	1024
+#define MAX_GATEWAY_SIZE	512
+
+
+struct hv_kvp_ipaddr_value {
+	__u16	adapter_id[MAX_ADAPTER_ID_SIZE];
+	__u8	addr_family;
+	__u8	dhcp_enabled;
+	__u16	ip_addr[MAX_IP_ADDR_SIZE];
+	__u16	sub_net[MAX_IP_ADDR_SIZE];
+	__u16	gate_way[MAX_GATEWAY_SIZE];
+	__u16	dns_addr[MAX_IP_ADDR_SIZE];
+} __attribute__((packed));
+
+
 struct hv_kvp_hdr {
 	__u8 operation;
 	__u8 pool;
@@ -187,10 +209,17 @@ struct hv_kvp_msg {
 		struct hv_kvp_msg_set		kvp_set;
 		struct hv_kvp_msg_delete	kvp_delete;
 		struct hv_kvp_msg_enumerate	kvp_enum_data;
+		struct hv_kvp_ipaddr_value      kvp_ip_val;
 		struct hv_kvp_register		kvp_register;
 	} body;
 } __attribute__((packed));
 
+struct hv_kvp_ip_msg {
+	__u8 operation;
+	__u8 pool;
+	struct hv_kvp_ipaddr_value      kvp_ip_val;
+} __attribute__((packed));
+
 #ifdef __KERNEL__
 #include <linux/scatterlist.h>
 #include <linux/list.h>
@@ -982,6 +1011,7 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver);
 #define HV_S_CONT			0x80070103
 #define HV_ERROR_NOT_SUPPORTED		0x80070032
 #define HV_ERROR_MACHINE_LOCKED		0x800704F7
+#define HV_ERROR_DEVICE_NOT_CONNECTED	0x8007048F
 
 /*
  * While we want to handle util services as regular devices,
diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index d9834b3..8fbcf7b 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -69,7 +69,7 @@ enum key_index {
 };
 
 static char kvp_send_buffer[4096];
-static char kvp_recv_buffer[4096];
+static char kvp_recv_buffer[4096 * 2];
 static struct sockaddr_nl addr;
 
 static char *os_name = "";
-- 
1.7.4.1

