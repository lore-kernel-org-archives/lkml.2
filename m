Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1BWPNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:13:24 -0500
Received: from blu0-omc1-s13.blu0.hotmail.com ([65.55.116.24]:49357 "EHLO
	blu0-omc1-s13.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704Ab1BWPNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:13:23 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP327A5C223BCDB8D998D2DD96DB0@phx.gbl>
Date: Wed, 23 Feb 2011 10:13:19 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: [PATCH] debug rcu head support !PREEMPT config
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-5-git-send-email-paulmck@linux.vnet.ibm.com> <1298431409.7666.76.camel@gandalf.stny.rr.com> <BLU0-SMTP615CB0BE0A2623EF62925096DB0@phx.gbl> <1298472914.7666.85.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1298472914.7666.85.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:12:19 up 322 days,  1:01,  6 users,  load average: 1.69, 1.66,
	1.54
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 23 Feb 2011 15:13:23.0141 (UTC) FILETIME=[36512F50:01CBD36C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove DEBUG_RCU_HEAD dependency on PREEMPT config. Handle the unability to
detect if within a RCU read-side critical section by never performing any
attempt to recover from a failure situation in the fixup handlers. Just print
the warnings.

This patch is only compile-tested.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/rcupdate.c |   17 +++++++++++++++++
 lib/Kconfig.debug |    2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/lib/Kconfig.debug
===================================================================
--- linux-2.6-lttng.orig/lib/Kconfig.debug
+++ linux-2.6-lttng/lib/Kconfig.debug
@@ -313,7 +313,7 @@ config DEBUG_OBJECTS_WORK
 
 config DEBUG_OBJECTS_RCU_HEAD
 	bool "Debug RCU callbacks objects"
-	depends on DEBUG_OBJECTS && PREEMPT
+	depends on DEBUG_OBJECTS
 	help
 	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
 
Index: linux-2.6-lttng/kernel/rcupdate.c
===================================================================
--- linux-2.6-lttng.orig/kernel/rcupdate.c
+++ linux-2.6-lttng/kernel/rcupdate.c
@@ -142,7 +142,14 @@ static int rcuhead_fixup_init(void *addr
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
@@ -184,7 +191,14 @@ static int rcuhead_fixup_activate(void *
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
@@ -214,6 +228,9 @@ static int rcuhead_fixup_free(void *addr
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
+		 * In !PREEMPT configurations, there is no way to tell if we are
+		 * in a RCU read-side critical section or not, so we never
+		 * attempt any fixup and just print a warning.
 		 */
 #ifndef CONFIG_PREEMPT
 		WARN_ON(1);
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
