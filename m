Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab1CSRU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 13:20:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab1CSRUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 13:20:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=oBijLTnDwuiFrcU+H2jV8cgrJsiS4oyBddNZXeEb58lrcjD9b3rV0M43W4nyCwIeLV
         onPXh9L5K32oBxNK1s+w==
Date: Sat, 19 Mar 2011 18:20:05 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ming.m.lin@intel.com,
        robert.richter@amd.com, asharma@fb.com, perfmon2-devel@lists.sf.net
Subject: [PATCH] perf_events: fix Intel fixed counters base initialization
Message-ID: <20110319172005.GB4978@quad>
Reply-To: eranian@google.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch solves the problems introduced by Robert's
commit 41bf498 and reported by Arun Sharma. This commit gets rid
of the base + index notation for reading and writing PMU msrs.

The problem is that for fixed counters, the new calculation for the
base did not take into account the fixed counter indexes, thus all
fixed counters were read/written from fixed counter 0. Although all
fixed counters share the same config MSR, they each have their own
counter register.

Without:
$ task -e unhalted_core_cycles -e instructions_retired -e baclears noploop 1
noploop for 1 seconds

 242202299 unhalted_core_cycles (0.00% scaling, ena=1000790892, run=1000790892)
2389685946 instructions_retired (0.00% scaling, ena=1000790892, run=1000790892)
     49473 baclears (0.00% scaling, ena=1000790892, run=1000790892)

With:
$ task -e unhalted_core_cycles -e instructions_retired -e baclears noploop 1
noploop for 1 seconds

 2392703238 unhalted_core_cycles (0.00% scaling, ena=1000840809, run=1000840809)
 2389793744 instructions_retired (0.00% scaling, ena=1000840809, run=1000840809)
      47863 baclears (0.00% scaling, ena=1000840809, run=1000840809)

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 87eab4a..8d637b9 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -912,7 +912,8 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 		hwc->event_base	= 0;
 	} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
 		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
-		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0;
+		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0
+				+ (hwc->idx - X86_PMC_IDX_FIXED);
 	} else {
 		hwc->config_base = x86_pmu_config_addr(hwc->idx);
 		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
