Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab0DOQn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:43:57 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47896 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab0DOQnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:43:20 -0400
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
       Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/5] x86, cacheinfo: Disable index in all four subcaches
Date: Thu, 15 Apr 2010 18:41:03 +0200
Message-Id: <1271349663-16670-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271349663-16670-1-git-send-email-bp@amd64.org>
References: <1271349663-16670-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

When disabling an L3 cache index, make sure we disable that index in
all four subcaches of the L3. Clarify nomenclature while at it, wrt to
disable slots versus disable index and rename accordingly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   60 +++++++++++++++++++++++---------
 1 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index c42b5c5..12c5475 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -387,7 +387,7 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 }
 
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
-				  unsigned int index)
+				  unsigned int slot)
 {
 	struct pci_dev *dev = this_leaf->l3->dev;
 	unsigned int reg = 0;
@@ -398,21 +398,53 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
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
@@ -438,23 +470,17 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
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
-- 
1.7.1.rc1

