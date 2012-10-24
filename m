Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633Ab2JXKgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:36:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55557 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939Ab2JXKgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:36:47 -0400
Date: Wed, 24 Oct 2012 03:35:23 -0700
From: tip-bot for Vince Weaver <vincent.weaver@maine.edu>
Message-ID: <tip-7d011962afbaa6e572cd8e0dbb7abf773e166e64@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, lawrence.f.meadows@intel.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, lawrence.f.meadows@intel.com,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1210171303290.23243@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210171303290.23243@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Remove cpuc->
 enable check on Intl KNC event enable/disable
Git-Commit-ID: 7d011962afbaa6e572cd8e0dbb7abf773e166e64
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:35:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d011962afbaa6e572cd8e0dbb7abf773e166e64
Gitweb:     http://git.kernel.org/tip/7d011962afbaa6e572cd8e0dbb7abf773e166e64
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Wed, 17 Oct 2012 13:04:33 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 12:00:49 +0200

perf/x86: Remove cpuc->enable check on Intl KNC event enable/disable

x86_pmu.enable() is called from x86_pmu_enable() with
cpuc->enabled set to 0.  This means we weren't re-enabling the
counters after a context switch.

This patch just removes the check, as it should't be necessary
(and the equivelent x86_ generic code does not have the checks).

The origin of this problem is the KNC driver being based on the
P6 one.   The P6 driver also has this issue, but works anyway
due to various lucky accidents.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: eranian@gmail.com
Cc: Meadows
Cc: Lawrence F <lawrence.f.meadows@intel.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1210171303290.23243@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_knc.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
index 73bcfbd..f3a2af4 100644
--- a/arch/x86/kernel/cpu/perf_event_knc.c
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -173,26 +173,22 @@ static void knc_pmu_enable_all(int added)
 static inline void
 knc_pmu_disable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
-	if (cpuc->enabled)
-		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+	val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)wrmsrl_safe(hwc->config_base + hwc->idx, val);
 }
 
 static void knc_pmu_enable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
-	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
+	val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)wrmsrl_safe(hwc->config_base + hwc->idx, val);
 }
