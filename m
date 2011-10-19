Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab1JSOw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:52:57 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38440 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab1JSOvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:51:31 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/9] x86, RAS: Move MCE decoding code into ras/
Date: Wed, 19 Oct 2011 16:51:00 +0200
Message-Id: <1319035866-29570-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1319035866-29570-1-git-send-email-bp@amd64.org>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Move the MCE decoding code into arch/x86/.../ras/.

No functionality change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 .../x86/include/ras/amd/mce-decode.h               |    0
 arch/x86/kernel/cpu/ras/Kconfig                    |   12 ++++++++++++
 arch/x86/kernel/cpu/ras/amd/Makefile               |    3 +++
 .../x86/kernel/cpu/ras/amd/mce-decode.c            |    2 +-
 drivers/edac/Kconfig                               |   12 ------------
 drivers/edac/Makefile                              |    3 ---
 drivers/edac/amd64_edac.h                          |    2 +-
 drivers/edac/mce_amd_inj.c                         |    3 +--
 8 files changed, 18 insertions(+), 19 deletions(-)
 rename drivers/edac/mce_amd.h => arch/x86/include/ras/amd/mce-decode.h (100%)
 rename drivers/edac/mce_amd.c => arch/x86/kernel/cpu/ras/amd/mce-decode.c (99%)

diff --git a/drivers/edac/mce_amd.h b/arch/x86/include/ras/amd/mce-decode.h
similarity index 100%
rename from drivers/edac/mce_amd.h
rename to arch/x86/include/ras/amd/mce-decode.h
diff --git a/arch/x86/kernel/cpu/ras/Kconfig b/arch/x86/kernel/cpu/ras/Kconfig
index e58c4ea..440d6a1 100644
--- a/arch/x86/kernel/cpu/ras/Kconfig
+++ b/arch/x86/kernel/cpu/ras/Kconfig
@@ -11,6 +11,18 @@ config X86_AMD_ERROR_THRESHOLDING
 	   detailed information see the section on Error Thresholding in
 	   the respective AMD BKDG.
 
+config X86_AMD_DECODE_MCE
+	tristate "Decode MCEs in human-readable form"
+	default y
+	---help---
+	  Enable this option if you want to decode Machine Check Exceptions
+	  occurring on your machine in a human-readable form.
+
+	  You should definitely say Y here in case you want to decode MCEs
+	  which occur really early upon boot, before the module infrastructure
+	  has been initialized.
+
+
 endmenu
 
 
diff --git a/arch/x86/kernel/cpu/ras/amd/Makefile b/arch/x86/kernel/cpu/ras/amd/Makefile
index 3c1678f..a18207b 100644
--- a/arch/x86/kernel/cpu/ras/amd/Makefile
+++ b/arch/x86/kernel/cpu/ras/amd/Makefile
@@ -1 +1,4 @@
 obj-$(CONFIG_X86_AMD_ERROR_THRESHOLDING)	+= thresholding.o
+
+amd_mce_decode-y				:= mce-decode.o
+obj-$(CONFIG_X86_AMD_DECODE_MCE)		+= amd_mce_decode.o
diff --git a/drivers/edac/mce_amd.c b/arch/x86/kernel/cpu/ras/amd/mce-decode.c
similarity index 99%
rename from drivers/edac/mce_amd.c
rename to arch/x86/kernel/cpu/ras/amd/mce-decode.c
index 795cfbc..e435779 100644
--- a/drivers/edac/mce_amd.c
+++ b/arch/x86/kernel/cpu/ras/amd/mce-decode.c
@@ -1,7 +1,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
-#include "mce_amd.h"
+#include <ras/amd/mce-decode.h>
 
 static struct amd_decoder_ops *fam_ops;
 
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index af1a17d..8de46e7 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -39,18 +39,6 @@ config EDAC_DEBUG
 	  there're four debug levels (x=0,1,2,3 from low to high).
 	  Usually you should select 'N'.
 
-config EDAC_DECODE_MCE
-	tristate "Decode MCEs in human-readable form (only on AMD for now)"
-	depends on CPU_SUP_AMD && X86_MCE
-	default y
-	---help---
-	  Enable this option if you want to decode Machine Check Exceptions
-	  occurring on your machine in human-readable form.
-
-	  You should definitely say Y here in case you want to decode MCEs
-	  which occur really early upon boot, before the module infrastructure
-	  has been initialized.
-
 config EDAC_MCE_INJ
 	tristate "Simple MCE injection interface over /sysfs"
 	depends on EDAC_DECODE_MCE
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 3e23913..a6f10c2 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -19,9 +19,6 @@ endif
 
 obj-$(CONFIG_EDAC_MCE_INJ)		+= mce_amd_inj.o
 
-edac_mce_amd-y				:= mce_amd.o
-obj-$(CONFIG_EDAC_DECODE_MCE)		+= edac_mce_amd.o
-
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
 obj-$(CONFIG_EDAC_CPC925)		+= cpc925_edac.o
 obj-$(CONFIG_EDAC_I5000)		+= i5000_edac.o
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 9a666cb..cd4232a 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -71,8 +71,8 @@
 #include <linux/mmzone.h>
 #include <linux/edac.h>
 #include <asm/msr.h>
+#include <ras/amd/mce-decode.h>
 #include "edac_core.h"
-#include "mce_amd.h"
 
 #define amd64_debug(fmt, arg...) \
 	edac_printk(KERN_DEBUG, "amd64", fmt, ##arg)
diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index a4987e0..a38806a 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -14,8 +14,7 @@
 #include <linux/sysdev.h>
 #include <linux/edac.h>
 #include <asm/mce.h>
-
-#include "mce_amd.h"
+#include <ras/amd/mce-decode.h>
 
 struct edac_mce_attr {
 	struct attribute attr;
-- 
1.7.4.rc2

