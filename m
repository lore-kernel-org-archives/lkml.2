Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab2HMK2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:28:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:36537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab2HMK2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:28:13 -0400
Message-ID: <1344853682.31459.20.camel@twins>
Subject: Re: [BUG] perf: sharing of cpuctx between core and ibs PMU causes
 problems
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>, mingo@elte.hu
Date: Mon, 13 Aug 2012 12:28:02 +0200
In-Reply-To: <CABPqkBRzyrmL_yiKnYWU4qaSZXbD=JJVnm5py4PUcgAYvT=hcA@mail.gmail.com>
References: <CABPqkBRWLcP_9WOL_VvucnY7A2AcpzuvsUt4_ZUgYMREo-65dA@mail.gmail.com>
	 <50235ED0.5010107@intel.com>
	 <CABPqkBT-pvmhyOHfMXs7dXsJXpEVmaSST1xFFHzCu4CDBf7baw@mail.gmail.com>
	 <1344535707.20277.20.camel@twins>
	 <CABPqkBRzyrmL_yiKnYWU4qaSZXbD=JJVnm5py4PUcgAYvT=hcA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK,.. so the AMD IBS PMUs actually have perf_invalid_context.

Lemme have a proper look...


Weirdness.. perf_pmu_register() will allocate a pmu->pmu_cpu_context for
each PMU. find_pmu_context() even special cases the perf_invalid_context
to return NULL to force the allocation instead of sharing it.

So both IBS PMUs should have their own cpuctx.



In any case, I was talking about something like the below.. I hate
growing the per-task ctx array with two entries, esp. since we'll mostly
add two NULL pointer checks on every perf operation for everybody not
using IBS.

---
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -436,7 +436,7 @@ static void perf_ibs_read(struct perf_ev
 
 static struct perf_ibs perf_ibs_fetch = {
 	.pmu = {
-		.task_ctx_nr	= perf_invalid_context,
+		.task_ctx_nr	= perf_hw2_context,
 
 		.event_init	= perf_ibs_init,
 		.add		= perf_ibs_add,
@@ -459,7 +459,7 @@ static struct perf_ibs perf_ibs_fetch =
 
 static struct perf_ibs perf_ibs_op = {
 	.pmu = {
-		.task_ctx_nr	= perf_invalid_context,
+		.task_ctx_nr	= perf_hw3_context,
 
 		.event_init	= perf_ibs_init,
 		.add		= perf_ibs_add,
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1237,6 +1237,8 @@ enum perf_event_task_context {
 	perf_invalid_context = -1,
 	perf_hw_context = 0,
 	perf_sw_context,
+	perf_hw2_context, /* AMD IBS (fetch) */
+	perf_hw3_context, /* AMD IBS (ops)   */
 	perf_nr_task_contexts,
 };
 

