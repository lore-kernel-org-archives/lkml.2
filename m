Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab2FNX6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:58:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2FNX6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:58:31 -0400
Message-Id: <20120614235645.580470128@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [ 15/20] x86, MCE, AMD: Make APIC LVT thresholding interrupt optional
In-Reply-To: <20120614235648.GA6552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit f227d4306cf30e1d5b6f231e8ef9006c34f3d186 upstream.

Currently, the APIC LVT interrupt for error thresholding is implicitly
enabled. However, there are models in the F15h range which do not enable
it. Make the code machinery which sets up the APIC interrupt support
an optional setting and add an ->interrupt_capable member to the bank
representation mirroring that capability and enable the interrupt offset
programming only if it is true.

Simplify code and fixup comment style while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>


---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   55 ++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -52,6 +52,7 @@ struct threshold_block {
 	unsigned int		cpu;
 	u32			address;
 	u16			interrupt_enable;
+	bool			interrupt_capable;
 	u16			threshold_limit;
 	struct kobject		kobj;
 	struct list_head	miscj;
@@ -86,6 +87,21 @@ struct thresh_restart {
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
@@ -107,8 +123,10 @@ static int lvt_off_valid(struct threshol
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
@@ -131,6 +149,12 @@ static void threshold_restart_bank(void
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
@@ -139,9 +163,10 @@ static void threshold_restart_bank(void
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
@@ -206,14 +231,18 @@ void mce_amd_feature_init(struct cpuinfo
 			if (shared_bank[bank] && c->cpu_core_id)
 				break;
 #endif
-			offset = setup_APIC_mce(offset,
-						(high & MASK_LVTOFF_HI) >> 20);
 
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
@@ -313,6 +342,9 @@ store_interrupt_enable(struct threshold_
 	struct thresh_restart tr;
 	unsigned long new;
 
+	if (!b->interrupt_capable)
+		return -EINVAL;
+
 	if (strict_strtoul(buf, 0, &new) < 0)
 		return -EINVAL;
 
@@ -471,6 +503,7 @@ static __cpuinit int allocate_threshold_
 	b->cpu			= cpu;
 	b->address		= address;
 	b->interrupt_enable	= 0;
+	b->interrupt_capable	= lvt_interrupt_supported(bank, high);
 	b->threshold_limit	= THRESHOLD_MAX;
 
 	INIT_LIST_HEAD(&b->miscj);


