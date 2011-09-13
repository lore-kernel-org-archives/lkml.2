Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1IMRjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:39:08 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:58758
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755861Ab1IMRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:38:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 16/20] Staging: hv: vmbus: Do not allocate struct hv_device_info on the stack
Date: Tue, 13 Sep 2011 10:59:52 -0700
Message-Id: <1315936796-20662-16-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315936796-20662-1-git-send-email-kys@microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct hv_device_info is about 101 bytes in size. Do not allocate this structure
on the stack.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |  134 ++++++++++++++++++++-------------------
 1 files changed, 69 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 466425a..d2562af 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -112,101 +112,105 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 				      char *buf)
 {
 	struct hv_device *hv_dev = device_to_hv_device(dev);
-	struct hv_device_info device_info;
+	struct hv_device_info *device_info;
 	char alias_name[VMBUS_ALIAS_LEN + 1];
+	int ret = 0;
 
-	memset(&device_info, 0, sizeof(struct hv_device_info));
+	device_info = kzalloc(sizeof(struct hv_device_info), GFP_KERNEL);
+	if (!device_info)
+		return ret;
 
-	get_channel_info(hv_dev, &device_info);
+	get_channel_info(hv_dev, device_info);
 
 	if (!strcmp(dev_attr->attr.name, "class_id")) {
-		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-			       device_info.chn_type.b[3],
-			       device_info.chn_type.b[2],
-			       device_info.chn_type.b[1],
-			       device_info.chn_type.b[0],
-			       device_info.chn_type.b[5],
-			       device_info.chn_type.b[4],
-			       device_info.chn_type.b[7],
-			       device_info.chn_type.b[6],
-			       device_info.chn_type.b[8],
-			       device_info.chn_type.b[9],
-			       device_info.chn_type.b[10],
-			       device_info.chn_type.b[11],
-			       device_info.chn_type.b[12],
-			       device_info.chn_type.b[13],
-			       device_info.chn_type.b[14],
-			       device_info.chn_type.b[15]);
+			       device_info->chn_type.b[3],
+			       device_info->chn_type.b[2],
+			       device_info->chn_type.b[1],
+			       device_info->chn_type.b[0],
+			       device_info->chn_type.b[5],
+			       device_info->chn_type.b[4],
+			       device_info->chn_type.b[7],
+			       device_info->chn_type.b[6],
+			       device_info->chn_type.b[8],
+			       device_info->chn_type.b[9],
+			       device_info->chn_type.b[10],
+			       device_info->chn_type.b[11],
+			       device_info->chn_type.b[12],
+			       device_info->chn_type.b[13],
+			       device_info->chn_type.b[14],
+			       device_info->chn_type.b[15]);
 	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
-		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-			       device_info.chn_instance.b[3],
-			       device_info.chn_instance.b[2],
-			       device_info.chn_instance.b[1],
-			       device_info.chn_instance.b[0],
-			       device_info.chn_instance.b[5],
-			       device_info.chn_instance.b[4],
-			       device_info.chn_instance.b[7],
-			       device_info.chn_instance.b[6],
-			       device_info.chn_instance.b[8],
-			       device_info.chn_instance.b[9],
-			       device_info.chn_instance.b[10],
-			       device_info.chn_instance.b[11],
-			       device_info.chn_instance.b[12],
-			       device_info.chn_instance.b[13],
-			       device_info.chn_instance.b[14],
-			       device_info.chn_instance.b[15]);
+			       device_info->chn_instance.b[3],
+			       device_info->chn_instance.b[2],
+			       device_info->chn_instance.b[1],
+			       device_info->chn_instance.b[0],
+			       device_info->chn_instance.b[5],
+			       device_info->chn_instance.b[4],
+			       device_info->chn_instance.b[7],
+			       device_info->chn_instance.b[6],
+			       device_info->chn_instance.b[8],
+			       device_info->chn_instance.b[9],
+			       device_info->chn_instance.b[10],
+			       device_info->chn_instance.b[11],
+			       device_info->chn_instance.b[12],
+			       device_info->chn_instance.b[13],
+			       device_info->chn_instance.b[14],
+			       device_info->chn_instance.b[15]);
 	} else if (!strcmp(dev_attr->attr.name, "modalias")) {
 		print_alias_name(hv_dev, alias_name);
-		return sprintf(buf, "vmbus:%s\n", alias_name);
+		ret = sprintf(buf, "vmbus:%s\n", alias_name);
 	} else if (!strcmp(dev_attr->attr.name, "state")) {
-		return sprintf(buf, "%d\n", device_info.chn_state);
+		ret = sprintf(buf, "%d\n", device_info->chn_state);
 	} else if (!strcmp(dev_attr->attr.name, "id")) {
-		return sprintf(buf, "%d\n", device_info.chn_id);
+		ret = sprintf(buf, "%d\n", device_info->chn_id);
 	} else if (!strcmp(dev_attr->attr.name, "out_intr_mask")) {
-		return sprintf(buf, "%d\n", device_info.outbound.int_mask);
+		ret = sprintf(buf, "%d\n", device_info->outbound.int_mask);
 	} else if (!strcmp(dev_attr->attr.name, "out_read_index")) {
-		return sprintf(buf, "%d\n", device_info.outbound.read_idx);
+		ret = sprintf(buf, "%d\n", device_info->outbound.read_idx);
 	} else if (!strcmp(dev_attr->attr.name, "out_write_index")) {
-		return sprintf(buf, "%d\n", device_info.outbound.write_idx);
+		ret = sprintf(buf, "%d\n", device_info->outbound.write_idx);
 	} else if (!strcmp(dev_attr->attr.name, "out_read_bytes_avail")) {
-		return sprintf(buf, "%d\n",
-			       device_info.outbound.bytes_avail_toread);
+		ret = sprintf(buf, "%d\n",
+			       device_info->outbound.bytes_avail_toread);
 	} else if (!strcmp(dev_attr->attr.name, "out_write_bytes_avail")) {
-		return sprintf(buf, "%d\n",
-			       device_info.outbound.bytes_avail_towrite);
+		ret = sprintf(buf, "%d\n",
+			       device_info->outbound.bytes_avail_towrite);
 	} else if (!strcmp(dev_attr->attr.name, "in_intr_mask")) {
-		return sprintf(buf, "%d\n", device_info.inbound.int_mask);
+		ret = sprintf(buf, "%d\n", device_info->inbound.int_mask);
 	} else if (!strcmp(dev_attr->attr.name, "in_read_index")) {
-		return sprintf(buf, "%d\n", device_info.inbound.read_idx);
+		ret = sprintf(buf, "%d\n", device_info->inbound.read_idx);
 	} else if (!strcmp(dev_attr->attr.name, "in_write_index")) {
-		return sprintf(buf, "%d\n", device_info.inbound.write_idx);
+		ret = sprintf(buf, "%d\n", device_info->inbound.write_idx);
 	} else if (!strcmp(dev_attr->attr.name, "in_read_bytes_avail")) {
-		return sprintf(buf, "%d\n",
-			       device_info.inbound.bytes_avail_toread);
+		ret = sprintf(buf, "%d\n",
+			       device_info->inbound.bytes_avail_toread);
 	} else if (!strcmp(dev_attr->attr.name, "in_write_bytes_avail")) {
-		return sprintf(buf, "%d\n",
-			       device_info.inbound.bytes_avail_towrite);
+		ret = sprintf(buf, "%d\n",
+			       device_info->inbound.bytes_avail_towrite);
 	} else if (!strcmp(dev_attr->attr.name, "monitor_id")) {
-		return sprintf(buf, "%d\n", device_info.monitor_id);
+		ret = sprintf(buf, "%d\n", device_info->monitor_id);
 	} else if (!strcmp(dev_attr->attr.name, "server_monitor_pending")) {
-		return sprintf(buf, "%d\n", device_info.server_monitor_pending);
+		ret = sprintf(buf, "%d\n", device_info->server_monitor_pending);
 	} else if (!strcmp(dev_attr->attr.name, "server_monitor_latency")) {
-		return sprintf(buf, "%d\n", device_info.server_monitor_latency);
+		ret = sprintf(buf, "%d\n", device_info->server_monitor_latency);
 	} else if (!strcmp(dev_attr->attr.name, "server_monitor_conn_id")) {
-		return sprintf(buf, "%d\n",
-			       device_info.server_monitor_conn_id);
+		ret = sprintf(buf, "%d\n",
+			       device_info->server_monitor_conn_id);
 	} else if (!strcmp(dev_attr->attr.name, "client_monitor_pending")) {
-		return sprintf(buf, "%d\n", device_info.client_monitor_pending);
+		ret = sprintf(buf, "%d\n", device_info->client_monitor_pending);
 	} else if (!strcmp(dev_attr->attr.name, "client_monitor_latency")) {
-		return sprintf(buf, "%d\n", device_info.client_monitor_latency);
+		ret = sprintf(buf, "%d\n", device_info->client_monitor_latency);
 	} else if (!strcmp(dev_attr->attr.name, "client_monitor_conn_id")) {
-		return sprintf(buf, "%d\n",
-			       device_info.client_monitor_conn_id);
-	} else {
-		return 0;
+		ret = sprintf(buf, "%d\n",
+			       device_info->client_monitor_conn_id);
 	}
+
+	kfree(device_info);
+	return ret;
 }
 
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
-- 
1.7.4.1

