Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1FBWbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:31:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51844 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1FBWbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:31:12 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: <laurent.pinchart@ideasonboard.com>, <Hiroshi.DOYU@nokia.com>,
        <arnd@arndb.de>, <davidb@codeaurora.org>, <Joerg.Roedel@amd.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 5/6] omap: iommu/iovmm: move to dedicated iommu folder
Date: Fri,  3 Jun 2011 01:27:42 +0300
Message-Id: <1307053663-24572-6-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307053663-24572-1-git-send-email-ohad@wizery.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move OMAP's iommu drivers to the dedicated iommu drivers folder.

While OMAP's iovmm (virtual memory manager) driver does not strictly
belong to the iommu drivers folder, move it there as well, because
it's by no means OMAP-specific (in concept. technically it is still
coupled with the omap iommu), and exposing it will ease its generalization,
consolidation, or removal (once a generic virtual memory manager and allocator
would materialize).

Move omap's iommu debug driver to the generic folder as well, for the
same reasons.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/plat-omap/Kconfig                         |   14 --------------
 arch/arm/plat-omap/Makefile                        |    2 --
 arch/arm/plat-omap/{ => include/plat}/iopgtable.h  |    0
 drivers/iommu/Kconfig                              |   18 ++++++++++++++++++
 drivers/iommu/Makefile                             |    3 +++
 .../iommu/omap-iommu-debug.c                       |    2 +-
 .../iommu.c => drivers/iommu/omap-iommu.c          |    2 +-
 .../iovmm.c => drivers/iommu/omap-iovmm.c          |    2 +-
 drivers/media/video/Kconfig                        |    2 +-
 9 files changed, 25 insertions(+), 20 deletions(-)
 rename arch/arm/plat-omap/{ => include/plat}/iopgtable.h (100%)
 rename arch/arm/plat-omap/iommu-debug.c => drivers/iommu/omap-iommu-debug.c (99%)
 rename arch/arm/plat-omap/iommu.c => drivers/iommu/omap-iommu.c (99%)
 rename arch/arm/plat-omap/iovmm.c => drivers/iommu/omap-iovmm.c (99%)

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 1bb1981..14f067f 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -131,20 +131,6 @@ config OMAP_MBOX_KFIFO_SIZE
 	  This can also be changed at runtime (via the mbox_kfifo_size
 	  module parameter).
 
-#can't be tristate; iommu api doesn't support un-registration
-config OMAP_IOMMU
-	bool
-	select IOMMU_API
-
-config OMAP_IOMMU_DEBUG
-       tristate "Export OMAP IOMMU internals in DebugFS"
-       depends on OMAP_IOMMU && DEBUG_FS
-       help
-         Select this to see extensive information about
-         the internal state of OMAP IOMMU in debugfs.
-
-         Say N unless you know you need this.
-
 config OMAP_IOMMU_IVA2
 	bool
 
diff --git a/arch/arm/plat-omap/Makefile b/arch/arm/plat-omap/Makefile
index f0233e6..9852622 100644
--- a/arch/arm/plat-omap/Makefile
+++ b/arch/arm/plat-omap/Makefile
@@ -18,8 +18,6 @@ obj-$(CONFIG_ARCH_OMAP3) += omap_device.o
 obj-$(CONFIG_ARCH_OMAP4) += omap_device.o
 
 obj-$(CONFIG_OMAP_MCBSP) += mcbsp.o
-obj-$(CONFIG_OMAP_IOMMU) += iommu.o iovmm.o
-obj-$(CONFIG_OMAP_IOMMU_DEBUG) += iommu-debug.o
 
 obj-$(CONFIG_CPU_FREQ) += cpu-omap.o
 obj-$(CONFIG_OMAP_DM_TIMER) += dmtimer.o
diff --git a/arch/arm/plat-omap/iopgtable.h b/arch/arm/plat-omap/include/plat/iopgtable.h
similarity index 100%
rename from arch/arm/plat-omap/iopgtable.h
rename to arch/arm/plat-omap/include/plat/iopgtable.h
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 2c5dfb4..57378ac 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -1,3 +1,21 @@
 # IOMMU_API always gets selected by whoever wants it.
 config IOMMU_API
 	bool
+
+# can't be tristate; iommu api doesn't support un-registration
+config OMAP_IOMMU
+	bool
+	select IOMMU_API
+
+config OMAP_IOVMM
+	tristate
+	select OMAP_IOMMU
+
+config OMAP_IOMMU_DEBUG
+       tristate "Export OMAP IOMMU internals in DebugFS"
+       depends on OMAP_IOVMM && DEBUG_FS
+       help
+         Select this to see extensive information about
+         the internal state of OMAP IOMMU in debugfs.
+
+         Say N unless you know you need this.
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 241ba4c..c094875 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1 +1,4 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
+obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
+obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
+obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
diff --git a/arch/arm/plat-omap/iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
similarity index 99%
rename from arch/arm/plat-omap/iommu-debug.c
rename to drivers/iommu/omap-iommu-debug.c
index f07cf2f..0f8c8dd 100644
--- a/arch/arm/plat-omap/iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -21,7 +21,7 @@
 #include <plat/iommu.h>
 #include <plat/iovmm.h>
 
-#include "iopgtable.h"
+#include <plat/iopgtable.h>
 
 #define MAXCOLUMN 100 /* for short messages */
 
diff --git a/arch/arm/plat-omap/iommu.c b/drivers/iommu/omap-iommu.c
similarity index 99%
rename from arch/arm/plat-omap/iommu.c
rename to drivers/iommu/omap-iommu.c
index f06e99c..1526fea 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -25,7 +25,7 @@
 
 #include <plat/iommu.h>
 
-#include "iopgtable.h"
+#include <plat/iopgtable.h>
 
 #define for_each_iotlb_cr(obj, n, __i, cr)				\
 	for (__i = 0;							\
diff --git a/arch/arm/plat-omap/iovmm.c b/drivers/iommu/omap-iovmm.c
similarity index 99%
rename from arch/arm/plat-omap/iovmm.c
rename to drivers/iommu/omap-iovmm.c
index 80bb2b6..42f4a2c 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -23,7 +23,7 @@
 #include <plat/iommu.h>
 #include <plat/iovmm.h>
 
-#include "iopgtable.h"
+#include <plat/iopgtable.h>
 
 /*
  * A device driver needs to create address mappings between:
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index bb53de7..4945f91 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -761,7 +761,7 @@ source "drivers/media/video/m5mols/Kconfig"
 
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
-	select OMAP_IOMMU
+	select OMAP_IOVMM
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3 && EXPERIMENTAL
 	---help---
 	  Driver for an OMAP 3 camera controller.
-- 
1.7.1

