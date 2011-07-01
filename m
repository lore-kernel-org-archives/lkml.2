Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab1GAATg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:19:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:52635 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab1GAATf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:19:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,455,1304319600"; 
   d="scan'208";a="21224466"
Subject: [patch] x32, fpu: fix DNA exception during check_fpu()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 30 Jun 2011 17:19:32 -0700
Message-Id: <1309479572.2665.1372.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

Before check_fpu() is called, we have cr0.TS bit set and hence the floating
point code to check the FDIV bug was generating a DNA exception.

Use kernel_fpu_begin()/kernel_fpu_end() around the floating point
code to avoid this unnecessary device not available exception during
boot.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/cpu/bugs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 525514c..46674fb 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -62,6 +62,8 @@ static void __init check_fpu(void)
 		return;
 	}
 
+	kernel_fpu_begin();
+
 	/*
 	 * trap_init() enabled FXSR and company _before_ testing for FP
 	 * problems here.
@@ -80,6 +82,8 @@ static void __init check_fpu(void)
 		: "=m" (*&fdiv_bug)
 		: "m" (*&x), "m" (*&y));
 
+	kernel_fpu_end();
+
 	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
 		printk(KERN_WARNING "Hmm, FPU with FDIV bug.\n");


