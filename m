Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab2AKRZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:25:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:28779 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933623Ab2AKRYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:24:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106055477"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan van de Ven" <arjan.van.de.ven@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v5 10/12] x86/mtrr/main.c: Ask the first online CPU to save mtrr
Date: Wed, 11 Jan 2012 09:04:51 -0800
Message-Id: <1326301493-28760-11-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
References: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
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

