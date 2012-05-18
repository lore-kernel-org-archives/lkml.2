Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031166Ab2ERDJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:09:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40415 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762523Ab2ERCw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:29 -0400
Message-Id: <20120518023255.712118438@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ingo van Lil <inguin@gmx.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 10/53] asix: Fix tx transfer padding for full-speed USB
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo van Lil <inguin@gmx.de>

[ Upstream commit 2a5809499e35b53a6044fd34e72b242688b7a862 ]

The asix.c USB Ethernet driver avoids ending a tx transfer with a zero-
length packet by appending a four-byte padding to transfers whose length
is a multiple of maxpacket. However, the hard-coded 512 byte maxpacket
length is valid for high-speed USB only; full-speed USB uses 64 byte
packets.

Signed-off-by: Ingo van Lil <inguin@gmx.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/asix.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index fda4be2..a9abee8 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -403,7 +403,7 @@ static struct sk_buff *asix_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	u32 packet_len;
 	u32 padbytes = 0xffff0000;
 
-	padlen = ((skb->len + 4) % 512) ? 0 : 4;
+	padlen = ((skb->len + 4) & (dev->maxpacket - 1)) ? 0 : 4;
 
 	if ((!skb_cloned(skb)) &&
 	    ((headroom + tailroom) >= (4 + padlen))) {
@@ -425,7 +425,7 @@ static struct sk_buff *asix_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	cpu_to_le32s(&packet_len);
 	skb_copy_to_linear_data(skb, &packet_len, sizeof(packet_len));
 
-	if ((skb->len % 512) == 0) {
+	if (padlen) {
 		cpu_to_le32s(&padbytes);
 		memcpy(skb_tail_pointer(skb), &padbytes, sizeof(padbytes));
 		skb_put(skb, sizeof(padbytes));
-- 
1.7.10.1




