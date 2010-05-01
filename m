Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab0EAA1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:27:37 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54655 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110Ab0EAA0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:26:22 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Li Zefan <lizf@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 06/10] sched: Fix an RCU warning in print_task()
Date: Fri, 30 Apr 2010 17:26:10 -0700
Message-Id: <1272673574-27797-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100501002548.GA27375@linux.vnet.ibm.com>
References: <20100501002548.GA27375@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

With CONFIG_PROVE_RCU=y, a warning can be triggered:

  $ cat /proc/sched_debug

...
kernel/cgroup.c:1649 invoked rcu_dereference_check() without protection!
...

Both cgroup_path() and task_group() should be called with either
rcu_read_lock or cgroup_mutex held.

The rcu_dereference_check() does include cgroup_lock_is_held(), so we
know that this lock is not held.  Therefore, in a CONFIG_PREEMPT kernel,
to say nothing of a CONFIG_PREEMPT_RT kernel, the original code could
have ended up copying a string out of the freelist.

This patch inserts RCU read-side primitives needed to prevent this
scenario.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/sched_debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 9b49db1..19be00b 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -114,7 +114,9 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	{
 		char path[64];
 
+		rcu_read_lock();
 		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
+		rcu_read_unlock();
 		SEQ_printf(m, " %s", path);
 	}
 #endif
-- 
1.7.0

