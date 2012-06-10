Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2FJLJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:09:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51502 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab2FJLJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:09:17 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dbaryshkov@gmail.com, slapin@ossfans.org, davem@davemloft.net
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] ieee802154: verify packet size before trying to allocate it
Date: Sun, 10 Jun 2012 13:10:19 +0200
Message-Id: <1339326619-1753-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when sending data over datagram, the send function will attempt to
allocate any size passed on from the userspace.

We should make sure that this size is checked and limited. The maximum size
of an IP packet seemed like the safest limit here.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---

Change in v2:
 - Limit by maximum size the protocol supports.

 net/ieee802154/dgram.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/ieee802154/dgram.c b/net/ieee802154/dgram.c
index 6fbb2ad..628498c 100644
--- a/net/ieee802154/dgram.c
+++ b/net/ieee802154/dgram.c
@@ -232,6 +232,11 @@ static int dgram_sendmsg(struct kiocb *iocb, struct sock *sk,
 
 	hlen = LL_RESERVED_SPACE(dev);
 	tlen = dev->needed_tailroom;
+	if (hlen + tlen + size > IEEE802154_MTU) {
+		err = -EMSGSIZE;
+		goto out;
+	}
+		
 	skb = sock_alloc_send_skb(sk, hlen + tlen + size,
 			msg->msg_flags & MSG_DONTWAIT,
 			&err);
-- 
1.7.8.6

