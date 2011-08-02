Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1HBFEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 01:04:20 -0400
Received: from knuth.cs.hmc.edu ([134.173.42.100]:36429 "EHLO knuth.cs.hmc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1HBFEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 01:04:15 -0400
Date: Mon, 1 Aug 2011 23:04:11 -0600
From: Adam Cozzette <acozzette@cs.hmc.edu>
To: Josh Boyer <jwboyer@redhat.com>
Cc: edwin_rong <edwin_rong@realsil.com.cn>, wwang <wei_wang@realsil.com.cn>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ums-realtek driver uses stack memory for DMA
Message-ID: <20110802050411.GC3857@[192.168.0.12]>
References: <20110801210905.GC2096@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110801210905.GC2096@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 05:09:06PM -0400, Josh Boyer wrote:
> Hello,
> 
> We have a report that the ums-realtek driver is generating a backtrace
> due to using stack variables for DMA buffers.  The backtrace is below
> and you can view the bug report here:
> https://bugzilla.redhat.com/show_bug.cgi?id=720054
> 
> Looking through the code, it seems that every call to rts51x_read_mem,
> rts51x_write_mem, and rts51x_read_status passes a stack variable to
> rts51x_bulk_transport, which then calls usb_stor_bulk_transfer_buf with
> this and generates the backtrace.  It is my understanding that the
> driver should be passing variables that are not on the stack and have
> been allocated with memory that will be suitable for the DMA api (e.g.
> kmalloc).
> 
> Was this missed during the initial review and is anyone working on
> adapting the driver to be compliant?

Could you try out this patch if it looks ok to you? I have not tested it because
unfortunately I don't have the hardware. Right now it generates some compile
warnings like this one:

drivers/usb/storage/realtek_cr.c:419:40: warning: ‘buf[0]’ may be used uninitialized in this function [-Wuninitialized]

It think they are harmless but I didn't see an obvious way to get rid of them,
so if you have any suggestions I would be glad to hear them.

This patch changed rts51x_read_mem, rts51x_write_mem, and rts51x_read_status to
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
 
