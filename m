Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab1CCMe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 07:34:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:49952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab1CCMe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 07:34:27 -0500
Date: Thu, 3 Mar 2011 12:33:57 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, bp@amd64.org, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@amd64.org, borislav.petkov@amd.com,
        mingo@elte.hu
In-Reply-To: <20110303115932.GA8603@aftab>
References: <20110303115932.GA8603@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, amd-nb: Misc cleanliness fixes
Message-ID: <tip-84fd1d35cc868a4f7590b6dbdae2d7761287b97a@git.kernel.org>
Git-Commit-ID: 84fd1d35cc868a4f7590b6dbdae2d7761287b97a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 03 Mar 2011 12:33:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84fd1d35cc868a4f7590b6dbdae2d7761287b97a
Gitweb:     http://git.kernel.org/tip/84fd1d35cc868a4f7590b6dbdae2d7761287b97a
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Thu, 3 Mar 2011 12:59:32 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Mar 2011 13:06:20 +0100

x86, amd-nb: Misc cleanliness fixes

Make functions used strictly in bool context return bool. Also,
fixup used types and comments, and make a local function static,
while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Borislav Petkov <bp@amd64.org>
LKML-Reference: <20110303115932.GA8603@aftab>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index ed3c2e5..6563419 100644
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
+	u16 i;
 
        if (!amd_nb_has_feature(AMD_NB_GART))
                return 0;
