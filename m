Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710Ab2C3MTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:19:55 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48688 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760581Ab2C3MSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:50 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 37/76] ACPICA: Sleep/Wake interfaces: optionally execute _GTS
 and _BFS
Date: Fri, 30 Mar 2012 06:13:40 -0400
Message-id: <8a73b17e4c0e09cb5b80deee5451e29b830df4cc.1333101989.git.len.brown@intel.com>
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

Enhanced the sleep/wake interfaces to optionally execute the
_GTS method (Going To Sleep), and the _BFS method (Back From
Sleep).  Windows apparently does not execute these methods, and
therefore these methods are often untested. It has been seen on
some systems where the execution of these methods causes errors
and also prevents the machine from entering S5. It is therefore
suggested that host operating systems do not execute these methods
by default. In the future, perhaps these methods can be optionally
executed based on the age of the system and/or what is the newest
version of Windows that the BIOS asks for via _OSI.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/achware.h   |   12 ++++++------
 drivers/acpi/acpica/hwesleep.c  |   21 +++++++++++++++------
 drivers/acpi/acpica/hwsleep.c   |   21 +++++++++++++++------
 drivers/acpi/acpica/hwxfsleep.c |   35 ++++++++++++++++++++---------------
 drivers/acpi/sleep.c            |   13 +++++++------
 include/acpi/acpixf.h           |    4 ++--
 include/acpi/actypes.h          |    9 ++++++++-
 7 files changed, 73 insertions(+), 42 deletions(-)

diff --git a/drivers/acpi/acpica/achware.h b/drivers/acpi/acpica/achware.h
index 5de4ec7..5ccb99a 100644
--- a/drivers/acpi/acpica/achware.h
+++ b/drivers/acpi/acpica/achware.h
@@ -83,22 +83,22 @@ acpi_status acpi_hw_clear_acpi_status(void);
 /*
  * hwsleep - sleep/wake support (Legacy sleep registers)
  */
-acpi_status acpi_hw_legacy_sleep(u8 sleep_state);
+acpi_status acpi_hw_legacy_sleep(u8 sleep_state, u8 flags);
 
-acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state);
+acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state, u8 flags);
 
-acpi_status acpi_hw_legacy_wake(u8 sleep_state);
+acpi_status acpi_hw_legacy_wake(u8 sleep_state, u8 flags);
 
 /*
  * hwesleep - sleep/wake support (Extended FADT-V5 sleep registers)
  */
 void acpi_hw_execute_sleep_method(char *method_name, u32 integer_argument);
 
-acpi_status acpi_hw_extended_sleep(u8 sleep_state);
+acpi_status acpi_hw_extended_sleep(u8 sleep_state, u8 flags);
 
-acpi_status acpi_hw_extended_wake_prep(u8 sleep_state);
+acpi_status acpi_hw_extended_wake_prep(u8 sleep_state, u8 flags);
 
-acpi_status acpi_hw_extended_wake(u8 sleep_state);
+acpi_status acpi_hw_extended_wake(u8 sleep_state, u8 flags);
 
 /*
  * hwvalid - Port I/O with validation
diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index 6cbc4e1..1c409e8 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -103,6 +103,7 @@ void acpi_hw_execute_sleep_method(char *method_pathname, u32 integer_argument)
  * FUNCTION:    acpi_hw_extended_sleep
  *
  * PARAMETERS:  sleep_state         - Which sleep state to enter
+ *              Flags               - ACPI_EXECUTE_GTS to run optional method
  *
  * RETURN:      Status
  *
@@ -112,7 +113,7 @@ void acpi_hw_execute_sleep_method(char *method_pathname, u32 integer_argument)
  *
  ******************************************************************************/
 
-acpi_status acpi_hw_extended_sleep(u8 sleep_state)
+acpi_status acpi_hw_extended_sleep(u8 sleep_state, u8 flags)
 {
 	acpi_status status;
 	u8 sleep_type_value;
@@ -136,9 +137,11 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
 
 	acpi_gbl_system_awake_and_running = FALSE;
 
-	/* Execute the _GTS method (Going To Sleep) */
+	/* Optionally execute _GTS (Going To Sleep) */
 
-	acpi_hw_execute_sleep_method(METHOD_PATHNAME__GTS, sleep_state);
+	if (flags & ACPI_EXECUTE_GTS) {
+		acpi_hw_execute_sleep_method(METHOD_PATHNAME__GTS, sleep_state);
+	}
 
 	/* Flush caches, as per ACPI specification */
 
@@ -181,6 +184,7 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
  * FUNCTION:    acpi_hw_extended_wake_prep
  *
  * PARAMETERS:  sleep_state         - Which sleep state we just exited
+ *              Flags               - ACPI_EXECUTE_BFS to run optional method
  *
  * RETURN:      Status
  *
@@ -189,7 +193,7 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
  *
  ******************************************************************************/
 
-acpi_status acpi_hw_extended_wake_prep(u8 sleep_state)
+acpi_status acpi_hw_extended_wake_prep(u8 sleep_state, u8 flags)
 {
 	acpi_status status;
 	u8 sleep_type_value;
@@ -208,7 +212,11 @@ acpi_status acpi_hw_extended_wake_prep(u8 sleep_state)
 				 &acpi_gbl_FADT.sleep_control);
 	}
 
-	acpi_hw_execute_sleep_method(METHOD_PATHNAME__BFS, sleep_state);
+	/* Optionally execute _BFS (Back From Sleep) */
+
+	if (flags & ACPI_EXECUTE_BFS) {
+		acpi_hw_execute_sleep_method(METHOD_PATHNAME__BFS, sleep_state);
+	}
 	return_ACPI_STATUS(AE_OK);
 }
 
@@ -217,6 +225,7 @@ acpi_status acpi_hw_extended_wake_prep(u8 sleep_state)
  * FUNCTION:    acpi_hw_extended_wake
  *
  * PARAMETERS:  sleep_state         - Which sleep state we just exited
+ *              Flags               - Reserved, set to zero
  *
  * RETURN:      Status
  *
@@ -225,7 +234,7 @@ acpi_status acpi_hw_extended_wake_prep(u8 sleep_state)
  *
  ******************************************************************************/
 
-acpi_status acpi_hw_extended_wake(u8 sleep_state)
+acpi_status acpi_hw_extended_wake(u8 sleep_state, u8 flags)
 {
 	ACPI_FUNCTION_TRACE(hw_extended_wake);
 
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index aba3634..8ab325c 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -56,6 +56,7 @@ ACPI_MODULE_NAME("hwsleep")
  * FUNCTION:    acpi_hw_legacy_sleep
  *
  * PARAMETERS:  sleep_state         - Which sleep state to enter
+ *              Flags               - ACPI_EXECUTE_GTS to run optional method
  *
  * RETURN:      Status
  *
@@ -63,7 +64,7 @@ ACPI_MODULE_NAME("hwsleep")
  *              THIS FUNCTION MUST BE CALLED WITH INTERRUPTS DISABLED
  *
  ******************************************************************************/
-acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
+acpi_status acpi_hw_legacy_sleep(u8 sleep_state, u8 flags)
 {
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
@@ -121,9 +122,11 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 		return_ACPI_STATUS(status);
 	}
 
-	/* Execute the _GTS method (Going To Sleep) */
+	/* Optionally execute _GTS (Going To Sleep) */
 
-	acpi_hw_execute_sleep_method(METHOD_PATHNAME__GTS, sleep_state);
+	if (flags & ACPI_EXECUTE_GTS) {
+		acpi_hw_execute_sleep_method(METHOD_PATHNAME__GTS, sleep_state);
+	}
 
 	/* Get current value of PM1A control */
 
@@ -219,6 +222,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
  * FUNCTION:    acpi_hw_legacy_wake_prep
  *
  * PARAMETERS:  sleep_state         - Which sleep state we just exited
+ *              Flags               - ACPI_EXECUTE_BFS to run optional method
  *
  * RETURN:      Status
  *
@@ -228,7 +232,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
  *
  ******************************************************************************/
 
-acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
+acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state, u8 flags)
 {
 	acpi_status status;
 	struct acpi_bit_register_info *sleep_type_reg_info;
@@ -279,7 +283,11 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 		}
 	}
 
-	acpi_hw_execute_sleep_method(METHOD_PATHNAME__BFS, sleep_state);
+	/* Optionally execute _BFS (Back From Sleep) */
+
+	if (flags & ACPI_EXECUTE_BFS) {
+		acpi_hw_execute_sleep_method(METHOD_PATHNAME__BFS, sleep_state);
+	}
 	return_ACPI_STATUS(status);
 }
 
@@ -288,6 +296,7 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
  * FUNCTION:    acpi_hw_legacy_wake
  *
  * PARAMETERS:  sleep_state         - Which sleep state we just exited
+ *              Flags               - Reserved, set to zero
  *
  * RETURN:      Status
  *
@@ -296,7 +305,7 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
  *
  ******************************************************************************/
 
-acpi_status acpi_hw_legacy_wake(u8 sleep_state)
+acpi_status acpi_hw_legacy_wake(u8 sleep_state, u8 flags)
 {
 	acpi_status status;
 
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index cf0168e..762d059 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -49,15 +49,16 @@
 ACPI_MODULE_NAME("hwxfsleep")
 
 /* Local prototypes */
-static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id);
+static acpi_status
+acpi_hw_sleep_dispatch(u8 sleep_state, u8 flags, u32 function_id);
 
 /*
  * Dispatch table used to efficiently branch to the various sleep
  * functions.
  */
-#define ACPI_SLEEP_FUNCTION         0
-#define ACPI_WAKE_PREP_FUNCTION     1
-#define ACPI_WAKE_FUNCTION          2
+#define ACPI_SLEEP_FUNCTION_ID         0
+#define ACPI_WAKE_PREP_FUNCTION_ID     1
+#define ACPI_WAKE_FUNCTION_ID          2
 
 /* Legacy functions are optional, based upon ACPI_REDUCED_HARDWARE */
 
@@ -233,7 +234,8 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_s4bios)
  *              function.
  *
  ******************************************************************************/
-static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id)
+static acpi_status
+acpi_hw_sleep_dispatch(u8 sleep_state, u8 flags, u32 function_id)
 {
 	acpi_status status;
 	struct acpi_sleep_functions *sleep_functions =
@@ -246,11 +248,11 @@ static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id)
 	 * use the extended sleep registers
 	 */
 	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
-		status = sleep_functions->extended_function(sleep_state);
+		status = sleep_functions->extended_function(sleep_state, flags);
 	} else {
 		/* Legacy sleep */
 
-		status = sleep_functions->legacy_function(sleep_state);
+		status = sleep_functions->legacy_function(sleep_state, flags);
 	}
 
 	return (status);
@@ -260,7 +262,7 @@ static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id)
 	 * For the case where reduced-hardware-only code is being generated,
 	 * we know that only the extended sleep registers are available
 	 */
-	status = sleep_functions->extended_function(sleep_state);
+	status = sleep_functions->extended_function(sleep_state, flags);
 	return (status);
 
 #endif				/* !ACPI_REDUCED_HARDWARE */
@@ -290,8 +292,6 @@ acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
 
 	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state_prep);
 
-	/* _PSW methods could be run here to enable wake-on keyboard, LAN, etc. */
-
 	status = acpi_get_sleep_type_data(sleep_state,
 					  &acpi_gbl_sleep_type_a,
 					  &acpi_gbl_sleep_type_b);
@@ -349,6 +349,7 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_prep)
  * FUNCTION:    acpi_enter_sleep_state
  *
  * PARAMETERS:  sleep_state         - Which sleep state to enter
+ *              Flags               - ACPI_EXECUTE_GTS to run optional method
  *
  * RETURN:      Status
  *
@@ -356,7 +357,7 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_prep)
  *              THIS FUNCTION MUST BE CALLED WITH INTERRUPTS DISABLED
  *
  ******************************************************************************/
-acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
+acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state, u8 flags)
 {
 	acpi_status status;
 
@@ -369,7 +370,8 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 		return_ACPI_STATUS(AE_AML_OPERAND_VALUE);
 	}
 
-	status = acpi_hw_sleep_dispatch(sleep_state, ACPI_SLEEP_FUNCTION);
+	status =
+	    acpi_hw_sleep_dispatch(sleep_state, flags, ACPI_SLEEP_FUNCTION_ID);
 	return_ACPI_STATUS(status);
 }
 
@@ -380,6 +382,7 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state)
  * FUNCTION:    acpi_leave_sleep_state_prep
  *
  * PARAMETERS:  sleep_state         - Which sleep state we are exiting
+ *              Flags               - ACPI_EXECUTE_BFS to run optional method
  *
  * RETURN:      Status
  *
@@ -388,13 +391,15 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state)
  *              Called with interrupts DISABLED.
  *
  ******************************************************************************/
-acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
+acpi_status acpi_leave_sleep_state_prep(u8 sleep_state, u8 flags)
 {
 	acpi_status status;
 
 	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state_prep);
 
-	status = acpi_hw_sleep_dispatch(sleep_state, ACPI_WAKE_PREP_FUNCTION);
+	status =
+	    acpi_hw_sleep_dispatch(sleep_state, flags,
+				   ACPI_WAKE_PREP_FUNCTION_ID);
 	return_ACPI_STATUS(status);
 }
 
@@ -419,7 +424,7 @@ acpi_status acpi_leave_sleep_state(u8 sleep_state)
 	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
 
 
-	status = acpi_hw_sleep_dispatch(sleep_state, ACPI_WAKE_FUNCTION);
+	status = acpi_hw_sleep_dispatch(sleep_state, 0, ACPI_WAKE_FUNCTION_ID);
 	return_ACPI_STATUS(status);
 }
 
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 4fda549..8f1fb45 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -250,7 +250,8 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 	switch (acpi_state) {
 	case ACPI_STATE_S1:
 		barrier();
-		status = acpi_enter_sleep_state(acpi_state);
+		status = acpi_enter_sleep_state(acpi_state,
+				ACPI_NO_OPTIONAL_METHODS);
 		break;
 
 	case ACPI_STATE_S3:
@@ -265,7 +266,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 	acpi_write_bit_register(ACPI_BITREG_SCI_ENABLE, 1);
 
 	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(acpi_state);
+	acpi_leave_sleep_state_prep(acpi_state, ACPI_NO_OPTIONAL_METHODS);
 
 	/* ACPI 3.0 specs (P62) says that it's the responsibility
 	 * of the OSPM to clear the status bit [ implying that the
@@ -534,9 +535,9 @@ static int acpi_hibernation_enter(void)
 	ACPI_FLUSH_CPU_CACHE();
 
 	/* This shouldn't return.  If it returns, we have a problem */
-	status = acpi_enter_sleep_state(ACPI_STATE_S4);
+	status = acpi_enter_sleep_state(ACPI_STATE_S4, ACPI_NO_OPTIONAL_METHODS);
 	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
+	acpi_leave_sleep_state_prep(ACPI_STATE_S4, ACPI_NO_OPTIONAL_METHODS);
 
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
 }
@@ -549,7 +550,7 @@ static void acpi_hibernation_leave(void)
 	 */
 	acpi_enable();
 	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
+	acpi_leave_sleep_state_prep(ACPI_STATE_S4, ACPI_NO_OPTIONAL_METHODS);
 	/* Check the hardware signature */
 	if (facs && s4_hardware_signature != facs->hardware_signature) {
 		printk(KERN_EMERG "ACPI: Hardware changed while hibernated, "
@@ -773,7 +774,7 @@ static void acpi_power_off(void)
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
 	printk(KERN_DEBUG "%s called\n", __func__);
 	local_irq_disable();
-	acpi_enter_sleep_state(ACPI_STATE_S5);
+	acpi_enter_sleep_state(ACPI_STATE_S5, ACPI_NO_OPTIONAL_METHODS);
 }
 
 /*
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index fb8a238..488c986 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -486,11 +486,11 @@ acpi_get_sleep_type_data(u8 sleep_state, u8 * slp_typ_a, u8 * slp_typ_b);
 
 acpi_status acpi_enter_sleep_state_prep(u8 sleep_state);
 
-acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state);
+acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state, u8 flags);
 
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status asmlinkage acpi_enter_sleep_state_s4bios(void))
 
-acpi_status acpi_leave_sleep_state_prep(u8 sleep_state);
+acpi_status acpi_leave_sleep_state_prep(u8 sleep_state, u8 flags);
 
 acpi_status acpi_leave_sleep_state(u8 sleep_state);
 
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 3496158..eba6604 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -518,6 +518,13 @@ typedef u64 acpi_integer;
 #define ACPI_SLEEP_TYPE_INVALID         0xFF
 
 /*
+ * Sleep/Wake flags
+ */
+#define ACPI_NO_OPTIONAL_METHODS        0x00	/* Do not execute any optional methods */
+#define ACPI_EXECUTE_GTS                0x01	/* For enter sleep interface */
+#define ACPI_EXECUTE_BFS                0x02	/* For leave sleep prep interface */
+
+/*
  * Standard notify values
  */
 #define ACPI_NOTIFY_BUS_CHECK           (u8) 0x00
@@ -790,7 +797,7 @@ typedef u8 acpi_adr_space_type;
 
 /* Sleep function dispatch */
 
-typedef acpi_status(*ACPI_SLEEP_FUNCTION) (u8 sleep_state);
+typedef acpi_status(*ACPI_SLEEP_FUNCTION) (u8 sleep_state, u8 flags);
 
 struct acpi_sleep_functions {
 	ACPI_SLEEP_FUNCTION legacy_function;
-- 
1.7.10.rc2.19.gfae9d

