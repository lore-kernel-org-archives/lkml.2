Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871Ab2C3V4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:56:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965658Ab2C3VSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:18:34 -0400
Message-Id: <20120330194831.492878639@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josh Boyer <jwboyer@redhat.com>
Subject: [ 037/175] USB: ums_realtek: do not use stack memory for DMA in __do_config_autodelink
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit 4898e07174b79013afd2b422ef6c4336ef8e6783 upstream.

__do_config_autodelink passes the data variable to the transport function.
If the calling functions pass a stack variable, this will eventually trigger
a DMA-API debug backtrace for mapping stack memory in the DMA buffer.  Fix
this by calling kmemdup for the passed data instead.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/realtek_cr.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -507,9 +507,14 @@ static int __do_config_autodelink(struct
 {
 	int retval;
 	u8 cmnd[12] = {0};
+	u8 *buf;
 
 	US_DEBUGP("%s, addr = 0xfe47, len = %d\n", __FUNCTION__, len);
 
+	buf = kmemdup(data, len, GFP_NOIO);
+	if (!buf)
+		return USB_STOR_TRANSPORT_ERROR;
+
 	cmnd[0] = 0xF0;
 	cmnd[1] = 0x0E;
 	cmnd[2] = 0xfe;
@@ -517,7 +522,8 @@ static int __do_config_autodelink(struct
 	cmnd[4] = (u8)(len >> 8);
 	cmnd[5] = (u8)len;
 
-	retval = rts51x_bulk_transport_special(us, 0, cmnd, 12, data, len, DMA_TO_DEVICE, NULL);
+	retval = rts51x_bulk_transport_special(us, 0, cmnd, 12, buf, len, DMA_TO_DEVICE, NULL);
+	kfree(buf);
 	if (retval != USB_STOR_TRANSPORT_GOOD) {
 		return -EIO;
 	}


