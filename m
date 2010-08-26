Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0HZXbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:31:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:58116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab0HZXbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:31:11 -0400
Date: Thu, 26 Aug 2010 23:30:43 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, konrad.wilk@oracle.com,
        fujita.tomonori@lab.ntt.co.jp, chrisw@sous-sol.org,
        jbarnes@virtuousgeek.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, yinghai@kernel.org,
        fujita.tomonori@lab.ntt.co.jp, chrisw@sous-sol.org,
        jbarnes@virtuousgeek.org, tglx@linutronix.de, hpa@linux.intel.com,
        len.brown@intel.com, David.Woodhouse@intel.com
In-Reply-To: <1282845485-8991-10-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-10-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86, VT-d: Make Intel VT-d IOMMU use IOMMU_INIT_* macros.
Message-ID: <tip-4db77ff3237a88ea74f691dd776e92b2f86a8f3f@git.kernel.org>
Git-Commit-ID: 4db77ff3237a88ea74f691dd776e92b2f86a8f3f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 23:30:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4db77ff3237a88ea74f691dd776e92b2f86a8f3f
Gitweb:     http://git.kernel.org/tip/4db77ff3237a88ea74f691dd776e92b2f86a8f3f
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Thu, 26 Aug 2010 13:58:04 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 26 Aug 2010 15:14:40 -0700

x86, VT-d: Make Intel VT-d IOMMU use IOMMU_INIT_* macros.

We utilize the IOMMU_INIT macros to create this dependency:

               [null]
                 |
       [pci_xen_swiotlb_detect]
                 |
       [pci_swiotlb_detect_override]
                 |
       [pci_swiotlb_detect_4gb]
                 |
         +-------+--------+---------------------+
        /                  \                     \
[detect_calgary]    [gart_iommu_hole_init]   [detect_intel_iommu]
                            |
                    [amd_iommu_detect]

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <1282845485-8991-10-git-send-email-konrad.wilk@oracle.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Woodhouse <David.Woodhouse@intel.com>
CC: Len Brown <len.brown@intel.com>
CC: Chris Wright <chrisw@sous-sol.org>
CC: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/pci/dmar.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 5fa64ea..4ef56a0 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -36,6 +36,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <asm/iommu_table.h>
 
 #define PREFIX "DMAR: "
 
@@ -724,7 +725,7 @@ int __init detect_intel_iommu(void)
 	early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
 	dmar_tbl = NULL;
 
-	return (ret ? 1 : -ENODEV);
+	return ret ? 1 : -ENODEV;
 }
 
 
@@ -1457,3 +1458,4 @@ int __init dmar_ir_support(void)
 		return 0;
 	return dmar->flags & 0x1;
 }
+IOMMU_INIT_POST(detect_intel_iommu);
