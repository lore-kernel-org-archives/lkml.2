Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1JULqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:46:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:56561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1JULqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:46:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="65431679"
From: John Mathew <john.mathew@intel.com>
To: linux-kernel@vger.kernel.org
Cc: len.brown@intel.com, pierre.tardy@intel.com, trenn@suse.de,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        John Mathew <john.mathew@intel.com>
Subject: [PATCH] cpuidle: Add an addtional trace for demoted c-states
Date: Fri, 21 Oct 2011 14:46:07 +0300
Message-Id: <1319197567-8573-1-git-send-email-john.mathew@intel.com>
X-Mailer: git-send-email 1.7.4.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables tracing of c-states that the device
eventually goes in to, which might be different from what
the governor had retuned. This scenario occurs in platforms
like Intel Medfield. Power tools like pytimechart will be
able to display accurate c-state transitions with the help of
this trace.

Signed-off-by: John Mathew <john.mathew@intel.com>
---
 drivers/cpuidle/cpuidle.c    |    3 +++
 include/trace/events/power.h |   23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index d4c5423..3d787ef 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -110,6 +110,9 @@ int cpuidle_idle_call(void)
 
 	dev->last_residency = target_state->enter(dev, target_state);
 
+	if (dev->last_state != target_state)
+		trace_power_demoted(POWER_CSTATE, dev->last_state->name, dev->cpu);
+
 	trace_power_end(dev->cpu);
 	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
 
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 1bcc2a8..941dc1a 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -101,6 +101,29 @@ DEFINE_EVENT(power, power_start,
 	TP_ARGS(type, state, cpu_id)
 );
 
+TRACE_EVENT(power_demoted,
+
+	TP_PROTO(unsigned int type, char *state, unsigned int cpu_id),
+
+	TP_ARGS(type, state, cpu_id),
+
+	TP_STRUCT__entry(
+		__field(	u64,		type		)
+		__string(	state,		state		)
+		__field(	u64,		cpu_id		)
+	),
+
+	TP_fast_assign(
+		__entry->type = type;
+		__assign_str(state, state);
+		__entry->cpu_id = cpu_id;
+	),
+
+	TP_printk("type=%lu state=%s cpu_id=%lu", (unsigned long)__entry->type,
+		 __get_str(state), (unsigned long)__entry->cpu_id)
+
+);
+
 DEFINE_EVENT(power, power_frequency,
 
 	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
-- 
1.7.4.1

---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

