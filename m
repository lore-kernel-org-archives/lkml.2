Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab1GAPVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:21:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:57472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab1GAPVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:21:15 -0400
Date: Fri, 1 Jul 2011 15:20:53 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
Message-ID: <tip-1880c4ae182afb5650c5678949ecfe7ff66a724e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, gorcunov@gmail.com, fweisbec@gmail.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, gorcunov@gmail.com, fweisbec@gmail.com,
        ming.m.lin@intel.com, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <20110623124918.GC13050@sun>
References: <20110623124918.GC13050@sun>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Add hw_watchdog_set_attr() in a sake of nmi-watchdog on P4
Git-Commit-ID: 1880c4ae182afb5650c5678949ecfe7ff66a724e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:20:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1880c4ae182afb5650c5678949ecfe7ff66a724e
Gitweb:     http://git.kernel.org/tip/1880c4ae182afb5650c5678949ecfe7ff66a724e
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Thu, 23 Jun 2011 16:49:18 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:34 +0200

perf, x86: Add hw_watchdog_set_attr() in a sake of nmi-watchdog on P4

Due to restriction and specifics of Netburst PMU we need a separated
event for NMI watchdog. In particular every Netburst event
consumes not just a counter and a config register, but also an
additional ESCR register.

Since ESCR registers are grouped upon counters (i.e. if ESCR is occupied
for some event there is no room for another event to enter until its
released) we need to pick up the "least" used ESCR (or the most available
one) for nmi-watchdog purposes -- so MSR_P4_CRU_ESCR2/3 was chosen.

With this patch nmi-watchdog and perf top should be able to run simultaneously.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
Tested-and-reviewed-by: Don Zickus <dzickus@redhat.com>
Tested-and-reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110623124918.GC13050@sun
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c    |    7 +++++++
 arch/x86/kernel/cpu/perf_event_p4.c |   26 ++++++++++++++++++++++++++
 kernel/watchdog.c                   |    6 +++++-
 3 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3a0338b..8a57f9a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -233,6 +233,7 @@ struct x86_pmu {
 	void		(*enable_all)(int added);
 	void		(*enable)(struct perf_event *);
 	void		(*disable)(struct perf_event *);
+	void		(*hw_watchdog_set_attr)(struct perf_event_attr *attr);
 	int		(*hw_config)(struct perf_event *event);
 	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
 	unsigned	eventsel;
@@ -315,6 +316,12 @@ static u64 __read_mostly hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
+void hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr)
+{
+	if (x86_pmu.hw_watchdog_set_attr)
+		x86_pmu.hw_watchdog_set_attr(wd_attr);
+}
+
 /*
  * Propagate event elapsed time into the generic event.
  * Can only be executed on the CPU where the event is active.
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index ead584f..f76fddf 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -705,6 +705,31 @@ static int p4_validate_raw_event(struct perf_event *event)
 	return 0;
 }
 
+static void p4_hw_watchdog_set_attr(struct perf_event_attr *wd_attr)
+{
+	/*
+	 * Watchdog ticks are special on Netburst, we use
+	 * that named "non-sleeping" ticks as recommended
+	 * by Intel SDM Vol3b.
+	 */
+	WARN_ON_ONCE(wd_attr->type	!= PERF_TYPE_HARDWARE ||
+		     wd_attr->config	!= PERF_COUNT_HW_CPU_CYCLES);
+
+	wd_attr->type	= PERF_TYPE_RAW;
+	wd_attr->config	=
+		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))		|
+		p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT		|
+			P4_CCCR_COMPARE);
+}
+
 static int p4_hw_config(struct perf_event *event)
 {
 	int cpu = get_cpu();
@@ -1179,6 +1204,7 @@ static __initconst const struct x86_pmu p4_pmu = {
 	.cntval_bits		= ARCH_P4_CNTRVAL_BITS,
 	.cntval_mask		= ARCH_P4_CNTRVAL_MASK,
 	.max_period		= (1ULL << (ARCH_P4_CNTRVAL_BITS - 1)) - 1,
+	.hw_watchdog_set_attr	= p4_hw_watchdog_set_attr,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
 	/*
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 3d0c56a..752b75b 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -200,6 +200,8 @@ static int is_softlockup(unsigned long touch_ts)
 }
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
+void __weak hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr) { }
+
 static struct perf_event_attr wd_hw_attr = {
 	.type		= PERF_TYPE_HARDWARE,
 	.config		= PERF_COUNT_HW_CPU_CYCLES,
@@ -368,9 +370,11 @@ static int watchdog_nmi_enable(int cpu)
 	if (event != NULL)
 		goto out_enable;
 
-	/* Try to register using hardware perf events */
 	wd_attr = &wd_hw_attr;
 	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
+	hw_nmi_watchdog_set_attr(wd_attr);
+
+	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
 	if (!IS_ERR(event)) {
 		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
