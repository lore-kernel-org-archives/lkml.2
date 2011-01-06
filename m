Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1AFAaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:17 -0500
Received: from kroah.org ([198.145.64.141]:35812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab1AFAaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:12 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:04 2011
Message-Id: <20110106002304.076081785@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segooon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [078/152] net: packet: fix information leak to userland
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Vasiliy Kulikov <segooon@gmail.com>

[ Upstream commit 67286640f638f5ad41a946b9a3dc75327950248f ]

packet_getname_spkt() doesn't initialize all members of sa_data field of
sockaddr struct if strlen(dev->name) < 13.  This structure is then copied
to userland.  It leads to leaking of contents of kernel stack memory.
We have to fully fill sa_data with strncpy() instead of strlcpy().

The same with packet_getname(): it doesn't initialize sll_pkttype field of
sockaddr_ll.  Set it to zero.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/packet/af_packet.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1721,7 +1721,7 @@ static int packet_getname_spkt(struct so
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
 	if (dev)
-		strlcpy(uaddr->sa_data, dev->name, 15);
+		strncpy(uaddr->sa_data, dev->name, 14);
 	else
 		memset(uaddr->sa_data, 0, 14);
 	rcu_read_unlock();
@@ -1744,6 +1744,7 @@ static int packet_getname(struct socket
 	sll->sll_family = AF_PACKET;
 	sll->sll_ifindex = po->ifindex;
 	sll->sll_protocol = po->num;
+	sll->sll_pkttype = 0;
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), po->ifindex);
 	if (dev) {


