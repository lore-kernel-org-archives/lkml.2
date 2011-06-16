Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab1FPHFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:05:36 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:38898 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756427Ab1FPHF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:27 -0400
X-Sasl-enc: dW+SSCKlYopIqolbAGD97CcZwP2HJDFLNlw5jf8bz/Wl 1308207926
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:11 2011
Message-Id: <20110616001611.099701369@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [18/91] rcu: Fix unpaired rcu_irq_enter() from locking selftests
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 lib/locking-selftest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -144,7 +144,7 @@ static void init_shared_classes(void)
 
 #define HARDIRQ_ENTER()				\
 	local_irq_disable();			\
-	irq_enter();				\
+	__irq_enter();				\
 	WARN_ON(!in_irq());
 
 #define HARDIRQ_EXIT()				\


