Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0FKGEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:04:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:46574 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab0FKGEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:04:20 -0400
Date: Fri, 11 Jun 2010 06:04:03 GMT
From: tip-bot for Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
       mingo@redhat.com, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de,
       shaohui.zheng@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
       tglx@linutronix.de, shaohui.zheng@intel.com
In-Reply-To: <1275977350.3444.660.camel@yhuang-dev.sh.intel.com>
References: <1275977350.3444.660.camel@yhuang-dev.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] x86, mce: Fix MSR_IA32_MCI_CTL2 CMCI threshold setup
Message-ID: <tip-3c417588603e5411f29d22a40f3b5ff71529a4f0@git.kernel.org>
Git-Commit-ID: 3c417588603e5411f29d22a40f3b5ff71529a4f0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Jun 2010 06:04:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c417588603e5411f29d22a40f3b5ff71529a4f0
Gitweb:     http://git.kernel.org/tip/3c417588603e5411f29d22a40f3b5ff71529a4f0
Author:     Huang Ying <ying.huang@intel.com>
AuthorDate: Tue, 8 Jun 2010 14:09:10 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 10 Jun 2010 21:27:36 -0700

x86, mce: Fix MSR_IA32_MCI_CTL2 CMCI threshold setup

It is reported that CMCI is not raised when number of corrected error
reaches preset threshold. After inspection, it is found that
MSR_IA32_MCI_CTL2 threshold field is not setup properly. This patch
fixed it.

Value of MCI_CTL2_CMCI_THRESHOLD_MASK is fixed according to x86_64
Software Developer's Manual too.

Reported-by: Shaohui Zheng <shaohui.zheng@intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
LKML-Reference: <1275977350.3444.660.camel@yhuang-dev.sh.intel.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/mce.h             |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 82db1d8..c62c13c 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -40,7 +40,7 @@
 
 /* CTL2 register defines */
 #define MCI_CTL2_CMCI_EN		(1ULL << 30)
-#define MCI_CTL2_CMCI_THRESHOLD_MASK	0xffffULL
+#define MCI_CTL2_CMCI_THRESHOLD_MASK	0x7fffULL
 
 #define MCJ_CTX_MASK		3
 #define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index faf7b29..6fcd093 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -102,6 +102,7 @@ static void cmci_discover(int banks, int boot)
 			continue;
 		}
 
+		val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
 		val |= MCI_CTL2_CMCI_EN | CMCI_THRESHOLD;
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
