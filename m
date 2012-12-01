Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab2LAOXn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:23:43 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:47247
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab2LAOXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:39 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 01/28] Drivers: hv: Implement routines for read side signaling optimization
Date: Sat,  1 Dec 2012 06:46:32 -0800
Message-Id: <1354373219-31374-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373160-31332-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement functions that will support read-side signaling optimization.
By having the reader indicate the start of the "read" operation and the
"end" of the read operation we can more efficiently handle the signaling
protocol: while the read is in progress, there is no need for the "writer"
to signal the "reader" as new items are put on the read queue.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hyperv_vmbus.h |    4 ++++
 drivers/hv/ring_buffer.c  |   24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index d8d1fad..3184f6f 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -570,6 +570,10 @@ u32 hv_get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *ring_info);
 void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 			    struct hv_ring_buffer_debug_info *debug_info);
 
+void hv_begin_read(struct hv_ring_buffer_info *rbi);
+
+u32 hv_end_read(struct hv_ring_buffer_info *rbi);
+
 /*
  * Maximum channels is determined by the size of the interrupt page
  * which is PAGE_SIZE. 1/2 of PAGE_SIZE is for send endpoint interrupt
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 7233c88..0010792 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -29,6 +29,30 @@
 
 #include "hyperv_vmbus.h"
 
+void hv_begin_read(struct hv_ring_buffer_info *rbi)
+{
+	rbi->ring_buffer->interrupt_mask = 1;
+	smp_mb();
+}
+
+u32 hv_end_read(struct hv_ring_buffer_info *rbi)
+{
+	u32 read;
+	u32 write;
+
+	rbi->ring_buffer->interrupt_mask = 0;
+	smp_mb();
+
+	/*
+	 * Now check to see if the ring buffer is still empty.
+	 * If it is not, we raced and we need to process new
+	 * incoming messages.
+	 */
+	hv_get_ringbuffer_availbytes(rbi, &read, &write);
+
+	return read;
+}
+
 
 /*
  * hv_get_next_write_location()
-- 
1.7.4.1

