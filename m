Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2HVMcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:32:31 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:39274 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab2HVMc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:32:29 -0400
Subject: [PATCH] x86: mce: Honour bios-set CMCI threshold
To: tony.luck@intel.com, andi@firstfloor.org, bp@amd64.org
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: gong.chen@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, linux-edac@vger.kernel.org
Date: Wed, 22 Aug 2012 18:00:54 +0530
Message-ID: <20120822123054.29238.3864.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12082212-8878-0000-0000-000003B3069C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI spec doesn't provide for a way for the bios to pass down
recommended thresholds to the OS on a _per-bank_ basis. This patch adds
a new boot option, which if passed, allows bios to initialize the CMCI
threshold. In such a case, we simply skip programming any threshold
value.

As fail-safe, we initialize threshold to 1 if some banks have not been
initialized by the bios and warn the user.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 Documentation/x86/x86_64/boot-options.txt |    5 ++++
 arch/x86/include/asm/mce.h                |    1 +
 arch/x86/kernel/cpu/mcheck/mce.c          |    4 +++
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   39 +++++++++++++++++++++++++++--
 4 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index c54b4f5..ec92540 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -50,6 +50,11 @@ Machine check
 		monarchtimeout:
 		Sets the time in us to wait for other CPUs on machine checks. 0
 		to disable.
+   mce=bios_cmci_threshold
+		Don't overwrite the bios-set CMCI threshold. This boot option
+		prevents Linux from overwriting the CMCI threshold set by the
+		bios. Without this option, Linux always sets the CMCI
+		threshold to 1.
 
    nomce (for compatibility with i386): same as mce=off
 
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index a3ac52b..8ad5078 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -171,6 +171,7 @@ DECLARE_PER_CPU(struct device *, mce_device);
 #ifdef CONFIG_X86_MCE_INTEL
 extern int mce_cmci_disabled;
 extern int mce_ignore_ce;
+extern int mce_bios_cmci_threshold;
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 void cmci_clear(void);
 void cmci_reenable(void);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 292d025..401359d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -82,6 +82,7 @@ static int			mce_panic_timeout	__read_mostly;
 static int			mce_dont_log_ce		__read_mostly;
 int				mce_cmci_disabled	__read_mostly;
 int				mce_ignore_ce		__read_mostly;
+int				mce_bios_cmci_threshold	__read_mostly;
 int				mce_ser			__read_mostly;
 
 struct mce_bank                *mce_banks		__read_mostly;
@@ -1907,6 +1908,7 @@ static struct miscdevice mce_chrdev_device = {
  *	check, or 0 to not wait
  * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
  * mce=nobootlog Don't log MCEs from before booting.
+ * mce=bios_cmci_threshold Don't program the CMCI threshold
  */
 static int __init mcheck_enable(char *str)
 {
@@ -1926,6 +1928,8 @@ static int __init mcheck_enable(char *str)
 		mce_ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
+	else if (!strcmp(str, "bios_cmci_threshold"))
+		mce_bios_cmci_threshold = 1;
 	else if (isdigit(str[0])) {
 		get_option(&str, &tolerant);
 		if (*str == ',') {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 38e49bc..b869040 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -84,10 +84,16 @@ static void cmci_discover(int banks, int boot)
 	unsigned long flags;
 	int hdr = 0;
 	int i;
+	int bios_wrong_thresh = 0;
+
+	if (boot && mce_bios_cmci_threshold)
+		printk_once(KERN_INFO
+			"bios_cmci_threshold: Using bios-set threshold values for CMCI");
 
 	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		u64 val;
+		int bios_zero_thresh = 0;
 
 		if (test_bit(i, owned))
 			continue;
@@ -102,8 +108,20 @@ static void cmci_discover(int banks, int boot)
 			continue;
 		}
 
-		val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
-		val |= MCI_CTL2_CMCI_EN | CMCI_THRESHOLD;
+		if (!mce_bios_cmci_threshold) {
+			val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
+			val |= CMCI_THRESHOLD;
+		} else if (!(val & MCI_CTL2_CMCI_THRESHOLD_MASK)) {
+			/*
+			 * If bios_cmci_threshold boot option was specified
+			 * but the threshold is zero, we'll try to initialize
+			 * it to 1.
+			 */
+			bios_zero_thresh = 1;
+			val |= CMCI_THRESHOLD;
+		}
+
+		val |= MCI_CTL2_CMCI_EN;
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
 
@@ -112,6 +130,15 @@ static void cmci_discover(int banks, int boot)
 			if (!test_and_set_bit(i, owned) && !boot)
 				print_update("CMCI", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+			/*
+			 * We are able to set thresholds for some banks that
+			 * had a threshold of 0. This means the BIOS has not
+			 * set the thresholds properly or does not work with
+			 * this boot option. Note down now and report later.
+			 */
+			if (mce_bios_cmci_threshold && bios_zero_thresh &&
+					(val & MCI_CTL2_CMCI_THRESHOLD_MASK))
+				bios_wrong_thresh = 1;
 		} else {
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
@@ -119,6 +146,12 @@ static void cmci_discover(int banks, int boot)
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (hdr)
 		printk(KERN_CONT "\n");
+	if (boot && mce_bios_cmci_threshold && bios_wrong_thresh) {
+		printk_once(KERN_INFO
+			"bios_cmci_threshold: Some banks do not have valid thresholds set");
+		printk_once(KERN_INFO
+			"bios_cmci_threshold: Make sure your BIOS supports this boot option");
+	}
 }
 
 /*
@@ -156,7 +189,7 @@ void cmci_clear(void)
 			continue;
 		/* Disable CMCI */
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
-		val &= ~(MCI_CTL2_CMCI_EN|MCI_CTL2_CMCI_THRESHOLD_MASK);
+		val &= ~MCI_CTL2_CMCI_EN;
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}

