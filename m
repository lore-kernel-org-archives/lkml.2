Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0ERGgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:36:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:12057 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab0ERGfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:35:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,253,1272870000"; 
   d="scan'208";a="622545494"
From: Huang Ying <ying.huang@intel.com>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org,
       linux-acpi@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH -v5 14/14] ACPI, APEI, EINJ injection parameters support
Date: Tue, 18 May 2010 14:35:24 +0800
Message-Id: <1274164524-6092-15-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274164524-6092-1-git-send-email-ying.huang@intel.com>
References: <1274164524-6092-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware error injection needs parameters, for example, it is
useful to specify memory address and memory address mask for memory
errors.

Some BIOSes allow parameters to be specified via an unpublished
extension. This patch adds support to it. The parameters will be
ignored on machines without necessary BIOS support.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/acpi/apei/einj.txt |   10 +++++
 drivers/acpi/apei/einj.c         |   72 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 77 insertions(+), 5 deletions(-)

--- a/Documentation/acpi/apei/einj.txt
+++ b/Documentation/acpi/apei/einj.txt
@@ -45,5 +45,15 @@ directory apei/einj. The following files
   injection. Before this, please specify all necessary error
   parameters.
 
+- param1
+  This file is used to set the first error parameter value. Effect of
+  parameter depends on error_type specified. For memory error, this is
+  physical memory address.
+
+- param2
+  This file is used to set the second error parameter value. Effect of
+  parameter depends on error_type specified. For memory error, this is
+  physical memory address mask.
+
 For more information about EINJ, please refer to ACPI specification
 version 4.0, section 17.5.
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -7,7 +7,7 @@
  * For more information about EINJ, please refer to ACPI Specification
  * version 4.0, section 17.5.
  *
- * Copyright 2009 Intel Corp.
+ * Copyright 2009-2010 Intel Corp.
  *   Author: Huang Ying <ying.huang@intel.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -42,6 +42,20 @@
 /* Firmware should respond within 1 miliseconds */
 #define FIRMWARE_TIMEOUT	(1 * NSEC_PER_MSEC)
 
+/*
+ * Some BIOSes allow parameters to the SET_ERROR_TYPE entries in the
+ * EINJ table through an unpublished extension. Use with caution as
+ * most will ignore the parameter and make their own choice of address
+ * for error injection.
+ */
+struct einj_parameter {
+	u64 type;
+	u64 reserved1;
+	u64 reserved2;
+	u64 param1;
+	u64 param2;
+};
+
 #define EINJ_OP_BUSY			0x1
 #define EINJ_STATUS_SUCCESS		0x0
 #define EINJ_STATUS_FAIL		0x1
@@ -85,6 +99,8 @@ static struct apei_exec_ins_type einj_in
  */
 static DEFINE_MUTEX(einj_mutex);
 
+static struct einj_parameter *einj_param;
+
 static void einj_exec_ctx_init(struct apei_exec_context *ctx)
 {
 	apei_exec_ctx_init(ctx, einj_ins_type, ARRAY_SIZE(einj_ins_type),
@@ -130,6 +146,26 @@ static int einj_timedout(u64 *t)
 	return 0;
 }
 
+static u64 einj_get_parameter_address(void)
+{
+	int i;
+	u64 paddr = 0;
+	struct acpi_whea_header *entry;
+
+	entry = EINJ_TAB_ENTRY(einj_tab);
+	for (i = 0; i < einj_tab->entries; i++) {
+		if (entry->action == ACPI_EINJ_SET_ERROR_TYPE &&
+		    entry->instruction == ACPI_EINJ_WRITE_REGISTER &&
+		    entry->register_region.space_id ==
+		    ACPI_ADR_SPACE_SYSTEM_MEMORY)
+			memcpy(&paddr, &entry->register_region.address,
+			       sizeof(paddr));
+		entry++;
+	}
+
+	return paddr;
+}
+
 /* do sanity check to trigger table */
 static int einj_check_trigger_header(struct acpi_einj_trigger *trigger_tab)
 {
@@ -233,7 +269,7 @@ out:
 	return rc;
 }
 
-static int __einj_error_inject(u32 type)
+static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 {
 	struct apei_exec_context ctx;
 	u64 val, trigger_paddr, timeout = FIRMWARE_TIMEOUT;
@@ -248,6 +284,10 @@ static int __einj_error_inject(u32 type)
 	rc = apei_exec_run(&ctx, ACPI_EINJ_SET_ERROR_TYPE);
 	if (rc)
 		return rc;
+	if (einj_param) {
+		writeq(param1, &einj_param->param1);
+		writeq(param2, &einj_param->param2);
+	}
 	rc = apei_exec_run(&ctx, ACPI_EINJ_EXECUTE_OPERATION);
 	if (rc)
 		return rc;
@@ -281,18 +321,20 @@ static int __einj_error_inject(u32 type)
 }
 
 /* Inject the specified hardware error */
-static int einj_error_inject(u32 type)
+static int einj_error_inject(u32 type, u64 param1, u64 param2)
 {
 	int rc;
 
 	mutex_lock(&einj_mutex);
-	rc = __einj_error_inject(type);
+	rc = __einj_error_inject(type, param1, param2);
 	mutex_unlock(&einj_mutex);
 
 	return rc;
 }
 
 static u32 error_type;
+static u64 error_param1;
+static u64 error_param2;
 static struct dentry *einj_debug_dir;
 
 static int available_error_type_show(struct seq_file *m, void *v)
@@ -376,7 +418,7 @@ static int error_inject_set(void *data,
 	if (!error_type)
 		return -EINVAL;
 
-	return einj_error_inject(error_type);
+	return einj_error_inject(error_type, error_param1, error_param2);
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(error_inject_fops, NULL,
@@ -399,6 +441,7 @@ static int einj_check_table(struct acpi_
 static int __init einj_init(void)
 {
 	int rc;
+	u64 param_paddr;
 	acpi_status status;
 	struct dentry *fentry;
 	struct apei_exec_context ctx;
@@ -436,6 +479,14 @@ static int __init einj_init(void)
 				     einj_debug_dir, NULL, &error_type_fops);
 	if (!fentry)
 		goto err_cleanup;
+	fentry = debugfs_create_x64("param1", S_IRUSR | S_IWUSR,
+				    einj_debug_dir, &error_param1);
+	if (!fentry)
+		goto err_cleanup;
+	fentry = debugfs_create_x64("param2", S_IRUSR | S_IWUSR,
+				    einj_debug_dir, &error_param2);
+	if (!fentry)
+		goto err_cleanup;
 	fentry = debugfs_create_file("error_inject", S_IWUSR,
 				     einj_debug_dir, NULL, &error_inject_fops);
 	if (!fentry)
@@ -452,11 +503,20 @@ static int __init einj_init(void)
 	rc = apei_exec_pre_map_gars(&ctx);
 	if (rc)
 		goto err_release;
+	param_paddr = einj_get_parameter_address();
+	if (param_paddr) {
+		einj_param = ioremap(param_paddr, sizeof(*einj_param));
+		rc = -ENOMEM;
+		if (!einj_param)
+			goto err_unmap;
+	}
 
 	pr_info(EINJ_PFX "Error INJection is initialized.\n");
 
 	return 0;
 
+err_unmap:
+	apei_exec_post_unmap_gars(&ctx);
 err_release:
 	apei_resources_release(&einj_resources);
 err_fini:
@@ -471,6 +531,8 @@ static void __exit einj_exit(void)
 {
 	struct apei_exec_context ctx;
 
+	if (einj_param)
+		iounmap(einj_param);
 	einj_exec_ctx_init(&ctx);
 	apei_exec_post_unmap_gars(&ctx);
 	apei_resources_release(&einj_resources);
