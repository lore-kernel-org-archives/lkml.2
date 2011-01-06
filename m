Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1AFJxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:53:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42584 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1AFJxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:53:09 -0500
Date: Thu, 6 Jan 2011 10:52:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mce changes for v2.6.38
Message-ID: <20110106095251.GA18480@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mce-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mce-for-linus

 Thanks,

	Ingo

------------------>
Robert Richter (5):
      mce, amd: Implement mce_threshold_block_init() helper function
      mce, amd: Shorten local variables mci_misc_{hi,lo}
      mce, amd: Add helper functions to setup APIC
      mce, amd: Remove goto in threshold_create_device()
      apic, amd: Make firmware bug messages more meaningful


 arch/x86/kernel/apic/apic.c          |   15 ++--
 arch/x86/kernel/cpu/mcheck/mce_amd.c |  135 +++++++++++++++++++---------------
 arch/x86/oprofile/op_model_amd.c     |    1 +
 3 files changed, 86 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 850657d..cb13048 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -433,17 +433,18 @@ int setup_APIC_eilvt(u8 offset, u8 vector, u8 msg_type, u8 mask)
 	reserved = reserve_eilvt_offset(offset, new);
 
 	if (reserved != new) {
-		pr_err(FW_BUG "cpu %d, try to setup vector 0x%x, but "
-		       "vector 0x%x was already reserved by another core, "
-		       "APIC%lX=0x%x\n",
-		       smp_processor_id(), new, reserved, reg, old);
+		pr_err(FW_BUG "cpu %d, try to use APIC%lX (LVT offset %d) for "
+		       "vector 0x%x, but the register is already in use for "
+		       "vector 0x%x on another cpu\n",
+		       smp_processor_id(), reg, offset, new, reserved);
 		return -EINVAL;
 	}
 
 	if (!eilvt_entry_is_changeable(old, new)) {
-		pr_err(FW_BUG "cpu %d, try to setup vector 0x%x but "
-		       "register already in use, APIC%lX=0x%x\n",
-		       smp_processor_id(), new, reg, old);
+		pr_err(FW_BUG "cpu %d, try to use APIC%lX (LVT offset %d) for "
+		       "vector 0x%x, but the register is already in use for "
+		       "vector 0x%x on this cpu\n",
+		       smp_processor_id(), reg, offset, new, old);
 		return -EBUSY;
 	}
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 80c4823..5bf2fac 100644
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
@@ -59,12 +57,6 @@ struct threshold_block {
 	struct list_head	miscj;
 };
 
-/* defaults used early on boot */
-static struct threshold_block threshold_defaults = {
-	.interrupt_enable	= 0,
-	.threshold_limit	= THRESHOLD_MAX,
-};
-
 struct threshold_bank {
 	struct kobject		*kobj;
 	struct threshold_block	*blocks;
@@ -89,50 +81,101 @@ static void amd_threshold_interrupt(void);
 struct thresh_restart {
 	struct threshold_block	*b;
 	int			reset;
+	int			set_lvt_off;
+	int			lvt_off;
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
 {
 	struct thresh_restart *tr = _tr;
-	u32 mci_misc_hi, mci_misc_lo;
+	u32 hi, lo;
 
-	rdmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
+	rdmsr(tr->b->address, lo, hi);
 
-	if (tr->b->threshold_limit < (mci_misc_hi & THRESHOLD_MAX))
+	if (tr->b->threshold_limit < (hi & THRESHOLD_MAX))
 		tr->reset = 1;	/* limit cannot be lower than err count */
 
 	if (tr->reset) {		/* reset err count and overflow bit */
-		mci_misc_hi =
-		    (mci_misc_hi & ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI)) |
+		hi =
+		    (hi & ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI)) |
 		    (THRESHOLD_MAX - tr->b->threshold_limit);
 	} else if (tr->old_limit) {	/* change limit w/o reset */
-		int new_count = (mci_misc_hi & THRESHOLD_MAX) +
+		int new_count = (hi & THRESHOLD_MAX) +
 		    (tr->old_limit - tr->b->threshold_limit);
 
-		mci_misc_hi = (mci_misc_hi & ~MASK_ERR_COUNT_HI) |
+		hi = (hi & ~MASK_ERR_COUNT_HI) |
 		    (new_count & THRESHOLD_MAX);
 	}
 
+	if (tr->set_lvt_off) {
+		if (lvt_off_valid(tr->b, tr->lvt_off, lo, hi)) {
+			/* set new lvt offset */
+			hi &= ~MASK_LVTOFF_HI;
+			hi |= tr->lvt_off << 20;
+		}
+	}
+
 	tr->b->interrupt_enable ?
-	    (mci_misc_hi = (mci_misc_hi & ~MASK_INT_TYPE_HI) | INT_TYPE_APIC) :
-	    (mci_misc_hi &= ~MASK_INT_TYPE_HI);
+	    (hi = (hi & ~MASK_INT_TYPE_HI) | INT_TYPE_APIC) :
+	    (hi &= ~MASK_INT_TYPE_HI);
 
-	mci_misc_hi |= MASK_COUNT_EN_HI;
-	wrmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
+	hi |= MASK_COUNT_EN_HI;
+	wrmsr(tr->b->address, lo, hi);
+}
+
+static void mce_threshold_block_init(struct threshold_block *b, int offset)
+{
+	struct thresh_restart tr = {
+		.b			= b,
+		.set_lvt_off		= 1,
+		.lvt_off		= offset,
+	};
+
+	b->threshold_limit		= THRESHOLD_MAX;
+	threshold_restart_bank(&tr);
+};
+
+static int setup_APIC_mce(int reserved, int new)
+{
+	if (reserved < 0 && !setup_APIC_eilvt(new, THRESHOLD_APIC_VECTOR,
+					      APIC_EILVT_MSG_FIX, 0))
+		return new;
+
+	return reserved;
 }
 
 /* cpu init entry point, called from mce.c with preempt off */
 void mce_amd_feature_init(struct cpuinfo_x86 *c)
 {
+	struct threshold_block b;
 	unsigned int cpu = smp_processor_id();
 	u32 low = 0, high = 0, address = 0;
 	unsigned int bank, block;
-	struct thresh_restart tr;
-	int lvt_off = -1;
-	u8 offset;
+	int offset = -1;
 
 	for (bank = 0; bank < NR_BANKS; ++bank) {
 		for (block = 0; block < NR_BLOCKS; ++block) {
@@ -163,39 +206,16 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
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
-
-			high &= ~MASK_LVTOFF_HI;
-			high |= lvt_off << 20;
-			wrmsr(address, low, high);
+			offset = setup_APIC_mce(offset,
+						(high & MASK_LVTOFF_HI) >> 20);
 
-			threshold_defaults.address = address;
-			tr.b = &threshold_defaults;
-			tr.reset = 0;
-			tr.old_limit = 0;
-			threshold_restart_bank(&tr);
+			memset(&b, 0, sizeof(b));
+			b.cpu		= cpu;
+			b.bank		= bank;
+			b.block		= block;
+			b.address	= address;
 
+			mce_threshold_block_init(&b, offset);
 			mce_threshold_vector = amd_threshold_interrupt;
 		}
 	}
@@ -298,9 +318,8 @@ store_interrupt_enable(struct threshold_block *b, const char *buf, size_t size)
 
 	b->interrupt_enable = !!new;
 
+	memset(&tr, 0, sizeof(tr));
 	tr.b		= b;
-	tr.reset	= 0;
-	tr.old_limit	= 0;
 
 	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 
@@ -321,10 +340,10 @@ store_threshold_limit(struct threshold_block *b, const char *buf, size_t size)
 	if (new < 1)
 		new = 1;
 
+	memset(&tr, 0, sizeof(tr));
 	tr.old_limit = b->threshold_limit;
 	b->threshold_limit = new;
 	tr.b = b;
-	tr.reset = 0;
 
 	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 
@@ -603,9 +622,9 @@ static __cpuinit int threshold_create_device(unsigned int cpu)
 			continue;
 		err = threshold_create_bank(cpu, bank);
 		if (err)
-			goto out;
+			return err;
 	}
-out:
+
 	return err;
 }
 
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 42fb46f..08de254 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -566,6 +566,7 @@ static int force_ibs_eilvt_setup(void)
 		ret = setup_ibs_ctl(i);
 		if (ret)
 			return ret;
+		pr_err(FW_BUG "using offset %d for IBS interrupts\n", i);
 		return 0;
 	}
 
