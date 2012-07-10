Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab2GJQT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:19:28 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:60728 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756158Ab2GJQT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:19:27 -0400
Message-ID: <1341937165.1762.10.camel@castor.rsk>
Subject: [PATCH] USB: remove 8 bytes of padding from usb_host_interface on
 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-usb <linux-usb@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jul 2012 17:19:25 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder elements in the usb_host_interface structure to remove 8 bytes
of padding on 64 bit builds , and so shrink it's size to 40 bytes.
    
usb_interface_descriptor is a odd size which leaves a gap that is not
big enough to hold a pointer, so moving extralen into that gap removes
the need for more padding.


Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---
patch against v3.5-rc6
compiled and tested on x86_64
I've been running this patch for several weeks with no obvious problems.
This will allow the usb_host_interface array to be a bit smaller and should
better align with the cachelines.

regards
Richard 




diff --git a/include/linux/usb.h b/include/linux/usb.h
index dea39dc..2abec02 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -77,14 +77,14 @@ struct usb_host_endpoint {
 struct usb_host_interface {
 	struct usb_interface_descriptor	desc;
 
+	int extralen;
+	unsigned char *extra;   /* Extra descriptors */
 	/* array of desc.bNumEndpoint endpoints associated with this
 	 * interface setting.  these will be in no particular order.
 	 */
 	struct usb_host_endpoint *endpoint;
 
 	char *string;		/* iInterface string, if present */
-	unsigned char *extra;   /* Extra descriptors */
-	int extralen;
 };
 
 enum usb_interface_condition {



