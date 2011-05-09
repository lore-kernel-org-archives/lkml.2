Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1EIVuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:50:06 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48777
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755067Ab1EIVox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 106/206] Staging: hv: Get rid of the forward declaration of hv_copyto_ringbuffer()
Date: Mon,  9 May 2011 14:56:28 -0700
Message-Id: <1304978288-22999-106-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration by moving the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/ring_buffer.c |   66 +++++++++++++++----------------------
 1 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 56521fd..2a461ddee 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -236,14 +236,37 @@ static u32 hv_copyfrom_ringbuffer(
 }
 
 
-
-static u32
-hv_copyto_ringbuffer(
+/*
+ *
+ * hv_copyto_ringbuffer()
+ *
+ * Helper routine to copy from source to ring buffer.
+ * Assume there is enough room. Handles wrap-around in dest case only!!
+ *
+ */
+static u32 hv_copyto_ringbuffer(
 	struct hv_ring_buffer_info	*ring_info,
 	u32				start_write_offset,
 	void				*src,
-	u32				srclen);
+	u32				srclen)
+{
+	void *ring_buffer = hv_get_ring_buffer(ring_info);
+	u32 ring_buffer_size = hv_get_ring_buffersize(ring_info);
+	u32 frag_len;
+
+	/* wrap-around detected! */
+	if (srclen > ring_buffer_size - start_write_offset) {
+		frag_len = ring_buffer_size - start_write_offset;
+		memcpy(ring_buffer + start_write_offset, src, frag_len);
+		memcpy(ring_buffer, src + frag_len, srclen - frag_len);
+	} else
+		memcpy(ring_buffer + start_write_offset, src, srclen);
 
+	start_write_offset += srclen;
+	start_write_offset %= ring_buffer_size;
+
+	return start_write_offset;
+}
 
 /*
  *
@@ -498,38 +521,3 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 
 	return 0;
 }
-
-
-/*
- *
- * hv_copyto_ringbuffer()
- *
- * Helper routine to copy from source to ring buffer.
- * Assume there is enough room. Handles wrap-around in dest case only!!
- *
- */
-static u32
-hv_copyto_ringbuffer(
-	struct hv_ring_buffer_info	*ring_info,
-	u32				start_write_offset,
-	void				*src,
-	u32				srclen)
-{
-	void *ring_buffer = hv_get_ring_buffer(ring_info);
-	u32 ring_buffer_size = hv_get_ring_buffersize(ring_info);
-	u32 frag_len;
-
-	/* wrap-around detected! */
-	if (srclen > ring_buffer_size - start_write_offset) {
-		frag_len = ring_buffer_size - start_write_offset;
-		memcpy(ring_buffer + start_write_offset, src, frag_len);
-		memcpy(ring_buffer, src + frag_len, srclen - frag_len);
-	} else
-		memcpy(ring_buffer + start_write_offset, src, srclen);
-
-	start_write_offset += srclen;
-	start_write_offset %= ring_buffer_size;
-
-	return start_write_offset;
-}
-
-- 
1.7.4.1

