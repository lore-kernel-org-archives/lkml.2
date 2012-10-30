Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906Ab2J3Qrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:47:35 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45575 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874Ab2J3Qrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:47:32 -0400
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
Subject: [PATCH tip/core/rcu 2/4] rcu: Add grace-period information to RCU CPU stall warnings
Date: Tue, 30 Oct 2012 09:46:47 -0700
Message-Id: <1351615609-25316-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351615609-25316-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030164622.GA25108@linux.vnet.ibm.com>
 <1351615609-25316-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-7408-0000-0000-000009C56575
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This commit causes the last grace period started and completed to be
printed on RCU CPU stall warning messages in order to aid diagnosis.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e785387..8f4de3a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -947,8 +947,9 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	print_cpu_stall_info_end();
-	printk(KERN_CONT "(detected by %d, t=%ld jiffies)\n",
-	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
+	pr_cont("(detected by %d, t=%ld jiffies, g=%lu, c=%lu)\n",
+	       smp_processor_id(), (long)(jiffies - rsp->gp_start),
+	       rsp->gpnum, rsp->completed);
 	if (ndetected == 0)
 		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
 	else if (!trigger_all_cpu_backtrace())
@@ -975,7 +976,8 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	print_cpu_stall_info_begin();
 	print_cpu_stall_info(rsp, smp_processor_id());
 	print_cpu_stall_info_end();
-	printk(KERN_CONT " (t=%lu jiffies)\n", jiffies - rsp->gp_start);
+	pr_cont(" (t=%lu jiffies g=%lu c=%lu)\n",
+		jiffies - rsp->gp_start, rsp->gpnum, rsp->completed);
 	if (!trigger_all_cpu_backtrace())
 		dump_stack();
 
-- 
1.7.8

