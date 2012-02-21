Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab2BUSAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:00:49 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:53266 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2BUR7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:59:25 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/4] rcu: Fixes to rcutorture error handling and cleanup
Date: Tue, 21 Feb 2012 09:58:30 -0800
Message-Id: <1329847110-10897-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1329847110-10897-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120221175810.GA10708@linux.vnet.ibm.com>
 <1329847110-10897-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022117-3270-0000-0000-00000435573C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcutorture initialization code ignored the error returns from
rcu_torture_onoff_init() and rcu_torture_stall_init().  The rcutorture
cleanup code failed to NULL out a number of pointers.  These bugs will
normally have no effect, but this commit fixes them nevertheless.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index a89b381..1463a06 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1337,6 +1337,7 @@ static void rcutorture_booster_cleanup(int cpu)
 
 	/* This must be outside of the mutex, otherwise deadlock! */
 	kthread_stop(t);
+	boost_tasks[cpu] = NULL;
 }
 
 static int rcutorture_booster_init(int cpu)
@@ -1484,13 +1485,15 @@ static void rcu_torture_onoff_cleanup(void)
 		return;
 	VERBOSE_PRINTK_STRING("Stopping rcu_torture_onoff task");
 	kthread_stop(onoff_task);
+	onoff_task = NULL;
 }
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
 
-static void
+static int
 rcu_torture_onoff_init(void)
 {
+	return 0;
 }
 
 static void rcu_torture_onoff_cleanup(void)
@@ -1554,6 +1557,7 @@ static void rcu_torture_stall_cleanup(void)
 		return;
 	VERBOSE_PRINTK_STRING("Stopping rcu_torture_stall_task.");
 	kthread_stop(stall_task);
+	stall_task = NULL;
 }
 
 static int rcutorture_cpu_notify(struct notifier_block *self,
@@ -1665,6 +1669,7 @@ rcu_torture_cleanup(void)
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shutdown task");
 		kthread_stop(shutdown_task);
 	}
+	shutdown_task = NULL;
 	rcu_torture_onoff_cleanup();
 
 	/* Wait for all RCU callbacks to fire.  */
@@ -1897,9 +1902,17 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
-	rcu_torture_onoff_init();
+	i = rcu_torture_onoff_init();
+	if (i != 0) {
+		firsterr = i;
+		goto unwind;
+	}
 	register_reboot_notifier(&rcutorture_shutdown_nb);
-	rcu_torture_stall_init();
+	i = rcu_torture_stall_init();
+	if (i != 0) {
+		firsterr = i;
+		goto unwind;
+	}
 	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
 	return 0;
-- 
1.7.8

