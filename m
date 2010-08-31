Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab0IAQBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:01:04 -0400
Received: from smtpauth12.prod.mesa1.secureserver.net ([64.202.165.35]:58489
	"HELO smtpauth12.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752514Ab0IAQBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:01:02 -0400
Message-ID: <4C7D4848.6090409@sailtheuniverse.com>
Date: Tue, 31 Aug 2010 11:22:00 -0700
From: Hank Janssen <hjanssen@sailtheuniverse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
        virtualization@lists.osdl.org, devel@driverdev.osuosl.org
CC: haiyangz@microsoft.com
Subject: [PATCH 5/5] staging: hv: Gracefully handle SCSI resets - RESEND
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Send from a linux machine, not routed through exchange)

If we get a SCSI host bus reset we now gracefully handle it, and we 
take the device offline. This before sometimes caused hangs.

Signed-off-by:Hank Janssen <hjanssen@microsoft.com
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com


---
 drivers/staging/hv/storvsc.c |   36 +++++++++++++++++++++++++++++++++++-
 1 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 6bd2ff1..5f222cf 100644
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
@@ -101,6 +106,7 @@ static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)
 static inline void FreeStorDevice(struct storvsc_device *Device)
 {
 	/* ASSERT(atomic_read(&Device->RefCount) == 0); */
+	/*kfree(Device->lock);*/
 	kfree(Device);
 }
 
@@ -108,13 +114,24 @@ static inline void FreeStorDevice(struct storvsc_device *Device)
 static inline struct storvsc_device *GetStorDevice(struct hv_device *Device)
 {
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
 
@@ -122,13 +139,19 @@ static inline struct storvsc_device *GetStorDevice(struct hv_device *Device)
 static inline struct storvsc_device *MustGetStorDevice(struct hv_device *Device)
 {
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
 
 	DPRINT_INFO(STORVSC, "resetting host adapter...");
@@ -625,6 +649,16 @@ int StorVscOnHostReset(struct hv_device *Device)
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


