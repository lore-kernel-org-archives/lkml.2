Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2E3Jdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:33:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:47655 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab2E3Jdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:33:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158617388"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] x86, realmode: build fix drivers/acpi/sleep.c
Date: Wed, 30 May 2012 12:33:41 +0300
Message-Id: <1338370421-27735-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@kernel.org>

Revert usage of acpi_wakeup_address and move definition
to x86 architecture code in order to make compilation work
in ia64.

[jsakkine: tested compilation in ia64/x86-64 and added
proper commit message]

Originally-by: H. Peter Anvin <hpa@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/include/asm/acpi.h |    7 +++----
 drivers/acpi/sleep.c        |    8 ++------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 724aa44..0c44630 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -29,6 +29,7 @@
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mpspec.h>
+#include <asm/realmode.h>
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -116,10 +117,8 @@ static inline void acpi_disable_pci(void)
 /* Low-level suspend routine. */
 extern int acpi_suspend_lowlevel(void);
 
-extern const unsigned char acpi_wakeup_code[];
-
-/* early initialization routine */
-extern void acpi_reserve_wakeup_memory(void);
+/* Physical address to resume after wakeup */
+#define acpi_wakeup_address ((unsigned long)(real_mode_header->wakeup_start))
 
 /*
  * Check if the CPU can handle C2 and deeper
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index a82fbf6..d2311f7 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -25,8 +25,6 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
-#include <asm/realmode.h>
-
 #include "internal.h"
 #include "sleep.h"
 
@@ -94,13 +92,11 @@ static struct notifier_block tts_notifier = {
 static int acpi_sleep_prepare(u32 acpi_state)
 {
 #ifdef CONFIG_ACPI_SLEEP
-	unsigned long wakeup_pa = real_mode_header->wakeup_start;
 	/* do we have a wakeup address for S2 and S3? */
 	if (acpi_state == ACPI_STATE_S3) {
-		if (!wakeup_pa)
+		if (!acpi_wakeup_address)
 			return -EFAULT;
-		acpi_set_firmware_waking_vector(
-				(acpi_physical_address)wakeup_pa);
+		acpi_set_firmware_waking_vector(acpi_wakeup_address);
 
 	}
 	ACPI_FLUSH_CPU_CACHE();
-- 
1.7.9.5

