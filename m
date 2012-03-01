Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab2CAMUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:20:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab2CAMUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:20:51 -0500
Date: Thu, 1 Mar 2012 04:19:54 -0800
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-ux6m4b8jonb9inx8xafh77ds@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Add __wake_up_all_locked() API
Git-Commit-ID: 63b2001169e75cd71e917ec953fdab572e3f944a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:20:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63b2001169e75cd71e917ec953fdab572e3f944a
Gitweb:     http://git.kernel.org/tip/63b2001169e75cd71e917ec953fdab572e3f944a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 1 Dec 2011 00:04:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:28:04 +0100

sched/wait: Add __wake_up_all_locked() API

For code which protects the waitqueue itself with another lock it
makes no sense to acquire the waitqueue lock for wakeup all. Provide
__wake_up_all_locked().

This is an optimization on the vanilla kernel (to be used by the
PCI code) and an important semantic distinction on -rt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-ux6m4b8jonb9inx8xafh77ds@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/wait.h |    5 +++--
 kernel/sched/core.c  |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index a9ce45e..7d9a9e9 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -157,7 +157,7 @@ void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr,
 			void *key);
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
 int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
@@ -170,7 +170,8 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
-#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)
+#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1)
+#define wake_up_all_locked(x)		__wake_up_locked((x), TASK_NORMAL, 0)
 
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 643cc37..820f745 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3418,9 +3418,9 @@ EXPORT_SYMBOL(__wake_up);
 /*
  * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
  */
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr)
 {
-	__wake_up_common(q, mode, 1, 0, NULL);
+	__wake_up_common(q, mode, nr, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked);
 
