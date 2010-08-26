Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0HZX3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:29:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:57979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab0HZX3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:29:46 -0400
Date: Thu, 26 Aug 2010 23:29:19 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, fujita.tomonori@lab.ntt.co.jp,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, fujita.tomonori@lab.ntt.co.jp,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1282845485-8991-6-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-6-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86, swiotlb: Make SWIOTLB use IOMMU_INIT_* macros.
Message-ID: <tip-c116c5457c46edb767df6f4e36d4905e3514ad37@git.kernel.org>
Git-Commit-ID: c116c5457c46edb767df6f4e36d4905e3514ad37
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 23:29:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c116c5457c46edb767df6f4e36d4905e3514ad37
Gitweb:     http://git.kernel.org/tip/c116c5457c46edb767df6f4e36d4905e3514ad37
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Thu, 26 Aug 2010 13:58:00 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 26 Aug 2010 15:13:37 -0700

x86, swiotlb: Make SWIOTLB use IOMMU_INIT_* macros.

We utilize the IOMMU_INIT macros to create this dependency:

       [pci_xen_swiotlb_detect]
                 |
       [pci_swiotlb_detect_override]
                 |
       [pci_swiotlb_detect_4gb]

And set the SWIOTLB IOMMU_INIT to utilize 'pci_swiotlb_init'
for .init and 'pci_swiotlb_late_init' for .late_init.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <1282845485-8991-6-git-send-email-konrad.wilk@oracle.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/pci-swiotlb.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index c7a72fa..8f972cb 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -10,7 +10,8 @@
 #include <asm/iommu.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
-
+#include <asm/xen/swiotlb-xen.h>
+#include <asm/iommu_table.h>
 int swiotlb __read_mostly;
 
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
@@ -55,6 +56,10 @@ int __init pci_swiotlb_detect_override(void)
 
 	return use_swiotlb;
 }
+IOMMU_INIT_FINISH(pci_swiotlb_detect_override,
+		  pci_xen_swiotlb_detect,
+		  pci_swiotlb_init,
+		  pci_swiotlb_late_init);
 
 /*
  * if 4GB or more detected (and iommu=off not set) return 1
@@ -69,6 +74,10 @@ int __init pci_swiotlb_detect_4gb(void)
 #endif
 	return swiotlb;
 }
+IOMMU_INIT(pci_swiotlb_detect_4gb,
+	   pci_swiotlb_detect_override,
+	   pci_swiotlb_init,
+	   pci_swiotlb_late_init);
 
 void __init pci_swiotlb_init(void)
 {
