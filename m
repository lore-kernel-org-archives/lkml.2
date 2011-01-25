Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1AYOxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:53:03 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47504 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1AYOxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:53:01 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] x86/platform: add a wallclock_init func to x86_platforms
 ops
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Jan 2011 14:26:16 +0000
Message-ID: <20110125142613.9886.69516.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Some wall clock devices use MMIO based HW register, this new function will
give them a chance to do some initialization work before their get/set_time
service get called.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/setup.c         |    2 ++
 arch/x86/kernel/x86_init.c      |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 64642ad..f7fa2e7 100644
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
@@ -146,6 +147,7 @@ struct x86_cpuinit_ops {
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
+	void (*wallclock_init)(void);
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long nowtime);
 	void (*iommu_shutdown)(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3cfe26..c204fd5 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1066,6 +1066,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	x86_init.oem.banner();
 
+	x86_platform.wallclock_init();
+
 	mcheck_init();
 
 	local_irq_save(flags);
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ceb2911..fc3f0e6 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -27,6 +27,7 @@ void __init x86_init_uint_noop(unsigned int unused) { }
 void __init x86_init_pgd_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
+void wallclock_init_noop(void) { }
 
 /*
  * The platform setup functions are preset with the default functions
@@ -92,6 +93,7 @@ static int default_i8042_detect(void) { return 1; };
 
 struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
+	.wallclock_init			= wallclock_init_noop,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
 	.iommu_shutdown			= iommu_shutdown_noop,

