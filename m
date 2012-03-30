Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174Ab2C3MTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:19:37 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48688 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760702Ab2C3MSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:47 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 30/76] ACPICA: Distill multiple sleep method functions to a
 single function
Date: Fri, 30 Mar 2012 06:13:33 -0400
Message-id: <f99648b1aff8b6158333a06c50d627be3c243a32.1333101989.git.len.brown@intel.com>
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

Adds acpi_hw_execute_sleep_method to handle the various sleep methods
such as _GTS, _BFS, _WAK, and _SST. Removes the specialized
functions previously used for each of these methods.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/achware.h   |    2 +-
 drivers/acpi/acpica/hwsleep.c   |  153 +++++++--------------------------------
 drivers/acpi/acpica/hwxfsleep.c |    2 +-
 3 files changed, 29 insertions(+), 128 deletions(-)

diff --git a/drivers/acpi/acpica/achware.h b/drivers/acpi/acpica/achware.h
index eed204a..d3f62a8 100644
--- a/drivers/acpi/acpica/achware.h
+++ b/drivers/acpi/acpica/achware.h
@@ -83,7 +83,7 @@ acpi_status acpi_hw_clear_acpi_status(void);
 /*
  * hwsleep - sleep/wake support
  */
-void acpi_hw_execute_SST(u32 value);
+void acpi_hw_execute_sleep_method(char *method_name, u32 integer_argument);
 
 acpi_status acpi_hw_extended_sleep(u8 sleep_state);
 
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index fa34147..abe65ff 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -49,13 +49,6 @@
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwsleep")
 
-/* Local prototypes */
-static void acpi_hw_execute_GTS(u8 sleep_state);
-
-static void acpi_hw_execute_BFS(u8 sleep_state);
-
-static void acpi_hw_execute_WAK(u8 sleep_state);
-
 static unsigned int gts, bfs;
 module_param(gts, uint, 0644);
 module_param(bfs, uint, 0644);
@@ -64,137 +57,45 @@ MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_hw_execute_GTS
+ * FUNCTION:    acpi_hw_execute_sleep_method
  *
- * PARAMETERS:  sleep_state         - Sleep state that will be entered
+ * PARAMETERS:  method_name         - Pathname of method to execute
+ *              integer_argument    - Argument to pass to the method
  *
  * RETURN:      None
  *
- * DESCRIPTION: Execute the optional _GTS method (Going To Sleep)
+ * DESCRIPTION: Execute a sleep/wake related method, with one integer argument
+ *              and no return value.
  *
  ******************************************************************************/
-
-static void acpi_hw_execute_GTS(u8 sleep_state)
+void acpi_hw_execute_sleep_method(char *method_name, u32 integer_argument)
 {
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
 	acpi_status status;
 
-	if (!gts)
-		return;
+	ACPI_FUNCTION_TRACE(hw_execute_sleep_method);
 
-	/* One argument, sleep_state */
+	if (!ACPI_STRCMP(METHOD_NAME__GTS, method_name) && !gts)
+		return_VOID;
 
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = sleep_state;
+	if (!ACPI_STRCMP(METHOD_NAME__BFS, method_name) && !bfs)
+		return_VOID;
 
-	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"While executing method _GTS"));
-	}
-}
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_hw_execute_BFS
- *
- * PARAMETERS:  sleep_state         - Which sleep state we just exited
- *
- * RETURN:      None
- *
- * DESCRIPTION: Execute the optional _BFS method (Back From Sleep)
- *
- ******************************************************************************/
-
-static void acpi_hw_execute_BFS(u8 sleep_state)
-{
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
-	acpi_status status;
-
-	if (!bfs)
-		return;
-
-	/* One argument, sleep_state */
+	/* One argument, integer_argument */
 
 	arg_list.count = 1;
 	arg_list.pointer = &arg;
 	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = sleep_state;
+	arg.integer.value = (u64)integer_argument;
 
-	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
+	status = acpi_evaluate_object(NULL, method_name, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"While executing method _BFS"));
+		ACPI_EXCEPTION((AE_INFO, status, "While executing method %s",
+				method_name));
 	}
-}
 
-/*******************************************************************************
- *
- * FUNCTION:    acpi_hw_execute_WAK
- *
- * PARAMETERS:  sleep_state         - Which sleep state we just exited
- *
- * RETURN:      None
- *
- * DESCRIPTION: Execute the _WAK method (System Wake)
- *
- ******************************************************************************/
-
-static void acpi_hw_execute_WAK(u8 sleep_state)
-{
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
-	acpi_status status;
-
-	/* One argument, sleep_state */
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = sleep_state;
-
-	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"While executing method _WAK"));
-	}
-	/* TBD: _WAK "sometimes" returns stuff - do we want to look at it? */
-}
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_hw_execute_SST
- *
- * PARAMETERS:  indicator_id        - Value to be passed to the _SST method
- *
- * RETURN:      None
- *
- * DESCRIPTION: Execute the optional _SST method (System Status)
- *
- ******************************************************************************/
-
-void acpi_hw_execute_SST(u32 indicator_id)
-{
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
-	acpi_status status;
-
-	/* One argument, status indicator ID */
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-
-	arg.integer.value = indicator_id;
-	status = acpi_evaluate_object(NULL, METHOD_NAME__SST, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"While executing method _SST"));
-	}
+	return_VOID;
 }
 
 #if (!ACPI_REDUCED_HARDWARE)
@@ -271,7 +172,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 
 	/* Execute the _GTS method (Going To Sleep) */
 
-	acpi_hw_execute_GTS(sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_NAME__GTS, sleep_state);
 
 	/* Get current value of PM1A control */
 
@@ -427,7 +328,7 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 		}
 	}
 
-	acpi_hw_execute_BFS(sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_NAME__BFS, sleep_state);
 	return_ACPI_STATUS(status);
 }
 
@@ -453,7 +354,7 @@ acpi_status acpi_hw_legacy_wake(u8 sleep_state)
 	/* Ensure enter_sleep_state_prep -> enter_sleep_state ordering */
 
 	acpi_gbl_sleep_type_a = ACPI_SLEEP_TYPE_INVALID;
-	acpi_hw_execute_SST(ACPI_SST_WAKING);
+	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WAKING);
 
 	/*
 	 * GPEs must be enabled before _WAK is called as GPEs
@@ -477,7 +378,7 @@ acpi_status acpi_hw_legacy_wake(u8 sleep_state)
 	 * Now we can execute _WAK, etc. Some machines require that the GPEs
 	 * are enabled before the wake methods are executed.
 	 */
-	acpi_hw_execute_WAK(sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_NAME__WAK, sleep_state);
 
 	/*
 	 * Some BIOS code assumes that WAK_STS will be cleared on resume
@@ -509,7 +410,7 @@ acpi_status acpi_hw_legacy_wake(u8 sleep_state)
 		return_ACPI_STATUS(status);
 	}
 
-	acpi_hw_execute_SST(ACPI_SST_WORKING);
+	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WORKING);
 	return_ACPI_STATUS(status);
 }
 
@@ -555,7 +456,7 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
 
 	/* Execute the _GTS method (Going To Sleep) */
 
-	acpi_hw_execute_GTS(sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_NAME__GTS, sleep_state);
 
 	/* Flush caches, as per ACPI specification */
 
@@ -625,7 +526,7 @@ acpi_status acpi_hw_extended_wake_prep(u8 sleep_state)
 				 &acpi_gbl_FADT.sleep_control);
 	}
 
-	acpi_hw_execute_BFS(sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_NAME__BFS, sleep_state);
 	return_ACPI_STATUS(AE_OK);
 }
 
@@ -652,8 +553,8 @@ acpi_status acpi_hw_extended_wake(u8 sleep_state)
 
 	/* Execute the wake methods */
 
-	acpi_hw_execute_SST(ACPI_SST_WAKING);
-	acpi_hw_execute_WAK(sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WAKING);
+	acpi_hw_execute_sleep_method(METHOD_NAME__WAK, sleep_state);
 
 	/*
 	 * Some BIOS code assumes that WAK_STS will be cleared on resume
@@ -663,6 +564,6 @@ acpi_status acpi_hw_extended_wake(u8 sleep_state)
 	(void)acpi_write(ACPI_X_WAKE_STATUS, &acpi_gbl_FADT.sleep_status);
 	acpi_gbl_system_awake_and_running = TRUE;
 
-	acpi_hw_execute_SST(ACPI_SST_WORKING);
+	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WORKING);
 	return_ACPI_STATUS(AE_OK);
 }
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index d599961..ff20558 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -261,7 +261,7 @@ acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
 	 * Set the system indicators to show the desired sleep state.
 	 * _SST is an optional method (return no error if not found)
 	 */
-	acpi_hw_execute_SST(sst_value);
+	acpi_hw_execute_sleep_method(METHOD_NAME__SST, sst_value);
 	return_ACPI_STATUS(AE_OK);
 }
 
-- 
1.7.10.rc2.19.gfae9d

