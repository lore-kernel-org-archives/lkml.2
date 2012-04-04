Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2DDOTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 10:19:08 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:30491 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab2DDOTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 10:19:06 -0400
Message-Id: <201204041419.q34EJ49H025297@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 4 Apr 2012 10:13:32 -0400
Subject: [PATCH v2] marvell sky2 driver: fix so it works without unaligned accesses
To: Stephen Hemminger <shemminger@vyatta.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120403.174610.2089715131687430500.davem@davemloft.net>
References: <20120403.174610.2089715131687430500.davem@davemloft.net> <1333469916.18626.284.camel@edumazet-glaptop> <201204031527.q33FR04i031747@farm-0027.internal.tilera.com>
X-OriginalArrivalTime: 04 Apr 2012 14:19:05.0055 (UTC) FILETIME=[E40F36F0:01CD126D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver uses a receive_new() routine that ends up requiring unaligned
accesses in IP header processing.  If the architecture doesn't support
efficient unaligned accesses, and SKY2_HW_RAM_BUFFER is set,
just copy all ingress packets to the bounce buffers instead.
Thanks to Eric Dumazet for pointing out the SKY2_HW_RAM_BUFFER issue.

This allows the driver to be used on the Tilera TILEmpower-Gx, since
the tile architecture doesn't currently handle kernel unaligned accesses,
just userspace.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/net/ethernet/marvell/sky2.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 423a1a2..2bc6a78 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2598,7 +2598,11 @@ static struct sk_buff *sky2_receive(struct net_device *dev,
 		goto error;
 
 okay:
-	if (length < copybreak)
+	if ((length < copybreak)
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	    || (sky2->hw->flags & SKY2_HW_RAM_BUFFER)
+#endif
+	    )
 		skb = receive_copy(sky2, re, length);
 	else
 		skb = receive_new(sky2, re, length);
-- 
1.6.5.2

