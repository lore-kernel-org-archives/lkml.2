Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965572Ab2DKXiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:38:10 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53150 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965547Ab2DKX2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:28:06 -0400
Message-Id: <20120411231309.010915683@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Julian Anastasov <ja@ssi.bg>,
        Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Josh Boyer <jwboyer@gmail.com>
Subject: [ 10/42] ACPICA: Fix regression in FADT revision checks
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

commit 3e80acd1af40fcd91a200b0416a7616b20c5d647 upstream.

	commit 64b3db22c04586997ab4be46dd5a5b99f8a2d390 (2.6.39),
"Remove use of unreliable FADT revision field" causes regression
for old P4 systems because now cst_control and other fields are
not reset to 0.

	The effect is that acpi_processor_power_init will notice
cst_control != 0 and a write to CST_CNT register is performed
that should not happen. As result, the system oopses after the
"No _CST, giving up" message, sometimes in acpi_ns_internalize_name,
sometimes in acpi_ns_get_type, usually at random places. May be
during migration to CPU 1 in acpi_processor_get_throttling.

	Every one of these settings help to avoid this problem:
 - acpi=off
 - processor.nocst=1
 - maxcpus=1

	The fix is to update acpi_gbl_FADT.header.length after
the original value is used to check for old revisions.

https://bugzilla.kernel.org/show_bug.cgi?id=42700
https://bugzilla.redhat.com/show_bug.cgi?id=727865

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/tbfadt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -350,10 +350,6 @@ static void acpi_tb_convert_fadt(void)
 	u32 address32;
 	u32 i;
 
-	/* Update the local FADT table header length */
-
-	acpi_gbl_FADT.header.length = sizeof(struct acpi_table_fadt);
-
 	/*
 	 * Expand the 32-bit FACS and DSDT addresses to 64-bit as necessary.
 	 * Later code will always use the X 64-bit field. Also, check for an
@@ -395,6 +391,10 @@ static void acpi_tb_convert_fadt(void)
 		acpi_gbl_FADT.boot_flags = 0;
 	}
 
+	/* Update the local FADT table header length */
+
+	acpi_gbl_FADT.header.length = sizeof(struct acpi_table_fadt);
+
 	/*
 	 * Expand the ACPI 1.0 32-bit addresses to the ACPI 2.0 64-bit "X"
 	 * generic address structures as necessary. Later code will always use


