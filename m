Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab1EAN1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:27:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60597 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334Ab1EANWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 68/86] net,rcu: convert call_rcu(wq_free_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:48 -0700
Message-Id: <1304256126-26015-68-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback wq_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(wq_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/socket.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 310d16b..c2ed7c9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -263,15 +263,6 @@ static struct inode *sock_alloc_inode(struct super_block *sb)
 	return &ei->vfs_inode;
 }
 
-
-
-static void wq_free_rcu(struct rcu_head *head)
-{
-	struct socket_wq *wq = container_of(head, struct socket_wq, rcu);
-
-	kfree(wq);
-}
-
 static void sock_destroy_inode(struct inode *inode)
 {
 	struct socket_alloc *ei;
@@ -279,7 +270,7 @@ static void sock_destroy_inode(struct inode *inode)
 
 	ei = container_of(inode, struct socket_alloc, vfs_inode);
 	wq = rcu_dereference_protected(ei->socket.wq, 1);
-	call_rcu(&wq->rcu, wq_free_rcu);
+	kfree_rcu(wq, rcu);
 	kmem_cache_free(sock_inode_cachep, ei);
 }
 
-- 
1.7.3.2

