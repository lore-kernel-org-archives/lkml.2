Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1AYWTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:19:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60049 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab1AYWSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:18:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 18/20] rtmutex-tester: remove BKL tests
Date: Tue, 25 Jan 2011 23:17:32 +0100
Message-Id: <1295993854-4971-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295993854-4971-1-git-send-email-arnd@arndb.de>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:kCXhAE0Sv168l4qWik6sJWxElBsWlp1HReD0B559Adg
 hwuoDsg9hodk9sRwXYMNobltMnFhLnwc654Bi2RDZHySDtHlk/
 TBBc6qx83mWorhtsVURPAgBSIytM65hhMIxnqiEj7+91+TdWTH
 K3MzIA4t6y/GfFI9Kh/rHO2J7/px9nMDZnqmNoxZJF6V9Vvjiq
 aofv97vperWGqaC1FacZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is going away, no need to test it any more.
I left the definitions of the test case numbers
in, so that the other tests do not get renumbered.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/rtmutex-tester.c |   39 ++++-----------------------------------
 1 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/kernel/rtmutex-tester.c b/kernel/rtmutex-tester.c
index 66cb89b..d5b5435 100644
--- a/kernel/rtmutex-tester.c
+++ b/kernel/rtmutex-tester.c
@@ -9,7 +9,6 @@
 #include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/sysdev.h>
 #include <linux/timer.h>
@@ -27,7 +26,6 @@ struct test_thread_data {
 	int			opcode;
 	int			opdata;
 	int			mutexes[MAX_RT_TEST_MUTEXES];
-	int			bkl;
 	int			event;
 	struct sys_device	sysdev;
 };
@@ -46,8 +44,8 @@ enum test_opcodes {
 	RTTEST_LOCKINTNOWAIT,	/* 6 Lock interruptible no wait in wakeup, data = lockindex */
 	RTTEST_LOCKCONT,	/* 7 Continue locking after the wakeup delay */
 	RTTEST_UNLOCK,		/* 8 Unlock, data = lockindex */
-	RTTEST_LOCKBKL,		/* 9 Lock BKL */
-	RTTEST_UNLOCKBKL,	/* 10 Unlock BKL */
+	RTTEST_LOCKBKL,		/* 9 Was: Lock BKL */
+	RTTEST_UNLOCKBKL,	/* 10 Was: Unlock BKL */
 	RTTEST_SIGNAL,		/* 11 Signal other test thread, data = thread id */
 	RTTEST_RESETEVENT = 98,	/* 98 Reset event counter */
 	RTTEST_RESET = 99,	/* 99 Reset all pending operations */
@@ -74,13 +72,6 @@ static int handle_op(struct test_thread_data *td, int lockwakeup)
 				td->mutexes[i] = 0;
 			}
 		}
-
-		if (!lockwakeup && td->bkl == 4) {
-#ifdef CONFIG_LOCK_KERNEL
-			unlock_kernel();
-#endif
-			td->bkl = 0;
-		}
 		return 0;
 
 	case RTTEST_RESETEVENT:
@@ -131,25 +122,6 @@ static int handle_op(struct test_thread_data *td, int lockwakeup)
 		td->mutexes[id] = 0;
 		return 0;
 
-	case RTTEST_LOCKBKL:
-		if (td->bkl)
-			return 0;
-		td->bkl = 1;
-#ifdef CONFIG_LOCK_KERNEL
-		lock_kernel();
-#endif
-		td->bkl = 4;
-		return 0;
-
-	case RTTEST_UNLOCKBKL:
-		if (td->bkl != 4)
-			break;
-#ifdef CONFIG_LOCK_KERNEL
-		unlock_kernel();
-#endif
-		td->bkl = 0;
-		return 0;
-
 	default:
 		break;
 	}
@@ -196,7 +168,6 @@ void schedule_rt_mutex_test(struct rt_mutex *mutex)
 		td->event = atomic_add_return(1, &rttest_event);
 		break;
 
-	case RTTEST_LOCKBKL:
 	default:
 		break;
 	}
@@ -229,8 +200,6 @@ void schedule_rt_mutex_test(struct rt_mutex *mutex)
 		td->event = atomic_add_return(1, &rttest_event);
 		return;
 
-	case RTTEST_LOCKBKL:
-		return;
 	default:
 		return;
 	}
@@ -380,11 +349,11 @@ static ssize_t sysfs_test_status(struct sys_device *dev, struct sysdev_attribute
 	spin_lock(&rttest_lock);
 
 	curr += sprintf(curr,
-		"O: %4d, E:%8d, S: 0x%08lx, P: %4d, N: %4d, B: %p, K: %d, M:",
+		"O: %4d, E:%8d, S: 0x%08lx, P: %4d, N: %4d, B: %p, M:",
 		td->opcode, td->event, tsk->state,
 			(MAX_RT_PRIO - 1) - tsk->prio,
 			(MAX_RT_PRIO - 1) - tsk->normal_prio,
-		tsk->pi_blocked_on, td->bkl);
+		tsk->pi_blocked_on);
 
 	for (i = MAX_RT_TEST_MUTEXES - 1; i >=0 ; i--)
 		curr += sprintf(curr, "%d", td->mutexes[i]);
-- 
1.7.1

