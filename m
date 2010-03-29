Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0C2VPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:15:30 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50279 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0C2VP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:15:29 -0400
Date: Mon, 29 Mar 2010 14:15:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       abogani@texware.it
Subject: [PATCH tip/core/urgent] rcu: protect fork-time cgroup access
Message-ID: <20100329211525.GA17703@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an rcu_read_lock() / rcu_read_unlock() pair to protect a fork-time
cgroup access.  This seems likely to be a false positive.

Located by: Alessio Igor Bogani <abogani@texware.it>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 sched.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9ab3cd7..d4bb5e0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2621,7 +2621,9 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
 
+	rcu_read_lock();
 	set_task_cpu(p, cpu);
+	rcu_read_unlock();
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
