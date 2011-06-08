Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1FHTao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:30:44 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38133 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab1FHTad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Subject: [PATCH tip/core/rcu 11/28] audit_tree,rcu: Convert call_rcu(__put_tree) to kfree_rcu()
Date: Wed,  8 Jun 2011 12:29:50 -0700
Message-Id: <1307561407-13809-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback __put_tree() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(__put_tree).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/audit_tree.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index e99dda0..5bf0790 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -93,16 +93,10 @@ static inline void get_tree(struct audit_tree *tree)
 	atomic_inc(&tree->count);
 }
 
-static void __put_tree(struct rcu_head *rcu)
-{
-	struct audit_tree *tree = container_of(rcu, struct audit_tree, head);
-	kfree(tree);
-}
-
 static inline void put_tree(struct audit_tree *tree)
 {
 	if (atomic_dec_and_test(&tree->count))
-		call_rcu(&tree->head, __put_tree);
+		kfree_rcu(tree, head);
 }
 
 /* to avoid bringing the entire thing in audit.h */
-- 
1.7.3.2

