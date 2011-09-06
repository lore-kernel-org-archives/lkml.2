Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1IGG26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:28:58 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52568 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab1IGGUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Shaohua Li <shaohua.li@intel.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/55] rcu: Avoid unnecessary self-wakeup of per-CPU kthreads
Date: Tue,  6 Sep 2011 10:59:56 -0700
Message-Id: <1315332049-2604-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

There are a number of cases where the RCU can find additional work
for the per-CPU kthread within the context of that per-CPU kthread.
In such cases, the per-CPU kthread is already running, so attempting
to wake itself up does nothing except waste CPU cycles.  This commit
therefore checks to see if it is in the per-CPU kthread context,
omitting the wakeup in this case.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 7b850cd..9703298 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1291,11 +1291,9 @@ static void invoke_rcu_callbacks_kthread(void)
 
 	local_irq_save(flags);
 	__this_cpu_write(rcu_cpu_has_work, 1);
-	if (__this_cpu_read(rcu_cpu_kthread_task) == NULL) {
-		local_irq_restore(flags);
-		return;
-	}
-	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
+	if (__this_cpu_read(rcu_cpu_kthread_task) != NULL &&
+	    current != __this_cpu_read(rcu_cpu_kthread_task))
+		wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
 	local_irq_restore(flags);
 }
 
-- 
1.7.3.2

