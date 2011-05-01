Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760Ab1EANfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:35:51 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44573 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab1EANWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 20/86] rcu: Enable DEBUG_OBJECTS_RCU_HEAD from !PREEMPT
Date: Sun,  1 May 2011 06:21:00 -0700
Message-Id: <1304256126-26015-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

The prohibition of DEBUG_OBJECTS_RCU_HEAD from !PREEMPT was due to the
fixup actions.  So just produce a warning from !PREEMPT.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupdate.c |   26 +++++++++++++++++++++-----
 lib/Kconfig.debug |    2 +-
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index f3240e9..b54d6d1 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -142,7 +142,14 @@ static int rcuhead_fixup_init(void *addr, enum debug_obj_state state)
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
+		 * In !PREEMPT configurations, there is no way to tell if we are
+		 * in a RCU read-side critical section or not, so we never
+		 * attempt any fixup and just print a warning.
 		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON(1);
+		return 0;
+#endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
 			WARN_ON(1);
@@ -184,7 +191,14 @@ static int rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
+		 * In !PREEMPT configurations, there is no way to tell if we are
+		 * in a RCU read-side critical section or not, so we never
+		 * attempt any fixup and just print a warning.
 		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON(1);
+		return 0;
+#endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
 			WARN_ON(1);
@@ -214,12 +228,14 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
-		 * Note that the machinery to reliably determine whether
-		 * or not we are in an RCU read-side critical section
-		 * exists only in the preemptible RCU implementations
-		 * (TINY_PREEMPT_RCU and TREE_PREEMPT_RCU), which is why
-		 * DEBUG_OBJECTS_RCU_HEAD is disallowed if !PREEMPT.
+		 * In !PREEMPT configurations, there is no way to tell if we are
+		 * in a RCU read-side critical section or not, so we never
+		 * attempt any fixup and just print a warning.
 		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON(1);
+		return 0;
+#endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
 			WARN_ON(1);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 93ce6de..3aa2780 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -337,7 +337,7 @@ config DEBUG_OBJECTS_WORK
 
 config DEBUG_OBJECTS_RCU_HEAD
 	bool "Debug RCU callbacks objects"
-	depends on DEBUG_OBJECTS && PREEMPT
+	depends on DEBUG_OBJECTS
 	help
 	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
 
-- 
1.7.3.2

