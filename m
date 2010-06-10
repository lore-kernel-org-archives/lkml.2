Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab0FJALB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 20:11:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:47851 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857Ab0FJAK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 20:10:58 -0400
Date: Thu, 10 Jun 2010 00:10:04 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com, bp@amd64.org,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, bp@amd64.org, hpa@linux.intel.com,
       borislav.petkov@amd.com
In-Reply-To: <20100602161840.GI18327@aftab>
References: <20100602161840.GI18327@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo: Carve out L3 cache slot accessors
Message-ID: <tip-8cc1176e5de534d55cb26ff0cef3fd0d6ad8c3c0@git.kernel.org>
Git-Commit-ID: 8cc1176e5de534d55cb26ff0cef3fd0d6ad8c3c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 00:10:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cc1176e5de534d55cb26ff0cef3fd0d6ad8c3c0
Gitweb:     http://git.kernel.org/tip/8cc1176e5de534d55cb26ff0cef3fd0d6ad8c3c0
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Wed, 2 Jun 2010 18:18:40 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 9 Jun 2010 15:57:41 -0700

x86, cacheinfo: Carve out L3 cache slot accessors

This is in preparation for disabling L3 cache indices after having
received correctable ECCs in the L3 cache. Now we allow for initial
setting of a disabled index slot (write once) and deny writing new
indices to it after it has been disabled. Also, we deny using both slots
to disable one and the same index.

Userspace can restore the previously disabled indices by rewriting those
sysfs entries when booting.

Cleanup and reorganize code while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100602161840.GI18327@aftab>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |  108 +++++++++++++++++++++++++--------
 1 files changed, 82 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 33eae20..898c2f4 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -347,8 +347,8 @@ static struct amd_l3_cache * __cpuinit amd_init_l3_cache(int node)
 	return l3;
 }
 
-static void __cpuinit
-amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
+static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
+					   int index)
 {
 	int node;
 
@@ -396,20 +396,39 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 	this_leaf->l3 = l3_caches[node];
 }
 
+/*
+ * check whether a slot used for disabling an L3 index is occupied.
+ * @l3: L3 cache descriptor
+ * @slot: slot number (0..1)
+ *
+ * @returns: the disabled index if used or negative value if slot free.
+ */
+int amd_get_l3_disable_slot(struct amd_l3_cache *l3, unsigned slot)
+{
+	unsigned int reg = 0;
+
+	pci_read_config_dword(l3->dev, 0x1BC + slot * 4, &reg);
+
+	/* check whether this slot is activated already */
+	if (reg & (3UL << 30))
+		return reg & 0xfff;
+
+	return -1;
+}
+
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 				  unsigned int slot)
 {
-	struct pci_dev *dev = this_leaf->l3->dev;
-	unsigned int reg = 0;
+	int index;
 
 	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
 		return -EINVAL;
 
-	if (!dev)
-		return -EINVAL;
+	index = amd_get_l3_disable_slot(this_leaf->l3, slot);
+	if (index >= 0)
+		return sprintf(buf, "%d\n", index);
 
-	pci_read_config_dword(dev, 0x1BC + slot * 4, &reg);
-	return sprintf(buf, "0x%08x\n", reg);
+	return sprintf(buf, "FREE\n");
 }
 
 #define SHOW_CACHE_DISABLE(slot)					\
@@ -451,37 +470,74 @@ static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
 	}
 }
 
-
-static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
-				   const char *buf, size_t count,
-				   unsigned int slot)
+/*
+ * disable a L3 cache index by using a disable-slot
+ *
+ * @l3:    L3 cache descriptor
+ * @cpu:   A CPU on the node containing the L3 cache
+ * @slot:  slot number (0..1)
+ * @index: index to disable
+ *
+ * @return: 0 on success, error status on failure
+ */
+int amd_set_l3_disable_slot(struct amd_l3_cache *l3, int cpu, unsigned slot,
+			    unsigned long index)
 {
-	struct pci_dev *dev = this_leaf->l3->dev;
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	unsigned long val = 0;
+	int ret = 0;
 
 #define SUBCACHE_MASK	(3UL << 20)
 #define SUBCACHE_INDEX	0xfff
 
-	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
+	/*
+	 * check whether this slot is already used or
+	 * the index is already disabled
+	 */
+	ret = amd_get_l3_disable_slot(l3, slot);
+	if (ret >= 0)
 		return -EINVAL;
 
+	/*
+	 * check whether the other slot has disabled the
+	 * same index already
+	 */
+	if (index == amd_get_l3_disable_slot(l3, !slot))
+		return -EINVAL;
+
+	/* do not allow writes outside of allowed bits */
+	if ((index & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
+	    ((index & SUBCACHE_INDEX) > l3->indices))
+		return -EINVAL;
+
+	amd_l3_disable_index(l3, cpu, slot, index);
+
+	return 0;
+}
+
+static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
+				  const char *buf, size_t count,
+				  unsigned int slot)
+{
+	unsigned long val = 0;
+	int cpu, err = 0;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!dev)
+	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
 		return -EINVAL;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
 
-	/* do not allow writes outside of allowed bits */
-	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
-	    ((val & SUBCACHE_INDEX) > this_leaf->l3->indices))
+	if (strict_strtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 
-	amd_l3_disable_index(this_leaf->l3, cpu, slot, val);
-
+	err = amd_set_l3_disable_slot(this_leaf->l3, cpu, slot, val);
+	if (err) {
+		if (err == -EEXIST)
+			printk(KERN_WARNING "L3 disable slot %d in use!\n",
+					    slot);
+		return err;
+	}
 	return count;
 }
 
@@ -502,7 +558,7 @@ static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 
 #else	/* CONFIG_CPU_SUP_AMD */
 static void __cpuinit
-amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
+amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf, int index)
 {
 };
 #endif /* CONFIG_CPU_SUP_AMD */
@@ -518,7 +574,7 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
 		amd_cpuid4(index, &eax, &ebx, &ecx);
-		amd_check_l3_disable(index, this_leaf);
+		amd_check_l3_disable(this_leaf, index);
 	} else {
 		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
 	}
