Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2AWXqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:46:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab2AWXqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:46:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:42:03 2012
Message-Id: <20120123234203.473278078@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:41:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Robert Lukassen <robert.lukassen@tomtom.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [21/27] USB: Fix bad dma problem on WDM device disconnect
In-Reply-To: <20120123234224.GA19510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Lukassen <Robert.Lukassen@tomtom.com>

commit 878b753e32ca765cd346a5d3038d630178ec78ff upstream.
[ changed s/usb_free_coherent/usb_buffer_free/ for 2.6.32.x]

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
Signed-off-by: Bjørn Mork <bjorn@mork.no>

---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -277,7 +277,7 @@ static void cleanup(struct wdm_device *d
 			desc->sbuf,
 			desc->validity->transfer_dma);
 	usb_buffer_free(interface_to_usbdev(desc->intf),
-			desc->wMaxCommand,
+			desc->bMaxPacketSize0,
 			desc->inbuf,
 			desc->response->transfer_dma);
 	kfree(desc->orq);


