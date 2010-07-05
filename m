Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab0GEOo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 10:44:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:60744 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab0GEOo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 10:44:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,540,1272870000"; 
   d="scan'208";a="296676676"
From: feng.tang@intel.com
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       hpa@zytor.com, jacob.jun.pan@intel.com, dtor@mail.ru,
       randy.dunlap@oracle.com
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH v2 1/5] x86: add i8042 pre-detection hook to x86_platform_ops
Date: Mon,  5 Jul 2010 23:03:18 +0800
Message-Id: <1278342202-10973-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
References: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Some x86 platforms like intel MID platforms don't have i8042 controllers,
and i8042 driver's probe to some legacy IO ports may hang the MID
processor. With this hook, i8042 driver can runtime check and skip the
probe when the pretection fail which also saves some probe time

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/x86_init.c      |    4 +++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 519b543..baa579c 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -142,6 +142,7 @@ struct x86_cpuinit_ops {
  * @set_wallclock:		set time back to HW clock
  * @is_untracked_pat_range	exclude from PAT logic
  * @nmi_init			enable NMI on cpus
+ * @i8042_detect		pre-detect if i8042 controller exists
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
@@ -150,6 +151,7 @@ struct x86_platform_ops {
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
 	void (*nmi_init)(void);
+	int (*i8042_detect)(void);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 61a1e8c..1e0c863 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -85,6 +85,7 @@ struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 };
 
 static void default_nmi_init(void) { };
+static int default_i8042_detect(void) { return 1; };
 
 struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
@@ -92,5 +93,6 @@ struct x86_platform_ops x86_platform = {
 	.set_wallclock			= mach_set_rtc_mmss,
 	.iommu_shutdown			= iommu_shutdown_noop,
 	.is_untracked_pat_range		= is_ISA_range,
-	.nmi_init			= default_nmi_init
+	.nmi_init			= default_nmi_init,
+	.i8042_detect			= default_i8042_detect
 };
-- 
1.7.0.4

