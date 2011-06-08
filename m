Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab1FHTdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:33:46 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38156 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652Ab1FHTaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 26/28] sysctl,rcu: Convert call_rcu(free_head) to kfree
Date: Wed,  8 Jun 2011 12:30:05 -0700
Message-Id: <1307561407-13809-26-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU callback free_head just calls kfree(), so we can use kfree_rcu()
instead of call_rcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sysctl.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c0bb324..39dbad0 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1574,16 +1574,11 @@ void sysctl_head_get(struct ctl_table_header *head)
 	spin_unlock(&sysctl_lock);
 }
 
-static void free_head(struct rcu_head *rcu)
-{
-	kfree(container_of(rcu, struct ctl_table_header, rcu));
-}
-
 void sysctl_head_put(struct ctl_table_header *head)
 {
 	spin_lock(&sysctl_lock);
 	if (!--head->count)
-		call_rcu(&head->rcu, free_head);
+		kfree_rcu(head, rcu);
 	spin_unlock(&sysctl_lock);
 }
 
@@ -1955,10 +1950,10 @@ void unregister_sysctl_table(struct ctl_table_header * header)
 	start_unregistering(header);
 	if (!--header->parent->count) {
 		WARN_ON(1);
-		call_rcu(&header->parent->rcu, free_head);
+		kfree_rcu(header->parent, rcu);
 	}
 	if (!--header->count)
-		call_rcu(&header->rcu, free_head);
+		kfree_rcu(header, rcu);
 	spin_unlock(&sysctl_lock);
 }
 
-- 
1.7.3.2

