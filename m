Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab0KROOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:14:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:52280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636Ab0KROOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:14:52 -0500
Date: Thu, 18 Nov 2010 14:14:31 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, andreas.herrmann3@amd.com, jbeulich@novell.com,
        JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jbeulich@novell.com, andreas.herrmann3@amd.com,
        JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4CE24DF40200007800022737@vpn.id2.novell.com>
References: <4CE24DF40200007800022737@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64: Fix and clean up AMD Fam10 MMCONF enabling
Message-ID: <tip-37db6c8f1d0c4b8f01dc049f3a893b725288660f@git.kernel.org>
Git-Commit-ID: 37db6c8f1d0c4b8f01dc049f3a893b725288660f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:14:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37db6c8f1d0c4b8f01dc049f3a893b725288660f
Gitweb:     http://git.kernel.org/tip/37db6c8f1d0c4b8f01dc049f3a893b725288660f
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 16 Nov 2010 08:25:08 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:41:35 +0100

x86-64: Fix and clean up AMD Fam10 MMCONF enabling

Candidate memory ranges were not calculated properly (start
addresses got needlessly rounded down, and end addresses didn't
get rounded up at all), address comparison for secondary CPUs
was done on only part of the address, and disabled status wasn't
tracked properly.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <4CE24DF40200007800022737@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/msr-index.h   |    2 +-
 arch/x86/kernel/mmconf-fam10h_64.c |   64 +++++++++++++++++-------------------
 2 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ea3dc4..6b89f5e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -128,7 +128,7 @@
 #define FAM10H_MMIO_CONF_ENABLE		(1<<0)
 #define FAM10H_MMIO_CONF_BUSRANGE_MASK	0xf
 #define FAM10H_MMIO_CONF_BUSRANGE_SHIFT 2
-#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffff
+#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
 
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index 6da143c..ac861b8 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -25,7 +25,6 @@ struct pci_hostbridge_probe {
 };
 
 static u64 __cpuinitdata fam10h_pci_mmconf_base;
-static int __cpuinitdata fam10h_pci_mmconf_base_status;
 
 static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
 	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
@@ -44,10 +43,12 @@ static int __cpuinit cmp_range(const void *x1, const void *x2)
 	return start1 - start2;
 }
 
-/*[47:0] */
-/* need to avoid (0xfd<<32) and (0xfe<<32), ht used space */
+#define MMCONF_UNIT (1ULL << FAM10H_MMIO_CONF_BASE_SHIFT)
+#define MMCONF_MASK (~(MMCONF_UNIT - 1))
+#define MMCONF_SIZE (MMCONF_UNIT << 8)
+/* need to avoid (0xfd<<32), (0xfe<<32), and (0xff<<32), ht used space */
 #define FAM10H_PCI_MMCONF_BASE (0xfcULL<<32)
-#define BASE_VALID(b) ((b != (0xfdULL << 32)) && (b != (0xfeULL << 32)))
+#define BASE_VALID(b) ((b) + MMCONF_SIZE <= (0xfdULL<<32) || (b) >= (1ULL<<40))
 static void __cpuinit get_fam10h_pci_mmconf_base(void)
 {
 	int i;
@@ -64,12 +65,11 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 	struct range range[8];
 
 	/* only try to get setting from BSP */
-	/* -1 or 1 */
-	if (fam10h_pci_mmconf_base_status)
+	if (fam10h_pci_mmconf_base)
 		return;
 
 	if (!early_pci_allowed())
-		goto fail;
+		return;
 
 	found = 0;
 	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
@@ -91,7 +91,7 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 	}
 
 	if (!found)
-		goto fail;
+		return;
 
 	/* SYS_CFG */
 	address = MSR_K8_SYSCFG;
@@ -99,16 +99,16 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 
 	/* TOP_MEM2 is not enabled? */
 	if (!(val & (1<<21))) {
-		tom2 = 0;
+		tom2 = 1ULL << 32;
 	} else {
 		/* TOP_MEM2 */
 		address = MSR_K8_TOP_MEM2;
 		rdmsrl(address, val);
-		tom2 = val & (0xffffULL<<32);
+		tom2 = max(val & 0xffffff800000ULL, 1ULL << 32);
 	}
 
 	if (base <= tom2)
-		base = tom2 + (1ULL<<32);
+		base = (tom2 + 2 * MMCONF_UNIT - 1) & MMCONF_MASK;
 
 	/*
 	 * need to check if the range is in the high mmio range that is
@@ -123,11 +123,11 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 		if (!(reg & 3))
 			continue;
 
-		start = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
+		start = (u64)(reg & 0xffffff00) << 8; /* 39:16 on 31:8*/
 		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
-		end = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
+		end = ((u64)(reg & 0xffffff00) << 8) | 0xffff; /* 39:16 on 31:8*/
 
-		if (!end)
+		if (end < tom2)
 			continue;
 
 		range[hi_mmio_num].start = start;
@@ -143,32 +143,27 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 
 	if (range[hi_mmio_num - 1].end < base)
 		goto out;
-	if (range[0].start > base)
+	if (range[0].start > base + MMCONF_SIZE)
 		goto out;
 
 	/* need to find one window */
-	base = range[0].start - (1ULL << 32);
+	base = (range[0].start & MMCONF_MASK) - MMCONF_UNIT;
 	if ((base > tom2) && BASE_VALID(base))
 		goto out;
-	base = range[hi_mmio_num - 1].end + (1ULL << 32);
-	if ((base > tom2) && BASE_VALID(base))
+	base = (range[hi_mmio_num - 1].end + MMCONF_UNIT) & MMCONF_MASK;
+	if (BASE_VALID(base))
 		goto out;
 	/* need to find window between ranges */
-	if (hi_mmio_num > 1)
-	for (i = 0; i < hi_mmio_num - 1; i++) {
-		if (range[i + 1].start > (range[i].end + (1ULL << 32))) {
-			base = range[i].end + (1ULL << 32);
-			if ((base > tom2) && BASE_VALID(base))
-				goto out;
-		}
+	for (i = 1; i < hi_mmio_num; i++) {
+		base = (range[i - 1].end + MMCONF_UNIT) & MMCONF_MASK;
+		val = range[i].start & MMCONF_MASK;
+		if (val >= base + MMCONF_SIZE && BASE_VALID(base))
+			goto out;
 	}
-
-fail:
-	fam10h_pci_mmconf_base_status = -1;
 	return;
+
 out:
 	fam10h_pci_mmconf_base = base;
-	fam10h_pci_mmconf_base_status = 1;
 }
 
 void __cpuinit fam10h_check_enable_mmcfg(void)
@@ -190,11 +185,10 @@ void __cpuinit fam10h_check_enable_mmcfg(void)
 
 		/* only trust the one handle 256 buses, if acpi=off */
 		if (!acpi_pci_disabled || busnbits >= 8) {
-			u64 base;
-			base = val & (0xffffULL << 32);
-			if (fam10h_pci_mmconf_base_status <= 0) {
+			u64 base = val & MMCONF_MASK;
+
+			if (!fam10h_pci_mmconf_base) {
 				fam10h_pci_mmconf_base = base;
-				fam10h_pci_mmconf_base_status = 1;
 				return;
 			} else if (fam10h_pci_mmconf_base ==  base)
 				return;
@@ -206,8 +200,10 @@ void __cpuinit fam10h_check_enable_mmcfg(void)
 	 * with 256 buses
 	 */
 	get_fam10h_pci_mmconf_base();
-	if (fam10h_pci_mmconf_base_status <= 0)
+	if (!fam10h_pci_mmconf_base) {
+		pci_probe &= ~PCI_CHECK_ENABLE_AMD_MMCONF;
 		return;
+	}
 
 	printk(KERN_INFO "Enable MMCONFIG on AMD Family 10h\n");
 	val &= ~((FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT) |
