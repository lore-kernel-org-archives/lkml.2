Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2JVXjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:39:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab2JVXjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:39:42 -0400
Date: Mon, 22 Oct 2012 19:37:47 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 1/2] percpu-rw-semaphores: use light/heavy barriers
In-Reply-To: <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
References: <20121015190958.GA4799@redhat.com> <20121015191018.GA4816@redhat.com>
 <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
 <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new barrier pair light_mb() and heavy_mb() for
percpu rw semaphores.

This patch fixes a bug in percpu-rw-semaphores where a barrier was
missing in percpu_up_write.

This patch improves performance on the read path of
percpu-rw-semaphores: on non-x86 cpus, there was a smp_mb() in
percpu_up_read. This patch changes it to a compiler barrier and removes
the "#if defined(X86) ..." condition.

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/percpu-rwsem.h |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

Index: linux-3.6.3-fast/include/linux/percpu-rwsem.h
===================================================================
--- linux-3.6.3-fast.orig/include/linux/percpu-rwsem.h	2012-10-22 23:37:57.000000000 +0200
+++ linux-3.6.3-fast/include/linux/percpu-rwsem.h	2012-10-23 01:21:23.000000000 +0200
@@ -12,6 +12,9 @@ struct percpu_rw_semaphore {
 	struct mutex mtx;
 };
 
+#define light_mb()	barrier()
+#define heavy_mb()	synchronize_sched()
+
 static inline void percpu_down_read(struct percpu_rw_semaphore *p)
 {
 	rcu_read_lock();
@@ -24,22 +27,12 @@ static inline void percpu_down_read(stru
 	}
 	this_cpu_inc(*p->counters);
 	rcu_read_unlock();
+	light_mb(); /* A, between read of p->locked and read of data, paired with D */
 }
 
 static inline void percpu_up_read(struct percpu_rw_semaphore *p)
 {
-	/*
-	 * On X86, write operation in this_cpu_dec serves as a memory unlock
-	 * barrier (i.e. memory accesses may be moved before the write, but
-	 * no memory accesses are moved past the write).
-	 * On other architectures this may not be the case, so we need smp_mb()
-	 * there.
-	 */
-#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
-	barrier();
-#else
-	smp_mb();
-#endif
+	light_mb(); /* B, between read of the data and write to p->counter, paired with C */
 	this_cpu_dec(*p->counters);
 }
 
@@ -61,11 +54,12 @@ static inline void percpu_down_write(str
 	synchronize_rcu();
 	while (__percpu_count(p->counters))
 		msleep(1);
-	smp_rmb(); /* paired with smp_mb() in percpu_sem_up_read() */
+	heavy_mb(); /* C, between read of p->counter and write to data, paired with B */
 }
 
 static inline void percpu_up_write(struct percpu_rw_semaphore *p)
 {
+	heavy_mb(); /* D, between write to data and write to p->locked, paired with A */
 	p->locked = false;
 	mutex_unlock(&p->mtx);
 }

