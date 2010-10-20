Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0JTFCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:02:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:37212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0JTFCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:02:40 -0400
Date: Wed, 20 Oct 2010 05:01:54 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1286360874-1471-3-git-send-email-robert.richter@amd.com>
References: <1286360874-1471-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] apic, x86: Use BIOS settings for IBS and MCE threshold interrupt LVT offsets
Message-ID: <tip-27afdf2008da0b8878a73e32e4eb12381b84e224@git.kernel.org>
Git-Commit-ID: 27afdf2008da0b8878a73e32e4eb12381b84e224
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 05:01:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27afdf2008da0b8878a73e32e4eb12381b84e224
Gitweb:     http://git.kernel.org/tip/27afdf2008da0b8878a73e32e4eb12381b84e224
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 6 Oct 2010 12:27:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 Oct 2010 04:42:13 +0200

apic, x86: Use BIOS settings for IBS and MCE threshold interrupt LVT offsets

We want the BIOS to setup the EILVT APIC registers. The offsets
were hardcoded and BIOS settings were overwritten by the OS.
Now, the subsystems for MCE threshold and IBS determine the LVT
offset from the registers the BIOS has setup. If the BIOS setup
is buggy on a family 10h system, a workaround enables IBS. If
the OS determines an invalid register setup, a "[Firmware Bug]:
" error message is reported.

We need this change also for upcomming cpu families.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1286360874-1471-3-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h          |    4 +-
 arch/x86/kernel/apic/apic.c          |   19 +----
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   27 ++++++-
 arch/x86/oprofile/op_model_amd.c     |  145 +++++++++++++++++++++++++++++----
 4 files changed, 154 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1fa03e0..286de34 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -252,9 +252,7 @@ static inline int apic_is_clustered_box(void)
 }
 #endif
 
-extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
-extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
-
+extern int setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask);
 
 #else /* !CONFIG_X86_LOCAL_APIC */
 static inline void lapic_shutdown(void) { }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2bfeafd..850657d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -390,9 +390,6 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
  * necessarily a BIOS bug.
  */
 
-#define APIC_EILVT_LVTOFF_MCE 0
-#define APIC_EILVT_LVTOFF_IBS 1
-
 static atomic_t eilvt_offsets[APIC_EILVT_NR_MAX];
 
 static inline int eilvt_entry_is_changeable(unsigned int old, unsigned int new)
@@ -426,7 +423,7 @@ static unsigned int reserve_eilvt_offset(int offset, unsigned int new)
  * enables the vector. See also the BKDGs.
  */
 
-static int setup_APIC_eilvt(u8 offset, u8 vector, u8 msg_type, u8 mask)
+int setup_APIC_eilvt(u8 offset, u8 vector, u8 msg_type, u8 mask)
 {
 	unsigned long reg = APIC_EILVTn(offset);
 	unsigned int new, old, reserved;
@@ -454,19 +451,7 @@ static int setup_APIC_eilvt(u8 offset, u8 vector, u8 msg_type, u8 mask)
 
 	return 0;
 }
-
-u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
-{
-	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
-	return APIC_EILVT_LVTOFF_MCE;
-}
-
-u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
-{
-	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
-	return APIC_EILVT_LVTOFF_IBS;
-}
-EXPORT_SYMBOL_GPL(setup_APIC_eilvt_ibs);
+EXPORT_SYMBOL_GPL(setup_APIC_eilvt);
 
 /*
  * Program the next event, relative to now
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 39aaee5..80c4823 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -131,7 +131,8 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 	u32 low = 0, high = 0, address = 0;
 	unsigned int bank, block;
 	struct thresh_restart tr;
-	u8 lvt_off;
+	int lvt_off = -1;
+	u8 offset;
 
 	for (bank = 0; bank < NR_BANKS; ++bank) {
 		for (block = 0; block < NR_BLOCKS; ++block) {
@@ -162,8 +163,28 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			if (shared_bank[bank] && c->cpu_core_id)
 				break;
 #endif
-			lvt_off = setup_APIC_eilvt_mce(THRESHOLD_APIC_VECTOR,
-						       APIC_EILVT_MSG_FIX, 0);
+			offset = (high & MASK_LVTOFF_HI) >> 20;
+			if (lvt_off < 0) {
+				if (setup_APIC_eilvt(offset,
+						     THRESHOLD_APIC_VECTOR,
+						     APIC_EILVT_MSG_FIX, 0)) {
+					pr_err(FW_BUG "cpu %d, failed to "
+					       "setup threshold interrupt "
+					       "for bank %d, block %d "
+					       "(MSR%08X=0x%x%08x)",
+					       smp_processor_id(), bank, block,
+					       address, high, low);
+					continue;
+				}
+				lvt_off = offset;
+			} else if (lvt_off != offset) {
+				pr_err(FW_BUG "cpu %d, invalid threshold "
+				       "interrupt offset %d for bank %d,"
+				       "block %d (MSR%08X=0x%x%08x)",
+				       smp_processor_id(), lvt_off, bank,
+				       block, address, high, low);
+				continue;
+			}
 
 			high &= ~MASK_LVTOFF_HI;
 			high |= lvt_off << 20;
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index b67a6b5..42fb46f 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -64,15 +64,22 @@ static u64 ibs_op_ctl;
  * IBS cpuid feature detection
  */
 
-#define IBS_CPUID_FEATURES      0x8000001b
+#define IBS_CPUID_FEATURES		0x8000001b
 
 /*
  * Same bit mask as for IBS cpuid feature flags (Fn8000_001B_EAX), but
  * bit 0 is used to indicate the existence of IBS.
  */
-#define IBS_CAPS_AVAIL			(1LL<<0)
-#define IBS_CAPS_RDWROPCNT		(1LL<<3)
-#define IBS_CAPS_OPCNT			(1LL<<4)
+#define IBS_CAPS_AVAIL			(1U<<0)
+#define IBS_CAPS_RDWROPCNT		(1U<<3)
+#define IBS_CAPS_OPCNT			(1U<<4)
+
+/*
+ * IBS APIC setup
+ */
+#define IBSCTL				0x1cc
+#define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
+#define IBSCTL_LVT_OFFSET_MASK		0x0F
 
 /*
  * IBS randomization macros
@@ -266,6 +273,74 @@ static void op_amd_stop_ibs(void)
 		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
+static inline int eilvt_is_available(int offset)
+{
+	/* check if we may assign a vector */
+	return !setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 1);
+}
+
+static inline int ibs_eilvt_valid(void)
+{
+	u64 val;
+	int offset;
+
+	rdmsrl(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
+		pr_err(FW_BUG "cpu %d, invalid IBS "
+		       "interrupt offset %d (MSR%08X=0x%016llx)",
+		       smp_processor_id(), offset,
+		       MSR_AMD64_IBSCTL, val);
+		return 0;
+	}
+
+	offset = val & IBSCTL_LVT_OFFSET_MASK;
+
+	if (eilvt_is_available(offset))
+		return !0;
+
+	pr_err(FW_BUG "cpu %d, IBS interrupt offset %d "
+	       "not available (MSR%08X=0x%016llx)",
+	       smp_processor_id(), offset,
+	       MSR_AMD64_IBSCTL, val);
+
+	return 0;
+}
+
+static inline int get_ibs_offset(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_LVT_OFFSET_VALID))
+		return -EINVAL;
+
+	return val & IBSCTL_LVT_OFFSET_MASK;
+}
+
+static void setup_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_offset();
+	if (offset < 0)
+		goto failed;
+
+	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
+		return;
+failed:
+	pr_warn("oprofile: IBS APIC setup failed on cpu #%d\n",
+		smp_processor_id());
+}
+
+static void clear_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_offset();
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
+}
+
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 
 static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
@@ -376,13 +451,13 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 
 	if (ibs_caps)
-		setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
+		setup_APIC_ibs();
 }
 
 static void op_amd_cpu_shutdown(void)
 {
 	if (ibs_caps)
-		setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
+		clear_APIC_ibs();
 }
 
 static int op_amd_check_ctrs(struct pt_regs * const regs,
@@ -445,16 +520,11 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	op_amd_stop_ibs();
 }
 
-static int __init_ibs_nmi(void)
+static int setup_ibs_ctl(int ibs_eilvt_off)
 {
-#define IBSCTL_LVTOFFSETVAL		(1 << 8)
-#define IBSCTL				0x1cc
 	struct pci_dev *cpu_cfg;
 	int nodes;
 	u32 value = 0;
-	u8 ibs_eilvt_off;
-
-	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
 
 	nodes = 0;
 	cpu_cfg = NULL;
@@ -466,21 +536,60 @@ static int __init_ibs_nmi(void)
 			break;
 		++nodes;
 		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
-				       | IBSCTL_LVTOFFSETVAL);
+				       | IBSCTL_LVT_OFFSET_VALID);
 		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
-		if (value != (ibs_eilvt_off | IBSCTL_LVTOFFSETVAL)) {
+		if (value != (ibs_eilvt_off | IBSCTL_LVT_OFFSET_VALID)) {
 			pci_dev_put(cpu_cfg);
 			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
-				"IBSCTL = 0x%08x", value);
-			return 1;
+			       "IBSCTL = 0x%08x\n", value);
+			return -EINVAL;
 		}
 	} while (1);
 
 	if (!nodes) {
-		printk(KERN_DEBUG "No CPU node configured for IBS");
-		return 1;
+		printk(KERN_DEBUG "No CPU node configured for IBS\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int force_ibs_eilvt_setup(void)
+{
+	int i;
+	int ret;
+
+	/* find the next free available EILVT entry */
+	for (i = 1; i < 4; i++) {
+		if (!eilvt_is_available(i))
+			continue;
+		ret = setup_ibs_ctl(i);
+		if (ret)
+			return ret;
+		return 0;
 	}
 
+	printk(KERN_DEBUG "No EILVT entry available\n");
+
+	return -EBUSY;
+}
+
+static int __init_ibs_nmi(void)
+{
+	int ret;
+
+	if (ibs_eilvt_valid())
+		return 0;
+
+	ret = force_ibs_eilvt_setup();
+	if (ret)
+		return ret;
+
+	if (!ibs_eilvt_valid())
+		return -EFAULT;
+
+	pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
+
 	return 0;
 }
 
