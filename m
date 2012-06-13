Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2FMUVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:21:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:31269 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab2FMUUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:20:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="152762572"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, eranian@google.com, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] x86: Detect model/family mismatches for common microcode revision
Date: Wed, 13 Jun 2012 13:20:42 -0700
Message-Id: <1339618842-26636-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When the model/family don't match force the common microcode to zero.
On such configurations there is no sane way to check for microcode
revisions, so don't even try.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cfc50e0..9642929 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1183,12 +1183,26 @@ __cpuinit void boot_update_min_microcode(struct cpuinfo_x86 *c)
 	if (!boot_min_microcode) {
 		boot_min_microcode = c->microcode;
 		boot_cpu_data.microcode = c->microcode;
-	} else if (c->microcode < boot_min_microcode) {
-		pr_warn("CPU %d has lower microcode revision %x at boot than boot CPU (%x)\n",
-			smp_processor_id(), 
-			c->microcode,
-			boot_min_microcode);
-		boot_cpu_data.microcode = c->microcode;
+	} else {
+		if (c->microcode < boot_min_microcode) {
+			pr_warn("CPU %d has lower microcode revision %x at boot than boot CPU (%x)\n",
+				smp_processor_id(), 
+				c->microcode,
+				boot_min_microcode);
+			boot_cpu_data.microcode = c->microcode;
+		}
+		/* Assume steppings have common microcode version numbers */
+		if (c->x86 != boot_cpu_data.x86 || 
+		    c->x86_model != boot_cpu_data.x86_model) {
+			pr_warn("CPU %d model mismatch to boot CPU: %d,%d vs %d,%d\n",
+				smp_processor_id(),
+				boot_cpu_data.x86,
+				boot_cpu_data.x86_model,
+				c->x86,
+				c->x86_model);
+			/* Disable any common microcode checks. */
+			boot_cpu_data.microcode = 0;
+		}
 	}
 }
 
-- 
1.7.7.6

