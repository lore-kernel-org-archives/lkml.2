Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965774Ab2EOCSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:49409 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964918Ab2EOCQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 061/179] USB: xhci - fix interval calculation for FS isoc endpoints
Date: Mon, 14 May 2012 22:12:37 -0400
Message-ID: <1337048075-6132-62-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@vmware.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cd3c18ba2fac14b34d03cae111f215009735ea06 upstream.

Full-speed isoc endpoints specify interval in exponent based form in
frames, not microframes, so we need to adjust accordingly.

NEC xHCI host controllers will return an error code of 0x11 if a full
speed isochronous endpoint is added with the Interval field set to
something less than 3 (2^3 = 8 microframes, or one frame).  It is
impossible for a full speed device to have an interval smaller than one
frame.

This was always an issue in the xHCI driver, but commit
dfa49c4ad120a784ef1ff0717168aa79f55a483a "USB: xhci - fix math in
xhci_get_endpoint_interval()" removed the clamping of the minimum value
in the Interval field, which revealed this bug.

This needs to be backported to stable kernels back to 2.6.31.

Reported-by: Matt Evans <matt@ozlabs.org>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/xhci-mem.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 05b5c34..727ac40 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -533,9 +533,19 @@ static unsigned int xhci_parse_exponent_interval(struct usb_device *udev,
 	interval = clamp_val(ep->desc.bInterval, 1, 16) - 1;
 	if (interval != ep->desc.bInterval - 1)
 		dev_warn(&udev->dev,
-			 "ep %#x - rounding interval to %d microframes\n",
+			 "ep %#x - rounding interval to %d %sframes\n",
 			 ep->desc.bEndpointAddress,
-			 1 << interval);
+			 1 << interval,
+			 udev->speed == USB_SPEED_FULL ? "" : "micro");
+
+	if (udev->speed == USB_SPEED_FULL) {
+		/*
+		 * Full speed isoc endpoints specify interval in frames,
+		 * not microframes. We are using microframes everywhere,
+		 * so adjust accordingly.
+		 */
+		interval += 3;	/* 1 frame = 2^3 uframes */
+	}
 
 	return interval;
 }
-- 
1.7.9.6

