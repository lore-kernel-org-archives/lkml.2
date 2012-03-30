Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143Ab2C3LWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:22:37 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:51544 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933789Ab2C3LSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:18:36 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 38/76] ACPI: Move module parameter gts and bfs to sleep.c
Date: Fri, 30 Mar 2012 06:13:41 -0400
Message-id: <a2ef5c4fd44ce3922435139393b89f2cce47f576.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

Move linux specific module parameter gts and bfs out of ACPICA core
code to sleep.c.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/hwesleep.c |   13 -------------
 drivers/acpi/sleep.c           |   38 +++++++++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index 1c409e8..29e8592 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -44,17 +44,10 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include <linux/module.h>
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwesleep")
 
-static unsigned int gts, bfs;
-module_param(gts, uint, 0644);
-module_param(bfs, uint, 0644);
-MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
-MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
-
 /*******************************************************************************
  *
  * FUNCTION:    acpi_hw_execute_sleep_method
@@ -76,12 +69,6 @@ void acpi_hw_execute_sleep_method(char *method_pathname, u32 integer_argument)
 
 	ACPI_FUNCTION_TRACE(hw_execute_sleep_method);
 
-	if (!ACPI_STRCMP(METHOD_PATHNAME__GTS, method_pathname) && !gts)
-		return_VOID;
-
-	if (!ACPI_STRCMP(METHOD_PATHNAME__BFS, method_pathname) && !bfs)
-		return_VOID;
-
 	/* One argument, integer_argument; No return value expected */
 
 	arg_list.count = 1;
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 8f1fb45..acf81fe 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -17,6 +17,7 @@
 #include <linux/suspend.h>
 #include <linux/reboot.h>
 #include <linux/acpi.h>
+#include <linux/module.h>
 
 #include <asm/io.h>
 
@@ -26,6 +27,24 @@
 #include "internal.h"
 #include "sleep.h"
 
+static unsigned int gts, bfs;
+module_param(gts, uint, 0644);
+module_param(bfs, uint, 0644);
+MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
+MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
+
+static u8 wake_sleep_flags(void)
+{
+	u8 flags = ACPI_NO_OPTIONAL_METHODS;
+
+	if (gts)
+		flags |= ACPI_EXECUTE_GTS;
+	if (bfs)
+		flags |= ACPI_EXECUTE_BFS;
+
+	return flags;
+}
+
 static u8 sleep_states[ACPI_S_STATE_COUNT];
 
 static void acpi_sleep_tts_switch(u32 acpi_state)
@@ -243,6 +262,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 {
 	acpi_status status = AE_OK;
 	u32 acpi_state = acpi_target_sleep_state;
+	u8 flags = wake_sleep_flags();
 	int error;
 
 	ACPI_FLUSH_CPU_CACHE();
@@ -250,8 +270,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 	switch (acpi_state) {
 	case ACPI_STATE_S1:
 		barrier();
-		status = acpi_enter_sleep_state(acpi_state,
-				ACPI_NO_OPTIONAL_METHODS);
+		status = acpi_enter_sleep_state(acpi_state, flags);
 		break;
 
 	case ACPI_STATE_S3:
@@ -266,7 +285,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 	acpi_write_bit_register(ACPI_BITREG_SCI_ENABLE, 1);
 
 	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(acpi_state, ACPI_NO_OPTIONAL_METHODS);
+	acpi_leave_sleep_state_prep(acpi_state, flags);
 
 	/* ACPI 3.0 specs (P62) says that it's the responsibility
 	 * of the OSPM to clear the status bit [ implying that the
@@ -530,27 +549,30 @@ static int acpi_hibernation_begin(void)
 
 static int acpi_hibernation_enter(void)
 {
+	u8 flags = wake_sleep_flags();
 	acpi_status status = AE_OK;
 
 	ACPI_FLUSH_CPU_CACHE();
 
 	/* This shouldn't return.  If it returns, we have a problem */
-	status = acpi_enter_sleep_state(ACPI_STATE_S4, ACPI_NO_OPTIONAL_METHODS);
+	status = acpi_enter_sleep_state(ACPI_STATE_S4, flags);
 	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(ACPI_STATE_S4, ACPI_NO_OPTIONAL_METHODS);
+	acpi_leave_sleep_state_prep(ACPI_STATE_S4, flags);
 
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
 }
 
 static void acpi_hibernation_leave(void)
 {
+	u8 flags = wake_sleep_flags();
+
 	/*
 	 * If ACPI is not enabled by the BIOS and the boot kernel, we need to
 	 * enable it here.
 	 */
 	acpi_enable();
 	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(ACPI_STATE_S4, ACPI_NO_OPTIONAL_METHODS);
+	acpi_leave_sleep_state_prep(ACPI_STATE_S4, flags);
 	/* Check the hardware signature */
 	if (facs && s4_hardware_signature != facs->hardware_signature) {
 		printk(KERN_EMERG "ACPI: Hardware changed while hibernated, "
@@ -771,10 +793,12 @@ static void acpi_power_off_prepare(void)
 
 static void acpi_power_off(void)
 {
+	u8 flags = wake_sleep_flags();
+
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
 	printk(KERN_DEBUG "%s called\n", __func__);
 	local_irq_disable();
-	acpi_enter_sleep_state(ACPI_STATE_S5, ACPI_NO_OPTIONAL_METHODS);
+	acpi_enter_sleep_state(ACPI_STATE_S5, flags);
 }
 
 /*
-- 
1.7.10.rc2.19.gfae9d

