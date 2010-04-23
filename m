Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0DWTno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:43:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42465 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab0DWTnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:43:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Li Zefan <lizf@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2.6.34-rc5 11/12] cgroup: Check task_lock in task_subsys_state()
Date: Fri, 23 Apr 2010 12:43:29 -0700
Message-Id: <1272051810-11249-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100423194255.GE2589@linux.vnet.ibm.com>
References: <20100423194255.GE2589@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Expand task_subsys_state()'s rcu_dereference_check() to include the full
locking rule as documented in Documentation/cgroups/cgroups.txt by adding
a check for task->alloc_lock being held.

This fixes an RCU false positive when resuming from suspend. The warning
comes from freezer cgroup in cgroup_freezing_or_frozen().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/cgroup.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b8ad1ea..8f78073 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -530,6 +530,7 @@ static inline struct cgroup_subsys_state *task_subsys_state(
 {
 	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
 				     rcu_read_lock_held() ||
+				     lockdep_is_held(&task->alloc_lock) ||
 				     cgroup_lock_is_held());
 }
 
-- 
1.7.0

