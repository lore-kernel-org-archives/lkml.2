Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1HIPQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:16:36 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:40886 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab1HIPQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:16:35 -0400
Subject: [PATCH] [RFC] BTUSB: be quiet on device disconnect
From: Paul Bolle <pebolle@tiscali.nl>
To: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-bluetooth@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 17:16:28 +0200
Message-ID: <1312902988.1853.24.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabling the bluetooth usb device embedded in (some) ThinkPads tends to
lead to errors like these:
    btusb_bulk_complete: hci0 urb ffff88011b9bfd68 failed to resubmit (19)
    btusb_intr_complete: hci0 urb ffff88011b46a318 failed to resubmit (19)
    btusb_bulk_complete: hci0 urb ffff88011b46a000 failed to resubmit (19)

That is because usb_disconnect() doesn't "quiesces" pending urbs.

Disconnecting a device is a normal thing to happen so it's no big deal
that usb_submit_urb() returns -ENODEV. The simplest way to get rid of
these errors is to stop treating that return as an error. Trivial,
actually.

While we're at it, add comments to be explicit about the reasons we're
not complaining about -EPERM and -ENODEV.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This patch seems to put an end to a pet peeve of mine: the errors in
the logs of a ThinkPad when I disable its embedded bluetooth.

1) I added Greg and linux-usb@vger.kernel.org because usb_submit_urb()
doesn't specify the meaning of its negative return values. I traced
-EPERM to usb_hcd_link_urb_to_ep(). That returns -EPERM if the urb is
"being killed". Did I trace the calls made by usb_submit_urb()
correctly? I also just assumed that -ENODEV always means device got
disconnected or something comparable. Is that correct too?

2) Sent as an RFC because btusb's btusb_*_complete() functions puzzle
me. If I read their code correctly these three functions will be an
urb's completion handler when usb_submit_urb() is called on that urb.
This means they will be called when usb_submit_urb() is done doing its
stuff. But they themselves also call usb_submit_urb()! So, apparently,
there's this endless loop:
    usb_submit_urb()
        btusb_*_complete()
           usb_submit_urb()
               [...]

It seems that usb_submit_urb() returning -EPERM is the expected way for
this loop to end. Am I reading this correctly? If so, doesn't this need
some comments to explain that? But perhaps calling usb_submit_urb() in a
completion handler is a common pattern for usb devices.

 drivers/bluetooth/btusb.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 91d13a9..9e4448e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -256,7 +256,9 @@ static void btusb_intr_complete(struct urb *urb)
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
-		if (err != -EPERM)
+		/* -EPERM: urb is being killed;
+		 * -ENODEV: device got disconnected */
+		if (err != -EPERM && err != -ENODEV)
 			BT_ERR("%s urb %p failed to resubmit (%d)",
 						hdev->name, urb, -err);
 		usb_unanchor_urb(urb);
@@ -341,7 +343,9 @@ static void btusb_bulk_complete(struct urb *urb)
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
-		if (err != -EPERM)
+		/* -EPERM: urb is being killed;
+		 * -ENODEV: device got disconnected */
+		if (err != -EPERM && err != -ENODEV)
 			BT_ERR("%s urb %p failed to resubmit (%d)",
 						hdev->name, urb, -err);
 		usb_unanchor_urb(urb);
@@ -431,7 +435,9 @@ static void btusb_isoc_complete(struct urb *urb)
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
-		if (err != -EPERM)
+		/* -EPERM: urb is being killed;
+		 * -ENODEV: device got disconnected */
+		if (err != -EPERM && err != -ENODEV)
 			BT_ERR("%s urb %p failed to resubmit (%d)",
 						hdev->name, urb, -err);
 		usb_unanchor_urb(urb);
-- 
1.7.4.4

