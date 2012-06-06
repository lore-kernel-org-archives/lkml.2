Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab2FFVbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:31:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48373 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2FFVbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:31:00 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dbaryshkov@gmail.com, slapin@ossfans.org, davem@davemloft.net
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] ieee802154: verify packet size before trying to allocate it
Date: Wed,  6 Jun 2012 23:32:02 +0200
Message-Id: <1339018322-19360-1-git-send-email-levinsasha928@gmail.com>
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
 net/ieee802154/dgram.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/ieee802154/dgram.c b/net/ieee802154/dgram.c
index 6fbb2ad..cf5070b 100644
--- a/net/ieee802154/dgram.c
+++ b/net/ieee802154/dgram.c
@@ -232,6 +232,10 @@ static int dgram_sendmsg(struct kiocb *iocb, struct sock *sk,
 
 	hlen = LL_RESERVED_SPACE(dev);
 	tlen = dev->needed_tailroom;
+	if (hlen + tlen + size > USHRT_MAX) {
+		err = -EMSGSIZE;
+		goto out;
+	}
 	skb = sock_alloc_send_skb(sk, hlen + tlen + size,
 			msg->msg_flags & MSG_DONTWAIT,
 			&err);
-- 
1.7.8.6

