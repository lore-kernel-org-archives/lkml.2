Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab0CaA2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:28:52 -0400
Received: from kroah.org ([198.145.64.141]:48903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab0C3XMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:20 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:28 2010
Message-Id: <20100330225827.532233393@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oliver@neukum.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [31/89] USB: Dont use GFP_KERNEL while we cannot reset a storage device
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit acbe2febe71abb2360b008e9ab3ee5c44169f78c upstream.

Memory allocations with GFP_KERNEL can cause IO to a storage
device which can fail resulting in a need to reset the device.
Therefore GFP_KERNEL cannot be safely used between usb_lock_device()
and usb_unlock_device(). Replace by GFP_NOIO.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devices.c |    2 +-
 drivers/usb/core/message.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -494,7 +494,7 @@ static ssize_t usb_device_dump(char __us
 		return 0;
 	/* allocate 2^1 pages = 8K (on i386);
 	 * should be more than enough for one device */
-	pages_start = (char *)__get_free_pages(GFP_KERNEL, 1);
+	pages_start = (char *)__get_free_pages(GFP_NOIO, 1);
 	if (!pages_start)
 		return -ENOMEM;
 
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -923,11 +923,11 @@ char *usb_cache_string(struct usb_device
 	if (index <= 0)
 		return NULL;
 
-	buf = kmalloc(MAX_USB_STRING_SIZE, GFP_KERNEL);
+	buf = kmalloc(MAX_USB_STRING_SIZE, GFP_NOIO);
 	if (buf) {
 		len = usb_string(udev, index, buf, MAX_USB_STRING_SIZE);
 		if (len > 0) {
-			smallbuf = kmalloc(++len, GFP_KERNEL);
+			smallbuf = kmalloc(++len, GFP_NOIO);
 			if (!smallbuf)
 				return buf;
 			memcpy(smallbuf, buf, len);
@@ -1694,7 +1694,7 @@ int usb_set_configuration(struct usb_dev
 	if (cp) {
 		nintf = cp->desc.bNumInterfaces;
 		new_interfaces = kmalloc(nintf * sizeof(*new_interfaces),
-				GFP_KERNEL);
+				GFP_NOIO);
 		if (!new_interfaces) {
 			dev_err(&dev->dev, "Out of memory\n");
 			return -ENOMEM;
@@ -1703,7 +1703,7 @@ int usb_set_configuration(struct usb_dev
 		for (; n < nintf; ++n) {
 			new_interfaces[n] = kzalloc(
 					sizeof(struct usb_interface),
-					GFP_KERNEL);
+					GFP_NOIO);
 			if (!new_interfaces[n]) {
 				dev_err(&dev->dev, "Out of memory\n");
 				ret = -ENOMEM;


