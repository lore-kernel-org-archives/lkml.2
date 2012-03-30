Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab2C3KT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:19:58 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52238 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab2C3KSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:18:53 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Robert Lee <rob.lee@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 11/76] ARM: shmobile: Consolidate time keeping and irq enable
Date: Fri, 30 Mar 2012 06:13:14 -0400
Message-id: <ee807dd89c0003a5cc0ec961132cd83542e5c30c.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Lee <rob.lee@linaro.org>

Enable core cpuidle timekeeping and irq enabling and remove that
handling from this code.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Jean Pihet <j-pihet@ti.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/arm/mach-shmobile/cpuidle.c |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-shmobile/cpuidle.c b/arch/arm/mach-shmobile/cpuidle.c
index 1b23342..ca23b20 100644
--- a/arch/arm/mach-shmobile/cpuidle.c
+++ b/arch/arm/mach-shmobile/cpuidle.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <asm/system.h>
+#include <asm/cpuidle.h>
 #include <asm/io.h>
 
 static void shmobile_enter_wfi(void)
@@ -29,37 +30,19 @@ static int shmobile_cpuidle_enter(struct cpuidle_device *dev,
 				  struct cpuidle_driver *drv,
 				  int index)
 {
-	ktime_t before, after;
-
-	before = ktime_get();
-
-	local_irq_disable();
-	local_fiq_disable();
-
 	shmobile_cpuidle_modes[index]();
 
-	local_irq_enable();
-	local_fiq_enable();
-
-	after = ktime_get();
-	dev->last_residency = ktime_to_ns(ktime_sub(after, before)) >> 10;
-
 	return index;
 }
 
 static struct cpuidle_device shmobile_cpuidle_dev;
 static struct cpuidle_driver shmobile_cpuidle_driver = {
-	.name =		"shmobile_cpuidle",
-	.owner =	THIS_MODULE,
-	.states[0] = {
-		.name = "C1",
-		.desc = "WFI",
-		.exit_latency = 1,
-		.target_residency = 1 * 2,
-		.flags = CPUIDLE_FLAG_TIME_VALID,
-	},
-	.safe_state_index = 0, /* C1 */
-	.state_count = 1,
+	.name			= "shmobile_cpuidle",
+	.owner			= THIS_MODULE,
+	.en_core_tk_irqen	= 1,
+	.states[0]		= ARM_CPUIDLE_WFI_STATE,
+	.safe_state_index	= 0, /* C1 */
+	.state_count		= 1,
 };
 
 void (*shmobile_cpuidle_setup)(struct cpuidle_driver *drv);
-- 
1.7.10.rc2.19.gfae9d

