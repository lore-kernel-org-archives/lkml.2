Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802Ab1KJDiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:38:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965079Ab1KJDir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:38:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:50 2011
Message-Id: <20111109213149.947003348@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Adam Cozzette <acozzette@cs.hmc.edu>
Subject: [078/264] ums_realtek: do not use stack memory for DMA
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Cozzette <acozzette@cs.hmc.edu>

commit 065e60964e293227e4feb0c1f7e27e609316ed9a upstream.

This patch changes rts51x_read_mem, rts51x_write_mem, and rts51x_read_status to
allocate temporary buffers with kmalloc. This way stack addresses are not used
for DMA when these functions call rts51x_bulk_transport.

Signed-off-by: Adam Cozzette <acozzette@cs.hmc.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/realtek_cr.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -320,6 +320,11 @@ static int rts51x_read_mem(struct us_dat
 {
 	int retval;
 	u8 cmnd[12] = { 0 };
+	u8 *buf;
+
+	buf = kmalloc(len, GFP_NOIO);
+	if (buf == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
 
 	US_DEBUGP("%s, addr = 0x%x, len = %d\n", __func__, addr, len);
 
@@ -331,10 +336,14 @@ static int rts51x_read_mem(struct us_dat
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
 
@@ -342,6 +351,12 @@ static int rts51x_write_mem(struct us_da
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
 
@@ -353,7 +368,8 @@ static int rts51x_write_mem(struct us_da
 	cmnd[5] = (u8) len;
 
 	retval = rts51x_bulk_transport(us, 0, cmnd, 12,
-				       data, len, DMA_TO_DEVICE, NULL);
+				       buf, len, DMA_TO_DEVICE, NULL);
+	kfree(buf);
 	if (retval != USB_STOR_TRANSPORT_GOOD)
 		return -EIO;
 
@@ -365,6 +381,11 @@ static int rts51x_read_status(struct us_
 {
 	int retval;
 	u8 cmnd[12] = { 0 };
+	u8 *buf;
+
+	buf = kmalloc(len, GFP_NOIO);
+	if (buf == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
 
 	US_DEBUGP("%s, lun = %d\n", __func__, lun);
 
@@ -372,10 +393,14 @@ static int rts51x_read_status(struct us_
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
 


