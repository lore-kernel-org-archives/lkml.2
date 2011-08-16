Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1HPCwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:52:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1HPCwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:52:07 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:52 2011
Message-Id: <20110816024452.815380699@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:42:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matt Evans <matt@ozlabs.org>
Subject: [04/26] usb/config: use proper endian access for wMaxPacketSize
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 7de7c7d2cb49900e0b967be871bf695c7d6135c9 upstream.

wMaxPacketSize is __le16 and should be accessed as such. Also fix the
wBytesPerInterval assignment while here.

v2: also fix the wBytesPerInterval assigment, noticed by Matt Evans

This patch should be backported to the 3.0 kernel.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Matt Evans <matt@ozlabs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/config.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -123,10 +123,11 @@ static void usb_parse_ss_endpoint_compan
 	}
 
 	if (usb_endpoint_xfer_isoc(&ep->desc))
-		max_tx = ep->desc.wMaxPacketSize * (desc->bMaxBurst + 1) *
-			(desc->bmAttributes + 1);
+		max_tx = (desc->bMaxBurst + 1) * (desc->bmAttributes + 1) *
+			le16_to_cpu(ep->desc.wMaxPacketSize);
 	else if (usb_endpoint_xfer_int(&ep->desc))
-		max_tx = ep->desc.wMaxPacketSize * (desc->bMaxBurst + 1);
+		max_tx = le16_to_cpu(ep->desc.wMaxPacketSize) *
+			(desc->bMaxBurst + 1);
 	else
 		max_tx = 999999;
 	if (le16_to_cpu(desc->wBytesPerInterval) > max_tx) {
@@ -134,10 +135,10 @@ static void usb_parse_ss_endpoint_compan
 				"config %d interface %d altsetting %d ep %d: "
 				"setting to %d\n",
 				usb_endpoint_xfer_isoc(&ep->desc) ? "Isoc" : "Int",
-				desc->wBytesPerInterval,
+				le16_to_cpu(desc->wBytesPerInterval),
 				cfgno, inum, asnum, ep->desc.bEndpointAddress,
 				max_tx);
-		ep->ss_ep_comp.wBytesPerInterval = max_tx;
+		ep->ss_ep_comp.wBytesPerInterval = cpu_to_le16(max_tx);
 	}
 }
 


