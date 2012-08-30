Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab2H3VTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:19:22 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41841 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2H3VOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:14:15 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        m68k <linux-m68k@vger.kernel.org>, "3.2.x.." <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 21/26] m68k: Add missing RCU idle APIs on idle loop
Date: Thu, 30 Aug 2012 14:05:38 -0700
Message-Id: <1346360743-3628-21-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-2398-0000-0000-000009EC2F31
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00169890; UDB=6.00038516; UTC=2012-08-30
 21:14:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

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

Add this missing pair of calls in the m68k's idle loop.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: m68k <linux-m68k@lists.linux-m68k.org>
Cc: 3.2.x.. <stable@vger.kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/m68k/kernel/process.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index c488e3c..ac2892e 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -25,6 +25,7 @@
 #include <linux/reboot.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
+#include <linux/rcupdate.h>
 
 #include <asm/uaccess.h>
 #include <asm/traps.h>
@@ -75,8 +76,10 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched())
 			idle();
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
 }
-- 
1.7.8

