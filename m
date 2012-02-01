Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab2BAVUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:20:44 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46830 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757498Ab2BAVTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:46 -0500
X-Sasl-enc: oJsgpjpdEg9BzyJcgZa/1oo2qVZi0zrUohTE7Oup2V0Z 1328131186
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:49 2012
Message-Id: <20120201210049.869369826@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [68/89] USB: cdc-wdm: Avoid hanging on interface with no USB_CDC_DMM_TYPE
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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


