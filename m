Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab1FPHfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:35:46 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47595 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755776Ab1FPHBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:04 -0400
X-Sasl-enc: icB8dyWEBxIqN3lR982KwTO3VvufB2dtrL6n4WscKGdK 1308207663
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:34 2011
Message-Id: <20110616000234.089119943@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dcbw@redhat.com>
Subject: [52/89] option: add Alcatel X200 to sendsetup blacklist
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 15badbcc8eede58b0d7e53a3acde1c90a7b6e40e upstream.

This modem really wants sendsetup blacklisted for interfaces 0 and 1,
otherwise the kernel hardlocks for about 10 seconds while waiting for
the modem's firmware to respond, which it of course doesn't do.

A slight complication here is that TCT (who owns the Alcatel brand) used
the same USB IDs for the X200 as the X060s despite the devices having
completely different firmware and AT command sets, so we end up adding
the X060s to the blacklist at the same time.  PSA to OEMs: don't use the
same USB IDs for different devices.  Really.  It makes your kittens cry.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -344,7 +344,7 @@ static void option_instat_callback(struc
 
 /* ALCATEL PRODUCTS */
 #define ALCATEL_VENDOR_ID			0x1bbb
-#define ALCATEL_PRODUCT_X060S			0x0000
+#define ALCATEL_PRODUCT_X060S_X200		0x0000
 
 #define PIRELLI_VENDOR_ID			0x1266
 #define PIRELLI_PRODUCT_C100_1			0x1002
@@ -435,6 +435,13 @@ static const struct option_blacklist_inf
 	.reason = OPTION_BLACKLIST_SENDSETUP
 };
 
+static const u8 alcatel_x200_no_sendsetup[] = { 0, 1 };
+static const struct option_blacklist_info alcatel_x200_blacklist = {
+	.infolen = ARRAY_SIZE(alcatel_x200_no_sendsetup),
+	.ifaceinfo = alcatel_x200_no_sendsetup,
+	.reason = OPTION_BLACKLIST_SENDSETUP
+};
+
 static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -939,7 +946,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_HSDPA_MINICARD ) }, /* Toshiba 3G HSDPA == Novatel Expedite EU870D MiniCard */
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S_X200),
+	  .driver_info = (kernel_ulong_t)&alcatel_x200_blacklist
+	},
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),


