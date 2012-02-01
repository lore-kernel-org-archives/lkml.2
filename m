Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2BATw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:52:56 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40458 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab2BATm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:42:58 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 15/41] rcu: Check for callback invocation from offline CPUs
Date: Wed,  1 Feb 2012 11:41:33 -0800
Message-Id: <1328125319-5205-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-7282-0000-0000-0000061F24D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Because quiescent states are now reported from offline CPUs in
CPU_DYING state, there is some possibility that such a CPU might
note the end of a grace period and attempt to start invoking
callbacks.  This would be a very bad thing, and is supposed to
be prevented by the fact that the CPU_DYING CPU gets rid of all
its callbacks before reporting the quiescent state.  However,
there is other CPU-offline code in the kernel, and it is quite
possible that someone will invoke RCU core processing from that
code.  Therefore, this commit adds a warning for this case.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 9040cb6..03c0d5f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1373,6 +1373,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	 * races with call_rcu() from interrupt handlers.
 	 */
 	local_irq_save(flags);
+	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
 	bl = rdp->blimit;
 	trace_rcu_batch_start(rsp->name, rdp->qlen_lazy, rdp->qlen, bl);
 	list = rdp->nxtlist;
-- 
1.7.8

