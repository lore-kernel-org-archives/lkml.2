Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935518Ab0KQWXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:23:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:55815 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070Ab0KQWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:23:07 -0500
Message-Id: <20101117222056.150176439@chello.nl>
User-Agent: quilt/0.47-1
Date: Wed, 17 Nov 2010 23:17:34 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kyle Moffett <kyle@moffetthome.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/8] perf: Use early_initcall() for tracepoint and breakpoint init
References: <20101117221730.002627458@chello.nl>
Content-Disposition: inline; filename=perf-fix-tp-bp-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like other pmu implementations, use early_initcall().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/hw_breakpoint.c |    2 +-
 kernel/perf_event.c    |    9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6.orig/kernel/hw_breakpoint.c
+++ linux-2.6/kernel/hw_breakpoint.c
@@ -655,6 +655,6 @@ static int __init init_hw_breakpoint(voi
 
 	return -ENOMEM;
 }
-core_initcall(init_hw_breakpoint);
+early_initcall(init_hw_breakpoint);
 
 
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4831,10 +4831,12 @@ static struct pmu perf_tracepoint = {
 	.read		= perf_swevent_read,
 };
 
-static inline void perf_tp_register(void)
+static __init int perf_tp_init(void)
 {
 	perf_pmu_register(&perf_tracepoint);
+	return 0;
 }
+early_initcall(perf_tp_init);
 
 static int perf_event_set_filter(struct perf_event *event, void __user *arg)
 {
@@ -4861,10 +4863,6 @@ static void perf_event_free_filter(struc
 
 #else
 
-static inline void perf_tp_register(void)
-{
-}
-
 static int perf_event_set_filter(struct perf_event *event, void __user *arg)
 {
 	return -ENOENT;
@@ -6365,6 +6363,5 @@ void __init perf_event_init(void)
 	perf_pmu_register(&perf_swevent);
 	perf_pmu_register(&perf_cpu_clock);
 	perf_pmu_register(&perf_task_clock);
-	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
 }


