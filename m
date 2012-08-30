Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2H3VOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:14:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59592 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab2H3VOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:14:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 26/26] ia64: Add missing RCU idle APIs on idle loop
Date: Thu, 30 Aug 2012 14:05:43 -0700
Message-Id: <1346360743-3628-26-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-9360-0000-0000-00000A065B0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Traditionally, the entire idle task served as an RCU quiescent state.
But when RCU read side critical sections started appearing within the
idle loop, this traditional strategy became untenable.  The fix was to
create new RCU APIs named rcu_idle_enter() and rcu_idle_exit(), which
must be called by each architecture's idle loop so that RCU can tell
when it is safe to ignore a given idle CPU.

Unfortunately, this fix was never applied to ia64, a shortcoming remedied
by this commit.

Reported by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested by: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/kernel/process.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index dd6fc14..3e316ec 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -29,6 +29,7 @@
 #include <linux/kdebug.h>
 #include <linux/utsname.h>
 #include <linux/tracehook.h>
+#include <linux/rcupdate.h>
 
 #include <asm/cpu.h>
 #include <asm/delay.h>
@@ -279,6 +280,7 @@ cpu_idle (void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		if (can_do_pal_halt) {
 			current_thread_info()->status &= ~TS_POLLING;
 			/*
@@ -309,6 +311,7 @@ cpu_idle (void)
 			normal_xtp();
 #endif
 		}
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 		check_pgt_cache();
 		if (cpu_is_offline(cpu))
-- 
1.7.8

