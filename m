Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab0JZGpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 02:45:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:46058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab0JZGpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 02:45:49 -0400
Date: Tue, 26 Oct 2010 06:45:22 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, tglx@linutronix.de, borislav.petkov@amd.com,
        mingo@elte.hu
In-Reply-To: <1288015419-29543-4-git-send-email-robert.richter@amd.com>
References: <1288015419-29543-4-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] mce, amd: Add helper functions to setup APIC
Message-ID: <tip-bbaff08dca3c34d0fb6b4c4051354184e33e3df8@git.kernel.org>
Git-Commit-ID: bbaff08dca3c34d0fb6b4c4051354184e33e3df8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 06:45:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbaff08dca3c34d0fb6b4c4051354184e33e3df8
Gitweb:     http://git.kernel.org/tip/bbaff08dca3c34d0fb6b4c4051354184e33e3df8
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 25 Oct 2010 16:03:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 Oct 2010 18:59:43 +0200

mce, amd: Add helper functions to setup APIC

This patch reworks and cleans up mce_amd_feature_init() by
introducing helper functions to setup and check the LVT offset.
It also fixes line endings in pr_err() calls.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1288015419-29543-4-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
