Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2C2IQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:16:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23794 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab2C2IQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:16:30 -0400
X-IronPort-AV: E=Sophos;i="4.75,335,1330876800"; 
   d="scan'208";a="4648227"
Message-ID: <4F741B98.2070709@cn.fujitsu.com>
Date: Thu, 29 Mar 2012 16:21:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: remove the context test in rcu_read_unlock_special()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-29 16:14:09,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-29 16:14:13,
	Serialize complete at 2012-03-29 16:14:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of commit#26861f and #10f39bb1b2, the context test in
rcu_read_unlock_special() are not needed.

commit#26861f and #10f39bb1b2 ensure ->rcu_read_unlock_special is zero
after rcu_read_unlock(), which implies:

if ->rcu_read_unlock_special is non-zero, the out-most RCU C.S. can
be interrupted or can be preempted, such context is safe to
call rcu_read_unlock_special().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 22ecea0..22e2ef1 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -571,12 +571,6 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 	if (special & RCU_READ_UNLOCK_NEED_QS)
 		rcu_preempt_cpu_qs();
 
-	/* Hardware IRQ handlers cannot block. */
-	if (in_irq() || in_serving_softirq()) {
-		local_irq_restore(flags);
-		return;
-	}
-
 	/* Clean up if blocked during RCU read-side critical section. */
 	if (special & RCU_READ_UNLOCK_BLOCKED) {
 		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c023464..2bd3689 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -338,12 +338,6 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		rcu_preempt_qs(smp_processor_id());
 	}
 
-	/* Hardware IRQ handlers cannot block. */
-	if (in_irq() || in_serving_softirq()) {
-		local_irq_restore(flags);
-		return;
-	}
-
 	/* Clean up if blocked during RCU read-side critical section. */
 	if (special & RCU_READ_UNLOCK_BLOCKED) {
 		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 671f959..7074f97 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -318,12 +318,8 @@ static inline void invoke_softirq(void)
 #else
 		do_softirq();
 #endif
-	} else {
-		__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
+	} else
 		wakeup_softirqd();
-		__local_bh_enable(SOFTIRQ_OFFSET);
-	}
 }
 
 /*
