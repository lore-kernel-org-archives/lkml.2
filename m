Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0C2HQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 03:16:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:22591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab0C2HQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 03:16:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,327,1267430400"; 
   d="scan'208";a="504480764"
Subject: [PATCH] x86, MCE, fix MSR_IA32_MCI_CTL2 CMCI threshold setup
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 15:16:40 +0800
Message-ID: <1269847000.1060.91.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is reported that CMCI is not raised when number of corrected error
reaches preset threshold. After inspection, it is found that
MSR_IA32_MCI_CTL2 threshold field is not setup properly. This patch
fixed it.

Reported-by: Shaohui Zheng <shaohui.zheng@intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/mce.h             |    3 +++
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 6c3fdd6..355f298 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -38,6 +38,9 @@
 #define MCM_ADDR_MEM	 3	/* memory address */
 #define MCM_ADDR_GENERIC 7	/* generic */
 
+/* CTL2 register defines */
+#define MCI_CTL2_THRESHOLD_MASK	0x7fff
+
 #define MCJ_CTX_MASK		3
 #define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
 #define MCJ_CTX_RANDOM		0    /* inject context: random */
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index d15df6e..ffe730d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -101,6 +101,7 @@ static void cmci_discover(int banks, int boot)
 			continue;
 		}
 
+		val &= ~MCI_CTL2_THRESHOLD_MASK;
 		val |= CMCI_EN | CMCI_THRESHOLD;
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);


