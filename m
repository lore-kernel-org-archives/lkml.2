Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0LERuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:50:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab0LERuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=k1gdXC43J9Vy7KxSV/NlYpZiZ/xO/xlOvfiqy6Zw0Q9tgz9c2F+3bLctteBAeJ7rUB
         gwrIBbvAHkQez2UObdirCTDa67XkSeoa7QweOrjn0EzNaXjTLt0oOVZaM8Uf7NYls92S
         oveWprSCf4DVk7gsmFEUkXXiQJ3HtZlo0j0Ow=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 02/45] kstrtox: convert arch/x86/
Date: Sun,  5 Dec 2010 19:48:59 +0200
Message-Id: <1291571382-2719-2-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
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
 6 files changed, 53 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 491977b..1b8380a 100644
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
index 17ad033..3647889 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -442,7 +442,7 @@ SHOW_CACHE_DISABLE(0)
 SHOW_CACHE_DISABLE(1)
 
 static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
-				 unsigned slot, unsigned long idx)
+				 unsigned slot, u32 idx)
 {
 	int i;
 
@@ -481,12 +481,12 @@ static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
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
@@ -518,7 +518,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 				  const char *buf, size_t count,
 				  unsigned int slot)
 {
-	unsigned long val = 0;
+	u32 val;
 	int cpu, err = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -529,8 +529,9 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 
 	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	err = kstrtou32(buf, 10, &val);
+	if (err < 0)
+		return err;
 
 	err = amd_set_l3_disable_slot(this_leaf->l3, cpu, slot, val);
 	if (err) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7a35b72..f868f80 100644
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
index 80c4823..27e1555 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -292,9 +292,11 @@ store_interrupt_enable(struct threshold_block *b, const char *buf, size_t size)
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
 
@@ -312,9 +314,11 @@ store_threshold_limit(struct threshold_block *b, const char *buf, size_t size)
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
index ba2bcdd..64ffde1 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -270,12 +270,12 @@ static void mmu_audit_disable(void)
 
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
index ba9caa8..0fc13d3 100644
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
-- 
1.7.2.2

