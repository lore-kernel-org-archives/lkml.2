Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0JNPdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:33:16 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:55363 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab0JNPdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:33:15 -0400
Subject: [PATCH] mutex: Introduce mutex_cpu_relax()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 17:33:12 +0200
Message-ID: <1287070392.8344.15.camel@thinkpad>
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

This patch replaces cpu_relax() in the spinning mutex code with a new
function mutex_cpu_relax(), which can be defined by each architecture
that selects HAVE_MUTEX_CPU_RELAX. The default is still cpu_relax(), so
this patch should not affect other architectures than System z for now.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/s390/Kconfig             |    1 +
 arch/s390/include/asm/mutex.h |    2 ++
 include/linux/mutex.h         |    4 ++++
 kernel/mutex.c                |    2 +-
 kernel/sched.c                |    2 +-
 5 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -100,6 +100,7 @@ config S390
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
+	select HAVE_MUTEX_CPU_RELAX
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
 	select ARCH_INLINE_SPIN_LOCK
--- a/arch/s390/include/asm/mutex.h
+++ b/arch/s390/include/asm/mutex.h
@@ -7,3 +7,5 @@
  */
 
 #include <asm-generic/mutex-dec.h>
+
+#define mutex_cpu_relax()	barrier()
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -160,4 +160,8 @@ extern int mutex_trylock(struct mutex *l
 extern void mutex_unlock(struct mutex *lock);
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
+#ifndef HAVE_MUTEX_CPU_RELAX
+#define mutex_cpu_relax()	cpu_relax()
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
+		mutex_cpu_relax();
 	}
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3888,7 +3888,7 @@ int mutex_spin_on_owner(struct mutex *lo
 		if (task_thread_info(rq->curr) != owner || need_resched())
 			return 0;
 
-		cpu_relax();
+		mutex_cpu_relax();
 	}
 
 	return 1;


