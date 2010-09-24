Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0IXQfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:35:06 -0400
Received: from kroah.org ([198.145.64.141]:37041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932914Ab0IXQez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:34:55 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:44 2010
Message-Id: <20100924163344.711466331@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [08/68] tcp: fix three tcp sysctls tuning
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit c5ed63d66f24fd4f7089b5a6e087b0ce7202aa8e ]

As discovered by Anton Blanchard, current code to autotune
tcp_death_row.sysctl_max_tw_buckets, sysctl_tcp_max_orphans and
sysctl_max_syn_backlog makes little sense.

The bigger a page is, the less tcp_max_orphans is : 4096 on a 512GB
machine in Anton's case.

(tcp_hashinfo.bhash_size * sizeof(struct inet_bind_hashbucket))
is much bigger if spinlock debugging is on. Its wrong to select bigger
limits in this case (where kernel structures are also bigger)

bhash_size max is 65536, and we get this value even for small machines.

A better ground is to use size of ehash table, this also makes code
shorter and more obvious.

Based on a patch from Anton, and another from David.

Reported-and-tested-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2878,7 +2878,7 @@ void __init tcp_init(void)
 {
 	struct sk_buff *skb = NULL;
 	unsigned long nr_pages, limit;
-	int order, i, max_share;
+	int i, max_share, cnt;
 
 	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) > sizeof(skb->cb));
 
@@ -2927,22 +2927,12 @@ void __init tcp_init(void)
 		INIT_HLIST_HEAD(&tcp_hashinfo.bhash[i].chain);
 	}
 
-	/* Try to be a bit smarter and adjust defaults depending
-	 * on available memory.
-	 */
-	for (order = 0; ((1 << order) << PAGE_SHIFT) <
-			(tcp_hashinfo.bhash_size * sizeof(struct inet_bind_hashbucket));
-			order++)
-		;
-	if (order >= 4) {
-		tcp_death_row.sysctl_max_tw_buckets = 180000;
-		sysctl_tcp_max_orphans = 4096 << (order - 4);
-		sysctl_max_syn_backlog = 1024;
-	} else if (order < 3) {
-		tcp_death_row.sysctl_max_tw_buckets >>= (3 - order);
-		sysctl_tcp_max_orphans >>= (3 - order);
-		sysctl_max_syn_backlog = 128;
-	}
+
+	cnt = tcp_hashinfo.ehash_size;
+
+	tcp_death_row.sysctl_max_tw_buckets = cnt / 2;
+	sysctl_tcp_max_orphans = cnt / 2;
+	sysctl_max_syn_backlog = max(128, cnt / 256);
 
 	/* Set the pressure threshold to be a fraction of global memory that
 	 * is up to 1/2 at 256 MB, decreasing toward zero with the amount of


