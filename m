Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2HIIwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 04:52:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab2HIIwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 04:52:41 -0400
Date: Thu, 9 Aug 2012 11:52:34 +0300
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        dsahern@gmail.com, peterz@infradead.org, mingo@kernel.org
Subject: [PATCH] perf/x86: disable PEBS on a guest entry.
Message-ID: <20120809085234.GI3341@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PMU counter has PEBS enabled it is not enough to disable counter
on a guest entry since PEBS memory write can overshoot guest entry
and corrupt guest memory. Disabling PEBS during guest entry solves
the problem.

Tested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 7a8b9d0..7268fd8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1444,8 +1444,16 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
 	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
+	/*
+	 * If PMU counter has PEBS enabled it is not enough to disable counter
+	 * on a guest entry since PEBS memory write can overshoot guest entry
+	 * and corrupt guest memory. Disabling PEBS solves the problem.
+	 */
+	arr[1].msr = MSR_IA32_PEBS_ENABLE;
+	arr[1].host = cpuc->pebs_enabled;
+	arr[1].guest = 0;
 
-	*nr = 1;
+	*nr = 2;
 	return arr;
 }
 
--
			Gleb.
