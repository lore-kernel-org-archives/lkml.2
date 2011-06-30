Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1F3T3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:29:52 -0400
Received: from smtp.net4visions.de ([85.214.69.78]:41281 "EHLO
	smtp.net4visions.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1F3T3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:29:50 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jun 2011 15:29:49 EDT
X-Spam-Flag: NO
X-Spam-Score: 0.602
Message-ID: <4E0CCC80.4070701@tower-net.de>
Date: Thu, 30 Jun 2011 21:20:32 +0200
From: Markus Kolb <linux-201011@tower-net.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dbrownell@users.sourceforge.net
Subject: [PATCH] cdc_ether fix to support Samsung Galaxy S with Android 2.3.4
 again
Content-Type: multipart/mixed;
 boundary="------------090402070908000508040002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090402070908000508040002
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

cdc_ether uses currently the wrong bInterfaceNumber(s).
It uses CDC Union information for bMasterInterface and bSlaveInterface 
which seems to be wrong. At least there isn't any relation.
I don't know what would be the correct way but with my patch the driver 
supports the mobile phone again and there should be no malfunction with 
already supported hardware.
For a bug report see
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/796006


--------------090402070908000508040002
Content-Type: text/x-patch;
 name="Ubuntu_bug_796006.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Ubuntu_bug_796006.patch"

diff -ru linux-2.6.38/drivers/net/usb/cdc_ether.c linux-2.6.38.patched/drivers/net/usb/cdc_ether.c
--- linux-2.6.38/drivers/net/usb/cdc_ether.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38.patched/drivers/net/usb/cdc_ether.c	2011-06-30 18:48:29.749287600 +0200
@@ -86,6 +86,8 @@
 	struct usb_driver		*driver = driver_of(intf);
 	struct usb_cdc_mdlm_desc	*desc = NULL;
 	struct usb_cdc_mdlm_detail_desc *detail = NULL;
+	int				mapped_master;
+	int				mapped_slave;
 
 	if (sizeof dev->data < sizeof *info)
 		return -EDOM;
@@ -188,6 +190,24 @@
 						info->u->bMasterInterface0);
 			info->data = usb_ifnum_to_if(dev->udev,
 						info->u->bSlaveInterface0);
+			if ((!info->control || !info->data) 
+					&& (info->u->bMasterInterface0 > 0)) {
+				// try with mapping to start with 0
+				mapped_master = (info->u->bMasterInterface0 
+						- ((info->u->bSlaveInterface0 >
+						info->u->bMasterInterface0) ? 
+						info->u->bMasterInterface0 : 
+						info->u->bSlaveInterface0));
+				mapped_slave = (info->u->bSlaveInterface0 
+						- ((info->u->bSlaveInterface0 >
+						info->u->bMasterInterface0) ? 
+						info->u->bMasterInterface0 : 
+						info->u->bSlaveInterface0));
+				info->control = usb_ifnum_to_if(dev->udev,
+						mapped_master);
+				info->data = usb_ifnum_to_if(dev->udev,
+						mapped_slave);
+			}
 			if (!info->control || !info->data) {
 				dev_dbg(&intf->dev,
 					"master #%u/%p slave #%u/%p\n",

--------------090402070908000508040002--
