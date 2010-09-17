Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab0IQI3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:29:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:59348 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab0IQI3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:29:20 -0400
Date: Fri, 17 Sep 2010 08:28:43 GMT
From: tip-bot for Jean Pihet <jean.pihet@newoldbits.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jean.pihet@newoldbits.com, arjan@linux.intel.com, peterz@infradead.org,
        j-pihet@ti.com, khilman@deeprootsystems.com, tglx@linutronix.de,
        trenn@suse.de, mingo@elte.hu, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jean.pihet@newoldbits.com, arjan@linux.intel.com, j-pihet@ti.com,
        peterz@infradead.org, khilman@deeprootsystems.com, tglx@linutronix.de,
        trenn@suse.de, len.brown@intel.com, mingo@elte.hu
In-Reply-To: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing, perf: Add more power related events
Message-ID: <tip-74704ac6ea402d50c9543cb28247e6d9f521f7ae@git.kernel.org>
Git-Commit-ID: 74704ac6ea402d50c9543cb28247e6d9f521f7ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 08:28:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74704ac6ea402d50c9543cb28247e6d9f521f7ae
Gitweb:     http://git.kernel.org/tip/74704ac6ea402d50c9543cb28247e6d9f521f7ae
Author:     Jean Pihet <jean.pihet@newoldbits.com>
AuthorDate: Tue, 7 Sep 2010 09:21:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Sep 2010 09:10:43 +0200

tracing, perf: Add more power related events

This patch adds new generic events for dynamic power management
tracing:

 - clock events class: used for clock enable/disable and for
   clock rate change,
 - power_domain events class: used for power domains transitions.

The OMAP architecture will be using the new events for PM debugging,
however the new events are made generic enough to be used by all
platforms.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
Acked-by: Thomas Renninger <trenn@suse.de>
Cc: discuss@lesswatts.org
Cc: linux-pm@lists.linux-foundation.org
Cc: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
LKML-Reference: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/power.h |   90 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 35a2a6e..286784d 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -10,12 +10,17 @@
 #ifndef _TRACE_POWER_ENUM_
 #define _TRACE_POWER_ENUM_
 enum {
-	POWER_NONE = 0,
-	POWER_CSTATE = 1,
-	POWER_PSTATE = 2,
+	POWER_NONE	= 0,
+	POWER_CSTATE	= 1,	/* C-State */
+	POWER_PSTATE	= 2,	/* Fequency change or DVFS */
+	POWER_SSTATE	= 3,	/* Suspend */
 };
 #endif
 
+/*
+ * The power events are used for cpuidle & suspend (power_start, power_end)
+ *  and for cpufreq (power_frequency)
+ */
 DECLARE_EVENT_CLASS(power,
 
 	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
@@ -70,6 +75,85 @@ TRACE_EVENT(power_end,
 
 );
 
+/*
+ * The clock events are used for clock enable/disable and for
+ *  clock rate change
+ */
+DECLARE_EVENT_CLASS(clock,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id),
+
+	TP_STRUCT__entry(
+		__string(       name,           name            )
+		__field(        u64,            state           )
+		__field(        u64,            cpu_id          )
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->state = state;
+		__entry->cpu_id = cpu_id;
+	),
+
+	TP_printk("%s state=%lu cpu_id=%lu", __get_str(name),
+		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
+);
+
+DEFINE_EVENT(clock, clock_enable,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id)
+);
+
+DEFINE_EVENT(clock, clock_disable,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id)
+);
+
+DEFINE_EVENT(clock, clock_set_rate,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id)
+);
+
+/*
+ * The power domain events are used for power domains transitions
+ */
+DECLARE_EVENT_CLASS(power_domain,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id),
+
+	TP_STRUCT__entry(
+		__string(       name,           name            )
+		__field(        u64,            state           )
+		__field(        u64,            cpu_id          )
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->state = state;
+		__entry->cpu_id = cpu_id;
+),
+
+	TP_printk("%s state=%lu cpu_id=%lu", __get_str(name),
+		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
+);
+
+DEFINE_EVENT(power_domain, power_domain_target,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id)
+);
+
 #endif /* _TRACE_POWER_H */
 
 /* This part must be outside protection */
