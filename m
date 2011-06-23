Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834Ab1FWRik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:35527 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778Ab1FWRib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Milton Miller <miltonm@bga.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 199/247] smp_call_function_many: handle concurrent clearing of mask
Date: Thu, 23 Jun 2011 13:34:27 -0400
Message-Id: <1308850515-15242-140-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 723aae25d5cdb09962901d36d526b44d4be1051c upstream.

Mike Galbraith reported finding a lockup ("perma-spin bug") where the
cpumask passed to smp_call_function_many was cleared by other cpu(s)
while a cpu was preparing its call_data block, resulting in no cpu to
clear the last ref and unlock the block.

Having cpus clear their bit asynchronously could be useful on a mask of
cpus that might have a translation context, or cpus that need a push to
complete an rcu window.

Instead of adding a BUG_ON and requiring yet another cpumask copy, just
detect the race and handle it.

Note: arch_send_call_function_ipi_mask must still handle an empty
cpumask because the data block is globally visible before the that arch
callback is made.  And (obviously) there are no guarantees to which cpus
are notified if the mask is changed during the call; only cpus that were
online and had their mask bit set during the whole call are guaranteed
to be called.

Reported-by: Mike Galbraith <efault@gmx.de>
Reported-by: Jan Beulich <JBeulich@novell.com>
Acked-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/smp.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 9686dbf..37f3208 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -429,7 +429,7 @@ void smp_call_function_many(const struct cpumask *mask,
 {
 	struct call_function_data *data;
 	unsigned long flags;
-	int cpu, next_cpu, this_cpu = smp_processor_id();
+	int refs, cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/*
 	 * Can deadlock when called with interrupts disabled.
@@ -440,7 +440,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
 		     && !oops_in_progress);
 
-	/* So, what's a CPU they want? Ignoring this one. */
+	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
 	if (cpu == this_cpu)
 		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
@@ -498,6 +498,13 @@ void smp_call_function_many(const struct cpumask *mask,
 	/* We rely on the "and" being processed before the store */
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
+	refs = cpumask_weight(data->cpumask);
+
+	/* Some callers race with other cpus changing the passed mask */
+	if (unlikely(!refs)) {
+		csd_unlock(&data->csd);
+		return;
+	}
 
 	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*
@@ -511,7 +518,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	 * to the cpumask before this write to refs, which indicates
 	 * data is on the list and is ready to be processed.
 	 */
-	atomic_set(&data->refs, cpumask_weight(data->cpumask));
+	atomic_set(&data->refs, refs);
 	raw_spin_unlock_irqrestore(&call_function.lock, flags);
 
 	/*
-- 
1.7.4.4

