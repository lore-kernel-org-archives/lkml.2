Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab2DDWKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 18:10:31 -0400
Received: from mail.vyatta.com ([76.74.103.46]:59606 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034Ab2DDWKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 18:10:30 -0400
Date: Wed, 4 Apr 2012 15:10:27 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] sky2: copy received packets on inefficient unaligned
 architecture
Message-ID: <20120404151027.047c183b@s6510.linuxnetplumber.net>
In-Reply-To: <4F7CC2AC.5040309@tilera.com>
References: <20120403.174610.2089715131687430500.davem@davemloft.net>
	<1333469916.18626.284.camel@edumazet-glaptop>
	<201204031527.q33FR04i031747@farm-0027.internal.tilera.com>
	<201204041419.q34EJ49H025297@farm-0012.internal.tilera.com>
	<20120404114253.5f84d4c8@s6510.linuxnetplumber.net>
	<4F7CC2AC.5040309@tilera.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified from original patch from Chris.

The sky2 driver has to have 8 byte alignment of receive buffer
on some chip versions. On architectures which don't support efficient
unaligned access this doesn't work very well. The solution is to
just copy all received packets which is what the driver already
does for small packets.

This allows the driver to be used on the Tilera TILEmpower-Gx, since
the tile architecture doesn't currently handle kernel unaligned accesses,
just userspace.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>

--- a/drivers/net/ethernet/marvell/sky2.c	2012-04-04 08:49:05.954853108 -0700
+++ b/drivers/net/ethernet/marvell/sky2.c	2012-04-04 15:03:41.725705876 -0700
@@ -2468,6 +2468,17 @@ static int sky2_change_mtu(struct net_de
 	return err;
 }
 
+static inline bool needs_copy(const struct rx_ring_info *re,
+			      unsigned length)
+{
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	/* Some architectures need the IP header to be aligned */
+	if (!IS_ALIGNED(re->data_addr + ETH_HLEN, sizeof(u32)))
+		return true;
+#endif
+	return length < copybreak;
+}
+
 /* For small just reuse existing skb for next receive */
 static struct sk_buff *receive_copy(struct sky2_port *sky2,
 				    const struct rx_ring_info *re,
@@ -2605,7 +2616,7 @@ static struct sk_buff *sky2_receive(stru
 		goto error;
 
 okay:
-	if (length < copybreak)
+	if (needs_copy(re, length))
 		skb = receive_copy(sky2, re, length);
 	else
 		skb = receive_new(sky2, re, length);

