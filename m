Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab1I2USy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:18:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22604 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab1I2USv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:18:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, len.brown@intel.com,
        joseph.cihula@intel.com, shane.wang@intel.com,
        xen-devel@lists.xensource.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com, ke.yu@intel.com, kevin.tian@intel.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/8] x86/acpi/sleep: Provide registration for acpi_suspend_lowlevel.
Date: Thu, 29 Sep 2011 16:16:49 -0400
Message-Id: <1317327414-24072-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
References: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4E84D259.0013,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liang Tang <liang.tang@oracle.com>

Which by default will be x86_acpi_suspend_lowlevel.
This registration allows us to register another callback
if there is a need to use another platform specific callback.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
CC: Len Brown <len.brown@intel.com>
CC: Joseph Cihula <joseph.cihula@intel.com>
CC: Shane Wang <shane.wang@intel.com>
CC: linux-pm@lists.linux-foundation.org
CC: linux-acpi@vger.kernel.org
CC: Len Brown <len.brown@intel.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Liang Tang <liang.tang@oracle.com>
---
 arch/x86/include/asm/acpi.h  |    2 +-
 arch/x86/kernel/acpi/boot.c  |    2 ++
 arch/x86/kernel/acpi/sleep.c |    4 ++--
 arch/x86/kernel/acpi/sleep.h |    2 ++
 drivers/acpi/sleep.c         |    2 ++
 5 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 0a46696..9b538dc 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -119,7 +119,7 @@ static inline void acpi_disable_pci(void)
 }
 
 /* Low-level suspend routine. */
-extern int acpi_suspend_lowlevel(void);
+extern int (*acpi_suspend_lowlevel)(void);
 
 extern const unsigned char acpi_wakeup_code[];
 #define acpi_wakeup_address (__pa(TRAMPOLINE_SYM(acpi_wakeup_code)))
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 7f30806..ddd081b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -44,6 +44,7 @@
 #include <asm/mpspec.h>
 #include <asm/smp.h>
 
+#include "sleep.h" /* To include x86_acpi_suspend_lowlevel */
 static int __initdata acpi_force = 0;
 u32 acpi_rsdt_forced;
 int acpi_disabled;
@@ -556,6 +557,7 @@ int (*__acpi_override_sleep)(u8 sleep_state, u32 pm1a_ctrl,
 			     u32 pm1b_ctrl, bool *skip_rest) \
 			   __attribute__ ((unused)) = NULL;
 
+int (*acpi_suspend_lowlevel)(void) = x86_acpi_suspend_lowlevel;
 /*
  * success: return IRQ number (>=0)
  * failure: return < 0
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 103b6ab..4d2d0b1 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -25,12 +25,12 @@ static char temp_stack[4096];
 #endif
 
 /**
- * acpi_suspend_lowlevel - save kernel state
+ * x86_acpi_suspend_lowlevel - save kernel state
  *
  * Create an identity mapped page table and copy the wakeup routine to
  * low memory.
  */
-int acpi_suspend_lowlevel(void)
+int x86_acpi_suspend_lowlevel(void)
 {
 	struct wakeup_header *header;
 	/* address in low memory of the wakeup routine. */
diff --git a/arch/x86/kernel/acpi/sleep.h b/arch/x86/kernel/acpi/sleep.h
index 416d4be..4d3feb5 100644
--- a/arch/x86/kernel/acpi/sleep.h
+++ b/arch/x86/kernel/acpi/sleep.h
@@ -13,3 +13,5 @@ extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 extern void wakeup_long64(void);
 
 extern void do_suspend_lowlevel(void);
+
+extern int x86_acpi_suspend_lowlevel(void);
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 3ed80b2..3570c00 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -254,6 +254,8 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 		break;
 
 	case ACPI_STATE_S3:
+		if (!acpi_suspend_lowlevel)
+			return -ENODEV;
 		error = acpi_suspend_lowlevel();
 		if (error)
 			return error;
-- 
1.7.4.1

