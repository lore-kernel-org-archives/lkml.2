Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1CCL7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 06:59:42 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40484 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1CCL7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 06:59:40 -0500
Date: Thu, 3 Mar 2011 12:59:32 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86, amd-nb: Misc correctness fixes
Message-ID: <20110303115932.GA8603@aftab>
References: <20110302193855.GA3840@aftab>
 <20110303091440.GA18252@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303091440.GA18252@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 04:14:40AM -0500, Ingo Molnar wrote:
> I'm confused about the title - a 'correctness fix' is one that fixes an actual bug.
> 
> Did you mean 'cleanliness fixes'?

Yes sir, this is basically a result from the 'make W=1 ..' thing I've
been playing with lately. Fixed.

> Also, checkpatch outputs a warning that looks legit.

Won't happen again. Hadn't enabled the pre-commit hook for checkpatch on
that machine. Fixed.

Here's a better version:

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 21 Feb 2011 15:54:36 +0100
Subject: [PATCH] x86, amd-nb: Misc cleanliness fixes

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
-- 
1.7.4.rc2

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
