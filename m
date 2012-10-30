Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab2J3Qyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:54:55 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59245 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934021Ab2J3Qyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:54:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/7] rcu: Make rcutorture give diagnostics if CPU offline fails
Date: Tue, 30 Oct 2012 09:54:31 -0700
Message-Id: <1351616076-25617-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030165415.GA25438@linux.vnet.ibm.com>
 <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-9360-0000-0000-00000C369339
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This commit causes rcutorture to print the errno if cpu_down() fails
when the rcutorture "verbose" module parameter is specified.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index aaa7b9f..9900f56 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1502,6 +1502,7 @@ rcu_torture_onoff(void *arg)
 	unsigned long delta;
 	int maxcpu = -1;
 	DEFINE_RCU_RANDOM(rand);
+	int ret;
 	unsigned long starttime;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_onoff task started");
@@ -1522,7 +1523,13 @@ rcu_torture_onoff(void *arg)
 					 torture_type, cpu);
 			starttime = jiffies;
 			n_offline_attempts++;
-			if (cpu_down(cpu) == 0) {
+			ret = cpu_down(cpu);
+			if (ret) {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "rcu_torture_onoff task: offline %d failed: errno %d\n",
+						 torture_type, cpu, ret);
+			} else {
 				if (verbose)
 					pr_alert("%s" TORTURE_FLAG
 						 "rcu_torture_onoff task: offlined %d\n",
-- 
1.7.8

