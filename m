Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab0GNUQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:16:10 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52313 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508Ab0GNUKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:16 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 01/30] net: convert to rcu_dereference_index_check()
Date: Wed, 14 Jul 2010 13:09:35 -0700
Message-Id: <1279138204-12849-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The task_cls_classid() function applies rcu_dereference() to integers,
which does not work with the shiny new sparse-based checking in
rcu_dereference().  This commit therefore moves to the new RCU API
rcu_dereference_index_check().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/net/cls_cgroup.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index 726cc35..dd1fdb8 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -45,7 +45,8 @@ static inline u32 task_cls_classid(struct task_struct *p)
 		return 0;
 
 	rcu_read_lock();
-	id = rcu_dereference(net_cls_subsys_id);
+	id = rcu_dereference_index_check(net_cls_subsys_id,
+					 rcu_read_lock_held());
 	if (id >= 0)
 		classid = container_of(task_subsys_state(p, id),
 				       struct cgroup_cls_state, css)->classid;
-- 
1.7.0.6

