Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1AZPBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:01:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:53427 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab1AZPBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:01:49 -0500
Date: Wed, 26 Jan 2011 15:00:41 GMT
From: tip-bot for Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, arnd@arndb.de, akpm@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: arnd@arndb.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        arjan@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295993854-4971-19-git-send-email-arnd@arndb.de>
References: <1295993854-4971-19-git-send-email-arnd@arndb.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] rtmutex-tester: Remove BKL tests
Message-ID: <tip-ccaa8d657117bb1876d471bd91579d774106778d@git.kernel.org>
Git-Commit-ID: ccaa8d657117bb1876d471bd91579d774106778d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 15:00:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ccaa8d657117bb1876d471bd91579d774106778d
Gitweb:     http://git.kernel.org/tip/ccaa8d657117bb1876d471bd91579d774106778d
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Tue, 25 Jan 2011 23:17:32 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Jan 2011 15:58:12 +0100

rtmutex-tester: Remove BKL tests

The BKL is going away, no need to test it any more.
I left the definitions of the test case numbers
in, so that the other tests do not get renumbered.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1295993854-4971-19-git-send-email-arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
