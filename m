Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab0DVUC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:02:57 -0400
Received: from kroah.org ([198.145.64.141]:60029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758141Ab0DVUBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:51 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:17 2010
Message-Id: <20100422195417.525889613@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: [121/139] ACPI: EC: Limit burst to 64 bits
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit 2060c44576c79086ff24718878d7edaa7384a985 upstream.

access_bit_width field is u8 in ACPICA, thus 256 value written to it
becomes 0, causing divide by zero later.

Proper fix would be to remove access_bit_width at all, just because
we already have access_byte_width, which is access_bit_width / 8.
Limit access width to 64 bit for now.

https://bugzilla.kernel.org/show_bug.cgi?id=15749
fixes regression caused by the fix for:
https://bugzilla.kernel.org/show_bug.cgi?id=14667

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/acpica/exprep.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/acpi/acpica/exprep.c
+++ b/drivers/acpi/acpica/exprep.c
@@ -471,13 +471,18 @@ acpi_status acpi_ex_prep_field_value(str
 		/* allow full data read from EC address space */
 		if (obj_desc->field.region_obj->region.space_id ==
 			ACPI_ADR_SPACE_EC) {
-			if (obj_desc->common_field.bit_length > 8)
-				obj_desc->common_field.access_bit_width =
-				ACPI_ROUND_UP(obj_desc->common_field.
-							bit_length, 8);
+			if (obj_desc->common_field.bit_length > 8) {
+				unsigned width =
+					ACPI_ROUND_BITS_UP_TO_BYTES(
+					obj_desc->common_field.bit_length);
+				// access_bit_width is u8, don't overflow it
+				if (width > 8)
+					width = 8;
 				obj_desc->common_field.access_byte_width =
-				ACPI_DIV_8(obj_desc->common_field.
-							access_bit_width);
+							width;
+				obj_desc->common_field.access_bit_width =
+							8 * width;
+			}
 		}
 
 		ACPI_DEBUG_PRINT((ACPI_DB_BFIELD,


