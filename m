Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1ATIcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:32:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43956 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1ATIcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:32:18 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, devel@driverdev.osuosl.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/hv/osd: don't reimplement ALIGN macro
Date: Thu, 20 Jan 2011 09:32:01 +0100
Message-Id: <1295512321-17626-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110120050143.GC9482@suse.de>
References: <20110120050143.GC9482@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ALIGN_DOWN macro was only used in NUM_PAGES_SPANNED.  So make the
latter easier and get rid of the former.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/staging/hv/blkvsc.c      |    2 +-
 drivers/staging/hv/channel.c     |    6 +++---
 drivers/staging/hv/hv.c          |    4 ++--
 drivers/staging/hv/osd.h         |   10 +++-------
 drivers/staging/hv/storvsc.c     |    6 +++---
 drivers/staging/hv/storvsc_drv.c |    4 ++--
 6 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index bc16d91..11a2523 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -85,7 +85,7 @@ int blk_vsc_initialize(struct hv_driver *driver)
 	 */
 	stor_driver->max_outstanding_req_per_channel =
 		((stor_driver->ring_buffer_size - PAGE_SIZE) /
-		  ALIGN_UP(MAX_MULTIPAGE_BUFFER_PACKET +
+		  ALIGN(MAX_MULTIPAGE_BUFFER_PACKET +
 			   sizeof(struct vstor_packet) + sizeof(u64),
 			   sizeof(u64)));
 
diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 45a627d..69e7856 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -726,7 +726,7 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 {
 	struct vmpacket_descriptor desc;
 	u32 packetlen = sizeof(struct vmpacket_descriptor) + bufferlen;
-	u32 packetlen_aligned = ALIGN_UP(packetlen, sizeof(u64));
+	u32 packetlen_aligned = ALIGN(packetlen, sizeof(u64));
 	struct scatterlist bufferlist[3];
 	u64 aligned_data = 0;
 	int ret;
@@ -793,7 +793,7 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 			  ((MAX_PAGE_BUFFER_COUNT - pagecount) *
 			  sizeof(struct hv_page_buffer));
 	packetlen = descsize + bufferlen;
-	packetlen_aligned = ALIGN_UP(packetlen, sizeof(u64));
+	packetlen_aligned = ALIGN(packetlen, sizeof(u64));
 
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
@@ -862,7 +862,7 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 			  ((MAX_MULTIPAGE_BUFFER_COUNT - pfncount) *
 			  sizeof(u64));
 	packetlen = descsize + bufferlen;
-	packetlen_aligned = ALIGN_UP(packetlen, sizeof(u64));
+	packetlen_aligned = ALIGN(packetlen, sizeof(u64));
 
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index a34d713..021acba 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -267,7 +267,7 @@ int hv_init(void)
 
 	hv_context.signal_event_param =
 		(struct hv_input_signal_event *)
-			(ALIGN_UP((unsigned long)
+			(ALIGN((unsigned long)
 				  hv_context.signal_event_buffer,
 				  HV_HYPERCALL_PARAM_ALIGN));
 	hv_context.signal_event_param->connectionid.asu32 = 0;
@@ -338,7 +338,7 @@ u16 hv_post_message(union hv_connection_id connection_id,
 		return -1;
 
 	aligned_msg = (struct hv_input_post_message *)
-			(ALIGN_UP(addr, HV_HYPERCALL_PARAM_ALIGN));
+			(ALIGN(addr, HV_HYPERCALL_PARAM_ALIGN));
 
 	aligned_msg->connectionid = connection_id;
 	aligned_msg->message_type = message_type;
diff --git a/drivers/staging/hv/osd.h b/drivers/staging/hv/osd.h
index 870ef07..f787161 100644
--- a/drivers/staging/hv/osd.h
+++ b/drivers/staging/hv/osd.h
@@ -25,16 +25,12 @@
 #ifndef _OSD_H_
 #define _OSD_H_
 
+#include <linux/kernel.h>
 #include <linux/workqueue.h>
 
 /* Defines */
-#define ALIGN_UP(value, align)	(((value) & (align-1)) ?		\
-				 (((value) + (align-1)) & ~(align-1)) :	\
-				 (value))
-#define ALIGN_DOWN(value, align)	((value) & ~(align-1))
-#define NUM_PAGES_SPANNED(addr, len)	((ALIGN_UP(addr+len, PAGE_SIZE) - \
-					 ALIGN_DOWN(addr, PAGE_SIZE)) >>  \
-					 PAGE_SHIFT)
+#define NUM_PAGES_SPANNED(addr, len)	((PAGE_ALIGN(addr + len) >> PAGE_SHIFT) - \
+					(addr >> PAGE_SHIFT))
 
 #define LOWORD(dw)	((unsigned short)(dw))
 #define HIWORD(dw)	((unsigned short)(((unsigned int) (dw) >> 16) & 0xFFFF))
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 9295113..5680fb0 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -437,7 +437,7 @@ static void stor_vsc_on_channel_callback(void *context)
 	struct storvsc_device *stor_device;
 	u32 bytes_recvd;
 	u64 request_id;
-	unsigned char packet[ALIGN_UP(sizeof(struct vstor_packet), 8)];
+	unsigned char packet[ALIGN(sizeof(struct vstor_packet), 8)];
 	struct storvsc_request_extension *request;
 	int ret;
 
@@ -452,7 +452,7 @@ static void stor_vsc_on_channel_callback(void *context)
 
 	do {
 		ret = vmbus_recvpacket(device->channel, packet,
-				       ALIGN_UP(sizeof(struct vstor_packet), 8),
+				       ALIGN(sizeof(struct vstor_packet), 8),
 				       &bytes_recvd, &request_id);
 		if (ret == 0 && bytes_recvd > 0) {
 			DPRINT_DBG(STORVSC, "receive %d bytes - tid %llx",
@@ -802,7 +802,7 @@ int stor_vsc_initialize(struct hv_driver *driver)
 	 */
 	stor_driver->max_outstanding_req_per_channel =
 		((stor_driver->ring_buffer_size - PAGE_SIZE) /
-		  ALIGN_UP(MAX_MULTIPAGE_BUFFER_PACKET +
+		  ALIGN(MAX_MULTIPAGE_BUFFER_PACKET +
 			   sizeof(struct vstor_packet) + sizeof(u64),
 			   sizeof(u64)));
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 17f1b34..7651ca2 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -434,7 +434,7 @@ static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
 	struct scatterlist *bounce_sgl;
 	struct page *page_buf;
 
-	num_pages = ALIGN_UP(len, PAGE_SIZE) >> PAGE_SHIFT;
+	num_pages = ALIGN(len, PAGE_SIZE) >> PAGE_SHIFT;
 
 	bounce_sgl = kcalloc(num_pages, sizeof(struct scatterlist), GFP_ATOMIC);
 	if (!bounce_sgl)
@@ -720,7 +720,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 			}
 
 			cmd_request->bounce_sgl_count =
-				ALIGN_UP(scsi_bufflen(scmnd), PAGE_SIZE) >>
+				ALIGN(scsi_bufflen(scmnd), PAGE_SIZE) >>
 					PAGE_SHIFT;
 
 			/*
-- 
1.7.2.3

