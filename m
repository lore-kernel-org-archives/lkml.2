Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762578Ab2FVPfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:35:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41864 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2FVPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:35:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/17] rcu: Prevent __call_rcu() from invoking RCU core on offline CPUs
Date: Fri, 22 Jun 2012 08:35:07 -0700
Message-Id: <1340379312-6684-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622153501.GA6626@linux.vnet.ibm.com>
 <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-4242-0000-0000-0000021531FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The __call_rcu() function will invoke the RCU core, for example, if
it detects that the current CPU has too many callbacks.  However, this
can happen on an offline CPU that is on its way to the idle loop, in
which case it is an error to invoke the RCU core, and the excess callbacks
will be adopted in any case.  This commit therefore adds checks to
__call_rcu() for running on an offline CPU, refraining from invoking
the RCU core in this case.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7720177..9419ebf 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1901,11 +1901,11 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 * If called from an extended quiescent state, invoke the RCU
 	 * core in order to force a re-evaluation of RCU's idleness.
 	 */
-	if (rcu_is_cpu_idle())
+	if (rcu_is_cpu_idle() && cpu_online(smp_processor_id()))
 		invoke_rcu_core();
 
-	/* If interrupts were disabled, don't dive into RCU core. */
-	if (irqs_disabled_flags(flags)) {
+	/* If interrupts were disabled or CPU offline, don't invoke RCU core. */
+	if (irqs_disabled_flags(flags) || cpu_is_offline(smp_processor_id())) {
 		local_irq_restore(flags);
 		return;
 	}
-- 
1.7.8

