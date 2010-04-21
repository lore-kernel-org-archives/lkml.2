Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0DUUC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:02:29 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38535 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab0DUUCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:02:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 2/5] rcu: fix RCU lockdep splat on freezer_fork path
Date: Wed, 21 Apr 2010 13:02:08 -0700
Message-Id: <1271880131-3951-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100421200150.GA3818@linux.vnet.ibm.com>
References: <20100421200150.GA3818@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an RCU read-side critical section to suppress this false positive.

Located-by: Eric Paris <eparis@parisplace.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup_freezer.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index da5e139..e5c0244 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -205,9 +205,12 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	 * No lock is needed, since the task isn't on tasklist yet,
 	 * so it can't be moved to another cgroup, which means the
 	 * freezer won't be removed and will be valid during this
-	 * function call.
+	 * function call.  Nevertheless, apply RCU read-side critical
+	 * section to suppress RCU lockdep false positives.
 	 */
+	rcu_read_lock();
 	freezer = task_freezer(task);
+	rcu_read_unlock();
 
 	/*
 	 * The root cgroup is non-freezable, so we can skip the
-- 
1.7.0

