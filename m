Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2LAO1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:27:43 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:56030
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab2LAOXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:39 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 05/28] Drivers: hv: Optimize the signaling on the write path
Date: Sat,  1 Dec 2012 06:46:36 -0800
Message-Id: <1354373219-31374-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host has already implemented the "read" side optimizations.
Leverage that to optimize "write" side signaling.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel.c      |   15 +++++++++------
 drivers/hv/hyperv_vmbus.h |    2 +-
 drivers/hv/ring_buffer.c  |   42 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 773a2f2..727c5f1 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -564,6 +564,7 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 	struct scatterlist bufferlist[3];
 	u64 aligned_data = 0;
 	int ret;
+	bool signal = false;
 
 
 	/* Setup the descriptor */
@@ -580,9 +581,9 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		   packetlen_aligned - packetlen);
 
-	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
+	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3, &signal);
 
-	if (ret == 0 && !hv_get_ringbuffer_interrupt_mask(&channel->outbound))
+	if (ret == 0 && signal)
 		vmbus_setevent(channel);
 
 	return ret;
@@ -606,6 +607,7 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 	u32 packetlen_aligned;
 	struct scatterlist bufferlist[3];
 	u64 aligned_data = 0;
+	bool signal = false;
 
 	if (pagecount > MAX_PAGE_BUFFER_COUNT)
 		return -EINVAL;
@@ -641,9 +643,9 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		packetlen_aligned - packetlen);
 
-	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
+	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3, &signal);
 
-	if (ret == 0 && !hv_get_ringbuffer_interrupt_mask(&channel->outbound))
+	if (ret == 0 && signal)
 		vmbus_setevent(channel);
 
 	return ret;
@@ -665,6 +667,7 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	u32 packetlen_aligned;
 	struct scatterlist bufferlist[3];
 	u64 aligned_data = 0;
+	bool signal = false;
 	u32 pfncount = NUM_PAGES_SPANNED(multi_pagebuffer->offset,
 					 multi_pagebuffer->len);
 
@@ -703,9 +706,9 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		packetlen_aligned - packetlen);
 
-	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
+	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3, &signal);
 
-	if (ret == 0 && !hv_get_ringbuffer_interrupt_mask(&channel->outbound))
+	if (ret == 0 && signal)
 		vmbus_setevent(channel);
 
 	return ret;
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 3184f6f..895c898 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -555,7 +555,7 @@ void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
 
 int hv_ringbuffer_write(struct hv_ring_buffer_info *ring_info,
 		    struct scatterlist *sglist,
-		    u32 sgcount);
+		    u32 sgcount, bool *signal);
 
 int hv_ringbuffer_peek(struct hv_ring_buffer_info *ring_info, void *buffer,
 		   u32 buflen);
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 0010792..9bc55f0 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -53,6 +53,37 @@ u32 hv_end_read(struct hv_ring_buffer_info *rbi)
 	return read;
 }
 
+/*
+ * When we write to the ring buffer, check if the host needs to
+ * be signaled. Here is the details of this protocol:
+ *
+ *	1. The host guarantees that while it is draining the
+ *	   ring buffer, it will set the interrupt_mask to
+ *	   indicate it does not need to be interrupted when
+ *	   new data is placed.
+ *
+ *	2. The host guarantees that it will completely drain
+ *	   the ring buffer before exiting the read loop. Further,
+ *	   once the ring buffer is empty, it will clear the
+ *	   interrupt_mask and re-check to see if new data has
+ *	   arrived.
+ */
+
+static bool hv_need_to_signal(u32 old_write, struct hv_ring_buffer_info *rbi)
+{
+	if (rbi->ring_buffer->interrupt_mask)
+		return false;
+
+	/*
+	 * This is the only case we need to signal when the
+	 * ring transitions from being empty to non-empty.
+	 */
+	if (old_write == rbi->ring_buffer->read_index)
+		return true;
+
+	return false;
+}
+
 
 /*
  * hv_get_next_write_location()
@@ -322,7 +353,7 @@ void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
  *
  */
 int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
-		    struct scatterlist *sglist, u32 sgcount)
+		    struct scatterlist *sglist, u32 sgcount, bool *signal)
 {
 	int i = 0;
 	u32 bytes_avail_towrite;
@@ -331,6 +362,7 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 
 	struct scatterlist *sg;
 	u32 next_write_location;
+	u32 old_write;
 	u64 prev_indices = 0;
 	unsigned long flags;
 
@@ -359,6 +391,8 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 	/* Write to the ring buffer */
 	next_write_location = hv_get_next_write_location(outring_info);
 
+	old_write = next_write_location;
+
 	for_each_sg(sglist, sg, sgcount, i)
 	{
 		next_write_location = hv_copyto_ringbuffer(outring_info,
@@ -375,14 +409,16 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 					     &prev_indices,
 					     sizeof(u64));
 
-	/* Make sure we flush all writes before updating the writeIndex */
-	smp_wmb();
+	/* Issue a full memory barrier before updating the write index */
+	smp_mb();
 
 	/* Now, update the write location */
 	hv_set_next_write_location(outring_info, next_write_location);
 
 
 	spin_unlock_irqrestore(&outring_info->ring_lock, flags);
+
+	*signal = hv_need_to_signal(old_write, outring_info);
 	return 0;
 }
 
-- 
1.7.4.1

