Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab0KDUYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:24:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31391 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab0KDUYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:24:19 -0400
Message-ID: <4CD3160D.7010902@kernel.org>
Date: Thu, 04 Nov 2010 13:22:37 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: your patch "x86/PCI: host mmconfig detect clean up"
References: <4CD15538020000780002060B@vpn.id2.novell.com>
In-Reply-To: <4CD15538020000780002060B@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 04:27 AM, Jan Beulich wrote:
> In this patch (commit 068258bc15439c11a966e873f931cc8e513dca61)
> you made the call to pci_mmcfg_reject_broken() unconditional. This
> breaks pci=check_enable_amd_mmconf when the mmconfig space
> wasn't enabled by the BIOS, since obviously the BIOS can't reserve
> in the E820 map the range Linux is going to assign. As the commit
> message doesn't really tell the reason for you doing so, could you
> shed some light on this, so a proper change to restore the original
> functionality can be put together?
> 
please check this one. 

Thanks

	Yinghai

Subject: [PATCH] x86/pci: Add mmconf range into e820 for when it is from MSR with amd faml0h

for AMD Fam10h, it we read mmconf from MSR early, we should just trust it
because we check it and correct it already.

so add it to e820

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/mmconf-fam10h_64.c |   40 +++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/kernel/mmconf-fam10h_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mmconf-fam10h_64.c
+++ linux-2.6/arch/x86/kernel/mmconf-fam10h_64.c
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
@@ -115,6 +119,7 @@ static void __cpuinit get_fam10h_pci_mmc
 	 * above 4G
 	 */
 	hi_mmio_num = 0;
+	memset(range, 0, sizeof(range));
 	for (i = 0; i < 8; i++) {
 		u32 reg;
 		u64 start;
@@ -130,16 +135,14 @@ static void __cpuinit get_fam10h_pci_mmc
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
@@ -191,10 +195,12 @@ void __cpuinit fam10h_check_enable_mmcfg
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
