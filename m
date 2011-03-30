Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268Ab1C3Vhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:37:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:21480 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933454Ab1C3VIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735598"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: davem@davemloft.net, randy.dunlap@oracle.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [158/275] x25: Do not reference freed memory.
Message-Id: <20110330210640.0F0683E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/x25/x25_link.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/net/x25/x25_link.c
===================================================================
--- linux-2.6.35.y.orig/net/x25/x25_link.c	2011-03-29 22:51:02.348663073 -0700
+++ linux-2.6.35.y/net/x25/x25_link.c	2011-03-29 23:03:01.541260733 -0700
@@ -392,9 +392,12 @@
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
