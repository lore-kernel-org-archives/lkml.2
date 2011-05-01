Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656Ab1EANe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:34:26 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53903 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab1EANWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 35/86] cgroup,rcu: convert call_rcu(free_cgroup_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:15 -0700
Message-Id: <1304256126-26015-35-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback free_cgroup_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_cgroup_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/cgroup.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d5160a8..20451ce 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -806,13 +806,6 @@ static int cgroup_call_pre_destroy(struct cgroup *cgrp)
 	return ret;
 }
 
-static void free_cgroup_rcu(struct rcu_head *obj)
-{
-	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
-
-	kfree(cgrp);
-}
-
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
@@ -850,7 +843,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 */
 		BUG_ON(!list_empty(&cgrp->pidlists));
 
-		call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
+		kfree_rcu(cgrp, rcu_head);
 	}
 	iput(inode);
 }
-- 
1.7.3.2

