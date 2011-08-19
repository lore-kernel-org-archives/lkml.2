Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1HSPEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:04:37 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44052 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab1HSPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:04:35 -0400
From: tom.leiming@gmail.com
To: rostedt@goodmis.org, fweisbec@gmail.com, jean.pihet@newoldbits.com,
        mingo@redhat.com, trenn@suse.de
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/3] trace points: power: remove 'cpu_id' from trace_power_domain_target
Date: Fri, 19 Aug 2011 23:04:03 +0800
Message-Id: <1313766244-22313-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com>
References: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch removes the 'cpu_id' parameter of the power_domain_target
trace point, based on the ideas below:

- the cpu_id which is passed to trace point is always the current
  cpu
- the current cpu info has been included into the trace result
  already
- smp_processor_id() can't be used safely in preemptible context.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 Documentation/trace/events-power.txt |    2 +-
 arch/arm/mach-omap2/powerdomain.c    |    6 ++----
 include/trace/events/power.h         |   14 ++++++--------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/Documentation/trace/events-power.txt b/Documentation/trace/events-power.txt
index 3726ba5..e9d5fe3 100644
--- a/Documentation/trace/events-power.txt
+++ b/Documentation/trace/events-power.txt
@@ -83,7 +83,7 @@ clock rate for set_rate.
 =======================
 The power domain events are used for power domains transitions
 
-power_domain_target	"%s state=%lu cpu_id=%lu"
+power_domain_target	"%s state=%lu"
 
 The first parameter gives the power domain name (e.g. "mpu_pwrdm").
 The second parameter is the power domain target state.
diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index 9af0847..00e017e 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -160,8 +160,7 @@ static int _pwrdm_state_switch(struct powerdomain *pwrdm, int flag)
 			trace_state = (PWRDM_TRACE_STATES_FLAG |
 				       ((state & OMAP_POWERSTATE_MASK) << 8) |
 				       ((prev & OMAP_POWERSTATE_MASK) << 0));
-			trace_power_domain_target(pwrdm->name, trace_state,
-						  smp_processor_id());
+			trace_power_domain_target(pwrdm->name, trace_state);
 		}
 		break;
 	default:
@@ -423,8 +422,7 @@ int pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst)
 
 	if (arch_pwrdm && arch_pwrdm->pwrdm_set_next_pwrst) {
 		/* Trace the pwrdm desired target state */
-		trace_power_domain_target(pwrdm->name, pwrst,
-					  smp_processor_id());
+		trace_power_domain_target(pwrdm->name, pwrst);
 		/* Program the pwrdm desired target state */
 		ret = arch_pwrdm->pwrdm_set_next_pwrst(pwrdm, pwrst);
 	}
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index e315e68..3878edc 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -206,31 +206,29 @@ DEFINE_EVENT(clock, clock_set_rate,
  */
 DECLARE_EVENT_CLASS(power_domain,
 
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
 
 DEFINE_EVENT(power_domain, power_domain_target,
 
-	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+	TP_PROTO(const char *name, unsigned int state),
 
-	TP_ARGS(name, state, cpu_id)
+	TP_ARGS(name, state)
 );
 #endif /* _TRACE_POWER_H */
 
-- 
1.7.4.1

