Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0FOW3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 18:29:50 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46132 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab0FOW3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 18:29:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 2/3] rcu: fix scope of wake_affine()'s new RCU read-side critical section
Date: Tue, 15 Jun 2010 15:29:42 -0700
Message-Id: <1276640983-14641-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100615222923.GA14571@linux.vnet.ibm.com>
References: <20100615222923.GA14571@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU read-side critical section needs to cover all uses of the pointer
returned by task_group().

Located-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ca56133..a878b53 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1250,7 +1250,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	}
 
 	tg = task_group(p);
-	rcu_read_unlock();
 	weight = p->se.load.weight;
 
 	/*
@@ -1277,6 +1276,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		balanced = this_eff_load <= prev_eff_load;
 	} else
 		balanced = true;
+	rcu_read_unlock();
 
 	/*
 	 * If the currently running task will sleep within
-- 
1.7.0.6

