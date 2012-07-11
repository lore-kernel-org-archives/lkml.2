Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab2GKS1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:27:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65226 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249Ab2GKS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:27:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/11] rcu: Ignore userspace extended quiescent state by default
Date: Wed, 11 Jul 2012 20:26:32 +0200
Message-Id: <1342031200-22731-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
References: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default we don't want to enter into RCU extended quiescent
state while in userspace because doing this produces some overhead
(eg: use of syscall slowpath). Set it off by default and ready to
run when some feature like adaptive tickless need it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/rcutree.c |    5 ++++-
 kernel/rcutree.h |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d5df618..78b0c30 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -209,6 +209,9 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
 	.dynticks = ATOMIC_INIT(1),
+#ifdef CONFIG_RCU_USER_QS
+	.ignore_user_qs = true,
+#endif
 };
 
 static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
@@ -442,7 +445,7 @@ void rcu_user_enter(void)
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (!rdtp->in_user) {
+	if (!rdtp->ignore_user_qs && !rdtp->in_user) {
 		rdtp->in_user = true;
 		rcu_eqs_enter(1);
 	}
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4d82cb5..55bcef1 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -103,6 +103,7 @@ struct rcu_dynticks {
 	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
 #ifdef CONFIG_RCU_USER_QS
+	bool ignore_user_qs;	    /* Treat userspace as extended QS or not */
 	bool in_user;		    /* Is the CPU in userland from RCU POV? */
 #endif
 };
-- 
1.7.5.4

