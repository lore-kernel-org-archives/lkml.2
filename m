Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab0CTFps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 01:45:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59098 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0CTFpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 01:45:47 -0400
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/9] oprofile, perf, x86: introduce new functions to reserve perfctrs by index
From: Andi Kleen <andi@firstfloor.org>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
	<1267716131-17908-4-git-send-email-robert.richter@amd.com>
Date: Sat, 20 Mar 2010 06:45:44 +0100
In-Reply-To: <1267716131-17908-4-git-send-email-robert.richter@amd.com> (Robert Richter's message of "Thu, 4 Mar 2010 16:22:05 +0100")
Message-ID: <87eijfczqv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter <robert.richter@amd.com> writes:

> Current perfctr reservation code allocates single pmu msrs. The msr
> addresses may differ depending on the model and offset calculation is
> necessary. This can be easier implemented by reserving a counter by
> its index only.

Sorry reviewing old patch. This doesn't work for the fixed counters on intel,
which don't have a index (or rather they have a separate number space)

I had a old patch to fix the reservation for them (and a matching
patch to perf to use it).

How to resolve this?

-Andi

---

---
 arch/x86/kernel/cpu/perfctr-watchdog.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6.32-ak/arch/x86/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux-2.6.32-ak.orig/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ linux-2.6.32-ak/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -70,9 +70,13 @@ static inline unsigned int nmi_perfctr_m
 	case X86_VENDOR_AMD:
 		return msr - MSR_K7_PERFCTR0;
 	case X86_VENDOR_INTEL:
-		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
+			if (msr >= MSR_CORE_PERF_FIXED_CTR0 &&
+			    msr < MSR_CORE_PERF_FIXED_CTR0 + 8)
+				return NMI_MAX_COUNTER_BITS -
+						(msr - MSR_CORE_PERF_FIXED_CTR0);
 			return msr - MSR_ARCH_PERFMON_PERFCTR0;
-
+		}
 		switch (boot_cpu_data.x86) {
 		case 6:
 			return msr - MSR_P6_PERFCTR0;




-- 
ak@linux.intel.com -- Speaking for myself only.
