Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1EYTdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:33:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:6099 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab1EYTdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:33:16 -0400
X-ExtLoop1: 1
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        jbeulich@novell.com, fenghua.yu@intel.com, khali@linux-fr.org
Subject: [PATCH 3/3] coretemp: Get microcode revision from cpu_data v2
Date: Wed, 25 May 2011 12:32:28 -0700
Message-Id: <1306351948-23382-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306351948-23382-1-git-send-email-andi@firstfloor.org>
References: <1306351948-23382-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Now that the ucode revision is available in cpu_data remove
the existing code in coretemp.c to query it manually. Read the ucode
revision from cpu_data instead

v2: Fix misplaced variable init. Remove unused variables.
Cc: jbeulich@novell.com
Cc: fenghua.yu@intel.com
Cc: khali@linux-fr.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/hwmon/coretemp.c |   31 +++++--------------------------
 1 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 9577c43..eec29d6 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -324,15 +324,6 @@ static int get_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 	}
 }
 
-static void __devinit get_ucode_rev_on_cpu(void *edx)
-{
-	u32 eax;
-
-	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-	sync_core();
-	rdmsr(MSR_IA32_UCODE_REV, eax, *(u32 *)edx);
-}
-
 static int get_pkg_tjmax(unsigned int cpu, struct device *dev)
 {
 	int err;
@@ -425,29 +416,17 @@ static void update_ttarget(__u8 cpu_model, struct temp_data *tdata,
 static int chk_ucode_version(struct platform_device *pdev)
 {
 	struct cpuinfo_x86 *c = &cpu_data(pdev->id);
-	int err;
-	u32 edx;
 
 	/*
 	 * Check if we have problem with errata AE18 of Core processors:
 	 * Readings might stop update when processor visited too deep sleep,
 	 * fixed for stepping D0 (6EC).
 	 */
-	if (c->x86_model == 0xe && c->x86_mask < 0xc) {
-		/* check for microcode update */
-		err = smp_call_function_single(pdev->id, get_ucode_rev_on_cpu,
-					       &edx, 1);
-		if (err) {
-			dev_err(&pdev->dev,
-				"Cannot determine microcode revision of "
-				"CPU#%u (%d)!\n", pdev->id, err);
-			return -ENODEV;
-		} else if (edx < 0x39) {
-			dev_err(&pdev->dev,
-				"Errata AE18 not fixed, update BIOS or "
-				"microcode of the CPU!\n");
-			return -ENODEV;
-		}
+	if (c->x86_model == 0xe && c->x86_mask < 0xc && c->cpu_update < 0x39) {
+		dev_err(&pdev->dev,
+			"Errata AE18 not fixed, update BIOS or "
+			"microcode of the CPU!\n");
+		return -ENODEV;
 	}
 	return 0;
 }
-- 
1.7.4.4

