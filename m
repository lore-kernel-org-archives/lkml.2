Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1CREEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:04:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64393 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab1CREEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:04:46 -0400
Message-ID: <4D82DA48.2070305@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:06:32 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/36] net,rcu: convert call_rcu(net_generic_release) to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:03:23,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:03:24,
	Serialize complete at 2011-03-18 12:03:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback net_generic_release() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(net_generic_release).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/core/net_namespace.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 3f86026..297bb92 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -27,14 +27,6 @@ EXPORT_SYMBOL(init_net);
 
 #define INITIAL_NET_GEN_PTRS	13 /* +1 for len +2 for rcu_head */
 
-static void net_generic_release(struct rcu_head *rcu)
-{
-	struct net_generic *ng;
-
-	ng = container_of(rcu, struct net_generic, rcu);
-	kfree(ng);
-}
-
 static int net_assign_generic(struct net *net, int id, void *data)
 {
 	struct net_generic *ng, *old_ng;
@@ -68,7 +60,7 @@ static int net_assign_generic(struct net *net, int id, void *data)
 	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len * sizeof(void*));
 
 	rcu_assign_pointer(net->gen, ng);
-	call_rcu(&old_ng->rcu, net_generic_release);
+	kfree_rcu(old_ng, rcu);
 assign:
 	ng->ptr[id - 1] = data;
 	return 0;
-- 
1.7.4
