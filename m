Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935103Ab1JEQzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:55:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:9204 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935085Ab1JEQzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:55:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,492,1312182000"; 
   d="scan'208";a="23558368"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
        "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <lenb@kernel.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 3/8] x86, i387.c: thread xstate is initialized only on BSP once
Date: Wed,  5 Oct 2011 09:39:14 -0700
Message-Id: <1317832759-10223-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
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
index 739d859..de2b48a 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -93,6 +93,7 @@ void __cpuinit fpu_init(void)
 {
 	unsigned long cr0;
 	unsigned long cr4_mask = 0;
+	static int once;
 
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

