Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762699Ab2KBCsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 22:48:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762645Ab2KBCsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 22:48:19 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>
Subject: [RFC PATCH] tasklet: ignore disabled tasklet in tasklet_action
Date: Fri,  2 Nov 2012 10:48:54 +0800
Message-Id: <1351824534-2861-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We met a ksoftirqd 100% issue, the perf top shows kernel is busy
with tasklet_action(), but no actual action is shown. From dumped
kernel, there's only one disabled tasklet on the tasklet_vec.

tasklet_action might be handled after tasklet is disabled, this will
make disabled tasklet stayed on tasklet_vec. tasklet_action will not
handle disabled tasklet, but place it on the tail of tasklet_vec,
still raise softirq for this tasklet. Things will become worse if
device driver uses tasklet_disable on its device remove/close code.
The disabled tasklet will stay on the vec, frequently __raise_softirq_off()
and make ksoftirqd wakeup even if no tasklets need to be handled.

This patch introduced a new TASKLET_STATE_HI bit to indicate HI_SOFTIRQ,
in tasklet_action(), simply ignore the disabled tasklet and don't raise
the softirq nr. In my previous patch, I remove tasklet_hi_enable() since
it is the same as tasklet_enable(). So only tasklet_enable() needs to be
modified, if tasklet state is changed from disable to enable, use
__tasklet_schedule() to put it on the right vec.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/interrupt.h |   12 ++++++++++--
 kernel/softirq.c          |   10 +++++-----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5e4e617..7e5bb00 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -521,7 +521,8 @@ struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
 enum
 {
 	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
-	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_RUN,	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_HI	/* Tasklet is HI_SOFTIRQ */
 };
 
 #ifdef CONFIG_SMP
@@ -593,7 +594,14 @@ static inline void tasklet_disable(struct tasklet_struct *t)
 static inline void tasklet_enable(struct tasklet_struct *t)
 {
 	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
+	if (atomic_dec_and_test(&t->count)) {
+		if (!test_bit(TASKLET_STATE_SCHED, &t->state))
+			return;
+		if (test_bit(TASKLET_STATE_HI, &t->state))
+			__tasklet_hi_schedule(t);
+		else
+			__tasklet_schedule(t);
+	}
 }
 
 static inline void tasklet_hi_enable(struct tasklet_struct *t)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index cc96bdc..6d77aef 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -431,6 +431,7 @@ void __tasklet_hi_schedule(struct tasklet_struct *t)
 	*__this_cpu_read(tasklet_hi_vec.tail) = t;
 	__this_cpu_write(tasklet_hi_vec.tail,  &(t->next));
 	raise_softirq_irqoff(HI_SOFTIRQ);
+	set_bit(TASKLET_STATE_HI, &t->state);
 	local_irq_restore(flags);
 }
 
@@ -442,6 +443,7 @@ void __tasklet_hi_schedule_first(struct tasklet_struct *t)
 
 	t->next = __this_cpu_read(tasklet_hi_vec.head);
 	__this_cpu_write(tasklet_hi_vec.head, t);
+	set_bit(TASKLET_STATE_HI, &t->state);
 	__raise_softirq_irqoff(HI_SOFTIRQ);
 }
 
@@ -467,10 +469,9 @@ static void tasklet_action(struct softirq_action *a)
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
 				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
-			}
+			} 
 			tasklet_unlock(t);
+			continue;
 		}
 
 		local_irq_disable();
@@ -502,10 +503,9 @@ static void tasklet_hi_action(struct softirq_action *a)
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
 				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
 			}
 			tasklet_unlock(t);
+			continue;
 		}
 
 		local_irq_disable();
-- 
1.7.9.5

