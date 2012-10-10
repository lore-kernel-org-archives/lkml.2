Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab2JKAPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:15:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57685 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932750Ab2JKAPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:15:25 -0400
X-Sasl-enc: A7dhz27P4C3iLWAvO7ftXYaBy9CYQXHGGXajk9tnpFCq 1349914524
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [ 110/133] score: Add missing RCU idle APIs on idle loop
Date: Thu, 11 Oct 2012 07:52:16 +0900
Message-Id: <20121010224914.323829269@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 0ee23fda59740767324b4340247ca41a2f498ca6 upstream.

In the old times, the whole idle task was considered
as an RCU quiescent state. But as RCU became more and
more successful overtime, some RCU read side critical
section have been added even in the code of some
architectures idle tasks, for tracing for example.

So nowadays, rcu_idle_enter() and rcu_idle_exit() must
be called by the architecture to tell RCU about the part
in the idle loop that doesn't make use of rcu read side
critical sections, typically the part that puts the CPU
in low power mode.

This is necessary for RCU to find the quiescent states in
idle in order to complete grace periods.

Add this missing pair of calls in scores's idle loop.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/score/kernel/process.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/score/kernel/process.c
+++ b/arch/score/kernel/process.c
@@ -27,6 +27,7 @@
 #include <linux/reboot.h>
 #include <linux/elfcore.h>
 #include <linux/pm.h>
+#include <linux/rcupdate.h>
 
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
@@ -50,9 +51,10 @@ void __noreturn cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched())
 			barrier();
-
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
 }


