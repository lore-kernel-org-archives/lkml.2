Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0FZLWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 07:22:42 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:52352 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469Ab0FZLWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 07:22:40 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
In-Reply-To: <20100624142804.431553874@chello.nl>
References: <20100624142804.431553874@chello.nl>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Sat, 26 Jun 2010 12:22:39 +0100
Message-ID: <87iq56yr5s.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 16:28:04 +0200, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> These patches prepare the perf code for multiple pmus (no user
> interface yet, Lin Ming is working on that). These patches remove all
> weak functions and rework the struct pmu interface.
> 
> The patches are boot tested on x86_64 and compile tested on: powerpc
> (!fsl, what config is that?), sparc and arm (sorry no SH compiler)

Hi Peter,

I tried your SH changes and I needed to apply this patch to get it to
compile. I haven't run the code yet, but I'll do that later today.

---

diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 50ff852..6bfbaec 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -251,7 +251,7 @@ static void sh_pmu_del(struct perf_event *event, int flags)
 	perf_event_update_userpage(event);
 }
 
-static int sh_pmu_enable(struct perf_event *event, int flags)
+static int sh_pmu_add(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
@@ -283,7 +283,7 @@ static void sh_pmu_read(struct perf_event *event)
 	sh_perf_event_update(event, &event->hw, event->hw.idx);
 }
 
-static in sh_pmu_event_init(struct perf_event *event)
+static int sh_pmu_event_init(struct perf_event *event)
 {
 	int err = __hw_perf_event_init(event);
 	if (unlikely(err)) {
@@ -345,15 +345,15 @@ sh_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-int __cpuinit register_sh_pmu(struct sh_pmu *pmu)
+int __cpuinit register_sh_pmu(struct sh_pmu *_pmu)
 {
 	if (sh_pmu)
 		return -EBUSY;
-	sh_pmu = pmu;
+	sh_pmu = _pmu;
 
-	pr_info("Performance Events: %s support registered\n", pmu->name);
+	pr_info("Performance Events: %s support registered\n", _pmu->name);
 
-	WARN_ON(pmu->num_events > MAX_HWEVENTS);
+	WARN_ON(_pmu->num_events > MAX_HWEVENTS);
 
 	perf_pmu_register(&pmu);
 	perf_cpu_notifier(sh_pmu_notifier);
