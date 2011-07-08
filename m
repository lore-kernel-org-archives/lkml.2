Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1GHFVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:21:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab1GHFAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:00:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:53 2011
Message-Id: <20110708001653.729894367@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [010/107] inetpeer: fix race in unused_list manipulations
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 686a7e32ca7fdd819eb9606abd3db52b77d1479f ]

Several crashes in cleanup_once() were reported in recent kernels.

Commit d6cc1d642de9 (inetpeer: various changes) added a race in
unlink_from_unused().

One way to avoid taking unused_peers.lock before doing the list_empty()
test is to catch 0->1 refcnt transitions, using full barrier atomic
operations variants (atomic_cmpxchg() and atomic_inc_return()) instead
of previous atomic_inc() and atomic_add_unless() variants.

We then call unlink_from_unused() only for the owner of the 0->1
transition.

Add a new atomic_add_unless_return() static helper

With help from Arun Sharma.

Refs: https://bugzilla.kernel.org/show_bug.cgi?id=32772

Reported-by: Arun Sharma <asharma@fb.com>
Reported-by: Maximilian Engelhardt <maxi@daemonizer.de>
Reported-by: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Reported-by: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/inetpeer.c |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -154,11 +154,9 @@ void __init inet_initpeers(void)
 /* Called with or without local BH being disabled. */
 static void unlink_from_unused(struct inet_peer *p)
 {
-	if (!list_empty(&p->unused)) {
-		spin_lock_bh(&unused_peers.lock);
-		list_del_init(&p->unused);
-		spin_unlock_bh(&unused_peers.lock);
-	}
+	spin_lock_bh(&unused_peers.lock);
+	list_del_init(&p->unused);
+	spin_unlock_bh(&unused_peers.lock);
 }
 
 static int addr_compare(const struct inetpeer_addr *a,
@@ -205,6 +203,20 @@ static int addr_compare(const struct ine
 	u;							\
 })
 
+static bool atomic_add_unless_return(atomic_t *ptr, int a, int u, int *newv)
+{
+	int cur, old = atomic_read(ptr);
+
+	while (old != u) {
+		*newv = old + a;
+		cur = atomic_cmpxchg(ptr, old, *newv);
+		if (cur == old)
+			return true;
+		old = cur;
+	}
+	return false;
+}
+
 /*
  * Called with rcu_read_lock()
  * Because we hold no lock against a writer, its quite possible we fall
@@ -213,7 +225,8 @@ static int addr_compare(const struct ine
  * We exit from this function if number of links exceeds PEER_MAXDEPTH
  */
 static struct inet_peer *lookup_rcu(const struct inetpeer_addr *daddr,
-				    struct inet_peer_base *base)
+				    struct inet_peer_base *base,
+				    int *newrefcnt)
 {
 	struct inet_peer *u = rcu_dereference(base->root);
 	int count = 0;
@@ -226,7 +239,7 @@ static struct inet_peer *lookup_rcu(cons
 			 * distinction between an unused entry (refcnt=0) and
 			 * a freed one.
 			 */
-			if (unlikely(!atomic_add_unless(&u->refcnt, 1, -1)))
+			if (!atomic_add_unless_return(&u->refcnt, 1, -1, newrefcnt))
 				u = NULL;
 			return u;
 		}
@@ -465,22 +478,23 @@ struct inet_peer *inet_getpeer(struct in
 	struct inet_peer_base *base = family_to_base(daddr->family);
 	struct inet_peer *p;
 	unsigned int sequence;
-	int invalidated;
+	int invalidated, newrefcnt = 0;
 
 	/* Look up for the address quickly, lockless.
 	 * Because of a concurrent writer, we might not find an existing entry.
 	 */
 	rcu_read_lock();
 	sequence = read_seqbegin(&base->lock);
-	p = lookup_rcu(daddr, base);
+	p = lookup_rcu(daddr, base, &newrefcnt);
 	invalidated = read_seqretry(&base->lock, sequence);
 	rcu_read_unlock();
 
 	if (p) {
-		/* The existing node has been found.
+found:		/* The existing node has been found.
 		 * Remove the entry from unused list if it was there.
 		 */
-		unlink_from_unused(p);
+		if (newrefcnt == 1)
+			unlink_from_unused(p);
 		return p;
 	}
 
@@ -494,11 +508,9 @@ struct inet_peer *inet_getpeer(struct in
 	write_seqlock_bh(&base->lock);
 	p = lookup(daddr, stack, base);
 	if (p != peer_avl_empty) {
-		atomic_inc(&p->refcnt);
+		newrefcnt = atomic_inc_return(&p->refcnt);
 		write_sequnlock_bh(&base->lock);
-		/* Remove the entry from unused list if it was there. */
-		unlink_from_unused(p);
-		return p;
+		goto found;
 	}
 	p = create ? kmem_cache_alloc(peer_cachep, GFP_ATOMIC) : NULL;
 	if (p) {


