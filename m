Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab0CRWEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:04:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:42136 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab0CRWD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:03:59 -0400
Date: Thu, 18 Mar 2010 22:03:35 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <1268940334-10892-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1268940334-10892-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Fix local_irq_disable() CONFIG_PROVE_RCU=y false positives
Message-ID: <tip-0cff810f54b3b52075c27f7a7021d5b195264b6c@git.kernel.org>
Git-Commit-ID: 0cff810f54b3b52075c27f7a7021d5b195264b6c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Mar 2010 22:03:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0cff810f54b3b52075c27f7a7021d5b195264b6c
Gitweb:     http://git.kernel.org/tip/0cff810f54b3b52075c27f7a7021d5b195264b6c
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Thu, 18 Mar 2010 12:25:33 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Mar 2010 21:25:32 +0100

rcu: Fix local_irq_disable() CONFIG_PROVE_RCU=y false positives

It is documented that local_irq_disable() also delimits RCU_SCHED
read-site critical sections.

See the document of synchronize_sched() or
Documentation/RCU/whatisRCU.txt.

So we have to test irqs_disabled() in rcu_read_lock_sched_held().
Otherwise rcu-lockdep brings incorrect complaint.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: eric.dumazet@gmail.com
LKML-Reference: <1268940334-10892-1-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcupdate.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e1bdc4b..872a98e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -149,7 +149,7 @@ static inline int rcu_read_lock_sched_held(void)
 		return 1;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || preempt_count() != 0;
+	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
@@ -180,7 +180,7 @@ static inline int rcu_read_lock_bh_held(void)
 #ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
-	return !rcu_scheduler_active || preempt_count() != 0;
+	return !rcu_scheduler_active || preempt_count() != 0 || irqs_disabled();
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
