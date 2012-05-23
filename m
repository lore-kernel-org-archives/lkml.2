Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab2EWIZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:25:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52097 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421Ab2EWIZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:25:46 -0400
Date: Wed, 23 May 2012 10:25:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "Luck, Tony" <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mce changes for v3.5
Message-ID: <20120523082539.GA16572@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mce-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mce-for-linus

   HEAD: 239e7bad43dadc43ccf4bbf51f798189fd2cc120 Merge tag 'amd-thresholding-fixes-for-3.5' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/mce

This tree updates/fixes MCE hardware support, it makes the APIC 
LVT thresholding interrupt optional because a subset of AMD F15h 
models don't support it.

 Thanks,

	Ingo

------------------>
Borislav Petkov (3):
      x86, MCE, AMD: Make APIC LVT thresholding interrupt optional
      x86, MCE, AMD: Hide interrupt_enable sysfs node
      x86, MCE, AMD: Disable error thresholding bank 4 on some models


 arch/x86/kernel/cpu/mcheck/mce.c     | 37 ++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 65 ++++++++++++++++++++++++++++--------
 2 files changed, 88 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d086a09..888fbf9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1423,6 +1423,43 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		 */
 		 if (c->x86 == 6 && banks > 0)
 			mce_banks[0].ctl = 0;
+
+		 /*
+		  * Turn off MC4_MISC thresholding banks on those models since
+		  * they're not supported there.
+		  */
+		 if (c->x86 == 0x15 &&
+		     (c->x86_model >= 0x10 && c->x86_model <= 0x1f)) {
+			 int i;
+			 u64 val, hwcr;
+			 bool need_toggle;
+			 u32 msrs[] = {
+				0x00000413, /* MC4_MISC0 */
+				0xc0000408, /* MC4_MISC1 */
+			 };
+
+			 rdmsrl(MSR_K7_HWCR, hwcr);
+
+			 /* McStatusWrEn has to be set */
+			 need_toggle = !(hwcr & BIT(18));
+
+			 if (need_toggle)
+				 wrmsrl(MSR_K7_HWCR, hwcr | BIT(18));
+
+			 for (i = 0; i < ARRAY_SIZE(msrs); i++) {
+				 rdmsrl(msrs[i], val);
+
+				 /* CntP bit set? */
+				 if (val & BIT(62)) {
+					 val &= ~BIT(62);
+					 wrmsrl(msrs[i], val);
+				 }
+			 }
+
+			 /* restore old settings */
+			 if (need_toggle)
+				 wrmsrl(MSR_K7_HWCR, hwcr);
+		 }
 	}
 
 	if (c->x86_vendor == X86_VENDOR_INTEL) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 99b5717..f4873a6 100644
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
 
@@ -390,10 +421,10 @@ RW_ATTR(threshold_limit);
 RW_ATTR(error_count);
 
 static struct attribute *default_attrs[] = {
-	&interrupt_enable.attr,
 	&threshold_limit.attr,
 	&error_count.attr,
-	NULL
+	NULL,	/* possibly interrupt_enable if supported, see below */
+	NULL,
 };
 
 #define to_block(k)	container_of(k, struct threshold_block, kobj)
@@ -467,8 +498,14 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 	b->cpu			= cpu;
 	b->address		= address;
 	b->interrupt_enable	= 0;
+	b->interrupt_capable	= lvt_interrupt_supported(bank, high);
 	b->threshold_limit	= THRESHOLD_MAX;
 
+	if (b->interrupt_capable)
+		threshold_ktype.default_attrs[2] = &interrupt_enable.attr;
+	else
+		threshold_ktype.default_attrs[2] = NULL;
+
 	INIT_LIST_HEAD(&b->miscj);
 
 	if (per_cpu(threshold_banks, cpu)[bank]->blocks) {
