Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2DQHXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:23:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54826 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2DQHXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:23:48 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Yong Zhang <yong.zhang@windriver.com>
Subject: [PATCH 3/3 -rt] lockdep: selftest: save/restore migrate_disable count
Date: Tue, 17 Apr 2012 15:23:39 +0800
Message-Id: <1334647419-10337-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334559716-18447-1-git-send-email-yong.zhang0@gmail.com>
References: <1334559716-18447-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

->migrate_disable_atomic will corrupt when doing some
case, such as double lock...

->migrate_disable will not be affected for now since
we have preempt disabled when doing seft test.
Just record it also for safe.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
Found it when enable CONFIG_SCHED_DEBUG.

 lib/locking-selftest.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 23b8564..a9cb9e4 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -939,6 +939,12 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 {
 	unsigned long saved_preempt_count = preempt_count();
 	int expected_failure = 0;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	int saved_migrate_disable = current->migrate_disable;
+# ifdef CONFIG_SCHED_DEBUG
+	int saved_migrate_disable_atomic = current->migrate_disable_atomic;
+# endif
+#endif
 
 	WARN_ON(irqs_disabled());
 
@@ -980,6 +986,13 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	 * count, so restore it:
 	 */
 	preempt_count() = saved_preempt_count;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	current->migrate_disable = saved_migrate_disable;
+# ifdef CONFIG_SCHED_DEBUG
+	current->migrate_disable_atomic = saved_migrate_disable_atomic;
+# endif
+#endif
+
 #ifdef CONFIG_TRACE_IRQFLAGS
 	if (softirq_count())
 		current->softirqs_enabled = 0;
-- 
1.7.5.4

