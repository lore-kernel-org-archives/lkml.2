Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2LAOYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:24:15 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48163
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab2LAOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 26/28] Drivers: hv: Implement flow management on the send side
Date: Sat,  1 Dec 2012 06:46:57 -0800
Message-Id: <1354373219-31374-26-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement flow management on the send side. When the sender is blocked, the reader
can potentially signal the sender to indicate there is now room to send.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel.c      |   12 ++++++++-
 drivers/hv/hyperv_vmbus.h |    2 +-
 drivers/hv/ring_buffer.c  |   51 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 9303252..064257e 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -735,6 +735,7 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 	u32 packetlen;
 	u32 userlen;
 	int ret;
+	bool signal = false;
 
 	*buffer_actual_len = 0;
 	*requestid = 0;
@@ -761,8 +762,10 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 
 	/* Copy over the packet to the user buffer */
 	ret = hv_ringbuffer_read(&channel->inbound, buffer, userlen,
-			     (desc.offset8 << 3));
+			     (desc.offset8 << 3), &signal);
 
+	if (signal)
+		vmbus_setevent(channel);
 
 	return 0;
 }
@@ -779,6 +782,7 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	u32 packetlen;
 	u32 userlen;
 	int ret;
+	bool signal = false;
 
 	*buffer_actual_len = 0;
 	*requestid = 0;
@@ -805,7 +809,11 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	*requestid = desc.trans_id;
 
 	/* Copy over the entire packet to the user buffer */
-	ret = hv_ringbuffer_read(&channel->inbound, buffer, packetlen, 0);
+	ret = hv_ringbuffer_read(&channel->inbound, buffer, packetlen, 0,
+				 &signal);
+
+	if (signal)
+		vmbus_setevent(channel);
 
 	return 0;
 }
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index becb106..ac111f2 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -550,7 +550,7 @@ int hv_ringbuffer_peek(struct hv_ring_buffer_info *ring_info, void *buffer,
 int hv_ringbuffer_read(struct hv_ring_buffer_info *ring_info,
 		   void *buffer,
 		   u32 buflen,
-		   u32 offset);
+		   u32 offset, bool *signal);
 
 
 void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 2a0babc..cafa72f 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -84,6 +84,50 @@ static bool hv_need_to_signal(u32 old_write, struct hv_ring_buffer_info *rbi)
 	return false;
 }
 
+/*
+ * To optimize the flow management on the send-side,
+ * when the sender is blocked because of lack of
+ * sufficient space in the ring buffer, potential the
+ * consumer of the ring buffer can signal the producer.
+ * This is controlled by the following parameters:
+ *
+ * 1. pending_send_sz: This is the size in bytes that the
+ *    producer is trying to send.
+ * 2. The feature bit feat_pending_send_sz set to indicate if
+ *    the consumer of the ring will signal when the ring
+ *    state transitions from being full to a state where
+ *    there is room for the producer to send the pending packet.
+ */
+
+static bool hv_need_to_signal_on_read(u32 old_rd,
+					 struct hv_ring_buffer_info *rbi)
+{
+	u32 prev_write_sz;
+	u32 cur_write_sz;
+	u32 r_size;
+	u32 write_loc = rbi->ring_buffer->write_index;
+	u32 read_loc = rbi->ring_buffer->read_index;
+	u32 pending_sz = rbi->ring_buffer->pending_send_sz;
+
+	/*
+	 * If the other end is not blocked on write don't bother.
+	 */
+	if (pending_sz == 0)
+		return false;
+
+	r_size = rbi->ring_datasize;
+	cur_write_sz = write_loc >= read_loc ? r_size - (write_loc - read_loc) :
+			read_loc - write_loc;
+
+	prev_write_sz = write_loc >= old_rd ? r_size - (write_loc - old_rd) :
+			old_rd - write_loc;
+
+
+	if ((prev_write_sz < pending_sz) && (cur_write_sz >= pending_sz))
+		return true;
+
+	return false;
+}
 
 /*
  * hv_get_next_write_location()
@@ -461,13 +505,14 @@ int hv_ringbuffer_peek(struct hv_ring_buffer_info *Inring_info,
  *
  */
 int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
-		   u32 buflen, u32 offset)
+		   u32 buflen, u32 offset, bool *signal)
 {
 	u32 bytes_avail_towrite;
 	u32 bytes_avail_toread;
 	u32 next_read_location = 0;
 	u64 prev_indices = 0;
 	unsigned long flags;
+	u32 old_read;
 
 	if (buflen <= 0)
 		return -EINVAL;
@@ -478,6 +523,8 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
+	old_read = bytes_avail_toread;
+
 	/* Make sure there is something to read */
 	if (bytes_avail_toread < buflen) {
 		spin_unlock_irqrestore(&inring_info->ring_lock, flags);
@@ -508,5 +555,7 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 
 	spin_unlock_irqrestore(&inring_info->ring_lock, flags);
 
+	*signal = hv_need_to_signal_on_read(old_read, inring_info);
+
 	return 0;
 }
-- 
1.7.4.1

