Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab0JOLIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 07:08:51 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:48373 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab0JOLIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 07:08:50 -0400
Subject: [PATCH] mutex: Introduce arch_mutex_cpu_relax()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <1287140101.2547.6.camel@thinkpad>
References: <1287070392.8344.15.camel@thinkpad>
	 <1287071960.29097.284.camel@twins>	<1287077465.8344.47.camel@thinkpad>
	 <1287078025.8344.56.camel@thinkpad>
	 <20101014151349.826b5271.akpm@linux-foundation.org>
	 <1287140101.2547.6.camel@thinkpad>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 13:07:35 +0200
Message-ID: <1287140855.2547.18.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

The spinning mutex implementation uses cpu_relax() in busy loops as a
compiler barrier. Depending on the architecture, cpu_relax() may do more
than needed in this specific mutex spin loops. On System z we also give
up the time slice of the virtual cpu in cpu_relax(), which prevents
effective spinning on the mutex.

This patch replaces cpu_relax() in the spinning mutex code with
arch_mutex_cpu_relax(), which can be defined by each architecture in
include/asm/mutex.h. The default is still cpu_relax(), so this should
not affect other architectures than System z for now.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/s390/include/asm/mutex.h |    2 ++
 include/linux/mutex.h         |    9 +++++++++
 kernel/mutex.c                |    2 +-
 kernel/sched.c                |    2 +-
 4 files changed, 13 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/mutex.h
+++ b/arch/s390/include/asm/mutex.h
@@ -7,3 +7,5 @@
  */
 
 #include <asm-generic/mutex-dec.h>
+
+#define arch_mutex_cpu_relax()	barrier()
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -16,6 +16,7 @@
 #include <linux/lockdep.h>
 
 #include <asm/atomic.h>
+#include <asm/mutex.h>
 
 /*
  * Simple, straightforward mutexes with strict semantics:
@@ -160,4 +161,12 @@ extern int mutex_trylock(struct mutex *l
 extern void mutex_unlock(struct mutex *lock);
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
+/*
+ * An architecture specific version of arch_mutex_cpu_relax() can be defined
+ * in include/asm/mutex.h.
+ */
+#ifndef arch_mutex_cpu_relax
+#define arch_mutex_cpu_relax()	cpu_relax()
+#endif
+
 #endif
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -199,7 +199,7 @@ __mutex_lock_common(struct mutex *lock,
 		 * memory barriers as we'll eventually observe the right
 		 * values at the cost of a few extra spins.
 		 */
-		cpu_relax();
+		arch_mutex_cpu_relax();
 	}
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3888,7 +3888,7 @@ int mutex_spin_on_owner(struct mutex *lo
 		if (task_thread_info(rq->curr) != owner || need_resched())
 			return 0;
 
-		cpu_relax();
+		arch_mutex_cpu_relax();
 	}
 
 	return 1;


