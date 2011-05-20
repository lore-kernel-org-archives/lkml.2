Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab1ETAKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:10:05 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54329 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab1ETAKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:10:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Wy/Lcn9+vZFU18DucJjdhiEhd5zipSOKxBg63tC7h4rtGa4uS2RRudWfyEWWHtGoH+
         2msYDZ+dpp08M8ZhSTlxcoFnoOqGxH1brhwwrF5o/p1jh/5iqNca3UCy2E+0utXQ/FfO
         d+IKrWphdfNHY8wIBvjbQt6q9n7vdMscdJXeg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stable <stable@kernel.org>
Subject: [PATCH] rcu: Fix unpaired rcu_irq_enter() from locking selftests
Date: Fri, 20 May 2011 02:09:54 +0200
Message-Id: <1305850194-8229-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <4DD58F90.4090506@kernel.org>
References: <4DD58F90.4090506@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HARDIRQ_ENTER() maps to irq_enter() which calls rcu_irq_enter().
But HARDIRQ_EXIT() maps to __irq_exit() which doesn't call
rcu_irq_exit().

So for every locking selftest that simulates hardirq disabled,
we create an imbalance in the rcu extended quiescent state
internal state.

As a result, after the first missing rcu_irq_exit(), subsequent
irqs won't exit any extended quiescent state the time of the
interrupt servicing. Rcu read side critical section inside irqs
on that CPU won't be guaranteed anymore.

To fix this, just use __irq_enter() to simulate the hardirq
context. This is sufficient for the locking selftests as we
don't need to exit any extended quiescent state or perform
any check that irqs normally do when they wake up from idle.

As a side effect, this patch should make it possible to
restore
"rcu: Decrease memory-barrier usage based on semi-formal proof",
which eventually helped finding this bug.

Reported-and-tested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stable <stable@kernel.org>
---
 lib/locking-selftest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.3.2

