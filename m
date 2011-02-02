Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab1BBA73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:59:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:46446 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab1BBAoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028474"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: segooon@gmail.com, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [74/139] net: packet: fix information leak to userland
Message-Id: <20110202004431.3D1CB3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/packet/af_packet.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/net/packet/af_packet.c
===================================================================
--- linux-2.6.35.y.orig/net/packet/af_packet.c
+++ linux-2.6.35.y/net/packet/af_packet.c
@@ -1706,7 +1706,7 @@ static int packet_getname_spkt(struct so
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
 	if (dev)
-		strlcpy(uaddr->sa_data, dev->name, 15);
+		strncpy(uaddr->sa_data, dev->name, 14);
 	else
 		memset(uaddr->sa_data, 0, 14);
 	rcu_read_unlock();
@@ -1729,6 +1729,7 @@ static int packet_getname(struct socket 
 	sll->sll_family = AF_PACKET;
 	sll->sll_ifindex = po->ifindex;
 	sll->sll_protocol = po->num;
+	sll->sll_pkttype = 0;
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), po->ifindex);
 	if (dev) {
