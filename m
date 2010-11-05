Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab0KEK7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 06:59:14 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50568 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0KEK7L convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Fri, 5 Nov 2010 06:59:11 -0400
Message-Id: <4CD3F18E0200007800020B6D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 05 Nov 2010 10:59:10 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Yinghai Lu" <yinghai@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: more fixes and cleanup to AMD Fam10 MMCONF
	 enabling
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately it turned out the original code had more issues: We want
to place the region above 4G in any case (even if TOM2 isn't enabled
or invalid), and the base mask definition was improperly typed (thus
causing shifts by FAM10H_MMIO_CONF_BASE_SHIFT to produce other than
the intended result). Fixing this in turn allowed simplifying the MMIO
region detection code, as regions ending below TOM2 now aren't of
interest anymore.

This will only apply cleanly on top of yesterday's patch titled
"x86-64: fix and clean up AMD Fam10 MMCONF enabling".

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/msr-index.h   |    2 +-
 arch/x86/kernel/mmconf-fam10h_64.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- 2.6.37-rc1/arch/x86/include/asm/msr-index.h
+++ 2.6.37-rc1-x86_64-mmconf-fam10h/arch/x86/include/asm/msr-index.h
@@ -128,7 +128,7 @@
 #define FAM10H_MMIO_CONF_ENABLE		(1<<0)
 #define FAM10H_MMIO_CONF_BUSRANGE_MASK	0xf
 #define FAM10H_MMIO_CONF_BUSRANGE_SHIFT 2
-#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffff
+#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
 
--- 2.6.37-rc1-x86_64-mmconf-fam10h.orig/arch/x86/kernel/mmconf-fam10h_64.c
+++ 2.6.37-rc1-x86_64-mmconf-fam10h/arch/x86/kernel/mmconf-fam10h_64.c
@@ -43,7 +43,7 @@ static int __cpuinit cmp_range(const voi
 	return start1 - start2;
 }
 
-#define UNIT (1ULL << (5 + 3 + 12))
+#define UNIT (1ULL << FAM10H_MMIO_CONF_BASE_SHIFT)
 #define MASK (~(UNIT - 1))
 #define SIZE (UNIT << 8)
 /* need to avoid (0xfd<<32) and (0xfe<<32), ht used space */
@@ -99,12 +99,12 @@ static void __cpuinit get_fam10h_pci_mmc
 
 	/* TOP_MEM2 is not enabled? */
 	if (!(val & (1<<21))) {
-		tom2 = 0;
+		tom2 = 1ULL << 32;
 	} else {
 		/* TOP_MEM2 */
 		address = MSR_K8_TOP_MEM2;
 		rdmsrl(address, val);
-		tom2 = val & 0xffffff800000ULL;
+		tom2 = max(val & 0xffffff800000ULL, 1ULL << 32);
 	}
 
 	if (base <= tom2)
@@ -127,7 +127,7 @@ static void __cpuinit get_fam10h_pci_mmc
 		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
 		end = ((u64)(reg & 0xffffff00) << 8) | 0xffff; /* 39:16 on 31:8*/
 
-		if (!end)
+		if (end < tom2)
 			continue;
 
 		range[hi_mmio_num].start = start;
@@ -151,13 +151,13 @@ static void __cpuinit get_fam10h_pci_mmc
 	if ((base > tom2) && BASE_VALID(base))
 		goto out;
 	base = (range[hi_mmio_num - 1].end + UNIT) & MASK;
-	if ((base > tom2) && BASE_VALID(base))
+	if (BASE_VALID(base))
 		goto out;
 	/* need to find window between ranges */
 	for (i = 1; i < hi_mmio_num; i++) {
 		base = (range[i - 1].end + UNIT) & MASK;
 		val = range[i].start & MASK;
-		if (val >= base + SIZE && base > tom2 && BASE_VALID(base))
+		if (val >= base + SIZE && BASE_VALID(base))
 			goto out;
 	}
 	return;



