Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab2IEKYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:24:01 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37496 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab2IEKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:23:59 -0400
Subject: [PATCH 3/3] x86/mce: Honour bios-set CMCI threshold
To: tony.luck@intel.com, andi@firstfloor.org, bp@amd64.org
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: gong.chen@linux.intel.com, ananth@in.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, gregkh@suse.de, linux-edac@vger.kernel.org
Date: Wed, 05 Sep 2012 15:52:06 +0530
Message-ID: <20120905102206.9423.28389.stgit@localhost.localdomain>
In-Reply-To: <20120905102049.9423.6413.stgit@localhost.localdomain>
References: <20120905102049.9423.6413.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12090510-9574-0000-0000-000004465869
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
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    3 +-
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
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 9a165a2..cfc2852 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -15,7 +15,8 @@ struct mce_config {
 	__u32	cmci_disabled		: 1,
 		ignore_ce		: 1,
 		dont_log_ce		: 1,
-		__pad			: 29;
+		bios_cmci_threshold	: 1,
+		__pad			: 28;
 };
 
 extern struct mce_config mce_cfg;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index cbdef73..e0985a7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1945,6 +1945,7 @@ static struct miscdevice mce_chrdev_device = {
  *	check, or 0 to not wait
  * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
  * mce=nobootlog Don't log MCEs from before booting.
+ * mce=bios_cmci_threshold Don't program the CMCI threshold
  */
 static int __init mcheck_enable(char *str)
 {
@@ -1964,6 +1965,8 @@ static int __init mcheck_enable(char *str)
 		mce_cfg.ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
+	else if (!strcmp(str, "bios_cmci_threshold"))
+		mce_cfg.bios_cmci_threshold = 1;
 	else if (isdigit(str[0])) {
 		get_option(&str, &tolerant);
 		if (*str == ',') {
@@ -2210,6 +2213,13 @@ static ssize_t set_cmci_disabled(struct device *s,
 	return size;
 }
 
+static ssize_t get_bios_cmci_threshold(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", mce_cfg.bios_cmci_threshold);
+}
+
 static ssize_t store_int_with_restart(struct device *s,
 				      struct device_attribute *attr,
 				      const char *buf, size_t size)
@@ -2225,6 +2235,7 @@ static DEVICE_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
 static DEVICE_ATTR(dont_log_ce, 0644, get_dont_log_ce, set_dont_log_ce);
 static DEVICE_ATTR(ignore_ce, 0644, get_ignore_ce, set_ignore_ce);
 static DEVICE_ATTR(cmci_disabled, 0644, get_cmci_disabled, set_cmci_disabled);
+static DEVICE_ATTR(bios_cmci_threshold, 0444, get_bios_cmci_threshold, NULL);
 
 static struct dev_ext_attribute dev_attr_check_interval = {
 	__ATTR(check_interval, 0644, device_show_int, store_int_with_restart),
@@ -2252,6 +2263,7 @@ static struct attribute *mce_device_global_attrs[] = {
 	&dev_attr_dont_log_ce.attr,
 	&dev_attr_ignore_ce.attr,
 	&dev_attr_cmci_disabled.attr,
+	&dev_attr_bios_cmci_threshold.attr,
 	NULL
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index a6c028d..6a2de06 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -181,10 +181,16 @@ static void cmci_discover(int banks)
 	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
 	unsigned long flags;
 	int i;
+	int bios_wrong_thresh = 0;
+
+	if (mce_cfg.bios_cmci_threshold)
+		printk_once(KERN_INFO
+			"bios_cmci_threshold: Using bios-set threshold values for CMCI");
 
 	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		u64 val;
+		int bios_zero_thresh = 0;
 
 		if (test_bit(i, owned))
 			continue;
@@ -198,8 +204,20 @@ static void cmci_discover(int banks)
 			continue;
 		}
 
-		val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
-		val |= MCI_CTL2_CMCI_EN | CMCI_THRESHOLD;
+		if (!mce_cfg.bios_cmci_threshold) {
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
 
@@ -207,11 +225,26 @@ static void cmci_discover(int banks)
 		if (val & MCI_CTL2_CMCI_EN) {
 			set_bit(i, owned);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+			/*
+			 * We are able to set thresholds for some banks that
+			 * had a threshold of 0. This means the BIOS has not
+			 * set the thresholds properly or does not work with
+			 * this boot option. Note down now and report later.
+			 */
+			if (mce_cfg.bios_cmci_threshold && bios_zero_thresh &&
+					(val & MCI_CTL2_CMCI_THRESHOLD_MASK))
+				bios_wrong_thresh = 1;
 		} else {
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
 	}
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	if (mce_cfg.bios_cmci_threshold && bios_wrong_thresh) {
+		printk_once(KERN_INFO
+			"bios_cmci_threshold: Some banks do not have valid thresholds set");
+		printk_once(KERN_INFO
+			"bios_cmci_threshold: Make sure your BIOS supports this boot option");
+	}
 }
 
 /*
@@ -249,7 +282,7 @@ void cmci_clear(void)
 			continue;
 		/* Disable CMCI */
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
-		val &= ~(MCI_CTL2_CMCI_EN|MCI_CTL2_CMCI_THRESHOLD_MASK);
+		val &= ~MCI_CTL2_CMCI_EN;
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}

