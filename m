Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab2IQBLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:11:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33726 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856Ab2IQAuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:39 -0400
Message-Id: <20120917003636.318896221@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "xeb@mail.ru" <xeb@mail.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 073/135] l2tp: avoid to use synchronize_rcu in tunnel free  function
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "xeb@mail.ru" <xeb@mail.ru>

[ Upstream commit 99469c32f79a32d8481f87be0d3c66dad286f4ec ]

Avoid to use synchronize_rcu in l2tp_tunnel_free because context may be
atomic.

Signed-off-by: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/l2tp/l2tp_core.c | 3 +--
 net/l2tp/l2tp_core.h | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 89ff8c6..7501b22 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1253,11 +1253,10 @@ static void l2tp_tunnel_free(struct l2tp_tunnel *tunnel)
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
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index a16a48e..4393794 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -157,6 +157,7 @@ struct l2tp_tunnel_cfg {
 
 struct l2tp_tunnel {
 	int			magic;		/* Should be L2TP_TUNNEL_MAGIC */
+	struct rcu_head rcu;
 	rwlock_t		hlist_lock;	/* protect session_hlist */
 	struct hlist_head	session_hlist[L2TP_HASH_SIZE];
 						/* hashed list of sessions,


