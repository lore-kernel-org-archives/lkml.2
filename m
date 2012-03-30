Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693Ab2C3MVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:21:36 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48688 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760659Ab2C3MSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:33 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 24/76] ACPICA: ACPI 5: Support for new FADT SleepStatus,
 SleepControl registers
Date: Fri, 30 Mar 2012 06:13:27 -0400
Message-id: <2feec47d4c5f80b05f1650f5a24865718978eea4.1333101989.git.len.brown@intel.com>
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

Adds sleep and wake support for systems with these registers.
One new file, hwxfsleep.c

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/Makefile    |    3 +-
 drivers/acpi/acpica/achware.h   |   17 ++
 drivers/acpi/acpica/hwsleep.c   |  566 +++++++++++++++++++++------------------
 drivers/acpi/acpica/hwxfsleep.c |  377 ++++++++++++++++++++++++++
 include/acpi/actbl.h            |    7 +
 5 files changed, 701 insertions(+), 269 deletions(-)
 create mode 100644 drivers/acpi/acpica/hwxfsleep.c

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index 0ca208b..da55180 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -73,7 +73,8 @@ acpi-y +=		\
 	hwregs.o	\
 	hwsleep.o	\
 	hwvalid.o	\
-	hwxface.o
+	hwxface.o	\
+	hwxfsleep.o
 
 acpi-$(ACPI_FUTURE_USAGE) += hwtimer.o
 
diff --git a/drivers/acpi/acpica/achware.h b/drivers/acpi/acpica/achware.h
index 677793e..087f710 100644
--- a/drivers/acpi/acpica/achware.h
+++ b/drivers/acpi/acpica/achware.h
@@ -81,6 +81,23 @@ acpi_status acpi_hw_register_write(u32 register_id, u32 value);
 acpi_status acpi_hw_clear_acpi_status(void);
 
 /*
+ * hwsleep - sleep/wake support
+ */
+void acpi_hw_execute_SST(u32 value);
+
+acpi_status acpi_hw_extended_sleep(u8 sleep_state);
+
+acpi_status acpi_hw_legacy_sleep(u8 sleep_state);
+
+acpi_status acpi_hw_extended_wake_prep(u8 sleep_state);
+
+acpi_status acpi_hw_extended_wake(u8 sleep_state);
+
+acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state);
+
+acpi_status acpi_hw_legacy_wake(u8 sleep_state);
+
+/*
  * hwvalid - Port I/O with validation
  */
 acpi_status acpi_hw_read_port(acpi_io_address address, u32 *value, u32 width);
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index 3c4a922..59a2a6b 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -1,7 +1,6 @@
-
 /******************************************************************************
  *
- * Name: hwsleep.c - ACPI Hardware Sleep/Wake Interface
+ * Name: hwsleep.c - ACPI Hardware Sleep/Wake Support Functions
  *
  *****************************************************************************/
 
@@ -44,212 +43,183 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include "actables.h"
 #include <linux/tboot.h>
 #include <linux/module.h>
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwsleep")
 
+/* Local prototypes */
+static void acpi_hw_execute_GTS(u8 sleep_state);
+
+static void acpi_hw_execute_BFS(u8 sleep_state);
+
+static void acpi_hw_execute_WAK(u8 sleep_state);
+
+static unsigned int gts, bfs;
+module_param(gts, uint, 0644);
+module_param(bfs, uint, 0644);
+MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
+MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
+
 /*******************************************************************************
  *
- * FUNCTION:    acpi_set_firmware_waking_vector
+ * FUNCTION:    acpi_hw_execute_GTS
  *
- * PARAMETERS:  physical_address    - 32-bit physical address of ACPI real mode
- *                                    entry point.
+ * PARAMETERS:  sleep_state         - Sleep state that will be entered
  *
- * RETURN:      Status
+ * RETURN:      None
  *
- * DESCRIPTION: Sets the 32-bit firmware_waking_vector field of the FACS
+ * DESCRIPTION: Execute the optional _GTS method (Going To Sleep)
  *
  ******************************************************************************/
-acpi_status
-acpi_set_firmware_waking_vector(u32 physical_address)
-{
-	ACPI_FUNCTION_TRACE(acpi_set_firmware_waking_vector);
-
 
-	/*
-	 * According to the ACPI specification 2.0c and later, the 64-bit
-	 * waking vector should be cleared and the 32-bit waking vector should
-	 * be used, unless we want the wake-up code to be called by the BIOS in
-	 * Protected Mode.  Some systems (for example HP dv5-1004nr) are known
-	 * to fail to resume if the 64-bit vector is used.
-	 */
+static void acpi_hw_execute_GTS(u8 sleep_state)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+	acpi_status status;
 
-	/* Set the 32-bit vector */
+	if (!gts)
+		return;
 
-	acpi_gbl_FACS->firmware_waking_vector = physical_address;
+	/* One argument, sleep_state */
 
-	/* Clear the 64-bit vector if it exists */
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = sleep_state;
 
-	if ((acpi_gbl_FACS->length > 32) && (acpi_gbl_FACS->version >= 1)) {
-		acpi_gbl_FACS->xfirmware_waking_vector = 0;
+	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		ACPI_EXCEPTION((AE_INFO, status,
+				"While executing method _GTS"));
 	}
-
-	return_ACPI_STATUS(AE_OK);
 }
 
-ACPI_EXPORT_SYMBOL(acpi_set_firmware_waking_vector)
-
-#if ACPI_MACHINE_WIDTH == 64
 /*******************************************************************************
  *
- * FUNCTION:    acpi_set_firmware_waking_vector64
+ * FUNCTION:    acpi_hw_execute_BFS
  *
- * PARAMETERS:  physical_address    - 64-bit physical address of ACPI protected
- *                                    mode entry point.
+ * PARAMETERS:  sleep_state         - Which sleep state we just exited
  *
- * RETURN:      Status
+ * RETURN:      None
  *
- * DESCRIPTION: Sets the 64-bit X_firmware_waking_vector field of the FACS, if
- *              it exists in the table. This function is intended for use with
- *              64-bit host operating systems.
+ * DESCRIPTION: Execute the optional _BFS method (Back From Sleep)
  *
  ******************************************************************************/
-acpi_status
-acpi_set_firmware_waking_vector64(u64 physical_address)
-{
-	ACPI_FUNCTION_TRACE(acpi_set_firmware_waking_vector64);
-
 
-	/* Determine if the 64-bit vector actually exists */
+static void acpi_hw_execute_BFS(u8 sleep_state)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+	acpi_status status;
 
-	if ((acpi_gbl_FACS->length <= 32) || (acpi_gbl_FACS->version < 1)) {
-		return_ACPI_STATUS(AE_NOT_EXIST);
-	}
+	if (!bfs)
+		return;
 
-	/* Clear 32-bit vector, set the 64-bit X_ vector */
+	/* One argument, sleep_state */
 
-	acpi_gbl_FACS->firmware_waking_vector = 0;
-	acpi_gbl_FACS->xfirmware_waking_vector = physical_address;
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = sleep_state;
 
-	return_ACPI_STATUS(AE_OK);
+	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		ACPI_EXCEPTION((AE_INFO, status,
+				"While executing method _BFS"));
+	}
 }
 
-ACPI_EXPORT_SYMBOL(acpi_set_firmware_waking_vector64)
-#endif
-
 /*******************************************************************************
  *
- * FUNCTION:    acpi_enter_sleep_state_prep
+ * FUNCTION:    acpi_hw_execute_WAK
  *
- * PARAMETERS:  sleep_state         - Which sleep state to enter
+ * PARAMETERS:  sleep_state         - Which sleep state we just exited
  *
- * RETURN:      Status
+ * RETURN:      None
  *
- * DESCRIPTION: Prepare to enter a system sleep state (see ACPI 2.0 spec p 231)
- *              This function must execute with interrupts enabled.
- *              We break sleeping into 2 stages so that OSPM can handle
- *              various OS-specific tasks between the two steps.
+ * DESCRIPTION: Execute the _WAK method (System Wake)
  *
  ******************************************************************************/
-acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
+
+static void acpi_hw_execute_WAK(u8 sleep_state)
 {
-	acpi_status status;
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
+	acpi_status status;
 
-	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state_prep);
-
-	/* _PSW methods could be run here to enable wake-on keyboard, LAN, etc. */
-
-	status = acpi_get_sleep_type_data(sleep_state,
-					  &acpi_gbl_sleep_type_a,
-					  &acpi_gbl_sleep_type_b);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/* Setup parameter object */
+	/* One argument, sleep_state */
 
 	arg_list.count = 1;
 	arg_list.pointer = &arg;
-
 	arg.type = ACPI_TYPE_INTEGER;
 	arg.integer.value = sleep_state;
 
-	/* Run the _PTS method */
-
-	status = acpi_evaluate_object(NULL, METHOD_NAME__PTS, &arg_list, NULL);
+	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		return_ACPI_STATUS(status);
+		ACPI_EXCEPTION((AE_INFO, status,
+				"While executing method _WAK"));
 	}
+	/* TBD: _WAK "sometimes" returns stuff - do we want to look at it? */
+}
 
-	/* Setup the argument to _SST */
-
-	switch (sleep_state) {
-	case ACPI_STATE_S0:
-		arg.integer.value = ACPI_SST_WORKING;
-		break;
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_hw_execute_SST
+ *
+ * PARAMETERS:  indicator_id        - Value to be passed to the _SST method
+ *
+ * RETURN:      None
+ *
+ * DESCRIPTION: Execute the optional _SST method (System Status)
+ *
+ ******************************************************************************/
 
-	case ACPI_STATE_S1:
-	case ACPI_STATE_S2:
-	case ACPI_STATE_S3:
-		arg.integer.value = ACPI_SST_SLEEPING;
-		break;
+void acpi_hw_execute_SST(u32 indicator_id)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+	acpi_status status;
 
-	case ACPI_STATE_S4:
-		arg.integer.value = ACPI_SST_SLEEP_CONTEXT;
-		break;
+	/* One argument, status indicator ID */
 
-	default:
-		arg.integer.value = ACPI_SST_INDICATOR_OFF;	/* Default is off */
-		break;
-	}
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
 
-	/*
-	 * Set the system indicators to show the desired sleep state.
-	 * _SST is an optional method (return no error if not found)
-	 */
+	arg.integer.value = indicator_id;
 	status = acpi_evaluate_object(NULL, METHOD_NAME__SST, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status,
 				"While executing method _SST"));
 	}
-
-	return_ACPI_STATUS(AE_OK);
 }
 
-ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_prep)
-
-static unsigned int gts, bfs;
-module_param(gts, uint, 0644);
-module_param(bfs, uint, 0644);
-MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
-MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
-
 /*******************************************************************************
  *
- * FUNCTION:    acpi_enter_sleep_state
+ * FUNCTION:    acpi_hw_legacy_sleep
  *
  * PARAMETERS:  sleep_state         - Which sleep state to enter
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Enter a system sleep state (see ACPI 2.0 spec p 231)
+ * DESCRIPTION: Enter a system sleep state via the legacy FADT PM registers
  *              THIS FUNCTION MUST BE CALLED WITH INTERRUPTS DISABLED
  *
  ******************************************************************************/
-acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
+
+acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 {
-	u32 pm1a_control;
-	u32 pm1b_control;
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
+	u32 pm1a_control;
+	u32 pm1b_control;
 	u32 in_value;
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
 	acpi_status status;
 
-	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state);
-
-	if ((acpi_gbl_sleep_type_a > ACPI_SLEEP_TYPE_MAX) ||
-	    (acpi_gbl_sleep_type_b > ACPI_SLEEP_TYPE_MAX)) {
-		ACPI_ERROR((AE_INFO, "Sleep values out of range: A=0x%X B=0x%X",
-			    acpi_gbl_sleep_type_a, acpi_gbl_sleep_type_b));
-		return_ACPI_STATUS(AE_AML_OPERAND_VALUE);
-	}
+	ACPI_FUNCTION_TRACE(hw_legacy_sleep);
 
 	sleep_type_reg_info =
 	    acpi_hw_get_bit_register_info(ACPI_BITREG_SLEEP_TYPE);
@@ -271,6 +241,18 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 		return_ACPI_STATUS(status);
 	}
 
+	if (sleep_state != ACPI_STATE_S5) {
+		/*
+		 * Disable BM arbitration. This feature is contained within an
+		 * optional register (PM2 Control), so ignore a BAD_ADDRESS
+		 * exception.
+		 */
+		status = acpi_write_bit_register(ACPI_BITREG_ARB_DISABLE, 1);
+		if (ACPI_FAILURE(status) && (status != AE_BAD_ADDRESS)) {
+			return_ACPI_STATUS(status);
+		}
+	}
+
 	/*
 	 * 1) Disable/Clear all GPEs
 	 * 2) Enable all wakeup GPEs
@@ -286,19 +268,9 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 		return_ACPI_STATUS(status);
 	}
 
-	if (gts) {
-		/* Execute the _GTS method */
+	/* Execute the _GTS method (Going To Sleep) */
 
-		arg_list.count = 1;
-		arg_list.pointer = &arg;
-		arg.type = ACPI_TYPE_INTEGER;
-		arg.integer.value = sleep_state;
-
-		status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
-		if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-			return_ACPI_STATUS(status);
-		}
-	}
+	acpi_hw_execute_GTS(sleep_state);
 
 	/* Get current value of PM1A control */
 
@@ -375,114 +347,43 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 		}
 	}
 
-	/* Wait until we enter sleep state */
-
-	do {
-		status = acpi_read_bit_register(ACPI_BITREG_WAKE_STATUS,
-						    &in_value);
-		if (ACPI_FAILURE(status)) {
-			return_ACPI_STATUS(status);
-		}
-
-		/* Spin until we wake */
-
-	} while (!in_value);
-
-	return_ACPI_STATUS(AE_OK);
-}
-
-ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state)
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_enter_sleep_state_s4bios
- *
- * PARAMETERS:  None
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Perform a S4 bios request.
- *              THIS FUNCTION MUST BE CALLED WITH INTERRUPTS DISABLED
- *
- ******************************************************************************/
-acpi_status asmlinkage acpi_enter_sleep_state_s4bios(void)
-{
-	u32 in_value;
-	acpi_status status;
-
-	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state_s4bios);
-
-	/* Clear the wake status bit (PM1) */
-
-	status =
-	    acpi_write_bit_register(ACPI_BITREG_WAKE_STATUS, ACPI_CLEAR_STATUS);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	status = acpi_hw_clear_acpi_status();
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/*
-	 * 1) Disable/Clear all GPEs
-	 * 2) Enable all wakeup GPEs
-	 */
-	status = acpi_hw_disable_all_gpes();
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-	acpi_gbl_system_awake_and_running = FALSE;
-
-	status = acpi_hw_enable_all_wakeup_gpes();
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	ACPI_FLUSH_CPU_CACHE();
-
-	status = acpi_hw_write_port(acpi_gbl_FADT.smi_command,
-				    (u32) acpi_gbl_FADT.S4bios_request, 8);
+	/* Wait for transition back to Working State */
 
 	do {
-		acpi_os_stall(1000);
 		status =
 		    acpi_read_bit_register(ACPI_BITREG_WAKE_STATUS, &in_value);
 		if (ACPI_FAILURE(status)) {
 			return_ACPI_STATUS(status);
 		}
+
 	} while (!in_value);
 
 	return_ACPI_STATUS(AE_OK);
 }
 
-ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_s4bios)
-
 /*******************************************************************************
  *
- * FUNCTION:    acpi_leave_sleep_state_prep
+ * FUNCTION:    acpi_hw_legacy_wake_prep
  *
- * PARAMETERS:  sleep_state         - Which sleep state we are exiting
+ * PARAMETERS:  sleep_state         - Which sleep state we just exited
  *
  * RETURN:      Status
  *
  * DESCRIPTION: Perform the first state of OS-independent ACPI cleanup after a
  *              sleep.
- *              Called with interrupts DISABLED.
+ *              Called with interrupts ENABLED.
  *
  ******************************************************************************/
-acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
+
+acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 {
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
 	acpi_status status;
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
 	u32 pm1a_control;
 	u32 pm1b_control;
 
-	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state_prep);
+	ACPI_FUNCTION_TRACE(hw_legacy_wake_prep);
 
 	/*
 	 * Set SLP_TYPE and SLP_EN to state S0.
@@ -525,25 +426,13 @@ acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
 		}
 	}
 
-	if (bfs) {
-		/* Execute the _BFS method */
-
-		arg_list.count = 1;
-		arg_list.pointer = &arg;
-		arg.type = ACPI_TYPE_INTEGER;
-		arg.integer.value = sleep_state;
-
-		status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
-		if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-			ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
-		}
-	}
+	acpi_hw_execute_BFS(sleep_state);
 	return_ACPI_STATUS(status);
 }
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_leave_sleep_state
+ * FUNCTION:    acpi_hw_legacy_wake
  *
  * PARAMETERS:  sleep_state         - Which sleep state we just exited
  *
@@ -553,31 +442,17 @@ acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
  *              Called with interrupts ENABLED.
  *
  ******************************************************************************/
-acpi_status acpi_leave_sleep_state(u8 sleep_state)
+
+acpi_status acpi_hw_legacy_wake(u8 sleep_state)
 {
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
 	acpi_status status;
 
-	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
+	ACPI_FUNCTION_TRACE(hw_legacy_wake);
 
 	/* Ensure enter_sleep_state_prep -> enter_sleep_state ordering */
 
 	acpi_gbl_sleep_type_a = ACPI_SLEEP_TYPE_INVALID;
-
-	/* Setup parameter object */
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-
-	/* Ignore any errors from these methods */
-
-	arg.integer.value = ACPI_SST_WAKING;
-	status = acpi_evaluate_object(NULL, METHOD_NAME__SST, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status, "During Method _SST"));
-	}
+	acpi_hw_execute_SST(ACPI_SST_WAKING);
 
 	/*
 	 * GPEs must be enabled before _WAK is called as GPEs
@@ -591,46 +466,201 @@ acpi_status acpi_leave_sleep_state(u8 sleep_state)
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
+
 	status = acpi_hw_enable_all_runtime_gpes();
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
 
-	arg.integer.value = sleep_state;
-	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
-	}
-	/* TBD: _WAK "sometimes" returns stuff - do we want to look at it? */
+	/*
+	 * Now we can execute _WAK, etc. Some machines require that the GPEs
+	 * are enabled before the wake methods are executed.
+	 */
+	acpi_hw_execute_WAK(sleep_state);
 
 	/*
-	 * Some BIOSes assume that WAK_STS will be cleared on resume and use
-	 * it to determine whether the system is rebooting or resuming. Clear
-	 * it for compatibility.
+	 * Some BIOS code assumes that WAK_STS will be cleared on resume
+	 * and use it to determine whether the system is rebooting or
+	 * resuming. Clear WAK_STS for compatibility.
 	 */
 	acpi_write_bit_register(ACPI_BITREG_WAKE_STATUS, 1);
-
 	acpi_gbl_system_awake_and_running = TRUE;
 
 	/* Enable power button */
 
 	(void)
 	    acpi_write_bit_register(acpi_gbl_fixed_event_info
-			      [ACPI_EVENT_POWER_BUTTON].
-			      enable_register_id, ACPI_ENABLE_EVENT);
+				    [ACPI_EVENT_POWER_BUTTON].
+				    enable_register_id, ACPI_ENABLE_EVENT);
 
 	(void)
 	    acpi_write_bit_register(acpi_gbl_fixed_event_info
-			      [ACPI_EVENT_POWER_BUTTON].
-			      status_register_id, ACPI_CLEAR_STATUS);
+				    [ACPI_EVENT_POWER_BUTTON].
+				    status_register_id, ACPI_CLEAR_STATUS);
 
-	arg.integer.value = ACPI_SST_WORKING;
-	status = acpi_evaluate_object(NULL, METHOD_NAME__SST, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status, "During Method _SST"));
+	/*
+	 * Enable BM arbitration. This feature is contained within an
+	 * optional register (PM2 Control), so ignore a BAD_ADDRESS
+	 * exception.
+	 */
+	status = acpi_write_bit_register(ACPI_BITREG_ARB_DISABLE, 0);
+	if (ACPI_FAILURE(status) && (status != AE_BAD_ADDRESS)) {
+		return_ACPI_STATUS(status);
 	}
 
+	acpi_hw_execute_SST(ACPI_SST_WORKING);
 	return_ACPI_STATUS(status);
 }
 
-ACPI_EXPORT_SYMBOL(acpi_leave_sleep_state)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_hw_extended_sleep
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state to enter
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Enter a system sleep state via the extended FADT sleep
+ *              registers (V5 FADT).
+ *              THIS FUNCTION MUST BE CALLED WITH INTERRUPTS DISABLED
+ *
+ ******************************************************************************/
+
+acpi_status acpi_hw_extended_sleep(u8 sleep_state)
+{
+	acpi_status status;
+	u8 sleep_type_value;
+	u64 sleep_status;
+
+	ACPI_FUNCTION_TRACE(hw_extended_sleep);
+
+	/* Extended sleep registers must be valid */
+
+	if (!acpi_gbl_FADT.sleep_control.address ||
+	    !acpi_gbl_FADT.sleep_status.address) {
+		return_ACPI_STATUS(AE_NOT_EXIST);
+	}
+
+	/* Clear wake status (WAK_STS) */
+
+	status = acpi_write(ACPI_X_WAKE_STATUS, &acpi_gbl_FADT.sleep_status);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	acpi_gbl_system_awake_and_running = FALSE;
+
+	/* Execute the _GTS method (Going To Sleep) */
+
+	acpi_hw_execute_GTS(sleep_state);
+
+	/* Flush caches, as per ACPI specification */
+
+	ACPI_FLUSH_CPU_CACHE();
+
+	/*
+	 * Set the SLP_TYP and SLP_EN bits.
+	 *
+	 * Note: We only use the first value returned by the \_Sx method
+	 * (acpi_gbl_sleep_type_a) - As per ACPI specification.
+	 */
+	ACPI_DEBUG_PRINT((ACPI_DB_INIT,
+			  "Entering sleep state [S%u]\n", sleep_state));
+
+	sleep_type_value =
+	    ((acpi_gbl_sleep_type_a << ACPI_X_SLEEP_TYPE_POSITION) &
+	     ACPI_X_SLEEP_TYPE_MASK);
+
+	status = acpi_write((sleep_type_value | ACPI_X_SLEEP_ENABLE),
+			    &acpi_gbl_FADT.sleep_control);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Wait for transition back to Working State */
+
+	do {
+		status = acpi_read(&sleep_status, &acpi_gbl_FADT.sleep_status);
+		if (ACPI_FAILURE(status)) {
+			return_ACPI_STATUS(status);
+		}
+
+	} while (!(((u8)sleep_status) & ACPI_X_WAKE_STATUS));
+
+	return_ACPI_STATUS(AE_OK);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_hw_extended_wake_prep
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state we just exited
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Perform first part of OS-independent ACPI cleanup after
+ *              a sleep. Called with interrupts ENABLED.
+ *
+ ******************************************************************************/
+
+acpi_status acpi_hw_extended_wake_prep(u8 sleep_state)
+{
+	acpi_status status;
+	u8 sleep_type_value;
+
+	ACPI_FUNCTION_TRACE(hw_extended_wake_prep);
+
+	status = acpi_get_sleep_type_data(ACPI_STATE_S0,
+					  &acpi_gbl_sleep_type_a,
+					  &acpi_gbl_sleep_type_b);
+	if (ACPI_SUCCESS(status)) {
+		sleep_type_value =
+		    ((acpi_gbl_sleep_type_a << ACPI_X_SLEEP_TYPE_POSITION) &
+		     ACPI_X_SLEEP_TYPE_MASK);
+
+		(void)acpi_write((sleep_type_value | ACPI_X_SLEEP_ENABLE),
+				 &acpi_gbl_FADT.sleep_control);
+	}
+
+	acpi_hw_execute_BFS(sleep_state);
+	return_ACPI_STATUS(AE_OK);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_hw_extended_wake
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state we just exited
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Perform OS-independent ACPI cleanup after a sleep
+ *              Called with interrupts ENABLED.
+ *
+ ******************************************************************************/
+
+acpi_status acpi_hw_extended_wake(u8 sleep_state)
+{
+	ACPI_FUNCTION_TRACE(hw_extended_wake);
+
+	/* Ensure enter_sleep_state_prep -> enter_sleep_state ordering */
+
+	acpi_gbl_sleep_type_a = ACPI_SLEEP_TYPE_INVALID;
+
+	/* Execute the wake methods */
+
+	acpi_hw_execute_SST(ACPI_SST_WAKING);
+	acpi_hw_execute_WAK(sleep_state);
+
+	/*
+	 * Some BIOS code assumes that WAK_STS will be cleared on resume
+	 * and use it to determine whether the system is rebooting or
+	 * resuming. Clear WAK_STS for compatibility.
+	 */
+	(void)acpi_write(ACPI_X_WAKE_STATUS, &acpi_gbl_FADT.sleep_status);
+	acpi_gbl_system_awake_and_running = TRUE;
+
+	acpi_hw_execute_SST(ACPI_SST_WORKING);
+	return_ACPI_STATUS(AE_OK);
+}
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
new file mode 100644
index 0000000..29c0fd3
--- /dev/null
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -0,0 +1,377 @@
+/******************************************************************************
+ *
+ * Name: hwxfsleep.c - ACPI Hardware Sleep/Wake External Interfaces
+ *
+ *****************************************************************************/
+
+/*
+ * Copyright (C) 2000 - 2012, Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#include <acpi/acpi.h>
+#include "accommon.h"
+#include <linux/module.h>
+
+#define _COMPONENT          ACPI_HARDWARE
+ACPI_MODULE_NAME("hwxfsleep")
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_set_firmware_waking_vector
+ *
+ * PARAMETERS:  physical_address    - 32-bit physical address of ACPI real mode
+ *                                    entry point.
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Sets the 32-bit firmware_waking_vector field of the FACS
+ *
+ ******************************************************************************/
+acpi_status acpi_set_firmware_waking_vector(u32 physical_address)
+{
+	ACPI_FUNCTION_TRACE(acpi_set_firmware_waking_vector);
+
+
+	/*
+	 * According to the ACPI specification 2.0c and later, the 64-bit
+	 * waking vector should be cleared and the 32-bit waking vector should
+	 * be used, unless we want the wake-up code to be called by the BIOS in
+	 * Protected Mode.  Some systems (for example HP dv5-1004nr) are known
+	 * to fail to resume if the 64-bit vector is used.
+	 */
+
+	/* Set the 32-bit vector */
+
+	acpi_gbl_FACS->firmware_waking_vector = physical_address;
+
+	/* Clear the 64-bit vector if it exists */
+
+	if ((acpi_gbl_FACS->length > 32) && (acpi_gbl_FACS->version >= 1)) {
+		acpi_gbl_FACS->xfirmware_waking_vector = 0;
+	}
+
+	return_ACPI_STATUS(AE_OK);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_set_firmware_waking_vector)
+
+#if ACPI_MACHINE_WIDTH == 64
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_set_firmware_waking_vector64
+ *
+ * PARAMETERS:  physical_address    - 64-bit physical address of ACPI protected
+ *                                    mode entry point.
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Sets the 64-bit X_firmware_waking_vector field of the FACS, if
+ *              it exists in the table. This function is intended for use with
+ *              64-bit host operating systems.
+ *
+ ******************************************************************************/
+acpi_status acpi_set_firmware_waking_vector64(u64 physical_address)
+{
+	ACPI_FUNCTION_TRACE(acpi_set_firmware_waking_vector64);
+
+
+	/* Determine if the 64-bit vector actually exists */
+
+	if ((acpi_gbl_FACS->length <= 32) || (acpi_gbl_FACS->version < 1)) {
+		return_ACPI_STATUS(AE_NOT_EXIST);
+	}
+
+	/* Clear 32-bit vector, set the 64-bit X_ vector */
+
+	acpi_gbl_FACS->firmware_waking_vector = 0;
+	acpi_gbl_FACS->xfirmware_waking_vector = physical_address;
+	return_ACPI_STATUS(AE_OK);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_set_firmware_waking_vector64)
+#endif
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_enter_sleep_state_s4bios
+ *
+ * PARAMETERS:  None
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Perform a S4 bios request.
+ *              THIS FUNCTION MUST BE CALLED WITH INTERRUPTS DISABLED
+ *
+ ******************************************************************************/
+acpi_status asmlinkage acpi_enter_sleep_state_s4bios(void)
+{
+	u32 in_value;
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state_s4bios);
+
+	/* Clear the wake status bit (PM1) */
+
+	status =
+	    acpi_write_bit_register(ACPI_BITREG_WAKE_STATUS, ACPI_CLEAR_STATUS);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	status = acpi_hw_clear_acpi_status();
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/*
+	 * 1) Disable/Clear all GPEs
+	 * 2) Enable all wakeup GPEs
+	 */
+	status = acpi_hw_disable_all_gpes();
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+	acpi_gbl_system_awake_and_running = FALSE;
+
+	status = acpi_hw_enable_all_wakeup_gpes();
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	ACPI_FLUSH_CPU_CACHE();
+
+	status = acpi_hw_write_port(acpi_gbl_FADT.smi_command,
+				    (u32)acpi_gbl_FADT.S4bios_request, 8);
+
+	do {
+		acpi_os_stall(1000);
+		status =
+		    acpi_read_bit_register(ACPI_BITREG_WAKE_STATUS, &in_value);
+		if (ACPI_FAILURE(status)) {
+			return_ACPI_STATUS(status);
+		}
+	} while (!in_value);
+
+	return_ACPI_STATUS(AE_OK);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_s4bios)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_enter_sleep_state_prep
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state to enter
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Prepare to enter a system sleep state (see ACPI 2.0 spec p 231)
+ *              This function must execute with interrupts enabled.
+ *              We break sleeping into 2 stages so that OSPM can handle
+ *              various OS-specific tasks between the two steps.
+ *
+ ******************************************************************************/
+acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
+{
+	acpi_status status;
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+	u32 sst_value;
+
+	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state_prep);
+
+	/* _PSW methods could be run here to enable wake-on keyboard, LAN, etc. */
+
+	status = acpi_get_sleep_type_data(sleep_state,
+					  &acpi_gbl_sleep_type_a,
+					  &acpi_gbl_sleep_type_b);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Execute the _PTS method (Prepare To Sleep) */
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = sleep_state;
+
+	status = acpi_evaluate_object(NULL, METHOD_NAME__PTS, &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Setup the argument to the _SST method (System STatus) */
+
+	switch (sleep_state) {
+	case ACPI_STATE_S0:
+		sst_value = ACPI_SST_WORKING;
+		break;
+
+	case ACPI_STATE_S1:
+	case ACPI_STATE_S2:
+	case ACPI_STATE_S3:
+		sst_value = ACPI_SST_SLEEPING;
+		break;
+
+	case ACPI_STATE_S4:
+		sst_value = ACPI_SST_SLEEP_CONTEXT;
+		break;
+
+	default:
+		sst_value = ACPI_SST_INDICATOR_OFF;	/* Default is off */
+		break;
+	}
+
+	/*
+	 * Set the system indicators to show the desired sleep state.
+	 * _SST is an optional method (return no error if not found)
+	 */
+	acpi_hw_execute_SST(sst_value);
+	return_ACPI_STATUS(AE_OK);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_prep)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_enter_sleep_state
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state to enter
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Enter a system sleep state (see ACPI 2.0 spec p 231)
+ *              THIS FUNCTION MUST BE CALLED WITH INTERRUPTS DISABLED
+ *
+ ******************************************************************************/
+acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
+{
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state);
+
+	if ((acpi_gbl_sleep_type_a > ACPI_SLEEP_TYPE_MAX) ||
+	    (acpi_gbl_sleep_type_b > ACPI_SLEEP_TYPE_MAX)) {
+		ACPI_ERROR((AE_INFO, "Sleep values out of range: A=0x%X B=0x%X",
+			    acpi_gbl_sleep_type_a, acpi_gbl_sleep_type_b));
+		return_ACPI_STATUS(AE_AML_OPERAND_VALUE);
+	}
+
+	/* If Hardware Reduced flag is set, must use the extended sleep registers */
+
+	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
+		status = acpi_hw_extended_sleep(sleep_state);
+	} else {
+		/* Legacy sleep */
+
+		status = acpi_hw_legacy_sleep(sleep_state);
+	}
+
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_leave_sleep_state_prep
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state we are exiting
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Perform the first state of OS-independent ACPI cleanup after a
+ *              sleep.
+ *              Called with interrupts DISABLED.
+ *
+ ******************************************************************************/
+acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
+{
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
+
+
+	/* If Hardware Reduced flag is set, must use the extended sleep registers */
+
+	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
+		status = acpi_hw_extended_wake_prep(sleep_state);
+	} else {
+		/* Legacy sleep */
+
+		status = acpi_hw_legacy_wake_prep(sleep_state);
+	}
+
+
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_leave_sleep_state_prep)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_leave_sleep_state
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state we just exited
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Perform OS-independent ACPI cleanup after a sleep
+ *              Called with interrupts ENABLED.
+ *
+ ******************************************************************************/
+acpi_status acpi_leave_sleep_state(u8 sleep_state)
+{
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
+
+
+	/* If Hardware Reduced flag is set, must use the extended sleep registers */
+
+	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
+		status = acpi_hw_extended_wake(sleep_state);
+	} else {
+		/* Legacy sleep */
+
+		status = acpi_hw_legacy_wake(sleep_state);
+	}
+
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_leave_sleep_state)
diff --git a/include/acpi/actbl.h b/include/acpi/actbl.h
index 8e1b92f..8dea546 100644
--- a/include/acpi/actbl.h
+++ b/include/acpi/actbl.h
@@ -309,6 +309,13 @@ enum acpi_prefered_pm_profiles {
 	PM_TABLET = 8
 };
 
+/* Values for sleep_status and sleep_control registers (V5 FADT) */
+
+#define ACPI_X_WAKE_STATUS          0x80
+#define ACPI_X_SLEEP_TYPE_MASK      0x1C
+#define ACPI_X_SLEEP_TYPE_POSITION  0x02
+#define ACPI_X_SLEEP_ENABLE         0x20
+
 /* Reset to default packing */
 
 #pragma pack()
-- 
1.7.10.rc2.19.gfae9d

