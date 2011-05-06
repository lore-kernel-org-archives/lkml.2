Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab1EFVGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:06:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:33070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab1EFVFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="639164503"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, arnd@arndb.de, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] Remove last BKL leftover: lock_depth
Date: Fri,  6 May 2011 14:05:28 -0700
Message-Id: <1304715928-19266-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
References: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This was the (hopefully) last BKL leftover: the per task lock_depth
field.

After all users are gone remove the task_struct lock_depth field.
Depending on the configuration this will not actually shrink task_struct
unfortunately due to padding. It helps a bit on 32bit. And on 64bit
it allows new bloat.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/init_task.h |    1 -
 include/linux/sched.h     |    2 --
 kernel/fork.c             |    1 -
 3 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index caa151f..689496b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -134,7 +134,6 @@ extern struct cred init_cred;
 	.stack		= &init_thread_info,				\
 	.usage		= ATOMIC_INIT(2),				\
 	.flags		= PF_KTHREAD,					\
-	.lock_depth	= -1,						\
 	.prio		= MAX_PRIO-20,					\
 	.static_prio	= MAX_PRIO-20,					\
 	.normal_prio	= MAX_PRIO-20,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53373bc..006c31f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1193,8 +1193,6 @@ struct task_struct {
 	unsigned int flags;	/* per process flags, defined below */
 	unsigned int ptrace;
 
-	int lock_depth;		/* BKL lock depth */
-
 #ifdef CONFIG_SMP
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
diff --git a/kernel/fork.c b/kernel/fork.c
index e7548de..aca6287 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1103,7 +1103,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	posix_cpu_timers_init(p);
 
-	p->lock_depth = -1;		/* -1 = no lock */
 	do_posix_clock_monotonic_gettime(&p->start_time);
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
-- 
1.7.4.4

