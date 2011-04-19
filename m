Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1DSU26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:28:58 -0400
Received: from kroah.org ([198.145.64.141]:47630 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab1DSURD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:45 2011
Message-Id: <20110419201045.175735533@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [19/70] fib: add rtnl locking in ip_fib_net_exit
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit e2666f84958adb3a034b98e99699b55705117e01 ]

Daniel J Blueman reported a lockdep splat in trie_firstleaf(), caused by
RTNL being not locked before a call to fib_table_flush()

Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/fib_frontend.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1041,6 +1041,7 @@ static void ip_fib_net_exit(struct net *
 	fib4_rules_exit(net);
 #endif
 
+	rtnl_lock();
 	for (i = 0; i < FIB_TABLE_HASHSZ; i++) {
 		struct fib_table *tb;
 		struct hlist_head *head;
@@ -1053,6 +1054,7 @@ static void ip_fib_net_exit(struct net *
 			fib_free_table(tb);
 		}
 	}
+	rtnl_unlock();
 	kfree(net->ipv4.fib_table_hash);
 }
 


