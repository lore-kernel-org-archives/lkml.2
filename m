Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935091Ab1JEQzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:55:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:52172 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935025Ab1JEQzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:55:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,492,1312182000"; 
   d="scan'208";a="23558367"
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
Subject: [PATCH 2/8] x86/mtrr/main.c: Ask the first online CPU to save mtrr
Date: Wed,  5 Oct 2011 09:39:13 -0700
Message-Id: <1317832759-10223-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Ask the first online CPU to save mtrr instead of asking BSP. BSP can be
offlined when mtrr_save_state() is called.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 6b96110..e18a4d3 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -695,11 +695,13 @@ void mtrr_ap_init(void)
 }
 
 /**
- * Save current fixed-range MTRR state of the BSP
+ * Save current fixed-range MTRR state of the first cpu in cpu_online_mask.
  */
 void mtrr_save_state(void)
 {
-	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1);
+	int first_cpu = cpumask_first(cpu_online_mask);
+
+	smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
 }
 
 void set_mtrr_aps_delayed_init(void)
-- 
1.6.0.3

