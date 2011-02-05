Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1BEOXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:23:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54987 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1BEOXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:23:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QZvvIcq9fyEqpbbbLpunEK+RQnU20Q2Y2OFfaq5iOQ4nVOAT44d19rX1lLNHWE/qQV
         bfb2gDzz/k8Pp7iYxPNMjNXZZ8quQ42Z25SpgfDO/+p47b0VNfCBtOjTQOZGVIOMGm7Y
         uHEx3+7nGxVD2qx1ULJD7+sbX3uim2cLg8OXM=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 51/52] kstrtox: convert x86
Date: Sat,  5 Feb 2011 16:20:54 +0200
Message-Id: <1296915654-7458-51-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   12 ++++++++----
 arch/x86/kernel/cpu/intel_cacheinfo.c     |   15 ++++++++-------
 arch/x86/kernel/cpu/mcheck/mce.c          |   25 ++++++++++++++-----------
 arch/x86/kernel/cpu/mcheck/mce_amd.c      |   12 ++++++++----
 arch/x86/kvm/mmu_audit.c                  |    6 +++---
 arch/x86/platform/uv/tlb_uv.c             |   19 ++++++++++++-------
 drivers/platform/x86/classmate-laptop.c   |    2 +-
 drivers/platform/x86/compal-laptop.c      |   14 ++++++--------
 8 files changed, 60 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 35c7e65..3b23367 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1451,11 +1451,15 @@ static void cpb_toggle(bool t)
 static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
 				 size_t count)
 {
-	int ret = -EINVAL;
-	unsigned long val = 0;
+	int val;
+	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
-	if (!ret && (val == 0 || val == 1) && cpb_capable)
+	ret = kstrtoint(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+	if (val != 0 && val != 1)
+		return -EINVAL;
+	if (cpb_capable)
 		cpb_toggle(val);
 	else
 		return -EINVAL;
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index ec2c19a..35afb5e 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -408,7 +408,7 @@ SHOW_CACHE_DISABLE(0)
 SHOW_CACHE_DISABLE(1)
 
 static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
-				 unsigned slot, unsigned long idx)
+				 unsigned slot, u32 idx)
 {
 	int i;
 
@@ -447,12 +447,12 @@ static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
  *
  * @return: 0 on success, error status on failure
  */
-int amd_set_l3_disable_slot(struct amd_l3_cache *l3, int cpu, unsigned slot,
-			    unsigned long index)
+static int amd_set_l3_disable_slot(struct amd_l3_cache *l3, int cpu,
+				   unsigned slot, u32 index)
 {
 	int ret = 0;
 
-#define SUBCACHE_MASK	(3UL << 20)
+#define SUBCACHE_MASK	(3U << 20)
 #define SUBCACHE_INDEX	0xfff
 
 	/*
@@ -484,7 +484,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 				  const char *buf, size_t count,
 				  unsigned int slot)
 {
-	unsigned long val = 0;
+	u32 val;
 	int cpu, err = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -496,8 +496,9 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 
 	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	err = kstrtou32(buf, 10, &val);
+	if (err < 0)
+		return err;
 
 	err = amd_set_l3_disable_slot(this_leaf->l3, cpu, slot, val);
 	if (err) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d916183..a3858d5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1833,12 +1833,11 @@ static ssize_t show_bank(struct sys_device *s, struct sysdev_attribute *attr,
 static ssize_t set_bank(struct sys_device *s, struct sysdev_attribute *attr,
 			const char *buf, size_t size)
 {
-	u64 new;
+	int rv;
 
-	if (strict_strtoull(buf, 0, &new) < 0)
-		return -EINVAL;
-
-	attr_to_bank(attr)->ctl = new;
+	rv = kstrtou64(buf, 0, &attr_to_bank(attr)->ctl);
+	if (rv < 0)
+		return rv;
 	mce_restart();
 
 	return size;
@@ -1871,10 +1870,12 @@ static ssize_t set_ignore_ce(struct sys_device *s,
 			     struct sysdev_attribute *attr,
 			     const char *buf, size_t size)
 {
-	u64 new;
+	unsigned long long new;
+	int rv;
 
-	if (strict_strtoull(buf, 0, &new) < 0)
-		return -EINVAL;
+	rv = kstrtoull(buf, 0, &new);
+	if (rv < 0)
+		return rv;
 
 	if (mce_ignore_ce ^ !!new) {
 		if (new) {
@@ -1894,10 +1895,12 @@ static ssize_t set_cmci_disabled(struct sys_device *s,
 				 struct sysdev_attribute *attr,
 				 const char *buf, size_t size)
 {
-	u64 new;
+	unsigned long long new;
+	int rv;
 
-	if (strict_strtoull(buf, 0, &new) < 0)
-		return -EINVAL;
+	rv = kstrtoull(buf, 0, &new);
+	if (rv < 0)
+		return rv;
 
 	if (mce_cmci_disabled ^ !!new) {
 		if (new) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 5bf2fac..f74e790 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -312,9 +312,11 @@ store_interrupt_enable(struct threshold_block *b, const char *buf, size_t size)
 {
 	struct thresh_restart tr;
 	unsigned long new;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &new) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 0, &new);
+	if (rv < 0)
+		return rv;
 
 	b->interrupt_enable = !!new;
 
@@ -331,9 +333,11 @@ store_threshold_limit(struct threshold_block *b, const char *buf, size_t size)
 {
 	struct thresh_restart tr;
 	unsigned long new;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &new) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 0, &new);
+	if (rv < 0)
+		return rv;
 
 	if (new > THRESHOLD_MAX)
 		new = THRESHOLD_MAX;
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 5f6223b..f60bbbf 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -275,12 +275,12 @@ static void mmu_audit_disable(void)
 
 static int mmu_audit_set(const char *val, const struct kernel_param *kp)
 {
+	int enable;
 	int ret;
-	unsigned long enable;
 
-	ret = strict_strtoul(val, 10, &enable);
+	ret = kstrtoint(val, 10, &enable);
 	if (ret < 0)
-		return -EINVAL;
+		return ret;
 
 	switch (enable) {
 	case 0:
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index df58e9c..4b687ae 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1028,21 +1028,22 @@ static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
 				 size_t count, loff_t *data)
 {
 	int cpu;
-	long input_arg;
+	int input_arg;
 	char optstr[64];
 	struct ptc_stats *stat;
+	int rv;
 
 	if (count == 0 || count > sizeof(optstr))
 		return -EINVAL;
 	if (copy_from_user(optstr, user, count))
 		return -EFAULT;
 	optstr[count - 1] = '\0';
-	if (strict_strtol(optstr, 10, &input_arg) < 0) {
-		printk(KERN_DEBUG "%s is invalid\n", optstr);
-		return -EINVAL;
-	}
+	rv = kstrtoint(optstr, 10, &input_arg);
+	if (rv < 0)
+		return rv;
 
-	if (input_arg == 0) {
+	switch (input_arg) {
+	case 0:
 		printk(KERN_DEBUG "# cpu:      cpu number\n");
 		printk(KERN_DEBUG "Sender statistics:\n");
 		printk(KERN_DEBUG
@@ -1110,11 +1111,15 @@ static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
 		"disable:  number times use of the BAU was disabled\n");
 		printk(KERN_DEBUG
 		"enable:   number times use of the BAU was re-enabled\n");
-	} else if (input_arg == -1) {
+		break;
+	case -1:
 		for_each_present_cpu(cpu) {
 			stat = &per_cpu(ptcstats, cpu);
 			memset(stat, 0, sizeof(struct ptc_stats));
 		}
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	return count;
diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index 9111354..e54994d 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -198,7 +198,7 @@ static ssize_t cmpc_accel_sensitivity_store(struct device *dev,
 	inputdev = dev_get_drvdata(&acpi->dev);
 	accel = dev_get_drvdata(&inputdev->dev);
 
-	r = strict_strtoul(buf, 0, &sensitivity);
+	r = kstrtoul(buf, 0, &sensitivity);
 	if (r)
 		return r;
 
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 034572b..0fae544 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -421,13 +421,12 @@ static ssize_t pwm_enable_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct compal_data *data = dev_get_drvdata(dev);
-	long val;
+	unsigned int val;
 	int err;
-	err = strict_strtol(buf, 10, &val);
+
+	err = kstrtouint(buf, 10, &val);
 	if (err)
 		return err;
-	if (val < 0)
-		return -EINVAL;
 
 	data->pwm_enable = val;
 
@@ -459,13 +458,12 @@ static ssize_t pwm_store(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct compal_data *data = dev_get_drvdata(dev);
-	long val;
+	u8 val;
 	int err;
-	err = strict_strtol(buf, 10, &val);
+
+	err = kstrtou8(buf, 10, &val);
 	if (err)
 		return err;
-	if (val < 0 || val > 255)
-		return -EINVAL;
 
 	data->curr_pwm = val;
 
-- 
1.7.3.4

