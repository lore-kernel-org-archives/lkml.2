Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2KSQix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:38:53 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35007 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab2KSQiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:38:51 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@redhat.com
Cc: ccross@android.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 3/3] sched: fix update NOHZ_IDLE flag
Date: Mon, 19 Nov 2012 17:38:07 +0100
Message-Id: <1353343087-18015-4-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1353343087-18015-1-git-send-email-vincent.guittot@linaro.org>
References: <1353343087-18015-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function nohz_kick_needed modifies NOHZ_IDLE flag that is used to update
the nr_busy_cpus of the sched_group.
When the sched_domain are updated (because of the unplug of a CPUs as an
example) a null_domain is attached to CPUs. We have to test
likely(!on_null_domain(cpu) first in order to detect such intialization step
and to not modify the NOHZ_IDLE flag

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3d0686c..1bf7c87 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5490,7 +5490,7 @@ void trigger_load_balance(struct rq *rq, int cpu)
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ
-	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (likely(!on_null_domain(cpu)) && nohz_kick_needed(rq, cpu))
 		nohz_balancer_kick(cpu);
 #endif
 }
-- 
1.7.10

