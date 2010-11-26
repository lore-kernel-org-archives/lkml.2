Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0KZPDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:03:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:40268 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab0KZPDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:03:13 -0500
Date: Fri, 26 Nov 2010 15:02:45 GMT
From: tip-bot for Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, gerald.schaefer@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, gerald.schaefer@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1290437256.7455.4.camel@thinkpad>
References: <1290437256.7455.4.camel@thinkpad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mutexes, sched: Introduce arch_mutex_cpu_relax()
Message-ID: <tip-335d7afbfb71faac833734a94240c1e07cf0ead8@git.kernel.org>
Git-Commit-ID: 335d7afbfb71faac833734a94240c1e07cf0ead8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:02:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  335d7afbfb71faac833734a94240c1e07cf0ead8
Gitweb:     http://git.kernel.org/tip/335d7afbfb71faac833734a94240c1e07cf0ead8
Author:     Gerald Schaefer <gerald.schaefer@de.ibm.com>
AuthorDate: Mon, 22 Nov 2010 15:47:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:05:34 +0100

mutexes, sched: Introduce arch_mutex_cpu_relax()

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290437256.7455.4.camel@thinkpad>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/Kconfig                  |    3 +++
 arch/s390/Kconfig             |    1 +
 arch/s390/include/asm/mutex.h |    2 ++
 include/linux/mutex.h         |    4 ++++
 kernel/mutex.c                |    2 +-
 kernel/sched.c                |    3 ++-
 6 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8bf0fa65..f78c2be 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -175,4 +175,7 @@ config HAVE_PERF_EVENTS_NMI
 config HAVE_ARCH_JUMP_LABEL
 	bool
 
+config HAVE_ARCH_MUTEX_CPU_RELAX
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index e0b98e7..6c6d7b3 100644
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
diff --git a/arch/s390/include/asm/mutex.h b/arch/s390/include/asm/mutex.h
index 458c1f7..688271f 100644
--- a/arch/s390/include/asm/mutex.h
+++ b/arch/s390/include/asm/mutex.h
@@ -7,3 +7,5 @@
  */
 
 #include <asm-generic/mutex-dec.h>
+
+#define arch_mutex_cpu_relax()	barrier()
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index f363bc8..94b48bd 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -160,4 +160,8 @@ extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
+#ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
+#define arch_mutex_cpu_relax()	cpu_relax()
+#endif
+
 #endif
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 200407c..a5889fb 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -199,7 +199,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * memory barriers as we'll eventually observe the right
 		 * values at the cost of a few extra spins.
 		 */
-		cpu_relax();
+		arch_mutex_cpu_relax();
 	}
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
diff --git a/kernel/sched.c b/kernel/sched.c
index 3e8a7db..abe7aec 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -75,6 +75,7 @@
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
+#include <asm/mutex.h>
 
 #include "sched_cpupri.h"
 #include "workqueue_sched.h"
@@ -3888,7 +3889,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 		if (task_thread_info(rq->curr) != owner || need_resched())
 			return 0;
 
-		cpu_relax();
+		arch_mutex_cpu_relax();
 	}
 
 	return 1;
