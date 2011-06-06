Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab1FFNkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:40:37 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42272 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457Ab1FFNkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:40:00 -0400
Message-ID: <4DECD8AB.3030904@secunet.com>
Date: Mon, 06 Jun 2011 15:39:55 +0200
From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, Matthias Urlichs <smurf@smurf.noris.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH] USB: option Add blacklist for ZTE K3765-Z (19d2:2002)
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2011 13:39:55.0801 (UTC) FILETIME=[38A14090:01CC244F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The funtion option_send_status times out when sending USB messages
to the interfaces 0, 1, and 2 of this UMTS stick. This results in a
5s timeout in the function causing other tty operations to feel very
sluggish.

This patch adds a blacklist entry for these 3 interfaces on the ZTE
K3765-Z device.

I was also able to reproduce the problem with v2.6.38 and v2.6.39.

This is very similar to a problem fixed in

commit 7a89e4cb9cdaba92f5fbc509945cf4e3c48db4e2
Author: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date:   Wed Mar 9 09:19:48 2011 +0000

    USB: serial: option: Apply OPTION_BLACKLIST_SENDSETUP also for ZTE MF626

Signed-off-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Cc: stable <stable@kernel.org>
---
 drivers/usb/serial/option.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 318dd00..b9a31b2 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -432,6 +432,13 @@ static const struct option_blacklist_info four_g_w14_blacklist = {
 	.reason = OPTION_BLACKLIST_SENDSETUP
 };
 
+static const u8 zte_k3765_z_no_sendsetup[] = { 0, 1, 2 };
+static const struct option_blacklist_info zte_k3765_z_blacklist = {
+	.infolen = ARRAY_SIZE(zte_k3765_z_no_sendsetup),
+	.ifaceinfo = zte_k3765_z_no_sendsetup,
+	.reason = OPTION_BLACKLIST_SENDSETUP
+};
+
 static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -916,7 +923,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0073, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0130, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0141, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2002, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2002, 0xff,
+	  0xff, 0xff), .driver_info = (kernel_ulong_t)&zte_k3765_z_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x2003, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },
-- 
1.7.2.5

