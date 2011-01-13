Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab1AMTEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:04:51 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57983 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929Ab1AMTEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:04:49 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 2/2] rcu: avoid pointless blocked-task warnings
Date: Thu, 13 Jan 2011 11:04:37 -0800
Message-Id: <1294945477-10612-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110113190414.GA10457@linux.vnet.ibm.com>
References: <20110113190414.GA10457@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

If the RCU callback-processing kthread has nothing to do, it parks in
a wait_event().  If RCU remains idle for more than two minutes, the
kernel complains about this.  This commit changes from wait_event()
to wait_event_interruptible() to prevent the kernel from complaining
just because RCU is idle.

Reported-by: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Thomas Weber <weber@corscience.de>
---
 kernel/rcutiny.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 0344937..0c343b9 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -189,7 +189,8 @@ static int rcu_kthread(void *arg)
 	unsigned long flags;
 
 	for (;;) {
-		wait_event(rcu_kthread_wq, have_rcu_kthread_work != 0);
+		wait_event_interruptible(rcu_kthread_wq,
+					 have_rcu_kthread_work != 0);
 		morework = rcu_boost();
 		local_irq_save(flags);
 		work = have_rcu_kthread_work;
-- 
1.7.3.2

