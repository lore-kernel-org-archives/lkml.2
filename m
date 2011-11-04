Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab1KDWWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:22:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:32977 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab1KDWVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:21:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="71337204"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "H Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 5/9] x86/mtrr/main.c: Ask the first online CPU to save mtrr
Date: Fri,  4 Nov 2011 15:03:57 -0700
Message-Id: <1320444241-834-6-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
References: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Ask the first online CPU to save mtrr instead of asking BSP. BSP could be
offline when mtrr_save_state() is called.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 6b96110..e4c1a41 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -695,11 +695,16 @@ void mtrr_ap_init(void)
 }
 
 /**
- * Save current fixed-range MTRR state of the BSP
+ * Save current fixed-range MTRR state of the first cpu in cpu_online_mask.
  */
 void mtrr_save_state(void)
 {
-	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1);
+	int first_cpu;
+
+	get_online_cpus();
+	first_cpu = cpumask_first(cpu_online_mask);
+	smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
+	put_online_cpus();
 }
 
 void set_mtrr_aps_delayed_init(void)
-- 
1.6.0.3

