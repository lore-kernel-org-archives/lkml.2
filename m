Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab1DYUfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:35:23 -0400
Received: from 1wt.eu ([62.212.114.60]:34541 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab1DYUZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:19 -0400
Message-Id: <20110425200239.553074929@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 151/173] net: packet: fix information leak to userland
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segooon@gmail.com>

commit 67286640f638f5ad41a946b9a3dc75327950248f upstream.

packet_getname_spkt() doesn't initialize all members of sa_data field of
sockaddr struct if strlen(dev->name) < 13.  This structure is then copied
to userland.  It leads to leaking of contents of kernel stack memory.
We have to fully fill sa_data with strncpy() instead of strlcpy().

The same with packet_getname(): it doesn't initialize sll_pkttype field of
sockaddr_ll.  Set it to zero.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Moritz Muehlenhoff <jmm@debian.org>
[jmm: Backported to 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/packet/af_packet.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1526,7 +1526,7 @@ static int packet_getname_spkt(struct so
 	uaddr->sa_family = AF_PACKET;
 	dev = dev_get_by_index(sock_net(sk), pkt_sk(sk)->ifindex);
 	if (dev) {
-		strlcpy(uaddr->sa_data, dev->name, 15);
+		strncpy(uaddr->sa_data, dev->name, 14);
 		dev_put(dev);
 	} else
 		memset(uaddr->sa_data, 0, 14);
@@ -1549,6 +1549,7 @@ static int packet_getname(struct socket
 	sll->sll_family = AF_PACKET;
 	sll->sll_ifindex = po->ifindex;
 	sll->sll_protocol = po->num;
+	sll->sll_pkttype = 0;
 	dev = dev_get_by_index(sock_net(sk), po->ifindex);
 	if (dev) {
 		sll->sll_hatype = dev->type;


