Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab1LPQ0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:26:01 -0500
Received: from zeus.madism.org ([88.190.14.41]:58750 "EHLO zeus.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab1LPQZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:25:54 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Dec 2011 11:25:54 EST
From: Pierre Habouzit <pierre.habouzit@intersec.com>
To: linux-kernel@vger.kernel.org
Cc: Pierre Habouzit <pierre.habouzit@intersec.com>,
        Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: allow preempt notifiers to self-unregister.
Date: Fri, 16 Dec 2011 17:15:50 +0100
Message-Id: <1324052151-3714-1-git-send-email-pierre.habouzit@intersec.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is very annoying when unlike kvm (the sole in-tree user I know of)
the process is a plain user process the kernel doesn't really handle and
that it wants to unregister the callbacks just at its death.

The code that one would like to write is:

    static my_module_sched_out(struct preempt_notifier *notifier)
    {
        struct my_module_type *mmi =
            container_of(notifier, struct my_module_type, notifier);

        if (unlikely(current->state & TASK_DEAD)) {
            preempt_notifier_unregister(notifier);
            kfree(mmi);
            return;
        }

        /* do our real work */
    }

Sadly this isn't allowed because the htlist walk isn't "safe" against
removals.

Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

  As a background, this need is because I have some kind of module code
  that uses this facility to evaluate how many of a group of threads are
  concurrently running (to regulate a pool of threads).

  Hence I install those callbacks for the thread registering themselves
  and want to keep them until the thread dies. Sadly I have no way to
  unregister those callbacks right now, but for horrible hacks (involving
  private delayed queues processed regularly walked to kfree() the
  structures referencing pids that are dead, urgh).

diff --git a/kernel/sched.c b/kernel/sched.c
index d6b149c..2653169 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3106,7 +3106,7 @@ static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
 	struct preempt_notifier *notifier;
 	struct hlist_node *node;
 
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
+	hlist_for_each_entry_safe(notifier, node, &curr->preempt_notifiers, link)
 		notifier->ops->sched_in(notifier, raw_smp_processor_id());
 }
 
@@ -3117,7 +3117,7 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
 	struct preempt_notifier *notifier;
 	struct hlist_node *node;
 
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
+	hlist_for_each_entry_safe(notifier, node, &curr->preempt_notifiers, link)
 		notifier->ops->sched_out(notifier, next);
 }
 
-- 
1.7.8.rc3.348.gb51a37

