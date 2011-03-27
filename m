Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1C0P5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 11:57:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55289 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab1C0P5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 11:57:24 -0400
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: [PATCH] sched, doc: Beef up load balancing description
Date: Sun, 27 Mar 2011 17:57:13 +0200
Message-Id: <1301241433-3790-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.4.1.48.g5673d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct all function names pertaining to load balancing and explain
shortly how load balancing is performed.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 Documentation/scheduler/sched-domains.txt |   32 ++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/Documentation/scheduler/sched-domains.txt b/Documentation/scheduler/sched-domains.txt
index 373ceac..b7ee379 100644
--- a/Documentation/scheduler/sched-domains.txt
+++ b/Documentation/scheduler/sched-domains.txt
@@ -1,8 +1,7 @@
-Each CPU has a "base" scheduling domain (struct sched_domain). These are
-accessed via cpu_sched_domain(i) and this_sched_domain() macros. The domain
+Each CPU has a "base" scheduling domain (struct sched_domain). The domain
 hierarchy is built from these base domains via the ->parent pointer. ->parent
-MUST be NULL terminated, and domain structures should be per-CPU as they
-are locklessly updated.
+MUST be NULL terminated, and domain structures should be per-CPU as they are
+locklessly updated.
 
 Each scheduling domain spans a number of CPUs (stored in the ->span field).
 A domain's span MUST be a superset of it child's span (this restriction could
@@ -26,11 +25,26 @@ is treated as one entity. The load of a group is defined as the sum of the
 load of each of its member CPUs, and only when the load of a group becomes
 out of balance are tasks moved between groups.
 
-In kernel/sched.c, rebalance_tick is run periodically on each CPU. This
-function takes its CPU's base sched domain and checks to see if has reached
-its rebalance interval. If so, then it will run load_balance on that domain.
-rebalance_tick then checks the parent sched_domain (if it exists), and the
-parent of the parent and so forth.
+In kernel/sched.c, trigger_load_balance() is run periodically on each CPU
+through scheduler_tick(). It raises a softirq after the next regularly scheduled
+rebalancing event for the current runqueue has arrived. The actual load
+balancing workhorse, run_rebalance_domains()->rebalance_domains(), is then run
+in softirq context (SCHED_SOFTIRQ).
+
+The latter function takes two arguments: the current CPU and whether it was idle
+at the time the scheduler_tick() happened and iterates over all sched domains
+our CPU is on, starting from its base domain and going up the ->parent chain.
+While doing that, it checks to see if the current domain has exhausted its
+rebalance interval. If so, it runs load_balance() on that domain. It then checks
+the parent sched_domain (if it exists), and the parent of the parent and so
+forth.
+
+Initially, load_balance() finds the busiest group in the current sched domain.
+If it succeeds, it looks for the busiest runqueue of all the CPUs' runqueues in
+that group. If it manages to find such a runqueue, it locks both our initial
+CPU's runqueue and the newly found busiest one and starts moving tasks from it
+to our runqueue. The exact number of tasks amounts to an imbalance previously
+computed while iterating over this sched domain's groups.
 
 *** Implementing sched domains ***
 The "base" domain will "span" the first level of the hierarchy. In the case
-- 
1.7.4.1.48.g5673d

