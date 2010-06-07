Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab0FGWXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 18:23:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35544 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab0FGWXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 18:23:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI / ACPICA: Fix problems related to GPE reference counting
Date: Tue, 8 Jun 2010 00:24:46 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Moore, Robert" <robert.moore@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006080024.46142.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few problems with the recently introduced GPE reference
counting mechanism.

First of all, we overlooked the fact that acpi_ev_update_gpes() could
have enabled GPEs before acpi_ev_initialize_gpe_block() was called
and some GPEs are enabled twice during the initialization as a
result.

Second, acpi_set_gpe() won't enable wakeup-only GPEs, because it
attempts to do that with the help of acpi_ev_enable_gpe() which, in
turn, calls acpi_hw_write_gpe_enable_reg() that will only enable the
GPE if its bit is set in the register's enable_for_run.  Worse yet,
acpi_hw_write_gpe_enable_reg() always writes the entire
enable_for_run mask into the register, so in theory it may enable
more GPEs than just the one we want to enable (for example, it may
enable GPEs in the same register that were disabled by
acpi_hw_low_disable_gpe() previously).

Next, the enable_for_run and enable_for_wake masks of the GPE
registers only change when the GPEs' runtime_count and wakeup_count
fields change from zero to nonzero or the other way around, so it
doesn't make sense to update the enable_for_run and enable_for_wake
masks anywhere outside of acpi_enable_gpe() and acpi_disable_gpe().

Finally, the sysfs interface allowing user space to disable/enable
GPEs doesn't work correctly, because a GPE disabled this way may be
re-enabled shortly by acpi_ev_asynch_enable_gpe() if its bit is set
in its register's enable_for_run mask.

To address these problems, call acpi_ev_update_gpe_enable_masks()
directly from acpi_enable_gpe() and acpi_disable_gpe() where the
GPE's runtime_count and wakeup_count counters change in such a
way that its register's enable_for_run and enable_for_wake masks have
to be updated.  Change acpi_hw_low_disable_gpe() into
acpi_hw_low_set_gpe() that can set as well as clear the appropriate
bit in the GPE's register and use it wherever necessary.

Add a new action constant, ACPI_GPE_CHECK_AND_ENABLE, that will cause
acpi_hw_low_set_gpe() to check if the GPE's bit in its register's
enable_for_run mask is set before attempting to enable the GPE
and remove acpi_hw_write_gpe_enable_reg() which isn't necessary any
more.  Remove acpi_ev_enable_gpe() and acpi_ev_disable_gpe() that
aren't necessary too.

Make acpi_ev_initialize_gpe_block() check if a GPE has already been
enabled and avoid calling acpi_enable_gpe() for it if that's the
case.  Also make the sysfs GPE interface use acpi_enable_gpe() and
acpi_disable_gpe() instead of acpi_set_gpe() so that GPE reference
counters are taken into account by it.

In addition to that, to reduce code duplication, move the computation
of a GPE's register bit mask to a separate function and call it
wherever that computation has to be carried out.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/acpica/acevents.h |    4 -
 drivers/acpi/acpica/achware.h  |    7 +-
 drivers/acpi/acpica/evgpe.c    |  118 ++---------------------------------------
 drivers/acpi/acpica/evgpeblk.c |   25 ++++++++
 drivers/acpi/acpica/evxface.c  |    2 
 drivers/acpi/acpica/evxfevnt.c |   59 ++++++++++++++++++--
 drivers/acpi/acpica/hwgpe.c    |  118 +++++++++++++++++++++++------------------
 drivers/acpi/system.c          |    6 +-
 include/acpi/actypes.h         |    3 -
 9 files changed, 161 insertions(+), 181 deletions(-)

Index: linux-2.6/drivers/acpi/acpica/hwgpe.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/hwgpe.c
+++ linux-2.6/drivers/acpi/acpica/hwgpe.c
@@ -57,21 +57,45 @@ acpi_hw_enable_wakeup_gpe_block(struct a
 
 /******************************************************************************
  *
- * FUNCTION:	acpi_hw_low_disable_gpe
+ * FUNCTION:	acpi_hw_gpe_register_bit
+ *
+ * PARAMETERS:	gpe_event_info	    - Info block for the GPE
+ *		gpe_register_info   - Info block for the GPE register
+ *
+ * RETURN:	Status
+ *
+ * DESCRIPTION:	Compute the enable mask with one bit corresponding to the given
+ *		GPE set.
+ *
+ ******************************************************************************/
+
+u32 acpi_hw_gpe_register_bit(struct acpi_gpe_event_info *gpe_event_info,
+			     struct acpi_gpe_register_info *gpe_register_info)
+{
+	return (u32)1 << (gpe_event_info->gpe_number -
+				gpe_register_info->base_gpe_number);
+}
+
+/******************************************************************************
+ *
+ * FUNCTION:	acpi_hw_low_set_gpe
  *
  * PARAMETERS:	gpe_event_info	    - Info block for the GPE to be disabled
+ *		action		    - Enable or disable
  *
  * RETURN:	Status
  *
- * DESCRIPTION: Disable a single GPE in the enable register.
+ * DESCRIPTION: Enable or disable a single GPE in its enable register.
  *
  ******************************************************************************/
 
-acpi_status acpi_hw_low_disable_gpe(struct acpi_gpe_event_info *gpe_event_info)
+acpi_status acpi_hw_low_set_gpe(struct acpi_gpe_event_info *gpe_event_info,
+				u8 action)
 {
 	struct acpi_gpe_register_info *gpe_register_info;
 	acpi_status status;
 	u32 enable_mask;
+	u32 register_bit;
 
 	/* Get the info block for the entire GPE register */
 
@@ -80,6 +104,17 @@ acpi_status acpi_hw_low_disable_gpe(stru
 		return (AE_NOT_EXIST);
 	}
 
+	register_bit = acpi_hw_gpe_register_bit(gpe_event_info,
+						gpe_register_info);
+
+	if (action == ACPI_GPE_CHECK_AND_ENABLE) {
+		if (register_bit & gpe_register_info->enable_for_run) {
+			action = ACPI_GPE_ENABLE;
+		} else {
+			return (AE_BAD_PARAMETER);
+		}
+	}
+
 	/* Get current value of the enable register that contains this GPE */
 
 	status = acpi_hw_read(&enable_mask, &gpe_register_info->enable_address);
@@ -87,11 +122,22 @@ acpi_status acpi_hw_low_disable_gpe(stru
 		return (status);
 	}
 
-	/* Clear just the bit that corresponds to this GPE */
+	/* Set ot clear just the bit that corresponds to this GPE */
+
+	switch (action) {
+	case ACPI_GPE_ENABLE:
+		ACPI_SET_BIT(enable_mask, register_bit);
+		break;
+
+	case ACPI_GPE_DISABLE:
+		ACPI_CLEAR_BIT(enable_mask, register_bit);
+		break;
+
+	default:
+		ACPI_ERROR((AE_INFO, "Invalid action\n"));
+		return (AE_BAD_PARAMETER);
+	}
 
-	ACPI_CLEAR_BIT(enable_mask, ((u32)1 <<
-				     (gpe_event_info->gpe_number -
-				      gpe_register_info->base_gpe_number)));
 
 	/* Write the updated enable mask */
 
@@ -101,23 +147,21 @@ acpi_status acpi_hw_low_disable_gpe(stru
 
 /******************************************************************************
  *
- * FUNCTION:    acpi_hw_write_gpe_enable_reg
+ * FUNCTION:    acpi_hw_clear_gpe
  *
- * PARAMETERS:  gpe_event_info      - Info block for the GPE to be enabled
+ * PARAMETERS:  gpe_event_info      - Info block for the GPE to be cleared
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Write a GPE enable register.  Note: The bit for this GPE must
- *              already be cleared or set in the parent register
- *              enable_for_run mask.
+ * DESCRIPTION: Clear the status bit for a single GPE.
  *
  ******************************************************************************/
 
-acpi_status
-acpi_hw_write_gpe_enable_reg(struct acpi_gpe_event_info * gpe_event_info)
+acpi_status acpi_hw_clear_gpe(struct acpi_gpe_event_info * gpe_event_info)
 {
 	struct acpi_gpe_register_info *gpe_register_info;
 	acpi_status status;
+	u32 register_bit;
 
 	ACPI_FUNCTION_ENTRY();
 
@@ -128,43 +172,15 @@ acpi_hw_write_gpe_enable_reg(struct acpi
 		return (AE_NOT_EXIST);
 	}
 
-	/* Write the entire GPE (runtime) enable register */
-
-	status = acpi_hw_write(gpe_register_info->enable_for_run,
-			       &gpe_register_info->enable_address);
-
-	return (status);
-}
-
-/******************************************************************************
- *
- * FUNCTION:    acpi_hw_clear_gpe
- *
- * PARAMETERS:  gpe_event_info      - Info block for the GPE to be cleared
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Clear the status bit for a single GPE.
- *
- ******************************************************************************/
-
-acpi_status acpi_hw_clear_gpe(struct acpi_gpe_event_info * gpe_event_info)
-{
-	acpi_status status;
-	u8 register_bit;
-
-	ACPI_FUNCTION_ENTRY();
-
-	register_bit = (u8)(1 <<
-			    (gpe_event_info->gpe_number -
-			     gpe_event_info->register_info->base_gpe_number));
+	register_bit = acpi_hw_gpe_register_bit(gpe_event_info,
+						gpe_register_info);
 
 	/*
 	 * Write a one to the appropriate bit in the status register to
 	 * clear this GPE.
 	 */
 	status = acpi_hw_write(register_bit,
-			       &gpe_event_info->register_info->status_address);
+				&gpe_register_info->status_address);
 
 	return (status);
 }
@@ -187,7 +203,7 @@ acpi_hw_get_gpe_status(struct acpi_gpe_e
 		       acpi_event_status * event_status)
 {
 	u32 in_byte;
-	u8 register_bit;
+	u32 register_bit;
 	struct acpi_gpe_register_info *gpe_register_info;
 	acpi_status status;
 	acpi_event_status local_event_status = 0;
@@ -201,12 +217,12 @@ acpi_hw_get_gpe_status(struct acpi_gpe_e
 	/* Get the info block for the entire GPE register */
 
 	gpe_register_info = gpe_event_info->register_info;
+	if (!gpe_register_info) {
+		return (AE_NOT_EXIST);
+	}
 
-	/* Get the register bitmask for this GPE */
-
-	register_bit = (u8)(1 <<
-			    (gpe_event_info->gpe_number -
-			     gpe_event_info->register_info->base_gpe_number));
+	register_bit = acpi_hw_gpe_register_bit(gpe_event_info,
+						gpe_register_info);
 
 	/* GPE currently enabled? (enabled for runtime?) */
 
Index: linux-2.6/drivers/acpi/acpica/achware.h
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/achware.h
+++ linux-2.6/drivers/acpi/acpica/achware.h
@@ -90,10 +90,11 @@ acpi_status acpi_hw_write_port(acpi_io_a
 /*
  * hwgpe - GPE support
  */
-acpi_status acpi_hw_low_disable_gpe(struct acpi_gpe_event_info *gpe_event_info);
+u32 acpi_hw_gpe_register_bit(struct acpi_gpe_event_info *gpe_event_info,
+			     struct acpi_gpe_register_info *gpe_register_info);
 
-acpi_status
-acpi_hw_write_gpe_enable_reg(struct acpi_gpe_event_info *gpe_event_info);
+acpi_status acpi_hw_low_set_gpe(struct acpi_gpe_event_info *gpe_event_info,
+				u8 action);
 
 acpi_status
 acpi_hw_disable_gpe_block(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
Index: linux-2.6/drivers/acpi/acpica/evgpe.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evgpe.c
+++ linux-2.6/drivers/acpi/acpica/evgpe.c
@@ -69,7 +69,7 @@ acpi_status
 acpi_ev_update_gpe_enable_masks(struct acpi_gpe_event_info *gpe_event_info)
 {
 	struct acpi_gpe_register_info *gpe_register_info;
-	u8 register_bit;
+	u32 register_bit;
 
 	ACPI_FUNCTION_TRACE(ev_update_gpe_enable_masks);
 
@@ -78,9 +78,8 @@ acpi_ev_update_gpe_enable_masks(struct a
 		return_ACPI_STATUS(AE_NOT_EXIST);
 	}
 
-	register_bit = (u8)
-	    (1 <<
-	     (gpe_event_info->gpe_number - gpe_register_info->base_gpe_number));
+	register_bit = acpi_hw_gpe_register_bit(gpe_event_info,
+						gpe_register_info);
 
 	/* Clear the wake/run bits up front */
 
@@ -102,107 +101,6 @@ acpi_ev_update_gpe_enable_masks(struct a
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_ev_enable_gpe
- *
- * PARAMETERS:  gpe_event_info          - GPE to enable
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Hardware-enable a GPE. Always enables the GPE, regardless
- *              of type or number of references.
- *
- * Note: The GPE lock should be already acquired when this function is called.
- *
- ******************************************************************************/
-
-acpi_status acpi_ev_enable_gpe(struct acpi_gpe_event_info *gpe_event_info)
-{
-	acpi_status status;
-
-
-	ACPI_FUNCTION_TRACE(ev_enable_gpe);
-
-
-	/*
-	 * We will only allow a GPE to be enabled if it has either an
-	 * associated method (_Lxx/_Exx) or a handler. Otherwise, the
-	 * GPE will be immediately disabled by acpi_ev_gpe_dispatch the
-	 * first time it fires.
-	 */
-	if (!(gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK)) {
-		return_ACPI_STATUS(AE_NO_HANDLER);
-	}
-
-	/* Ensure the HW enable masks are current */
-
-	status = acpi_ev_update_gpe_enable_masks(gpe_event_info);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/* Clear the GPE (of stale events) */
-
-	status = acpi_hw_clear_gpe(gpe_event_info);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/* Enable the requested GPE */
-
-	status = acpi_hw_write_gpe_enable_reg(gpe_event_info);
-	return_ACPI_STATUS(status);
-}
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_ev_disable_gpe
- *
- * PARAMETERS:  gpe_event_info          - GPE to disable
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Hardware-disable a GPE. Always disables the requested GPE,
- *              regardless of the type or number of references.
- *
- * Note: The GPE lock should be already acquired when this function is called.
- *
- ******************************************************************************/
-
-acpi_status acpi_ev_disable_gpe(struct acpi_gpe_event_info *gpe_event_info)
-{
-	acpi_status status;
-
-	ACPI_FUNCTION_TRACE(ev_disable_gpe);
-
-
-	/*
-	 * Note: Always disable the GPE, even if we think that that it is already
-	 * disabled. It is possible that the AML or some other code has enabled
-	 * the GPE behind our back.
-	 */
-
-	/* Ensure the HW enable masks are current */
-
-	status = acpi_ev_update_gpe_enable_masks(gpe_event_info);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/*
-	 * Always H/W disable this GPE, even if we don't know the GPE type.
-	 * Simply clear the enable bit for this particular GPE, but do not
-	 * write out the current GPE enable mask since this may inadvertently
-	 * enable GPEs too early. An example is a rogue GPE that has arrived
-	 * during ACPICA initialization - possibly because AML or other code
-	 * has enabled the GPE.
-	 */
-	status = acpi_hw_low_disable_gpe(gpe_event_info);
-	return_ACPI_STATUS(status);
-}
-
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_ev_low_get_gpe_info
  *
  * PARAMETERS:  gpe_number          - Raw GPE number
@@ -451,10 +349,6 @@ static void ACPI_SYSTEM_XFACE acpi_ev_as
 		return_VOID;
 	}
 
-	/* Update the GPE register masks for return to enabled state */
-
-	(void)acpi_ev_update_gpe_enable_masks(gpe_event_info);
-
 	/*
 	 * Take a snapshot of the GPE info for this level - we copy the info to
 	 * prevent a race condition with remove_handler/remove_block.
@@ -523,7 +417,7 @@ static void acpi_ev_asynch_enable_gpe(vo
 	}
 
 	/* Enable this GPE */
-	(void)acpi_hw_write_gpe_enable_reg(gpe_event_info);
+	(void)acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_CHECK_AND_ENABLE);
 	return_VOID;
 }
 
@@ -607,7 +501,7 @@ acpi_ev_gpe_dispatch(struct acpi_gpe_eve
 		 * Disable the GPE, so it doesn't keep firing before the method has a
 		 * chance to run (it runs asynchronously with interrupts enabled).
 		 */
-		status = acpi_ev_disable_gpe(gpe_event_info);
+		status = acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_DISABLE);
 		if (ACPI_FAILURE(status)) {
 			ACPI_EXCEPTION((AE_INFO, status,
 					"Unable to disable GPE[0x%2X]",
@@ -644,7 +538,7 @@ acpi_ev_gpe_dispatch(struct acpi_gpe_eve
 		 * Disable the GPE. The GPE will remain disabled a handler
 		 * is installed or ACPICA is restarted.
 		 */
-		status = acpi_ev_disable_gpe(gpe_event_info);
+		status = acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_DISABLE);
 		if (ACPI_FAILURE(status)) {
 			ACPI_EXCEPTION((AE_INFO, status,
 					"Unable to disable GPE[0x%2X]",
Index: linux-2.6/drivers/acpi/acpica/evxfevnt.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evxfevnt.c
+++ linux-2.6/drivers/acpi/acpica/evxfevnt.c
@@ -210,6 +210,44 @@ ACPI_EXPORT_SYMBOL(acpi_enable_event)
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_clear_and_enable_gpe
+ *
+ * PARAMETERS:  gpe_event_info  - GPE to enable
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Clear the given GPE from stale events and enable it.
+ *
+ ******************************************************************************/
+static acpi_status
+acpi_clear_and_enable_gpe(struct acpi_gpe_event_info *gpe_event_info)
+{
+	acpi_status status;
+
+	/*
+	 * We will only allow a GPE to be enabled if it has either an
+	 * associated method (_Lxx/_Exx) or a handler. Otherwise, the
+	 * GPE will be immediately disabled by acpi_ev_gpe_dispatch the
+	 * first time it fires.
+	 */
+	if (!(gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK)) {
+		return_ACPI_STATUS(AE_NO_HANDLER);
+	}
+
+	/* Clear the GPE (of stale events) */
+	status = acpi_hw_clear_gpe(gpe_event_info);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Enable the requested GPE */
+	status = acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_ENABLE);
+
+	return_ACPI_STATUS(status);
+}
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_set_gpe
  *
  * PARAMETERS:  gpe_device      - Parent GPE Device. NULL for GPE0/GPE1
@@ -249,11 +287,11 @@ acpi_status acpi_set_gpe(acpi_handle gpe
 
 	switch (action) {
 	case ACPI_GPE_ENABLE:
-		status = acpi_ev_enable_gpe(gpe_event_info);
+		status = acpi_clear_and_enable_gpe(gpe_event_info);
 		break;
 
 	case ACPI_GPE_DISABLE:
-		status = acpi_ev_disable_gpe(gpe_event_info);
+		status = acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_DISABLE);
 		break;
 
 	default:
@@ -316,7 +354,11 @@ acpi_status acpi_enable_gpe(acpi_handle 
 
 		gpe_event_info->runtime_count++;
 		if (gpe_event_info->runtime_count == 1) {
-			status = acpi_ev_enable_gpe(gpe_event_info);
+			status = acpi_ev_update_gpe_enable_masks(gpe_event_info);
+			if (ACPI_SUCCESS(status)) {
+				status = acpi_clear_and_enable_gpe(gpe_event_info);
+			}
+
 			if (ACPI_FAILURE(status)) {
 				gpe_event_info->runtime_count--;
 				goto unlock_and_exit;
@@ -343,7 +385,7 @@ acpi_status acpi_enable_gpe(acpi_handle 
 		 */
 		gpe_event_info->wakeup_count++;
 		if (gpe_event_info->wakeup_count == 1) {
-			(void)acpi_ev_update_gpe_enable_masks(gpe_event_info);
+			status = acpi_ev_update_gpe_enable_masks(gpe_event_info);
 		}
 	}
 
@@ -403,7 +445,12 @@ acpi_status acpi_disable_gpe(acpi_handle
 
 		gpe_event_info->runtime_count--;
 		if (!gpe_event_info->runtime_count) {
-			status = acpi_ev_disable_gpe(gpe_event_info);
+			status = acpi_ev_update_gpe_enable_masks(gpe_event_info);
+			if (ACPI_SUCCESS(status)) {
+				status = acpi_hw_low_set_gpe(gpe_event_info,
+							     ACPI_GPE_DISABLE);
+			}
+
 			if (ACPI_FAILURE(status)) {
 				gpe_event_info->runtime_count++;
 				goto unlock_and_exit;
@@ -424,7 +471,7 @@ acpi_status acpi_disable_gpe(acpi_handle
 
 		gpe_event_info->wakeup_count--;
 		if (!gpe_event_info->wakeup_count) {
-			(void)acpi_ev_update_gpe_enable_masks(gpe_event_info);
+			status = acpi_ev_update_gpe_enable_masks(gpe_event_info);
 		}
 	}
 
Index: linux-2.6/drivers/acpi/acpica/evgpeblk.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evgpeblk.c
+++ linux-2.6/drivers/acpi/acpica/evgpeblk.c
@@ -500,6 +500,30 @@ acpi_ev_initialize_gpe_block(struct acpi
 
 			gpe_index = (i * ACPI_GPE_REGISTER_WIDTH) + j;
 			gpe_event_info = &gpe_block->event_info[gpe_index];
+			gpe_number = gpe_index + gpe_block->block_base_number;
+
+			/*
+			 * Ensure that the register bit corresponding to this
+			 * GPE in its register's enable masks is up to date.
+			 */
+			status = acpi_ev_update_gpe_enable_masks(gpe_event_info);
+			if (ACPI_FAILURE(status)) {
+				ACPI_ERROR((AE_INFO, "Failed to update enable "
+					"masks for GPE %02X\n", gpe_number));
+				continue;
+			}
+
+			/*
+			 * If the GPE has already been enabled for runtime
+			 * signaling, make sure it remains enabled, but do not
+			 * increment its reference counter.
+			 */
+			if (gpe_event_info->runtime_count) {
+				acpi_set_gpe(gpe_device, gpe_number,
+						ACPI_GPE_ENABLE);
+				gpe_enabled_count++;
+				continue;
+			}
 
 			if (gpe_event_info->flags & ACPI_GPE_CAN_WAKE) {
 				wake_gpe_count++;
@@ -516,7 +540,6 @@ acpi_ev_initialize_gpe_block(struct acpi
 
 			/* Enable this GPE */
 
-			gpe_number = gpe_index + gpe_block->block_base_number;
 			status = acpi_enable_gpe(gpe_device, gpe_number,
 						 ACPI_GPE_TYPE_RUNTIME);
 			if (ACPI_FAILURE(status)) {
Index: linux-2.6/include/acpi/actypes.h
===================================================================
--- linux-2.6.orig/include/acpi/actypes.h
+++ linux-2.6/include/acpi/actypes.h
@@ -663,10 +663,11 @@ typedef u32 acpi_event_status;
 #define ACPI_GPE_MAX                    0xFF
 #define ACPI_NUM_GPE                    256
 
-/* Actions for acpi_set_gpe */
+/* Actions for acpi_set_gpe and acpi_hw_low_set_gpe */
 
 #define ACPI_GPE_ENABLE                 0
 #define ACPI_GPE_DISABLE                1
+#define ACPI_GPE_CHECK_AND_ENABLE       2
 
 /* gpe_types for acpi_enable_gpe and acpi_disable_gpe */
 
Index: linux-2.6/drivers/acpi/acpica/evxface.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evxface.c
+++ linux-2.6/drivers/acpi/acpica/evxface.c
@@ -721,7 +721,7 @@ acpi_install_gpe_handler(acpi_handle gpe
 
 	/* Disable the GPE before installing the handler */
 
-	status = acpi_ev_disable_gpe(gpe_event_info);
+	status = acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_DISABLE);
 	if (ACPI_FAILURE (status)) {
 		goto unlock_and_exit;
 	}
Index: linux-2.6/drivers/acpi/acpica/acevents.h
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/acevents.h
+++ linux-2.6/drivers/acpi/acpica/acevents.h
@@ -80,10 +80,6 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_x
 acpi_status
 acpi_ev_update_gpe_enable_masks(struct acpi_gpe_event_info *gpe_event_info);
 
-acpi_status acpi_ev_enable_gpe(struct acpi_gpe_event_info *gpe_event_info);
-
-acpi_status acpi_ev_disable_gpe(struct acpi_gpe_event_info *gpe_event_info);
-
 struct acpi_gpe_event_info *acpi_ev_get_gpe_event_info(acpi_handle gpe_device,
 						       u32 gpe_number);
 
Index: linux-2.6/drivers/acpi/system.c
===================================================================
--- linux-2.6.orig/drivers/acpi/system.c
+++ linux-2.6/drivers/acpi/system.c
@@ -388,10 +388,12 @@ static ssize_t counter_set(struct kobjec
 	if (index < num_gpes) {
 		if (!strcmp(buf, "disable\n") &&
 				(status & ACPI_EVENT_FLAG_ENABLED))
-			result = acpi_set_gpe(handle, index, ACPI_GPE_DISABLE);
+			result = acpi_disable_gpe(handle, index,
+						ACPI_GPE_TYPE_RUNTIME);
 		else if (!strcmp(buf, "enable\n") &&
 				!(status & ACPI_EVENT_FLAG_ENABLED))
-			result = acpi_set_gpe(handle, index, ACPI_GPE_ENABLE);
+			result = acpi_enable_gpe(handle, index,
+						ACPI_GPE_TYPE_RUNTIME);
 		else if (!strcmp(buf, "clear\n") &&
 				(status & ACPI_EVENT_FLAG_SET))
 			result = acpi_clear_gpe(handle, index);
