Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab1CZAQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:16:32 -0400
Received: from kroah.org ([198.145.64.141]:41825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab1CYXwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:43 2011
Message-Id: <20110325234842.953802871@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Lukassen <robert.lukassen@tomtom.com>
Subject: [38/55] USB: Fix bad dma problem on WDM device disconnect
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robert Lukassen <Robert.Lukassen@tomtom.com>

commit 878b753e32ca765cd346a5d3038d630178ec78ff upstream.

In the WDM class driver a disconnect event leads to calls to
usb_free_coherent to put back two USB DMA buffers allocated earlier.
The call to usb_free_coherent uses a different size parameter
(desc->wMaxCommand) than the corresponding call to usb_alloc_coherent
(desc->bMaxPacketSize0).

When a disconnect event occurs, this leads to 'bad dma' complaints
from usb core because the USB DMA buffer is being pushed back to the
'buffer-2048' pool from which it has not been allocated.

This patch against the most recent linux-2.6 kernel ensures that the
parameters used by usb_alloc_coherent & usb_free_coherent calls in
cdc-wdm.c match.

Signed-off-by: Robert Lukassen <robert.lukassen@tomtom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -281,7 +281,7 @@ static void cleanup(struct wdm_device *d
 			  desc->sbuf,
 			  desc->validity->transfer_dma);
 	usb_free_coherent(interface_to_usbdev(desc->intf),
-			  desc->wMaxCommand,
+			  desc->bMaxPacketSize0,
 			  desc->inbuf,
 			  desc->response->transfer_dma);
 	kfree(desc->orq);


