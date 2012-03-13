Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab2CMAWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:47728 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637Ab2CMAWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dmitry Torokhov <dtor@vmware.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 075/196] USB: fix formatting of SuperSpeed endpoints in /proc/bus/usb/devices
Date: Mon, 12 Mar 2012 20:19:48 -0400
Message-Id: <1331598109-31424-30-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@vmware.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2868a2b1ba8f9c7f6c4170519ebb6c62934df70e upstream.

Isochronous and interrupt SuperSpeed endpoints use the same mechanisms
for decoding bInterval values as HighSpeed ones so adjust the code
accordingly.

Also bandwidth reservation for SuperSpeed matches highspeed, not
low/full speed.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/devices.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index 19bc03a..7013296 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -219,7 +219,7 @@ static char *usb_dump_endpoint_descriptor(int speed, char *start, char *end,
 		break;
 	case USB_ENDPOINT_XFER_INT:
 		type = "Int.";
-		if (speed == USB_SPEED_HIGH)
+		if (speed == USB_SPEED_HIGH || speed == USB_SPEED_SUPER)
 			interval = 1 << (desc->bInterval - 1);
 		else
 			interval = desc->bInterval;
@@ -227,7 +227,8 @@ static char *usb_dump_endpoint_descriptor(int speed, char *start, char *end,
 	default:	/* "can't happen" */
 		return start;
 	}
-	interval *= (speed == USB_SPEED_HIGH) ? 125 : 1000;
+	interval *= (speed == USB_SPEED_HIGH ||
+		     speed == USB_SPEED_SUPER) ? 125 : 1000;
 	if (interval % 1000)
 		unit = 'u';
 	else {
@@ -537,8 +538,9 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
 	if (level == 0) {
 		int	max;
 
-		/* high speed reserves 80%, full/low reserves 90% */
-		if (usbdev->speed == USB_SPEED_HIGH)
+		/* super/high speed reserves 80%, full/low reserves 90% */
+		if (usbdev->speed == USB_SPEED_HIGH ||
+		    usbdev->speed == USB_SPEED_SUPER)
 			max = 800;
 		else
 			max = FRAME_TIME_MAX_USECS_ALLOC;
-- 
1.7.9.3

