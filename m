Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab0EYXYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:24:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47227
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933018Ab0EYXYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:24:36 -0400
Date: Tue, 25 May 2010 16:24:46 -0700 (PDT)
Message-Id: <20100525.162446.183058933.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, NeilJay@gmail.com
Subject: Re: linux-next: build warning in Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100525.161929.112591425.davem@davemloft.net>
References: <20100525114614.fd61d822.sfr@canb.auug.org.au>
	<20100524.215822.13254177.davem@davemloft.net>
	<20100525.161929.112591425.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 25 May 2010 16:19:29 -0700 (PDT)

> Here is how I fixed this:
> 
> --------------------
> drivers/net/usb/asix.c: Fix pointer cast.

Sorry, that only took care of one of the two warnings :-)

This patch is better.

--------------------
drivers/net/usb/asix.c: Fix pointer cast.

Stephen Rothwell reports the following new warning:

drivers/net/usb/asix.c: In function 'asix_rx_fixup':
drivers/net/usb/asix.c:325: warning: cast from pointer to integer of different size
drivers/net/usb/asix.c:354: warning: cast from pointer to integer of different size

The code just cares about the low alignment bits, so use
an "unsigned long" cast instead of one to "u32".

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/usb/asix.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index 31b7331..1f802e9 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -322,7 +322,7 @@ static int asix_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (u16) (header & 0x0000ffff);
 
 		if ((skb->len) - ((size + 1) & 0xfffe) == 0) {
-			u8 alignment = (u32)skb->data & 0x3;
+			u8 alignment = (unsigned long)skb->data & 0x3;
 			if (alignment != 0x2) {
 				/*
 				 * not 16bit aligned so use the room provided by
@@ -351,7 +351,7 @@ static int asix_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		}
 		ax_skb = skb_clone(skb, GFP_ATOMIC);
 		if (ax_skb) {
-			u8 alignment = (u32)packet & 0x3;
+			u8 alignment = (unsigned long)packet & 0x3;
 			ax_skb->len = size;
 
 			if (alignment != 0x2) {
-- 
1.7.0.4

