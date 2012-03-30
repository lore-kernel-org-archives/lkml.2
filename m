Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356Ab2C3MV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:21:28 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48688 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760359Ab2C3MSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:36 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 32/76] ACPICA: Add table-driven dispatch for sleep/wake
 functions
Date: Fri, 30 Mar 2012 06:13:35 -0400
Message-id: <72a8887a356076dfa39bd6691c52446f90a50480.1333101989.git.len.brown@intel.com>
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

From: Bob Moore <robert.moore@intel.com>

Simplifies the code, especially the compile-time
ACPI_REDUCED_HARDWARE option.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/acmacros.h  |    6 ++
 drivers/acpi/acpica/hwxfsleep.c |  136 +++++++++++++++++++++++----------------
 include/acpi/actypes.h          |    9 +++
 3 files changed, 97 insertions(+), 54 deletions(-)

diff --git a/drivers/acpi/acpica/acmacros.h b/drivers/acpi/acpica/acmacros.h
index ef338a9..f119f47 100644
--- a/drivers/acpi/acpica/acmacros.h
+++ b/drivers/acpi/acpica/acmacros.h
@@ -516,6 +516,12 @@
 
 #endif				/* ACPI_DEBUG_OUTPUT */
 
+#if (!ACPI_REDUCED_HARDWARE)
+#define ACPI_HW_OPTIONAL_FUNCTION(addr)     addr
+#else
+#define ACPI_HW_OPTIONAL_FUNCTION(addr)     NULL
+#endif
+
 /*
  * Some code only gets executed when the debugger is built in.
  * Note that this is entirely independent of whether the
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index ff20558..b711f97 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -48,6 +48,34 @@
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwxfsleep")
 
+/* Local prototypes */
+static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id);
+
+/*
+ * Dispatch table used to efficiently branch to the various sleep
+ * functions.
+ */
+#define ACPI_SLEEP_FUNCTION         0
+#define ACPI_WAKE_PREP_FUNCTION     1
+#define ACPI_WAKE_FUNCTION          2
+
+/* Legacy functions are optional, based upon ACPI_REDUCED_HARDWARE */
+
+static struct acpi_sleep_functions acpi_sleep_dispatch[] = {
+	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_sleep),
+	 acpi_hw_extended_sleep},
+	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_wake_prep),
+	 acpi_hw_extended_wake_prep},
+	{ACPI_HW_OPTIONAL_FUNCTION(acpi_hw_legacy_wake), acpi_hw_extended_wake}
+};
+
+/*
+ * These functions are removed for the ACPI_REDUCED_HARDWARE case:
+ *      acpi_set_firmware_waking_vector
+ *      acpi_set_firmware_waking_vector64
+ *      acpi_enter_sleep_state_s4bios
+ */
+
 #if (!ACPI_REDUCED_HARDWARE)
 /*******************************************************************************
  *
@@ -61,6 +89,7 @@ ACPI_MODULE_NAME("hwxfsleep")
  * DESCRIPTION: Sets the 32-bit firmware_waking_vector field of the FACS
  *
  ******************************************************************************/
+
 acpi_status acpi_set_firmware_waking_vector(u32 physical_address)
 {
 	ACPI_FUNCTION_TRACE(acpi_set_firmware_waking_vector);
@@ -193,18 +222,65 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_s4bios)
 #endif				/* !ACPI_REDUCED_HARDWARE */
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_hw_sleep_dispatch
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state to enter/exit
+ *              function_id         - Sleep, wake_prep, or Wake
+ *
+ * RETURN:      Status from the invoked sleep handling function.
+ *
+ * DESCRIPTION: Dispatch a sleep/wake request to the appropriate handling
+ *              function.
+ *
+ ******************************************************************************/
+static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id)
+{
+	acpi_status status;
+	struct acpi_sleep_functions *sleep_functions =
+	    &acpi_sleep_dispatch[function_id];
+
+#if (!ACPI_REDUCED_HARDWARE)
+
+	/*
+	 * If the Hardware Reduced flag is set (from the FADT), we must
+	 * use the extended sleep registers
+	 */
+	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
+		status = sleep_functions->extended_function(sleep_state);
+	} else {
+		/* Legacy sleep */
+
+		status = sleep_functions->legacy_function(sleep_state);
+	}
+
+	return (status);
+
+#else
+	/*
+	 * For the case where reduced-hardware-only code is being generated,
+	 * we know that only the extended sleep registers are available
+	 */
+	status = sleep_functions->extended_function(sleep_state);
+	return (status);
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
+}
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_enter_sleep_state_prep
  *
  * PARAMETERS:  sleep_state         - Which sleep state to enter
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Prepare to enter a system sleep state (see ACPI 2.0 spec p 231)
+ * DESCRIPTION: Prepare to enter a system sleep state.
  *              This function must execute with interrupts enabled.
  *              We break sleeping into 2 stages so that OSPM can handle
  *              various OS-specific tasks between the two steps.
  *
  ******************************************************************************/
+
 acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
 {
 	acpi_status status;
@@ -291,23 +367,8 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 			    acpi_gbl_sleep_type_a, acpi_gbl_sleep_type_b));
 		return_ACPI_STATUS(AE_AML_OPERAND_VALUE);
 	}
-#if (!ACPI_REDUCED_HARDWARE)
-
-	/* If Hardware Reduced flag is set, must use the extended sleep registers */
-
-	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
-		status = acpi_hw_extended_sleep(sleep_state);
-	} else {
-		/* Legacy sleep */
-
-		status = acpi_hw_legacy_sleep(sleep_state);
-	}
-
-#else
-	status = acpi_hw_extended_sleep(sleep_state);
-
-#endif				/* !ACPI_REDUCED_HARDWARE */
 
+	status = acpi_hw_sleep_dispatch(sleep_state, ACPI_SLEEP_FUNCTION);
 	return_ACPI_STATUS(status);
 }
 
@@ -330,26 +391,9 @@ acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
 {
 	acpi_status status;
 
-	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
-
-
-#if (!ACPI_REDUCED_HARDWARE)
-
-	/* If Hardware Reduced flag is set, must use the extended sleep registers */
-
-	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
-		status = acpi_hw_extended_wake_prep(sleep_state);
-	} else {
-		/* Legacy sleep */
-
-		status = acpi_hw_legacy_wake_prep(sleep_state);
-	}
-#else
-	status = acpi_hw_extended_wake_prep(sleep_state);
-
-#endif				/* !ACPI_REDUCED_HARDWARE */
-
+	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state_prep);
 
+	status = acpi_hw_sleep_dispatch(sleep_state, ACPI_WAKE_PREP_FUNCTION);
 	return_ACPI_STATUS(status);
 }
 
@@ -359,7 +403,7 @@ ACPI_EXPORT_SYMBOL(acpi_leave_sleep_state_prep)
  *
  * FUNCTION:    acpi_leave_sleep_state
  *
- * PARAMETERS:  sleep_state         - Which sleep state we just exited
+ * PARAMETERS:  sleep_state         - Which sleep state we are exiting
  *
  * RETURN:      Status
  *
@@ -374,23 +418,7 @@ acpi_status acpi_leave_sleep_state(u8 sleep_state)
 	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
 
 
-#if (!ACPI_REDUCED_HARDWARE)
-
-	/* If Hardware Reduced flag is set, must use the extended sleep registers */
-
-	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
-		status = acpi_hw_extended_wake(sleep_state);
-	} else {
-		/* Legacy sleep */
-
-		status = acpi_hw_legacy_wake(sleep_state);
-	}
-
-#else
-	status = acpi_hw_extended_wake(sleep_state);
-
-#endif				/* !ACPI_REDUCED_HARDWARE */
-
+	status = acpi_hw_sleep_dispatch(sleep_state, ACPI_WAKE_FUNCTION);
 	return_ACPI_STATUS(status);
 }
 
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 48c4d5f..3496158 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -788,6 +788,15 @@ typedef u8 acpi_adr_space_type;
 #define ACPI_ENABLE_EVENT                       1
 #define ACPI_DISABLE_EVENT                      0
 
+/* Sleep function dispatch */
+
+typedef acpi_status(*ACPI_SLEEP_FUNCTION) (u8 sleep_state);
+
+struct acpi_sleep_functions {
+	ACPI_SLEEP_FUNCTION legacy_function;
+	ACPI_SLEEP_FUNCTION extended_function;
+};
+
 /*
  * External ACPI object definition
  */
-- 
1.7.10.rc2.19.gfae9d

