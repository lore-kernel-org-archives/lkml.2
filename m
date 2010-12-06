Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0LFUao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:30:44 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:52455
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754489Ab0LFU36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:29:58 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 5/8] staging: hv: Convert camel case function names in storvsc.c to lowercase
Date: Mon,  6 Dec 2010 12:26:48 -0800
Message-Id: <1291667211-1865-5-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1291667211-1865-4-git-send-email-hjanssen@microsoft.com>
References: <1291667211-1865-1-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-2-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-3-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-4-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com> 

Convert camel case function names in storvsc.c to lowercase

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc.c  |    8 ++--
 drivers/staging/hv/storvsc.c |   91 +++++++++++++++++++++--------------------
 2 files changed, 51 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index e62c922..208492c 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -42,7 +42,7 @@ static int BlkVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 
 	deviceInfo = (struct storvsc_device_info *)AdditionalInfo;
 
-	ret = StorVscOnDeviceAdd(Device, AdditionalInfo);
+	ret = stor_vsc_on_device_add(Device, AdditionalInfo);
 	if (ret != 0)
 		return ret;
 
@@ -94,9 +94,9 @@ int blk_vsc_initialize(struct hv_driver *Driver)
 
 	/* Setup the dispatch table */
 	storDriver->base.OnDeviceAdd = BlkVscOnDeviceAdd;
-	storDriver->base.OnDeviceRemove = StorVscOnDeviceRemove;
-	storDriver->base.OnCleanup = StorVscOnCleanup;
-	storDriver->on_io_request = StorVscOnIORequest;
+	storDriver->base.OnDeviceRemove = stor_vsc_on_device_remove;
+	storDriver->base.OnCleanup = stor_vsc_on_cleanup;
+	storDriver->on_io_request = stor_vsc_on_io_request;
 
 	return ret;
 }
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 3b6e63a..6643038 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -81,7 +81,7 @@ static const struct hv_guid gStorVscDeviceType = {
 };
 
 
-static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)
+static inline struct storvsc_device *alloc_stor_device(struct hv_device *Device)
 {
 	struct storvsc_device *storDevice;
 
@@ -99,14 +99,14 @@ static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)
 	return storDevice;
 }
 
-static inline void FreeStorDevice(struct storvsc_device *Device)
+static inline void free_stor_device(struct storvsc_device *Device)
 {
 	/* ASSERT(atomic_read(&Device->ref_count) == 0); */
 	kfree(Device);
 }
 
 /* Get the stordevice object iff exists and its refcount > 1 */
-static inline struct storvsc_device *GetStorDevice(struct hv_device *Device)
+static inline struct storvsc_device *get_stor_device(struct hv_device *Device)
 {
 	struct storvsc_device *storDevice;
 
@@ -120,7 +120,8 @@ static inline struct storvsc_device *GetStorDevice(struct hv_device *Device)
 }
 
 /* Get the stordevice object iff exists and its refcount > 0 */
-static inline struct storvsc_device *MustGetStorDevice(struct hv_device *Device)
+static inline struct storvsc_device *must_get_stor_device(
+					struct hv_device *Device)
 {
 	struct storvsc_device *storDevice;
 
@@ -133,7 +134,7 @@ static inline struct storvsc_device *MustGetStorDevice(struct hv_device *Device)
 	return storDevice;
 }
 
-static inline void PutStorDevice(struct hv_device *Device)
+static inline void put_stor_device(struct hv_device *Device)
 {
 	struct storvsc_device *storDevice;
 
@@ -144,8 +145,9 @@ static inline void PutStorDevice(struct hv_device *Device)
 	/* ASSERT(atomic_read(&storDevice->ref_count)); */
 }
 
-/* Drop ref count to 1 to effectively disable GetStorDevice() */
-static inline struct storvsc_device *ReleaseStorDevice(struct hv_device *Device)
+/* Drop ref count to 1 to effectively disable get_stor_device() */
+static inline struct storvsc_device *release_stor_device(
+					struct hv_device *Device)
 {
 	struct storvsc_device *storDevice;
 
@@ -160,7 +162,7 @@ static inline struct storvsc_device *ReleaseStorDevice(struct hv_device *Device)
 }
 
 /* Drop ref count to 0. No one can use StorDevice object. */
-static inline struct storvsc_device *FinalReleaseStorDevice(
+static inline struct storvsc_device *final_release_stor_device(
 			struct hv_device *Device)
 {
 	struct storvsc_device *storDevice;
@@ -176,14 +178,14 @@ static inline struct storvsc_device *FinalReleaseStorDevice(
 	return storDevice;
 }
 
-static int StorVscChannelInit(struct hv_device *Device)
+static int stor_vsc_channel_init(struct hv_device *Device)
 {
 	struct storvsc_device *storDevice;
 	struct storvsc_request_extension *request;
 	struct vstor_packet *vstorPacket;
 	int ret;
 
-	storDevice = GetStorDevice(Device);
+	storDevice = get_stor_device(Device);
 	if (!storDevice) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
 			   "device being destroyed?");
@@ -340,18 +342,18 @@ Cleanup:
 	kfree(request->wait_event);
 	request->wait_event = NULL;
 nomem:
-	PutStorDevice(Device);
+	put_stor_device(Device);
 	return ret;
 }
 
-static void StorVscOnIOCompletion(struct hv_device *Device,
+static void stor_vsc_on_io_completion(struct hv_device *Device,
 				  struct vstor_packet *VStorPacket,
 				  struct storvsc_request_extension *RequestExt)
 {
 	struct hv_storvsc_request *request;
 	struct storvsc_device *storDevice;
 
-	storDevice = MustGetStorDevice(Device);
+	storDevice = must_get_stor_device(Device);
 	if (!storDevice) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
 			   "device being destroyed?");
@@ -405,17 +407,17 @@ static void StorVscOnIOCompletion(struct hv_device *Device,
 
 	atomic_dec(&storDevice->num_outstanding_requests);
 
-	PutStorDevice(Device);
+	put_stor_device(Device);
 }
 
-static void StorVscOnReceive(struct hv_device *Device,
+static void stor_vsc_on_receive(struct hv_device *Device,
 			     struct vstor_packet *VStorPacket,
 			     struct storvsc_request_extension *RequestExt)
 {
 	switch (VStorPacket->operation) {
 	case VSTOR_OPERATION_COMPLETE_IO:
 		DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION");
-		StorVscOnIOCompletion(Device, VStorPacket, RequestExt);
+		stor_vsc_on_io_completion(Device, VStorPacket, RequestExt);
 		break;
 	case VSTOR_OPERATION_REMOVE_DEVICE:
 		DPRINT_INFO(STORVSC, "REMOVE_DEVICE_OPERATION");
@@ -429,7 +431,7 @@ static void StorVscOnReceive(struct hv_device *Device,
 	}
 }
 
-static void StorVscOnChannelCallback(void *context)
+static void stor_vsc_on_channel_callback(void *context)
 {
 	struct hv_device *device = (struct hv_device *)context;
 	struct storvsc_device *storDevice;
@@ -441,7 +443,7 @@ static void StorVscOnChannelCallback(void *context)
 
 	/* ASSERT(device); */
 
-	storDevice = MustGetStorDevice(device);
+	storDevice = must_get_stor_device(device);
 	if (!storDevice) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
 			   "device being destroyed?");
@@ -476,7 +478,7 @@ static void StorVscOnChannelCallback(void *context)
 
 				osd_waitevent_set(request->wait_event);
 			} else {
-				StorVscOnReceive(device,
+				stor_vsc_on_receive(device,
 						(struct vstor_packet *)packet,
 						request);
 			}
@@ -486,11 +488,11 @@ static void StorVscOnChannelCallback(void *context)
 		}
 	} while (1);
 
-	PutStorDevice(device);
+	put_stor_device(device);
 	return;
 }
 
-static int StorVscConnectToVsp(struct hv_device *Device)
+static int stor_vsc_connect_to_vsp(struct hv_device *Device)
 {
 	struct vmstorage_channel_properties props;
 	struct storvsc_driver_object *storDriver;
@@ -505,7 +507,7 @@ static int StorVscConnectToVsp(struct hv_device *Device)
 			 storDriver->ring_buffer_size,
 			 (void *)&props,
 			 sizeof(struct vmstorage_channel_properties),
-			 StorVscOnChannelCallback, Device);
+			 stor_vsc_on_channel_callback, Device);
 
 	DPRINT_DBG(STORVSC, "storage props: path id %d, tgt id %d, max xfer %d",
 		   props.path_id, props.target_id, props.max_transfer_bytes);
@@ -515,16 +517,17 @@ static int StorVscConnectToVsp(struct hv_device *Device)
 		return -1;
 	}
 
-	ret = StorVscChannelInit(Device);
+	ret = stor_vsc_channel_init(Device);
 
 	return ret;
 }
 
 /*
- * StorVscOnDeviceAdd - Callback when the device belonging to this driver is added
+ * stor_vsc_on_device_add - Callback when the device belonging to this driver
  * is added
  */
-static int StorVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
+static int stor_vsc_on_device_add(struct hv_device *Device,
+					void *AdditionalInfo)
 {
 	struct storvsc_device *storDevice;
 	/* struct vmstorage_channel_properties *props; */
@@ -532,7 +535,7 @@ static int StorVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 	int ret = 0;
 
 	deviceInfo = (struct storvsc_device_info *)AdditionalInfo;
-	storDevice = AllocStorDevice(Device);
+	storDevice = alloc_stor_device(Device);
 	if (!storDevice) {
 		ret = -1;
 		goto Cleanup;
@@ -555,7 +558,7 @@ static int StorVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 
 	storDevice->port_number = deviceInfo->port_number;
 	/* Send it back up */
-	ret = StorVscConnectToVsp(Device);
+	ret = stor_vsc_connect_to_vsp(Device);
 
 	/* deviceInfo->PortNumber = storDevice->PortNumber; */
 	deviceInfo->path_id = storDevice->path_id;
@@ -570,16 +573,16 @@ Cleanup:
 }
 
 /*
- * StorVscOnDeviceRemove - Callback when the our device is being removed
+ * stor_vsc_on_device_remove - Callback when the our device is being removed
  */
-static int StorVscOnDeviceRemove(struct hv_device *Device)
+static int stor_vsc_on_device_remove(struct hv_device *Device)
 {
 	struct storvsc_device *storDevice;
 
 	DPRINT_INFO(STORVSC, "disabling storage device (%p)...",
 		    Device->Extension);
 
-	storDevice = ReleaseStorDevice(Device);
+	storDevice = release_stor_device(Device);
 
 	/*
 	 * At this point, all outbound traffic should be disable. We
@@ -595,14 +598,14 @@ static int StorVscOnDeviceRemove(struct hv_device *Device)
 	DPRINT_INFO(STORVSC, "removing storage device (%p)...",
 		    Device->Extension);
 
-	storDevice = FinalReleaseStorDevice(Device);
+	storDevice = final_release_stor_device(Device);
 
 	DPRINT_INFO(STORVSC, "storage device (%p) safe to remove", storDevice);
 
 	/* Close the channel */
 	vmbus_close(Device->channel);
 
-	FreeStorDevice(storDevice);
+	free_stor_device(storDevice);
 	return 0;
 }
 
@@ -615,7 +618,7 @@ int stor_vsc_on_host_reset(struct hv_device *Device)
 
 	DPRINT_INFO(STORVSC, "resetting host adapter...");
 
-	storDevice = GetStorDevice(Device);
+	storDevice = get_stor_device(Device);
 	if (!storDevice) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
 			   "device being destroyed?");
@@ -658,14 +661,14 @@ int stor_vsc_on_host_reset(struct hv_device *Device)
 	 */
 
 Cleanup:
-	PutStorDevice(Device);
+	put_stor_device(Device);
 	return ret;
 }
 
 /*
- * StorVscOnIORequest - Callback to initiate an I/O request
+ * stor_vsc_on_io_request - Callback to initiate an I/O request
  */
-static int StorVscOnIORequest(struct hv_device *Device,
+static int stor_vsc_on_io_request(struct hv_device *Device,
 			      struct hv_storvsc_request *Request)
 {
 	struct storvsc_device *storDevice;
@@ -676,7 +679,7 @@ static int StorVscOnIORequest(struct hv_device *Device,
 	requestExtension =
 		(struct storvsc_request_extension *)Request->extension;
 	vstorPacket = &requestExtension->vstor_packet;
-	storDevice = GetStorDevice(Device);
+	storDevice = get_stor_device(Device);
 
 	DPRINT_DBG(STORVSC, "enter - Device %p, DeviceExt %p, Request %p, "
 		   "Extension %p", Device, storDevice, Request,
@@ -751,14 +754,14 @@ static int StorVscOnIORequest(struct hv_device *Device,
 
 	atomic_inc(&storDevice->num_outstanding_requests);
 
-	PutStorDevice(Device);
+	put_stor_device(Device);
 	return ret;
 }
 
 /*
- * StorVscOnCleanup - Perform any cleanup when the driver is removed
+ * stor_vsc_on_cleanup - Perform any cleanup when the driver is removed
  */
-static void StorVscOnCleanup(struct hv_driver *Driver)
+static void stor_vsc_on_cleanup(struct hv_driver *Driver)
 {
 }
 
@@ -806,11 +809,11 @@ int stor_vsc_initialize(struct hv_driver *Driver)
 		    STORVSC_MAX_IO_REQUESTS);
 
 	/* Setup the dispatch table */
-	storDriver->base.OnDeviceAdd	= StorVscOnDeviceAdd;
-	storDriver->base.OnDeviceRemove	= StorVscOnDeviceRemove;
-	storDriver->base.OnCleanup	= StorVscOnCleanup;
+	storDriver->base.OnDeviceAdd	= stor_vsc_on_device_add;
+	storDriver->base.OnDeviceRemove	= stor_vsc_on_device_remove;
+	storDriver->base.OnCleanup	= stor_vsc_on_cleanup;
 
-	storDriver->on_io_request	= StorVscOnIORequest;
+	storDriver->on_io_request	= stor_vsc_on_io_request;
 
 	return 0;
 }
-- 
1.6.0.2

