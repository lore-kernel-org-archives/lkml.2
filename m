Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0FHJAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:00:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37152 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab0FHJAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:00:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 3/5] ACPI / ACPICA: Avoid writing full enable masks to GPE registers
Date: Tue, 8 Jun 2010 10:49:45 +0200
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
Message-Id: <201006081049.45342.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

ACPICA uses acpi_hw_write_gpe_enable_reg() to re-enable a GPE after
an event signaled by it has been handled.  However, this function
writes the entire GPE enable mask to the GPE's enable register which
may not be correct.  Namely, if one of the other GPEs in the same
register was previously enabled by acpi_enable_gpe() and subsequently
disabled using acpi_set_gpe(), acpi_hw_write_gpe_enable_reg() will
re-enable it along with the target GPE.

To fix this issue rework acpi_hw_write_gpe_enable_reg() so that it
calls acpi_hw_low_set_gpe() with a special action value,
ACPI_GPE_COND_ENABLE, that will make it only enable the GPE if the
corresponding bit in its register's enable_for_run mask is set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/acpica/hwgpe.c |   18 +++++-------------
 include/acpi/actypes.h      |    1 +
 2 files changed, 6 insertions(+), 13 deletions(-)

Index: linux-2.6/drivers/acpi/acpica/hwgpe.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/hwgpe.c
+++ linux-2.6/drivers/acpi/acpica/hwgpe.c
@@ -118,6 +118,10 @@ acpi_hw_low_set_gpe(struct acpi_gpe_even
 	register_bit = acpi_hw_gpe_register_bit(gpe_event_info,
 						gpe_register_info);
 	switch (action) {
+	case ACPI_GPE_COND_ENABLE:
+		if (!(register_bit & gpe_register_info->enable_for_run))
+			return (AE_BAD_PARAMETER);
+
 	case ACPI_GPE_ENABLE:
 		ACPI_SET_BIT(enable_mask, register_bit);
 		break;
@@ -154,23 +158,11 @@ acpi_hw_low_set_gpe(struct acpi_gpe_even
 acpi_status
 acpi_hw_write_gpe_enable_reg(struct acpi_gpe_event_info * gpe_event_info)
 {
-	struct acpi_gpe_register_info *gpe_register_info;
 	acpi_status status;
 
 	ACPI_FUNCTION_ENTRY();
 
-	/* Get the info block for the entire GPE register */
-
-	gpe_register_info = gpe_event_info->register_info;
-	if (!gpe_register_info) {
-		return (AE_NOT_EXIST);
-	}
-
-	/* Write the entire GPE (runtime) enable register */
-
-	status = acpi_hw_write(gpe_register_info->enable_for_run,
-			       &gpe_register_info->enable_address);
-
+	status = acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_COND_ENABLE);
 	return (status);
 }
 
Index: linux-2.6/include/acpi/actypes.h
===================================================================
--- linux-2.6.orig/include/acpi/actypes.h
+++ linux-2.6/include/acpi/actypes.h
@@ -667,6 +667,7 @@ typedef u32 acpi_event_status;
 
 #define ACPI_GPE_ENABLE                 0
 #define ACPI_GPE_DISABLE                1
+#define ACPI_GPE_COND_ENABLE            2
 
 /* gpe_types for acpi_enable_gpe and acpi_disable_gpe */
 

