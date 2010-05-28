Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0E1Uqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:46:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54033 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab0E1Uqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:46:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/2] ACPI / ACPICA: Allow GPEs to be force disabled via sysfs
Date: Fri, 28 May 2010 22:47:43 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Moore, Robert" <robert.moore@intel.com>
References: <201005282245.19382.rjw@sisk.pl>
In-Reply-To: <201005282245.19382.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005282247.43261.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the GPE reference counting patches (commits
9630bdd9b15d2f489c646d8bc04b60e53eb5ec78 and
cbbc0de700e61d0cdc854d435dbc2ef148de0e00), the sysfs interface
allowing user space to disable/enable GPEs doesn't work correctly,
because a GPE disabled this way may be re-enabled shortly by
acpi_ev_asynch_enable_gpe() if its bit is set in its register's
enable_for_run mask.

To fix this, introduce two new action values for acpi_set_gpe(),
ACPI_GPE_FORCE_ENABLE and ACPI_GPE_FORCE_DISABLE, such that if
acpi_set_gpe() is called with ACPI_GPE_FORCE_DISABLE, the GPE is
force disabled and can only be re-enabled by calling acpi_set_gpe()
with ACPI_GPE_FORCE_ENABLE.  Use these new values in the sysfs
interface for disabling/enabling GPEs.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/acpica/evgpe.c    |    5 ++++-
 drivers/acpi/acpica/evxfevnt.c |   24 ++++++++++++++++++++++++
 drivers/acpi/system.c          |    6 ++++--
 include/acpi/actypes.h         |   19 ++++++++++++-------
 4 files changed, 44 insertions(+), 10 deletions(-)

Index: linux-2.6/include/acpi/actypes.h
===================================================================
--- linux-2.6.orig/include/acpi/actypes.h
+++ linux-2.6/include/acpi/actypes.h
@@ -668,6 +668,8 @@ typedef u32 acpi_event_status;
 #define ACPI_GPE_ENABLE                 0
 #define ACPI_GPE_DISABLE                1
 #define ACPI_GPE_CHECK_AND_ENABLE       2
+#define ACPI_GPE_FORCE_ENABLE           3
+#define ACPI_GPE_FORCE_DISABLE          4
 
 /* gpe_types for acpi_enable_gpe and acpi_disable_gpe */
 
@@ -677,13 +679,14 @@ typedef u32 acpi_event_status;
 
 /*
  * GPE info flags - Per GPE
- * +-------+---+-+-+
- * |  7:4  |3:2|1|0|
- * +-------+---+-+-+
- *     |     |  | |
- *     |     |  | +--- Interrupt type: edge or level triggered
- *     |     |  +----- GPE can wake the system
- *     |     +-------- Type of dispatch:to method, handler, or none
+ * +-------+-+---+-+-+
+ * |  7:5  |4|3:2|1|0|
+ * +-------+-+---+-+-+
+ *     |    |  |  | |
+ *     |    |  |  | +--- Interrupt type: edge or level triggered
+ *     |    |  |  +----- GPE can wake the system
+ *     |    |  +-------- Type of dispatch:to method, handler, or none
+ *     |    +----------- GPE has been forcibly disabled
  *     +-------------- <Reserved>
  */
 #define ACPI_GPE_XRUPT_TYPE_MASK        (u8) 0x01
@@ -697,6 +700,8 @@ typedef u32 acpi_event_status;
 #define ACPI_GPE_DISPATCH_METHOD        (u8) 0x08
 #define ACPI_GPE_DISPATCH_NOT_USED      (u8) 0x00
 
+#define ACPI_GPE_FORCE_DISABLED		(u8) 0x10
+
 /*
  * Flags for GPE and Lock interfaces
  */
Index: linux-2.6/drivers/acpi/acpica/evgpe.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evgpe.c
+++ linux-2.6/drivers/acpi/acpica/evgpe.c
@@ -417,7 +417,10 @@ static void acpi_ev_asynch_enable_gpe(vo
 	}
 
 	/* Enable this GPE */
-	(void)acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_CHECK_AND_ENABLE);
+	if (!(gpe_event_info->flags & ACPI_GPE_FORCE_DISABLED)) {
+		(void)acpi_hw_low_set_gpe(gpe_event_info,
+					  ACPI_GPE_CHECK_AND_ENABLE);
+	}
 	return_VOID;
 }
 
Index: linux-2.6/drivers/acpi/acpica/evxfevnt.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evxfevnt.c
+++ linux-2.6/drivers/acpi/acpica/evxfevnt.c
@@ -281,10 +281,24 @@ acpi_status acpi_set_gpe(acpi_handle gpe
 		status = acpi_clear_and_enable_gpe(gpe_event_info);
 		break;
 
+	case ACPI_GPE_FORCE_ENABLE:
+		status = acpi_clear_and_enable_gpe(gpe_event_info);
+		if (ACPI_SUCCESS(status)) {
+			gpe_event_info->flags &= ~(ACPI_GPE_FORCE_DISABLED);
+		}
+		break;
+
 	case ACPI_GPE_DISABLE:
 		status = acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_DISABLE);
 		break;
 
+	case ACPI_GPE_FORCE_DISABLE:
+		status = acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_DISABLE);
+		if (ACPI_SUCCESS(status)) {
+			gpe_event_info->flags |= ACPI_GPE_FORCE_DISABLED;
+		}
+		break;
+
 	default:
 		status = AE_BAD_PARAMETER;
 		break;
@@ -337,6 +351,11 @@ acpi_status acpi_enable_gpe(acpi_handle 
 		goto unlock_and_exit;
 	}
 
+	if (gpe_event_info->flags & ACPI_GPE_FORCE_DISABLED) {
+		status = AE_ERROR;
+		goto unlock_and_exit;
+	}
+
 	if (gpe_type & ACPI_GPE_TYPE_RUNTIME) {
 		if (gpe_event_info->runtime_count == ACPI_UINT8_MAX) {
 			status = AE_LIMIT;	/* Too many references */
@@ -426,6 +445,11 @@ acpi_status acpi_disable_gpe(acpi_handle
 		goto unlock_and_exit;
 	}
 
+	if (gpe_event_info->flags & ACPI_GPE_FORCE_DISABLED) {
+		status = AE_ERROR;
+		goto unlock_and_exit;
+	}
+
 	/* Hardware-disable a runtime GPE on removal of the last reference */
 
 	if (gpe_type & ACPI_GPE_TYPE_RUNTIME) {
Index: linux-2.6/drivers/acpi/system.c
===================================================================
--- linux-2.6.orig/drivers/acpi/system.c
+++ linux-2.6/drivers/acpi/system.c
@@ -388,10 +388,12 @@ static ssize_t counter_set(struct kobjec
 	if (index < num_gpes) {
 		if (!strcmp(buf, "disable\n") &&
 				(status & ACPI_EVENT_FLAG_ENABLED))
-			result = acpi_set_gpe(handle, index, ACPI_GPE_DISABLE);
+			result = acpi_set_gpe(handle, index,
+						ACPI_GPE_FORCE_DISABLE);
 		else if (!strcmp(buf, "enable\n") &&
 				!(status & ACPI_EVENT_FLAG_ENABLED))
-			result = acpi_set_gpe(handle, index, ACPI_GPE_ENABLE);
+			result = acpi_set_gpe(handle, index,
+						ACPI_GPE_FORCE_ENABLE);
 		else if (!strcmp(buf, "clear\n") &&
 				(status & ACPI_EVENT_FLAG_SET))
 			result = acpi_clear_gpe(handle, index);

