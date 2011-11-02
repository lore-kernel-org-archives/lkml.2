Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934623Ab1KCBlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:41:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934585Ab1KCBl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:45 2011
Message-Id: <20111102222745.414999132@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Matthias Dellweg <2500@gmx.de>
Subject: [062/101] usb/core/devio.c: Check for printer class specific request
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Matthias Dellweg <2500@gmx.de>

commit 393cbb5151ecda9f9e14e3082d048dd27a1ff9f6 upstream.

In the usb printer class specific request get_device_id the value of
wIndex is (interface << 8 | altsetting) instead of just interface.
This enables the detection of some printers with libusb.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Matthias Dellweg <2500@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -601,9 +601,10 @@ static int findintfep(struct usb_device
 }
 
 static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
-			   unsigned int index)
+			   unsigned int request, unsigned int index)
 {
 	int ret = 0;
+	struct usb_host_interface *alt_setting;
 
 	if (ps->dev->state != USB_STATE_UNAUTHENTICATED
 	 && ps->dev->state != USB_STATE_ADDRESS
@@ -612,6 +613,19 @@ static int check_ctrlrecip(struct dev_st
 	if (USB_TYPE_VENDOR == (USB_TYPE_MASK & requesttype))
 		return 0;
 
+	/*
+	 * check for the special corner case 'get_device_id' in the printer
+	 * class specification, where wIndex is (interface << 8 | altsetting)
+	 * instead of just interface
+	 */
+	if (requesttype == 0xa1 && request == 0) {
+		alt_setting = usb_find_alt_setting(ps->dev->actconfig,
+						   index >> 8, index & 0xff);
+		if (alt_setting
+		 && alt_setting->desc.bInterfaceClass == USB_CLASS_PRINTER)
+			index >>= 8;
+	}
+
 	index &= 0xff;
 	switch (requesttype & USB_RECIP_MASK) {
 	case USB_RECIP_ENDPOINT:
@@ -760,7 +774,8 @@ static int proc_control(struct dev_state
 
 	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
 		return -EFAULT;
-	ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.wIndex);
+	ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.bRequest,
+			      ctrl.wIndex);
 	if (ret)
 		return ret;
 	wLength = ctrl.wLength;		/* To suppress 64k PAGE_SIZE warning */
@@ -1082,7 +1097,7 @@ static int proc_do_submiturb(struct dev_
 			kfree(dr);
 			return -EINVAL;
 		}
-		ret = check_ctrlrecip(ps, dr->bRequestType,
+		ret = check_ctrlrecip(ps, dr->bRequestType, dr->bRequest,
 				      le16_to_cpup(&dr->wIndex));
 		if (ret) {
 			kfree(dr);


