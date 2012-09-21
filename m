Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab2IUCJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:09:35 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49013 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab2IUCJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:09:34 -0400
Message-ID: <1348193336.2371.76.camel@ThinkPad-T420>
Subject: [PATCH rcu] Move TINY_RCU quiescent state out of extended quiescent
 state
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, dipankar@in.ibm.com
Date: Fri, 21 Sep 2012 10:08:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12092102-4790-0000-0000-000004B8B1B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TINY_RCU's rcu_idle_enter_common() invokes rcu_sched_qs() in order
to inform the RCU core of the quiescent state implied by idle entry.
Of course, idle is also an extended quiescent state, so that the call
to rcu_sched_qs() speeds up RCU's invoking of any callbacks that might
be queued.  This speed-up is important when entering into dyntick-idle
mode -- if there are no further scheduling-clock interrupts, the callbacks
might never be invoked, which could result in a system hang.

However, processing callbacks does event tracing, which in turn
implies RCU read-side critical sections, which are illegal in extended
quiescent states.  This patch therefore moves the call to rcu_sched_qs()
so that it precedes the point at which we set the new value of 
rcu_dynticks_nesting, which may indicate RCU is in an extended quiescent
state. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 2e073a2..e4c6a59 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -75,9 +75,9 @@ static void rcu_idle_enter_common(long long newval)
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
+	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
 	barrier();
 	rcu_dynticks_nesting = newval;
-	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
 }
 
 /*
-- 
1.7.9.5



