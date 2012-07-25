Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab2GYDnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:43:20 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46154 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab2GYDnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:43:10 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 37/52] ACPICA: Split exception code utilities to a new file, utexcep.c
Date: Tue, 24 Jul 2012 23:41:33 -0400
Message-Id: <bc7db1453902ec53cdbcb6a9807db0c527be990f.1343187617.git.len.brown@intel.com>
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

Simplifies sharing of these functions.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/Makefile   |   1 +
 drivers/acpi/acpica/acglobal.h |   8 ---
 drivers/acpi/acpica/utdecode.c |  35 ----------
 drivers/acpi/acpica/utexcep.c  | 153 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/utmisc.c   |  69 -------------------
 include/acpi/acexcep.h         |   5 +-
 6 files changed, 157 insertions(+), 114 deletions(-)
 create mode 100644 drivers/acpi/acpica/utexcep.c

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index 793b8cc..fa9a7d5 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -140,6 +140,7 @@ acpi-y +=		\
 	utaddress.o	\
 	utalloc.o	\
 	utcopy.o	\
+	utexcep.o	\
 	utdebug.o	\
 	utdecode.o	\
 	utdelete.o	\
diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index 92fab6a..ce79100 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -326,14 +326,6 @@ extern const char *acpi_gbl_region_types[ACPI_NUM_PREDEFINED_REGIONS];
 
 #endif
 
-/* Exception codes */
-
-extern char const *acpi_gbl_exception_names_env[];
-extern char const *acpi_gbl_exception_names_pgm[];
-extern char const *acpi_gbl_exception_names_tbl[];
-extern char const *acpi_gbl_exception_names_aml[];
-extern char const *acpi_gbl_exception_names_ctrl[];
-
 /*****************************************************************************
  *
  * Namespace globals
diff --git a/drivers/acpi/acpica/utdecode.c b/drivers/acpi/acpica/utdecode.c
index 6848499..c8c130c 100644
--- a/drivers/acpi/acpica/utdecode.c
+++ b/drivers/acpi/acpica/utdecode.c
@@ -49,41 +49,6 @@
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utdecode")
 
-/*******************************************************************************
- *
- * FUNCTION:    acpi_format_exception
- *
- * PARAMETERS:  Status       - The acpi_status code to be formatted
- *
- * RETURN:      A string containing the exception text. A valid pointer is
- *              always returned.
- *
- * DESCRIPTION: This function translates an ACPI exception into an ASCII string
- *              It is here instead of utxface.c so it is always present.
- *
- ******************************************************************************/
-const char *acpi_format_exception(acpi_status status)
-{
-	const char *exception = NULL;
-
-	ACPI_FUNCTION_ENTRY();
-
-	exception = acpi_ut_validate_exception(status);
-	if (!exception) {
-
-		/* Exception code was not recognized */
-
-		ACPI_ERROR((AE_INFO,
-			    "Unknown exception code: 0x%8.8X", status));
-
-		exception = "UNKNOWN_STATUS_CODE";
-	}
-
-	return (ACPI_CAST_PTR(const char, exception));
-}
-
-ACPI_EXPORT_SYMBOL(acpi_format_exception)
-
 /*
  * Properties of the ACPI Object Types, both internal and external.
  * The table is indexed by values of acpi_object_type
diff --git a/drivers/acpi/acpica/utexcep.c b/drivers/acpi/acpica/utexcep.c
new file mode 100644
index 0000000..23b9894
--- /dev/null
+++ b/drivers/acpi/acpica/utexcep.c
@@ -0,0 +1,153 @@
+/*******************************************************************************
+ *
+ * Module Name: utexcep - Exception code support
+ *
+ ******************************************************************************/
+
+/*
+ * Copyright (C) 2000 - 2012, Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#define ACPI_DEFINE_EXCEPTION_TABLE
+#include <linux/export.h>
+#include <acpi/acpi.h>
+#include "accommon.h"
+
+#define _COMPONENT          ACPI_UTILITIES
+ACPI_MODULE_NAME("utexcep")
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_format_exception
+ *
+ * PARAMETERS:  status              - The acpi_status code to be formatted
+ *
+ * RETURN:      A string containing the exception text. A valid pointer is
+ *              always returned.
+ *
+ * DESCRIPTION: This function translates an ACPI exception into an ASCII
+ *              string. Returns "unknown status" string for invalid codes.
+ *
+ ******************************************************************************/
+const char *acpi_format_exception(acpi_status status)
+{
+	const char *exception = NULL;
+
+	ACPI_FUNCTION_ENTRY();
+
+	exception = acpi_ut_validate_exception(status);
+	if (!exception) {
+
+		/* Exception code was not recognized */
+
+		ACPI_ERROR((AE_INFO,
+			    "Unknown exception code: 0x%8.8X", status));
+
+		exception = "UNKNOWN_STATUS_CODE";
+	}
+
+	return (ACPI_CAST_PTR(const char, exception));
+}
+
+ACPI_EXPORT_SYMBOL(acpi_format_exception)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ut_validate_exception
+ *
+ * PARAMETERS:  status              - The acpi_status code to be formatted
+ *
+ * RETURN:      A string containing the exception text. NULL if exception is
+ *              not valid.
+ *
+ * DESCRIPTION: This function validates and translates an ACPI exception into
+ *              an ASCII string.
+ *
+ ******************************************************************************/
+const char *acpi_ut_validate_exception(acpi_status status)
+{
+	u32 sub_status;
+	const char *exception = NULL;
+
+	ACPI_FUNCTION_ENTRY();
+
+	/*
+	 * Status is composed of two parts, a "type" and an actual code
+	 */
+	sub_status = (status & ~AE_CODE_MASK);
+
+	switch (status & AE_CODE_MASK) {
+	case AE_CODE_ENVIRONMENTAL:
+
+		if (sub_status <= AE_CODE_ENV_MAX) {
+			exception = acpi_gbl_exception_names_env[sub_status];
+		}
+		break;
+
+	case AE_CODE_PROGRAMMER:
+
+		if (sub_status <= AE_CODE_PGM_MAX) {
+			exception = acpi_gbl_exception_names_pgm[sub_status];
+		}
+		break;
+
+	case AE_CODE_ACPI_TABLES:
+
+		if (sub_status <= AE_CODE_TBL_MAX) {
+			exception = acpi_gbl_exception_names_tbl[sub_status];
+		}
+		break;
+
+	case AE_CODE_AML:
+
+		if (sub_status <= AE_CODE_AML_MAX) {
+			exception = acpi_gbl_exception_names_aml[sub_status];
+		}
+		break;
+
+	case AE_CODE_CONTROL:
+
+		if (sub_status <= AE_CODE_CTRL_MAX) {
+			exception = acpi_gbl_exception_names_ctrl[sub_status];
+		}
+		break;
+
+	default:
+		break;
+	}
+
+	return (ACPI_CAST_PTR(const char, exception));
+}
diff --git a/drivers/acpi/acpica/utmisc.c b/drivers/acpi/acpica/utmisc.c
index 577a44e..e30c060 100644
--- a/drivers/acpi/acpica/utmisc.c
+++ b/drivers/acpi/acpica/utmisc.c
@@ -82,75 +82,6 @@ void ut_convert_backslashes(char *pathname)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_ut_validate_exception
- *
- * PARAMETERS:  Status       - The acpi_status code to be formatted
- *
- * RETURN:      A string containing the exception text. NULL if exception is
- *              not valid.
- *
- * DESCRIPTION: This function validates and translates an ACPI exception into
- *              an ASCII string.
- *
- ******************************************************************************/
-
-const char *acpi_ut_validate_exception(acpi_status status)
-{
-	u32 sub_status;
-	const char *exception = NULL;
-
-	ACPI_FUNCTION_ENTRY();
-
-	/*
-	 * Status is composed of two parts, a "type" and an actual code
-	 */
-	sub_status = (status & ~AE_CODE_MASK);
-
-	switch (status & AE_CODE_MASK) {
-	case AE_CODE_ENVIRONMENTAL:
-
-		if (sub_status <= AE_CODE_ENV_MAX) {
-			exception = acpi_gbl_exception_names_env[sub_status];
-		}
-		break;
-
-	case AE_CODE_PROGRAMMER:
-
-		if (sub_status <= AE_CODE_PGM_MAX) {
-			exception = acpi_gbl_exception_names_pgm[sub_status];
-		}
-		break;
-
-	case AE_CODE_ACPI_TABLES:
-
-		if (sub_status <= AE_CODE_TBL_MAX) {
-			exception = acpi_gbl_exception_names_tbl[sub_status];
-		}
-		break;
-
-	case AE_CODE_AML:
-
-		if (sub_status <= AE_CODE_AML_MAX) {
-			exception = acpi_gbl_exception_names_aml[sub_status];
-		}
-		break;
-
-	case AE_CODE_CONTROL:
-
-		if (sub_status <= AE_CODE_CTRL_MAX) {
-			exception = acpi_gbl_exception_names_ctrl[sub_status];
-		}
-		break;
-
-	default:
-		break;
-	}
-
-	return (ACPI_CAST_PTR(const char, exception));
-}
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_ut_is_pci_root_bridge
  *
  * PARAMETERS:  Id              - The HID/CID in string format
diff --git a/include/acpi/acexcep.h b/include/acpi/acexcep.h
index 92d6e1d..0b5dcb6 100644
--- a/include/acpi/acexcep.h
+++ b/include/acpi/acexcep.h
@@ -52,6 +52,7 @@
 #define AE_CODE_ACPI_TABLES             0x2000
 #define AE_CODE_AML                     0x3000
 #define AE_CODE_CONTROL                 0x4000
+#define AE_CODE_MAX                     0x4000
 #define AE_CODE_MASK                    0xF000
 
 #define ACPI_SUCCESS(a)                 (!(a))
@@ -181,7 +182,7 @@
 
 /* Exception strings for acpi_format_exception */
 
-#ifdef DEFINE_ACPI_GLOBALS
+#ifdef ACPI_DEFINE_EXCEPTION_TABLE
 
 /*
  * String versions of the exception codes above
@@ -295,6 +296,6 @@ char const *acpi_gbl_exception_names_ctrl[] = {
 	"AE_CTRL_PARSE_PENDING"
 };
 
-#endif				/* ACPI GLOBALS */
+#endif				/* EXCEPTION_TABLE */
 
 #endif				/* __ACEXCEP_H__ */
-- 
1.7.12.rc0

