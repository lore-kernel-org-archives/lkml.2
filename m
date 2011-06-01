Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161547Ab1FAIKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:10:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161504Ab1FAIKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:10:45 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:12 2011
Message-Id: <20110601080311.259071529@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:47 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>, Scot Doyle <lkml@scotdoyle.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [051/146] inetpeer: reduce stack usage
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 66944e1c5797562cebe2d1857d46dff60bf9a69e ]

On 64bit arches, we use 752 bytes of stack when cleanup_once() is called
from inet_getpeer().

Lets share the avl stack to save ~376 bytes.

Before patch :

# objdump -d net/ipv4/inetpeer.o | scripts/checkstack.pl

0x000006c3 unlink_from_pool [inetpeer.o]:		376
0x00000721 unlink_from_pool [inetpeer.o]:		376
0x00000cb1 inet_getpeer [inetpeer.o]:			376
0x00000e6d inet_getpeer [inetpeer.o]:			376
0x0004 inet_initpeers [inetpeer.o]:			112
# size net/ipv4/inetpeer.o
   text	   data	    bss	    dec	    hex	filename
   5320	    432	     21	   5773	   168d	net/ipv4/inetpeer.o

After patch :

objdump -d net/ipv4/inetpeer.o | scripts/checkstack.pl
0x00000c11 inet_getpeer [inetpeer.o]:			376
0x00000dcd inet_getpeer [inetpeer.o]:			376
0x00000ab9 peer_check_expire [inetpeer.o]:		328
0x00000b7f peer_check_expire [inetpeer.o]:		328
0x0004 inet_initpeers [inetpeer.o]:			112
# size net/ipv4/inetpeer.o
   text	   data	    bss	    dec	    hex	filename
   5163	    432	     21	   5616	   15f0	net/ipv4/inetpeer.o

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Scot Doyle <lkml@scotdoyle.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Reviewed-by: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/inetpeer.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -366,7 +366,8 @@ static void inetpeer_free_rcu(struct rcu
 }
 
 /* May be called with local BH enabled. */
-static void unlink_from_pool(struct inet_peer *p, struct inet_peer_base *base)
+static void unlink_from_pool(struct inet_peer *p, struct inet_peer_base *base,
+			     struct inet_peer __rcu **stack[PEER_MAXDEPTH])
 {
 	int do_free;
 
@@ -380,7 +381,6 @@ static void unlink_from_pool(struct inet
 	 * We use refcnt=-1 to alert lockless readers this entry is deleted.
 	 */
 	if (atomic_cmpxchg(&p->refcnt, 1, -1) == 1) {
-		struct inet_peer __rcu **stack[PEER_MAXDEPTH];
 		struct inet_peer __rcu ***stackptr, ***delp;
 		if (lookup(&p->daddr, stack, base) != p)
 			BUG();
@@ -435,7 +435,7 @@ static struct inet_peer_base *peer_to_ba
 }
 
 /* May be called with local BH enabled. */
-static int cleanup_once(unsigned long ttl)
+static int cleanup_once(unsigned long ttl, struct inet_peer __rcu **stack[PEER_MAXDEPTH])
 {
 	struct inet_peer *p = NULL;
 
@@ -467,7 +467,7 @@ static int cleanup_once(unsigned long tt
 		 * happen because of entry limits in route cache. */
 		return -1;
 
-	unlink_from_pool(p, peer_to_base(p));
+	unlink_from_pool(p, peer_to_base(p), stack);
 	return 0;
 }
 
@@ -523,7 +523,7 @@ struct inet_peer *inet_getpeer(struct in
 
 	if (base->total >= inet_peer_threshold)
 		/* Remove one less-recently-used entry. */
-		cleanup_once(0);
+		cleanup_once(0, stack);
 
 	return p;
 }
@@ -539,6 +539,7 @@ static void peer_check_expire(unsigned l
 {
 	unsigned long now = jiffies;
 	int ttl, total;
+	struct inet_peer __rcu **stack[PEER_MAXDEPTH];
 
 	total = compute_total();
 	if (total >= inet_peer_threshold)
@@ -547,7 +548,7 @@ static void peer_check_expire(unsigned l
 		ttl = inet_peer_maxttl
 				- (inet_peer_maxttl - inet_peer_minttl) / HZ *
 					total / inet_peer_threshold * HZ;
-	while (!cleanup_once(ttl)) {
+	while (!cleanup_once(ttl, stack)) {
 		if (jiffies != now)
 			break;
 	}


