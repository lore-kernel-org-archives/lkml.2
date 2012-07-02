Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941Ab2GBL3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:29:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47571 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2GBL3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:29:16 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dbaryshkov@gmail.com, slapin@ossfans.org, davem@davemloft.net
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v3] ieee802154: verify packet size before trying to allocate it
Date: Mon,  2 Jul 2012 13:29:55 +0200
Message-Id: <1341228595-9883-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when sending data over datagram, the send function will attempt to
allocate any size passed on from the userspace.

We should make sure that this size is checked and limited. We'll limit it
to the MTU of the device, which is checked later anyway.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 net/ieee802154/dgram.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ieee802154/dgram.c b/net/ieee802154/dgram.c
index 6fbb2ad..1670561 100644
--- a/net/ieee802154/dgram.c
+++ b/net/ieee802154/dgram.c
@@ -230,6 +230,12 @@ static int dgram_sendmsg(struct kiocb *iocb, struct sock *sk,
 	mtu = dev->mtu;
 	pr_debug("name = %s, mtu = %u\n", dev->name, mtu);
 
+	if (size > mtu) {
+		pr_debug("size = %Zu, mtu = %u\n", size, mtu);
+		err = -EINVAL;
+		goto out_dev;
+	}
+
 	hlen = LL_RESERVED_SPACE(dev);
 	tlen = dev->needed_tailroom;
 	skb = sock_alloc_send_skb(sk, hlen + tlen + size,
@@ -258,12 +264,6 @@ static int dgram_sendmsg(struct kiocb *iocb, struct sock *sk,
 	if (err < 0)
 		goto out_skb;
 
-	if (size > mtu) {
-		pr_debug("size = %Zu, mtu = %u\n", size, mtu);
-		err = -EINVAL;
-		goto out_skb;
-	}
-
 	skb->dev = dev;
 	skb->sk  = sk;
 	skb->protocol = htons(ETH_P_IEEE802154);
-- 
1.7.8.6

