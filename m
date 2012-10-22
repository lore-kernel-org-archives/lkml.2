Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2JVXja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:39:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab2JVXj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:39:29 -0400
Date: Mon, 22 Oct 2012 19:39:16 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 2/2] percpu-rw-semaphores: use rcu_read_lock_sched
In-Reply-To: <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1210221937550.25995@file.rdu.redhat.com>
References: <20121015190958.GA4799@redhat.com> <20121015191018.GA4816@redhat.com>
 <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
 <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rcu_read_lock_sched / rcu_read_unlock_sched / synchronize_sched
instead of rcu_read_lock / rcu_read_unlock / synchronize_rcu.

This is an optimization. The RCU-protected region is very small, so
there will be no latency problems if we disable preempt in this region.

So we use rcu_read_lock_sched / rcu_read_unlock_sched that translates
to preempt_disable / preempt_disable. It is smaller (and supposedly
faster) than preemptible rcu_read_lock / rcu_read_unlock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/percpu-rwsem.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-3.6.3-fast/include/linux/percpu-rwsem.h
===================================================================
--- linux-3.6.3-fast.orig/include/linux/percpu-rwsem.h	2012-10-23 01:21:49.000000000 +0200
+++ linux-3.6.3-fast/include/linux/percpu-rwsem.h	2012-10-23 01:36:23.000000000 +0200
@@ -17,16 +17,16 @@ struct percpu_rw_semaphore {
 
 static inline void percpu_down_read(struct percpu_rw_semaphore *p)
 {
-	rcu_read_lock();
+	rcu_read_lock_sched();
 	if (unlikely(p->locked)) {
-		rcu_read_unlock();
+		rcu_read_unlock_sched();
 		mutex_lock(&p->mtx);
 		this_cpu_inc(*p->counters);
 		mutex_unlock(&p->mtx);
 		return;
 	}
 	this_cpu_inc(*p->counters);
-	rcu_read_unlock();
+	rcu_read_unlock_sched();
 	light_mb(); /* A, between read of p->locked and read of data, paired with D */
 }
 
@@ -51,7 +51,7 @@ static inline void percpu_down_write(str
 {
 	mutex_lock(&p->mtx);
 	p->locked = true;
-	synchronize_rcu();
+	synchronize_sched(); /* make sure that all readers exit the rcu_read_lock_sched region */
 	while (__percpu_count(p->counters))
 		msleep(1);
 	heavy_mb(); /* C, between read of p->counter and write to data, paired with B */

