Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937813Ab0CPLJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 07:09:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S937794Ab0CPLJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:09:24 -0400
Message-ID: <4B9F66E1.2060309@cn.fujitsu.com>
Date: Tue, 16 Mar 2010 19:09:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] rcu: local_irq_disable() also delimits RCU_SCHED read-site
 critical sections
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is documented that local_irq_disable() also delimits
RCU_SCHED read-site critical sections.
See the document of synchronize_sched() or
Documentation/RCU/whatisRCU.txt.

So we have to test irqs_disabled() in rcu_read_lock_sched_held().
Otherwise rcu-lockdep brings incorrect complaint.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3024050..2ce5674 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -160,7 +160,7 @@ static inline int rcu_read_lock_sched_held(void)
 		return 1;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || preempt_count() != 0;
+	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
@@ -191,7 +191,7 @@ static inline int rcu_read_lock_bh_held(void)
 #ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
-	return !rcu_scheduler_active || preempt_count() != 0;
+	return !rcu_scheduler_active || preempt_count() != 0 || irqs_disabled();
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)

