Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab1HSPEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:04:22 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:62474 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1HSPEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:04:21 -0400
From: tom.leiming@gmail.com
To: rostedt@goodmis.org, fweisbec@gmail.com, jean.pihet@newoldbits.com,
        mingo@redhat.com, trenn@suse.de
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/3] trace points: power: remove 'cpu_id' from trace_clock_*
Date: Fri, 19 Aug 2011 23:04:02 +0800
Message-Id: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch removes the 'cpu_id' parameter of the clock_*
trace point, based on the ideas below:

- the cpu_id which is passed to trace point is always the current
  cpu
- the current cpu info has been included into the trace result already
- smp_processor_id() can't be used safely in preemptible context.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 Documentation/trace/events-power.txt |    6 +++---
 arch/arm/mach-omap2/clock.c          |    6 +++---
 include/trace/events/power.h         |   22 ++++++++++------------
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/Documentation/trace/events-power.txt b/Documentation/trace/events-power.txt
index 96d87b6..3726ba5 100644
--- a/Documentation/trace/events-power.txt
+++ b/Documentation/trace/events-power.txt
@@ -71,9 +71,9 @@ power_start event.
 The clock events are used for clock enable/disable and for
 clock rate change.
 
-clock_enable		"%s state=%lu cpu_id=%lu"
-clock_disable		"%s state=%lu cpu_id=%lu"
-clock_set_rate		"%s state=%lu cpu_id=%lu"
+clock_enable		"%s state=%lu"
+clock_disable		"%s state=%lu"
+clock_set_rate		"%s state=%lu"
 
 The first parameter gives the clock name (e.g. "gpio1_iclk").
 The second parameter is '1' for enable, '0' for disable, the target
diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 1f3481f..05111b1 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -285,7 +285,7 @@ void omap2_clk_disable(struct clk *clk)
 	pr_debug("clock: %s: disabling in hardware\n", clk->name);
 
 	if (clk->ops && clk->ops->disable) {
-		trace_clock_disable(clk->name, 0, smp_processor_id());
+		trace_clock_disable(clk->name, 0);
 		clk->ops->disable(clk);
 	}
 
@@ -339,7 +339,7 @@ int omap2_clk_enable(struct clk *clk)
 	}
 
 	if (clk->ops && clk->ops->enable) {
-		trace_clock_enable(clk->name, 1, smp_processor_id());
+		trace_clock_enable(clk->name, 1);
 		ret = clk->ops->enable(clk);
 		if (ret) {
 			WARN(1, "clock: %s: could not enable: %d\n",
@@ -380,7 +380,7 @@ int omap2_clk_set_rate(struct clk *clk, unsigned long rate)
 
 	/* dpll_ck, core_ck, virt_prcm_set; plus all clksel clocks */
 	if (clk->set_rate) {
-		trace_clock_set_rate(clk->name, rate, smp_processor_id());
+		trace_clock_set_rate(clk->name, rate);
 		ret = clk->set_rate(clk, rate);
 	}
 
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 1bcc2a8..e315e68 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -162,45 +162,43 @@ static inline void trace_power_frequency(u64 type, u64 state, u64 cpuid) {};
  */
 DECLARE_EVENT_CLASS(clock,
 
-	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(const char *name, unsigned int state),
 
-	TP_ARGS(name, state, cpu_id),
+	TP_ARGS(name, state),
 
 	TP_STRUCT__entry(
 		__string(       name,           name            )
 		__field(        u64,            state           )
-		__field(        u64,            cpu_id          )
 	),
 
 	TP_fast_assign(
 		__assign_str(name, name);
 		__entry->state = state;
-		__entry->cpu_id = cpu_id;
 	),
 
-	TP_printk("%s state=%lu cpu_id=%lu", __get_str(name),
-		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
+	TP_printk("%s state=%lu", __get_str(name),
+		(unsigned long)__entry->state)
 );
 
 DEFINE_EVENT(clock, clock_enable,
 
-	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(const char *name, unsigned int state),
 
-	TP_ARGS(name, state, cpu_id)
+	TP_ARGS(name, state)
 );
 
 DEFINE_EVENT(clock, clock_disable,
 
-	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(const char *name, unsigned int state),
 
-	TP_ARGS(name, state, cpu_id)
+	TP_ARGS(name, state)
 );
 
 DEFINE_EVENT(clock, clock_set_rate,
 
-	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(const char *name, unsigned int state),
 
-	TP_ARGS(name, state, cpu_id)
+	TP_ARGS(name, state)
 );
 
 /*
-- 
1.7.4.1

