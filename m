Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124Ab2EOCRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:49038 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964873Ab2EOCQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 016/179] rcu: Fix unpaired rcu_irq_enter() from locking selftests
Date: Mon, 14 May 2012 22:11:52 -0400
Message-ID: <1337048075-6132-17-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 lib/locking-selftest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 619313e..507a22f 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -144,7 +144,7 @@ static void init_shared_classes(void)
 
 #define HARDIRQ_ENTER()				\
 	local_irq_disable();			\
-	irq_enter();				\
+	__irq_enter();				\
 	WARN_ON(!in_irq());
 
 #define HARDIRQ_EXIT()				\
-- 
1.7.9.6

