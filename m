Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0IQV6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 17:58:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:45681 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0IQV6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 17:58:32 -0400
From: Thomas Renninger <trenn@suse.de>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Fri, 17 Sep 2010 23:58:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.4-0.1.99.9.f8e4270-desktop; KDE/4.4.4; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <201009171508.46471.trenn@suse.de> <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
In-Reply-To: <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009172358.18652.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some patches for cleanup...
compile tested only...
Should not break existing user space apps, but they should
get converted asap to use power_swtich_state...

---

power-trace: Rename power frequency to power_switch_state

this interface/function is not intended for frequency changes
only, but should get used for any P- (processor frequency),
C- (processor sleep), T- (processor throttling), or S- (machine sleep)
state.

Since it's used in cpufreq.c which must be compiled in
and not in acpi-cpufreq.c anymore there is no need to export it
for modules.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/cpufreq/cpufreq.c    |    1 +
 include/trace/events/power.h |    7 +++++++
 kernel/trace/power-traces.c  |    1 -
 3 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.35-master/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-2.6.35-master.orig/drivers/cpufreq/cpufreq.c
+++ linux-2.6.35-master/drivers/cpufreq/cpufreq.c
@@ -354,6 +354,7 @@ void cpufreq_notify_transition(struct cp
 		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
 		dprintk("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
 			(unsigned long)freqs->cpu);
+		trace_power_switch_state(POWER_PSTATE, freqs->new, freqs->cpu);
 		trace_power_frequency(POWER_PSTATE, freqs->new, freqs->cpu);
 		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
 				CPUFREQ_POSTCHANGE, freqs);
Index: linux-2.6.35-master/include/trace/events/power.h
===================================================================
--- linux-2.6.35-master.orig/include/trace/events/power.h
+++ linux-2.6.35-master/include/trace/events/power.h
@@ -38,6 +38,13 @@ DECLARE_EVENT_CLASS(power,
 		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
 );
 
+DEFINE_EVENT(power, power_switch_state,
+
+	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(type, state, cpu_id)
+);
+
 DEFINE_EVENT(power, power_start,
 
 	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
Index: linux-2.6.35-master/kernel/trace/power-traces.c
===================================================================
--- linux-2.6.35-master.orig/kernel/trace/power-traces.c
+++ linux-2.6.35-master/kernel/trace/power-traces.c
@@ -13,5 +13,4 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
 
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
 
