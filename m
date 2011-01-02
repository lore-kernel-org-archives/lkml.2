Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1ABH0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:26:06 -0500
Received: from mail.windriver.com ([147.11.1.11]:37213 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab1ABH0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:26:01 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 254/260] USB: accept some invalid ep0-maxpacket values
Date: Sun,  2 Jan 2011 02:19:10 -0500
Message-Id: <1293952756-15010-255-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:47.0418 (UTC) FILETIME=[228F51A0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 56626a72a47bf3e50875d960d6b5f17b9bee0ab2 upstream.

A few devices (such as the RCA VR5220 voice recorder) are so
non-compliant with the USB spec that they have invalid maxpacket sizes
for endpoint 0.  Nevertheless, as long as we can safely use them, we
may as well do so.

This patch (as1432) softens our acceptance criterion by allowing
high-speed devices to have ep0-maxpacket sizes other than 64.  A
warning is printed in the system log when this happens, and the
existing error message is clarified.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: James <bjlockie@lockie.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/hub.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 3e28f92..5b63c45 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2848,13 +2848,16 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 	else
 		i = udev->descriptor.bMaxPacketSize0;
 	if (le16_to_cpu(udev->ep0.desc.wMaxPacketSize) != i) {
-		if (udev->speed != USB_SPEED_FULL ||
+		if (udev->speed == USB_SPEED_LOW ||
 				!(i == 8 || i == 16 || i == 32 || i == 64)) {
-			dev_err(&udev->dev, "ep0 maxpacket = %d\n", i);
+			dev_err(&udev->dev, "Invalid ep0 maxpacket: %d\n", i);
 			retval = -EMSGSIZE;
 			goto fail;
 		}
-		dev_dbg(&udev->dev, "ep0 maxpacket = %d\n", i);
+		if (udev->speed == USB_SPEED_FULL)
+			dev_dbg(&udev->dev, "ep0 maxpacket = %d\n", i);
+		else
+			dev_warn(&udev->dev, "Using ep0 maxpacket: %d\n", i);
 		udev->ep0.desc.wMaxPacketSize = cpu_to_le16(i);
 		usb_ep0_reinit(udev);
 	}
-- 
1.7.3.3

