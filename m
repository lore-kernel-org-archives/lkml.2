Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab0DPQPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:15:05 -0400
Received: from mail.webcontact.de ([82.98.82.138]:60944 "EHLO
	borg.webcontact.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758256Ab0DPQO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:14:59 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Apr 2010 12:14:59 EDT
From: Alexander Rauth <alexander.rauth@promotion-ie.de>
To: Len Brown <lenb@kernel.org>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Alexander Rauth <alexander.rauth@promotion-ie.de>
Subject: [PATCH] ACPI: EC: limit multibyte access to EC to 8 byte
Date: Fri, 16 Apr 2010 18:07:46 +0200
Message-Id: <1271434066-7292-1-git-send-email-alexander.rauth@promotion-ie.de>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit dadf28a10c3eb29421837a2e413ab869ebd9e168 enabled multibyte
access to EC, but ignored that the consuming function expects the
bitfields to be in chunks of maximal 64 bit. So limit multibyte
access to 8 byte to prevent error in the ACPI layer.

Signed-off-by: Alexander Rauth <alexander.rauth@promotion-ie.de>
---
 drivers/acpi/acpica/exprep.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpica/exprep.c b/drivers/acpi/acpica/exprep.c
index a610ebe..58659af 100644
--- a/drivers/acpi/acpica/exprep.c
+++ b/drivers/acpi/acpica/exprep.c
@@ -471,13 +471,18 @@ acpi_status acpi_ex_prep_field_value(struct acpi_create_field_info *info)
 		/* allow full data read from EC address space */
 		if (obj_desc->field.region_obj->region.space_id ==
 			ACPI_ADR_SPACE_EC) {
-			if (obj_desc->common_field.bit_length > 8)
-				obj_desc->common_field.access_bit_width =
-				ACPI_ROUND_UP(obj_desc->common_field.
-							bit_length, 8);
+			if (obj_desc->common_field.bit_length > 8) {
+				if (obj_desc->common_field.bit_length <= 64) {
+					obj_desc->common_field.access_bit_width =
+						ACPI_ROUND_UP(obj_desc->common_field.
+						bit_length, 8);
+				} else {
+					obj_desc->common_field.access_bit_width = 64;
+				}	
 				obj_desc->common_field.access_byte_width =
-				ACPI_DIV_8(obj_desc->common_field.
-							access_bit_width);
+					ACPI_DIV_8(obj_desc->common_field.
+					access_bit_width);
+			}
 		}
 
 		ACPI_DEBUG_PRINT((ACPI_DB_BFIELD,
-- 
1.6.4.4

