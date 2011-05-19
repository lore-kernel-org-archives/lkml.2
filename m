Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000Ab1ESSIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:08:31 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39584 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933939Ab1ESSI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:29 -0400
X-Sasl-enc: W9SDjnxO5CJbA6fXm3hAHO7wiApYCPt47GEsHtJM7O2U 1305828508
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:57 2011
Message-Id: <20110519180557.180377156@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [30/71] ipheth: Properly distinguish length and alignment in URBs and skbs
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit 9c412942a0bb19ba18f7bd939d42eff1e132a901 upstream.

The USB protocol this driver implements appears to require 2 bytes of
padding in front of each received packet.  This used to be equal to
the value of NET_IP_ALIGN on x86, so the driver abused that constant
and mostly worked, but this is no longer the case.  The driver also
mixed up the URB and packet lengths, resulting in 2 bytes of junk at
the end of the skb.

Introduce a private constant for the 2 bytes of padding; fix this
confusion and check for the under-length case.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/ipheth.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -65,6 +65,7 @@
 #define IPHETH_USBINTF_PROTO    1
 
 #define IPHETH_BUF_SIZE         1516
+#define IPHETH_IP_ALIGN		2	/* padding at front of URB */
 #define IPHETH_TX_TIMEOUT       (5 * HZ)
 
 #define IPHETH_INTFNUM          2
@@ -202,18 +203,21 @@ static void ipheth_rcvbulk_callback(stru
 		return;
 	}
 
-	len = urb->actual_length;
-	buf = urb->transfer_buffer;
+	if (urb->actual_length <= IPHETH_IP_ALIGN) {
+		dev->net->stats.rx_length_errors++;
+		return;
+	}
+	len = urb->actual_length - IPHETH_IP_ALIGN;
+	buf = urb->transfer_buffer + IPHETH_IP_ALIGN;
 
-	skb = dev_alloc_skb(NET_IP_ALIGN + len);
+	skb = dev_alloc_skb(len);
 	if (!skb) {
 		err("%s: dev_alloc_skb: -ENOMEM", __func__);
 		dev->net->stats.rx_dropped++;
 		return;
 	}
 
-	skb_reserve(skb, NET_IP_ALIGN);
-	memcpy(skb_put(skb, len), buf + NET_IP_ALIGN, len - NET_IP_ALIGN);
+	memcpy(skb_put(skb, len), buf, len);
 	skb->dev = dev->net;
 	skb->protocol = eth_type_trans(skb, dev->net);
 


