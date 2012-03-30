Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926Ab2C3NTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:19:12 -0400
Received: from vms173021pub.verizon.net ([206.46.173.21]:33467 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab2C3NS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:18:28 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 26/76] ACPICA: Support for custom ACPICA build for ACPI 5
 reduced hardware
Date: Fri, 30 Mar 2012 06:13:29 -0400
Message-id: <33620c5419e8a11814dd11e02a80e6ef77a43407.1333101989.git.len.brown@intel.com>
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

Add ACPI_REDUCED_HARDWARE flag that removes all hardware-related
code (about 10% code, 5% static data).

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/accommon.h                   |    1 -
 drivers/acpi/acpica/acdebug.h                    |    8 +-
 drivers/acpi/acpica/acevents.h                   |   21 +-
 drivers/acpi/acpica/acglobal.h                   |   11 +-
 drivers/acpi/acpica/evevent.c                    |    4 +-
 drivers/acpi/acpica/evglock.c                    |    4 +-
 drivers/acpi/acpica/evgpe.c                      |    4 +-
 drivers/acpi/acpica/evgpeblk.c                   |    4 +-
 drivers/acpi/acpica/evgpeinit.c                  |    4 +-
 drivers/acpi/acpica/evgpeutil.c                  |    3 +
 drivers/acpi/acpica/evmisc.c                     |    3 +
 drivers/acpi/acpica/evsci.c                      |    4 +-
 drivers/acpi/acpica/evxface.c                    |  436 +++++++++++-----------
 drivers/acpi/acpica/evxfevnt.c                   |    2 +
 drivers/acpi/acpica/evxfgpe.c                    |    2 +
 drivers/acpi/acpica/hwacpi.c                     |    3 +
 drivers/acpi/acpica/hwgpe.c                      |    4 +-
 drivers/acpi/acpica/hwregs.c                     |    8 +-
 drivers/acpi/acpica/hwsleep.c                    |    2 +
 drivers/acpi/acpica/hwtimer.c                    |    2 +
 drivers/acpi/acpica/hwxface.c                    |    3 +-
 drivers/acpi/acpica/hwxfsleep.c                  |   22 +-
 drivers/acpi/acpica/tbutils.c                    |    2 +
 drivers/acpi/acpica/utglobal.c                   |    9 +-
 drivers/acpi/acpica/utinit.c                     |   37 +-
 drivers/acpi/acpica/utxface.c                    |    6 +-
 {drivers/acpi/acpica => include/acpi}/acconfig.h |   17 +
 include/acpi/acexcep.h                           |    6 +-
 include/acpi/acpixf.h                            |  219 +++++++----
 29 files changed, 531 insertions(+), 320 deletions(-)
 rename {drivers/acpi/acpica => include/acpi}/acconfig.h (92%)

diff --git a/drivers/acpi/acpica/accommon.h b/drivers/acpi/acpica/accommon.h
index a44bd42..8a7d51b 100644
--- a/drivers/acpi/acpica/accommon.h
+++ b/drivers/acpi/acpica/accommon.h
@@ -51,7 +51,6 @@
  *
  * Note: The order of these include files is important.
  */
-#include "acconfig.h"		/* Global configuration constants */
 #include "acmacros.h"		/* C macros */
 #include "aclocal.h"		/* Internal data types */
 #include "acobject.h"		/* ACPI internal object */
diff --git a/drivers/acpi/acpica/acdebug.h b/drivers/acpi/acpica/acdebug.h
index deaa819..5e8abb0 100644
--- a/drivers/acpi/acpica/acdebug.h
+++ b/drivers/acpi/acpica/acdebug.h
@@ -111,7 +111,7 @@ acpi_status acpi_db_find_name_in_namespace(char *name_arg);
 
 void acpi_db_set_scope(char *name);
 
-acpi_status acpi_db_sleep(char *object_arg);
+ACPI_HW_DEPENDENT_RETURN_OK(acpi_status acpi_db_sleep(char *object_arg))
 
 void acpi_db_find_references(char *object_arg);
 
@@ -119,11 +119,13 @@ void acpi_db_display_locks(void);
 
 void acpi_db_display_resources(char *object_arg);
 
-void acpi_db_display_gpes(void);
+ACPI_HW_DEPENDENT_RETURN_VOID(void acpi_db_display_gpes(void))
 
 void acpi_db_check_integrity(void);
 
-void acpi_db_generate_gpe(char *gpe_arg, char *block_arg);
+ACPI_HW_DEPENDENT_RETURN_VOID(void
+			      acpi_db_generate_gpe(char *gpe_arg,
+						   char *block_arg))
 
 void acpi_db_check_predefined_names(void);
 
diff --git a/drivers/acpi/acpica/acevents.h b/drivers/acpi/acpica/acevents.h
index c53caa5..d700f63 100644
--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -69,11 +69,10 @@ acpi_ev_queue_notify_request(struct acpi_namespace_node *node,
  */
 acpi_status acpi_ev_init_global_lock_handler(void);
 
-acpi_status acpi_ev_acquire_global_lock(u16 timeout);
-
-acpi_status acpi_ev_release_global_lock(void);
-
-acpi_status acpi_ev_remove_global_lock_handler(void);
+ACPI_HW_DEPENDENT_RETURN_OK(acpi_status
+			    acpi_ev_acquire_global_lock(u16 timeout))
+ ACPI_HW_DEPENDENT_RETURN_OK(acpi_status acpi_ev_release_global_lock(void))
+ acpi_status acpi_ev_remove_global_lock_handler(void);
 
 /*
  * evgpe - Low-level GPE support
@@ -114,7 +113,9 @@ acpi_ev_initialize_gpe_block(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
 			     struct acpi_gpe_block_info *gpe_block,
 			     void *context);
 
-acpi_status acpi_ev_delete_gpe_block(struct acpi_gpe_block_info *gpe_block);
+ACPI_HW_DEPENDENT_RETURN_OK(acpi_status
+			    acpi_ev_delete_gpe_block(struct acpi_gpe_block_info
+						     *gpe_block))
 
 u32
 acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
@@ -126,9 +127,10 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
  */
 acpi_status acpi_ev_gpe_initialize(void);
 
-void acpi_ev_update_gpes(acpi_owner_id table_owner_id);
+ACPI_HW_DEPENDENT_RETURN_VOID(void
+			      acpi_ev_update_gpes(acpi_owner_id table_owner_id))
 
-acpi_status
+ acpi_status
 acpi_ev_match_gpe_method(acpi_handle obj_handle,
 			 u32 level, void *context, void **return_value);
 
@@ -237,6 +239,5 @@ acpi_status acpi_ev_remove_sci_handler(void);
 
 u32 acpi_ev_initialize_sCI(u32 program_sCI);
 
-void acpi_ev_terminate(void);
-
+ACPI_HW_DEPENDENT_RETURN_VOID(void acpi_ev_terminate(void))
 #endif				/* __ACEVENTS_H__  */
diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index 2853f76..4f7d3f5 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -147,7 +147,7 @@ u8 acpi_gbl_system_awake_and_running;
  */
 u8 acpi_gbl_reduced_hardware;
 
-#endif
+#endif				/* DEFINE_ACPI_GLOBALS */
 
 /* Do not disassemble buffers to resource descriptors */
 
@@ -184,8 +184,12 @@ ACPI_EXTERN u32 acpi_gbl_trace_dbg_layer;
  * found in the RSDT/XSDT.
  */
 ACPI_EXTERN struct acpi_table_list acpi_gbl_root_table_list;
+
+#if (!ACPI_REDUCED_HARDWARE)
 ACPI_EXTERN struct acpi_table_facs *acpi_gbl_FACS;
 
+#endif				/* !ACPI_REDUCED_HARDWARE */
+
 /* These addresses are calculated from the FADT Event Block addresses */
 
 ACPI_EXTERN struct acpi_generic_address acpi_gbl_xpm1a_status;
@@ -397,10 +401,15 @@ ACPI_EXTERN struct acpi_fixed_event_handler
 ACPI_EXTERN struct acpi_gpe_xrupt_info *acpi_gbl_gpe_xrupt_list_head;
 ACPI_EXTERN struct acpi_gpe_block_info
 *acpi_gbl_gpe_fadt_blocks[ACPI_MAX_GPE_BLOCKS];
+
+#if (!ACPI_REDUCED_HARDWARE)
+
 ACPI_EXTERN u8 acpi_gbl_all_gpes_initialized;
 ACPI_EXTERN ACPI_GBL_EVENT_HANDLER acpi_gbl_global_event_handler;
 ACPI_EXTERN void *acpi_gbl_global_event_handler_context;
 
+#endif				/* !ACPI_REDUCED_HARDWARE */
+
 /*****************************************************************************
  *
  * Debugger globals
diff --git a/drivers/acpi/acpica/evevent.c b/drivers/acpi/acpica/evevent.c
index 6729ebe..07e4dc4 100644
--- a/drivers/acpi/acpica/evevent.c
+++ b/drivers/acpi/acpica/evevent.c
@@ -47,7 +47,7 @@
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evevent")
-
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /* Local prototypes */
 static acpi_status acpi_ev_fixed_event_initialize(void);
 
@@ -291,3 +291,5 @@ static u32 acpi_ev_fixed_event_dispatch(u32 event)
 	return ((acpi_gbl_fixed_event_handlers[event].
 		 handler) (acpi_gbl_fixed_event_handlers[event].context));
 }
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/evglock.c b/drivers/acpi/acpica/evglock.c
index 5e5683c..cfeab38 100644
--- a/drivers/acpi/acpica/evglock.c
+++ b/drivers/acpi/acpica/evglock.c
@@ -48,7 +48,7 @@
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evglock")
-
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /* Local prototypes */
 static u32 acpi_ev_global_lock_handler(void *context);
 
@@ -339,3 +339,5 @@ acpi_status acpi_ev_release_global_lock(void)
 	acpi_os_release_mutex(acpi_gbl_global_lock_mutex->mutex.os_mutex);
 	return_ACPI_STATUS(status);
 }
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 9e88cb6..8ba0e5f 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -48,7 +48,7 @@
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evgpe")
-
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /* Local prototypes */
 static void ACPI_SYSTEM_XFACE acpi_ev_asynch_execute_gpe_method(void *context);
 
@@ -766,3 +766,5 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 
 	return_UINT32(ACPI_INTERRUPT_HANDLED);
 }
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/evgpeblk.c b/drivers/acpi/acpica/evgpeblk.c
index be75339..23a3ca8 100644
--- a/drivers/acpi/acpica/evgpeblk.c
+++ b/drivers/acpi/acpica/evgpeblk.c
@@ -48,7 +48,7 @@
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evgpeblk")
-
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /* Local prototypes */
 static acpi_status
 acpi_ev_install_gpe_block(struct acpi_gpe_block_info *gpe_block,
@@ -504,3 +504,5 @@ acpi_ev_initialize_gpe_block(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
 
 	return_ACPI_STATUS(AE_OK);
 }
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/evgpeinit.c b/drivers/acpi/acpica/evgpeinit.c
index adf7494..da0add8 100644
--- a/drivers/acpi/acpica/evgpeinit.c
+++ b/drivers/acpi/acpica/evgpeinit.c
@@ -48,7 +48,7 @@
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evgpeinit")
-
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /*
  * Note: History of _PRW support in ACPICA
  *
@@ -440,3 +440,5 @@ acpi_ev_match_gpe_method(acpi_handle obj_handle,
 			  name, gpe_number));
 	return_ACPI_STATUS(AE_OK);
 }
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/evgpeutil.c b/drivers/acpi/acpica/evgpeutil.c
index 2507393..3c43796 100644
--- a/drivers/acpi/acpica/evgpeutil.c
+++ b/drivers/acpi/acpica/evgpeutil.c
@@ -48,6 +48,7 @@
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evgpeutil")
 
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ev_walk_gpe_list
@@ -374,3 +375,5 @@ acpi_ev_delete_gpe_handlers(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
 
 	return_ACPI_STATUS(AE_OK);
 }
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/evmisc.c b/drivers/acpi/acpica/evmisc.c
index 84966f4..0912f62 100644
--- a/drivers/acpi/acpica/evmisc.c
+++ b/drivers/acpi/acpica/evmisc.c
@@ -270,6 +270,7 @@ static void ACPI_SYSTEM_XFACE acpi_ev_notify_dispatch(void *context)
 	acpi_ut_delete_generic_state(notify_info);
 }
 
+#if (!ACPI_REDUCED_HARDWARE)
 /******************************************************************************
  *
  * FUNCTION:    acpi_ev_terminate
@@ -338,3 +339,5 @@ void acpi_ev_terminate(void)
 	}
 	return_VOID;
 }
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/evsci.c b/drivers/acpi/acpica/evsci.c
index 26065c6..6a57aa2 100644
--- a/drivers/acpi/acpica/evsci.c
+++ b/drivers/acpi/acpica/evsci.c
@@ -48,7 +48,7 @@
 
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evsci")
-
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /* Local prototypes */
 static u32 ACPI_SYSTEM_XFACE acpi_ev_sci_xrupt_handler(void *context);
 
@@ -181,3 +181,5 @@ acpi_status acpi_ev_remove_sci_handler(void)
 
 	return_ACPI_STATUS(status);
 }
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index 61944e8..44bef57 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -51,222 +51,6 @@
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evxface")
 
-/*******************************************************************************
- *
- * FUNCTION:    acpi_install_exception_handler
- *
- * PARAMETERS:  Handler         - Pointer to the handler function for the
- *                                event
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Saves the pointer to the handler function
- *
- ******************************************************************************/
-#ifdef ACPI_FUTURE_USAGE
-acpi_status acpi_install_exception_handler(acpi_exception_handler handler)
-{
-	acpi_status status;
-
-	ACPI_FUNCTION_TRACE(acpi_install_exception_handler);
-
-	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/* Don't allow two handlers. */
-
-	if (acpi_gbl_exception_handler) {
-		status = AE_ALREADY_EXISTS;
-		goto cleanup;
-	}
-
-	/* Install the handler */
-
-	acpi_gbl_exception_handler = handler;
-
-      cleanup:
-	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
-	return_ACPI_STATUS(status);
-}
-
-ACPI_EXPORT_SYMBOL(acpi_install_exception_handler)
-#endif				/*  ACPI_FUTURE_USAGE  */
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_install_global_event_handler
- *
- * PARAMETERS:  Handler         - Pointer to the global event handler function
- *              Context         - Value passed to the handler on each event
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Saves the pointer to the handler function. The global handler
- *              is invoked upon each incoming GPE and Fixed Event. It is
- *              invoked at interrupt level at the time of the event dispatch.
- *              Can be used to update event counters, etc.
- *
- ******************************************************************************/
-acpi_status
-acpi_install_global_event_handler(ACPI_GBL_EVENT_HANDLER handler, void *context)
-{
-	acpi_status status;
-
-	ACPI_FUNCTION_TRACE(acpi_install_global_event_handler);
-
-	/* Parameter validation */
-
-	if (!handler) {
-		return_ACPI_STATUS(AE_BAD_PARAMETER);
-	}
-
-	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/* Don't allow two handlers. */
-
-	if (acpi_gbl_global_event_handler) {
-		status = AE_ALREADY_EXISTS;
-		goto cleanup;
-	}
-
-	acpi_gbl_global_event_handler = handler;
-	acpi_gbl_global_event_handler_context = context;
-
-      cleanup:
-	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
-	return_ACPI_STATUS(status);
-}
-
-ACPI_EXPORT_SYMBOL(acpi_install_global_event_handler)
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_install_fixed_event_handler
- *
- * PARAMETERS:  Event           - Event type to enable.
- *              Handler         - Pointer to the handler function for the
- *                                event
- *              Context         - Value passed to the handler on each GPE
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Saves the pointer to the handler function and then enables the
- *              event.
- *
- ******************************************************************************/
-acpi_status
-acpi_install_fixed_event_handler(u32 event,
-				 acpi_event_handler handler, void *context)
-{
-	acpi_status status;
-
-	ACPI_FUNCTION_TRACE(acpi_install_fixed_event_handler);
-
-	/* Parameter validation */
-
-	if (event > ACPI_EVENT_MAX) {
-		return_ACPI_STATUS(AE_BAD_PARAMETER);
-	}
-
-	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/* Don't allow two handlers. */
-
-	if (NULL != acpi_gbl_fixed_event_handlers[event].handler) {
-		status = AE_ALREADY_EXISTS;
-		goto cleanup;
-	}
-
-	/* Install the handler before enabling the event */
-
-	acpi_gbl_fixed_event_handlers[event].handler = handler;
-	acpi_gbl_fixed_event_handlers[event].context = context;
-
-	status = acpi_clear_event(event);
-	if (ACPI_SUCCESS(status))
-		status = acpi_enable_event(event, 0);
-	if (ACPI_FAILURE(status)) {
-		ACPI_WARNING((AE_INFO, "Could not enable fixed event 0x%X",
-			      event));
-
-		/* Remove the handler */
-
-		acpi_gbl_fixed_event_handlers[event].handler = NULL;
-		acpi_gbl_fixed_event_handlers[event].context = NULL;
-	} else {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Enabled fixed event %X, Handler=%p\n", event,
-				  handler));
-	}
-
-      cleanup:
-	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
-	return_ACPI_STATUS(status);
-}
-
-ACPI_EXPORT_SYMBOL(acpi_install_fixed_event_handler)
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_remove_fixed_event_handler
- *
- * PARAMETERS:  Event           - Event type to disable.
- *              Handler         - Address of the handler
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Disables the event and unregisters the event handler.
- *
- ******************************************************************************/
-acpi_status
-acpi_remove_fixed_event_handler(u32 event, acpi_event_handler handler)
-{
-	acpi_status status = AE_OK;
-
-	ACPI_FUNCTION_TRACE(acpi_remove_fixed_event_handler);
-
-	/* Parameter validation */
-
-	if (event > ACPI_EVENT_MAX) {
-		return_ACPI_STATUS(AE_BAD_PARAMETER);
-	}
-
-	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/* Disable the event before removing the handler */
-
-	status = acpi_disable_event(event, 0);
-
-	/* Always Remove the handler */
-
-	acpi_gbl_fixed_event_handlers[event].handler = NULL;
-	acpi_gbl_fixed_event_handlers[event].context = NULL;
-
-	if (ACPI_FAILURE(status)) {
-		ACPI_WARNING((AE_INFO,
-			      "Could not write to fixed event enable register 0x%X",
-			      event));
-	} else {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Disabled fixed event %X\n",
-				  event));
-	}
-
-	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
-	return_ACPI_STATUS(status);
-}
-
-ACPI_EXPORT_SYMBOL(acpi_remove_fixed_event_handler)
 
 /*******************************************************************************
  *
@@ -334,6 +118,7 @@ acpi_add_handler_object(struct acpi_object_notify_handler *parent_obj,
 	return AE_OK;
 }
 
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_install_notify_handler
@@ -705,6 +490,224 @@ ACPI_EXPORT_SYMBOL(acpi_remove_notify_handler)
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_install_exception_handler
+ *
+ * PARAMETERS:  Handler         - Pointer to the handler function for the
+ *                                event
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Saves the pointer to the handler function
+ *
+ ******************************************************************************/
+#ifdef ACPI_FUTURE_USAGE
+acpi_status acpi_install_exception_handler(acpi_exception_handler handler)
+{
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_install_exception_handler);
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Don't allow two handlers. */
+
+	if (acpi_gbl_exception_handler) {
+		status = AE_ALREADY_EXISTS;
+		goto cleanup;
+	}
+
+	/* Install the handler */
+
+	acpi_gbl_exception_handler = handler;
+
+      cleanup:
+	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_install_exception_handler)
+#endif				/*  ACPI_FUTURE_USAGE  */
+
+#if (!ACPI_REDUCED_HARDWARE)
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_install_global_event_handler
+ *
+ * PARAMETERS:  Handler         - Pointer to the global event handler function
+ *              Context         - Value passed to the handler on each event
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Saves the pointer to the handler function. The global handler
+ *              is invoked upon each incoming GPE and Fixed Event. It is
+ *              invoked at interrupt level at the time of the event dispatch.
+ *              Can be used to update event counters, etc.
+ *
+ ******************************************************************************/
+acpi_status
+acpi_install_global_event_handler(ACPI_GBL_EVENT_HANDLER handler, void *context)
+{
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_install_global_event_handler);
+
+	/* Parameter validation */
+
+	if (!handler) {
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+	}
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Don't allow two handlers. */
+
+	if (acpi_gbl_global_event_handler) {
+		status = AE_ALREADY_EXISTS;
+		goto cleanup;
+	}
+
+	acpi_gbl_global_event_handler = handler;
+	acpi_gbl_global_event_handler_context = context;
+
+      cleanup:
+	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_install_global_event_handler)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_install_fixed_event_handler
+ *
+ * PARAMETERS:  Event           - Event type to enable.
+ *              Handler         - Pointer to the handler function for the
+ *                                event
+ *              Context         - Value passed to the handler on each GPE
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Saves the pointer to the handler function and then enables the
+ *              event.
+ *
+ ******************************************************************************/
+acpi_status
+acpi_install_fixed_event_handler(u32 event,
+				 acpi_event_handler handler, void *context)
+{
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_install_fixed_event_handler);
+
+	/* Parameter validation */
+
+	if (event > ACPI_EVENT_MAX) {
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+	}
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Don't allow two handlers. */
+
+	if (NULL != acpi_gbl_fixed_event_handlers[event].handler) {
+		status = AE_ALREADY_EXISTS;
+		goto cleanup;
+	}
+
+	/* Install the handler before enabling the event */
+
+	acpi_gbl_fixed_event_handlers[event].handler = handler;
+	acpi_gbl_fixed_event_handlers[event].context = context;
+
+	status = acpi_clear_event(event);
+	if (ACPI_SUCCESS(status))
+		status = acpi_enable_event(event, 0);
+	if (ACPI_FAILURE(status)) {
+		ACPI_WARNING((AE_INFO, "Could not enable fixed event 0x%X",
+			      event));
+
+		/* Remove the handler */
+
+		acpi_gbl_fixed_event_handlers[event].handler = NULL;
+		acpi_gbl_fixed_event_handlers[event].context = NULL;
+	} else {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "Enabled fixed event %X, Handler=%p\n", event,
+				  handler));
+	}
+
+      cleanup:
+	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_install_fixed_event_handler)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_remove_fixed_event_handler
+ *
+ * PARAMETERS:  Event           - Event type to disable.
+ *              Handler         - Address of the handler
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Disables the event and unregisters the event handler.
+ *
+ ******************************************************************************/
+acpi_status
+acpi_remove_fixed_event_handler(u32 event, acpi_event_handler handler)
+{
+	acpi_status status = AE_OK;
+
+	ACPI_FUNCTION_TRACE(acpi_remove_fixed_event_handler);
+
+	/* Parameter validation */
+
+	if (event > ACPI_EVENT_MAX) {
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+	}
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Disable the event before removing the handler */
+
+	status = acpi_disable_event(event, 0);
+
+	/* Always Remove the handler */
+
+	acpi_gbl_fixed_event_handlers[event].handler = NULL;
+	acpi_gbl_fixed_event_handlers[event].context = NULL;
+
+	if (ACPI_FAILURE(status)) {
+		ACPI_WARNING((AE_INFO,
+			      "Could not write to fixed event enable register 0x%X",
+			      event));
+	} else {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Disabled fixed event %X\n",
+				  event));
+	}
+
+	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_remove_fixed_event_handler)
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_install_gpe_handler
  *
  * PARAMETERS:  gpe_device      - Namespace node for the GPE (NULL for FADT
@@ -984,3 +987,4 @@ acpi_status acpi_release_global_lock(u32 handle)
 }
 
 ACPI_EXPORT_SYMBOL(acpi_release_global_lock)
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/evxfevnt.c b/drivers/acpi/acpica/evxfevnt.c
index 1768bbe..77cee5a 100644
--- a/drivers/acpi/acpica/evxfevnt.c
+++ b/drivers/acpi/acpica/evxfevnt.c
@@ -49,6 +49,7 @@
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evxfevnt")
 
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /*******************************************************************************
  *
  * FUNCTION:    acpi_enable
@@ -352,3 +353,4 @@ acpi_status acpi_get_event_status(u32 event, acpi_event_status * event_status)
 }
 
 ACPI_EXPORT_SYMBOL(acpi_get_event_status)
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index 33388fd..86f9b34 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -50,6 +50,7 @@
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evxfgpe")
 
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /******************************************************************************
  *
  * FUNCTION:    acpi_update_all_gpes
@@ -695,3 +696,4 @@ acpi_get_gpe_device(u32 index, acpi_handle *gpe_device)
 }
 
 ACPI_EXPORT_SYMBOL(acpi_get_gpe_device)
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/hwacpi.c b/drivers/acpi/acpica/hwacpi.c
index d21ec5f..d0b9ed5 100644
--- a/drivers/acpi/acpica/hwacpi.c
+++ b/drivers/acpi/acpica/hwacpi.c
@@ -48,6 +48,7 @@
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwacpi")
 
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /******************************************************************************
  *
  * FUNCTION:    acpi_hw_set_mode
@@ -166,3 +167,5 @@ u32 acpi_hw_get_mode(void)
 		return_UINT32(ACPI_SYS_MODE_LEGACY);
 	}
 }
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/hwgpe.c b/drivers/acpi/acpica/hwgpe.c
index 1a6894a..25bd28c 100644
--- a/drivers/acpi/acpica/hwgpe.c
+++ b/drivers/acpi/acpica/hwgpe.c
@@ -48,7 +48,7 @@
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwgpe")
-
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /* Local prototypes */
 static acpi_status
 acpi_hw_enable_wakeup_gpe_block(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
@@ -479,3 +479,5 @@ acpi_status acpi_hw_enable_all_wakeup_gpes(void)
 	status = acpi_ev_walk_gpe_list(acpi_hw_enable_wakeup_gpe_block, NULL);
 	return_ACPI_STATUS(status);
 }
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index 4ea4eeb5..17a78e5 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -51,6 +51,7 @@
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwregs")
 
+#if (!ACPI_REDUCED_HARDWARE)
 /* Local Prototypes */
 static acpi_status
 acpi_hw_read_multiple(u32 *value,
@@ -62,6 +63,8 @@ acpi_hw_write_multiple(u32 value,
 		       struct acpi_generic_address *register_a,
 		       struct acpi_generic_address *register_b);
 
+#endif				/* !ACPI_REDUCED_HARDWARE */
+
 /******************************************************************************
  *
  * FUNCTION:    acpi_hw_validate_register
@@ -240,6 +243,7 @@ acpi_status acpi_hw_write(u32 value, struct acpi_generic_address *reg)
 	return (status);
 }
 
+#if (!ACPI_REDUCED_HARDWARE)
 /*******************************************************************************
  *
  * FUNCTION:    acpi_hw_clear_acpi_status
@@ -285,7 +289,7 @@ exit:
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_hw_get_register_bit_mask
+ * FUNCTION:    acpi_hw_get_bit_register_info
  *
  * PARAMETERS:  register_id         - Index of ACPI Register to access
  *
@@ -658,3 +662,5 @@ acpi_hw_write_multiple(u32 value,
 
 	return (status);
 }
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index 59a2a6b..fa34147 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -197,6 +197,7 @@ void acpi_hw_execute_SST(u32 indicator_id)
 	}
 }
 
+#if (!ACPI_REDUCED_HARDWARE)
 /*******************************************************************************
  *
  * FUNCTION:    acpi_hw_legacy_sleep
@@ -512,6 +513,7 @@ acpi_status acpi_hw_legacy_wake(u8 sleep_state)
 	return_ACPI_STATUS(status);
 }
 
+#endif				/* !ACPI_REDUCED_HARDWARE */
 
 /*******************************************************************************
  *
diff --git a/drivers/acpi/acpica/hwtimer.c b/drivers/acpi/acpica/hwtimer.c
index d4973d9..f1b2c3b 100644
--- a/drivers/acpi/acpica/hwtimer.c
+++ b/drivers/acpi/acpica/hwtimer.c
@@ -49,6 +49,7 @@
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwtimer")
 
+#if (!ACPI_REDUCED_HARDWARE)	/* Entire module */
 /******************************************************************************
  *
  * FUNCTION:    acpi_get_timer_resolution
@@ -187,3 +188,4 @@ acpi_get_timer_duration(u32 start_ticks, u32 end_ticks, u32 * time_elapsed)
 }
 
 ACPI_EXPORT_SYMBOL(acpi_get_timer_duration)
+#endif				/* !ACPI_REDUCED_HARDWARE */
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index 9d38eb6..bb8dba6 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -286,6 +286,7 @@ acpi_status acpi_write(u64 value, struct acpi_generic_address *reg)
 
 ACPI_EXPORT_SYMBOL(acpi_write)
 
+#if (!ACPI_REDUCED_HARDWARE)
 /*******************************************************************************
  *
  * FUNCTION:    acpi_read_bit_register
@@ -453,7 +454,7 @@ unlock_and_exit:
 }
 
 ACPI_EXPORT_SYMBOL(acpi_write_bit_register)
-
+#endif				/* !ACPI_REDUCED_HARDWARE */
 /*******************************************************************************
  *
  * FUNCTION:    acpi_get_sleep_type_data
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index 29c0fd3..d599961 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -48,6 +48,7 @@
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwxfsleep")
 
+#if (!ACPI_REDUCED_HARDWARE)
 /*******************************************************************************
  *
  * FUNCTION:    acpi_set_firmware_waking_vector
@@ -189,7 +190,7 @@ acpi_status asmlinkage acpi_enter_sleep_state_s4bios(void)
 }
 
 ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_s4bios)
-
+#endif				/* !ACPI_REDUCED_HARDWARE */
 /*******************************************************************************
  *
  * FUNCTION:    acpi_enter_sleep_state_prep
@@ -290,6 +291,7 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 			    acpi_gbl_sleep_type_a, acpi_gbl_sleep_type_b));
 		return_ACPI_STATUS(AE_AML_OPERAND_VALUE);
 	}
+#if (!ACPI_REDUCED_HARDWARE)
 
 	/* If Hardware Reduced flag is set, must use the extended sleep registers */
 
@@ -301,6 +303,11 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 		status = acpi_hw_legacy_sleep(sleep_state);
 	}
 
+#else
+	status = acpi_hw_extended_sleep(sleep_state);
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
+
 	return_ACPI_STATUS(status);
 }
 
@@ -326,6 +333,8 @@ acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
 	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
 
 
+#if (!ACPI_REDUCED_HARDWARE)
+
 	/* If Hardware Reduced flag is set, must use the extended sleep registers */
 
 	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
@@ -335,6 +344,10 @@ acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
 
 		status = acpi_hw_legacy_wake_prep(sleep_state);
 	}
+#else
+	status = acpi_hw_extended_wake_prep(sleep_state);
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
 
 
 	return_ACPI_STATUS(status);
@@ -361,6 +374,8 @@ acpi_status acpi_leave_sleep_state(u8 sleep_state)
 	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
 
 
+#if (!ACPI_REDUCED_HARDWARE)
+
 	/* If Hardware Reduced flag is set, must use the extended sleep registers */
 
 	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
@@ -371,6 +386,11 @@ acpi_status acpi_leave_sleep_state(u8 sleep_state)
 		status = acpi_hw_legacy_wake(sleep_state);
 	}
 
+#else
+	status = acpi_hw_extended_wake(sleep_state);
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
+
 	return_ACPI_STATUS(status);
 }
 
diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 09ca39e..1347c08 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -118,6 +118,7 @@ acpi_tb_check_xsdt(acpi_physical_address address)
 		return AE_OK;
 }
 
+#if (!ACPI_REDUCED_HARDWARE)
 /*******************************************************************************
  *
  * FUNCTION:    acpi_tb_initialize_facs
@@ -148,6 +149,7 @@ acpi_status acpi_tb_initialize_facs(void)
 								&acpi_gbl_FACS));
 	return status;
 }
+#endif				/* !ACPI_REDUCED_HARDWARE */
 
 /*******************************************************************************
  *
diff --git a/drivers/acpi/acpica/utglobal.c b/drivers/acpi/acpica/utglobal.c
index 4153584..90f53b4 100644
--- a/drivers/acpi/acpica/utglobal.c
+++ b/drivers/acpi/acpica/utglobal.c
@@ -140,6 +140,7 @@ const struct acpi_predefined_names acpi_gbl_pre_defined_names[] = {
 	{NULL, ACPI_TYPE_ANY, NULL}
 };
 
+#if (!ACPI_REDUCED_HARDWARE)
 /******************************************************************************
  *
  * Event and Hardware globals
@@ -236,6 +237,7 @@ struct acpi_fixed_event_info acpi_gbl_fixed_event_info[ACPI_NUM_FIXED_EVENTS] =
 					ACPI_BITMASK_RT_CLOCK_STATUS,
 					ACPI_BITMASK_RT_CLOCK_ENABLE},
 };
+#endif				/* !ACPI_REDUCED_HARDWARE */
 
 /*******************************************************************************
  *
@@ -286,6 +288,8 @@ acpi_status acpi_ut_init_globals(void)
 
 	acpi_gbl_owner_id_mask[ACPI_NUM_OWNERID_MASKS - 1] = 0x80000000;
 
+#if (!ACPI_REDUCED_HARDWARE)
+
 	/* GPE support */
 
 	acpi_gbl_gpe_xrupt_list_head = NULL;
@@ -294,6 +298,10 @@ acpi_status acpi_ut_init_globals(void)
 	acpi_current_gpe_count = 0;
 	acpi_gbl_all_gpes_initialized = FALSE;
 
+	acpi_gbl_global_event_handler = NULL;
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
+
 	/* Global handlers */
 
 	acpi_gbl_system_notify.handler = NULL;
@@ -302,7 +310,6 @@ acpi_status acpi_ut_init_globals(void)
 	acpi_gbl_init_handler = NULL;
 	acpi_gbl_table_handler = NULL;
 	acpi_gbl_interface_handler = NULL;
-	acpi_gbl_global_event_handler = NULL;
 
 	/* Global Lock support */
 
diff --git a/drivers/acpi/acpica/utinit.c b/drivers/acpi/acpica/utinit.c
index 8359c0c..246798e 100644
--- a/drivers/acpi/acpica/utinit.c
+++ b/drivers/acpi/acpica/utinit.c
@@ -53,27 +53,35 @@ ACPI_MODULE_NAME("utinit")
 /* Local prototypes */
 static void acpi_ut_terminate(void);
 
+#if (!ACPI_REDUCED_HARDWARE)
+
+static void acpi_ut_free_gpe_lists(void);
+
+#else
+
+#define acpi_ut_free_gpe_lists()
+#endif				/* !ACPI_REDUCED_HARDWARE */
+
+#if (!ACPI_REDUCED_HARDWARE)
 /******************************************************************************
  *
- * FUNCTION:    acpi_ut_terminate
+ * FUNCTION:    acpi_ut_free_gpe_lists
  *
  * PARAMETERS:  none
  *
  * RETURN:      none
  *
- * DESCRIPTION: Free global memory
+ * DESCRIPTION: Free global GPE lists
  *
  ******************************************************************************/
 
-static void acpi_ut_terminate(void)
+static void acpi_ut_free_gpe_lists(void)
 {
 	struct acpi_gpe_block_info *gpe_block;
 	struct acpi_gpe_block_info *next_gpe_block;
 	struct acpi_gpe_xrupt_info *gpe_xrupt_info;
 	struct acpi_gpe_xrupt_info *next_gpe_xrupt_info;
 
-	ACPI_FUNCTION_TRACE(ut_terminate);
-
 	/* Free global GPE blocks and related info structures */
 
 	gpe_xrupt_info = acpi_gbl_gpe_xrupt_list_head;
@@ -91,7 +99,26 @@ static void acpi_ut_terminate(void)
 		ACPI_FREE(gpe_xrupt_info);
 		gpe_xrupt_info = next_gpe_xrupt_info;
 	}
+}
+#endif				/* !ACPI_REDUCED_HARDWARE */
+
+/******************************************************************************
+ *
+ * FUNCTION:    acpi_ut_terminate
+ *
+ * PARAMETERS:  none
+ *
+ * RETURN:      none
+ *
+ * DESCRIPTION: Free global memory
+ *
+ ******************************************************************************/
+
+static void acpi_ut_terminate(void)
+{
+	ACPI_FUNCTION_TRACE(ut_terminate);
 
+	acpi_ut_free_gpe_lists();
 	acpi_ut_delete_address_lists();
 	return_VOID;
 }
diff --git a/drivers/acpi/acpica/utxface.c b/drivers/acpi/acpica/utxface.c
index 644e8c8..afa94f5 100644
--- a/drivers/acpi/acpica/utxface.c
+++ b/drivers/acpi/acpica/utxface.c
@@ -145,6 +145,8 @@ acpi_status acpi_enable_subsystem(u32 flags)
 
 	ACPI_FUNCTION_TRACE(acpi_enable_subsystem);
 
+#if (!ACPI_REDUCED_HARDWARE)
+
 	/* Enable ACPI mode */
 
 	if (!(flags & ACPI_NO_ACPI_ENABLE)) {
@@ -169,6 +171,7 @@ acpi_status acpi_enable_subsystem(u32 flags)
 		ACPI_WARNING((AE_INFO, "Could not map the FACS table"));
 		return_ACPI_STATUS(status);
 	}
+#endif				/* !ACPI_REDUCED_HARDWARE */
 
 	/*
 	 * Install the default op_region handlers. These are installed unless
@@ -184,7 +187,7 @@ acpi_status acpi_enable_subsystem(u32 flags)
 			return_ACPI_STATUS(status);
 		}
 	}
-
+#if (!ACPI_REDUCED_HARDWARE)
 	/*
 	 * Initialize ACPI Event handling (Fixed and General Purpose)
 	 *
@@ -220,6 +223,7 @@ acpi_status acpi_enable_subsystem(u32 flags)
 			return_ACPI_STATUS(status);
 		}
 	}
+#endif				/* !ACPI_REDUCED_HARDWARE */
 
 	return_ACPI_STATUS(status);
 }
diff --git a/drivers/acpi/acpica/acconfig.h b/include/acpi/acconfig.h
similarity index 92%
rename from drivers/acpi/acpica/acconfig.h
rename to include/acpi/acconfig.h
index 3748f1a..03f1485 100644
--- a/drivers/acpi/acpica/acconfig.h
+++ b/include/acpi/acconfig.h
@@ -85,6 +85,23 @@
  */
 #define ACPI_CHECKSUM_ABORT             FALSE
 
+/*
+ * Generate a version of ACPICA that only supports "reduced hardware"
+ * platforms (as defined in ACPI 5.0). Set to TRUE to generate a specialized
+ * version of ACPICA that ONLY supports the ACPI 5.0 "reduced hardware"
+ * model. In other words, no ACPI hardware is supported.
+ *
+ * If TRUE, this means no support for the following:
+ *      PM Event and Control registers
+ *      SCI interrupt (and handler)
+ *      Fixed Events
+ *      General Purpose Events (GPEs)
+ *      Global Lock
+ *      ACPI PM timer
+ *      FACS table (Waking vectors and Global Lock)
+ */
+#define ACPI_REDUCED_HARDWARE           FALSE
+
 /******************************************************************************
  *
  * Subsystem Constants
diff --git a/include/acpi/acexcep.h b/include/acpi/acexcep.h
index 5b6c391..47b3902 100644
--- a/include/acpi/acexcep.h
+++ b/include/acpi/acexcep.h
@@ -89,8 +89,9 @@
 #define AE_SAME_HANDLER                 (acpi_status) (0x0019 | AE_CODE_ENVIRONMENTAL)
 #define AE_NO_HANDLER                   (acpi_status) (0x001A | AE_CODE_ENVIRONMENTAL)
 #define AE_OWNER_ID_LIMIT               (acpi_status) (0x001B | AE_CODE_ENVIRONMENTAL)
+#define AE_NOT_CONFIGURED               (acpi_status) (0x001C | AE_CODE_ENVIRONMENTAL)
 
-#define AE_CODE_ENV_MAX                 0x001B
+#define AE_CODE_ENV_MAX                 0x001C
 
 /*
  * Programmer exceptions
@@ -213,7 +214,8 @@ char const *acpi_gbl_exception_names_env[] = {
 	"AE_ABORT_METHOD",
 	"AE_SAME_HANDLER",
 	"AE_NO_HANDLER",
-	"AE_OWNER_ID_LIMIT"
+	"AE_OWNER_ID_LIMIT",
+	"AE_NOT_CONFIGURED"
 };
 
 char const *acpi_gbl_exception_names_pgm[] = {
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 67cd51c..e8600dd 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -49,6 +49,7 @@
 
 #define ACPI_CA_VERSION                 0x20120111
 
+#include "acconfig.h"
 #include "actypes.h"
 #include "actbl.h"
 
@@ -71,6 +72,33 @@ extern u8 acpi_gbl_copy_dsdt_locally;
 extern u8 acpi_gbl_truncate_io_addresses;
 extern u8 acpi_gbl_disable_auto_repair;
 
+/*
+ * Hardware-reduced prototypes. All interfaces that use these macros will
+ * be configured out of the ACPICA build if the ACPI_REDUCED_HARDWARE flag
+ * is set to TRUE.
+ */
+#if (!ACPI_REDUCED_HARDWARE)
+#define ACPI_HW_DEPENDENT_RETURN_STATUS(prototype) \
+	prototype;
+
+#define ACPI_HW_DEPENDENT_RETURN_OK(prototype) \
+	prototype;
+
+#define ACPI_HW_DEPENDENT_RETURN_VOID(prototype) \
+	prototype;
+
+#else
+#define ACPI_HW_DEPENDENT_RETURN_STATUS(prototype) \
+	static ACPI_INLINE prototype {return(AE_NOT_CONFIGURED);}
+
+#define ACPI_HW_DEPENDENT_RETURN_OK(prototype) \
+	static ACPI_INLINE prototype {return(AE_OK);}
+
+#define ACPI_HW_DEPENDENT_RETURN_VOID(prototype) \
+	static ACPI_INLINE prototype {}
+
+#endif				/* !ACPI_REDUCED_HARDWARE */
+
 extern u32 acpi_current_gpe_count;
 extern struct acpi_table_fadt acpi_gbl_FADT;
 extern u8 acpi_gbl_system_awake_and_running;
@@ -96,9 +124,8 @@ acpi_status acpi_terminate(void);
 acpi_status acpi_subsystem_status(void);
 #endif
 
-acpi_status acpi_enable(void);
-
-acpi_status acpi_disable(void);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enable(void))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_disable(void))
 
 #ifdef ACPI_FUTURE_USAGE
 acpi_status acpi_get_system_info(struct acpi_buffer *ret_buffer);
@@ -235,17 +262,34 @@ acpi_status acpi_get_parent(acpi_handle object, acpi_handle * out_handle);
 acpi_status
 acpi_install_initialization_handler(acpi_init_handler handler, u32 function);
 
-acpi_status
-acpi_install_global_event_handler(ACPI_GBL_EVENT_HANDLER handler,
-				 void *context);
-
-acpi_status
-acpi_install_fixed_event_handler(u32 acpi_event,
-				 acpi_event_handler handler, void *context);
-
-acpi_status
-acpi_remove_fixed_event_handler(u32 acpi_event, acpi_event_handler handler);
-
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_install_global_event_handler
+				(ACPI_GBL_EVENT_HANDLER handler, void *context))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				 acpi_install_fixed_event_handler(u32
+								  acpi_event,
+								  acpi_event_handler
+								  handler,
+								  void
+								  *context))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				 acpi_remove_fixed_event_handler(u32 acpi_event,
+								 acpi_event_handler
+								 handler))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				 acpi_install_gpe_handler(acpi_handle
+							  gpe_device,
+							  u32 gpe_number,
+							  u32 type,
+							  acpi_gpe_handler
+							  address,
+							  void *context))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				 acpi_remove_gpe_handler(acpi_handle gpe_device,
+							 u32 gpe_number,
+							 acpi_gpe_handler
+							 address))
 acpi_status
 acpi_install_notify_handler(acpi_handle device,
 			    u32 handler_type,
@@ -266,15 +310,6 @@ acpi_remove_address_space_handler(acpi_handle device,
 				  acpi_adr_space_type space_id,
 				  acpi_adr_space_handler handler);
 
-acpi_status
-acpi_install_gpe_handler(acpi_handle gpe_device,
-			 u32 gpe_number,
-			 u32 type, acpi_gpe_handler address, void *context);
-
-acpi_status
-acpi_remove_gpe_handler(acpi_handle gpe_device,
-			u32 gpe_number, acpi_gpe_handler address);
-
 #ifdef ACPI_FUTURE_USAGE
 acpi_status acpi_install_exception_handler(acpi_exception_handler handler);
 #endif
@@ -284,9 +319,11 @@ acpi_status acpi_install_interface_handler(acpi_interface_handler handler);
 /*
  * Global Lock interfaces
  */
-acpi_status acpi_acquire_global_lock(u16 timeout, u32 * handle);
-
-acpi_status acpi_release_global_lock(u32 handle);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_acquire_global_lock(u16 timeout,
+							 u32 *handle))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_release_global_lock(u32 handle))
 
 /*
  * Interfaces to AML mutex objects
@@ -299,47 +336,75 @@ acpi_status acpi_release_mutex(acpi_handle handle, acpi_string pathname);
 /*
  * Fixed Event interfaces
  */
-acpi_status acpi_enable_event(u32 event, u32 flags);
-
-acpi_status acpi_disable_event(u32 event, u32 flags);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_enable_event(u32 event, u32 flags))
 
-acpi_status acpi_clear_event(u32 event);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_disable_event(u32 event, u32 flags))
 
-acpi_status acpi_get_event_status(u32 event, acpi_event_status * event_status);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_clear_event(u32 event))
 
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_get_event_status(u32 event,
+						      acpi_event_status
+						      *event_status))
 /*
  * General Purpose Event (GPE) Interfaces
  */
-acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number);
-
-acpi_status acpi_disable_gpe(acpi_handle gpe_device, u32 gpe_number);
-
-acpi_status acpi_clear_gpe(acpi_handle gpe_device, u32 gpe_number);
-
-acpi_status
-acpi_setup_gpe_for_wake(acpi_handle parent_device,
-			acpi_handle gpe_device, u32 gpe_number);
-
-acpi_status acpi_set_gpe_wake_mask(acpi_handle gpe_device, u32 gpe_number, u8 action);
-
-acpi_status
-acpi_get_gpe_status(acpi_handle gpe_device,
-		    u32 gpe_number, acpi_event_status *event_status);
-
-acpi_status acpi_disable_all_gpes(void);
-
-acpi_status acpi_enable_all_runtime_gpes(void);
-
-acpi_status acpi_get_gpe_device(u32 gpe_index, acpi_handle *gpe_device);
-
-acpi_status
-acpi_install_gpe_block(acpi_handle gpe_device,
-		       struct acpi_generic_address *gpe_block_address,
-		       u32 register_count, u32 interrupt_number);
-
-acpi_status acpi_remove_gpe_block(acpi_handle gpe_device);
-
-acpi_status acpi_update_all_gpes(void);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_update_all_gpes(void))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_enable_gpe(acpi_handle gpe_device,
+						u32 gpe_number))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_disable_gpe(acpi_handle gpe_device,
+						 u32 gpe_number))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_clear_gpe(acpi_handle gpe_device,
+					       u32 gpe_number))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_set_gpe(acpi_handle gpe_device,
+					     u32 gpe_number, u8 action))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_finish_gpe(acpi_handle gpe_device,
+						u32 gpe_number))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_setup_gpe_for_wake(acpi_handle
+							parent_device,
+							acpi_handle gpe_device,
+							u32 gpe_number))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				 acpi_set_gpe_wake_mask(acpi_handle gpe_device,
+							u32 gpe_number,
+							u8 action))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				 acpi_get_gpe_status(acpi_handle gpe_device,
+						     u32 gpe_number,
+						     acpi_event_status
+						     *event_status))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_disable_all_gpes(void))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enable_all_runtime_gpes(void))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_get_gpe_device(u32 gpe_index,
+						    acpi_handle * gpe_device))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_install_gpe_block(acpi_handle gpe_device,
+						       struct
+						       acpi_generic_address
+						       *gpe_block_address,
+						       u32 register_count,
+						       u32 interrupt_number))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				 acpi_remove_gpe_block(acpi_handle gpe_device))
 
 /*
  * Resource interfaces
@@ -391,20 +456,31 @@ acpi_buffer_to_resource(u8 *aml_buffer,
  */
 acpi_status acpi_reset(void);
 
-acpi_status acpi_read_bit_register(u32 register_id, u32 *return_value);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_read_bit_register(u32 register_id,
+						       u32 *return_value))
 
-acpi_status acpi_write_bit_register(u32 register_id, u32 value);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_write_bit_register(u32 register_id,
+							u32 value))
 
-acpi_status acpi_set_firmware_waking_vector(u32 physical_address);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_set_firmware_waking_vector(u32
+								physical_address))
 
 #if ACPI_MACHINE_WIDTH == 64
-acpi_status acpi_set_firmware_waking_vector64(u64 physical_address);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_set_firmware_waking_vector64(u64
+								  physical_address))
 #endif
 
 acpi_status acpi_read(u64 *value, struct acpi_generic_address *reg);
 
 acpi_status acpi_write(u64 value, struct acpi_generic_address *reg);
 
+/*
+ * Sleep/Wake interfaces
+ */
 acpi_status
 acpi_get_sleep_type_data(u8 sleep_state, u8 * slp_typ_a, u8 * slp_typ_b);
 
@@ -412,7 +488,7 @@ acpi_status acpi_enter_sleep_state_prep(u8 sleep_state);
 
 acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state);
 
-acpi_status asmlinkage acpi_enter_sleep_state_s4bios(void);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status asmlinkage acpi_enter_sleep_state_s4bios(void))
 
 acpi_status acpi_leave_sleep_state_prep(u8 sleep_state);
 
@@ -422,12 +498,15 @@ acpi_status acpi_leave_sleep_state(u8 sleep_state);
  * ACPI Timer interfaces
  */
 #ifdef ACPI_FUTURE_USAGE
-acpi_status acpi_get_timer_resolution(u32 *resolution);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_get_timer_resolution(u32 *resolution))
 
-acpi_status acpi_get_timer(u32 *ticks);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_get_timer(u32 *ticks))
 
-acpi_status
-acpi_get_timer_duration(u32 start_ticks, u32 end_ticks, u32 *time_elapsed);
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_get_timer_duration(u32 start_ticks,
+							u32 end_ticks,
+							u32 *time_elapsed))
 #endif				/* ACPI_FUTURE_USAGE */
 
 /*
-- 
1.7.10.rc2.19.gfae9d

