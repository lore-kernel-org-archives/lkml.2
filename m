Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab0CUHP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:15:56 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:28694 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0CUHPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:15:54 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/20] x86: use wake_system_ram_range instead of e820_any_mapped in agp path
Date: Sun, 21 Mar 2010 00:13:05 -0700
Message-Id: <1269155601-18247-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BA5C765.0062,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put apterture_valid back to .c
and early path still use e820_any_mapped()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/gart.h   |   22 ----------------------
 arch/x86/kernel/aperture_64.c |   22 ++++++++++++++++++++++
 drivers/char/agp/amd64-agp.c  |   39 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 4ac5b0f..2b63a91 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -74,26 +74,4 @@ static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
         pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
 
-static inline int aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
-{
-	if (!aper_base)
-		return 0;
-
-	if (aper_base + aper_size > 0x100000000ULL) {
-		printk(KERN_INFO "Aperture beyond 4GB. Ignoring.\n");
-		return 0;
-	}
-	if (e820_any_mapped(aper_base, aper_base + aper_size, E820_RAM)) {
-		printk(KERN_INFO "Aperture pointing to e820 RAM. Ignoring.\n");
-		return 0;
-	}
-	if (aper_size < min_size) {
-		printk(KERN_INFO "Aperture too small (%d MB) than (%d MB)\n",
-				 aper_size>>20, min_size>>20);
-		return 0;
-	}
-
-	return 1;
-}
-
 #endif /* _ASM_X86_GART_H */
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 3704997..f6e6270 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -145,6 +145,28 @@ static u32 __init find_cap(int bus, int slot, int func, int cap)
 	return 0;
 }
 
+static int __init aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
+{
+	if (!aper_base)
+		return 0;
+
+	if (aper_base + aper_size > 0x100000000ULL) {
+		printk(KERN_INFO "Aperture beyond 4GB. Ignoring.\n");
+		return 0;
+	}
+	if (e820_any_mapped(aper_base, aper_base + aper_size, E820_RAM)) {
+		printk(KERN_INFO "Aperture pointing to e820 RAM. Ignoring.\n");
+		return 0;
+	}
+	if (aper_size < min_size) {
+		printk(KERN_INFO "Aperture too small (%d MB) than (%d MB)\n",
+				 aper_size>>20, min_size>>20);
+		return 0;
+	}
+
+	return 1;
+}
+
 /* Read a standard AGPv3 bridge header */
 static u32 __init read_agp(int bus, int slot, int func, int cap, u32 *order)
 {
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index fd50ead..85cabd0 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -14,7 +14,6 @@
 #include <linux/agp_backend.h>
 #include <linux/mmzone.h>
 #include <asm/page.h>		/* PAGE_SIZE */
-#include <asm/e820.h>
 #include <asm/k8.h>
 #include <asm/gart.h>
 #include "agp.h"
@@ -231,6 +230,44 @@ static const struct agp_bridge_driver amd_8151_driver = {
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
+static int __devinit
+__is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
+{
+	return 1;
+}
+
+static int __devinit any_ram_in_range(u64 base, u64 size)
+{
+	unsigned long pfn, nr_pages;
+
+	pfn = base >> PAGE_SHIFT;
+	nr_pages = size >> PAGE_SHIFT;
+
+	return walk_system_ram_range(pfn, nr_pages, NULL, __is_ram) == 1;
+}
+
+static int __devinit aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
+{
+	if (!aper_base)
+		return 0;
+
+	if (aper_base + aper_size > 0x100000000ULL) {
+		printk(KERN_INFO "Aperture beyond 4GB. Ignoring.\n");
+		return 0;
+	}
+	if (any_ram_in_range(aper_base, aper_size)) {
+		printk(KERN_INFO "Aperture pointing to E820 RAM. Ignoring.\n");
+		return 0;
+	}
+	if (aper_size < min_size) {
+		printk(KERN_INFO "Aperture too small (%d MB) than (%d MB)\n",
+				 aper_size>>20, min_size>>20);
+		return 0;
+	}
+
+	return 1;
+}
+
 /* Some basic sanity checks for the aperture. */
 static int __devinit agp_aperture_valid(u64 aper, u32 size)
 {
-- 
1.6.4.2

