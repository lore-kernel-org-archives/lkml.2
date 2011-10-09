Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1JIKMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 06:12:31 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:32904 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1JIKMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 06:12:24 -0400
Subject: [PATCH 2/2] Bluetooth: btusb: hide more usb_submit_urb errors
From: Paul Bolle <pebolle@tiscali.nl>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Oct 2011 12:12:22 +0200
Message-ID: <1318155142.1903.24.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are still three calls of usb_submit_urb() that will print errors
if those calls return -EPERM or -ENODEV. I have never triggered these,
so I'm not sure when these return values might be seen. It still makes
sense to be silent if these occur (since "urb is being killed" and
"device got disconnected" aren't things to worry about).

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/bluetooth/btusb.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3d1afe7..5816527 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -309,7 +309,8 @@ static int btusb_submit_intr_urb(struct hci_dev *hdev, gfp_t mem_flags)
 
 	err = usb_submit_urb(urb, mem_flags);
 	if (err < 0) {
-		BT_ERR("%s urb %p submission failed (%d)",
+		if (err != -EPERM && err != -ENODEV)
+			BT_ERR("%s urb %p submission failed (%d)",
 						hdev->name, urb, -err);
 		usb_unanchor_urb(urb);
 	}
@@ -394,7 +395,8 @@ static int btusb_submit_bulk_urb(struct hci_dev *hdev, gfp_t mem_flags)
 
 	err = usb_submit_urb(urb, mem_flags);
 	if (err < 0) {
-		BT_ERR("%s urb %p submission failed (%d)",
+		if (err != -EPERM && err != -ENODEV)
+			BT_ERR("%s urb %p submission failed (%d)",
 						hdev->name, urb, -err);
 		usb_unanchor_urb(urb);
 	}
@@ -517,7 +519,8 @@ static int btusb_submit_isoc_urb(struct hci_dev *hdev, gfp_t mem_flags)
 
 	err = usb_submit_urb(urb, mem_flags);
 	if (err < 0) {
-		BT_ERR("%s urb %p submission failed (%d)",
+		if (err != -EPERM && err != -ENODEV)
+			BT_ERR("%s urb %p submission failed (%d)",
 						hdev->name, urb, -err);
 		usb_unanchor_urb(urb);
 	}
-- 
1.7.4.4



