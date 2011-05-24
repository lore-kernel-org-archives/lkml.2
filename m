Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab1EXXEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:04:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:15964 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374Ab1EXXEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:04:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,264,1304319600"; 
   d="scan'208";a="8059164"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        jbeulich@novell.com, fenghua.yu@intel.com, khali@linux-fr.org
Subject: [PATCH 3/3] coretemp: Get microcode revision from cpu_data
Date: Tue, 24 May 2011 16:03:30 -0700
Message-Id: <1306278210-18285-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Now that the ucode revision is available in cpu_data remove
the existing code in coretemp.c to query it manually. Read the ucode
revision from cpu_data instead

Cc: jbeulich@novell.com
Cc: fenghua.yu@intel.com
Cc: khali@linux-fr.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/hwmon/coretemp.c |   29 +++++------------------------
 1 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 9577c43..aff3e2c 100644
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
@@ -433,21 +424,11 @@ static int chk_ucode_version(struct platform_device *pdev)
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
+	if (c->x86_model == 0xe && c->x86_mask < 0xc && c->x86_cpu_update < 0x39) {
+		dev_err(&pdev->dev,
+			"Errata AE18 not fixed, update BIOS or "
+			"microcode of the CPU!\n");
+		return -ENODEV;
 	}
 	return 0;
 }
-- 
1.7.4.4

