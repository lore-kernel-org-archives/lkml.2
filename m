Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab1GTIKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 04:10:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:38903 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1GTIKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 04:10:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,233,1309762800"; 
   d="scan'208";a="27954195"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [BUGFIX] ACPI, APEI, EINJ Param support is disabled by default
Date: Wed, 20 Jul 2011 16:09:29 +0800
Message-Id: <1311149369-20624-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EINJ parameter support is only usable for some specific BIOS.
Originally, it is expected to have no harm for BIOS does not support
it.  But now, we found it will cause issue (memory overwriting) for
some BIOS.  So param support is disabled by default and only enabled
when newly added module parameter named "param_extension" is
explicitly specified.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Acked-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/acpi/apei/einj.txt |   11 +++++++++--
 drivers/acpi/apei/einj.c         |   39 ++++++++++++++++++++++++---------------
 2 files changed, 33 insertions(+), 17 deletions(-)

--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -46,7 +46,8 @@
  * Some BIOSes allow parameters to the SET_ERROR_TYPE entries in the
  * EINJ table through an unpublished extension. Use with caution as
  * most will ignore the parameter and make their own choice of address
- * for error injection.
+ * for error injection.  This extension is used only if
+ * param_extension module parameter is specified.
  */
 struct einj_parameter {
 	u64 type;
@@ -65,6 +66,9 @@ struct einj_parameter {
 	((struct acpi_whea_header *)((char *)(tab) +			\
 				    sizeof(struct acpi_table_einj)))
 
+static bool param_extension;
+module_param(param_extension, bool, 0);
+
 static struct acpi_table_einj *einj_tab;
 
 static struct apei_resources einj_resources;
@@ -489,14 +493,6 @@ static int __init einj_init(void)
 				     einj_debug_dir, NULL, &error_type_fops);
 	if (!fentry)
 		goto err_cleanup;
-	fentry = debugfs_create_x64("param1", S_IRUSR | S_IWUSR,
-				    einj_debug_dir, &error_param1);
-	if (!fentry)
-		goto err_cleanup;
-	fentry = debugfs_create_x64("param2", S_IRUSR | S_IWUSR,
-				    einj_debug_dir, &error_param2);
-	if (!fentry)
-		goto err_cleanup;
 	fentry = debugfs_create_file("error_inject", S_IWUSR,
 				     einj_debug_dir, NULL, &error_inject_fops);
 	if (!fentry)
@@ -513,12 +509,23 @@ static int __init einj_init(void)
 	rc = apei_exec_pre_map_gars(&ctx);
 	if (rc)
 		goto err_release;
-	param_paddr = einj_get_parameter_address();
-	if (param_paddr) {
-		einj_param = ioremap(param_paddr, sizeof(*einj_param));
-		rc = -ENOMEM;
-		if (!einj_param)
-			goto err_unmap;
+	if (param_extension) {
+		param_paddr = einj_get_parameter_address();
+		if (param_paddr) {
+			einj_param = ioremap(param_paddr, sizeof(*einj_param));
+			rc = -ENOMEM;
+			if (!einj_param)
+				goto err_unmap;
+			fentry = debugfs_create_x64("param1", S_IRUSR | S_IWUSR,
+						    einj_debug_dir, &error_param1);
+			if (!fentry)
+				goto err_unmap;
+			fentry = debugfs_create_x64("param2", S_IRUSR | S_IWUSR,
+						    einj_debug_dir, &error_param2);
+			if (!fentry)
+				goto err_unmap;
+		} else
+			pr_warn(EINJ_PFX "Parameter extension is not supported.\n");
 	}
 
 	pr_info(EINJ_PFX "Error INJection is initialized.\n");
@@ -526,6 +533,8 @@ static int __init einj_init(void)
 	return 0;
 
 err_unmap:
+	if (einj_param)
+		iounmap(einj_param);
 	apei_exec_post_unmap_gars(&ctx);
 err_release:
 	apei_resources_release(&einj_resources);
--- a/Documentation/acpi/apei/einj.txt
+++ b/Documentation/acpi/apei/einj.txt
@@ -48,12 +48,19 @@ directory apei/einj. The following files
 - param1
   This file is used to set the first error parameter value. Effect of
   parameter depends on error_type specified. For memory error, this is
-  physical memory address.
+  physical memory address.  Only available if param_extension module
+  parameter is specified.
 
 - param2
   This file is used to set the second error parameter value. Effect of
   parameter depends on error_type specified. For memory error, this is
-  physical memory address mask.
+  physical memory address mask.  Only available if param_extension
+  module parameter is specified.
+
+Injecting parameter support is a BIOS version specific extension, that
+is, it only works on some BIOS version.  If you want to use it, please
+make sure your BIOS version has the proper support and specify
+"param_extension=y" in module parameter.
 
 For more information about EINJ, please refer to ACPI specification
 version 4.0, section 17.5.
