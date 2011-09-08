Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab1IHOFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:05:45 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40577
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933082Ab1IHODQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:03:16 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 18/25] Staging: hv: storvsc: Eliminate the usage of ext field in struct  hv_device
Date: Thu,  8 Sep 2011 07:24:29 -0700
Message-Id: <1315491876-9554-18-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, eliminate the usage of ext field in struct  hv_device for storvsc driver.
We do this by registering pointer to struct storvsc_device as the driver
specific data and eliminating the current usage of driver specific data to
save and retrieve the pointer to struct Scsi_Host.
Additionally, all access to the driver specific data is through
the vmbus wrapper functions.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 57c1035..98d47cd 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -266,6 +266,7 @@ struct storvsc_device {
 	bool	 destroy;
 	bool	 drain_notify;
 	atomic_t num_outstanding_req;
+	struct Scsi_Host *host;
 
 	wait_queue_head_t waiting_to_drain;
 
@@ -306,7 +307,8 @@ static inline struct storvsc_device *get_out_stor_device(
 {
 	struct storvsc_device *stor_device;
 
-	stor_device = (struct storvsc_device *)device->ext;
+	stor_device =
+		(struct storvsc_device *)hv_get_drvdata(device);
 
 	if (stor_device && stor_device->destroy)
 		stor_device = NULL;
@@ -328,7 +330,8 @@ static inline struct storvsc_device *get_in_stor_device(
 {
 	struct storvsc_device *stor_device;
 
-	stor_device = (struct storvsc_device *)device->ext;
+	stor_device =
+		(struct storvsc_device *)hv_get_drvdata(device);
 
 	if (!stor_device)
 		goto get_in_err;
@@ -480,7 +483,8 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	struct storvsc_device *stor_device;
 	struct vstor_packet *stor_pkt;
 
-	stor_device = (struct storvsc_device *)device->ext;
+	stor_device =
+		(struct storvsc_device *)hv_get_drvdata(device);
 
 	stor_pkt = &request->vstor_packet;
 
@@ -630,7 +634,8 @@ static int storvsc_dev_remove(struct hv_device *device)
 	struct storvsc_device *stor_device;
 	unsigned long flags;
 
-	stor_device = (struct storvsc_device *)device->ext;
+	stor_device =
+		(struct storvsc_device *)hv_get_drvdata(device);
 
 	spin_lock_irqsave(&device->channel->inbound_lock, flags);
 	stor_device->destroy = true;
@@ -652,7 +657,7 @@ static int storvsc_dev_remove(struct hv_device *device)
 	 * allow incoming packets.
 	 */
 	spin_lock_irqsave(&device->channel->inbound_lock, flags);
-	device->ext = NULL;
+	hv_set_drvdata(device, NULL);
 	spin_unlock_irqrestore(&device->channel->inbound_lock, flags);
 
 	/* Close the channel */
@@ -963,7 +968,9 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 static int storvsc_remove(struct hv_device *dev,
 				const struct hv_vmbus_device_id *dev_id)
 {
-	struct Scsi_Host *host = dev_get_drvdata(&dev->device);
+	struct storvsc_device *stor_device =
+			(struct storvsc_device *)hv_get_drvdata(dev);
+	struct Scsi_Host *host = stor_device->host;
 	struct hv_host_device *host_dev =
 			(struct hv_host_device *)host->hostdata;
 
@@ -1338,8 +1345,6 @@ static int storvsc_probe(struct hv_device *device,
 	if (!host)
 		return -ENOMEM;
 
-	dev_set_drvdata(&device->device, host);
-
 	host_dev = (struct hv_host_device *)host->hostdata;
 	memset(host_dev, 0, sizeof(struct hv_host_device));
 
@@ -1366,7 +1371,8 @@ static int storvsc_probe(struct hv_device *device,
 	stor_device->destroy = false;
 	init_waitqueue_head(&stor_device->waiting_to_drain);
 	stor_device->device = device;
-	device->ext = stor_device;
+	stor_device->host = host;
+	hv_set_drvdata(device, stor_device);
 
 	stor_device->port_number = host->host_no;
 	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size);
-- 
1.7.4.1

