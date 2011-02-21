Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab1BUPRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:17:07 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46701 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab1BUPRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:17:05 -0500
From: Borislav Petkov <bp@amd64.org>
To: <x86@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86, amd-nb: Misc correctness fixes
Date: Mon, 21 Feb 2011 16:17:42 +0100
Message-Id: <1298301462-20469-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Make functions used strictly in bool context return bool. Also, fixup
used types and comments, and make a local function static, while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/amd_nb.h |   12 ++++++------
 arch/x86/kernel/amd_nb.c      |   18 ++++++++++--------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 2b33c4d..527fb96 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -13,7 +13,7 @@ extern const struct pci_device_id amd_nb_misc_ids[];
 extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
 struct bootnode;
 
-extern int early_is_amd_nb(u32 value);
+extern bool early_is_amd_nb(u32 value);
 extern int amd_cache_northbridges(void);
 extern void amd_flush_garts(void);
 extern int amd_numa_init(unsigned long start_pfn, unsigned long end_pfn);
@@ -38,18 +38,18 @@ struct amd_northbridge_info {
 };
 extern struct amd_northbridge_info amd_northbridges;
 
-#define AMD_NB_GART			0x1
-#define AMD_NB_L3_INDEX_DISABLE		0x2
-#define AMD_NB_L3_PARTITIONING		0x4
+#define AMD_NB_GART			BIT(0)
+#define AMD_NB_L3_INDEX_DISABLE		BIT(1)
+#define AMD_NB_L3_PARTITIONING		BIT(2)
 
 #ifdef CONFIG_AMD_NB
 
-static inline int amd_nb_num(void)
+static inline u16 amd_nb_num(void)
 {
 	return amd_northbridges.num;
 }
 
-static inline int amd_nb_has_feature(int feature)
+static inline bool amd_nb_has_feature(unsigned feature)
 {
 	return ((amd_northbridges.flags & feature) == feature);
 }
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index ed3c2e5..b57ade1 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -48,7 +48,7 @@ static struct pci_dev *next_northbridge(struct pci_dev *dev,
 
 int amd_cache_northbridges(void)
 {
-	int i = 0;
+	u16 i = 0;
 	struct amd_northbridge *nb;
 	struct pci_dev *misc, *link;
 
@@ -103,9 +103,11 @@ int amd_cache_northbridges(void)
 }
 EXPORT_SYMBOL_GPL(amd_cache_northbridges);
 
-/* Ignores subdevice/subvendor but as far as I can figure out
-   they're useless anyways */
-int __init early_is_amd_nb(u32 device)
+/*
+ * Ignores subdevice/subvendor but as far as I can figure out
+ * they're useless anyways
+ */
+bool __init early_is_amd_nb(u32 device)
 {
 	const struct pci_device_id *id;
 	u32 vendor = device & 0xffff;
@@ -113,8 +115,8 @@ int __init early_is_amd_nb(u32 device)
 	device >>= 16;
 	for (id = amd_nb_misc_ids; id->vendor; id++)
 		if (vendor == id->vendor && device == id->device)
-			return 1;
-	return 0;
+			return true;
+	return false;
 }
 
 int amd_get_subcaches(int cpu)
@@ -176,9 +178,9 @@ int amd_set_subcaches(int cpu, int mask)
 	return 0;
 }
 
-int amd_cache_gart(void)
+static int amd_cache_gart(void)
 {
-       int i;
+       u16 i;
 
        if (!amd_nb_has_feature(AMD_NB_GART))
                return 0;
-- 
1.7.4.rc2

