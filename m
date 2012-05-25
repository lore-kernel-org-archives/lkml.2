Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2EYMt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 08:49:59 -0400
Received: from zero-entropy.de ([46.163.77.74]:39444 "EHLO
	lvps46-163-77-74.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab2EYMt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 08:49:57 -0400
X-Greylist: delayed 2063 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2012 08:49:57 EDT
From: =?UTF-8?q?Stephen=20R=C3=B6ttger?= 
	<stephen.roettger@zero-entropy.de>
To: dbaryshkov@gmail.com, slapin@ossfans.org
Cc: davem@davemloft.net, linux-zigbee-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stephen=20R=C3=B6ttger?= 
	<stephen.roettger@zero-entropy.de>
Subject: [PATCH] ieee802154: pass source address in dgram_recvmsg
Date: Fri, 25 May 2012 14:14:33 +0200
Message-Id: <1337948073-5280-1-git-send-email-stephen.roettger@zero-entropy.de>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets dgram_recvmsg fill in the sockaddr struct in
msg->msg_name with the source address of the packet.
This is used by the userland functions recvmsg and recvfrom to get the
senders address.
The patch is based on the devel branch of
git://linux-zigbee.git.sourceforge.net/gitroot/linux-zigbee/kernel

Signed-off-by: Stephen Röttger <stephen.roettger@zero-entropy.de>
---
 net/ieee802154/dgram.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/ieee802154/dgram.c b/net/ieee802154/dgram.c
index 7883fa6..d0a6ebc 100644
--- a/net/ieee802154/dgram.c
+++ b/net/ieee802154/dgram.c
@@ -290,6 +290,9 @@ static int dgram_recvmsg(struct kiocb *iocb, struct sock *sk,
 	size_t copied = 0;
 	int err = -EOPNOTSUPP;
 	struct sk_buff *skb;
+	struct sockaddr_ieee802154 *saddr;
+
+	saddr = (struct sockaddr_ieee802154 *)msg->msg_name;
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
@@ -308,6 +311,13 @@ static int dgram_recvmsg(struct kiocb *iocb, struct sock *sk,
 
 	sock_recv_ts_and_drops(msg, sk, skb);
 
+	if (saddr) {
+		saddr->family = AF_IEEE802154;
+		saddr->addr = mac_cb(skb)->sa;
+	}
+	if (addr_len)
+		*addr_len = sizeof(*saddr);
+
 	if (flags & MSG_TRUNC)
 		copied = skb->len;
 done:
-- 
1.7.8

