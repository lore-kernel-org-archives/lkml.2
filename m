Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab0KVOrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:47:46 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:46262 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab0KVOrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:47:42 -0500
Subject: [PATCH] mutex: Introduce arch_mutex_cpu_relax()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 15:47:36 +0100
Message-ID: <1290437256.7455.4.camel@thinkpad>
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
arch_mutex_cpu_relax(), which can be defined by each architecture that
selects HAVE_ARCH_MUTEX_CPU_RELAX. The default is still cpu_relax(), so
this patch should not affect other architectures than System z for now.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/Kconfig                  |    3 +++
 arch/s390/Kconfig             |    1 +
 arch/s390/include/asm/mutex.h |    2 ++
 include/linux/mutex.h         |    4 ++++
 kernel/mutex.c                |    2 +-
 kernel/sched.c                |    3 ++-
 6 files changed, 13 insertions(+), 2 deletions(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -175,4 +175,7 @@ config HAVE_PERF_EVENTS_NMI
 config HAVE_ARCH_JUMP_LABEL
 	bool
 
+config HAVE_ARCH_MUTEX_CPU_RELAX
+	bool
+
 source "kernel/gcov/Kconfig"
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -99,6 +99,7 @@ config S390
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
 	select HAVE_GET_USER_PAGES_FAST
+	select HAVE_ARCH_MUTEX_CPU_RELAX
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
 	select ARCH_INLINE_SPIN_LOCK
--- a/arch/s390/include/asm/mutex.h
+++ b/arch/s390/include/asm/mutex.h
@@ -7,3 +7,5 @@
  */
 
 #include <asm-generic/mutex-dec.h>
+
+#define arch_mutex_cpu_relax()	barrier()
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -160,4 +160,8 @@ extern int mutex_trylock(struct mutex *l
 extern void mutex_unlock(struct mutex *lock);
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
+#ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
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
@@ -75,6 +75,7 @@
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
+#include <asm/mutex.h>
 
 #include "sched_cpupri.h"
 #include "workqueue_sched.h"
@@ -4029,7 +4030,7 @@ int mutex_spin_on_owner(struct mutex *lo
 		if (task_thread_info(rq->curr) != owner || need_resched())
 			return 0;
 
-		cpu_relax();
+		arch_mutex_cpu_relax();
 	}
 
 	return 1;


