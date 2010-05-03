Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab0ECWlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:41:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:60909 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759370Ab0ECWk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:40:57 -0400
Date: Mon, 3 May 2010 22:40:50 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1271945222-5283-6-git-send-email-bp@amd64.org>
References: <1271945222-5283-6-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo: Disable index in all four subcaches
Message-ID: <tip-59d3b388741cf1a5eb7ad27fd4e9ed72643164ae@git.kernel.org>
Git-Commit-ID: 59d3b388741cf1a5eb7ad27fd4e9ed72643164ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 03 May 2010 22:40:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59d3b388741cf1a5eb7ad27fd4e9ed72643164ae
Gitweb:     http://git.kernel.org/tip/59d3b388741cf1a5eb7ad27fd4e9ed72643164ae
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 22 Apr 2010 16:07:02 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 22 Apr 2010 17:17:27 -0700

x86, cacheinfo: Disable index in all four subcaches

When disabling an L3 cache index, make sure we disable that index in
all four subcaches of the L3. Clarify nomenclature while at it, wrt to
disable slots versus disable index and rename accordingly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1271945222-5283-6-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   60 +++++++++++++++++++++++---------
 1 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 1346e9c..33eae20 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -397,7 +397,7 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 }
 
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
-				  unsigned int index)
+				  unsigned int slot)
 {
 	struct pci_dev *dev = this_leaf->l3->dev;
 	unsigned int reg = 0;
@@ -408,21 +408,53 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 	if (!dev)
 		return -EINVAL;
 
-	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
+	pci_read_config_dword(dev, 0x1BC + slot * 4, &reg);
 	return sprintf(buf, "0x%08x\n", reg);
 }
 
-#define SHOW_CACHE_DISABLE(index)					\
+#define SHOW_CACHE_DISABLE(slot)					\
 static ssize_t								\
-show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)	\
+show_cache_disable_##slot(struct _cpuid4_info *this_leaf, char *buf)	\
 {									\
-	return show_cache_disable(this_leaf, buf, index);		\
+	return show_cache_disable(this_leaf, buf, slot);		\
 }
 SHOW_CACHE_DISABLE(0)
 SHOW_CACHE_DISABLE(1)
 
+static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
+				 unsigned slot, unsigned long idx)
+{
+	int i;
+
+	idx |= BIT(30);
+
+	/*
+	 *  disable index in all 4 subcaches
+	 */
+	for (i = 0; i < 4; i++) {
+		u32 reg = idx | (i << 20);
+
+		if (!l3->subcaches[i])
+			continue;
+
+		pci_write_config_dword(l3->dev, 0x1BC + slot * 4, reg);
+
+		/*
+		 * We need to WBINVD on a core on the node containing the L3
+		 * cache which indices we disable therefore a simple wbinvd()
+		 * is not sufficient.
+		 */
+		wbinvd_on_cpu(cpu);
+
+		reg |= BIT(31);
+		pci_write_config_dword(l3->dev, 0x1BC + slot * 4, reg);
+	}
+}
+
+
 static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
-	const char *buf, size_t count, unsigned int index)
+				   const char *buf, size_t count,
+				   unsigned int slot)
 {
 	struct pci_dev *dev = this_leaf->l3->dev;
 	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
@@ -448,23 +480,17 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	    ((val & SUBCACHE_INDEX) > this_leaf->l3->indices))
 		return -EINVAL;
 
-	val |= BIT(30);
-	pci_write_config_dword(dev, 0x1BC + index * 4, val);
-	/*
-	 * We need to WBINVD on a core on the node containing the L3 cache which
-	 * indices we disable therefore a simple wbinvd() is not sufficient.
-	 */
-	wbinvd_on_cpu(cpu);
-	pci_write_config_dword(dev, 0x1BC + index * 4, val | BIT(31));
+	amd_l3_disable_index(this_leaf->l3, cpu, slot, val);
+
 	return count;
 }
 
-#define STORE_CACHE_DISABLE(index)					\
+#define STORE_CACHE_DISABLE(slot)					\
 static ssize_t								\
-store_cache_disable_##index(struct _cpuid4_info *this_leaf,		\
+store_cache_disable_##slot(struct _cpuid4_info *this_leaf,		\
 			    const char *buf, size_t count)		\
 {									\
-	return store_cache_disable(this_leaf, buf, count, index);	\
+	return store_cache_disable(this_leaf, buf, count, slot);	\
 }
 STORE_CACHE_DISABLE(0)
 STORE_CACHE_DISABLE(1)
