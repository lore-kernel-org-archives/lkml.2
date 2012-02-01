Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab2BAVqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:46:54 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43355 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932432Ab2BAVIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:54 -0500
X-Sasl-enc: /vvlrg4iXOYW9fTRDOq+BYSVHIbJF60AlL8Im89Vh/ep 1328130533
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:41 2012
Message-Id: <20120201205741.669375656@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [48/65] USB: cdc-wdm: Avoid hanging on interface with no USB_CDC_DMM_TYPE
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 15699e6fafc3a90e5fdc2ef30555a04dee62286f upstream.

The probe does not strictly require the USB_CDC_DMM_TYPE
descriptor, which is a good thing as it makes the driver
usable on non-conforming interfaces.  A user could e.g.
bind to it to a CDC ECM interface by using the new_id and
bind sysfs files.  But this would fail with a 0 buffer length
due to the missing descriptor.

Fix by defining a reasonable fallback size: The minimum
device receive buffer size required by the CDC WMC standard,
revision 1.1

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -57,6 +57,8 @@ MODULE_DEVICE_TABLE (usb, wdm_ids);
 
 #define WDM_MAX			16
 
+/* CDC-WMC r1.1 requires wMaxCommand to be "at least 256 decimal (0x100)" */
+#define WDM_DEFAULT_BUFSIZE	256
 
 static DEFINE_MUTEX(wdm_mutex);
 
@@ -636,7 +638,7 @@ static int wdm_probe(struct usb_interfac
 	struct usb_cdc_dmm_desc *dmhd;
 	u8 *buffer = intf->altsetting->extra;
 	int buflen = intf->altsetting->extralen;
-	u16 maxcom = 0;
+	u16 maxcom = WDM_DEFAULT_BUFSIZE;
 
 	if (!buffer)
 		goto out;


