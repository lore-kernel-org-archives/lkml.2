Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1IZKT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:19:26 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49679 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1IZKTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:19:24 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/7] rcu: Fix preempt-unsafe debug check of rcu extended quiescent state
Date: Mon, 26 Sep 2011 12:19:06 +0200
Message-Id: <1317032352-25571-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the rcu_check_extended_qs() function that is used to check
illegal uses of RCU under extended quiescent states, we look
at the local value of dynticks that is even if an extended
quiescent state or odd otherwise.

We are looking at it without disabling the preemption though
and this opens a race window where we may read the state of
a remote CPU instead, like in the following scenario:

CPU 1                                                        CPU 2

bool rcu_check_extended_qs(void)
{
	struct rcu_dynticks *rdtp;

	rdtp = &per_cpu(rcu_dynticks,
			raw_smp_processor_id());

	< ---- Task is migrated here ---- >

	// CPU 1 goes idle and increase rdtp->dynticks
							/* Here we are reading the value for
							the remote CPU 1 instead of the local CPU */
							if (atomic_read(&rdtp->dynticks) & 0x1)
								return false;

							return true;
							}

The possible result of this is false positive return value of that
function, suggesting we are in an extended quiescent state in random
places.

Fix this by disabling preemption while reading that value.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/rcutree.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c9b4adf..234dca3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -469,13 +469,15 @@ void rcu_irq_exit(void)
 
 bool rcu_check_extended_qs(void)
 {
-	struct rcu_dynticks *rdtp;
+	struct rcu_dynticks *rdtp = &get_cpu_var(rcu_dynticks);
+	bool ext_qs = true;
 
-	rdtp = &per_cpu(rcu_dynticks, raw_smp_processor_id());
 	if (atomic_read(&rdtp->dynticks) & 0x1)
-		return false;
+		ext_qs = false;
+
+	put_cpu_var(rcu_dynticks);
 
-	return true;
+	return ext_qs;
 }
 EXPORT_SYMBOL_GPL(rcu_check_extended_qs);
 
-- 
1.7.5.4

