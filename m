Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab2GYDxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:53:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46154 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab2GYDmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:19 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 10/52] ACPICA: Add FADT error message for GAS BitWidth overflow
Date: Tue, 24 Jul 2012 23:41:06 -0400
Message-Id: <66be71ff477389ff12c9c43dc6ee176cf8e1dd3a.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Error for possible overflow during conversion from 32-bit legacy
register addresses to GAS format. The GAS struct contains a
one-byte BitWidth field, meaning that the maximum length of a
register is 255 bits. ACPICA BZ 953.

https://www.acpica.org/bugzilla/show_bug.cgi?id=953

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/tbfadt.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index 4c9c760..d919f40 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -49,9 +49,10 @@
 ACPI_MODULE_NAME("tbfadt")
 
 /* Local prototypes */
-static ACPI_INLINE void
+static void
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
-			     u8 space_id, u8 byte_width, u64 address);
+			     u8 space_id,
+			     u8 byte_width, u64 address, char *register_name);
 
 static void acpi_tb_convert_fadt(void);
 
@@ -182,10 +183,25 @@ static struct acpi_fadt_pm_info fadt_pm_info_table[] = {
  *
  ******************************************************************************/
 
-static ACPI_INLINE void
+static void
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
-			     u8 space_id, u8 byte_width, u64 address)
+			     u8 space_id,
+			     u8 byte_width, u64 address, char *register_name)
 {
+	u8 bit_width;
+
+	/* Bit width field in the GAS is only one byte long, 255 max */
+
+	bit_width = (u8)(byte_width * 8);
+
+	if (byte_width > 31) {	/* (31*8)=248 */
+		ACPI_ERROR((AE_INFO,
+			    "%s - 32-bit FADT register is too long (%u bytes, %u bits) "
+			    "to convert to GAS struct - 255 bits max, truncating",
+			    register_name, byte_width, (byte_width * 8)));
+
+		bit_width = 255;
+	}
 
 	/*
 	 * The 64-bit Address field is non-aligned in the byte packed
@@ -196,7 +212,7 @@ acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
 	/* All other fields are byte-wide */
 
 	generic_address->space_id = space_id;
-	generic_address->bit_width = (u8)ACPI_MUL_8(byte_width);
+	generic_address->bit_width = bit_width;
 	generic_address->bit_offset = 0;
 	generic_address->access_width = 0;	/* Access width ANY */
 }
@@ -456,7 +472,8 @@ static void acpi_tb_convert_fadt(void)
 								   &acpi_gbl_FADT,
 								   fadt_info_table
 								   [i].length),
-						     (u64) address32);
+						     (u64) address32,
+						     fadt_info_table[i].name);
 		}
 	}
 }
@@ -670,7 +687,8 @@ static void acpi_tb_setup_fadt_registers(void)
 						     source64->address +
 						     (fadt_pm_info_table[i].
 						      register_num *
-						      pm1_register_byte_width));
+						      pm1_register_byte_width),
+						     "PmRegisters");
 		}
 	}
 }
-- 
1.7.12.rc0

