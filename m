Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2L1TRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:17:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55044 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171Ab2L1TR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:27 -0500
Message-Id: <20121228190359.855077542@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [ 150/173] USB: cdc-wdm: fix regression on buffer deallocation
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

[ no commit upstream, since usb_alloc_coherent usage was removed from
  the driver before this was fixed ]

Commit cafbe85 ("USB: cdc-wdm: better allocate a buffer that is at least
as big as we tell the USB core") introduced a regression: it changed
the size used in usb_alloc_coherent, but failed to do the same for the
usb_free_coherent calls.

It also was marked for stable and got backported to older kernels. But
in the upstream kernel, the usage of usb_alloc_coherent was right after
removed from the driver, so upstream doesn't have this problem, while
the stable kernels still have, and thus need this fix.

BugLink: https://bugs.launchpad.net/bugs/1074157
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-wdm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 9aaed0d..97b2c55 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -301,7 +301,7 @@ static void cleanup(struct wdm_device *desc)
 			  desc->sbuf,
 			  desc->validity->transfer_dma);
 	usb_free_coherent(interface_to_usbdev(desc->intf),
-			  desc->bMaxPacketSize0,
+			  desc->wMaxCommand,
 			  desc->inbuf,
 			  desc->response->transfer_dma);
 	kfree(desc->orq);
@@ -788,7 +788,7 @@ out:
 err3:
 	usb_set_intfdata(intf, NULL);
 	usb_free_coherent(interface_to_usbdev(desc->intf),
-			  desc->bMaxPacketSize0,
+			  desc->wMaxCommand,
 			desc->inbuf,
 			desc->response->transfer_dma);
 err2:


