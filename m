Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868Ab2C3NS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:18:26 -0400
Received: from vms173021pub.verizon.net ([206.46.173.21]:33452 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab2C3NSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:18:18 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 31/76] ACPICA: Split sleep/wake functions into two files
Date: Fri, 30 Mar 2012 06:13:34 -0400
Message-id: <709585765734e90d9fe0a2dc9c6f4e49eff5c6ec.1333101989.git.len.brown@intel.com>
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

The functions for the original/legacy sleep/wake registers are in
hwsleep.c, and the functions for the new extended FADT V5 sleep
registers are in hwesleep.c

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/Makefile   |    1 +
 drivers/acpi/acpica/achware.h  |   17 +--
 drivers/acpi/acpica/hwesleep.c |  251 ++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/hwsleep.c  |  207 +--------------------------------
 4 files changed, 265 insertions(+), 211 deletions(-)
 create mode 100644 drivers/acpi/acpica/hwesleep.c

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index da55180..793b8cc 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -68,6 +68,7 @@ acpi-y +=		\
 
 acpi-y +=		\
 	hwacpi.o	\
+	hwesleep.o	\
 	hwgpe.o		\
 	hwpci.o		\
 	hwregs.o	\
diff --git a/drivers/acpi/acpica/achware.h b/drivers/acpi/acpica/achware.h
index d3f62a8..5de4ec7 100644
--- a/drivers/acpi/acpica/achware.h
+++ b/drivers/acpi/acpica/achware.h
@@ -81,22 +81,25 @@ acpi_status acpi_hw_register_write(u32 register_id, u32 value);
 acpi_status acpi_hw_clear_acpi_status(void);
 
 /*
- * hwsleep - sleep/wake support
+ * hwsleep - sleep/wake support (Legacy sleep registers)
+ */
+acpi_status acpi_hw_legacy_sleep(u8 sleep_state);
+
+acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state);
+
+acpi_status acpi_hw_legacy_wake(u8 sleep_state);
+
+/*
+ * hwesleep - sleep/wake support (Extended FADT-V5 sleep registers)
  */
 void acpi_hw_execute_sleep_method(char *method_name, u32 integer_argument);
 
 acpi_status acpi_hw_extended_sleep(u8 sleep_state);
 
-acpi_status acpi_hw_legacy_sleep(u8 sleep_state);
-
 acpi_status acpi_hw_extended_wake_prep(u8 sleep_state);
 
 acpi_status acpi_hw_extended_wake(u8 sleep_state);
 
-acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state);
-
-acpi_status acpi_hw_legacy_wake(u8 sleep_state);
-
 /*
  * hwvalid - Port I/O with validation
  */
diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
new file mode 100644
index 0000000..9e44c6c
--- /dev/null
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -0,0 +1,251 @@
+/******************************************************************************
+ *
+ * Name: hwesleep.c - ACPI Hardware Sleep/Wake Support functions for the
+ *                    extended FADT-V5 sleep registers.
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
+ACPI_MODULE_NAME("hwesleep")
+
+static unsigned int gts, bfs;
+module_param(gts, uint, 0644);
+module_param(bfs, uint, 0644);
+MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
+MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_hw_execute_sleep_method
+ *
+ * PARAMETERS:  method_name         - Pathname of method to execute
+ *              integer_argument    - Argument to pass to the method
+ *
+ * RETURN:      None
+ *
+ * DESCRIPTION: Execute a sleep/wake related method with one integer argument
+ *              and no return value.
+ *
+ ******************************************************************************/
+void acpi_hw_execute_sleep_method(char *method_name, u32 integer_argument)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(hw_execute_sleep_method);
+
+	if (!ACPI_STRCMP(METHOD_NAME__GTS, method_name) && !gts)
+		return_VOID;
+
+	if (!ACPI_STRCMP(METHOD_NAME__BFS, method_name) && !bfs)
+		return_VOID;
+
+	/* One argument, integer_argument; No return value expected */
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = (u64)integer_argument;
+
+	status = acpi_evaluate_object(NULL, method_name, &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		ACPI_EXCEPTION((AE_INFO, status, "While executing method %s",
+				method_name));
+	}
+
+	return_VOID;
+}
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
+	acpi_hw_execute_sleep_method(METHOD_NAME__GTS, sleep_state);
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
+	acpi_hw_execute_sleep_method(METHOD_NAME__BFS, sleep_state);
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
+	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WAKING);
+	acpi_hw_execute_sleep_method(METHOD_NAME__WAK, sleep_state);
+
+	/*
+	 * Some BIOS code assumes that WAK_STS will be cleared on resume
+	 * and use it to determine whether the system is rebooting or
+	 * resuming. Clear WAK_STS for compatibility.
+	 */
+	(void)acpi_write(ACPI_X_WAKE_STATUS, &acpi_gbl_FADT.sleep_status);
+	acpi_gbl_system_awake_and_running = TRUE;
+
+	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WORKING);
+	return_ACPI_STATUS(AE_OK);
+}
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index abe65ff..b96d41b 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
- * Name: hwsleep.c - ACPI Hardware Sleep/Wake Support Functions
+ * Name: hwsleep.c - ACPI Hardware Sleep/Wake Support functions for the
+ *                   original/legacy sleep/PM registers.
  *
  *****************************************************************************/
 
@@ -49,56 +50,7 @@
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwsleep")
 
-static unsigned int gts, bfs;
-module_param(gts, uint, 0644);
-module_param(bfs, uint, 0644);
-MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
-MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_hw_execute_sleep_method
- *
- * PARAMETERS:  method_name         - Pathname of method to execute
- *              integer_argument    - Argument to pass to the method
- *
- * RETURN:      None
- *
- * DESCRIPTION: Execute a sleep/wake related method, with one integer argument
- *              and no return value.
- *
- ******************************************************************************/
-void acpi_hw_execute_sleep_method(char *method_name, u32 integer_argument)
-{
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
-	acpi_status status;
-
-	ACPI_FUNCTION_TRACE(hw_execute_sleep_method);
-
-	if (!ACPI_STRCMP(METHOD_NAME__GTS, method_name) && !gts)
-		return_VOID;
-
-	if (!ACPI_STRCMP(METHOD_NAME__BFS, method_name) && !bfs)
-		return_VOID;
-
-	/* One argument, integer_argument */
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = (u64)integer_argument;
-
-	status = acpi_evaluate_object(NULL, method_name, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status, "While executing method %s",
-				method_name));
-	}
-
-	return_VOID;
-}
-
-#if (!ACPI_REDUCED_HARDWARE)
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /*******************************************************************************
  *
  * FUNCTION:    acpi_hw_legacy_sleep
@@ -111,7 +63,6 @@ void acpi_hw_execute_sleep_method(char *method_name, u32 integer_argument)
  *              THIS FUNCTION MUST BE CALLED WITH INTERRUPTS DISABLED
  *
  ******************************************************************************/
-
 acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 {
 	struct acpi_bit_register_info *sleep_type_reg_info;
@@ -415,155 +366,3 @@ acpi_status acpi_hw_legacy_wake(u8 sleep_state)
 }
 
 #endif				/* !ACPI_REDUCED_HARDWARE */
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_hw_extended_sleep
- *
- * PARAMETERS:  sleep_state         - Which sleep state to enter
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Enter a system sleep state via the extended FADT sleep
- *              registers (V5 FADT).
- *              THIS FUNCTION MUST BE CALLED WITH INTERRUPTS DISABLED
- *
- ******************************************************************************/
-
-acpi_status acpi_hw_extended_sleep(u8 sleep_state)
-{
-	acpi_status status;
-	u8 sleep_type_value;
-	u64 sleep_status;
-
-	ACPI_FUNCTION_TRACE(hw_extended_sleep);
-
-	/* Extended sleep registers must be valid */
-
-	if (!acpi_gbl_FADT.sleep_control.address ||
-	    !acpi_gbl_FADT.sleep_status.address) {
-		return_ACPI_STATUS(AE_NOT_EXIST);
-	}
-
-	/* Clear wake status (WAK_STS) */
-
-	status = acpi_write(ACPI_X_WAKE_STATUS, &acpi_gbl_FADT.sleep_status);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	acpi_gbl_system_awake_and_running = FALSE;
-
-	/* Execute the _GTS method (Going To Sleep) */
-
-	acpi_hw_execute_sleep_method(METHOD_NAME__GTS, sleep_state);
-
-	/* Flush caches, as per ACPI specification */
-
-	ACPI_FLUSH_CPU_CACHE();
-
-	/*
-	 * Set the SLP_TYP and SLP_EN bits.
-	 *
-	 * Note: We only use the first value returned by the \_Sx method
-	 * (acpi_gbl_sleep_type_a) - As per ACPI specification.
-	 */
-	ACPI_DEBUG_PRINT((ACPI_DB_INIT,
-			  "Entering sleep state [S%u]\n", sleep_state));
-
-	sleep_type_value =
-	    ((acpi_gbl_sleep_type_a << ACPI_X_SLEEP_TYPE_POSITION) &
-	     ACPI_X_SLEEP_TYPE_MASK);
-
-	status = acpi_write((sleep_type_value | ACPI_X_SLEEP_ENABLE),
-			    &acpi_gbl_FADT.sleep_control);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/* Wait for transition back to Working State */
-
-	do {
-		status = acpi_read(&sleep_status, &acpi_gbl_FADT.sleep_status);
-		if (ACPI_FAILURE(status)) {
-			return_ACPI_STATUS(status);
-		}
-
-	} while (!(((u8)sleep_status) & ACPI_X_WAKE_STATUS));
-
-	return_ACPI_STATUS(AE_OK);
-}
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_hw_extended_wake_prep
- *
- * PARAMETERS:  sleep_state         - Which sleep state we just exited
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Perform first part of OS-independent ACPI cleanup after
- *              a sleep. Called with interrupts ENABLED.
- *
- ******************************************************************************/
-
-acpi_status acpi_hw_extended_wake_prep(u8 sleep_state)
-{
-	acpi_status status;
-	u8 sleep_type_value;
-
-	ACPI_FUNCTION_TRACE(hw_extended_wake_prep);
-
-	status = acpi_get_sleep_type_data(ACPI_STATE_S0,
-					  &acpi_gbl_sleep_type_a,
-					  &acpi_gbl_sleep_type_b);
-	if (ACPI_SUCCESS(status)) {
-		sleep_type_value =
-		    ((acpi_gbl_sleep_type_a << ACPI_X_SLEEP_TYPE_POSITION) &
-		     ACPI_X_SLEEP_TYPE_MASK);
-
-		(void)acpi_write((sleep_type_value | ACPI_X_SLEEP_ENABLE),
-				 &acpi_gbl_FADT.sleep_control);
-	}
-
-	acpi_hw_execute_sleep_method(METHOD_NAME__BFS, sleep_state);
-	return_ACPI_STATUS(AE_OK);
-}
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_hw_extended_wake
- *
- * PARAMETERS:  sleep_state         - Which sleep state we just exited
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Perform OS-independent ACPI cleanup after a sleep
- *              Called with interrupts ENABLED.
- *
- ******************************************************************************/
-
-acpi_status acpi_hw_extended_wake(u8 sleep_state)
-{
-	ACPI_FUNCTION_TRACE(hw_extended_wake);
-
-	/* Ensure enter_sleep_state_prep -> enter_sleep_state ordering */
-
-	acpi_gbl_sleep_type_a = ACPI_SLEEP_TYPE_INVALID;
-
-	/* Execute the wake methods */
-
-	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WAKING);
-	acpi_hw_execute_sleep_method(METHOD_NAME__WAK, sleep_state);
-
-	/*
-	 * Some BIOS code assumes that WAK_STS will be cleared on resume
-	 * and use it to determine whether the system is rebooting or
-	 * resuming. Clear WAK_STS for compatibility.
-	 */
-	(void)acpi_write(ACPI_X_WAKE_STATUS, &acpi_gbl_FADT.sleep_status);
-	acpi_gbl_system_awake_and_running = TRUE;
-
-	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WORKING);
-	return_ACPI_STATUS(AE_OK);
-}
-- 
1.7.10.rc2.19.gfae9d

