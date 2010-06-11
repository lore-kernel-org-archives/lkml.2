Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0FKGEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:04:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:46550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0FKGEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:04:00 -0400
Date: Fri, 11 Jun 2010 06:03:44 GMT
From: tip-bot for Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1275977348.3444.659.camel@yhuang-dev.sh.intel.com>
References: <1275977348.3444.659.camel@yhuang-dev.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] x86, mce: Rename MSR_IA32_MCx_CTL2 value
Message-ID: <tip-1f9a0bd4989fd16842ad71fc89240b48ab191446@git.kernel.org>
Git-Commit-ID: 1f9a0bd4989fd16842ad71fc89240b48ab191446
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Jun 2010 06:03:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f9a0bd4989fd16842ad71fc89240b48ab191446
Gitweb:     http://git.kernel.org/tip/1f9a0bd4989fd16842ad71fc89240b48ab191446
Author:     Huang Ying <ying.huang@intel.com>
AuthorDate: Tue, 8 Jun 2010 14:09:08 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 10 Jun 2010 21:27:26 -0700

x86, mce: Rename MSR_IA32_MCx_CTL2 value

Rename CMCI_EN to MCI_CTL2_CMCI_EN and CMCI_THRESHOLD_MASK to
MCI_CTL2_CMCI_THRESHOLD_MASK to make naming consistent.

Signed-off-by: Huang Ying <ying.huang@intel.com>
LKML-Reference: <1275977348.3444.659.camel@yhuang-dev.sh.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/mce.h             |    4 ++++
 arch/x86/include/asm/msr-index.h       |    3 ---
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    8 ++++----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index f32a430..82db1d8 100644
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
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b49d8ca..38f66eb 100644
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
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 62b48e4..faf7b29 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -95,19 +95,19 @@ static void cmci_discover(int banks, int boot)
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
