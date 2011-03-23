Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab1CWRkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:40:45 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:51758
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755641Ab1CWRkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:40:39 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 06/16] Staging: hv: Get rid of dead code in storvsc.c
Date: Wed, 23 Mar 2011 10:50:24 -0700
Message-Id: <1300902635-1347-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300902635-1347-1-git-send-email-kys@microsoft.com>
References: <1300902537-1290-1-git-send-email-kys@microsoft.com>
 <1300902635-1347-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of some "dead code" from storvsc.c

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c |   33 ---------------------------------
 1 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index c8d7ff7..1f05aa6 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -65,7 +65,6 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 
 static inline void free_stor_device(struct storvsc_device *device)
 {
-	/* ASSERT(atomic_read(&device->ref_count) == 0); */
 	kfree(device);
 }
 
@@ -103,10 +102,8 @@ static inline void put_stor_device(struct hv_device *device)
 	struct storvsc_device *stor_device;
 
 	stor_device = (struct storvsc_device *)device->ext;
-	/* ASSERT(stor_device); */
 
 	atomic_dec(&stor_device->ref_count);
-	/* ASSERT(atomic_read(&stor_device->ref_count)); */
 }
 
 /* Drop ref count to 1 to effectively disable get_stor_device() */
@@ -116,7 +113,6 @@ static inline struct storvsc_device *release_stor_device(
 	struct storvsc_device *stor_device;
 
 	stor_device = (struct storvsc_device *)device->ext;
-	/* ASSERT(stor_device); */
 
 	/* Busy wait until the ref drop to 2, then set it to 1 */
 	while (atomic_cmpxchg(&stor_device->ref_count, 2, 1) != 2)
@@ -132,7 +128,6 @@ static inline struct storvsc_device *final_release_stor_device(
 	struct storvsc_device *stor_device;
 
 	stor_device = (struct storvsc_device *)device->ext;
-	/* ASSERT(stor_device); */
 
 	/* Busy wait until the ref drop to 1, then set it to 0 */
 	while (atomic_cmpxchg(&stor_device->ref_count, 1, 0) != 1)
@@ -341,12 +336,8 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 		   "completed bytes xfer %u", request_ext,
 		   vstor_packet->vm_srb.data_transfer_length);
 
-	/* ASSERT(request_ext != NULL); */
-	/* ASSERT(request_ext->request != NULL); */
-
 	request = request_ext->request;
 
-	/* ASSERT(request->OnIOCompletion != NULL); */
 
 	/* Copy over the status...etc */
 	request->status = vstor_packet->vm_srb.scsi_status;
@@ -366,8 +357,6 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 				    "valid - len %d\n", request_ext,
 				    vstor_packet->vm_srb.sense_info_length);
 
-			/* ASSERT(vstor_packet->vm_srb.sense_info_length <= */
-			/* 	request->SenseBufferSize); */
 			memcpy(request->sense_buffer,
 			       vstor_packet->vm_srb.sense_data,
 			       vstor_packet->vm_srb.sense_info_length);
@@ -418,7 +407,6 @@ static void stor_vsc_on_channel_callback(void *context)
 	struct storvsc_request_extension *request;
 	int ret;
 
-	/* ASSERT(device); */
 
 	stor_device = must_get_stor_device(device);
 	if (!stor_device) {
@@ -435,21 +423,12 @@ static void stor_vsc_on_channel_callback(void *context)
 			DPRINT_DBG(STORVSC, "receive %d bytes - tid %llx",
 				   bytes_recvd, request_id);
 
-			/* ASSERT(bytes_recvd ==
-					sizeof(struct vstor_packet)); */
 
 			request = (struct storvsc_request_extension *)
 					(unsigned long)request_id;
-			/* ASSERT(request);c */
 
-			/* if (vstor_packet.Flags & SYNTHETIC_FLAG) */
 			if ((request == &stor_device->init_request) ||
 			    (request == &stor_device->reset_request)) {
-				/* DPRINT_INFO(STORVSC,
-				 *             "reset completion - operation "
-				 *             "%u status %u",
-				 *             vstor_packet.Operation,
-				 *             vstor_packet.Status); */
 
 				memcpy(&request->vstor_packet, packet,
 				       sizeof(struct vstor_packet));
@@ -461,7 +440,6 @@ static void stor_vsc_on_channel_callback(void *context)
 						request);
 			}
 		} else {
-			/* DPRINT_DBG(STORVSC, "nothing else to read..."); */
 			break;
 		}
 	} while (1);
@@ -508,7 +486,6 @@ int stor_vsc_on_device_add(struct hv_device *device,
 					void *additional_info)
 {
 	struct storvsc_device *stor_device;
-	/* struct vmstorage_channel_properties *props; */
 	struct storvsc_device_info *device_info;
 	int ret = 0;
 
@@ -520,8 +497,6 @@ int stor_vsc_on_device_add(struct hv_device *device,
 	}
 
 	/* Save the channel properties to our storvsc channel */
-	/* props = (struct vmstorage_channel_properties *)
-	 *		channel->offerMsg.Offer.u.Standard.UserDefined; */
 
 	/* FIXME: */
 	/*
@@ -530,15 +505,10 @@ int stor_vsc_on_device_add(struct hv_device *device,
 	 * scsi channel prior to the bus scan
 	 */
 
-	/* storChannel->PortNumber = 0;
-	storChannel->PathId = props->PathId;
-	storChannel->TargetId = props->TargetId; */
-
 	stor_device->port_number = device_info->port_number;
 	/* Send it back up */
 	ret = stor_vsc_connect_to_vsp(device);
 
-	/* device_info->PortNumber = stor_device->PortNumber; */
 	device_info->path_id = stor_device->path_id;
 	device_info->target_id = stor_device->target_id;
 
@@ -673,8 +643,6 @@ int stor_vsc_on_io_request(struct hv_device *device,
 		return -2;
 	}
 
-	/* print_hex_dump_bytes("", DUMP_PREFIX_NONE, request->Cdb,
-	 *			request->CdbLen); */
 
 	request_extension->request = request;
 	request_extension->device  = device;
@@ -762,7 +730,6 @@ int stor_vsc_initialize(struct hv_driver *driver)
 		   sizeof(struct vmscsi_request));
 
 	/* Make sure we are at least 2 pages since 1 page is used for control */
-	/* ASSERT(stor_driver->RingBufferSize >= (PAGE_SIZE << 1)); */
 
 	driver->name = g_driver_name;
 	memcpy(&driver->dev_type, &gStorVscDeviceType,
-- 
1.7.4.1

