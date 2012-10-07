Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2JGXX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:23:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38555 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515Ab2JGXXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:01 -0400
Message-Id: <20121007225842.174746398@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rustad, Mark D" <mark.d.rustad@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 054/108] net: Statically initialize init_net.dev_base_head
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rustad, Mark D" <mark.d.rustad@intel.com>

commit 734b65417b24d6eea3e3d7457e1f11493890ee1d upstream.

This change eliminates an initialization-order hazard most
recently seen when netprio_cgroup is built into the kernel.

With thanks to Eric Dumazet for catching a bug.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/dev.c           |    3 ++-
 net/core/net_namespace.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0f28a9e..1cb0d8a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6283,7 +6283,8 @@ static struct hlist_head *netdev_create_hash(void)
 /* Initialize per network namespace state */
 static int __net_init netdev_init(struct net *net)
 {
-	INIT_LIST_HEAD(&net->dev_base_head);
+	if (net != &init_net)
+		INIT_LIST_HEAD(&net->dev_base_head);
 
 	net->dev_name_head = netdev_create_hash();
 	if (net->dev_name_head == NULL)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index dddbacb..42f1e1c 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -27,7 +27,9 @@ static DEFINE_MUTEX(net_mutex);
 LIST_HEAD(net_namespace_list);
 EXPORT_SYMBOL_GPL(net_namespace_list);
 
-struct net init_net;
+struct net init_net = {
+	.dev_base_head = LIST_HEAD_INIT(init_net.dev_base_head),
+};
 EXPORT_SYMBOL(init_net);
 
 #define INITIAL_NET_GEN_PTRS	13 /* +1 for len +2 for rcu_head */


