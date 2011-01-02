Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1ABH3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:29:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:37195 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab1ABHZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 252/260] USB: disable endpoints after unbinding interfaces, not before
Date: Sun,  2 Jan 2011 02:19:08 -0500
Message-Id: <1293952756-15010-253-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:45.0089 (UTC) FILETIME=[212BF110:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 80f0cf3947889014d3a3dc0ad60fb87cfda4b12a upstream.

This patch (as1430) fixes a bug in usbcore.  When a device
configuration change occurs or a device is removed, the endpoints for
the old config should be completely disabled.  However it turns out
they aren't; this is because usb_unbind_interface() calls
usb_enable_interface() or usb_set_interface() to put interfaces back
in altsetting 0, which re-enables the interfaces' endpoints.

As a result, when a device goes through a config change or is
unconfigured, the ep_in[] and ep_out[] arrays may be left holding old
pointers to usb_host_endpoint structures.  If the device is
deauthorized these structures get freed, and the stale pointers cause
errors when the the device is eventually unplugged.

The solution is to disable the endpoints after unbinding the
interfaces instead of before.  This isn't as large a change as it
sounds, since usb_unbind_interface() disables all the interface's
endpoints anyway before calling the driver's disconnect routine,
unless the driver claims to support "soft" unbind.

This fixes Bugzilla #19192.  Thanks to "Tom" Lei Ming for diagnosing
the underlying cause of the problem.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Carsten Sommer <carsten_sommer@ymail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/message.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index ad1f359..559deec 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1155,13 +1155,6 @@ void usb_disable_device(struct usb_device *dev, int skip_ep0)
 {
 	int i;
 
-	dev_dbg(&dev->dev, "%s nuking %s URBs\n", __func__,
-		skip_ep0 ? "non-ep0" : "all");
-	for (i = skip_ep0; i < 16; ++i) {
-		usb_disable_endpoint(dev, i, true);
-		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
-	}
-
 	/* getting rid of interfaces will disconnect
 	 * any drivers bound to them (a key side effect)
 	 */
@@ -1191,6 +1184,13 @@ void usb_disable_device(struct usb_device *dev, int skip_ep0)
 		if (dev->state == USB_STATE_CONFIGURED)
 			usb_set_device_state(dev, USB_STATE_ADDRESS);
 	}
+
+	dev_dbg(&dev->dev, "%s nuking %s URBs\n", __func__,
+		skip_ep0 ? "non-ep0" : "all");
+	for (i = skip_ep0; i < 16; ++i) {
+		usb_disable_endpoint(dev, i, true);
+		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
+	}
 }
 
 /**
-- 
1.7.3.3

