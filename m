Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2IQAva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33835 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754446Ab2IQAvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:11 -0400
Message-Id: <20120917003633.591214368@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 053/135] pptp: lookup route with the proper net namespace
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit 08252b32311c3fa84219ad794d640af7399b5485 ]

pptp always use init_net as the net namespace to lookup
route, this will cause route lookup failed in container.

because we already set the correct net namespace to struct
sock in pptp_create,so fix this by using sock_net(sk) to
replace &init_net.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ppp/pptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index f8a6853..ad6a9d9 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -189,7 +189,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	if (sk_pppox(po)->sk_state & PPPOX_DEAD)
 		goto tx_error;
 
-	rt = ip_route_output_ports(&init_net, &fl4, NULL,
+	rt = ip_route_output_ports(sock_net(sk), &fl4, NULL,
 				   opt->dst_addr.sin_addr.s_addr,
 				   opt->src_addr.sin_addr.s_addr,
 				   0, 0, IPPROTO_GRE,
@@ -468,7 +468,7 @@ static int pptp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	po->chan.private = sk;
 	po->chan.ops = &pptp_chan_ops;
 
-	rt = ip_route_output_ports(&init_net, &fl4, sk,
+	rt = ip_route_output_ports(sock_net(sk), &fl4, sk,
 				   opt->dst_addr.sin_addr.s_addr,
 				   opt->src_addr.sin_addr.s_addr,
 				   0, 0,


