Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0HZXaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:30:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:58084 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab0HZXav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:30:51 -0400
Date: Thu, 26 Aug 2010 23:30:22 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, joerg.roedel@amd.com,
        fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, joerg.roedel@amd.com,
        fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1282845485-8991-9-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-9-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86, GART/AMD-VI: Make AMD GART and IOMMU use IOMMU_INIT_* macros.
Message-ID: <tip-22e6daf41ba28ddc06295e42859b266f737b3e99@git.kernel.org>
Git-Commit-ID: 22e6daf41ba28ddc06295e42859b266f737b3e99
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 23:30:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22e6daf41ba28ddc06295e42859b266f737b3e99
Gitweb:     http://git.kernel.org/tip/22e6daf41ba28ddc06295e42859b266f737b3e99
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Thu, 26 Aug 2010 13:58:03 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 26 Aug 2010 15:14:30 -0700

x86, GART/AMD-VI: Make AMD GART and IOMMU use IOMMU_INIT_* macros.

We utilize the IOMMU_INIT macros to create this dependency:

               [null]
                 |
       [pci_xen_swiotlb_detect]
                 |
       [pci_swiotlb_detect_override]
                 |
       [pci_swiotlb_detect_4gb]
                 |
         +-------+--------+
        /                  \
[detect_calgary]    [gart_iommu_hole_init]
                            |
                    [amd_iommu_detect]

Meaning that 'amd_iommu_detect' will be called after
'gart_iommu_hole_init'.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <1282845485-8991-9-git-send-email-konrad.wilk@oracle.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Joerg Roedel <joerg.roedel@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/amd_iommu_init.c |    7 ++++++-
 arch/x86/kernel/pci-gart_64.c    |    2 ++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 0b9e2dc..26a5e43 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -31,7 +31,7 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/x86_init.h>
-
+#include <asm/iommu_table.h>
 /*
  * definitions for the ACPI scanning code
  */
@@ -1430,3 +1430,8 @@ static int __init parse_amd_iommu_options(char *str)
 
 __setup("amd_iommu_dump", parse_amd_iommu_dump);
 __setup("amd_iommu=", parse_amd_iommu_options);
+
+IOMMU_INIT_FINISH(amd_iommu_detect,
+		  gart_iommu_hole_init,
+		  0,
+		  0);
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 0f7f130..de9734b 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -41,6 +41,7 @@
 #include <asm/dma.h>
 #include <asm/k8.h>
 #include <asm/x86_init.h>
+#include <asm/iommu_table.h>
 
 static unsigned long iommu_bus_base;	/* GART remapping area (physical) */
 static unsigned long iommu_size;	/* size of remapping area bytes */
@@ -896,3 +897,4 @@ void __init gart_parse_options(char *p)
 		}
 	}
 }
+IOMMU_INIT_POST(gart_iommu_hole_init);
