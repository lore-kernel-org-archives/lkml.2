Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2HYR5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:57:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:36728 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab2HYR4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:56:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,311,1344236400"; 
   d="scan'208";a="184878900"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v8 11/12] x86/i387.c: Initialize thread xstate only on CPU0 only once
Date: Sat, 25 Aug 2012 10:41:27 -0700
Message-Id: <1345916488-8355-12-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1345916488-8355-1-git-send-email-fenghua.yu@intel.com>
References: <1345916488-8355-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

init_thread_xstate() is only called once to avoid overriding xstate_size during
boot time or during CPU hotplug.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/i387.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index f250431..e4c3a21 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -188,7 +188,11 @@ void __cpuinit fpu_init(void)
 		cr0 |= X86_CR0_EM;
 	write_cr0(cr0);
 
-	if (!smp_processor_id())
+	/*
+	 * init_thread_xstate is only called once to avoid overriding
+	 * xstate_size during boot time or during CPU hotplug.
+	 */
+	if (xstate_size == 0)
 		init_thread_xstate();
 
 	mxcsr_feature_mask_init();
-- 
1.7.2

