Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab1FVKQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:16:17 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:5082 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754197Ab1FVKQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:16:13 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0LN6SIX-01-8QX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
        <davidb@codeaurora.org>, <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] iommu/amd: Move missing parts to drivers/iommu
Date: Wed, 22 Jun 2011 12:16:46 +0200
Message-ID: <1308737806-2658-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308737806-2658-1-git-send-email-joerg.roedel@amd.com>
References: <1307742947-32118-1-git-send-email-ohad@wizery.com>
 <1308737806-2658-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few parts of the driver were missing in drivers/iommu.
Move them there to have the complete driver in that
directory.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/Makefile                           |    1 -
 drivers/iommu/Makefile                             |    2 +-
 drivers/iommu/amd_iommu.c                          |    7 ++++---
 .../x86/kernel => drivers/iommu}/amd_iommu_init.c  |    8 +++++---
 .../asm => drivers/iommu}/amd_iommu_proto.h        |    2 +-
 .../asm => drivers/iommu}/amd_iommu_types.h        |    0
 .../asm/amd_iommu.h => include/linux/amd-iommu.h   |    0
 7 files changed, 11 insertions(+), 9 deletions(-)
 rename {arch/x86/kernel => drivers/iommu}/amd_iommu_init.c (99%)
 rename {arch/x86/include/asm => drivers/iommu}/amd_iommu_proto.h (98%)
 rename {arch/x86/include/asm => drivers/iommu}/amd_iommu_types.h (100%)
 rename arch/x86/include/asm/amd_iommu.h => include/linux/amd-iommu.h (100%)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index aef0298..11817ff 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -123,7 +123,6 @@ ifeq ($(CONFIG_X86_64),y)
 
 	obj-$(CONFIG_GART_IOMMU)	+= amd_gart_64.o aperture_64.o
 	obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
-	obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o
 
 	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 	obj-y				+= vsmp_64.o
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 49e9c0f..4d4d77d 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
-obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o
+obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
 obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
 obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 7c3a95e..5aa12ea 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -27,13 +27,14 @@
 #include <linux/iommu-helper.h>
 #include <linux/iommu.h>
 #include <linux/delay.h>
+#include <linux/amd-iommu.h>
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/dma.h>
-#include <asm/amd_iommu_proto.h>
-#include <asm/amd_iommu_types.h>
-#include <asm/amd_iommu.h>
+
+#include "amd_iommu_proto.h"
+#include "amd_iommu_types.h"
 
 #define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
similarity index 99%
rename from arch/x86/kernel/amd_iommu_init.c
rename to drivers/iommu/amd_iommu_init.c
index bfc8453..82d2410 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -24,14 +24,16 @@
 #include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
 #include <linux/msi.h>
+#include <linux/amd-iommu.h>
 #include <asm/pci-direct.h>
-#include <asm/amd_iommu_proto.h>
-#include <asm/amd_iommu_types.h>
-#include <asm/amd_iommu.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/x86_init.h>
 #include <asm/iommu_table.h>
+
+#include "amd_iommu_proto.h"
+#include "amd_iommu_types.h"
+
 /*
  * definitions for the ACPI scanning code
  */
diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
similarity index 98%
rename from arch/x86/include/asm/amd_iommu_proto.h
rename to drivers/iommu/amd_iommu_proto.h
index 55d95eb..7ffaa64 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -19,7 +19,7 @@
 #ifndef _ASM_X86_AMD_IOMMU_PROTO_H
 #define _ASM_X86_AMD_IOMMU_PROTO_H
 
-#include <asm/amd_iommu_types.h>
+#include "amd_iommu_types.h"
 
 extern int amd_iommu_init_dma_ops(void);
 extern int amd_iommu_init_passthrough(void);
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
similarity index 100%
rename from arch/x86/include/asm/amd_iommu_types.h
rename to drivers/iommu/amd_iommu_types.h
diff --git a/arch/x86/include/asm/amd_iommu.h b/include/linux/amd-iommu.h
similarity index 100%
rename from arch/x86/include/asm/amd_iommu.h
rename to include/linux/amd-iommu.h
-- 
1.7.4.1


