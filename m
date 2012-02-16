Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2BPWBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:01:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37909 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab2BPWA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:00:59 -0500
From: Ben Collins <bcollins@ubuntu.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: UDLFB: Add module_param to allow forcing pixel_limit
Date: Thu, 16 Feb 2012 17:00:54 -0500
Message-Id: <60F6BCE2-4810-4F6D-92EF-482790BF0199@ubuntu.com>
Cc: libdlo <libdlo@lists.freedesktop.org>,
        Bernie Thompson <bernie@plugable.com>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1257)
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices may have bad vendor descriptors. This allows the user to set
a pixel limit that matches their specific device. The default was the
maximum (DL-195) which allowed bad modes to be set for lower level
devices (DL-115, etc).

Optionally, I considered setting the default pixel_limit to 700000
(DL-115), but figured this was OK instead.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>

diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 0319593..debb029 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -72,6 +72,7 @@ MODULE_DEVICE_TABLE(usb, id_table);
 static bool console = 1; /* Allow fbcon to open framebuffer */
 static bool fb_defio = 1;  /* Detect mmap writes using page faults */
 static bool shadow = 1; /* Optionally disable shadow framebuffer */
+static int pixel_limit; /* Optionally force a pixel limit (for bad vendor descriptors) */
 
 /* dlfb keeps a list of urbs for efficient bulk transfers */
 static void dlfb_urb_completion(struct urb *urb);
@@ -1546,9 +1547,15 @@ static int dlfb_parse_vendor_descriptor(struct dlfb_data *dev,
 			case 0x0200: { /* max_area */
 				u32 max_area;
 				max_area = le32_to_cpu(*((u32 *)desc));
-				pr_warn("DL chip limited to %d pixel modes\n",
-					max_area);
-				dev->sku_pixel_limit = max_area;
+				if (!pixel_limit) {
+					pr_warn("DL chip limited to %d pixel"
+						" modes\n", max_area);
+					dev->sku_pixel_limit = max_area;
+				} else {
+					pr_warn("DL chip limit of %d overriden"
+						" by module param to %d\n",
+						max_area, pixel_limit);
+				}
 				break;
 			}
 			default:
@@ -1605,8 +1612,12 @@ static int dlfb_usb_probe(struct usb_interface *interface,
 	pr_info("console enable=%d\n", console);
 	pr_info("fb_defio enable=%d\n", fb_defio);
 	pr_info("shadow enable=%d\n", shadow);
+	pr_info("pixel_limit=%d\n", pixel_limit);
 
-	dev->sku_pixel_limit = 2048 * 1152; /* default to maximum */
+	if (pixel_limit)
+		dev->sku_pixel_limit = pixel_limit;
+	else
+		dev->sku_pixel_limit = 2048 * 1152; /* default to maximum */
 
 	if (!dlfb_parse_vendor_descriptor(dev, interface)) {
 		pr_err("firmware not recognized. Assume incompatible device\n");
@@ -1948,6 +1959,9 @@ MODULE_PARM_DESC(fb_defio, "Page fault detection of mmap writes");
 module_param(shadow, bool, S_IWUSR | S_IRUSR | S_IWGRP | S_IRGRP);
 MODULE_PARM_DESC(shadow, "Shadow vid mem. Disable to save mem but lose perf");
 
+module_param(pixel_limit, int, S_IWUSR | S_IRUSR | S_IWGRP | S_IRGRP);
+MODULE_PARM_DESC(pixel_limit, "Pixel limit (700000 minimum for DL-115, 2360000 maximum for DL-195)");
+
 MODULE_AUTHOR("Roberto De Ioris <roberto@unbit.it>, "
 	      "Jaya Kumar <jayakumar.lkml@gmail.com>, "
 	      "Bernie Thompson <bernie@plugable.com>");

--
Bluecherry: http://www.bluecherrydvr.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

