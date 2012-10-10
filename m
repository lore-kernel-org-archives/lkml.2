Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab2JKA0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:26:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45606 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933318Ab2JKAZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:25:53 -0400
X-Sasl-enc: JMxa19r+U+BrGqkdMPR33LewPhuRnTw60GNyKpUVRTGu 1349915152
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 107/122] sched: Fix load avg vs. cpu-hotplug
Date: Thu, 11 Oct 2012 07:54:33 +0900
Message-Id: <20121010225357.276051295@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 08bedae1d0acd8c9baf514fb69fa199d0c8345f6 upstream.

Commit f319da0c68 ("sched: Fix load avg vs cpu-hotplug") was an
incomplete fix:

In particular, the problem is that at the point it calls
calc_load_migrate() nr_running := 1 (the stopper thread), so move the
call to CPU_DEAD where we're sure that nr_running := 0.

Also note that we can call calc_load_migrate() without serialization, we
know the state of rq is stable since its cpu is dead, and we modify the
global state using appropriate atomic ops.

Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346882630.2600.59.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5604,7 +5604,9 @@ migration_call(struct notifier_block *nf
 		migrate_tasks(cpu);
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		break;
 
+	case CPU_DEAD:
 		calc_load_migrate(rq);
 		break;
 #endif


