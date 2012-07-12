Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162976Ab2GLXsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:48:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448Ab2GLWgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:36:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 023/187] inetpeer: fix a race in inetpeer_gc_worker()
Date: Thu, 12 Jul 2012 15:32:59 -0700
Message-Id: <20120712191524.408333757@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 55432d2b543a4b6dfae54f5c432a566877a85d90 ]

commit 5faa5df1fa2024 (inetpeer: Invalidate the inetpeer tree along with
the routing cache) added a race :

Before freeing an inetpeer, we must respect a RCU grace period, and make
sure no user will attempt to increase refcnt.

inetpeer_invalidate_tree() waits for a RCU grace period before inserting
inetpeer tree into gc_list and waking the worker. At that time, no
concurrent lookup can find a inetpeer in this tree.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inetpeer.h |    5 ++++-
 net/ipv4/inetpeer.c    |   16 ++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -40,7 +40,10 @@ struct inet_peer {
 	u32			pmtu_orig;
 	u32			pmtu_learned;
 	struct inetpeer_addr_base redirect_learned;
-	struct list_head	gc_list;
+	union {
+		struct list_head	gc_list;
+		struct rcu_head     gc_rcu;
+	};
 	/*
 	 * Once inet_peer is queued for deletion (refcnt == -1), following fields
 	 * are not available: rid, ip_id_count, tcp_ts, tcp_ts_stamp
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -560,6 +560,17 @@ bool inet_peer_xrlim_allow(struct inet_p
 }
 EXPORT_SYMBOL(inet_peer_xrlim_allow);
 
+static void inetpeer_inval_rcu(struct rcu_head *head)
+{
+	struct inet_peer *p = container_of(head, struct inet_peer, gc_rcu);
+
+	spin_lock_bh(&gc_lock);
+	list_add_tail(&p->gc_list, &gc_list);
+	spin_unlock_bh(&gc_lock);
+
+	schedule_delayed_work(&gc_work, gc_delay);
+}
+
 void inetpeer_invalidate_tree(int family)
 {
 	struct inet_peer *old, *new, *prev;
@@ -576,10 +587,7 @@ void inetpeer_invalidate_tree(int family
 	prev = cmpxchg(&base->root, old, new);
 	if (prev == old) {
 		base->total = 0;
-		spin_lock(&gc_lock);
-		list_add_tail(&prev->gc_list, &gc_list);
-		spin_unlock(&gc_lock);
-		schedule_delayed_work(&gc_work, gc_delay);
+		call_rcu(&prev->gc_rcu, inetpeer_inval_rcu);
 	}
 
 out:


