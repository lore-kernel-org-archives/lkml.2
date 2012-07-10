Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2GJMRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:17:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:39945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab2GJMRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:17:17 -0400
Message-ID: <1341922621.3462.130.camel@twins>
Subject: Re: [PATCH V2 5/5] perf/x86: Add Intel Nehalem-EX uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Tue, 10 Jul 2012 14:17:01 +0200
In-Reply-To: <4FF534F1.3030307@intel.com>
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
	  <1341381616-12229-6-git-send-email-zheng.z.yan@intel.com>
	 <1341396293.2507.77.camel@laptop> <4FF534F1.3030307@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 14:32 +0800, Yan, Zheng wrote:
> The uncore subsystem in Nehalem-EX consists of 7 components
> (U-Box, C-Box, B-Box, S-Box, R-Box, M-Box and W-Box). This
> patch is large because the way to program these boxes is
> diverse.
> 
Thanks, I added the below little delta.

Did you manage to fix that SNB-EP crash already?

Also, should we be adding 58 (IVB) to the SNB uncore? The SDM states it
should all be the same programming wise.

---
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c

@@ -893,7 +893,7 @@ static struct attribute_group nhmex_unco
 static struct intel_uncore_type nhmex_uncore_cbox = {
 	.name			= "cbox",
 	.num_counters		= 6,
-	.num_boxes		= 8,
+	.num_boxes		= 10,
 	.perf_ctr_bits		= 48,
 	.event_ctl		= NHMEX_C0_MSR_PMON_EV_SEL0,
 	.perf_ctr		= NHMEX_C0_MSR_PMON_CTR0,
@@ -2806,9 +2806,9 @@ static int __init uncore_cpu_init(void)
 	max_cores = boot_cpu_data.x86_max_cores;
 	switch (boot_cpu_data.x86_model) {
 	case 26: /* Nehalem */
-	case 30:
+	case 30: /* Nehalem-EP */
 	case 37: /* Westmere */
-	case 44:
+	case 44: /* Westmere-EP */
 		msr_uncores = nhm_msr_uncores;
 		break;
 	case 42: /* Sandy Bridge */
@@ -2821,7 +2821,10 @@ static int __init uncore_cpu_init(void)
 			snbep_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snbep_msr_uncores;
 		break;
-	case 46:
+	case 46: /* Nehalem-EX */
+	case 47: /* Westmere-EX aka. Xeon E7 */
+		if (nhmex_uncore_cbox.num_boxes > max_cores)
+			nhmex_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = nhmex_msr_uncores;
 		break;
 	default:

