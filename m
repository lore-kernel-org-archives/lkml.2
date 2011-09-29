Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab1I2USe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:18:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45023 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab1I2US2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:18:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, len.brown@intel.com,
        joseph.cihula@intel.com, shane.wang@intel.com,
        xen-devel@lists.xensource.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com, ke.yu@intel.com, kevin.tian@intel.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/8] x86, acpi, tboot: Have a ACPI sleep override instead of calling tboot_sleep.
Date: Thu, 29 Sep 2011 16:16:48 -0400
Message-Id: <1317327414-24072-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
References: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090201.4E84D244.0008,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI suspend path makes a call to tboot_sleep right before
it writes the PM1A, PM1B values. We replace the direct call to
tboot via an registration callback similar to __acpi_register_gsi.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
CC: Len Brown <len.brown@intel.com>
CC: Joseph Cihula <joseph.cihula@intel.com>
CC: Shane Wang <shane.wang@intel.com>
CC: xen-devel@lists.xensource.com
CC: linux-pm@lists.linux-foundation.org
CC: tboot-devel@lists.sourceforge.net
CC: linux-acpi@vger.kernel.org
[v1: Added __attribute__ ((unused))]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/acpi.h   |    4 ++++
 arch/x86/kernel/acpi/boot.c   |    4 ++++
 arch/x86/kernel/tboot.c       |   14 ++++++++++----
 drivers/acpi/acpica/hwsleep.c |   12 ++++++++++--
 include/linux/tboot.h         |    3 ++-
 5 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 610001d..0a46696 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -98,6 +98,10 @@ void acpi_pic_sci_set_trigger(unsigned int, u16);
 extern int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
 				  int trigger, int polarity);
 
+extern int (*__acpi_override_sleep)(u8 sleep_state, u32 pm1a_ctrl,
+				    u32 pm1b_ctrl, bool *skip_rest) \
+				    __attribute__ ((unused));
+
 static inline void disable_acpi(void)
 {
 	acpi_disabled = 1;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4558f0d..7f30806 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -552,6 +552,10 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
 			   int trigger, int polarity) = acpi_register_gsi_pic;
 
+int (*__acpi_override_sleep)(u8 sleep_state, u32 pm1a_ctrl,
+			     u32 pm1b_ctrl, bool *skip_rest) \
+			   __attribute__ ((unused)) = NULL;
+
 /*
  * success: return IRQ number (>=0)
  * failure: return < 0
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index e07a2fc..a6c0a30 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -42,7 +42,7 @@
 #include <asm/setup.h>
 #include <asm/e820.h>
 #include <asm/io.h>
-
+#include <linux/acpi.h>
 #include "acpi/realmode/wakeup.h"
 
 /* Global pointer to shared data; NULL means no measured launch. */
@@ -271,7 +271,9 @@ static void tboot_copy_fadt(const struct acpi_table_fadt *fadt)
 		offsetof(struct acpi_table_facs, firmware_waking_vector);
 }
 
-void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
+
+int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control,
+		bool *skip_rest)
 {
 	static u32 acpi_shutdown_map[ACPI_S_STATE_COUNT] = {
 		/* S0,1,2: */ -1, -1, -1,
@@ -280,7 +282,7 @@ void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
 		/* S5: */ TB_SHUTDOWN_S5 };
 
 	if (!tboot_enabled())
-		return;
+		return AE_OK;
 
 	tboot_copy_fadt(&acpi_gbl_FADT);
 	tboot->acpi_sinfo.pm1a_cnt_val = pm1a_control;
@@ -291,10 +293,12 @@ void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
 	if (sleep_state >= ACPI_S_STATE_COUNT ||
 	    acpi_shutdown_map[sleep_state] == -1) {
 		pr_warning("unsupported sleep state 0x%x\n", sleep_state);
-		return;
+		return AE_ERROR;
 	}
 
 	tboot_shutdown(acpi_shutdown_map[sleep_state]);
+
+	return AE_OK;
 }
 
 static atomic_t ap_wfs_count;
@@ -344,6 +348,8 @@ static __init int tboot_late_init(void)
 
 	atomic_set(&ap_wfs_count, 0);
 	register_hotcpu_notifier(&tboot_cpu_notifier);
+
+	__acpi_override_sleep = tboot_sleep;
 	return 0;
 }
 
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index 2ac28bb..31d1198 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -45,7 +45,6 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "actables.h"
-#include <linux/tboot.h>
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwsleep")
@@ -343,8 +342,17 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 
 	ACPI_FLUSH_CPU_CACHE();
 
-	tboot_sleep(sleep_state, pm1a_control, pm1b_control);
+	if (__acpi_override_sleep) {
+		bool skip_rest = false;
 
+		status = __acpi_override_sleep(sleep_state, pm1a_control,
+					       pm1b_control, &skip_rest);
+
+		if (ACPI_FAILURE(status))
+			return_ACPI_STATUS(status);
+		if (skip_rest)
+			return_ACPI_STATUS(AE_OK);
+	}
 	/* Write #2: Write both SLP_TYP + SLP_EN */
 
 	status = acpi_hw_write_pm1_control(pm1a_control, pm1b_control);
diff --git a/include/linux/tboot.h b/include/linux/tboot.h
index 1dba6ee..1216698 100644
--- a/include/linux/tboot.h
+++ b/include/linux/tboot.h
@@ -143,7 +143,8 @@ static inline int tboot_enabled(void)
 
 extern void tboot_probe(void);
 extern void tboot_shutdown(u32 shutdown_type);
-extern void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control);
+extern int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control,
+		       bool *skip_rest)  __attribute__ ((unused));
 extern struct acpi_table_header *tboot_get_dmar_table(
 				      struct acpi_table_header *dmar_tbl);
 extern int tboot_force_iommu(void);
-- 
1.7.4.1

