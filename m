Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2HRRbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:31:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:22621 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab2HRRa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182607888"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/31] Disable const sections for PA-RISC
Date: Sat, 18 Aug 2012 10:29:52 -0700
Message-Id: <1345311022-26328-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The PA-RISC tool chain seems to have some problem with correct read/write
attributes on sections. This causes problems when the const sections
are fixed up for other architecture to only contain truly read-only
data.

Disable const sections for PA-RISC

This can cause a bit of noise with modpost.

Cc: James.Bottomley@HansenPartnership.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/parisc/Kconfig  |    4 ++++
 include/linux/init.h |   27 +++++++++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 3ff21b5..fbfeec9 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -243,6 +243,10 @@ config NODES_SHIFT
 	default "3"
 	depends on NEED_MULTIPLE_NODES
 
+config BROKEN_RODATA
+	bool
+	default y
+
 source "kernel/Kconfig.preempt"
 source "kernel/Kconfig.hz"
 source "mm/Kconfig"
diff --git a/include/linux/init.h b/include/linux/init.h
index 5e664f6..c2f06b3 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -43,10 +43,21 @@
    discard it in modules) */
 #define __init		__section(.init.text) __cold notrace
 #define __initdata	__section(.init.data)
-#define __initconst	__section(.init.rodata)
+#define __initconst	__constsection(.init.rodata)
 #define __exitdata	__section(.exit.data)
 #define __exit_call	__used __section(.exitcall.exit)
 
+/* 
+ * Some architecture have tool chains which do not handle rodata attributes
+ * correctly. For those disable special sections for const, so that other
+ * architectures can annotate correctly.
+ */
+#ifdef CONFIG_BROKEN_RODATA
+#define __constsection(x)
+#else
+#define __constsection(x) __section(x)
+#endif
+
 /*
  * modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a
@@ -66,7 +77,7 @@
  */
 #define __ref            __section(.ref.text) noinline
 #define __refdata        __section(.ref.data)
-#define __refconst       __section(.ref.rodata)
+#define __refconst       __constsection(.ref.rodata)
 
 /* compatibility defines */
 #define __init_refok     __ref
@@ -85,26 +96,26 @@
 /* Used for HOTPLUG */
 #define __devinit        __section(.devinit.text) __cold notrace
 #define __devinitdata    __section(.devinit.data)
-#define __devinitconst   __section(.devinit.rodata)
+#define __devinitconst   __constsection(.devinit.rodata)
 #define __devexit        __section(.devexit.text) __exitused __cold notrace
 #define __devexitdata    __section(.devexit.data)
-#define __devexitconst   __section(.devexit.rodata)
+#define __devexitconst   __constsection(.devexit.rodata)
 
 /* Used for HOTPLUG_CPU */
 #define __cpuinit        __section(.cpuinit.text) __cold notrace
 #define __cpuinitdata    __section(.cpuinit.data)
-#define __cpuinitconst   __section(.cpuinit.rodata)
+#define __cpuinitconst   __constsection(.cpuinit.rodata)
 #define __cpuexit        __section(.cpuexit.text) __exitused __cold notrace
 #define __cpuexitdata    __section(.cpuexit.data)
-#define __cpuexitconst   __section(.cpuexit.rodata)
+#define __cpuexitconst   __constsection(.cpuexit.rodata)
 
 /* Used for MEMORY_HOTPLUG */
 #define __meminit        __section(.meminit.text) __cold notrace
 #define __meminitdata    __section(.meminit.data)
-#define __meminitconst   __section(.meminit.rodata)
+#define __meminitconst   __constsection(.meminit.rodata)
 #define __memexit        __section(.memexit.text) __exitused __cold notrace
 #define __memexitdata    __section(.memexit.data)
-#define __memexitconst   __section(.memexit.rodata)
+#define __memexitconst   __constsection(.memexit.rodata)
 
 /* For assembly routines */
 #define __HEAD		.section	".head.text","ax"
-- 
1.7.7.6

