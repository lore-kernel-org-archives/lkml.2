Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab2HXVPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:15:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:7595 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab2HXVPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:15:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="scan'208";a="190967404"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 5/6] lguest, x86: handle guest TS bit for lazy/non-lazy fpu host models
Date: Fri, 24 Aug 2012 14:13:01 -0700
Message-Id: <1345842782-24175-6-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using unlazy_fpu() check if user_has_fpu() and set/clear
the host TS bits so that the lguest works fine with both the
lazy/non-lazy FPU host models with minimal changes.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/x86/core.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 39809035..4af12e1 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -203,8 +203,8 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * we set it now, so we can trap and pass that trap to the Guest if it
 	 * uses the FPU.
 	 */
-	if (cpu->ts)
-		unlazy_fpu(current);
+	if (cpu->ts && user_has_fpu())
+		stts();
 
 	/*
 	 * SYSENTER is an optimized way of doing system calls.  We can't allow
@@ -234,6 +234,10 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 if (boot_cpu_has(X86_FEATURE_SEP))
 		wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
 
+	/* Clear the host TS bit if it was set above. */
+	if (cpu->ts && user_has_fpu())
+		clts();
+
 	/*
 	 * If the Guest page faulted, then the cr2 register will tell us the
 	 * bad virtual address.  We have to grab this now, because once we
@@ -249,7 +253,7 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * a different CPU. So all the critical stuff should be done
 	 * before this.
 	 */
-	else if (cpu->regs->trapnum == 7)
+	else if (cpu->regs->trapnum == 7 && !user_has_fpu())
 		math_state_restore();
 }
 
-- 
1.7.6.5

