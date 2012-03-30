Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644Ab2C3LPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:15:21 -0400
Received: from vms173021pub.verizon.net ([206.46.173.21]:22202 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760193Ab2C3LPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:15:01 -0400
X-Greylist: delayed 3603 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2012 07:15:01 EDT
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 04/76] ACPICA: Fix regression in FADT revision checks
Date: Fri, 30 Mar 2012 06:13:07 -0400
Message-id: <3e80acd1af40fcd91a200b0416a7616b20c5d647.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

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
---
 drivers/acpi/acpica/tbfadt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index c5d8704..4c9c760 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -363,10 +363,6 @@ static void acpi_tb_convert_fadt(void)
 	u32 address32;
 	u32 i;
 
-	/* Update the local FADT table header length */
-
-	acpi_gbl_FADT.header.length = sizeof(struct acpi_table_fadt);
-
 	/*
 	 * Expand the 32-bit FACS and DSDT addresses to 64-bit as necessary.
 	 * Later code will always use the X 64-bit field. Also, check for an
@@ -408,6 +404,10 @@ static void acpi_tb_convert_fadt(void)
 		acpi_gbl_FADT.boot_flags = 0;
 	}
 
+	/* Update the local FADT table header length */
+
+	acpi_gbl_FADT.header.length = sizeof(struct acpi_table_fadt);
+
 	/*
 	 * Expand the ACPI 1.0 32-bit addresses to the ACPI 2.0 64-bit "X"
 	 * generic address structures as necessary. Later code will always use
-- 
1.7.10.rc2.19.gfae9d

