Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0FUI5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 04:57:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64523 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab0FUI5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 04:57:52 -0400
Message-ID: <4C1F2986.7080006@cn.fujitsu.com>
Date: Mon, 21 Jun 2010 16:57:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcutorture: add random preemption
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add random preemption to help we to torture the preemptable rcu.

srcu_read_delay() also calls rcu_read_delay() for shorter delays.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 2e2726d..7c81d07 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -303,6 +303,10 @@ static void rcu_read_delay(struct rcu_random_state *rrsp)
 		mdelay(longdelay_ms);
 	if (!(rcu_random(rrsp) % (nrealreaders * 2 * shortdelay_us)))
 		udelay(shortdelay_us);
+#ifdef CONFIG_PREEMPT
+	if (!preempt_count() && !(rcu_random(rrsp) % (nrealreaders * 20000)))
+		preempt_schedule();
+#endif
 }
 
 static void rcu_torture_read_unlock(int idx) __releases(RCU)
@@ -536,6 +540,8 @@ static void srcu_read_delay(struct rcu_random_state *rrsp)
 	delay = rcu_random(rrsp) % (nrealreaders * 2 * longdelay * uspertick);
 	if (!delay)
 		schedule_timeout_interruptible(longdelay);
+	else
+		rcu_read_delay(rrsp);
 }
 
 static void srcu_torture_read_unlock(int idx) __releases(&srcu_ctl)
