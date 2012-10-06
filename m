Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab2JFUN6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:13:58 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52672 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2JFUNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:13:53 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 13/49] ACPI: Use ACPICA native way to decode the PLD buffer
Date: Sat,  6 Oct 2012 16:09:34 -0400
Message-Id: <8ede06aba5dffa78a27a18c47a9059eb38072ada.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

This patch is on top of the ACPICA 20120816 release, which implemented
a native way to decode PLD buffer, so use it instead of leting upper
level users do the decoding.

v2: Modify the check for PLD buffer length to reject buffers whose
length < 16

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/utils.c    | 11 +++++++----
 include/acpi/acpi_bus.h | 31 +------------------------------
 2 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 3e87c9c..462f7e3 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -384,7 +384,7 @@ acpi_evaluate_reference(acpi_handle handle,
 EXPORT_SYMBOL(acpi_evaluate_reference);
 
 acpi_status
-acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld *pld)
+acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld)
 {
 	acpi_status status;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -400,13 +400,16 @@ acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld *pld)
 	if (!output || output->type != ACPI_TYPE_PACKAGE
 	    || !output->package.count
 	    || output->package.elements[0].type != ACPI_TYPE_BUFFER
-	    || output->package.elements[0].buffer.length > sizeof(*pld)) {
+	    || output->package.elements[0].buffer.length < ACPI_PLD_REV1_BUFFER_SIZE) {
 		status = AE_TYPE;
 		goto out;
 	}
 
-	memcpy(pld, output->package.elements[0].buffer.pointer,
-	       output->package.elements[0].buffer.length);
+	status = acpi_decode_pld_buffer(
+			output->package.elements[0].buffer.pointer,
+			output->package.elements[0].buffer.length,
+			pld);
+
 out:
 	kfree(buffer.pointer);
 	return status;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index bde976e..0c1fcd4 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -54,37 +54,8 @@ acpi_status
 acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
 			u32 status_code, struct acpi_buffer *status_buf);
 
-struct acpi_pld {
-	unsigned int revision:7; /* 0 */
-	unsigned int ignore_colour:1; /* 7 */
-	unsigned int colour:24; /* 8 */
-	unsigned int width:16; /* 32 */
-	unsigned int height:16; /* 48 */
-	unsigned int user_visible:1; /* 64 */
-	unsigned int dock:1; /* 65 */
-	unsigned int lid:1; /* 66 */
-	unsigned int panel:3; /* 67 */
-	unsigned int vertical_pos:2; /* 70 */
-	unsigned int horizontal_pos:2; /* 72 */
-	unsigned int shape:4; /* 74 */
-	unsigned int group_orientation:1; /* 78 */
-	unsigned int group_token:8; /* 79 */
-	unsigned int group_position:8; /* 87 */
-	unsigned int bay:1; /* 95 */
-	unsigned int ejectable:1; /* 96 */
-	unsigned int ospm_eject_required:1; /* 97 */
-	unsigned int cabinet_number:8; /* 98 */
-	unsigned int card_cage_number:8; /* 106 */
-	unsigned int reference:1; /* 114 */
-	unsigned int rotation:4; /* 115 */
-	unsigned int order:5; /* 119 */
-	unsigned int reserved:4; /* 124 */
-	unsigned int vertical_offset:16; /* 128 */
-	unsigned int horizontal_offset:16; /* 144 */
-} __attribute__((__packed__));
-
 acpi_status
-acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld *pld);
+acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld);
 #ifdef CONFIG_ACPI
 
 #include <linux/proc_fs.h>
-- 
1.8.0.rc0.18.gf84667d

