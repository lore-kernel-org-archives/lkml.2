Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab1DHAla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 20:41:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56420 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab1DHAl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 20:41:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6309"; a="84623558"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] msm: platsmp: actually read core count in get_core_count
Date: Thu,  7 Apr 2011 17:41:09 -0700
Message-Id: <1302223269-32047-1-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we just assumed there were CONFIG_NR_CPUS cpus present in
the system. Instead, figure out the number of cpus from the MIDR
register.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/platsmp.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 0f427bc..58c1d7b 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -18,6 +18,7 @@
 
 #include <asm/hardware/gic.h>
 #include <asm/cacheflush.h>
+#include <asm/cputype.h>
 #include <asm/mach-types.h>
 
 #include <mach/msm_iomap.h>
@@ -40,6 +41,12 @@ volatile int pen_release = -1;
 
 static DEFINE_SPINLOCK(boot_lock);
 
+static inline int get_core_count(void)
+{
+	/* 1 + the PART[1:0] field of MIDR */
+	return ((read_cpuid_id() >> 4) & 3) + 1;
+}
+
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
 	/* Configure edge-triggered PPIs */
@@ -147,9 +154,9 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
  */
 void __init smp_init_cpus(void)
 {
-	unsigned int i;
+	unsigned int i, ncores = get_core_count();
 
-	for (i = 0; i < NR_CPUS; i++)
+	for (i = 0; i < ncores; i++)
 		set_cpu_possible(i, true);
 }
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

