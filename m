Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab0H3V4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:56:31 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:44335 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab0H3V4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:56:21 -0400
Message-ID: <4C7C279C.507@simon.arlott.org.uk>
Date: Mon, 30 Aug 2010 22:50:20 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100605 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: [PATCH] USB: output an error message when the pipe type doesn't match
 the endpoint type
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f661c6f8c67bd55e93348f160d590ff9edf08904 adds a check of the pipe type if
CONFIG_USB_DEBUG is enabled, but it doesn't output anything if this scenario
occurs.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/core/urb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 419e6b3..c14fc08 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -401,8 +401,11 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
 	};
 
 	/* Check that the pipe's type matches the endpoint's type */
-	if (usb_pipetype(urb->pipe) != pipetypes[xfertype])
+	if (usb_pipetype(urb->pipe) != pipetypes[xfertype]) {
+		dev_err(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
+			usb_pipetype(urb->pipe), pipetypes[xfertype]);
 		return -EPIPE;		/* The most suitable error code :-) */
+	}
 
 	/* enforce simple/standard policy */
 	allowed = (URB_NO_TRANSFER_DMA_MAP | URB_NO_INTERRUPT | URB_DIR_MASK |
-- 
1.7.0.4
-- 
Simon Arlott
