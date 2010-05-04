Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab0EDMjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:39:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:51768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab0EDMjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:14 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/12] sched: drop @cpu argument from sched_in preempt notifier
Date: Tue,  4 May 2010 14:38:33 +0200
Message-Id: <1272976724-14312-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@cpu parameter is superflous.  Drop it.  This will help unifying
notifiers in sched.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/preempt.h |    3 +--
 kernel/sched.c          |    2 +-
 virt/kvm/kvm_main.c     |    4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 2e681d9..cd7d090 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -101,7 +101,6 @@ struct preempt_notifier;
  * preempt_ops - notifiers called when a task is preempted and rescheduled
  * @sched_in: we're about to be rescheduled:
  *    notifier: struct preempt_notifier for the task being scheduled
- *    cpu:  cpu we're scheduled on
  * @sched_out: we've just been preempted
  *    notifier: struct preempt_notifier for the task being preempted
  *    next: the task that's kicking us out
@@ -112,7 +111,7 @@ struct preempt_notifier;
  * difference is intentional and depended upon by its users.
  */
 struct preempt_ops {
-	void (*sched_in)(struct preempt_notifier *notifier, int cpu);
+	void (*sched_in)(struct preempt_notifier *notifier);
 	void (*sched_out)(struct preempt_notifier *notifier,
 			  struct task_struct *next);
 };
diff --git a/kernel/sched.c b/kernel/sched.c
index 6af210a..724f0e4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2718,7 +2718,7 @@ static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
 	struct hlist_node *node;
 
 	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
-		notifier->ops->sched_in(notifier, raw_smp_processor_id());
+		notifier->ops->sched_in(notifier);
 }
 
 static void
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c82ae24..2c06489 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2164,11 +2164,11 @@ struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
 	return container_of(pn, struct kvm_vcpu, preempt_notifier);
 }
 
-static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
+static void kvm_sched_in(struct preempt_notifier *pn)
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	kvm_arch_vcpu_load(vcpu, cpu);
+	kvm_arch_vcpu_load(vcpu, raw_smp_processor_id());
 }
 
 static void kvm_sched_out(struct preempt_notifier *pn,
-- 
1.6.4.2

