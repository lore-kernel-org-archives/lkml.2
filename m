Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab0HPLJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:09:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52951 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0HPLJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:09:24 -0400
MIME-Version: 1.0
X-Originating-IP: [81.240.54.178]
Date: Mon, 16 Aug 2010 13:09:23 +0200
Message-ID: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com>
Subject: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a patch proposal for adding new trace events for power management.
Comments are welcome on this email address Jean Pihet
<jean.pihet@newoldbits.com>.

Jean

>From b1d6df4fb4ebb72dca6660659d7030736c2a5cb2 Mon Sep 17 00:00:00 2001
From: Jean Pihet <jean.pihet@newoldbits.com>
Date: Mon, 16 Aug 2010 12:31:31 +0200
Subject: [PATCH] tracing, perf: add more power related events

This patch adds new generic events for dynamic power management
tracing:
- clock events class: used for clock enable/disable and for
   clock rate change,
- power_domain events class: used for power domains transitions.

The OMAP architecture is using the new events for PM debugging, however
the new events are made generic enough to be used by all platforms.

Signed-off-by: Jean Pihet <jpihet@ti.com>
---
 include/trace/events/power.h |   84 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 35a2a6e..0caa79c 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -16,6 +16,10 @@ enum {
 };
 #endif

+/*
+ * The power events are used for cpuidle (power_start, power_end) and for
+ *  cpufreq (power_frequency)
+ */
 DECLARE_EVENT_CLASS(power,

 	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
@@ -70,6 +74,86 @@ TRACE_EVENT(power_end,

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
+		__string(	name,		name		)
+		__field(	u64,		state		)
+		__field(	u64,		cpu_id		)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->state = state;
+		__entry->cpu_id = cpu_id;
+	),
+
+	TP_printk("name=%s state=%lu cpu_id=%lu", __get_str(name),
+		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
+);
+
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
+		__string(	name,		name		)
+		__field(	u64,		state		)
+		__field(	u64,		cpu_id		)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->state = state;
+		__entry->cpu_id = cpu_id;
+	),
+
+	TP_printk("name=%s state=%lu cpu_id=%lu", __get_str(name),
+		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
+);
+
+DEFINE_EVENT(power_domain, power_domain_transition,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id)
+);
+
 #endif /* _TRACE_POWER_H */

 /* This part must be outside protection */
-- 
1.7.1
