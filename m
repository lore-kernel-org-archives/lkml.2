Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1K1VZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:25:42 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48196 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab1K1VZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:25:01 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 4/4 RFC] rcu: New rcu_user_enter_irq() and rcu_user_exit_irq() APIs
Date: Mon, 28 Nov 2011 22:24:47 +0100
Message-Id: <1322515487-18690-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A CPU running in adaptive tickless mode wants to enter into
RCU extended quiescent state while running in userspace. This
way we can shut down the tick that is usually needed on each
CPU for the needs of RCU.

Typically, RCU enters the extended quiescent state when we resume
to userspace through a syscall or exception exit, this is done
using rcu_user_enter(). Then RCU exit this state by calling
rcu_user_exit() from syscall or exception entry.

However there are two other points where we may want to enter
or exit this state. Some remote CPU may require a tickless CPU
to restart its tick for any reason and send it an IPI for
this purpose. As we restart the tick, we don't want to resume
from the IPI in RCU extended quiescent state anymore.
Similarly we may stop the tick from an interrupt in userspace and
we need to be able to enter RCU extended quiescent state when we
resume from this interrupt to userspace.

To these ends, we provide two new APIs:

- rcu_user_enter_irq(). This must be called from a non-nesting
interrupt betwenn rcu_irq_enter() and rcu_irq_exit().
After the irq calls rcu_irq_exit(), we'll run into RCU extended
quiescent state.

- rcu_user_exit_irq(). This must be called from a non-nesting
interrupt, interrupting an RCU extended quiescent state, and
between rcu_irq_enter() and rcu_irq_exit(). After the irq calls
rcu_irq_exit(), we'll prevent from resuming the RCU extended
quiescent.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 00a9fba..a7906c9 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -402,6 +402,18 @@ void rcu_user_enter(void)
 	__rcu_idle_enter();
 }
 
+void rcu_user_enter_irq(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	WARN_ON_ONCE(rdtp->dynticks_nesting == 1);
+	rdtp->dynticks_nesting = 1;
+	local_irq_restore(flags);
+}
+
 /**
  * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
  *
@@ -503,6 +515,18 @@ void rcu_user_exit(void)
 	__rcu_idle_exit();
 }
 
+void rcu_user_exit_irq(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	WARN_ON_ONCE(rdtp->dynticks_nesting != 1);
+	rdtp->dynticks_nesting = (LLONG_MAX / 2) + 1;
+	local_irq_restore(flags);
+}
+
 /**
  * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
  *
-- 
1.7.5.4

