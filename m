Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0LFUaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:30:00 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:59254
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752869Ab0LFU35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:29:57 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2010 15:29:57 EST
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 4/8] staging: hv: Convert camel case struct fields in storvsc.c to lowercase
Date: Mon,  6 Dec 2010 12:26:47 -0800
Message-Id: <1291667211-1865-4-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1291667211-1865-3-git-send-email-hjanssen@microsoft.com>
References: <1291667211-1865-1-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-2-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-3-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com> 

Convert camel cased struct fields in storvsc.c to lowercase

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/storvsc.c |  133 +++++++++++++++++++++---------------------
 1 files changed, 67 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 7704131..3b6e63a 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -34,43 +34,43 @@
 struct storvsc_request_extension {
 	/* LIST_ENTRY ListEntry; */
 
-	struct hv_storvsc_request *Request;
-	struct hv_device *Device;
+	struct hv_storvsc_request *request;
+	struct hv_device *device;
 
 	/* Synchronize the request/response if needed */
-	struct osd_waitevent *WaitEvent;
+	struct osd_waitevent *wait_event;
 
-	struct vstor_packet VStorPacket;
+	struct vstor_packet vstor_packet;
 };
 
 /* A storvsc device is a device object that contains a vmbus channel */
 struct storvsc_device {
-	struct hv_device *Device;
+	struct hv_device *device;
 
 	/* 0 indicates the device is being destroyed */
-	atomic_t RefCount;
+	atomic_t ref_count;
 
-	atomic_t NumOutstandingRequests;
+	atomic_t num_outstanding_requests;
 
 	/*
 	 * Each unique Port/Path/Target represents 1 channel ie scsi
 	 * controller. In reality, the pathid, targetid is always 0
 	 * and the port is set by us
 	 */
-	unsigned int PortNumber;
-	unsigned char PathId;
-	unsigned char TargetId;
+	unsigned int port_number;
+	unsigned char path_id;
+	unsigned char target_id;
 
 	/* LIST_ENTRY OutstandingRequestList; */
 	/* HANDLE OutstandingRequestLock; */
 
 	/* Used for vsc/vsp channel reset process */
-	struct storvsc_request_extension InitRequest;
-	struct storvsc_request_extension ResetRequest;
+	struct storvsc_request_extension init_request;
+	struct storvsc_request_extension reset_request;
 };
 
 
-static const char *gDriverName = "storvsc";
+static const char *g_driver_name = "storvsc";
 
 /* {ba6163d9-04a1-4d29-b605-72e2ffb1dc7f} */
 static const struct hv_guid gStorVscDeviceType = {
@@ -90,10 +90,10 @@ static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)
 		return NULL;
 
 	/* Set to 2 to allow both inbound and outbound traffics */
-	/* (ie GetStorDevice() and MustGetStorDevice()) to proceed. */
-	atomic_cmpxchg(&storDevice->RefCount, 0, 2);
+	/* (ie get_stor_device() and must_get_stor_device()) to proceed. */
+	atomic_cmpxchg(&storDevice->ref_count, 0, 2);
 
-	storDevice->Device = Device;
+	storDevice->device = Device;
 	Device->Extension = storDevice;
 
 	return storDevice;
@@ -101,7 +101,7 @@ static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)
 
 static inline void FreeStorDevice(struct storvsc_device *Device)
 {
-	/* ASSERT(atomic_read(&Device->RefCount) == 0); */
+	/* ASSERT(atomic_read(&Device->ref_count) == 0); */
 	kfree(Device);
 }
 
@@ -111,8 +111,8 @@ static inline struct storvsc_device *GetStorDevice(struct hv_device *Device)
 	struct storvsc_device *storDevice;
 
 	storDevice = (struct storvsc_device *)Device->Extension;
-	if (storDevice && atomic_read(&storDevice->RefCount) > 1)
-		atomic_inc(&storDevice->RefCount);
+	if (storDevice && atomic_read(&storDevice->ref_count) > 1)
+		atomic_inc(&storDevice->ref_count);
 	else
 		storDevice = NULL;
 
@@ -125,8 +125,8 @@ static inline struct storvsc_device *MustGetStorDevice(struct hv_device *Device)
 	struct storvsc_device *storDevice;
 
 	storDevice = (struct storvsc_device *)Device->Extension;
-	if (storDevice && atomic_read(&storDevice->RefCount))
-		atomic_inc(&storDevice->RefCount);
+	if (storDevice && atomic_read(&storDevice->ref_count))
+		atomic_inc(&storDevice->ref_count);
 	else
 		storDevice = NULL;
 
@@ -140,8 +140,8 @@ static inline void PutStorDevice(struct hv_device *Device)
 	storDevice = (struct storvsc_device *)Device->Extension;
 	/* ASSERT(storDevice); */
 
-	atomic_dec(&storDevice->RefCount);
-	/* ASSERT(atomic_read(&storDevice->RefCount)); */
+	atomic_dec(&storDevice->ref_count);
+	/* ASSERT(atomic_read(&storDevice->ref_count)); */
 }
 
 /* Drop ref count to 1 to effectively disable GetStorDevice() */
@@ -153,7 +153,7 @@ static inline struct storvsc_device *ReleaseStorDevice(struct hv_device *Device)
 	/* ASSERT(storDevice); */
 
 	/* Busy wait until the ref drop to 2, then set it to 1 */
-	while (atomic_cmpxchg(&storDevice->RefCount, 2, 1) != 2)
+	while (atomic_cmpxchg(&storDevice->ref_count, 2, 1) != 2)
 		udelay(100);
 
 	return storDevice;
@@ -169,7 +169,7 @@ static inline struct storvsc_device *FinalReleaseStorDevice(
 	/* ASSERT(storDevice); */
 
 	/* Busy wait until the ref drop to 1, then set it to 0 */
-	while (atomic_cmpxchg(&storDevice->RefCount, 1, 0) != 1)
+	while (atomic_cmpxchg(&storDevice->ref_count, 1, 0) != 1)
 		udelay(100);
 
 	Device->Extension = NULL;
@@ -190,16 +190,16 @@ static int StorVscChannelInit(struct hv_device *Device)
 		return -1;
 	}
 
-	request = &storDevice->InitRequest;
-	vstorPacket = &request->VStorPacket;
+	request = &storDevice->init_request;
+	vstorPacket = &request->vstor_packet;
 
 	/*
 	 * Now, initiate the vsc/vsp initialization protocol on the open
 	 * channel
 	 */
 	memset(request, 0, sizeof(struct storvsc_request_extension));
-	request->WaitEvent = osd_waitevent_create();
-	if (!request->WaitEvent) {
+	request->wait_event = osd_waitevent_create();
+	if (!request->wait_event) {
 		ret = -ENOMEM;
 		goto nomem;
 	}
@@ -224,7 +224,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(request->WaitEvent);
+	osd_waitevent_wait(request->wait_event);
 
 	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
 	    vstorPacket->status != 0) {
@@ -255,7 +255,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(request->WaitEvent);
+	osd_waitevent_wait(request->wait_event);
 
 	/* TODO: Check returned version */
 	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
@@ -273,7 +273,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 	vstorPacket->operation = VSTOR_OPERATION_QUERY_PROPERTIES;
 	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
 	vstorPacket->storage_channel_properties.port_number =
-					storDevice->PortNumber;
+					storDevice->port_number;
 
 	ret = vmbus_sendpacket(Device->channel, vstorPacket,
 			       sizeof(struct vstor_packet),
@@ -287,7 +287,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(request->WaitEvent);
+	osd_waitevent_wait(request->wait_event);
 
 	/* TODO: Check returned version */
 	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
@@ -298,8 +298,8 @@ static int StorVscChannelInit(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	storDevice->PathId = vstorPacket->storage_channel_properties.path_id;
-	storDevice->TargetId
+	storDevice->path_id = vstorPacket->storage_channel_properties.path_id;
+	storDevice->target_id
 		= vstorPacket->storage_channel_properties.target_id;
 
 	DPRINT_DBG(STORVSC, "channel flag 0x%x, max xfer len 0x%x",
@@ -324,7 +324,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(request->WaitEvent);
+	osd_waitevent_wait(request->wait_event);
 
 	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
 	    vstorPacket->status != 0) {
@@ -337,8 +337,8 @@ static int StorVscChannelInit(struct hv_device *Device)
 	DPRINT_INFO(STORVSC, "**** storage channel up and running!! ****");
 
 Cleanup:
-	kfree(request->WaitEvent);
-	request->WaitEvent = NULL;
+	kfree(request->wait_event);
+	request->wait_event = NULL;
 nomem:
 	PutStorDevice(Device);
 	return ret;
@@ -365,7 +365,7 @@ static void StorVscOnIOCompletion(struct hv_device *Device,
 	/* ASSERT(RequestExt != NULL); */
 	/* ASSERT(RequestExt->Request != NULL); */
 
-	request = RequestExt->Request;
+	request = RequestExt->request;
 
 	/* ASSERT(request->OnIOCompletion != NULL); */
 
@@ -403,7 +403,7 @@ static void StorVscOnIOCompletion(struct hv_device *Device,
 
 	request->on_io_completion(request);
 
-	atomic_dec(&storDevice->NumOutstandingRequests);
+	atomic_dec(&storDevice->num_outstanding_requests);
 
 	PutStorDevice(Device);
 }
@@ -463,18 +463,18 @@ static void StorVscOnChannelCallback(void *context)
 			/* ASSERT(request);c */
 
 			/* if (vstorPacket.Flags & SYNTHETIC_FLAG) */
-			if ((request == &storDevice->InitRequest) ||
-			    (request == &storDevice->ResetRequest)) {
+			if ((request == &storDevice->init_request) ||
+			    (request == &storDevice->reset_request)) {
 				/* DPRINT_INFO(STORVSC,
 				 *             "reset completion - operation "
 				 *             "%u status %u",
 				 *             vstorPacket.Operation,
 				 *             vstorPacket.Status); */
 
-				memcpy(&request->VStorPacket, packet,
+				memcpy(&request->vstor_packet, packet,
 				       sizeof(struct vstor_packet));
 
-				osd_waitevent_set(request->WaitEvent);
+				osd_waitevent_set(request->wait_event);
 			} else {
 				StorVscOnReceive(device,
 						(struct vstor_packet *)packet,
@@ -522,6 +522,7 @@ static int StorVscConnectToVsp(struct hv_device *Device)
 
 /*
  * StorVscOnDeviceAdd - Callback when the device belonging to this driver is added
+ * is added
  */
 static int StorVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 {
@@ -552,17 +553,17 @@ static int StorVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 	storChannel->PathId = props->PathId;
 	storChannel->TargetId = props->TargetId; */
 
-	storDevice->PortNumber = deviceInfo->port_number;
+	storDevice->port_number = deviceInfo->port_number;
 	/* Send it back up */
 	ret = StorVscConnectToVsp(Device);
 
 	/* deviceInfo->PortNumber = storDevice->PortNumber; */
-	deviceInfo->path_id = storDevice->PathId;
-	deviceInfo->target_id = storDevice->TargetId;
+	deviceInfo->path_id = storDevice->path_id;
+	deviceInfo->target_id = storDevice->target_id;
 
 	DPRINT_DBG(STORVSC, "assigned port %u, path %u target %u\n",
-		   storDevice->PortNumber, storDevice->PathId,
-		   storDevice->TargetId);
+		   storDevice->port_number, storDevice->path_id,
+		   storDevice->target_id);
 
 Cleanup:
 	return ret;
@@ -585,9 +586,9 @@ static int StorVscOnDeviceRemove(struct hv_device *Device)
 	 * only allow inbound traffic (responses) to proceed so that
 	 * outstanding requests can be completed.
 	 */
-	while (atomic_read(&storDevice->NumOutstandingRequests)) {
+	while (atomic_read(&storDevice->num_outstanding_requests)) {
 		DPRINT_INFO(STORVSC, "waiting for %d requests to complete...",
-			    atomic_read(&storDevice->NumOutstandingRequests));
+			    atomic_read(&storDevice->num_outstanding_requests));
 		udelay(100);
 	}
 
@@ -621,22 +622,22 @@ int stor_vsc_on_host_reset(struct hv_device *Device)
 		return -1;
 	}
 
-	request = &storDevice->ResetRequest;
-	vstorPacket = &request->VStorPacket;
+	request = &storDevice->reset_request;
+	vstorPacket = &request->vstor_packet;
 
-	request->WaitEvent = osd_waitevent_create();
-	if (!request->WaitEvent) {
+	request->wait_event = osd_waitevent_create();
+	if (!request->wait_event) {
 		ret = -ENOMEM;
 		goto Cleanup;
 	}
 
 	vstorPacket->operation = VSTOR_OPERATION_RESET_BUS;
 	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
-	vstorPacket->vm_srb.path_id = storDevice->PathId;
+	vstorPacket->vm_srb.path_id = storDevice->path_id;
 
 	ret = vmbus_sendpacket(Device->channel, vstorPacket,
 			       sizeof(struct vstor_packet),
-			       (unsigned long)&storDevice->ResetRequest,
+			       (unsigned long)&storDevice->reset_request,
 			       VmbusPacketTypeDataInBand,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
@@ -646,9 +647,9 @@ int stor_vsc_on_host_reset(struct hv_device *Device)
 	}
 
 	/* FIXME: Add a timeout */
-	osd_waitevent_wait(request->WaitEvent);
+	osd_waitevent_wait(request->wait_event);
 
-	kfree(request->WaitEvent);
+	kfree(request->wait_event);
 	DPRINT_INFO(STORVSC, "host adapter reset completed");
 
 	/*
@@ -674,7 +675,7 @@ static int StorVscOnIORequest(struct hv_device *Device,
 
 	requestExtension =
 		(struct storvsc_request_extension *)Request->extension;
-	vstorPacket = &requestExtension->VStorPacket;
+	vstorPacket = &requestExtension->vstor_packet;
 	storDevice = GetStorDevice(Device);
 
 	DPRINT_DBG(STORVSC, "enter - Device %p, DeviceExt %p, Request %p, "
@@ -694,8 +695,8 @@ static int StorVscOnIORequest(struct hv_device *Device,
 	/* print_hex_dump_bytes("", DUMP_PREFIX_NONE, Request->Cdb,
 	 *			Request->CdbLen); */
 
-	requestExtension->Request = Request;
-	requestExtension->Device  = Device;
+	requestExtension->request = Request;
+	requestExtension->device  = Device;
 
 	memset(vstorPacket, 0 , sizeof(struct vstor_packet));
 
@@ -729,9 +730,9 @@ static int StorVscOnIORequest(struct hv_device *Device,
 		   vstorPacket->vm_srb.sense_info_length,
 		   vstorPacket->vm_srb.cdb_length);
 
-	if (requestExtension->Request->data_buffer.Length) {
+	if (requestExtension->request->data_buffer.Length) {
 		ret = vmbus_sendpacket_multipagebuffer(Device->channel,
-				&requestExtension->Request->data_buffer,
+				&requestExtension->request->data_buffer,
 				vstorPacket,
 				sizeof(struct vstor_packet),
 				(unsigned long)requestExtension);
@@ -748,7 +749,7 @@ static int StorVscOnIORequest(struct hv_device *Device,
 			   vstorPacket, ret);
 	}
 
-	atomic_inc(&storDevice->NumOutstandingRequests);
+	atomic_inc(&storDevice->num_outstanding_requests);
 
 	PutStorDevice(Device);
 	return ret;
@@ -782,7 +783,7 @@ int stor_vsc_initialize(struct hv_driver *Driver)
 	/* Make sure we are at least 2 pages since 1 page is used for control */
 	/* ASSERT(storDriver->RingBufferSize >= (PAGE_SIZE << 1)); */
 
-	Driver->name = gDriverName;
+	Driver->name = g_driver_name;
 	memcpy(&Driver->deviceType, &gStorVscDeviceType,
 	       sizeof(struct hv_guid));
 
-- 
1.6.0.2

