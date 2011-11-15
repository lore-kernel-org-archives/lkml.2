Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab1KOVdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:33:40 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39111 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab1KOVc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:32:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        x86@kernel.org, hpa@zytor.com, len.brown@intel.com,
        joseph.cihula@intel.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/7] x86, acpi, tboot: Have a ACPI os prepare sleep instead of calling tboot_sleep.
Date: Tue, 15 Nov 2011 16:31:05 -0500
Message-Id: <1321392671-9128-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
References: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4EC2DA45.0076,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Liang <liang.tang@oracle.com>

The ACPI suspend path makes a call to tboot_sleep right before
it writes the PM1A, PM1B values. We replace the direct call to
tboot via an registration callback similar to __acpi_register_gsi.

As part of this, the tboot_sleep need only to register with the
acpi_os_prepare_sleep_register and if it not (on IA64) then it simply
won't be called.

We can also remove the tboot_sleep declerations.

[v1: Added __attribute__ ((unused))]
[v2: Introduced a wrapper instead of changing tboot_sleep return values]
Signed-off-by: Tang Liang <liang.tang@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/tboot.c       |    9 +++++++++
 drivers/acpi/acpica/hwsleep.c |    7 ++++---
 drivers/acpi/osl.c            |   19 +++++++++++++++++++
 include/acpi/acpiosxf.h       |    6 ++++++
 include/linux/tboot.h         |    3 ---
 5 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index e2410e2..751d673 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -31,6 +31,7 @@
 #include <linux/pfn.h>
 #include <linux/mm.h>
 #include <linux/tboot.h>
+#include <acpi/acpiosxf.h>
 
 #include <asm/trampoline.h>
 #include <asm/processor.h>
@@ -297,6 +298,12 @@ void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
 
 	tboot_shutdown(acpi_shutdown_map[sleep_state]);
 }
+static acpi_status tboot_sleep_wrapper(u8 sleep_state, u32 pm1a_control,
+		u32 pm1b_control)
+{
+	tboot_sleep(sleep_state, pm1a_control, pm1b_control);
+	return AE_OK;
+}
 
 static atomic_t ap_wfs_count;
 
@@ -345,6 +352,8 @@ static __init int tboot_late_init(void)
 
 	atomic_set(&ap_wfs_count, 0);
 	register_hotcpu_notifier(&tboot_cpu_notifier);
+
+	acpi_os_prepare_sleep_register(&tboot_sleep_wrapper);
 	return 0;
 }
 
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index d52da30..b10bc90 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -45,7 +45,6 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "actables.h"
-#include <linux/tboot.h>
 #include <linux/module.h>
 
 #define _COMPONENT          ACPI_HARDWARE
@@ -344,8 +343,10 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 
 	ACPI_FLUSH_CPU_CACHE();
 
-	tboot_sleep(sleep_state, pm1a_control, pm1b_control);
-
+	status = acpi_os_prepare_sleep(sleep_state, pm1a_control,
+				 pm1b_control);
+	if (ACPI_FAILURE(status))
+		return_ACPI_STATUS(status);
 	/* Write #2: Write both SLP_TYP + SLP_EN */
 
 	status = acpi_hw_write_pm1_control(pm1a_control, pm1b_control);
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index f31c5c5..40daa68 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1659,3 +1659,22 @@ acpi_status acpi_os_terminate(void)
 
 	return AE_OK;
 }
+
+acpi_status (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 pm1a_ctrl,
+				       u32 pm1b_ctrl);
+
+acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 pm1a_control,
+		u32 pm1b_control)
+{
+	if (__acpi_os_prepare_sleep)
+		return __acpi_os_prepare_sleep(sleep_state, pm1a_control,
+					       pm1b_control);
+	else
+		return	AE_OK;
+}
+
+void acpi_os_prepare_sleep_register(acpi_status (*func)(u8 sleep_state,
+		 u32 pm1a_ctrl,	u32 pm1b_ctrl))
+{
+	__acpi_os_prepare_sleep = func;
+}
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 83062ed..ebde1e1 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -108,6 +108,12 @@ void acpi_os_delete_lock(acpi_spinlock handle);
 
 acpi_cpu_flags acpi_os_acquire_lock(acpi_spinlock handle);
 
+void acpi_os_prepare_sleep_register(acpi_status (*func)(u8 sleep_state,
+				    u32 pm1a_ctrl, u32 pm1b_ctrl));
+
+acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 pm1a_control,
+				  u32 pm1b_control);
+
 void acpi_os_release_lock(acpi_spinlock handle, acpi_cpu_flags flags);
 
 /*
diff --git a/include/linux/tboot.h b/include/linux/tboot.h
index 1dba6ee..d57732d 100644
--- a/include/linux/tboot.h
+++ b/include/linux/tboot.h
@@ -143,7 +143,6 @@ static inline int tboot_enabled(void)
 
 extern void tboot_probe(void);
 extern void tboot_shutdown(u32 shutdown_type);
-extern void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control);
 extern struct acpi_table_header *tboot_get_dmar_table(
 				      struct acpi_table_header *dmar_tbl);
 extern int tboot_force_iommu(void);
@@ -153,8 +152,6 @@ extern int tboot_force_iommu(void);
 #define tboot_enabled()			0
 #define tboot_probe()			do { } while (0)
 #define tboot_shutdown(shutdown_type)	do { } while (0)
-#define tboot_sleep(sleep_state, pm1a_control, pm1b_control)	\
-					do { } while (0)
 #define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
 #define tboot_force_iommu()		0
 
-- 
1.7.7.1

