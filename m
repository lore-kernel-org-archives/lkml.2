Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752Ab2I1Uwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:52:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54216 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945926Ab2I1Ush (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:37 -0400
X-Sasl-enc: dVL5e3OMmrZwgK/Z8MPlGERLKNjbhpOg2ZRV+MXjMdG9 1348865316
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Rustad <mark.d.rustad@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 100/127] net: Statically initialize init_net.dev_base_head
Date: Fri, 28 Sep 2012 13:34:33 -0700
Message-Id: <20120928203057.607614395@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rustad, Mark D" <mark.d.rustad@intel.com>

commit 734b65417b24d6eea3e3d7457e1f11493890ee1d upstream.

This change eliminates an initialization-order hazard most
recently seen when netprio_cgroup is built into the kernel.

With thanks to Eric Dumazet for catching a bug.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/dev.c           |    3 ++-
 net/core/net_namespace.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6260,7 +6260,8 @@ static struct hlist_head *netdev_create_
 /* Initialize per network namespace state */
 static int __net_init netdev_init(struct net *net)
 {
-	INIT_LIST_HEAD(&net->dev_base_head);
+	if (net != &init_net)
+		INIT_LIST_HEAD(&net->dev_base_head);
 
 	net->dev_name_head = netdev_create_hash();
 	if (net->dev_name_head == NULL)
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -24,7 +24,9 @@ static DEFINE_MUTEX(net_mutex);
 LIST_HEAD(net_namespace_list);
 EXPORT_SYMBOL_GPL(net_namespace_list);
 
-struct net init_net;
+struct net init_net = {
+	.dev_base_head = LIST_HEAD_INIT(init_net.dev_base_head),
+};
 EXPORT_SYMBOL(init_net);
 
 #define INITIAL_NET_GEN_PTRS	13 /* +1 for len +2 for rcu_head */


