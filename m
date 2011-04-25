Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab1DYUYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:07 -0400
Received: from 1wt.eu ([62.212.114.60]:33894 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746Ab1DYUYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:04 -0400
Message-Id: <20110425200235.645260924@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 061/173] x25: Do not reference freed memory.
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

commit 96642d42f076101ba98866363d908cab706d156c upstream.

In x25_link_free(), we destroy 'nb' before dereferencing
'nb->dev'.  Don't do this, because 'nb' might be freed
by then.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/x25/x25_link.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -391,9 +391,12 @@ void __exit x25_link_free(void)
 	write_lock_bh(&x25_neigh_list_lock);
 
 	list_for_each_safe(entry, tmp, &x25_neigh_list) {
+		struct net_device *dev;
+
 		nb = list_entry(entry, struct x25_neigh, node);
+		dev = nb->dev;
 		__x25_remove_neigh(nb);
-		dev_put(nb->dev);
+		dev_put(dev);
 	}
 	write_unlock_bh(&x25_neigh_list_lock);
 }


