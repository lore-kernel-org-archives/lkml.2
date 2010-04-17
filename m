Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0DQMiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 08:38:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:53677 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0DQMiJ (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 08:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:x-url:x-pgp-fp:x-pgp:date:message-id
         :user-agent:mime-version:content-type;
        b=e52iY3VEluwdUxM1YtOx9m5T7TwucvnbZoz2HVlJIHUHjZzfsxvzb1mD3tpGkjgvn+
         izrTemMW2inDrqRGQDzECw/EeMYjq5rEVI/nti3K2g6Qifk074jT+j418dXtTsjfqVii
         XQxcDSLAJvKcgsxedSUOvDkE5NOFgRKmBFfho=
From: Michal Nazarewicz <mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] usb: core: config.c: use buffer on stack rather then on heap
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Sat, 17 Apr 2010 14:38:02 +0200
Message-ID: <871veecl05.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_get_configuration() uses a temporary buffer allocated on heap
to read USB configuration descriptor.  The buffer is just nine
bytes an so it is a waste to allocate it on heap where it can be
allocated on stack with the rest of local variables.  This
simplifies the code and minimises memory usage.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/core/config.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 0d3af6a..78d3f87 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -722,13 +722,12 @@ int usb_get_configuration(struct usb_device *dev)
 	int ncfg = dev->descriptor.bNumConfigurations;
 	int result = 0;
 	unsigned int cfgno, length;
-	unsigned char *buffer;
 	unsigned char *bigbuffer;
-	struct usb_config_descriptor *desc;
+	struct usb_config_descriptor desc;
 
 	cfgno = 0;
 	if (dev->authorized == 0)	/* Not really an error */
-		goto out_not_authorized;
+		goto err;
 	result = -ENOMEM;
 	if (ncfg > USB_MAXCONFIG) {
 		dev_warn(ddev, "too many configurations: %d, "
@@ -751,17 +750,12 @@ int usb_get_configuration(struct usb_device *dev)
 	if (!dev->rawdescriptors)
 		goto err2;
 
-	buffer = kmalloc(USB_DT_CONFIG_SIZE, GFP_KERNEL);
-	if (!buffer)
-		goto err2;
-	desc = (struct usb_config_descriptor *)buffer;
-
 	result = 0;
 	for (; cfgno < ncfg; cfgno++) {
 		/* We grab just the first descriptor so we know how long
 		 * the whole configuration is */
 		result = usb_get_descriptor(dev, USB_DT_CONFIG, cfgno,
-		    buffer, USB_DT_CONFIG_SIZE);
+		    &desc, USB_DT_CONFIG_SIZE);
 		if (result < 0) {
 			dev_err(ddev, "unable to read config index %d "
 			    "descriptor/%s: %d\n", cfgno, "start", result);
@@ -775,7 +769,7 @@ int usb_get_configuration(struct usb_device *dev)
 			result = -EINVAL;
 			goto err;
 		}
-		length = max((int) le16_to_cpu(desc->wTotalLength),
+		length = max((int) le16_to_cpu(desc.wTotalLength),
 		    USB_DT_CONFIG_SIZE);
 
 		/* Now that we know the length, get the whole thing */
@@ -810,8 +804,6 @@ int usb_get_configuration(struct usb_device *dev)
 	result = 0;
 
 err:
-	kfree(buffer);
-out_not_authorized:
 	dev->descriptor.bNumConfigurations = cfgno;
 err2:
 	if (result == -ENOMEM)
-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
