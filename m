Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab2JHRLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:11:55 -0400
Received: from mail.x86-64.org ([217.9.48.20]:60585 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab2JHRLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:11:48 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/6] x86, RAS: Move AMD MCE injection code into ras/
Date: Mon,  8 Oct 2012 19:11:29 +0200
Message-Id: <1349716293-16723-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349716293-16723-1-git-send-email-bp@amd64.org>
References: <1349716293-16723-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is the code collecting all AMD MCE injection methods.

No functionality change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/Kconfig                                            |  2 ++
 arch/x86/ras/Kconfig                                        | 11 +++++++++++
 arch/x86/ras/Makefile                                       |  3 ++-
 arch/x86/ras/amd/Makefile                                   |  3 +++
 drivers/edac/mce_amd_inj.c => arch/x86/ras/amd/mce-inject.c |  2 +-
 drivers/edac/Kconfig                                        | 10 ----------
 6 files changed, 19 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/ras/Kconfig
 create mode 100644 arch/x86/ras/amd/Makefile
 rename drivers/edac/mce_amd_inj.c => arch/x86/ras/amd/mce-inject.c (99%)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e5cae3de52ff..85f666390b5e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -695,6 +695,8 @@ config X86_RAS
 	features which enable hardware error logging and reporting. Leave it
 	at 'y' unless you really know what you're doing.
 
+source "arch/x86/ras/Kconfig"
+
 source "arch/x86/Kconfig.cpu"
 
 config HPET_TIMER
diff --git a/arch/x86/ras/Kconfig b/arch/x86/ras/Kconfig
new file mode 100644
index 000000000000..9362f54bfe0f
--- /dev/null
+++ b/arch/x86/ras/Kconfig
@@ -0,0 +1,11 @@
+menu "AMD RAS features"
+	depends on X86_RAS && CPU_SUP_AMD
+
+config X86_AMD_MCE_INJECT
+	tristate "Simple MCE injection interface over /sysfs"
+	default n
+	help
+	  This is a simple interface to inject MCEs over /sysfs and test
+	  the MCE decoding code.
+
+endmenu
diff --git a/arch/x86/ras/Makefile b/arch/x86/ras/Makefile
index 7a70bb5cd057..4d8d37a301c4 100644
--- a/arch/x86/ras/Makefile
+++ b/arch/x86/ras/Makefile
@@ -1 +1,2 @@
-obj-y		:= ras.o
+obj-y				:= ras.o
+obj-$(CONFIG_X86_MCE)		+= amd/
diff --git a/arch/x86/ras/amd/Makefile b/arch/x86/ras/amd/Makefile
new file mode 100644
index 000000000000..74f2a1e676b4
--- /dev/null
+++ b/arch/x86/ras/amd/Makefile
@@ -0,0 +1,3 @@
+amd_mce_inject-y				:= mce-inject.o
+obj-$(CONFIG_X86_AMD_MCE_INJECT)		+= amd_mce_inject.o
+
diff --git a/drivers/edac/mce_amd_inj.c b/arch/x86/ras/amd/mce-inject.c
similarity index 99%
rename from drivers/edac/mce_amd_inj.c
rename to arch/x86/ras/amd/mce-inject.c
index 66b5151c1080..90aa317b09a6 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/arch/x86/ras/amd/mce-inject.c
@@ -16,7 +16,7 @@
 #include <linux/module.h>
 #include <asm/mce.h>
 
-#include "mce_amd.h"
+#include "../../../drivers/edac/mce_amd.h"
 
 struct edac_mce_attr {
 	struct attribute attr;
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index bb82d6be793c..0e6afbd7749c 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -59,16 +59,6 @@ config EDAC_DECODE_MCE
 	  which occur really early upon boot, before the module infrastructure
 	  has been initialized.
 
-config EDAC_MCE_INJ
-	tristate "Simple MCE injection interface over /sysfs"
-	depends on EDAC_DECODE_MCE
-	default n
-	help
-	  This is a simple interface to inject MCEs over /sysfs and test
-	  the MCE decoding code in EDAC.
-
-	  This is currently AMD-only.
-
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
 	help
-- 
1.8.0.rc0.18.gf84667d

