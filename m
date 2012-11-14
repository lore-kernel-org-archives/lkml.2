Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2KNFua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55036 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452Ab2KNFuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:22 -0500
Message-Id: <20121114053944.039777768@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:47 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tom Parkin <tparkin@katalix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 74/82] l2tp: fix oops in l2tp_eth_create() error path
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Parkin <tparkin@katalix.com>

[ Upstream commit 789336360e0a2aeb9750c16ab704a02cbe035e9e ]

When creating an L2TPv3 Ethernet session, if register_netdev() should fail for
any reason (for example, automatic naming for "l2tpeth%d" interfaces hits the
32k-interface limit), the netdev is freed in the error path.  However, the
l2tp_eth_sess structure's dev pointer is left uncleared, and this results in
l2tp_eth_delete() then attempting to unregister the same netdev later in the
session teardown.  This results in an oops.

To avoid this, clear the session dev pointer in the error path.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/l2tp/l2tp_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 2cef50b..64164fb 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -269,6 +269,7 @@ static int l2tp_eth_create(struct net *net, u32 tunnel_id, u32 session_id, u32 p
 
 out_del_dev:
 	free_netdev(dev);
+	spriv->dev = NULL;
 out_del_session:
 	l2tp_session_delete(session);
 out:


