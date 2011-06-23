Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab1FWMtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:49:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43013 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1FWMtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GKq+aAICuwbjRDPXMMY0hpZ5l5gFpTYZIg9Z1cze15HTqxLdWB2cW76Yk1joqi5Lyz
         umtSjGzhw/v9DNmUo9tB97PdeBNNWTca/BZh76PT87Bsllq6uKhdevpGkKY2t7VtrwYO
         r4HSbaOFFocPXrVl0JZPpt1pyaz8KmvV30poc=
Date: Thu, 23 Jun 2011 16:49:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>, Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf, x86: Add hw_watchdog_set_attr() in a sake of
 nmi-watchdog on P4
Message-ID: <20110623124918.GC13050@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to restriction and specifics of Netburst PMU we need a separated
event for NMI watchdog. In particular every Netburst event consume not
just a counter and config register, but also an additional ESCR register.
Since ESCR registers are grouped upon counters (i.e. if ESCR is occupied
for some event there is no room for another event to enter until it's
released) we need to pick up "least" used ESCR (or most available)
for nmi-watchdog purpose -- MSR_P4_CRU_ESCR2/3 was chosen.

With this patch nmi-watchdog and perf top should be able to run simultaneously.

v2: Add a comment about non-sleeping clockticks spotted by Ingo Molnar.
v3: Peter Zijlstra and Stephane Eranian pointed out that making new
    event global visible (up to userspace) will bring problems supporting
    this ABI in future. So now this event is x86 specific and hidden
    from userspace.
v4: Stephane proposed to use __weak arch specific callback instead of
    new hidden generic event.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Stephane Eranian <eranian@google.com>
---

Note, I dont have access to P4 machine at moment so help in testing
would be highly appreciated.

 arch/x86/kernel/cpu/perf_event.c    |    7 +++++++
 arch/x86/kernel/cpu/perf_event_p4.c |   26 ++++++++++++++++++++++++++
 kernel/watchdog.c                   |    6 +++++-
 3 files changed, 38 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -233,6 +233,7 @@ struct x86_pmu {
 	void		(*enable_all)(int added);
 	void		(*enable)(struct perf_event *);
 	void		(*disable)(struct perf_event *);
+	void		(*hw_watchdog_set_attr)(struct perf_event_attr *attr);
 	int		(*hw_config)(struct perf_event *event);
 	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
 	unsigned	eventsel;
@@ -315,6 +316,12 @@ static u64 __read_mostly hw_cache_extra_
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
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -705,6 +705,31 @@ static int p4_validate_raw_event(struct 
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
@@ -1179,6 +1204,7 @@ static __initconst const struct x86_pmu 
 	.cntval_bits		= ARCH_P4_CNTRVAL_BITS,
 	.cntval_mask		= ARCH_P4_CNTRVAL_MASK,
 	.max_period		= (1ULL << (ARCH_P4_CNTRVAL_BITS - 1)) - 1,
+	.hw_watchdog_set_attr	= p4_hw_watchdog_set_attr,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
 	/*
Index: linux-2.6.git/kernel/watchdog.c
===================================================================
--- linux-2.6.git.orig/kernel/watchdog.c
+++ linux-2.6.git/kernel/watchdog.c
@@ -200,6 +200,8 @@ static int is_softlockup(unsigned long t
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
