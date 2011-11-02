Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1KBUb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:31:56 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34331 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1KBUbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:53 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 10/28] rcu: Disable preemption in rcu_is_cpu_idle()
Date: Wed,  2 Nov 2011 13:30:31 -0700
Message-Id: <1320265849-5744-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-5806-0000-0000-000000F80A38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Because rcu_is_cpu_idle() is to be used to check for extended quiescent
states in RCU-preempt read-side critical sections, it cannot assume that
preemption is disabled.  And preemption must be disabled when accessing
the dyntick-idle state, because otherwise the following sequence of events
could occur:

1.	Task A on CPU 1 enters rcu_is_cpu_idle() and picks up the pointer
	to CPU 1's per-CPU variables.

2.	Task B preempts Task A and starts running on CPU 1.

3.	Task A migrates to CPU 2.

4.	Task B blocks, leaving CPU 1 idle.

5.	Task A continues execution on CPU 2, accessing CPU 1's dyntick-idle
	information using the pointer fetched in step 1 above, and finds
	that CPU 1 is idle.

6.	Task A therefore incorrectly concludes that it is executing in
	an extended quiescent state, possibly issuing a spurious splat.

Therefore, this commit disables preemption within the rcu_is_cpu_idle()
function.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index abb5167..c097394 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -556,12 +556,16 @@ void rcu_nmi_exit(void)
  * rcu_is_cpu_idle - see if RCU thinks that the current CPU is idle
  *
  * If the current CPU is in its idle loop and is neither in an interrupt
- * or NMI handler, return true.  The caller must have at least disabled
- * preemption.
+ * or NMI handler, return true.
  */
 int rcu_is_cpu_idle(void)
 {
-	return (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
+	int ret;
+
+	preempt_disable();
+	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
+	preempt_enable();
+	return ret;
 }
 
 #endif /* #ifdef CONFIG_PROVE_RCU */
-- 
1.7.3.2

