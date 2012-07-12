Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519Ab2GLWhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:37:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759484Ab2GLWhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:37:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 028/187] net: neighbour: fix neigh_dump_info()
Date: Thu, 12 Jul 2012 15:33:04 -0700
Message-Id: <20120712191524.883517684@linuxfoundation.org>
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

[ Upstream commit 4bd6683bd400c8b1d2ad544bb155d86a5d10f91c ]

Denys found out "ip neigh" output was truncated to
about 54 neighbours.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2214,9 +2214,7 @@ static int neigh_dump_table(struct neigh
 	rcu_read_lock_bh();
 	nht = rcu_dereference_bh(tbl->nht);
 
-	for (h = 0; h < (1 << nht->hash_shift); h++) {
-		if (h < s_h)
-			continue;
+	for (h = s_h; h < (1 << nht->hash_shift); h++) {
 		if (h > s_h)
 			s_idx = 0;
 		for (n = rcu_dereference_bh(nht->hash_buckets[h]), idx = 0;
@@ -2255,9 +2253,7 @@ static int pneigh_dump_table(struct neig
 
 	read_lock_bh(&tbl->lock);
 
-	for (h = 0; h <= PNEIGH_HASHMASK; h++) {
-		if (h < s_h)
-			continue;
+	for (h = s_h; h <= PNEIGH_HASHMASK; h++) {
 		if (h > s_h)
 			s_idx = 0;
 		for (n = tbl->phash_buckets[h], idx = 0; n; n = n->next) {
@@ -2292,7 +2288,7 @@ static int neigh_dump_info(struct sk_buf
 	struct neigh_table *tbl;
 	int t, family, s_t;
 	int proxy = 0;
-	int err = 0;
+	int err;
 
 	read_lock(&neigh_tbl_lock);
 	family = ((struct rtgenmsg *) nlmsg_data(cb->nlh))->rtgen_family;
@@ -2306,7 +2302,7 @@ static int neigh_dump_info(struct sk_buf
 
 	s_t = cb->args[0];
 
-	for (tbl = neigh_tables, t = 0; tbl && (err >= 0);
+	for (tbl = neigh_tables, t = 0; tbl;
 	     tbl = tbl->next, t++) {
 		if (t < s_t || (family && tbl->family != family))
 			continue;
@@ -2317,6 +2313,8 @@ static int neigh_dump_info(struct sk_buf
 			err = pneigh_dump_table(tbl, skb, cb);
 		else
 			err = neigh_dump_table(tbl, skb, cb);
+		if (err < 0)
+			break;
 	}
 	read_unlock(&neigh_tbl_lock);
 


