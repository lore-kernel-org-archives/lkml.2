Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671Ab1EANfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:35:48 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54857 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab1EANWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 34/86] cgroup,rcu: convert call_rcu(free_css_set_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:14 -0700
Message-Id: <1304256126-26015-34-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback free_css_set_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_css_set_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/cgroup.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 25c7eb5..d5160a8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -326,12 +326,6 @@ static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
 	return &css_set_table[index];
 }
 
-static void free_css_set_rcu(struct rcu_head *obj)
-{
-	struct css_set *cg = container_of(obj, struct css_set, rcu_head);
-	kfree(cg);
-}
-
 /* We don't maintain the lists running through each css_set to its
  * task until after the first call to cgroup_iter_start(). This
  * reduces the fork()/exit() overhead for people who have cgroups
@@ -375,7 +369,7 @@ static void __put_css_set(struct css_set *cg, int taskexit)
 	}
 
 	write_unlock(&css_set_lock);
-	call_rcu(&cg->rcu_head, free_css_set_rcu);
+	kfree_rcu(cg, rcu_head);
 }
 
 /*
-- 
1.7.3.2

