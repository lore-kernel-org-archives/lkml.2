Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0JSNz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:55:29 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43764 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0JSNzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:55:23 -0400
Message-Id: <20101019134808.462621937@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 19 Oct 2010 15:43:02 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/7] perf, x86: Clean up reserve_ds_buffers() signature
References: <20101019134256.087045503@chello.nl>
Content-Disposition: inline; filename=perf-perf-event-improve-ds-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that reserve_ds_buffers() never fails, change it to return
void and remove all code dealing with the error return.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c          |    9 +++------
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    9 +++------
 2 files changed, 6 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -382,7 +382,7 @@ static void release_pmc_hardware(void) {
 
 #endif
 
-static int reserve_ds_buffers(void);
+static void reserve_ds_buffers(void);
 static void release_ds_buffers(void);
 
 static void hw_perf_event_destroy(struct perf_event *event)
@@ -546,11 +546,8 @@ static int __x86_pmu_event_init(struct p
 		if (atomic_read(&active_events) == 0) {
 			if (!reserve_pmc_hardware())
 				err = -EBUSY;
-			else {
-				err = reserve_ds_buffers();
-				if (err)
-					release_pmc_hardware();
-			}
+			else
+				reserve_ds_buffers();
 		}
 		if (!err)
 			atomic_inc(&active_events);
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -191,7 +191,7 @@ static void release_ds_buffers(void)
 	put_online_cpus();
 }
 
-static int reserve_ds_buffers(void)
+static void reserve_ds_buffers(void)
 {
 	int bts_err = 0, pebs_err = 0;
 	int cpu;
@@ -200,7 +200,7 @@ static int reserve_ds_buffers(void)
 	x86_pmu.pebs_active = 0;
 
 	if (!x86_pmu.bts && !x86_pmu.pebs)
-		return 0;
+		return;
 
 	if (!x86_pmu.bts)
 		bts_err = 1;
@@ -251,8 +251,6 @@ static int reserve_ds_buffers(void)
 	}
 
 	put_online_cpus();
-
-	return 0;
 }
 
 /*
@@ -714,9 +712,8 @@ static void intel_ds_init(void)
 
 #else /* CONFIG_CPU_SUP_INTEL */
 
-static int reserve_ds_buffers(void)
+static void reserve_ds_buffers(void)
 {
-	return 0;
 }
 
 static void release_ds_buffers(void)


