Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab2EIGPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:15:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38935 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756285Ab2EIFx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:29 -0400
Message-Id: <20120509055041.429945543@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Julian Anastasov <ja@ssi.bg>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 084/167] [PATCH 23/26] netns: do not leak net_generic data on failed init
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit b922934d017f1cc831b017913ed7d1a56c558b43 ]

ops_init should free the net_generic data on
init failure and __register_pernet_operations should not
call ops_free when NET_NS is not enabled.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/net_namespace.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 0e950fd..31a5ae5 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -83,21 +83,29 @@ assign:
 
 static int ops_init(const struct pernet_operations *ops, struct net *net)
 {
-	int err;
+	int err = -ENOMEM;
+	void *data = NULL;
+
 	if (ops->id && ops->size) {
-		void *data = kzalloc(ops->size, GFP_KERNEL);
+		data = kzalloc(ops->size, GFP_KERNEL);
 		if (!data)
-			return -ENOMEM;
+			goto out;
 
 		err = net_assign_generic(net, *ops->id, data);
-		if (err) {
-			kfree(data);
-			return err;
-		}
+		if (err)
+			goto cleanup;
 	}
+	err = 0;
 	if (ops->init)
-		return ops->init(net);
-	return 0;
+		err = ops->init(net);
+	if (!err)
+		return 0;
+
+cleanup:
+	kfree(data);
+
+out:
+	return err;
 }
 
 static void ops_free(const struct pernet_operations *ops, struct net *net)
@@ -448,12 +456,7 @@ static void __unregister_pernet_operations(struct pernet_operations *ops)
 static int __register_pernet_operations(struct list_head *list,
 					struct pernet_operations *ops)
 {
-	int err = 0;
-	err = ops_init(ops, &init_net);
-	if (err)
-		ops_free(ops, &init_net);
-	return err;
-	
+	return ops_init(ops, &init_net);
 }
 
 static void __unregister_pernet_operations(struct pernet_operations *ops)
-- 
1.7.10



