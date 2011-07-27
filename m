Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1G0CpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 22:45:02 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:50506 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1G0Co7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 22:44:59 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de,
        Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH 2/2] ASIX: Use only 11 bits of header for data size
Date: Wed, 27 Jul 2011 04:44:47 +0200
Message-Id: <1311734687-23551-2-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1311734687-23551-1-git-send-email-marek.vasut@gmail.com>
References: <1311734687-23551-1-git-send-email-marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AX88772B uses only 11 bits of the header for the actual size. The other bits
are used for something else. This causes dmesg full of messages:

	asix_rx_fixup() Bad Header Length

This patch trims the check to only 11 bits. I believe on older chips, the
remaining 5 top bits are unused.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/net/usb/asix.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

NOTE: If possible, can someone test/verify this patch with other ASIX chips ?
NOTE2: If Ack-ed, Greg, can you get this into -stable?

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index d5b62a4..c5c4b4d 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -314,11 +314,11 @@ static int asix_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
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
-- 
1.7.5.3

