Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0JaRKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:10:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53346 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0JaRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:10:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o7DUYmnGT04iyIb+CXTU2LJ4cjoDbSh9zoEf1dFxRGsIJeFHQK5ZhcGRbrHNEUfGU2
         juRrp+B/qfnUSofuJaTayW1KjYpuZYBKq7Yc3WcGJOTCnyDTpBdNSZCtgjXUK1ixlwjE
         flVDcJVlh5Tb/kcWl95zdgaVh7OauZuQnkWh0=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] net: packet: fix information leak to userland
Date: Sun, 31 Oct 2010 20:10:28 +0300
Message-Id: <1288545028-16436-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

packet_getname_spkt() doesn't initialize all members of sa_data field of
sockaddr struct if strlen(dev->name) < 13.  This structure is then copied
to userland.  It leads to leaking of contents of kernel stack memory.
We have to fully fill sa_data with strncpy() instead of strlcpy().

The same with packet_getname(): it doesn't initialize sll_pkttype field of
sockaddr_ll.  Set it to zero.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 net/packet/af_packet.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 3616f27..0856a13 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1719,7 +1719,7 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
 	if (dev)
-		strlcpy(uaddr->sa_data, dev->name, 15);
+		strncpy(uaddr->sa_data, dev->name, 14);
 	else
 		memset(uaddr->sa_data, 0, 14);
 	rcu_read_unlock();
@@ -1742,6 +1742,7 @@ static int packet_getname(struct socket *sock, struct sockaddr *uaddr,
 	sll->sll_family = AF_PACKET;
 	sll->sll_ifindex = po->ifindex;
 	sll->sll_protocol = po->num;
+	sll->sll_pkttype = 0;
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), po->ifindex);
 	if (dev) {
-- 
1.7.0.4

