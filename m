Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0JYOjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:39:39 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:16112 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755578Ab0JYOji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:39:38 -0400
X-SpamScore: -2
X-BigFish: VS-2(zzbb2cKzz1202hzz8275bhz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0LAUOPR-02-CXL-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/5] mce, amd: Add helper functions to setup APIC
Date: Mon, 25 Oct 2010 16:03:37 +0200
Message-ID: <1288015419-29543-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1288015419-29543-1-git-send-email-robert.richter@amd.com>
References: <1288015419-29543-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reworks and cleans up mce_amd_feature_init() by introducing
helper functions to setup and check the LVT offset. It also fixes line
endings in pr_err() calls.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   67 +++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index eb771b9..e316684 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -31,8 +31,6 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 
-#define PFX               "mce_threshold: "
-#define VERSION           "version 1.1.1"
 #define NR_BANKS          6
 #define NR_BLOCKS         9
 #define THRESHOLD_MAX     0xFFF
@@ -88,6 +86,27 @@ struct thresh_restart {
 	u16			old_limit;
 };
 
+static int lvt_off_valid(struct threshold_block *b, int apic, u32 lo, u32 hi)
+{
+	int msr = (hi & MASK_LVTOFF_HI) >> 20;
+
+	if (apic < 0) {
+		pr_err(FW_BUG "cpu %d, failed to setup threshold interrupt "
+		       "for bank %d, block %d (MSR%08X=0x%x%08x)\n", b->cpu,
+		       b->bank, b->block, b->address, hi, lo);
+		return 0;
+	}
+
+	if (apic != msr) {
+		pr_err(FW_BUG "cpu %d, invalid threshold interrupt offset %d "
+		       "for bank %d, block %d (MSR%08X=0x%x%08x)\n",
+		       b->cpu, apic, b->bank, b->block, b->address, hi, lo);
+		return 0;
+	}
+
+	return 1;
+};
+
 /* must be called with correct cpu affinity */
 /* Called via smp_call_function_single() */
 static void threshold_restart_bank(void *_tr)
@@ -113,9 +132,11 @@ static void threshold_restart_bank(void *_tr)
 	}
 
 	if (tr->set_lvt_off) {
-		/* set new lvt offset */
-		hi &= ~MASK_LVTOFF_HI;
-		hi |= tr->lvt_off << 20;
+		if (lvt_off_valid(tr->b, tr->lvt_off, lo, hi)) {
+			/* set new lvt offset */
+			hi &= ~MASK_LVTOFF_HI;
+			hi |= tr->lvt_off << 20;
+		}
 	}
 
 	tr->b->interrupt_enable ?
@@ -138,6 +159,15 @@ static void mce_threshold_block_init(struct threshold_block *b, int offset)
 	threshold_restart_bank(&tr);
 };
 
+static int setup_APIC_mce(int reserved, int new)
+{
+	if (reserved < 0 && !setup_APIC_eilvt(new, THRESHOLD_APIC_VECTOR,
+					      APIC_EILVT_MSG_FIX, 0))
+		return new;
+
+	return reserved;
+}
+
 /* cpu init entry point, called from mce.c with preempt off */
 void mce_amd_feature_init(struct cpuinfo_x86 *c)
 {
@@ -145,8 +175,7 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 	unsigned int cpu = smp_processor_id();
 	u32 low = 0, high = 0, address = 0;
 	unsigned int bank, block;
-	int lvt_off = -1;
-	u8 offset;
+	int offset = -1;
 
 	for (bank = 0; bank < NR_BANKS; ++bank) {
 		for (block = 0; block < NR_BLOCKS; ++block) {
@@ -177,28 +206,8 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			if (shared_bank[bank] && c->cpu_core_id)
 				break;
 #endif
-			offset = (high & MASK_LVTOFF_HI) >> 20;
-			if (lvt_off < 0) {
-				if (setup_APIC_eilvt(offset,
-						     THRESHOLD_APIC_VECTOR,
-						     APIC_EILVT_MSG_FIX, 0)) {
-					pr_err(FW_BUG "cpu %d, failed to "
-					       "setup threshold interrupt "
-					       "for bank %d, block %d "
-					       "(MSR%08X=0x%x%08x)",
-					       smp_processor_id(), bank, block,
-					       address, high, low);
-					continue;
-				}
-				lvt_off = offset;
-			} else if (lvt_off != offset) {
-				pr_err(FW_BUG "cpu %d, invalid threshold "
-				       "interrupt offset %d for bank %d,"
-				       "block %d (MSR%08X=0x%x%08x)",
-				       smp_processor_id(), lvt_off, bank,
-				       block, address, high, low);
-				continue;
-			}
+			offset = setup_APIC_mce(offset,
+						(high & MASK_LVTOFF_HI) >> 20);
 
 			memset(&b, 0, sizeof(b));
 			b.cpu		= cpu;
-- 
1.7.3.1


