Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab0EaHJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:09:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:29510 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab0EaHJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:09:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,331,1272870000"; 
   d="scan'208";a="803320985"
Subject: [PATCH 1/2] x86, MCE, rename MSR_IA32_MCx_CTL2 value
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Huang@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ying <ying.huang@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 15:09:10 +0800
Message-ID: <1275289750.3444.442.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CMCI_EN to MCI_CTL2_CMCI_EN and CMCI_THRESHOLD_MASK to
MCI_CTL2_CMCI_THRESHOLD_MASK to make naming consistent.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/mce.h             |    4 ++++
 arch/x86/include/asm/msr-index.h       |    3 ---
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    8 ++++----
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -38,6 +38,10 @@
 #define MCM_ADDR_MEM	 3	/* memory address */
 #define MCM_ADDR_GENERIC 7	/* generic */
 
+/* CTL2 register defines */
+#define MCI_CTL2_CMCI_EN		(1ULL << 30)
+#define MCI_CTL2_CMCI_THRESHOLD_MASK	0xffffULL
+
 #define MCJ_CTX_MASK		3
 #define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
 #define MCJ_CTX_RANDOM		0    /* inject context: random */
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -94,9 +94,6 @@
 #define MSR_IA32_MC0_CTL2		0x00000280
 #define MSR_IA32_MCx_CTL2(x)		(MSR_IA32_MC0_CTL2 + (x))
 
-#define CMCI_EN			(1ULL << 30)
-#define CMCI_THRESHOLD_MASK		0xffffULL
-
 #define MSR_P6_PERFCTR0			0x000000c1
 #define MSR_P6_PERFCTR1			0x000000c2
 #define MSR_P6_EVNTSEL0			0x00000186
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -95,19 +95,19 @@ static void cmci_discover(int banks, int
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
 
 		/* Already owned by someone else? */
-		if (val & CMCI_EN) {
+		if (val & MCI_CTL2_CMCI_EN) {
 			if (test_and_clear_bit(i, owned) && !boot)
 				print_update("SHD", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 			continue;
 		}
 
-		val |= CMCI_EN | CMCI_THRESHOLD;
+		val |= MCI_CTL2_CMCI_EN | CMCI_THRESHOLD;
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
 
 		/* Did the enable bit stick? -- the bank supports CMCI */
-		if (val & CMCI_EN) {
+		if (val & MCI_CTL2_CMCI_EN) {
 			if (!test_and_set_bit(i, owned) && !boot)
 				print_update("CMCI", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
@@ -155,7 +155,7 @@ void cmci_clear(void)
 			continue;
 		/* Disable CMCI */
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
-		val &= ~(CMCI_EN|CMCI_THRESHOLD_MASK);
+		val &= ~(MCI_CTL2_CMCI_EN|MCI_CTL2_CMCI_THRESHOLD_MASK);
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}


