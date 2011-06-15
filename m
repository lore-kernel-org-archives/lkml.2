Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab1FPHjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:39:17 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40548 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab1FPHAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:35 -0400
X-Sasl-enc: dzQfwe9abmszqn9X9k1lYBP9cUbAnfb7Lmvzzxuew5HN 1308207634
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:31 2011
Message-Id: <20110616000231.329987767@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [24/89] zd1211rw: fix to work on OHCI
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit 59342f6a6bc35df623fb44784daa5e1077063b8f upstream.

zd1211 devices register 'EP 4 OUT' endpoint as Interrupt type on USB 2.0:

      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1

However on USB 1.1 endpoint becomes Bulk:

      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0

Commit 37939810b937aba830dd751291fcdc51cae1a6cb assumed that endpoint is
always interrupt type and changed usb_bulk_msg() calls to usb_interrupt_msg().

Problem here is that usb_bulk_msg() on interrupt endpoint selfcorrects the
call and changes requested pipe to interrupt type (see usb_bulk_msg).
However with usb_interrupt_msg() on bulk endpoint does not correct the
pipe type to bulk, but instead URB is submitted with interrupt type pipe.

So pre-2.6.39 used usb_bulk_msg() and therefore worked with both endpoint
types, however in 2.6.39 usb_interrupt_msg() with bulk endpoint causes
ohci_hcd to fail submitted URB instantly with -ENOSPC and preventing zd1211rw
from working with OHCI.

Fix this by detecting endpoint type and using correct endpoint/pipe types
for URB. Also fix asynchronous zd_usb_iowrite16v_async() to use right
URB type on 'EP 4 OUT'.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/zd1211rw/zd_usb.c |   53 ++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1533,6 +1533,31 @@ static void __exit usb_exit(void)
 module_init(usb_init);
 module_exit(usb_exit);
 
+static int zd_ep_regs_out_msg(struct usb_device *udev, void *data, int len,
+			      int *actual_length, int timeout)
+{
+	/* In USB 2.0 mode EP_REGS_OUT endpoint is interrupt type. However in
+	 * USB 1.1 mode endpoint is bulk. Select correct type URB by endpoint
+	 * descriptor.
+	 */
+	struct usb_host_endpoint *ep;
+	unsigned int pipe;
+
+	pipe = usb_sndintpipe(udev, EP_REGS_OUT);
+	ep = usb_pipe_endpoint(udev, pipe);
+	if (!ep)
+		return -EINVAL;
+
+	if (usb_endpoint_xfer_int(&ep->desc)) {
+		return usb_interrupt_msg(udev, pipe, data, len,
+					 actual_length, timeout);
+	} else {
+		pipe = usb_sndbulkpipe(udev, EP_REGS_OUT);
+		return usb_bulk_msg(udev, pipe, data, len, actual_length,
+				    timeout);
+	}
+}
+
 static int usb_int_regs_length(unsigned int count)
 {
 	return sizeof(struct usb_int_regs) + count * sizeof(struct reg_data);
@@ -1648,15 +1673,14 @@ int zd_usb_ioread16v(struct zd_usb *usb,
 
 	udev = zd_usb_to_usbdev(usb);
 	prepare_read_regs_int(usb);
-	r = usb_interrupt_msg(udev, usb_sndintpipe(udev, EP_REGS_OUT),
-			      req, req_len, &actual_req_len, 50 /* ms */);
+	r = zd_ep_regs_out_msg(udev, req, req_len, &actual_req_len, 50 /*ms*/);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
-			"error in usb_interrupt_msg(). Error number %d\n", r);
+			"error in zd_ep_regs_out_msg(). Error number %d\n", r);
 		goto error;
 	}
 	if (req_len != actual_req_len) {
-		dev_dbg_f(zd_usb_dev(usb), "error in usb_interrupt_msg()\n"
+		dev_dbg_f(zd_usb_dev(usb), "error in zd_ep_regs_out_msg()\n"
 			" req_len %d != actual_req_len %d\n",
 			req_len, actual_req_len);
 		r = -EIO;
@@ -1818,9 +1842,17 @@ int zd_usb_iowrite16v_async(struct zd_us
 		rw->value = cpu_to_le16(ioreqs[i].value);
 	}
 
-	usb_fill_int_urb(urb, udev, usb_sndintpipe(udev, EP_REGS_OUT),
-			 req, req_len, iowrite16v_urb_complete, usb,
-			 ep->desc.bInterval);
+	/* In USB 2.0 mode endpoint is interrupt type. However in USB 1.1 mode
+	 * endpoint is bulk. Select correct type URB by endpoint descriptor.
+	 */
+	if (usb_endpoint_xfer_int(&ep->desc))
+		usb_fill_int_urb(urb, udev, usb_sndintpipe(udev, EP_REGS_OUT),
+				 req, req_len, iowrite16v_urb_complete, usb,
+				 ep->desc.bInterval);
+	else
+		usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_REGS_OUT),
+				  req, req_len, iowrite16v_urb_complete, usb);
+
 	urb->transfer_flags |= URB_FREE_BUFFER;
 
 	/* Submit previous URB */
@@ -1924,15 +1956,14 @@ int zd_usb_rfwrite(struct zd_usb *usb, u
 	}
 
 	udev = zd_usb_to_usbdev(usb);
-	r = usb_interrupt_msg(udev, usb_sndintpipe(udev, EP_REGS_OUT),
-			      req, req_len, &actual_req_len, 50 /* ms */);
+	r = zd_ep_regs_out_msg(udev, req, req_len, &actual_req_len, 50 /*ms*/);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
-			"error in usb_interrupt_msg(). Error number %d\n", r);
+			"error in zd_ep_regs_out_msg(). Error number %d\n", r);
 		goto out;
 	}
 	if (req_len != actual_req_len) {
-		dev_dbg_f(zd_usb_dev(usb), "error in usb_interrupt_msg()"
+		dev_dbg_f(zd_usb_dev(usb), "error in zd_ep_regs_out_msg()"
 			" req_len %d != actual_req_len %d\n",
 			req_len, actual_req_len);
 		r = -EIO;


