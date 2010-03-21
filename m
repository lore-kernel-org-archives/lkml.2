Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0CUHRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:17:24 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:20977 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab0CUHRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:17:00 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 20/20] x86/pci: add mmconf range into e820 for when it is from MSR with amd faml0h
Date: Sun, 21 Mar 2010 00:13:21 -0700
Message-Id: <1269155601-18247-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BA5C78C.0041,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for AMD Fam10h, it we read mmconf from MSR early, we should just trust it
because we check it and correct it already.

so add it to e820

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/mmconf-fam10h_64.c |   40 ++++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index 7182580..4426fd2 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -16,6 +16,7 @@
 #include <asm/acpi.h>
 #include <asm/mmconfig.h>
 #include <asm/pci_x86.h>
+#include <asm/e820.h>
 
 struct pci_hostbridge_probe {
 	u32 bus;
@@ -27,23 +28,26 @@ struct pci_hostbridge_probe {
 static u64 __cpuinitdata fam10h_pci_mmconf_base;
 static int __cpuinitdata fam10h_pci_mmconf_base_status;
 
+/* only on BSP */
+static void __init_refok e820_add_mmconf_range(int busnbits)
+{
+	u64 end;
+
+	end = fam10h_pci_mmconf_base + (1ULL<<(busnbits + 20)) - 1;
+	if (!e820_all_mapped(fam10h_pci_mmconf_base, end+1, E820_RESERVED)) {
+		printk(KERN_DEBUG "Fam 10h mmconf [%llx, %llx]\n",
+				 fam10h_pci_mmconf_base, end);
+		e820_add_region(fam10h_pci_mmconf_base, 1ULL<<(busnbits + 20),
+				 E820_RESERVED);
+		sanitize_e820_map();
+	}
+}
+
 static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
 	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
 	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
 };
 
-static int __cpuinit cmp_range(const void *x1, const void *x2)
-{
-	const struct range *r1 = x1;
-	const struct range *r2 = x2;
-	int start1, start2;
-
-	start1 = r1->start >> 32;
-	start2 = r2->start >> 32;
-
-	return start1 - start2;
-}
-
 /*[47:0] */
 /* need to avoid (0xfd<<32) and (0xfe<<32), ht used space */
 #define FAM10H_PCI_MMCONF_BASE (0xfcULL<<32)
@@ -115,6 +119,7 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 	 * above 4G
 	 */
 	hi_mmio_num = 0;
+	memset(range, 0, sizeof(range));
 	for (i = 0; i < 8; i++) {
 		u32 reg;
 		u64 start;
@@ -130,16 +135,14 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 		if (!end)
 			continue;
 
-		range[hi_mmio_num].start = start;
-		range[hi_mmio_num].end = end;
-		hi_mmio_num++;
+		hi_mmio_num = add_range(range, 8, hi_mmio_num, start, end);
 	}
 
 	if (!hi_mmio_num)
 		goto out;
 
 	/* sort the range */
-	sort(range, hi_mmio_num, sizeof(struct range), cmp_range, NULL);
+	sort_range(range, hi_mmio_num);
 
 	if (range[hi_mmio_num - 1].end < base)
 		goto out;
@@ -169,6 +172,7 @@ fail:
 out:
 	fam10h_pci_mmconf_base = base;
 	fam10h_pci_mmconf_base_status = 1;
+	e820_add_mmconf_range(8);
 }
 
 void __cpuinit fam10h_check_enable_mmcfg(void)
@@ -191,10 +195,12 @@ void __cpuinit fam10h_check_enable_mmcfg(void)
 		/* only trust the one handle 256 buses, if acpi=off */
 		if (!acpi_pci_disabled || busnbits >= 8) {
 			u64 base;
-			base = val & (0xffffULL << 32);
+			base = val & (FAM10H_MMIO_CONF_BASE_MASK <<
+					FAM10H_MMIO_CONF_BASE_SHIFT);
 			if (fam10h_pci_mmconf_base_status <= 0) {
 				fam10h_pci_mmconf_base = base;
 				fam10h_pci_mmconf_base_status = 1;
+				e820_add_mmconf_range(busnbits);
 				return;
 			} else if (fam10h_pci_mmconf_base ==  base)
 				return;
-- 
1.6.4.2

