Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1AEV1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:27:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:36749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab1AEV1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:27:38 -0500
Date: Wed, 5 Jan 2011 21:25:06 GMT
From: tip-bot for Jean Pihet <j-pihet@ti.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, arjan@linux.intel.com, j-pihet@ti.com, pavel@ucw.cz,
        rostedt@goodmis.org, tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu,
        len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com, j-pihet@ti.com,
        pavel@ucw.cz, rostedt@goodmis.org, tglx@linutronix.de, rjw@sisk.pl,
        len.brown@intel.com, mingo@elte.hu
In-Reply-To: <1294253342-29056-3-git-send-email-j-pihet@ti.com>
References: <1294253342-29056-3-git-send-email-j-pihet@ti.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools, perf: Documentation for the power events API
Message-ID: <tip-4b95f135f606c87e4056b6d7fd3c5781c818858b@git.kernel.org>
Git-Commit-ID: 4b95f135f606c87e4056b6d7fd3c5781c818858b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 Jan 2011 21:25:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b95f135f606c87e4056b6d7fd3c5781c818858b
Gitweb:     http://git.kernel.org/tip/4b95f135f606c87e4056b6d7fd3c5781c818858b
Author:     Jean Pihet <j-pihet@ti.com>
AuthorDate: Wed, 5 Jan 2011 19:49:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Jan 2011 21:25:29 +0100

tools, perf: Documentation for the power events API

Provides documentation for the following:
- the new power trace API,
- the old (legacy) power trace API,
- the DEPRECATED Kconfig option usage.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: trenn@suse.de
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-pm@lists.linux-foundation.org
LKML-Reference: <1294253342-29056-3-git-send-email-j-pihet@ti.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/trace/events-power.txt |   90 ++++++++++++++++++++++++++++++++++
 1 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/events-power.txt b/Documentation/trace/events-power.txt
new file mode 100644
index 0000000..96d87b6
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
