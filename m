Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1GATWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 15:22:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:24763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab1GATWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 15:22:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,460,1304319600"; 
   d="scan'208";a="20665769"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] x86, intel: Use cpu_update for Atom errata check
Date: Fri,  1 Jul 2011 12:21:25 -0700
Message-Id: <1309548086-28215-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309548086-28215-1-git-send-email-andi@firstfloor.org>
References: <1309548086-28215-1-git-send-email-andi@firstfloor.org>
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
index ebedd27..6f75c45 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -55,17 +55,10 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
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

