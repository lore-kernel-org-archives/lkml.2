Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2H0L1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 07:27:08 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:39350 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2H0L0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 07:26:54 -0400
Subject: [PATCH 2/2] x86/mce: Honour bios-set CMCI threshold
To: tony.luck@intel.com, andi@firstfloor.org, bp@amd64.org
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: gong.chen@linux.intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, lcm@us.ibm.com,
        mingo@redhat.com, tglx@linutronix.de, linux-edac@vger.kernel.org
Date: Mon, 27 Aug 2012 16:55:12 +0530
Message-ID: <20120827112512.10313.49176.stgit@localhost.localdomain>
In-Reply-To: <20120827112503.10313.62594.stgit@localhost.localdomain>
References: <20120827112503.10313.62594.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12082711-6102-0000-0000-00000220E030
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

Changes:
- Use the mce_boot_flags structure.
- Expose bios_cmci_threshold via sysfs.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 Documentation/x86/x86_64/boot-options.txt |    5 ++++
 arch/x86/include/asm/mce.h                |    3 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |   12 +++++++++
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   39 +++++++++++++++++++++++++++--
 4 files changed, 55 insertions(+), 4 deletions(-)

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
index 78caeb2..7c8ad16 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -133,7 +133,8 @@ struct mce_boot_flags {
 	__u32	cmci_disabled		: 1,
 		ignore_ce		: 1,
 		dont_log_ce		: 1,
-		__pad			: 29;
+		bios_cmci_threshold	: 1,
+		__pad			: 28;
 };
 
 extern struct mce_boot_flags mce_boot_flags;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a0d399..1d97e55 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1906,6 +1906,7 @@ static struct miscdevice mce_chrdev_device = {
  *	check, or 0 to not wait
  * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
  * mce=nobootlog Don't log MCEs from before booting.
+ * mce=bios_cmci_threshold Don't program the CMCI threshold
  */
 static int __init mcheck_enable(char *str)
 {
@@ -1925,6 +1926,8 @@ static int __init mcheck_enable(char *str)
 		mce_boot_flags.ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
+	else if (!strcmp(str, "bios_cmci_threshold"))
+		mce_boot_flags.bios_cmci_threshold = 1;
 	else if (isdigit(str[0])) {
 		get_option(&str, &tolerant);
 		if (*str == ',') {
@@ -2171,6 +2174,13 @@ static ssize_t set_cmci_disabled(struct device *s,
 	return size;
 }
 
+static ssize_t get_bios_cmci_threshold(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", mce_boot_flags.bios_cmci_threshold);
+}
+
 static ssize_t store_int_with_restart(struct device *s,
 				      struct device_attribute *attr,
 				      const char *buf, size_t size)
@@ -2186,6 +2196,7 @@ static DEVICE_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
 static DEVICE_ATTR(dont_log_ce, 0644, get_dont_log_ce, set_dont_log_ce);
 static DEVICE_ATTR(ignore_ce, 0644, get_ignore_ce, set_ignore_ce);
 static DEVICE_ATTR(cmci_disabled, 0644, get_cmci_disabled, set_cmci_disabled);
+static DEVICE_ATTR(bios_cmci_threshold, 0444, get_bios_cmci_threshold, NULL);
 
 static struct dev_ext_attribute dev_attr_check_interval = {
 	__ATTR(check_interval, 0644, device_show_int, store_int_with_restart),
@@ -2200,6 +2211,7 @@ static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_dont_log_ce,
 	&dev_attr_ignore_ce,
 	&dev_attr_cmci_disabled,
+	&dev_attr_bios_cmci_threshold,
 	NULL
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index aaf5c51..e7222e3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -84,10 +84,16 @@ static void cmci_discover(int banks, int boot)
 	unsigned long flags;
 	int hdr = 0;
 	int i;
+	int bios_wrong_thresh = 0;
+
+	if (boot && mce_boot_flags.bios_cmci_threshold)
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
+		if (!mce_boot_flags.bios_cmci_threshold) {
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
+			if (mce_boot_flags.bios_cmci_threshold && bios_zero_thresh &&
+					(val & MCI_CTL2_CMCI_THRESHOLD_MASK))
+				bios_wrong_thresh = 1;
 		} else {
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
@@ -119,6 +146,12 @@ static void cmci_discover(int banks, int boot)
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (hdr)
 		printk(KERN_CONT "\n");
+	if (boot && mce_boot_flags.bios_cmci_threshold && bios_wrong_thresh) {
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

