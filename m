Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab1I1XT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:19:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:11959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab1I1XT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 19:19:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="56943768"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] x86, intel: Use cpu_update for Atom errata check
Date: Wed, 28 Sep 2011 16:19:52 -0700
Message-Id: <1317251993-5030-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1317251993-5030-1-git-send-email-andi@firstfloor.org>
References: <1317251993-5030-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Now that the cpu update level is available the Atom PSE errata
check can use it directly without reading the MSR again.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 6b178c8..aef3bfc 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -64,17 +64,10 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 * need the microcode to have already been loaded... so if it is
 	 * not, recommend a BIOS update and disable large pages.
 	 */
-	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2) {
-		u32 ucode, junk;
-
-		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-		sync_core();
-		rdmsr(MSR_IA32_UCODE_REV, junk, ucode);
-
-		if (ucode < 0x20e) {
-			printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
-			clear_cpu_cap(c, X86_FEATURE_PSE);
-		}
+	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2 &&
+	    c->microcode < 0x20e) {
+		printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
+		clear_cpu_cap(c, X86_FEATURE_PSE);
 	}
 
 #ifdef CONFIG_X86_64
-- 
1.7.4.4

