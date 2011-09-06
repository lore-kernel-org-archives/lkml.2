Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1IGGWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:22:55 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38342 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab1IGGWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:22:22 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/55] rcu: Don't destroy rcu_torture_boost() callback until it is done
Date: Tue,  6 Sep 2011 11:00:07 -0700
Message-Id: <1315332049-2604-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
x-cbid: 11090706-6078-0000-0000-000000711B16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The rcu_torture_boost() cleanup code destroyed debug-objects state before
waiting for the last RCU callback to be invoked, resulting in rare but
very real debug-objects warnings.  Move the destruction to after the
waiting to fix this problem.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index e0f39ea..1194d6c 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -796,11 +796,11 @@ checkwait:	rcu_stutter_wait("rcu_torture_boost");
 
 	/* Clean up and exit. */
 	VERBOSE_PRINTK_STRING("rcu_torture_boost task stopping");
-	destroy_rcu_head_on_stack(&rbi.rcu);
 	rcutorture_shutdown_absorb("rcu_torture_boost");
 	while (!kthread_should_stop() || rbi.inflight)
 		schedule_timeout_uninterruptible(1);
 	smp_mb(); /* order accesses to ->inflight before stack-frame death. */
+	destroy_rcu_head_on_stack(&rbi.rcu);
 	return 0;
 }
 
-- 
1.7.3.2

