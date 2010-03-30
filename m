Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab0CaAEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:04:53 -0400
Received: from kroah.org ([198.145.64.141]:45286 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820Ab0C3XSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:31 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:45 2010
Message-Id: <20100330225645.149576437@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [072/116] usb: r8a66597-hcd: fix removed from an attached hub
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>

commit d835933436ac0d1e8f5b35fe809fd4e767e55d6e upstream.

fix the problem that when a USB hub is attached to the r8a66597-hcd and
a device is removed from that hub, it's likely that a kernel panic follows.

Reported-by: Markus Pietrek <Markus.Pietrek@emtrion.de>
Signed-off-by: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/r8a66597-hcd.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -418,7 +418,7 @@ static u8 alloc_usb_address(struct r8a66
 
 /* this function must be called with interrupt disabled */
 static void free_usb_address(struct r8a66597 *r8a66597,
-			     struct r8a66597_device *dev)
+			     struct r8a66597_device *dev, int reset)
 {
 	int port;
 
@@ -430,7 +430,13 @@ static void free_usb_address(struct r8a6
 	dev->state = USB_STATE_DEFAULT;
 	r8a66597->address_map &= ~(1 << dev->address);
 	dev->address = 0;
-	dev_set_drvdata(&dev->udev->dev, NULL);
+	/*
+	 * Only when resetting USB, it is necessary to erase drvdata. When
+	 * a usb device with usb hub is disconnect, "dev->udev" is already
+	 * freed on usb_desconnect(). So we cannot access the data.
+	 */
+	if (reset)
+		dev_set_drvdata(&dev->udev->dev, NULL);
 	list_del(&dev->device_list);
 	kfree(dev);
 
@@ -1067,7 +1073,7 @@ static void r8a66597_usb_disconnect(stru
 	struct r8a66597_device *dev = r8a66597->root_hub[port].dev;
 
 	disable_r8a66597_pipe_all(r8a66597, dev);
-	free_usb_address(r8a66597, dev);
+	free_usb_address(r8a66597, dev, 0);
 
 	start_root_hub_sampling(r8a66597, port, 0);
 }
@@ -2085,7 +2091,7 @@ static void update_usb_address_map(struc
 				spin_lock_irqsave(&r8a66597->lock, flags);
 				dev = get_r8a66597_device(r8a66597, addr);
 				disable_r8a66597_pipe_all(r8a66597, dev);
-				free_usb_address(r8a66597, dev);
+				free_usb_address(r8a66597, dev, 0);
 				put_child_connect_map(r8a66597, addr);
 				spin_unlock_irqrestore(&r8a66597->lock, flags);
 			}
@@ -2228,7 +2234,7 @@ static int r8a66597_hub_control(struct u
 			rh->port |= (1 << USB_PORT_FEAT_RESET);
 
 			disable_r8a66597_pipe_all(r8a66597, dev);
-			free_usb_address(r8a66597, dev);
+			free_usb_address(r8a66597, dev, 1);
 
 			r8a66597_mdfy(r8a66597, USBRST, USBRST | UACT,
 				      get_dvstctr_reg(port));


