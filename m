Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab0DVThy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:37:54 -0400
Received: from kroah.org ([198.145.64.141]:41466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836Ab0DVT3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:42 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:22 2010
Message-Id: <20100422190922.146928687@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>, 563313@bugs.debian.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [165/197] ACPI: EC: Allow multibyte access to EC
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit dadf28a10c3eb29421837a2e413ab869ebd upstream

http://bugzilla.kernel.org/show_bug.cgi?id=14667

[bwh: Backport to 2.6.32; same applies to 2.6.33]

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/acpica/exprep.c |   12 ++++++++++++
 drivers/acpi/ec.c            |   35 +++++++++--------------------------
 2 files changed, 21 insertions(+), 26 deletions(-)

--- a/drivers/acpi/acpica/exprep.c
+++ b/drivers/acpi/acpica/exprep.c
@@ -468,6 +468,18 @@ acpi_status acpi_ex_prep_field_value(str
 
 		acpi_ut_add_reference(obj_desc->field.region_obj);
 
+		/* allow full data read from EC address space */
+		if (obj_desc->field.region_obj->region.space_id ==
+			ACPI_ADR_SPACE_EC) {
+			if (obj_desc->common_field.bit_length > 8)
+				obj_desc->common_field.access_bit_width =
+				ACPI_ROUND_UP(obj_desc->common_field.
+							bit_length, 8);
+				obj_desc->common_field.access_byte_width =
+				ACPI_DIV_8(obj_desc->common_field.
+							access_bit_width);
+		}
+
 		ACPI_DEBUG_PRINT((ACPI_DB_BFIELD,
 				  "RegionField: BitOff %X, Off %X, Gran %X, Region %p\n",
 				  obj_desc->field.start_field_bit_offset,
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -588,12 +588,12 @@ static u32 acpi_ec_gpe_handler(void *dat
 
 static acpi_status
 acpi_ec_space_handler(u32 function, acpi_physical_address address,
-		      u32 bits, acpi_integer *value,
+		      u32 bits, acpi_integer *value64,
 		      void *handler_context, void *region_context)
 {
 	struct acpi_ec *ec = handler_context;
-	int result = 0, i;
-	u8 temp = 0;
+	int result = 0, i, bytes = bits / 8;
+	u8 *value = (u8 *)value64;
 
 	if ((address > 0xFF) || !value || !handler_context)
 		return AE_BAD_PARAMETER;
@@ -601,32 +601,15 @@ acpi_ec_space_handler(u32 function, acpi
 	if (function != ACPI_READ && function != ACPI_WRITE)
 		return AE_BAD_PARAMETER;
 
-	if (bits != 8 && acpi_strict)
-		return AE_BAD_PARAMETER;
-
-	if (EC_FLAGS_MSI)
+	if (EC_FLAGS_MSI || bits > 8)
 		acpi_ec_burst_enable(ec);
 
-	if (function == ACPI_READ) {
-		result = acpi_ec_read(ec, address, &temp);
-		*value = temp;
-	} else {
-		temp = 0xff & (*value);
-		result = acpi_ec_write(ec, address, temp);
-	}
-
-	for (i = 8; unlikely(bits - i > 0); i += 8) {
-		++address;
-		if (function == ACPI_READ) {
-			result = acpi_ec_read(ec, address, &temp);
-			(*value) |= ((acpi_integer)temp) << i;
-		} else {
-			temp = 0xff & ((*value) >> i);
-			result = acpi_ec_write(ec, address, temp);
-		}
-	}
+	for (i = 0; i < bytes; ++i, ++address, ++value)
+		result = (function == ACPI_READ) ?
+			acpi_ec_read(ec, address, value) :
+			acpi_ec_write(ec, address, *value);
 
-	if (EC_FLAGS_MSI)
+	if (EC_FLAGS_MSI || bits > 8)
 		acpi_ec_burst_disable(ec);
 
 	switch (result) {


