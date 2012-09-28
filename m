Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946019Ab2I1VK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:10:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41696 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759537Ab2I1Ukq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:40:46 -0400
X-Sasl-enc: +xniLLxykiAs6di12BUY//NbcEvJmcnqefGgTj1uJAsz 1348864845
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dmitry Kozlov <xeb@mail.ru>, "David S. Miller" <davem@davemloft.net>
Subject: [ 021/127] l2tp: avoid to use synchronize_rcu in tunnel free function
Date: Fri, 28 Sep 2012 13:33:14 -0700
Message-Id: <20120928203048.310145288@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "xeb@mail.ru" <xeb@mail.ru>

[ Upstream commit 99469c32f79a32d8481f87be0d3c66dad286f4ec ]

Avoid to use synchronize_rcu in l2tp_tunnel_free because context may be
atomic.

Signed-off-by: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |    3 +--
 net/l2tp/l2tp_core.h |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1252,11 +1252,10 @@ static void l2tp_tunnel_free(struct l2tp
 	/* Remove from tunnel list */
 	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
 	list_del_rcu(&tunnel->list);
+	kfree_rcu(tunnel, rcu);
 	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-	synchronize_rcu();
 
 	atomic_dec(&l2tp_tunnel_count);
-	kfree(tunnel);
 }
 
 /* Create a socket for the tunnel, if one isn't set up by
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -157,6 +157,7 @@ struct l2tp_tunnel_cfg {
 
 struct l2tp_tunnel {
 	int			magic;		/* Should be L2TP_TUNNEL_MAGIC */
+	struct rcu_head rcu;
 	rwlock_t		hlist_lock;	/* protect session_hlist */
 	struct hlist_head	session_hlist[L2TP_HASH_SIZE];
 						/* hashed list of sessions,


