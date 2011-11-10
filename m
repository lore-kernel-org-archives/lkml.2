Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554Ab1KJAwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:52:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:1731 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab1KJAvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:51:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,486,1315206000"; 
   d="scan'208";a="35103432"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "H Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan van de Ven" <arjan.van.de.ven@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v3 6/7] x86/i387.c: Thread xstate is initialized only on BSP once
Date: Wed,  9 Nov 2011 16:34:16 -0800
Message-Id: <1320885257-16647-7-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1320885257-16647-1-git-send-email-fenghua.yu@intel.com>
References: <1320885257-16647-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

init_thread_xstate() is only called on BSP once to avoid to override
xstate_size.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/i387.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 739d859..f721a61 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -93,6 +93,7 @@ void __cpuinit fpu_init(void)
 {
 	unsigned long cr0;
 	unsigned long cr4_mask = 0;
+	static int once = 1;
 
 	if (cpu_has_fxsr)
 		cr4_mask |= X86_CR4_OSFXSR;
@@ -107,8 +108,14 @@ void __cpuinit fpu_init(void)
 		cr0 |= X86_CR0_EM;
 	write_cr0(cr0);
 
-	if (!smp_processor_id())
+	/*
+	 * init_thread_xstate is only called on BSP once to avoid to override
+	 * xstate_size.
+	 */
+	if (!smp_processor_id() && once) {
+		once = 0;
 		init_thread_xstate();
+	}
 
 	mxcsr_feature_mask_init();
 	/* clean state in init */
-- 
1.6.0.3

