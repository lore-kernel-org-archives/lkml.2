Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1HXSW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:22:58 -0400
Received: from knuth.cs.hmc.edu ([134.173.42.100]:57725 "EHLO knuth.cs.hmc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab1HXSWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:22:55 -0400
Date: Wed, 24 Aug 2011 12:22:37 -0600
From: Adam Cozzette <acozzette@cs.hmc.edu>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>,
        edwin_rong <edwin_rong@realsil.com.cn>,
        wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] ums_realtek: do not use stack memory for DMA
Message-ID: <20110824182237.GC5450@[192.168.0.12]>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes rts51x_read_mem, rts51x_write_mem, and rts51x_read_status to
allocate temporary buffers with kmalloc. This way stack addresses are not used
for DMA when these functions call rts51x_bulk_transport.

Signed-off-by: Adam Cozzette <acozzette@cs.hmc.edu>
---
 realtek_cr.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 34adc4b..232167a 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -320,6 +320,11 @@ static int rts51x_read_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 {
 	int retval;
 	u8 cmnd[12] = { 0 };
+	u8 *buf;
+
+	buf = kmalloc(len, GFP_NOIO);
+	if (buf == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
 
 	US_DEBUGP("%s, addr = 0x%x, len = %d\n", __func__, addr, len);
 
@@ -331,10 +336,14 @@ static int rts51x_read_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 	cmnd[5] = (u8) len;
 
 	retval = rts51x_bulk_transport(us, 0, cmnd, 12,
-				       data, len, DMA_FROM_DEVICE, NULL);
-	if (retval != USB_STOR_TRANSPORT_GOOD)
+				       buf, len, DMA_FROM_DEVICE, NULL);
+	if (retval != USB_STOR_TRANSPORT_GOOD) {
+		kfree(buf);
 		return -EIO;
+	}
 
+	memcpy(data, buf, len);
+	kfree(buf);
 	return 0;
 }
 
@@ -342,6 +351,12 @@ static int rts51x_write_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 {
 	int retval;
 	u8 cmnd[12] = { 0 };
+	u8 *buf;
+
+	buf = kmalloc(len, GFP_NOIO);
+	if (buf == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
+	memcpy(buf, data, len);
 
 	US_DEBUGP("%s, addr = 0x%x, len = %d\n", __func__, addr, len);
 
@@ -353,7 +368,8 @@ static int rts51x_write_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 	cmnd[5] = (u8) len;
 
 	retval = rts51x_bulk_transport(us, 0, cmnd, 12,
-				       data, len, DMA_TO_DEVICE, NULL);
+				       buf, len, DMA_TO_DEVICE, NULL);
+	kfree(buf);
 	if (retval != USB_STOR_TRANSPORT_GOOD)
 		return -EIO;
 
@@ -365,6 +381,11 @@ static int rts51x_read_status(struct us_data *us,
 {
 	int retval;
 	u8 cmnd[12] = { 0 };
+	u8 *buf;
+
+	buf = kmalloc(len, GFP_NOIO);
+	if (buf == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
 
 	US_DEBUGP("%s, lun = %d\n", __func__, lun);
 
@@ -372,10 +393,14 @@ static int rts51x_read_status(struct us_data *us,
 	cmnd[1] = 0x09;
 
 	retval = rts51x_bulk_transport(us, lun, cmnd, 12,
-				       status, len, DMA_FROM_DEVICE, actlen);
-	if (retval != USB_STOR_TRANSPORT_GOOD)
+				       buf, len, DMA_FROM_DEVICE, actlen);
+	if (retval != USB_STOR_TRANSPORT_GOOD) {
+		kfree(buf);
 		return -EIO;
+	}
 
+	memcpy(status, buf, len);
+	kfree(buf);
 	return 0;
 }
