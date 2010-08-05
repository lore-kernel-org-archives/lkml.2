Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab0HETau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 15:30:50 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:25803 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933415Ab0HETaj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 15:30:39 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "'gregkh@suse.de'" <gregkh@suse.de>
Subject: [PATCH 5/5] staging: hv: Gracefully handle SCSI resets
Thread-Topic: [PATCH 5/5] staging: hv: Gracefully handle SCSI resets
Thread-Index: Acs01Iknp3eis2yLQZupvE7mjWPj2A==
Date: Thu, 5 Aug 2010 19:30:37 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FEC8AF@TK5EX14MBXC114.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com>

If we get a SCSI host bus reset we now gracefully handle it, and we take the
device offline. This before sometimes caused hangs.

Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com>
Cc: stable <stable@kernel.org>

---
 drivers/staging/hv/storvsc.c |   36 +++++++++++++++++++++++++++++++++++-
 1 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c index 6bd2ff1..5f222cf 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -48,7 +48,9 @@ struct storvsc_device {
 
 	/* 0 indicates the device is being destroyed */
 	atomic_t RefCount;
-
+	
+	int reset;
+	spinlock_t lock;
 	atomic_t NumOutstandingRequests;
 
 	/*
@@ -93,6 +95,9 @@ static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)
 	atomic_cmpxchg(&storDevice->RefCount, 0, 2);
 
 	storDevice->Device = Device;
+	storDevice->reset  = 0;
+	spin_lock_init(&storDevice->lock);
+
 	Device->Extension = storDevice;
 
 	return storDevice;
@@ -101,6 +106,7 @@ static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)  static inline void FreeStorDevice(struct storvsc_device *Device)  {
 	/* ASSERT(atomic_read(&Device->RefCount) == 0); */
+	/*kfree(Device->lock);*/
 	kfree(Device);
 }
 
@@ -108,13 +114,24 @@ static inline void FreeStorDevice(struct storvsc_device *Device)  static inline struct storvsc_device *GetStorDevice(struct hv_device *Device)  {
 	struct storvsc_device *storDevice;
+	unsigned long flags;
 
 	storDevice = (struct storvsc_device *)Device->Extension;
+
+	spin_lock_irqsave(&storDevice->lock, flags);
+
+	if (storDevice->reset == 1) {
+		spin_unlock_irqrestore(&storDevice->lock, flags);
+		return NULL;
+	}
+
 	if (storDevice && atomic_read(&storDevice->RefCount) > 1)
 		atomic_inc(&storDevice->RefCount);
 	else
 		storDevice = NULL;
 
+	spin_unlock_irqrestore(&storDevice->lock, flags);
+
 	return storDevice;
 }
 
@@ -122,13 +139,19 @@ static inline struct storvsc_device *GetStorDevice(struct hv_device *Device)  static inline struct storvsc_device *MustGetStorDevice(struct hv_device *Device)  {
 	struct storvsc_device *storDevice;
+	unsigned long flags;
 
 	storDevice = (struct storvsc_device *)Device->Extension;
+
+	spin_lock_irqsave(&storDevice->lock, flags);
+
 	if (storDevice && atomic_read(&storDevice->RefCount))
 		atomic_inc(&storDevice->RefCount);
 	else
 		storDevice = NULL;
 
+	spin_unlock_irqrestore(&storDevice->lock, flags);
+
 	return storDevice;
 }
 
@@ -614,6 +637,7 @@ int StorVscOnHostReset(struct hv_device *Device)
 	struct storvsc_device *storDevice;
 	struct storvsc_request_extension *request;
 	struct vstor_packet *vstorPacket;
+	unsigned long flags;
 	int ret;
 
 	DPRINT_INFO(STORVSC, "resetting host adapter..."); @@ -625,6 +649,16 @@ int StorVscOnHostReset(struct hv_device *Device)
 		return -1;
 	}
 
+	spin_lock_irqsave(&storDevice->lock, flags);
+	storDevice->reset = 1;
+	spin_unlock_irqrestore(&storDevice->lock, flags);
+
+	/*
+	 * Wait for traffic in transit to complete
+	 */
+	while (atomic_read(&storDevice->NumOutstandingRequests))
+		udelay(1000);
+
 	request = &storDevice->ResetRequest;
 	vstorPacket = &request->VStorPacket;
 
--
1.6.0.2

