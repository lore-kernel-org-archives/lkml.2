Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0EaHJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:09:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:29510 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab0EaHJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,331,1272870000"; 
   d="scan'208";a="571922572"
Subject: [PATCH 2/2] x86, MCE, fix MSR_IA32_MCI_CTL2 CMCI threshold setup
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Huang@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ying <ying.huang@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 15:09:13 +0800
Message-ID: <1275289753.3444.443.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is reported that CMCI is not raised when number of corrected error
reaches preset threshold. After inspection, it is found that
MSR_IA32_MCI_CTL2 threshold field is not setup properly. This patch
fixed it.

Value of MCI_CTL2_CMCI_THRESHOLD_MASK is fixed according to x86_64
Software Developer's Manual too.

Reported-by: Shaohui Zheng <shaohui.zheng@intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h             |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -40,7 +40,7 @@
 
 /* CTL2 register defines */
 #define MCI_CTL2_CMCI_EN		(1ULL << 30)
-#define MCI_CTL2_CMCI_THRESHOLD_MASK	0xffffULL
+#define MCI_CTL2_CMCI_THRESHOLD_MASK	0x7fffULL
 
 #define MCJ_CTX_MASK		3
 #define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -102,6 +102,7 @@ static void cmci_discover(int banks, int
 			continue;
 		}
 
+		val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
 		val |= MCI_CTL2_CMCI_EN | CMCI_THRESHOLD;
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);


