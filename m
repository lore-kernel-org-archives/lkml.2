Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981Ab2EJRq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:46:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760172Ab2EJRe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:28 -0400
Message-Id: <20120510173134.851728856@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ingo van Lil <inguin@gmx.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 22/52] asix: Fix tx transfer padding for full-speed USB
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/asix.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -403,7 +403,7 @@ static struct sk_buff *asix_tx_fixup(str
 	u32 packet_len;
 	u32 padbytes = 0xffff0000;
 
-	padlen = ((skb->len + 4) % 512) ? 0 : 4;
+	padlen = ((skb->len + 4) & (dev->maxpacket - 1)) ? 0 : 4;
 
 	if ((!skb_cloned(skb)) &&
 	    ((headroom + tailroom) >= (4 + padlen))) {
@@ -425,7 +425,7 @@ static struct sk_buff *asix_tx_fixup(str
 	cpu_to_le32s(&packet_len);
 	skb_copy_to_linear_data(skb, &packet_len, sizeof(packet_len));
 
-	if ((skb->len % 512) == 0) {
+	if (padlen) {
 		cpu_to_le32s(&padbytes);
 		memcpy(skb_tail_pointer(skb), &padbytes, sizeof(padbytes));
 		skb_put(skb, sizeof(padbytes));


