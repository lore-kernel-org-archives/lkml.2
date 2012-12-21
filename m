Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab2LUOre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:47:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:41824 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab2LUOq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:46:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,329,1355126400"; 
   d="scan'208";a="235197530"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Yinghai Lu" <yinghai@kernel.org>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v5 04/12] x86/common.c: load ucode in 64 bit or show loading ucode info in 32 bit on AP
Date: Thu, 20 Dec 2012 23:44:24 -0800
Message-Id: <1356075872-3054-5-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

In 64 bit, load ucode on AP in cpu_init().

In 32 bit, show ucode loading info on AP in cpu_init(). Microcode has been
loaded earlier before paging. Now it is safe to show the loading microcode
info on this AP.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d7fd246..d814772 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1220,6 +1220,12 @@ void __cpuinit cpu_init(void)
 	int cpu;
 	int i;
 
+	/*
+	 * Load microcode on this cpu if a valid microcode is available.
+	 * This is early microcode loading procedure.
+	 */
+	load_ucode_ap();
+
 	cpu = stack_smp_processor_id();
 	t = &per_cpu(init_tss, cpu);
 	oist = &per_cpu(orig_ist, cpu);
@@ -1311,6 +1317,8 @@ void __cpuinit cpu_init(void)
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 	struct thread_struct *thread = &curr->thread;
 
+	show_ucode_info_early();
+
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
 		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
 		for (;;)
-- 
1.8.0.1

