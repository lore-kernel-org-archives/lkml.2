Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab0FHJAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:00:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37148 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab0FHJAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:00:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 1/5] ACPI / ACPICA: Use helper function for computing GPE masks
Date: Tue, 8 Jun 2010 10:48:26 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Len Brown <len.brown@intel.com>, Zhang Rui <rui.zhang@intel.com>
References: <201006080024.46142.rjw@sisk.pl> <201006081046.48488.rjw@sisk.pl>
In-Reply-To: <201006081046.48488.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006081048.26092.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

In quite a few places ACPICA needs to compute a GPE enable mask with
only one bit, corresponding to a given GPE, set.  Currently, that
computation is always open coded which leads to unnecessary code
duplication.  Fix this by introducing a helper function for computing
one-bit GPE enable masks and using it where appropriate.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/acpica/achware.h |    3 ++
 drivers/acpi/acpica/evgpe.c   |    7 ++---
 drivers/acpi/acpica/hwgpe.c   |   52 ++++++++++++++++++++++++++++++++----------
 3 files changed, 46 insertions(+), 16 deletions(-)

Index: linux-2.6/drivers/acpi/acpica/achware.h
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/achware.h
+++ linux-2.6/drivers/acpi/acpica/achware.h
@@ -90,6 +90,9 @@ acpi_status acpi_hw_write_port(acpi_io_a
 /*
  * hwgpe - GPE support
  */
+u32 acpi_hw_gpe_register_bit(struct acpi_gpe_event_info *gpe_event_info,
+			     struct acpi_gpe_register_info *gpe_register_info);
+
 acpi_status acpi_hw_low_disable_gpe(struct acpi_gpe_event_info *gpe_event_info);
 
 acpi_status
Index: linux-2.6/drivers/acpi/acpica/hwgpe.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/hwgpe.c
+++ linux-2.6/drivers/acpi/acpica/hwgpe.c
@@ -57,6 +57,27 @@ acpi_hw_enable_wakeup_gpe_block(struct a
 
 /******************************************************************************
  *
+ * FUNCTION:	acpi_hw_gpe_register_bit
+ *
+ * PARAMETERS:	gpe_event_info	    - Info block for the GPE
+ *		gpe_register_info   - Info block for the GPE register
+ *
+ * RETURN:	Status
+ *
+ * DESCRIPTION:	Compute GPE enable mask with one bit corresponding to the given
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
  * FUNCTION:	acpi_hw_low_disable_gpe
  *
  * PARAMETERS:	gpe_event_info	    - Info block for the GPE to be disabled
@@ -72,6 +93,7 @@ acpi_status acpi_hw_low_disable_gpe(stru
 	struct acpi_gpe_register_info *gpe_register_info;
 	acpi_status status;
 	u32 enable_mask;
+	u32 register_bit;
 
 	/* Get the info block for the entire GPE register */
 
@@ -89,9 +111,9 @@ acpi_status acpi_hw_low_disable_gpe(stru
 
 	/* Clear just the bit that corresponds to this GPE */
 
-	ACPI_CLEAR_BIT(enable_mask, ((u32)1 <<
-				     (gpe_event_info->gpe_number -
-				      gpe_register_info->base_gpe_number)));
+	register_bit = acpi_hw_gpe_register_bit(gpe_event_info,
+						gpe_register_info);
+	ACPI_CLEAR_BIT(enable_mask, register_bit);
 
 	/* Write the updated enable mask */
 
@@ -150,21 +172,28 @@ acpi_hw_write_gpe_enable_reg(struct acpi
 
 acpi_status acpi_hw_clear_gpe(struct acpi_gpe_event_info * gpe_event_info)
 {
+	struct acpi_gpe_register_info *gpe_register_info;
 	acpi_status status;
-	u8 register_bit;
+	u32 register_bit;
 
 	ACPI_FUNCTION_ENTRY();
 
-	register_bit = (u8)(1 <<
-			    (gpe_event_info->gpe_number -
-			     gpe_event_info->register_info->base_gpe_number));
+	/* Get the info block for the entire GPE register */
+
+	gpe_register_info = gpe_event_info->register_info;
+	if (!gpe_register_info) {
+		return (AE_NOT_EXIST);
+	}
+
+	register_bit = acpi_hw_gpe_register_bit(gpe_event_info,
+						gpe_register_info);
 
 	/*
 	 * Write a one to the appropriate bit in the status register to
 	 * clear this GPE.
 	 */
 	status = acpi_hw_write(register_bit,
-			       &gpe_event_info->register_info->status_address);
+			       &gpe_register_info->status_address);
 
 	return (status);
 }
@@ -187,7 +216,7 @@ acpi_hw_get_gpe_status(struct acpi_gpe_e
 		       acpi_event_status * event_status)
 {
 	u32 in_byte;
-	u8 register_bit;
+	u32 register_bit;
 	struct acpi_gpe_register_info *gpe_register_info;
 	acpi_status status;
 	acpi_event_status local_event_status = 0;
@@ -204,9 +233,8 @@ acpi_hw_get_gpe_status(struct acpi_gpe_e
 
 	/* Get the register bitmask for this GPE */
 
-	register_bit = (u8)(1 <<
-			    (gpe_event_info->gpe_number -
-			     gpe_event_info->register_info->base_gpe_number));
+	register_bit = acpi_hw_gpe_register_bit(gpe_event_info,
+						gpe_register_info);
 
 	/* GPE currently enabled? (enabled for runtime?) */
 
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
 

