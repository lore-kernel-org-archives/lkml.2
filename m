Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2H3SqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:46:03 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54452 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab2H3Spo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:45:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/5] rcu: Prevent initialization race in rcutorture kthreads
Date: Thu, 30 Aug 2012 11:45:12 -0700
Message-Id: <1346352312-31987-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-2398-0000-0000-000009EA37AC
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00169860; UDB=6.00038509; UTC=2012-08-30
 18:45:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

When you do something like "t = kthread_run(...)", it is possible that
the kthread will start running before the assignment to "t" happens.
If the child kthread expects to find a pointer to its task_struct in "t",
it will then be fatally disappointed.  This commit therefore switches
such cases to kthread_create() followed by wake_up_process(), guaranteeing
that the assignment happens before the child kthread starts running.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 8ea2726..3e2adae 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -2028,14 +2028,15 @@ rcu_torture_init(void)
 	/* Start up the kthreads. */
 
 	VERBOSE_PRINTK_STRING("Creating rcu_torture_writer task");
-	writer_task = kthread_run(rcu_torture_writer, NULL,
-				  "rcu_torture_writer");
+	writer_task = kthread_create(rcu_torture_writer, NULL,
+				     "rcu_torture_writer");
 	if (IS_ERR(writer_task)) {
 		firsterr = PTR_ERR(writer_task);
 		VERBOSE_PRINTK_ERRSTRING("Failed to create writer");
 		writer_task = NULL;
 		goto unwind;
 	}
+	wake_up_process(writer_task);
 	fakewriter_tasks = kzalloc(nfakewriters * sizeof(fakewriter_tasks[0]),
 				   GFP_KERNEL);
 	if (fakewriter_tasks == NULL) {
@@ -2150,14 +2151,15 @@ rcu_torture_init(void)
 	}
 	if (shutdown_secs > 0) {
 		shutdown_time = jiffies + shutdown_secs * HZ;
-		shutdown_task = kthread_run(rcu_torture_shutdown, NULL,
-					    "rcu_torture_shutdown");
+		shutdown_task = kthread_create(rcu_torture_shutdown, NULL,
+					       "rcu_torture_shutdown");
 		if (IS_ERR(shutdown_task)) {
 			firsterr = PTR_ERR(shutdown_task);
 			VERBOSE_PRINTK_ERRSTRING("Failed to create shutdown");
 			shutdown_task = NULL;
 			goto unwind;
 		}
+		wake_up_process(shutdown_task);
 	}
 	i = rcu_torture_onoff_init();
 	if (i != 0) {
-- 
1.7.8

