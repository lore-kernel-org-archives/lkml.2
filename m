Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab0FBVXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:23:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44856 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab0FBVXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=YdIBKcq99eYebTXyHUQcCd1gims6iSPRSCXCHLUlOXAnKJeP3UqMaapnSKLh+2l3Rh
         jJv9vHHX3eLudWQtv+9d2LFDdDee2FPX4opbf2yD5P4Wq1383bm+3mu83LkIbDDHTjO6
         McMFQRd6BN3foG8hmwAfSreDp9d/dwYla5MBQ=
Date: Thu, 3 Jun 2010 01:23:04 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -tip] perf, x86: Make a second write to performance counter
	if needed
Message-ID: <20100602212304.GC5264@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Netburst PMU we need a second write to a performance counter
due to cpu erratum.

A simple flag test instead of alternative instructions was choosen
because wrmsrl is already a macro and if virtualization is turned
on will need an additional wrapper call which is more expencise.

nb: we should propably switch to jump-labels as only this facility
reach the mainline.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Robert Richter <robert.richter@amd.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Frédéric Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c    |   10 ++++++++++
 arch/x86/kernel/cpu/perf_event_p4.c |    9 +++++++++
 2 files changed, 19 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -220,6 +220,7 @@ struct x86_pmu {
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
 	void		(*quirks)(void);
+	int		perfctr_second_write;
 
 	int		(*cpu_prepare)(int cpu);
 	void		(*cpu_starting)(int cpu);
@@ -926,6 +927,15 @@ x86_perf_event_set_period(struct perf_ev
 	atomic64_set(&hwc->prev_count, (u64)-left);
 
 	wrmsrl(hwc->event_base + idx,
+		(u64)(-left) & x86_pmu.cntval_mask);
+
+	/*
+	 * Due to erratum on certan cpu we need
+	 * a second write to be sure the register
+	 * is updated properly
+	 */
+	if (x86_pmu.perfctr_second_write)
+		wrmsrl(hwc->event_base + idx,
 			(u64)(-left) & x86_pmu.cntval_mask);
 
 	perf_event_update_userpage(event);
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -829,6 +829,15 @@ static __initconst const struct x86_pmu 
 	.max_period		= (1ULL << 39) - 1,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
+	/*
+	 * This handles erratum N15 in intel doc 249199-029,
+	 * the counter may not be updated correctly on write
+	 * so we need a second write operation to do the trick
+	 * (the official workaround didn't work)
+	 *
+	 * the former idea is taken from OProfile code
+	 */
+	.perfctr_second_write	= 1,
 };
 
 static __init int p4_pmu_init(void)
