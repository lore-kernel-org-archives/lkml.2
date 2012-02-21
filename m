Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2BUUAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:00:50 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:56024 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab2BUUAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:00:34 -0500
Date: Tue, 21 Feb 2012 12:00:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: rostedt@goodmis.org
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC -rt] Alleged fix for CPU-hotplug deadlock
Message-ID: <20120221200009.GA14368@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022120-3352-0000-0000-000002CC000D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is intended to fix a deadlock seen in -rt.  Untested, might
not even compile.  The intent is to move kthread_stop() outside of
the CPU-hotplug lock, thus preventing deadlocks involving sleeping
spinlocks.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8c26a49..e0d514b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2041,8 +2041,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		rcu_send_cbs_to_online(&rcu_sched_state);
 		rcu_preempt_send_cbs_to_online();
 		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
+	case CPU_POST_DEAD:
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		rcu_offline_cpu(cpu);

