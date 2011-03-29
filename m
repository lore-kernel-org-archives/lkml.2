Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1C2UsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:48:15 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:54091
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753937Ab1C2UsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:48:09 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 04/07] Replace DPRINT with natives in hv_vmbus
Date: Tue, 29 Mar 2011 13:58:47 -0700
Message-Id: <1301432330-1705-5-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
References: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all remaining DPRINT calls (excluding the ringbuffer debug
which is going to be done in a next set of patches) with their
native pr_ calls. And also changed some of the printouts to be more
useful.

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/channel.c      |    9 +++++--
 drivers/staging/hv/channel_mgmt.c |   25 ++++++++++-----------
 drivers/staging/hv/connection.c   |   12 ++++++----
 drivers/staging/hv/hv.c           |   10 ++++----
 drivers/staging/hv/ring_buffer.c  |    1 +
 drivers/staging/hv/vmbus_drv.c    |   43 +++++++++++++++---------------------
 6 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index c90dbaf..ddadd6e 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -18,6 +18,8 @@
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
@@ -898,7 +900,7 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 	if (userlen > bufferlen) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
-		DPRINT_ERR(VMBUS, "buffer too small - got %d needs %d",
+		pr_err("Buffer too small - got %d needs %d\n",
 			   bufferlen, userlen);
 		return -1;
 	}
@@ -950,8 +952,9 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	if (packetlen > bufferlen) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
-		DPRINT_ERR(VMBUS, "buffer too small - needed %d bytes but "
-			   "got space for only %d bytes", packetlen, bufferlen);
+		pr_err("Buffer too small - needed %d bytes but "
+			"got space for only %d bytes\n",
+			packetlen, bufferlen);
 		return -2;
 	}
 
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index ebdd9d8..a75a1ae 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -18,6 +18,8 @@
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
@@ -403,8 +405,7 @@ static void vmbus_process_offer(struct work_struct *work)
 	 */
 	ret = vmbus_child_device_register(newchannel->device_obj);
 	if (ret != 0) {
-		DPRINT_ERR(VMBUS,
-			   "unable to add child device object (relid %d)",
+		pr_err("unable to add child device object (relid %d)\n",
 			   newchannel->offermsg.child_relid);
 
 		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
@@ -430,8 +431,9 @@ static void vmbus_process_offer(struct work_struct *work)
 						 hv_cb_utils[cnt].callback,
 						 newchannel) == 0) {
 				hv_cb_utils[cnt].channel = newchannel;
-				DPRINT_INFO(VMBUS, "%s",
-						hv_cb_utils[cnt].log_msg);
+
+				pr_info("%s\n", hv_cb_utils[cnt].log_msg);
+
 				count_hv_channel();
 			}
 		}
@@ -472,7 +474,7 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 	/* Allocate the channel object and save this offer. */
 	newchannel = alloc_channel();
 	if (!newchannel) {
-		DPRINT_ERR(VMBUS, "unable to allocate channel object");
+		pr_err("Unable to allocate channel object\n");
 		return;
 	}
 
@@ -730,8 +732,7 @@ void vmbus_onmessage(void *context)
 	size = msg->header.payload_size;
 
 	if (hdr->msgtype >= CHANNELMSG_COUNT) {
-		DPRINT_ERR(VMBUS,
-			   "Received invalid channel message type %d size %d",
+		pr_err("Received invalid channel message type %d size %d\n",
 			   hdr->msgtype, size);
 		print_hex_dump_bytes("", DUMP_PREFIX_NONE,
 				     (unsigned char *)msg->u.payload, size);
@@ -741,8 +742,7 @@ void vmbus_onmessage(void *context)
 	if (gChannelMessageTable[hdr->msgtype].messageHandler)
 		gChannelMessageTable[hdr->msgtype].messageHandler(hdr);
 	else
-		DPRINT_ERR(VMBUS, "Unhandled channel message type %d",
-			   hdr->msgtype);
+		pr_err("Unhandled channel message type %d\n", hdr->msgtype);
 }
 
 /*
@@ -770,7 +770,7 @@ int vmbus_request_offers(void)
 	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_message_header));
 	if (ret != 0) {
-		DPRINT_ERR(VMBUS, "Unable to request offers - %d", ret);
+		pr_err("Unable to request offers - %d\n", ret);
 
 		goto cleanup;
 	}
@@ -810,9 +810,8 @@ void vmbus_release_unattached_channels(void)
 
 		if (!channel->device_obj->drv) {
 			list_del(&channel->listentry);
-			DPRINT_INFO(VMBUS,
-				    "Releasing unattached device object %p",
-				    channel->device_obj);
+
+			pr_err("Releasing unattached device object\n");
 
 			vmbus_child_device_unregister(channel->device_obj);
 			free_channel(channel);
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index ed2a7a8..7de0780 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -20,6 +20,8 @@
  *   Hank Janssen  <hjanssen@microsoft.com>
  *
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
@@ -153,9 +155,9 @@ int vmbus_connect(void)
 	if (msginfo->response.version_response.version_supported) {
 		vmbus_connection.conn_state = CONNECTED;
 	} else {
-		DPRINT_ERR(VMBUS, "Vmbus connection failed!!..."
-			   "current version (%d) not supported",
-			   VMBUS_REVISION_NUMBER);
+		pr_err("Unable to connect, "
+			"Version %d not supported by Hyper-V\n",
+			VMBUS_REVISION_NUMBER);
 		ret = -1;
 		goto Cleanup;
 	}
@@ -216,7 +218,7 @@ int vmbus_disconnect(void)
 
 	vmbus_connection.conn_state = DISCONNECTED;
 
-	DPRINT_INFO(VMBUS, "Vmbus disconnected!!");
+	pr_info("hv_vmbus disconnected\n");
 
 Cleanup:
 	kfree(msg);
@@ -269,7 +271,7 @@ static void process_chn_event(void *context)
 		 *			  (void*)channel);
 		 */
 	} else {
-		DPRINT_ERR(VMBUS, "channel not found for relid - %d.", relid);
+		pr_err("channel not found for relid - %d\n", relid);
 	}
 }
 
diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index d627a83..8898d7f 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -19,6 +19,8 @@
  *   Hank Janssen  <hjanssen@microsoft.com>
  *
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -116,7 +118,7 @@ static int query_hypervisor_info(void)
 		edx = 0;
 		op = HVCPUID_VERSION;
 		cpuid(op, &eax, &ebx, &ecx, &edx);
-		DPRINT_INFO(VMBUS, "OS Build:%d-%d.%d-%d-%d.%d",\
+		pr_info("Hyper-V Host OS Build:%d-%d.%d-%d-%d.%d\n",
 			    eax,
 			    ebx >> 16,
 			    ebx & 0xFFFF,
@@ -369,8 +371,7 @@ void hv_synic_init(void *irqarg)
 		(void *)get_zeroed_page(GFP_ATOMIC);
 
 	if (hv_context.synic_message_page[cpu] == NULL) {
-		DPRINT_ERR(VMBUS,
-			   "unable to allocate SYNIC message page!!");
+		pr_err("Unable to allocate SYNIC message page\n");
 		goto Cleanup;
 	}
 
@@ -378,8 +379,7 @@ void hv_synic_init(void *irqarg)
 		(void *)get_zeroed_page(GFP_ATOMIC);
 
 	if (hv_context.synic_event_page[cpu] == NULL) {
-		DPRINT_ERR(VMBUS,
-			   "unable to allocate SYNIC event page!!");
+		pr_err("Unable to allocate SYNIC event page\n");
 		goto Cleanup;
 	}
 
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 9bd5218..66e1b3f 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -20,6 +20,7 @@
  *   Hank Janssen  <hjanssen@microsoft.com>
  *
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
 #include <linux/mm.h>
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index b320f71..cb6dbc0 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -20,6 +20,8 @@
  *
  * 3/9/2011: K. Y. Srinivasan	- Significant restructuring and cleanup
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -350,18 +352,16 @@ static int vmbus_probe(struct device *child_device)
 		ret = dev->probe_error =
 		drv->driver.probe(child_device);
 		if (ret != 0) {
-			DPRINT_ERR(VMBUS_DRV, "probe() failed for device %s "
-				   "(%p) on driver %s (%d)...",
-				   dev_name(child_device), child_device,
-				   child_device->driver->name, ret);
+			pr_err("probe failed for device %s (%d)\n",
+			       dev_name(child_device), ret);
 
 			INIT_WORK(&dev->probe_failed_work_item,
 				  vmbus_probe_failed_cb);
 			schedule_work(&dev->probe_failed_work_item);
 		}
 	} else {
-		DPRINT_ERR(VMBUS_DRV, "probe() method not set for driver - %s",
-			   child_device->driver->name);
+		pr_err("probe not set for driver %s\n",
+		       dev_name(child_device));
 		ret = -1;
 	}
 	return ret;
@@ -386,9 +386,8 @@ static int vmbus_remove(struct device *child_device)
 		if (drv->driver.remove) {
 			ret = drv->driver.remove(child_device);
 		} else {
-			DPRINT_ERR(VMBUS_DRV,
-				   "remove() method not set for driver - %s",
-				   child_device->driver->name);
+			pr_err("remove not set for driver %s\n",
+				dev_name(child_device));
 			ret = -1;
 		}
 	}
@@ -572,12 +571,10 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 	/* Hypervisor initialization...setup hypercall page..etc */
 	ret = hv_init();
 	if (ret != 0) {
-		DPRINT_ERR(VMBUS, "Unable to initialize the hypervisor - 0x%x",
-				ret);
+		pr_err("Unable to initialize the hypervisor - 0x%x\n", ret);
 		goto cleanup;
 	}
 
-
 	hv_bus.bus.name = driver_name;
 
 	/* Initialize the bus context */
@@ -599,7 +596,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 			  driver_name, pdev);
 
 	if (ret != 0) {
-		DPRINT_ERR(VMBUS_DRV, "ERROR - Unable to request IRQ %d",
+		pr_err("Unable to request IRQ %d\n",
 			   pdev->irq);
 
 		bus_unregister(&hv_bus.bus);
@@ -669,8 +666,7 @@ int vmbus_child_driver_register(struct device_driver *drv)
 {
 	int ret;
 
-	DPRINT_INFO(VMBUS_DRV, "child driver (%p) registering - name %s",
-		    drv, drv->name);
+	pr_info("child driver registering - name %s\n", drv->name);
 
 	/* The child driver on this vmbus */
 	drv->bus = &hv_bus.bus;
@@ -695,8 +691,7 @@ EXPORT_SYMBOL(vmbus_child_driver_register);
  */
 void vmbus_child_driver_unregister(struct device_driver *drv)
 {
-	DPRINT_INFO(VMBUS_DRV, "child driver (%p) unregistering - name %s",
-		    drv, drv->name);
+	pr_info("child driver unregistering - name %s\n", drv->name);
 
 	driver_unregister(drv);
 
@@ -717,8 +712,7 @@ struct hv_device *vmbus_child_device_create(struct hv_guid *type,
 	/* Allocate the new child device */
 	child_device_obj = kzalloc(sizeof(struct hv_device), GFP_KERNEL);
 	if (!child_device_obj) {
-		DPRINT_ERR(VMBUS_DRV,
-			"unable to allocate device_context for child device");
+		pr_err("Unable to allocate device object for child device\n");
 		return NULL;
 	}
 
@@ -759,11 +753,10 @@ int vmbus_child_device_register(struct hv_device *child_device_obj)
 	ret = child_device_obj->probe_error;
 
 	if (ret)
-		DPRINT_ERR(VMBUS_DRV, "unable to register child device (%p)",
-			   &child_device_obj->device);
+		pr_err("Unable to register child device\n");
 	else
-		DPRINT_INFO(VMBUS_DRV, "child device (%p) registered",
-			    &child_device_obj->device);
+		pr_info("child device %s registered\n",
+			dev_name(&child_device_obj->device));
 
 	return ret;
 }
@@ -780,8 +773,8 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
 	 */
 	device_unregister(&device_obj->device);
 
-	DPRINT_INFO(VMBUS_DRV, "child device (%p) unregistered",
-		    &device_obj->device);
+	pr_info("child device %s unregistered\n",
+		dev_name(&device_obj->device));
 }
 
 
-- 
1.6.0.2

