Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1G0VsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:23542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab1G0VsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900315"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: fweisbec@gmail.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [3/99] rcu: Fix unpaired rcu_irq_enter() from locking selftests
Message-Id: <20110727214801.610A42403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Frederic Weisbecker <fweisbec@gmail.com>

commit ba9f207c9f82115aba4ce04b22e0081af0ae300f upstream.

HARDIRQ_ENTER() maps to irq_enter() which calls rcu_irq_enter().
But HARDIRQ_EXIT() maps to __irq_exit() which doesn't call
rcu_irq_exit().

So for every locking selftest that simulates hardirq disabled,
we create an imbalance in the rcu extended quiescent state
internal state.

As a result, after the first missing rcu_irq_exit(), subsequent
irqs won't exit dyntick-idle mode after leaving the interrupt
handler.  This means that RCU won't see the affected CPU as being
in an extended quiescent state, resulting in long grace-period
delays (as in grace periods extending for hours).

To fix this, just use __irq_enter() to simulate the hardirq
context. This is sufficient for the locking selftests as we
don't need to exit any extended quiescent state or perform
any check that irqs normally do when they wake up from idle.

As a side effect, this patch makes it possible to restore
"rcu: Decrease memory-barrier usage based on semi-formal proof",
which eventually helped finding this bug.

Reported-and-tested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 lib/locking-selftest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/lib/locking-selftest.c
===================================================================
--- linux-2.6.35.y.orig/lib/locking-selftest.c
+++ linux-2.6.35.y/lib/locking-selftest.c
@@ -144,7 +144,7 @@ static void init_shared_classes(void)
 
 #define HARDIRQ_ENTER()				\
 	local_irq_disable();			\
-	irq_enter();				\
+	__irq_enter();				\
 	WARN_ON(!in_irq());
 
 #define HARDIRQ_EXIT()				\
