Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2AXTlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:41:20 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14478 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2AXTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:41:18 -0500
Date: Tue, 24 Jan 2012 20:41:20 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-mmc@vger.kernel.org, linux-usb@vger.kernel.org
cc: linux-kernel@vger.kernel.org,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        Chris Ball <cjb@laptop.org>, Greg Kroah-Hartman <greg@kroah.com>
Subject: [PATCH] MMC, vub300: Resolve mem leak in vub300_probe() and simplify
 the code a bit
Message-ID: <alpine.LNX.2.00.1201242037270.27508@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/mmc/host/vub300.c::vub300_probe() we need both
'command_out_urb' and 'command_res_urb'. Currently we fail to free the
former if allocating the latter fails. Fix that (and simplify the code
a bit at the same time) by just doing both allocations and if either
fails then free both - usb_free_urb() deals gracefully with NULL
pointers, so this is safe.

We also initialize 'retval' to '-ENOMEM' when we declare the variable,
so there's no reason to re-set it to '-ENOMEM' before jumping to
'error0:' when one of the initial usb_alloc_urb() calls fail().

Also rename the 'error*:' labels to be just 'error0' and 'error1'
rather than 'error[0145]'.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/mmc/host/vub300.c |   31 +++++++++++--------------------
 1 files changed, 11 insertions(+), 20 deletions(-)

 Note:
   I have no real way to actually test this patch, so it is compile tested 
   only. Please review carefully before applying.

 Note2:
   Please CC me on replies.

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 3135a1a..dc34455 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2116,23 +2116,16 @@ static int vub300_probe(struct usb_interface *interface,
 		 udev->descriptor.idVendor, udev->descriptor.idProduct,
 		 manufacturer, product, serial_number);
 	command_out_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!command_out_urb) {
-		retval = -ENOMEM;
-		dev_err(&udev->dev, "not enough memory for command_out_urb\n");
-		goto error0;
-	}
 	command_res_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!command_res_urb) {
-		retval = -ENOMEM;
-		dev_err(&udev->dev, "not enough memory for command_res_urb\n");
-		goto error1;
+	if (!command_res_urb || !command_out_urb) {
+		dev_err(&udev->dev, "not enough memory for command urbs\n");
+		goto error0;
 	}
 	/* this also allocates memory for our VUB300 mmc host device */
 	mmc = mmc_alloc_host(sizeof(struct vub300_mmc_host), &udev->dev);
 	if (!mmc) {
-		retval = -ENOMEM;
 		dev_err(&udev->dev, "not enough memory for the mmc_host\n");
-		goto error4;
+		goto error0;
 	}
 	/* MMC core transfer sizes tunable parameters */
 	mmc->caps = 0;
@@ -2285,7 +2278,7 @@ static int vub300_probe(struct usb_interface *interface,
 		dev_err(&vub300->udev->dev,
 		    "Could not find two sets of bulk-in/out endpoint pairs\n");
 		retval = -EINVAL;
-		goto error5;
+		goto error1;
 	}
 	retval =
 		usb_control_msg(vub300->udev, usb_rcvctrlpipe(vub300->udev, 0),
@@ -2294,14 +2287,14 @@ static int vub300_probe(struct usb_interface *interface,
 				0x0000, 0x0000, &vub300->hc_info,
 				sizeof(vub300->hc_info), HZ);
 	if (retval < 0)
-		goto error5;
+		goto error1;
 	retval =
 		usb_control_msg(vub300->udev, usb_rcvctrlpipe(vub300->udev, 0),
 				SET_ROM_WAIT_STATES,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				firmware_rom_wait_states, 0x0000, NULL, 0, HZ);
 	if (retval < 0)
-		goto error5;
+		goto error1;
 	dev_info(&vub300->udev->dev,
 		 "operating_mode = %s %s %d MHz %s %d byte USB packets\n",
 		 (mmc->caps & MMC_CAP_SDIO_IRQ) ? "IRQs" : "POLL",
@@ -2316,14 +2309,14 @@ static int vub300_probe(struct usb_interface *interface,
 				0x0000, 0x0000, &vub300->system_port_status,
 				sizeof(vub300->system_port_status), HZ);
 	if (retval < 0) {
-		goto error4;
+		goto error0;
 	} else if (sizeof(vub300->system_port_status) == retval) {
 		vub300->card_present =
 			(0x0001 & vub300->system_port_status.port_flags) ? 1 : 0;
 		vub300->read_only =
 			(0x0010 & vub300->system_port_status.port_flags) ? 1 : 0;
 	} else {
-		goto error4;
+		goto error0;
 	}
 	usb_set_intfdata(interface, vub300);
 	INIT_DELAYED_WORK(&vub300->pollwork, vub300_pollwork_thread);
@@ -2351,17 +2344,15 @@ static int vub300_probe(struct usb_interface *interface,
 			 interface_to_InterfaceNumber(interface));
 	mmc_add_host(mmc);
 	return 0;
-error5:
+error1:
 	mmc_free_host(mmc);
 	/*
 	 * and hence also frees vub300
 	 * which is contained at the end of struct mmc
 	 */
-error4:
+error0:
 	usb_free_urb(command_out_urb);
-error1:
 	usb_free_urb(command_res_urb);
-error0:
 	return retval;
 }
 
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

