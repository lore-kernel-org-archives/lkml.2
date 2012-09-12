Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab2ILM1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:27:24 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:50190 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2ILM1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:27:22 -0400
Subject: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
To: tony.luck@intel.com
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: gong.chen@linux.intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, bp@amd64.org,
        lcm@us.ibm.com, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, gregkh@suse.de, linux-edac@vger.kernel.org
Date: Wed, 12 Sep 2012 17:55:16 +0530
Message-ID: <20120912122516.3825.87838.stgit@localhost.localdomain>
In-Reply-To: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com>
References: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12091212-8878-0000-0000-000003FAC6C4
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

v3: Updated messages as per Tony's inputs.
v2: Just separating out the patch. I will send a separate patch for
consolidating the MCE boot flags.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 Documentation/x86/x86_64/boot-options.txt |    5 ++++
 arch/x86/include/asm/mce.h                |    1 +
 arch/x86/kernel/cpu/mcheck/mce.c          |   10 ++++++++
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   35 +++++++++++++++++++++++++++--
 4 files changed, 48 insertions(+), 3 deletions(-)

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
index c311122..29e87d3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -83,6 +83,7 @@ static int			mce_dont_log_ce		__read_mostly;
 int				mce_cmci_disabled	__read_mostly;
 int				mce_ignore_ce		__read_mostly;
 int				mce_ser			__read_mostly;
+int				mce_bios_cmci_threshold	__read_mostly;
 
 struct mce_bank                *mce_banks		__read_mostly;
 
@@ -1946,6 +1947,7 @@ static struct miscdevice mce_chrdev_device = {
  *	check, or 0 to not wait
  * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
  * mce=nobootlog Don't log MCEs from before booting.
+ * mce=bios_cmci_threshold Don't program the CMCI threshold
  */
 static int __init mcheck_enable(char *str)
 {
@@ -1965,6 +1967,8 @@ static int __init mcheck_enable(char *str)
 		mce_ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
+	else if (!strcmp(str, "bios_cmci_threshold"))
+		mce_bios_cmci_threshold = 1;
 	else if (isdigit(str[0])) {
 		get_option(&str, &tolerant);
 		if (*str == ',') {
@@ -2205,6 +2209,11 @@ static struct dev_ext_attribute dev_attr_cmci_disabled = {
 	&mce_cmci_disabled
 };
 
+static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
+	__ATTR(bios_cmci_threshold, 0444, device_show_int, NULL),
+	&mce_bios_cmci_threshold
+};
+
 static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_tolerant.attr,
 	&dev_attr_check_interval.attr,
@@ -2213,6 +2222,7 @@ static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_dont_log_ce.attr,
 	&dev_attr_ignore_ce.attr,
 	&dev_attr_cmci_disabled.attr,
+	&dev_attr_bios_cmci_threshold.attr,
 	NULL
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 098386f..5f88abf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -181,10 +181,12 @@ static void cmci_discover(int banks)
 	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
 	unsigned long flags;
 	int i;
+	int bios_wrong_thresh = 0;
 
 	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		u64 val;
+		int bios_zero_thresh = 0;
 
 		if (test_bit(i, owned))
 			continue;
@@ -198,8 +200,20 @@ static void cmci_discover(int banks)
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
 
@@ -207,11 +221,26 @@ static void cmci_discover(int banks)
 		if (val & MCI_CTL2_CMCI_EN) {
 			set_bit(i, owned);
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
 	}
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	if (mce_bios_cmci_threshold && bios_wrong_thresh) {
+		pr_info_once(
+			"bios_cmci_threshold: Some banks do not have valid thresholds set\n");
+		pr_info_once(
+			"bios_cmci_threshold: Make sure your BIOS supports this boot option\n");
+	}
 }
 
 /*
@@ -249,7 +278,7 @@ void cmci_clear(void)
 			continue;
 		/* Disable CMCI */
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
-		val &= ~(MCI_CTL2_CMCI_EN|MCI_CTL2_CMCI_THRESHOLD_MASK);
+		val &= ~MCI_CTL2_CMCI_EN;
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}

