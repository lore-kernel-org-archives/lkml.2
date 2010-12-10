Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab0LJTxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:53:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43049 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab0LJTxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:53:33 -0500
From: jean.pihet@newoldbits.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Renninger <trenn@suse.de>, linux-pm@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 3/3] tools, perf: Documentation for the power events API
Date: Fri, 10 Dec 2010 20:52:01 +0100
Message-Id: <1292010721-17426-4-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292010721-17426-1-git-send-email-j-pihet@ti.com>
References: <1292010721-17426-1-git-send-email-j-pihet@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Provides documentation for the following:
- the new power trace API,
- the old (legacy) power trace API,
- the DEPRECATED Kconfig option usage..

Signed-off-by: Jean Pihet <j-pihet@ti.com>
---
 Documentation/trace/events-power.txt |   90 ++++++++++++++++++++++++++++++++++
 1 files changed, 90 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/trace/events-power.txt

diff --git a/Documentation/trace/events-power.txt b/Documentation/trace/events-power.txt
new file mode 100644
index 0000000..8a50653
--- /dev/null
+++ b/Documentation/trace/events-power.txt
@@ -0,0 +1,90 @@
+
+			Subsystem Trace Points: power
+
+The power tracing system captures events related to power transitions
+within the kernel. Broadly speaking there are three major subheadings:
+
+  o Power state switch which reports events related to suspend (S-states),
+     cpuidle (C-states) and cpufreq (P-states)
+  o System clock related changes
+  o Power domains related changes and transitions
+
+This document describes what each of the tracepoints is and why they
+might be useful.
+
+Cf. include/trace/events/power.h for the events definitions.
+
+1. Power state switch events
+============================
+
+1.1 New trace API
+-----------------
+
+A 'cpu' event class gathers the CPU-related events: cpuidle and
+cpufreq.
+
+cpu_idle		"state=%lu cpu_id=%lu"
+cpu_frequency		"state=%lu cpu_id=%lu"
+
+A suspend event is used to indicate the system going in and out of the
+suspend mode:
+
+machine_suspend		"state=%lu"
+
+
+Note: the value of '-1' or '4294967295' for state means an exit from the current state,
+i.e. trace_cpu_idle(4, smp_processor_id()) means that the system
+enters the idle state 4, while trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id())
+means that the system exits the previous idle state.
+
+The event which has 'state=4294967295' in the trace is very important to the user
+space tools which are using it to detect the end of the current state, and so to
+correctly draw the states diagrams and to calculate accurate statistics etc.
+
+1.2 DEPRECATED trace API
+------------------------
+
+A new Kconfig option CONFIG_EVENT_POWER_TRACING_DEPRECATED with the default value of
+'y' has been created. This allows the legacy trace power API to be used conjointly
+with the new trace API.
+The Kconfig option, the old trace API (in include/trace/events/power.h) and the
+old trace points will disappear in a future release (namely 2.6.41).
+
+power_start		"type=%lu state=%lu cpu_id=%lu"
+power_frequency		"type=%lu state=%lu cpu_id=%lu"
+power_end		"cpu_id=%lu"
+
+The 'type' parameter takes one of those macros:
+ . POWER_NONE	= 0,
+ . POWER_CSTATE	= 1,	/* C-State */
+ . POWER_PSTATE	= 2,	/* Fequency change or DVFS */
+
+The 'state' parameter is set depending on the type:
+ . Target C-state for type=POWER_CSTATE,
+ . Target frequency for type=POWER_PSTATE,
+
+power_end is used to indicate the exit of a state, corresponding to the latest
+power_start event.
+
+2. Clocks events
+================
+The clock events are used for clock enable/disable and for
+clock rate change.
+
+clock_enable		"%s state=%lu cpu_id=%lu"
+clock_disable		"%s state=%lu cpu_id=%lu"
+clock_set_rate		"%s state=%lu cpu_id=%lu"
+
+The first parameter gives the clock name (e.g. "gpio1_iclk").
+The second parameter is '1' for enable, '0' for disable, the target
+clock rate for set_rate.
+
+3. Power domains events
+=======================
+The power domain events are used for power domains transitions
+
+power_domain_target	"%s state=%lu cpu_id=%lu"
+
+The first parameter gives the power domain name (e.g. "mpu_pwrdm").
+The second parameter is the power domain target state.
+
-- 
1.7.2.3

