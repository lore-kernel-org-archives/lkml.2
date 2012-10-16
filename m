Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2JPOxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:53:03 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45240 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab2JPOw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:52:58 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v2 2/6] x86, RAS: Move AMD MCE injection code into ras/
Date: Tue, 16 Oct 2012 16:52:51 +0200
Message-Id: <1350399175-14477-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc2.4.g42e55a5
In-Reply-To: <1350399175-14477-1-git-send-email-bp@amd64.org>
References: <1350399175-14477-1-git-send-email-bp@amd64.org>
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
 arch/x86/ras/Makefile                                       |  1 +
 arch/x86/ras/amd/Makefile                                   |  3 +++
 drivers/edac/mce_amd_inj.c => arch/x86/ras/amd/mce-inject.c |  2 +-
 drivers/edac/Kconfig                                        | 10 ----------
 6 files changed, 18 insertions(+), 11 deletions(-)
 create mode 100644 arch/x86/ras/Kconfig
 create mode 100644 arch/x86/ras/amd/Makefile
 rename drivers/edac/mce_amd_inj.c => arch/x86/ras/amd/mce-inject.c (99%)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e882fc64ffb3..f2f704af9f86 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -666,6 +666,8 @@ config X86_RAS
 	A collection of Reliability, Availability and Serviceability software
 	features which enable hardware error logging and reporting.
 
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
index e69de29bb2d1..dd7a321e4b5e 100644
--- a/arch/x86/ras/Makefile
+++ b/arch/x86/ras/Makefile
@@ -0,0 +1 @@
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
index 409b92b8d346..96c1f6f4b6a1 100644
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
1.8.0.rc2.4.g42e55a5

