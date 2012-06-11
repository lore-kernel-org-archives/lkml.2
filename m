Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2FKVMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:12:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2FKVMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:12:49 -0400
Date: Mon, 11 Jun 2012 17:12:39 -0400
From: Dave Jones <davej@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, nzimmer@sgi.com, joe@perches.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] watchdog: Quiet down the boot messages
Message-ID: <20120611211239.GA12721@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Don Zickus <dzickus@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, nzimmer@sgi.com,
	joe@perches.com, Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1339445050-29941-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339445050-29941-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 04:04:10PM -0400, Don Zickus wrote:
 > A bunch of bugzillas have complained how noisy the nmi_watchdog is during
 > boot-up especially with its expected failure cases (like virt and bios
 > resource contention).
 > 
 > This is my attempt to quiet them down and keep it less confusing for the end
 > user.  What I did is print the message for cpu0 and save it for future
 > comparisons.  If future cpus have an identical message as cpu0, then don't
 > print the redundant info.  However, if a future cpu has a different message,
 > happily print that loudly.

Would anyone object to compressing these lines too ?
 
 >     ... version:                2
 >     ... bit width:              40
 >     ... generic registers:      2
 >     ... value mask:             000000ffffffffff
 >     ... max period:             000000007fffffff
 >     ... fixed-purpose events:   3
 >     ... event mask:             0000000700000003

That's a lot of wasted space, that could just as easily take up two lines
without losing readability.

untested, but something like the below patch..

	Dave


diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c4706cf..68e83ad 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1389,13 +1389,13 @@ static int __init init_hw_perf_events(void)
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
-	pr_info("... version:                %d\n",     x86_pmu.version);
-	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
-	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
-	pr_info("... value mask:             %016Lx\n", x86_pmu.cntval_mask);
-	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
-	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_counters_fixed);
-	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
+	pr_info("... version: %d ", x86_pmu.version);
+	pr_info("bit width: %d ", x86_pmu.cntval_bits);
+	pr_info("generic registers: %d\n", x86_pmu.num_counters);
+	pr_info("... value mask: %016Lx ", x86_pmu.cntval_mask);
+	pr_info("max period: %016Lx ", x86_pmu.max_period);
+	pr_info("fixed-purpose events: %d ", x86_pmu.num_counters_fixed);
+	pr_info("event mask: %016Lx\n", x86_pmu.intel_ctrl);
 
 	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	perf_cpu_notifier(x86_pmu_notifier);
