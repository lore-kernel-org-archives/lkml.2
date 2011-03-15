Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab1COVyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:54:31 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:51050
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758794Ab1COVxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:53:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 12/12] Staging: hv: Get rid of the forward declaration for vmbus_show_device_attr
Date: Tue, 15 Mar 2011 15:03:44 -0700
Message-Id: <1300226624-27004-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1300226624-27004-12-git-send-email-kys@microsoft.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-2-git-send-email-kys@microsoft.com>
 <1300226624-27004-3-git-send-email-kys@microsoft.com>
 <1300226624-27004-4-git-send-email-kys@microsoft.com>
 <1300226624-27004-5-git-send-email-kys@microsoft.com>
 <1300226624-27004-6-git-send-email-kys@microsoft.com>
 <1300226624-27004-7-git-send-email-kys@microsoft.com>
 <1300226624-27004-8-git-send-email-kys@microsoft.com>
 <1300226624-27004-9-git-send-email-kys@microsoft.com>
 <1300226624-27004-10-git-send-email-kys@microsoft.com>
 <1300226624-27004-11-git-send-email-kys@microsoft.com>
 <1300226624-27004-12-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of vmbus_show_device_attr by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |  302 +++++++++++++++++++--------------------
 1 files changed, 147 insertions(+), 155 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 194926c..3263fc8 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -47,18 +47,160 @@ struct hv_bus {
 	struct tasklet_struct event_dpc;
 };
 
+unsigned int vmbus_loglevel = (ALL_MODULES << 16 | INFO_LVL);
+EXPORT_SYMBOL(vmbus_loglevel);
+	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
+	/* (((VMBUS | VMBUS_DRV)<<16) | DEBUG_LVL_ENTEREXIT); */
+
+
+static void get_channel_info(struct hv_device *device,
+			     struct hv_device_info *info)
+{
+	struct vmbus_channel_debug_info debug_info;
+
+	if (!device->channel)
+		return;
+
+	vmbus_get_debug_info(device->channel, &debug_info);
+
+	info->chn_id = debug_info.relid;
+	info->chn_state = debug_info.state;
+	memcpy(&info->chn_type, &debug_info.interfacetype,
+	       sizeof(struct hv_guid));
+	memcpy(&info->chn_instance, &debug_info.interface_instance,
+	       sizeof(struct hv_guid));
+
+	info->monitor_id = debug_info.monitorid;
+
+	info->server_monitor_pending = debug_info.servermonitor_pending;
+	info->server_monitor_latency = debug_info.servermonitor_latency;
+	info->server_monitor_conn_id = debug_info.servermonitor_connectionid;
+
+	info->client_monitor_pending = debug_info.clientmonitor_pending;
+	info->client_monitor_latency = debug_info.clientmonitor_latency;
+	info->client_monitor_conn_id = debug_info.clientmonitor_connectionid;
+
+	info->inbound.int_mask = debug_info.inbound.current_interrupt_mask;
+	info->inbound.read_idx = debug_info.inbound.current_read_index;
+	info->inbound.write_idx = debug_info.inbound.current_write_index;
+	info->inbound.bytes_avail_toread =
+		debug_info.inbound.bytes_avail_toread;
+	info->inbound.bytes_avail_towrite =
+		debug_info.inbound.bytes_avail_towrite;
 
+	info->outbound.int_mask =
+		debug_info.outbound.current_interrupt_mask;
+	info->outbound.read_idx = debug_info.outbound.current_read_index;
+	info->outbound.write_idx = debug_info.outbound.current_write_index;
+	info->outbound.bytes_avail_toread =
+		debug_info.outbound.bytes_avail_toread;
+	info->outbound.bytes_avail_towrite =
+		debug_info.outbound.bytes_avail_towrite;
+}
 
+/*
+ * vmbus_show_device_attr - Show the device attribute in sysfs.
+ *
+ * This is invoked when user does a
+ * "cat /sys/bus/vmbus/devices/<busdevice>/<attr name>"
+ */
 static ssize_t vmbus_show_device_attr(struct device *dev,
 				      struct device_attribute *dev_attr,
-				      char *buf);
+				      char *buf)
+{
+	struct hv_device *device_ctx = device_to_hv_device(dev);
+	struct hv_device_info device_info;
 
+	memset(&device_info, 0, sizeof(struct hv_device_info));
 
-unsigned int vmbus_loglevel = (ALL_MODULES << 16 | INFO_LVL);
-EXPORT_SYMBOL(vmbus_loglevel);
-	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
-	/* (((VMBUS | VMBUS_DRV)<<16) | DEBUG_LVL_ENTEREXIT); */
+	get_channel_info(device_ctx, &device_info);
 
+	if (!strcmp(dev_attr->attr.name, "class_id")) {
+		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
+			       device_info.chn_type.data[3],
+			       device_info.chn_type.data[2],
+			       device_info.chn_type.data[1],
+			       device_info.chn_type.data[0],
+			       device_info.chn_type.data[5],
+			       device_info.chn_type.data[4],
+			       device_info.chn_type.data[7],
+			       device_info.chn_type.data[6],
+			       device_info.chn_type.data[8],
+			       device_info.chn_type.data[9],
+			       device_info.chn_type.data[10],
+			       device_info.chn_type.data[11],
+			       device_info.chn_type.data[12],
+			       device_info.chn_type.data[13],
+			       device_info.chn_type.data[14],
+			       device_info.chn_type.data[15]);
+	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
+		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
+			       device_info.chn_instance.data[3],
+			       device_info.chn_instance.data[2],
+			       device_info.chn_instance.data[1],
+			       device_info.chn_instance.data[0],
+			       device_info.chn_instance.data[5],
+			       device_info.chn_instance.data[4],
+			       device_info.chn_instance.data[7],
+			       device_info.chn_instance.data[6],
+			       device_info.chn_instance.data[8],
+			       device_info.chn_instance.data[9],
+			       device_info.chn_instance.data[10],
+			       device_info.chn_instance.data[11],
+			       device_info.chn_instance.data[12],
+			       device_info.chn_instance.data[13],
+			       device_info.chn_instance.data[14],
+			       device_info.chn_instance.data[15]);
+	} else if (!strcmp(dev_attr->attr.name, "state")) {
+		return sprintf(buf, "%d\n", device_info.chn_state);
+	} else if (!strcmp(dev_attr->attr.name, "id")) {
+		return sprintf(buf, "%d\n", device_info.chn_id);
+	} else if (!strcmp(dev_attr->attr.name, "out_intr_mask")) {
+		return sprintf(buf, "%d\n", device_info.outbound.int_mask);
+	} else if (!strcmp(dev_attr->attr.name, "out_read_index")) {
+		return sprintf(buf, "%d\n", device_info.outbound.read_idx);
+	} else if (!strcmp(dev_attr->attr.name, "out_write_index")) {
+		return sprintf(buf, "%d\n", device_info.outbound.write_idx);
+	} else if (!strcmp(dev_attr->attr.name, "out_read_bytes_avail")) {
+		return sprintf(buf, "%d\n",
+			       device_info.outbound.bytes_avail_toread);
+	} else if (!strcmp(dev_attr->attr.name, "out_write_bytes_avail")) {
+		return sprintf(buf, "%d\n",
+			       device_info.outbound.bytes_avail_towrite);
+	} else if (!strcmp(dev_attr->attr.name, "in_intr_mask")) {
+		return sprintf(buf, "%d\n", device_info.inbound.int_mask);
+	} else if (!strcmp(dev_attr->attr.name, "in_read_index")) {
+		return sprintf(buf, "%d\n", device_info.inbound.read_idx);
+	} else if (!strcmp(dev_attr->attr.name, "in_write_index")) {
+		return sprintf(buf, "%d\n", device_info.inbound.write_idx);
+	} else if (!strcmp(dev_attr->attr.name, "in_read_bytes_avail")) {
+		return sprintf(buf, "%d\n",
+			       device_info.inbound.bytes_avail_toread);
+	} else if (!strcmp(dev_attr->attr.name, "in_write_bytes_avail")) {
+		return sprintf(buf, "%d\n",
+			       device_info.inbound.bytes_avail_towrite);
+	} else if (!strcmp(dev_attr->attr.name, "monitor_id")) {
+		return sprintf(buf, "%d\n", device_info.monitor_id);
+	} else if (!strcmp(dev_attr->attr.name, "server_monitor_pending")) {
+		return sprintf(buf, "%d\n", device_info.server_monitor_pending);
+	} else if (!strcmp(dev_attr->attr.name, "server_monitor_latency")) {
+		return sprintf(buf, "%d\n", device_info.server_monitor_latency);
+	} else if (!strcmp(dev_attr->attr.name, "server_monitor_conn_id")) {
+		return sprintf(buf, "%d\n",
+			       device_info.server_monitor_conn_id);
+	} else if (!strcmp(dev_attr->attr.name, "client_monitor_pending")) {
+		return sprintf(buf, "%d\n", device_info.client_monitor_pending);
+	} else if (!strcmp(dev_attr->attr.name, "client_monitor_latency")) {
+		return sprintf(buf, "%d\n", device_info.client_monitor_latency);
+	} else if (!strcmp(dev_attr->attr.name, "client_monitor_conn_id")) {
+		return sprintf(buf, "%d\n",
+			       device_info.client_monitor_conn_id);
+	} else {
+		return 0;
+	}
+}
 
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
 static struct device_attribute vmbus_device_attrs[] = {
@@ -438,156 +580,6 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	}
 }
 
-
-static void get_channel_info(struct hv_device *device,
-			     struct hv_device_info *info)
-{
-	struct vmbus_channel_debug_info debug_info;
-
-	if (!device->channel)
-		return;
-
-	vmbus_get_debug_info(device->channel, &debug_info);
-
-	info->chn_id = debug_info.relid;
-	info->chn_state = debug_info.state;
-	memcpy(&info->chn_type, &debug_info.interfacetype,
-	       sizeof(struct hv_guid));
-	memcpy(&info->chn_instance, &debug_info.interface_instance,
-	       sizeof(struct hv_guid));
-
-	info->monitor_id = debug_info.monitorid;
-
-	info->server_monitor_pending = debug_info.servermonitor_pending;
-	info->server_monitor_latency = debug_info.servermonitor_latency;
-	info->server_monitor_conn_id = debug_info.servermonitor_connectionid;
-
-	info->client_monitor_pending = debug_info.clientmonitor_pending;
-	info->client_monitor_latency = debug_info.clientmonitor_latency;
-	info->client_monitor_conn_id = debug_info.clientmonitor_connectionid;
-
-	info->inbound.int_mask = debug_info.inbound.current_interrupt_mask;
-	info->inbound.read_idx = debug_info.inbound.current_read_index;
-	info->inbound.write_idx = debug_info.inbound.current_write_index;
-	info->inbound.bytes_avail_toread =
-		debug_info.inbound.bytes_avail_toread;
-	info->inbound.bytes_avail_towrite =
-		debug_info.inbound.bytes_avail_towrite;
-
-	info->outbound.int_mask =
-		debug_info.outbound.current_interrupt_mask;
-	info->outbound.read_idx = debug_info.outbound.current_read_index;
-	info->outbound.write_idx = debug_info.outbound.current_write_index;
-	info->outbound.bytes_avail_toread =
-		debug_info.outbound.bytes_avail_toread;
-	info->outbound.bytes_avail_towrite =
-		debug_info.outbound.bytes_avail_towrite;
-}
-
-/*
- * vmbus_show_device_attr - Show the device attribute in sysfs.
- *
- * This is invoked when user does a
- * "cat /sys/bus/vmbus/devices/<busdevice>/<attr name>"
- */
-static ssize_t vmbus_show_device_attr(struct device *dev,
-				      struct device_attribute *dev_attr,
-				      char *buf)
-{
-	struct hv_device *device_ctx = device_to_hv_device(dev);
-	struct hv_device_info device_info;
-
-	memset(&device_info, 0, sizeof(struct hv_device_info));
-
-	get_channel_info(device_ctx, &device_info);
-
-	if (!strcmp(dev_attr->attr.name, "class_id")) {
-		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-			       device_info.chn_type.data[3],
-			       device_info.chn_type.data[2],
-			       device_info.chn_type.data[1],
-			       device_info.chn_type.data[0],
-			       device_info.chn_type.data[5],
-			       device_info.chn_type.data[4],
-			       device_info.chn_type.data[7],
-			       device_info.chn_type.data[6],
-			       device_info.chn_type.data[8],
-			       device_info.chn_type.data[9],
-			       device_info.chn_type.data[10],
-			       device_info.chn_type.data[11],
-			       device_info.chn_type.data[12],
-			       device_info.chn_type.data[13],
-			       device_info.chn_type.data[14],
-			       device_info.chn_type.data[15]);
-	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
-		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-			       device_info.chn_instance.data[3],
-			       device_info.chn_instance.data[2],
-			       device_info.chn_instance.data[1],
-			       device_info.chn_instance.data[0],
-			       device_info.chn_instance.data[5],
-			       device_info.chn_instance.data[4],
-			       device_info.chn_instance.data[7],
-			       device_info.chn_instance.data[6],
-			       device_info.chn_instance.data[8],
-			       device_info.chn_instance.data[9],
-			       device_info.chn_instance.data[10],
-			       device_info.chn_instance.data[11],
-			       device_info.chn_instance.data[12],
-			       device_info.chn_instance.data[13],
-			       device_info.chn_instance.data[14],
-			       device_info.chn_instance.data[15]);
-	} else if (!strcmp(dev_attr->attr.name, "state")) {
-		return sprintf(buf, "%d\n", device_info.chn_state);
-	} else if (!strcmp(dev_attr->attr.name, "id")) {
-		return sprintf(buf, "%d\n", device_info.chn_id);
-	} else if (!strcmp(dev_attr->attr.name, "out_intr_mask")) {
-		return sprintf(buf, "%d\n", device_info.outbound.int_mask);
-	} else if (!strcmp(dev_attr->attr.name, "out_read_index")) {
-		return sprintf(buf, "%d\n", device_info.outbound.read_idx);
-	} else if (!strcmp(dev_attr->attr.name, "out_write_index")) {
-		return sprintf(buf, "%d\n", device_info.outbound.write_idx);
-	} else if (!strcmp(dev_attr->attr.name, "out_read_bytes_avail")) {
-		return sprintf(buf, "%d\n",
-			       device_info.outbound.bytes_avail_toread);
-	} else if (!strcmp(dev_attr->attr.name, "out_write_bytes_avail")) {
-		return sprintf(buf, "%d\n",
-			       device_info.outbound.bytes_avail_towrite);
-	} else if (!strcmp(dev_attr->attr.name, "in_intr_mask")) {
-		return sprintf(buf, "%d\n", device_info.inbound.int_mask);
-	} else if (!strcmp(dev_attr->attr.name, "in_read_index")) {
-		return sprintf(buf, "%d\n", device_info.inbound.read_idx);
-	} else if (!strcmp(dev_attr->attr.name, "in_write_index")) {
-		return sprintf(buf, "%d\n", device_info.inbound.write_idx);
-	} else if (!strcmp(dev_attr->attr.name, "in_read_bytes_avail")) {
-		return sprintf(buf, "%d\n",
-			       device_info.inbound.bytes_avail_toread);
-	} else if (!strcmp(dev_attr->attr.name, "in_write_bytes_avail")) {
-		return sprintf(buf, "%d\n",
-			       device_info.inbound.bytes_avail_towrite);
-	} else if (!strcmp(dev_attr->attr.name, "monitor_id")) {
-		return sprintf(buf, "%d\n", device_info.monitor_id);
-	} else if (!strcmp(dev_attr->attr.name, "server_monitor_pending")) {
-		return sprintf(buf, "%d\n", device_info.server_monitor_pending);
-	} else if (!strcmp(dev_attr->attr.name, "server_monitor_latency")) {
-		return sprintf(buf, "%d\n", device_info.server_monitor_latency);
-	} else if (!strcmp(dev_attr->attr.name, "server_monitor_conn_id")) {
-		return sprintf(buf, "%d\n",
-			       device_info.server_monitor_conn_id);
-	} else if (!strcmp(dev_attr->attr.name, "client_monitor_pending")) {
-		return sprintf(buf, "%d\n", device_info.client_monitor_pending);
-	} else if (!strcmp(dev_attr->attr.name, "client_monitor_latency")) {
-		return sprintf(buf, "%d\n", device_info.client_monitor_latency);
-	} else if (!strcmp(dev_attr->attr.name, "client_monitor_conn_id")) {
-		return sprintf(buf, "%d\n",
-			       device_info.client_monitor_conn_id);
-	} else {
-		return 0;
-	}
-}
-
 /*
  * vmbus_bus_init -Main vmbus driver initialization routine.
  *
-- 
1.5.5.6

