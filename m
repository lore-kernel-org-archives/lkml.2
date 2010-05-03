Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0ECWlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:41:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:60863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759290Ab0ECWkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:40:49 -0400
Date: Mon, 3 May 2010 22:40:33 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1271945222-5283-5-git-send-email-bp@amd64.org>
References: <1271945222-5283-5-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo: Make L3 cache info per node
Message-ID: <tip-ba06edb63f5ef2913aad37070eaec3c9d8ac73b8@git.kernel.org>
Git-Commit-ID: ba06edb63f5ef2913aad37070eaec3c9d8ac73b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 03 May 2010 22:40:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba06edb63f5ef2913aad37070eaec3c9d8ac73b8
Gitweb:     http://git.kernel.org/tip/ba06edb63f5ef2913aad37070eaec3c9d8ac73b8
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 22 Apr 2010 16:07:01 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 22 Apr 2010 17:17:23 -0700

x86, cacheinfo: Make L3 cache info per node

Currently, we're allocating L3 cache info and calculating indices for
each online cpu which is clearly superfluous. Instead, we need to do
this per-node as is each L3 cache.

No functional change, only per-cpu memory savings.

-v2: Allocate L3 cache descriptors array dynamically.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1271945222-5283-5-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   59 +++++++++++++++++++++++++--------
 1 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index ff663ca..1346e9c 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -307,19 +307,18 @@ struct _cache_attr {
 };
 
 #ifdef CONFIG_CPU_SUP_AMD
+
+/*
+ * L3 cache descriptors
+ */
+static struct amd_l3_cache **__cpuinitdata l3_caches;
+
 static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 {
-	/*
-	 * We're called over smp_call_function_single() and therefore
-	 * are on the correct cpu.
-	 */
-	int cpu = smp_processor_id();
-	int node = cpu_to_node(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned int sc0, sc1, sc2, sc3;
 	u32 val = 0;
 
-	pci_read_config_dword(dev, 0x1C4, &val);
+	pci_read_config_dword(l3->dev, 0x1C4, &val);
 
 	/* calculate subcache sizes */
 	l3->subcaches[0] = sc0 = !(val & BIT(0));
@@ -328,13 +327,31 @@ static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 	l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
 
 	l3->indices = (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
+}
+
+static struct amd_l3_cache * __cpuinit amd_init_l3_cache(int node)
+{
+	struct amd_l3_cache *l3;
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+
+	l3 = kzalloc(sizeof(struct amd_l3_cache), GFP_ATOMIC);
+	if (!l3) {
+		printk(KERN_WARNING "Error allocating L3 struct\n");
+		return NULL;
+	}
 
 	l3->dev = dev;
+
+	amd_calc_l3_indices(l3);
+
+	return l3;
 }
 
 static void __cpuinit
 amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
+	int node;
+
 	if (boot_cpu_data.x86 != 0x10)
 		return;
 
@@ -355,14 +372,28 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 	if (num_k8_northbridges == 0)
 		return;
 
-	this_leaf->l3 = kzalloc(sizeof(struct amd_l3_cache), GFP_ATOMIC);
-	if (!this_leaf->l3) {
-		printk(KERN_WARNING "Error allocating L3 struct\n");
-		return;
+	/*
+	 * Strictly speaking, the amount in @size below is leaked since it is
+	 * never freed but this is done only on shutdown so it doesn't matter.
+	 */
+	if (!l3_caches) {
+		int size = num_k8_northbridges * sizeof(struct amd_l3_cache *);
+
+		l3_caches = kzalloc(size, GFP_ATOMIC);
+		if (!l3_caches)
+			return;
 	}
 
-	this_leaf->l3->can_disable = true;
-	amd_calc_l3_indices(this_leaf->l3);
+	node = amd_get_nb_id(smp_processor_id());
+
+	if (!l3_caches[node]) {
+		l3_caches[node] = amd_init_l3_cache(node);
+		l3_caches[node]->can_disable = true;
+	}
+
+	WARN_ON(!l3_caches[node]);
+
+	this_leaf->l3 = l3_caches[node];
 }
 
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
