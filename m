Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1HYQhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:37:40 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42801
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753508Ab1HYQ24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:56 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 32/59] Staging: hv: vmbus: Cleanup error values in ringbuffer.c
Date: Thu, 25 Aug 2011 09:48:58 -0700
Message-Id: <1314290965-2698-32-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard Linux errno values in ringbuffer.c and do the associated
cleanup in the clients.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    2 +-
 drivers/staging/hv/netvsc.c      |    2 +-
 drivers/staging/hv/ring_buffer.c |    6 +++---
 drivers/staging/hv/storvsc_drv.c |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 9b99387..d3f4f1d 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -726,7 +726,7 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 		} else {
 			ret = blkvsc_submit_request(blkvsc_req,
 						    blkvsc_request_completion);
-			if (ret == -1) {
+			if (ret == -EAGAIN) {
 				pending = 1;
 				list_add_tail(&blkvsc_req->pend_entry,
 					      &blkdev->pending_list);
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index cb02eed..d547ff6 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -565,7 +565,7 @@ retry_send_cmplt:
 	if (ret == 0) {
 		/* success */
 		/* no-op */
-	} else if (ret == -1) {
+	} else if (ret == -EAGAIN) {
 		/* no more room...wait a bit and attempt to retry 3 times */
 		retries++;
 		dev_err(&device->device, "unable to send receive completion pkt"
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 42f7672..9212699 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -390,7 +390,7 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 	/* is empty since the read index == write index */
 	if (bytes_avail_towrite <= totalbytes_towrite) {
 		spin_unlock_irqrestore(&outring_info->ring_lock, flags);
-		return -1;
+		return -EAGAIN;
 	}
 
 	/* Write to the ring buffer */
@@ -450,7 +450,7 @@ int hv_ringbuffer_peek(struct hv_ring_buffer_info *Inring_info,
 
 		spin_unlock_irqrestore(&Inring_info->ring_lock, flags);
 
-		return -1;
+		return -EAGAIN;
 	}
 
 	/* Convert to byte offset */
@@ -496,7 +496,7 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 	if (bytes_avail_toread < buflen) {
 		spin_unlock_irqrestore(&inring_info->ring_lock, flags);
 
-		return -1;
+		return -EAGAIN;
 	}
 
 	next_read_location =
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 4dc6d2f..1e49879 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -580,7 +580,7 @@ retry_request:
 	/* Invokes the vsc to start an IO */
 	ret = storvsc_do_io(dev, &cmd_request->request);
 
-	if (ret == -1) {
+	if (ret == -EAGAIN) {
 		/* no more space */
 
 		if (cmd_request->bounce_sgl_count) {
-- 
1.7.4.1

