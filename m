Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2DYPwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:52:19 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:50990 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab2DYPwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:52:16 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/3] x86, MCE, AMD: Make APIC LVT thresholding interrupt optional
Date: Wed, 25 Apr 2012 17:52:01 +0200
Message-Id: <1335369123-23196-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1335369123-23196-1-git-send-email-bp@amd64.org>
References: <1335369123-23196-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Currently, the APIC LVT interrupt for error thresholding is implicitly
enabled. However, there are models in the F15h range which do not enable
it. Make the code machinery which sets up the APIC interrupt support
an optional setting and add an ->interrupt_capable member to the bank
representation mirroring that capability and enable the interrupt offset
programming only if it is true.

Simplify code and fixup comment style while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   56 ++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 99b57179f912..2c1d178be46e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -51,6 +51,7 @@ struct threshold_block {
 	unsigned int		cpu;
 	u32			address;
 	u16			interrupt_enable;
+	bool			interrupt_capable;
 	u16			threshold_limit;
 	struct kobject		kobj;
 	struct list_head	miscj;
@@ -83,6 +84,21 @@ struct thresh_restart {
 	u16			old_limit;
 };
 
+static bool lvt_interrupt_supported(unsigned int bank, u32 msr_high_bits)
+{
+	/*
+	 * bank 4 supports APIC LVT interrupts implicitly since forever.
+	 */
+	if (bank == 4)
+		return true;
+
+	/*
+	 * IntP: interrupt present; if this bit is set, the thresholding
+	 * bank can generate APIC LVT interrupts
+	 */
+	return msr_high_bits & BIT(28);
+}
+
 static int lvt_off_valid(struct threshold_block *b, int apic, u32 lo, u32 hi)
 {
 	int msr = (hi & MASK_LVTOFF_HI) >> 20;
@@ -104,8 +120,10 @@ static int lvt_off_valid(struct threshold_block *b, int apic, u32 lo, u32 hi)
 	return 1;
 };
 
-/* must be called with correct cpu affinity */
-/* Called via smp_call_function_single() */
+/*
+ * Called via smp_call_function_single(), must be called with correct
+ * cpu affinity.
+ */
 static void threshold_restart_bank(void *_tr)
 {
 	struct thresh_restart *tr = _tr;
@@ -128,6 +146,12 @@ static void threshold_restart_bank(void *_tr)
 		    (new_count & THRESHOLD_MAX);
 	}
 
+	/* clear IntType */
+	hi &= ~MASK_INT_TYPE_HI;
+
+	if (!tr->b->interrupt_capable)
+		goto done;
+
 	if (tr->set_lvt_off) {
 		if (lvt_off_valid(tr->b, tr->lvt_off, lo, hi)) {
 			/* set new lvt offset */
@@ -136,9 +160,10 @@ static void threshold_restart_bank(void *_tr)
 		}
 	}
 
-	tr->b->interrupt_enable ?
-	    (hi = (hi & ~MASK_INT_TYPE_HI) | INT_TYPE_APIC) :
-	    (hi &= ~MASK_INT_TYPE_HI);
+	if (tr->b->interrupt_enable)
+		hi |= INT_TYPE_APIC;
+
+ done:
 
 	hi |= MASK_COUNT_EN_HI;
 	wrmsr(tr->b->address, lo, hi);
@@ -202,14 +227,17 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			if (shared_bank[bank] && c->cpu_core_id)
 				break;
 
-			offset = setup_APIC_mce(offset,
-						(high & MASK_LVTOFF_HI) >> 20);
-
 			memset(&b, 0, sizeof(b));
-			b.cpu		= cpu;
-			b.bank		= bank;
-			b.block		= block;
-			b.address	= address;
+			b.cpu			= cpu;
+			b.bank			= bank;
+			b.block			= block;
+			b.address		= address;
+			b.interrupt_capable	= lvt_interrupt_supported(bank, high);
+
+			if (b.interrupt_capable) {
+				int new = (high & MASK_LVTOFF_HI) >> 20;
+				offset  = setup_APIC_mce(offset, new);
+			}
 
 			mce_threshold_block_init(&b, offset);
 			mce_threshold_vector = amd_threshold_interrupt;
@@ -309,6 +337,9 @@ store_interrupt_enable(struct threshold_block *b, const char *buf, size_t size)
 	struct thresh_restart tr;
 	unsigned long new;
 
+	if (!b->interrupt_capable)
+		return -EINVAL;
+
 	if (strict_strtoul(buf, 0, &new) < 0)
 		return -EINVAL;
 
@@ -467,6 +498,7 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 	b->cpu			= cpu;
 	b->address		= address;
 	b->interrupt_enable	= 0;
+	b->interrupt_capable	= lvt_interrupt_supported(bank, high);
 	b->threshold_limit	= THRESHOLD_MAX;
 
 	INIT_LIST_HEAD(&b->miscj);
-- 
1.7.9.3.362.g71319

