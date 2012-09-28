Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031834Ab2I1UEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:04:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890Ab2I1SzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dmitry Kozlov <xeb@mail.ru>, "David S. Miller" <davem@davemloft.net>
Subject: [ 030/262] l2tp: avoid to use synchronize_rcu in tunnel free function
Date: Fri, 28 Sep 2012 11:49:19 -0700
Message-Id: <20120928183001.527624561@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1346,11 +1346,10 @@ static void l2tp_tunnel_free(struct l2tp
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
@@ -163,6 +163,7 @@ struct l2tp_tunnel_cfg {
 
 struct l2tp_tunnel {
 	int			magic;		/* Should be L2TP_TUNNEL_MAGIC */
+	struct rcu_head rcu;
 	rwlock_t		hlist_lock;	/* protect session_hlist */
 	struct hlist_head	session_hlist[L2TP_HASH_SIZE];
 						/* hashed list of sessions,


