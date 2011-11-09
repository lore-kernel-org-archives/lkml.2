Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab1KJD3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:29:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935079Ab1KJD3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:18 2011
Message-Id: <20111109212717.961795081@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marek Vasut <marek.vasut@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [173/262] ASIX: Use only 11 bits of header for data size
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut@gmail.com>

commit bca0beb9363f8487ac902931a50eb00180a2d14a upstream.

The AX88772B uses only 11 bits of the header for the actual size. The other bits
are used for something else. This causes dmesg full of messages:

	asix_rx_fixup() Bad Header Length

This patch trims the check to only 11 bits. I believe on older chips, the
remaining 5 top bits are unused.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/asix.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -314,11 +314,11 @@ static int asix_rx_fixup(struct usbnet *
 	skb_pull(skb, 4);
 
 	while (skb->len > 0) {
-		if ((header & 0xffff) != ((~header >> 16) & 0xffff))
+		if ((header & 0x07ff) != ((~header >> 16) & 0x07ff))
 			netdev_err(dev->net, "asix_rx_fixup() Bad Header Length\n");
 
 		/* get the packet length */
-		size = (u16) (header & 0x0000ffff);
+		size = (u16) (header & 0x000007ff);
 
 		if ((skb->len) - ((size + 1) & 0xfffe) == 0) {
 			u8 alignment = (unsigned long)skb->data & 0x3;


