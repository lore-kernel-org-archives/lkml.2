Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab0EGRsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:48:16 -0400
Received: from mga10.intel.com ([192.55.52.92]:2733 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757374Ab0EGRrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:47:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,349,1270450800"; 
   d="scan'208";a="796418410"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Feng Tang <feng.tang@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 6/8] x86/platform: add a wallclock_init func to x86_platforms ops
Date: Fri,  7 May 2010 10:41:46 -0700
Message-Id: <1273254108-3234-7-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Some wall clock devices use MMIO based HW register, this new function will
give them a chance to do some initialization work before their get/set_time
service get called.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/setup.c         |    2 ++
 arch/x86/kernel/x86_init.c      |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 519b543..be027a8 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -138,6 +138,7 @@ struct x86_cpuinit_ops {
 /**
  * struct x86_platform_ops - platform specific runtime functions
  * @calibrate_tsc:		calibrate TSC
+ * @wallclock_init:		init the wallclock device
  * @get_wallclock:		get time from HW clock like RTC etc.
  * @set_wallclock:		set time back to HW clock
  * @is_untracked_pat_range	exclude from PAT logic
@@ -145,6 +146,7 @@ struct x86_cpuinit_ops {
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
+	void (*wallclock_init)(void);
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long nowtime);
 	void (*iommu_shutdown)(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c4851ef..d001d8c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1050,6 +1050,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	x86_init.oem.banner();
 
+	x86_platform.wallclock_init();
+
 	mcheck_init();
 }
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 61a1e8c..ee00d76 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -24,6 +24,7 @@ void __init x86_init_uint_noop(unsigned int unused) { }
 void __init x86_init_pgd_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
+void wallclock_init_noop(void) { }
 
 /*
  * The platform setup functions are preset with the default functions
@@ -88,6 +89,7 @@ static void default_nmi_init(void) { };
 
 struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
+	.wallclock_init			= wallclock_init_noop,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
 	.iommu_shutdown			= iommu_shutdown_noop,
-- 
1.6.3.3

