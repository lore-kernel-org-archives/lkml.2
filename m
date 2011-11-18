Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab1KRPKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:10:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57842 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab1KRPKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:10:34 -0500
Subject: Re: [PATCH v4 0/2] perf, x86: handle overlapping counters
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 18 Nov 2011 16:10:17 +0100
In-Reply-To: <1321616122-1533-1-git-send-email-robert.richter@amd.com>
References: <1321616122-1533-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321629017.2197.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 12:35 +0100, Robert Richter wrote:
> I know there is an ongoing discussion about the best algorithm to be
> used for this problem. Posting this version with the latest updates
> anyway...
> 
> This patch set implements support for overlapping counters (patch #2).
> For this the existing x86 event scheduler is reworked by introducing
> helper functions (patch #1).
> 
> Version 4 of the patch set fixes a bug in the event assignment. There was a
> problem if the first event's weight (index 0) is not the minimum weight. In
> this case the event was assigned twice leaving another event uninitialized
> which caused a GP while accessing counter msrs. Fixes this by proper
> initialzing the first event in perf_sched_init().

OK, I've queued these and tested them using something like:

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -88,13 +88,19 @@ static struct extra_reg intel_nehalem_ex
 
 static struct event_constraint intel_westmere_event_constraints[] __read_mostly =
 {
-	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
-	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
+//	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
+//	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
 	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
 	INTEL_EVENT_CONSTRAINT(0x60, 0x1), /* OFFCORE_REQUESTS_OUTSTANDING */
 	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
 	INTEL_EVENT_CONSTRAINT(0xb3, 0x1), /* SNOOPQ_REQUEST_OUTSTANDING */
+
+	EVENT_CONSTRAINT_OVERLAP(0x003c, 0x1|0x2, INTEL_ARCH_EVENT_MASK),
+	EVENT_CONSTRAINT_OVERLAP(0x00c0, 0x2|0x4, INTEL_ARCH_EVENT_MASK),
+	EVENT_CONSTRAINT_OVERLAP(0x4f2e, 0x4|0x8, INTEL_ARCH_EVENT_MASK),
+	EVENT_CONSTRAINT_OVERLAP(0x412e, 0x8|0x1, INTEL_ARCH_EVENT_MASK),
+
 	EVENT_CONSTRAINT_END
 };
 
To stress the thing, you can quite easily manage to hit that
WARN_ON_ONCE() in there, but I haven't seen things explode yet.


> Robert Richter (2):
>   configs: updating misc-x86_64-erda to v3.0.8
>   config: updating misc-x86_64-erda.config for ASUS M4A89GTD PRO
> 
>  configs/misc-x86_64-erda.config |  517 ++++++++++++++++++++++++++++-----------
>  1 files changed, 379 insertions(+), 138 deletions(-)

You sure about that? :-)
