Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab0JDSYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:24:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773Ab0JDSXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:23:02 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/5] ACPI: Allow handlers to be installed at the same time as methods
Date: Mon,  4 Oct 2010 14:22:25 -0400
Message-Id: <1286216549-5438-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1286216549-5438-1-git-send-email-mjg@redhat.com>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are circumstances under which it may be desirable for GPE handlers
to be installable without displacing the existing GPE method. Add support
for this via a boolean argument to acpi_install_gpe_handler, and fix up the
existing users to ensure that their behaviour doesn't change.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/acpica/aclocal.h    |    7 ++--
 drivers/acpi/acpica/evgpe.c      |   75 ++++++++++++++++++--------------------
 drivers/acpi/acpica/evgpeinit.c  |   11 +-----
 drivers/acpi/acpica/evgpeutil.c  |    5 +--
 drivers/acpi/acpica/evxface.c    |   23 ++++++------
 drivers/acpi/ec.c                |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c |    2 +-
 include/acpi/acpixf.h            |    3 +-
 8 files changed, 56 insertions(+), 72 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index df85b53..66e3dff 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -406,16 +406,15 @@ struct acpi_predefined_data {
  *
  ****************************************************************************/
 
-/* Dispatch info for each GPE -- either a method or handler, cannot be both */
+/* Dispatch info for each GPE */
 
 struct acpi_handler_info {
 	acpi_event_handler address;	/* Address of handler, if any */
 	void *context;		/* Context to be passed to handler */
-	struct acpi_namespace_node *method_node;	/* Method node for this GPE level (saved) */
 	u8 orig_flags;		/* Original misc info about this GPE */
 };
 
-union acpi_gpe_dispatch_info {
+struct acpi_gpe_dispatch_info {
 	struct acpi_namespace_node *method_node;	/* Method node for this GPE level */
 	struct acpi_handler_info *handler;
 };
@@ -425,7 +424,7 @@ union acpi_gpe_dispatch_info {
  * NOTE: Important to keep this struct as small as possible.
  */
 struct acpi_gpe_event_info {
-	union acpi_gpe_dispatch_info dispatch;	/* Either Method or Handler */
+	struct acpi_gpe_dispatch_info dispatch;
 	struct acpi_gpe_register_info *register_info;	/* Backpointer to register info */
 	u8 flags;		/* Misc info about this GPE */
 	u8 gpe_number;		/* This GPE */
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index f226eac..c4b1c4c 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -474,9 +474,7 @@ static void ACPI_SYSTEM_XFACE acpi_ev_asynch_execute_gpe_method(void *context)
 	 * Must check for control method type dispatch one more time to avoid a
 	 * race with ev_gpe_install_handler
 	 */
-	if ((local_gpe_event_info.flags & ACPI_GPE_DISPATCH_MASK) ==
-	    ACPI_GPE_DISPATCH_METHOD) {
-
+	if (local_gpe_event_info.flags & ACPI_GPE_DISPATCH_METHOD) {
 		/* Allocate the evaluation information block */
 
 		info = ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_evaluate_info));
@@ -575,41 +573,15 @@ acpi_ev_gpe_dispatch(struct acpi_gpe_event_info *gpe_event_info, u32 gpe_number)
 	}
 
 	/*
-	 * Dispatch the GPE to either an installed handler, or the control method
-	 * associated with this GPE (_Lxx or _Exx). If a handler exists, we invoke
-	 * it and do not attempt to run the method. If there is neither a handler
-	 * nor a method, we disable this GPE to prevent further such pointless
-	 * events from firing.
+	 * Dispatch the GPE to either any installed handler or control
+	 * method associated with this GPE (_Lxx or _Exx). We invoke
+	 * the method first in case it has side effects that would be
+	 * interfered with if the handler has already altered hardware
+	 * state. If there is neither a handler nor a method, we
+	 * disable this GPE to prevent further such pointless events
+	 * from firing.
 	 */
-	switch (gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) {
-	case ACPI_GPE_DISPATCH_HANDLER:
-
-		/*
-		 * Invoke the installed handler (at interrupt level)
-		 * Ignore return status for now.
-		 * TBD: leave GPE disabled on error?
-		 */
-		(void)gpe_event_info->dispatch.handler->address(gpe_event_info->
-								dispatch.
-								handler->
-								context);
-
-		/* It is now safe to clear level-triggered events. */
-
-		if ((gpe_event_info->flags & ACPI_GPE_XRUPT_TYPE_MASK) ==
-		    ACPI_GPE_LEVEL_TRIGGERED) {
-			status = acpi_hw_clear_gpe(gpe_event_info);
-			if (ACPI_FAILURE(status)) {
-				ACPI_EXCEPTION((AE_INFO, status,
-					"Unable to clear GPE[0x%2X]",
-						gpe_number));
-				return_UINT32(ACPI_INTERRUPT_NOT_HANDLED);
-			}
-		}
-		break;
-
-	case ACPI_GPE_DISPATCH_METHOD:
-
+	if (gpe_event_info->flags & ACPI_GPE_DISPATCH_METHOD) {
 		/*
 		 * Disable the GPE, so it doesn't keep firing before the method has a
 		 * chance to run (it runs asynchronously with interrupts enabled).
@@ -634,10 +606,34 @@ acpi_ev_gpe_dispatch(struct acpi_gpe_event_info *gpe_event_info, u32 gpe_number)
 					"Unable to queue handler for GPE[0x%2X] - event disabled",
 					gpe_number));
 		}
-		break;
+	}
 
-	default:
+	if (gpe_event_info->flags & ACPI_GPE_DISPATCH_HANDLER) {
+		/*
+		 * Invoke the installed handler (at interrupt level)
+		 * Ignore return status for now.
+		 * TBD: leave GPE disabled on error?
+		 */
+		(void)gpe_event_info->dispatch.handler->address(gpe_event_info->
+								dispatch.
+								handler->
+								context);
 
+		/* It is now safe to clear level-triggered events. */
+
+		if ((gpe_event_info->flags & ACPI_GPE_XRUPT_TYPE_MASK) ==
+		    ACPI_GPE_LEVEL_TRIGGERED) {
+			status = acpi_hw_clear_gpe(gpe_event_info);
+			if (ACPI_FAILURE(status)) {
+				ACPI_EXCEPTION((AE_INFO, status,
+					"Unable to clear GPE[0x%2X]",
+						gpe_number));
+				return_UINT32(ACPI_INTERRUPT_NOT_HANDLED);
+			}
+		}
+	}
+
+	if (!(gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK)) {
 		/*
 		 * No handler or method to run!
 		 * 03/2010: This case should no longer be possible. We will not allow
@@ -658,7 +654,6 @@ acpi_ev_gpe_dispatch(struct acpi_gpe_event_info *gpe_event_info, u32 gpe_number)
 					gpe_number));
 			return_UINT32(ACPI_INTERRUPT_NOT_HANDLED);
 		}
-		break;
 	}
 
 	return_UINT32(ACPI_INTERRUPT_HANDLED);
diff --git a/drivers/acpi/acpica/evgpeinit.c b/drivers/acpi/acpica/evgpeinit.c
index 3084c5d..4c3687e 100644
--- a/drivers/acpi/acpica/evgpeinit.c
+++ b/drivers/acpi/acpica/evgpeinit.c
@@ -392,16 +392,7 @@ acpi_ev_match_gpe_method(acpi_handle obj_handle,
 		return_ACPI_STATUS(AE_OK);
 	}
 
-	if ((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) ==
-	    ACPI_GPE_DISPATCH_HANDLER) {
-
-		/* If there is already a handler, ignore this GPE method */
-
-		return_ACPI_STATUS(AE_OK);
-	}
-
-	if ((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) ==
-	    ACPI_GPE_DISPATCH_METHOD) {
+	if (gpe_event_info->flags & ACPI_GPE_DISPATCH_METHOD) {
 		/*
 		 * If there is already a method, ignore this method. But check
 		 * for a type mismatch (if both the _Lxx AND _Exx exist)
diff --git a/drivers/acpi/acpica/evgpeutil.c b/drivers/acpi/acpica/evgpeutil.c
index 19a0e51..434ad1b 100644
--- a/drivers/acpi/acpica/evgpeutil.c
+++ b/drivers/acpi/acpica/evgpeutil.c
@@ -323,12 +323,11 @@ acpi_ev_delete_gpe_handlers(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
 								 ACPI_GPE_REGISTER_WIDTH)
 								+ j];
 
-			if ((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) ==
-			    ACPI_GPE_DISPATCH_HANDLER) {
+			if (gpe_event_info->flags & ACPI_GPE_DISPATCH_HANDLER) {
 				ACPI_FREE(gpe_event_info->dispatch.handler);
 				gpe_event_info->dispatch.handler = NULL;
 				gpe_event_info->flags &=
-				    ~ACPI_GPE_DISPATCH_MASK;
+				    ~ACPI_GPE_DISPATCH_HANDLER;
 			}
 		}
 	}
diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index 14e48ad..e618e43 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -662,6 +662,8 @@ ACPI_EXPORT_SYMBOL(acpi_remove_notify_handler)
  *                                edge- or level-triggered interrupt.
  *              Address         - Address of the handler
  *              Context         - Value passed to the handler on each GPE
+ *		keep_method	- Whether the existing method should be
+ *				  displaced or kept
  *
  * RETURN:      Status
  *
@@ -671,7 +673,8 @@ ACPI_EXPORT_SYMBOL(acpi_remove_notify_handler)
 acpi_status
 acpi_install_gpe_handler(acpi_handle gpe_device,
 			 u32 gpe_number,
-			 u32 type, acpi_event_handler address, void *context)
+			 u32 type, acpi_event_handler address, void *context,
+			 bool keep_method)
 {
 	struct acpi_gpe_event_info *gpe_event_info;
 	struct acpi_handler_info *handler;
@@ -711,8 +714,7 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 
 	/* Make sure that there isn't a handler there already */
 
-	if ((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) ==
-	    ACPI_GPE_DISPATCH_HANDLER) {
+	if (gpe_event_info->flags & ACPI_GPE_DISPATCH_HANDLER) {
 		status = AE_ALREADY_EXISTS;
 		goto free_and_exit;
 	}
@@ -721,7 +723,6 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 
 	handler->address = address;
 	handler->context = context;
-	handler->method_node = gpe_event_info->dispatch.method_node;
 	handler->orig_flags = gpe_event_info->flags &
 			(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
 
@@ -733,17 +734,17 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 	 */
 
 	if ((handler->orig_flags & ACPI_GPE_DISPATCH_METHOD)
-	    && !(gpe_event_info->flags & ACPI_GPE_CAN_WAKE))
+	    && !(gpe_event_info->flags & ACPI_GPE_CAN_WAKE) && !keep_method)
 		(void)acpi_raw_disable_gpe(gpe_event_info);
 
 	/* Install the handler */
 
 	gpe_event_info->dispatch.handler = handler;
 
-	/* Setup up dispatch flags to indicate handler (vs. method) */
+	if (!keep_method)
+		gpe_event_info->flags &=
+			~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
 
-	gpe_event_info->flags &=
-	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
 	gpe_event_info->flags |= (u8) (type | ACPI_GPE_DISPATCH_HANDLER);
 
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
@@ -812,8 +813,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 
 	/* Make sure that a handler is indeed installed */
 
-	if ((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) !=
-	    ACPI_GPE_DISPATCH_HANDLER) {
+	if (!(gpe_event_info->flags & ACPI_GPE_DISPATCH_HANDLER)) {
 		status = AE_NOT_EXIST;
 		goto unlock_and_exit;
 	}
@@ -829,9 +829,8 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 
 	handler = gpe_event_info->dispatch.handler;
 
-	/* Restore Method node (if any), set dispatch flags */
+	/* Set dispatch flags */
 
-	gpe_event_info->dispatch.method_node = handler->method_node;
 	gpe_event_info->flags &=
 		~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
 	gpe_event_info->flags |= handler->orig_flags;
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index f31291b..04df824 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -735,7 +735,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 		return 0;
 	status = acpi_install_gpe_handler(NULL, ec->gpe,
 				  ACPI_GPE_EDGE_TRIGGERED,
-				  &acpi_ec_gpe_handler, ec);
+				  &acpi_ec_gpe_handler, ec, false);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 7bd7c45..5fdaa0d 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1959,7 +1959,7 @@ static int acpi_gpe_irq_setup(struct smi_info *info)
 					  info->irq,
 					  ACPI_GPE_LEVEL_TRIGGERED,
 					  &ipmi_acpi_gpe,
-					  info);
+					  info, false);
 	if (status != AE_OK) {
 		dev_warn(info->dev, "%s unable to claim ACPI GPE %d,"
 			 " running polled\n", DEVICE_NAME, info->irq);
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index c0786d4..215fbd1 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -253,7 +253,8 @@ acpi_remove_address_space_handler(acpi_handle device,
 acpi_status
 acpi_install_gpe_handler(acpi_handle gpe_device,
 			 u32 gpe_number,
-			 u32 type, acpi_event_handler address, void *context);
+			 u32 type, acpi_event_handler address, void *context,
+			 bool keep_method);
 
 acpi_status
 acpi_remove_gpe_handler(acpi_handle gpe_device,
-- 
1.7.3.1

