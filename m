Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab2FTIPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:15:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:26168 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab2FTIPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:15:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="155887549"
From: "Zhang, Xiaoyan" <xiaoyan.zhang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>
Subject: [PATCH V2 1/2] driver: add PPI support in tpm driver
Thread-Topic: [PATCH V2 1/2] driver: add PPI support in tpm driver
Thread-Index: Ac1OvM7Vt2edENGZQ+GTKubavqkVcg==
Date: Wed, 20 Jun 2012 08:15:09 +0000
Message-ID: <1340122384.8068.0.camel@localhost>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.48.101]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5K8FTr8000849

From: Xiaoyan Zhang <xiaoyan.zhang@intel.com>

The Physical Presence Interface enables the OS and the BIOS to cooperate
and provides a simple and straightforward platform user experience for
administering the TPM without sacrificing security.

V2: separate the patch out in a separate source file, add #ifdef CONFIG_ACPI
so it compiles out on ppc, and use standard error instead of ACPI error as
return code of show/store fns.

Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
---
 drivers/char/tpm/Makefile  |    3 +-
 drivers/char/tpm/tpm.c     |   11 +
 drivers/char/tpm/tpm.h     |    1 +
 drivers/char/tpm/tpm_ppi.c |  450 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 464 insertions(+), 1 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_ppi.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index ea3a1e0..fe87366 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -1,7 +1,8 @@
 #
 # Makefile for the kernel tpm device drivers.
 #
-obj-$(CONFIG_TCG_TPM) += tpm.o
+obj-$(CONFIG_TCG_TPM) += tpm_main.o
+tpm_main-y += tpm.o tpm_ppi.o
 ifdef CONFIG_ACPI
 	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
 endif
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ad7c732..d5db4fa 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1361,6 +1361,9 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 	char *devname;
 	struct tpm_chip *chip;
 
+#ifdef CONFIG_ACPI
+	struct kobject *ppi;
+#endif
 	/* Driver specific per-device data */
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
@@ -1416,6 +1419,14 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 		return NULL;
 	}
 
+#ifdef CONFIG_ACPI
+	ppi = kobject_create_and_add("ppi", &dev->kobj);
+	if (sysfs_create_group(ppi, &ppi_attr_grp)) {
+		misc_deregister(&chip->vendor.miscdev);
+		put_device(chip->dev);
+		return NULL;
+	}
+#endif
 	chip->bios_dir = tpm_bios_log_setup(devname);
 
 	/* Make chip available */
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index b1c5280..9f706ad 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -306,6 +306,7 @@ extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 #ifdef CONFIG_ACPI
 extern struct dentry ** tpm_bios_log_setup(char *);
 extern void tpm_bios_log_teardown(struct dentry **);
+extern struct attribute_group ppi_attr_grp;
 #else
 static inline struct dentry ** tpm_bios_log_setup(char *name)
 {
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
new file mode 100644
index 0000000..eaf0592
--- /dev/null
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -0,0 +1,450 @@
+#include <linux/acpi.h>
+#include <acpi/acpi_drivers.h>
+#include "tpm.h"
+
+static const u8 tpm_ppi_uuid[] = {
+	0xA6, 0xFA, 0xDD, 0x3D,
+	0x1B, 0x36,
+	0xB4, 0x4E,
+	0xA4, 0x24,
+	0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53
+};
+static char *tpm_device_name = "TPM";
+
+#define TPM_PPI_REVISION_ID	1
+#define TPM_PPI_FN_VERSION	1
+#define TPM_PPI_FN_SUBREQ	2
+#define TPM_PPI_FN_GETREQ	3
+#define TPM_PPI_FN_GETACT	4
+#define TPM_PPI_FN_GETRSP	5
+#define TPM_PPI_FN_SUBREQ2	7
+#define TPM_PPI_FN_GETOPR	8
+#define PPI_TPM_REQ_MAX		22
+#define PPI_VS_REQ_START	128
+#define PPI_VS_REQ_END		255
+#define PPI_VERSION_LEN		3
+
+static acpi_status ppi_callback(acpi_handle handle, u32 level, void *context,
+				void **return_value)
+{
+	acpi_status status;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	status = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
+	if (strstr(buffer.pointer, context) != NULL) {
+		*return_value = handle;
+		kfree(buffer.pointer);
+		return AE_CTRL_TERMINATE;
+	}
+	return AE_OK;
+}
+
+static inline void ppi_assign_params(union acpi_object params[4],
+				     u64 function_num)
+{
+	params[0].type = ACPI_TYPE_BUFFER;
+	params[0].buffer.length = sizeof(tpm_ppi_uuid);
+	params[0].buffer.pointer = (char *)tpm_ppi_uuid;
+	params[1].type = ACPI_TYPE_INTEGER;
+	params[1].integer.value = TPM_PPI_REVISION_ID;
+	params[2].type = ACPI_TYPE_INTEGER;
+	params[2].integer.value = function_num;
+	params[3].type = ACPI_TYPE_PACKAGE;
+	params[3].package.count = 0;
+	params[3].package.elements = NULL;
+}
+
+ssize_t tpm_show_ppi_version(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object *obj;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					 ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	obj = (union acpi_object *)output.pointer;
+	status = scnprintf(buf, PAGE_SIZE, "%s\n", obj->string.pointer);
+	kfree(output.pointer);
+	return status;
+}
+
+ssize_t tpm_show_ppi_request(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object *ret_obj;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_GETREQ);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_PACKAGE);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	/*
+	 * output.pointer should be of package type, including two integers.
+	 * The first is function return code, 0 means success and 1 means
+	 * error. The second is pending TPM operation requested by the OS, 0
+	 * means none and >0 means operation value.
+	 */
+	ret_obj = ((union acpi_object *)output.pointer)->package.elements;
+	if (ret_obj->type == ACPI_TYPE_INTEGER) {
+		if (ret_obj->integer.value) {
+			status = -EFAULT;
+			goto cleanup;
+		}
+		ret_obj++;
+		if (ret_obj->type == ACPI_TYPE_INTEGER)
+			status = scnprintf(buf, PAGE_SIZE, "%llu\n",
+					   ret_obj->integer.value);
+		else
+			status = -EINVAL;
+	} else {
+		status = -EINVAL;
+	}
+cleanup:
+	kfree(output.pointer);
+	return status;
+}
+
+ssize_t tpm_store_ppi_request(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	char version[PPI_VERSION_LEN + 1];
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object obj;
+	u32 req;
+	u64 ret;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	strncpy(version,
+		((union acpi_object *)output.pointer)->string.pointer,
+		PPI_VERSION_LEN);
+	kfree(output.pointer);
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+	/*
+	 * the function to submit TPM operation request to pre-os environment
+	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
+	 * version 1.1
+	 */
+	if (strcmp(version, "1.1") == -1)
+		params[2].integer.value = TPM_PPI_FN_SUBREQ;
+	else
+		params[2].integer.value = TPM_PPI_FN_SUBREQ2;
+	/*
+	 * PPI spec defines params[3].type as ACPI_TYPE_PACKAGE. Some BIOS
+	 * accept buffer/string/integer type, but some BIOS accept buffer/
+	 * string/package type. For PPI version 1.0 and 1.1, use buffer type
+	 * for compatibility, and use package type since 1.2 according to spec.
+	 */
+	if (strcmp(version, "1.2") == -1) {
+		params[3].type = ACPI_TYPE_BUFFER;
+		params[3].buffer.length = sizeof(req);
+		sscanf(buf, "%d", &req);
+		params[3].buffer.pointer = (char *)&req;
+	} else {
+		params[3].package.count = 1;
+		obj.type = ACPI_TYPE_INTEGER;
+		sscanf(buf, "%llu", &obj.integer.value);
+		params[3].package.elements = &obj;
+	}
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_INTEGER);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	ret = ((union acpi_object *)output.pointer)->integer.value;
+	if (ret == 0)
+		status = (acpi_status)count;
+	else if (ret == 1)
+		status = -EPERM;
+	else
+		status = -EFAULT;
+	kfree(output.pointer);
+	return status;
+}
+
+ssize_t tpm_show_ppi_transition_action(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	char version[PPI_VERSION_LEN + 1];
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	u32 ret;
+	char *info[] = {
+		"None",
+		"Shutdown",
+		"Reboot",
+		"OS Vendor-specific",
+		"Error",
+	};
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	strncpy(version,
+		((union acpi_object *)output.pointer)->string.pointer,
+		PPI_VERSION_LEN);
+	/*
+	 * PPI spec defines params[3].type as empty package, but some platforms
+	 * (e.g. Capella with PPI 1.0) need integer/string/buffer type, so for
+	 * compatibility, define params[3].type as buffer, if PPI version < 1.2
+	 */
+	if (strcmp(version, "1.2") == -1) {
+		params[3].type = ACPI_TYPE_BUFFER;
+		params[3].buffer.length =  0;
+		params[3].buffer.pointer = NULL;
+	}
+	params[2].integer.value = TPM_PPI_FN_GETACT;
+	kfree(output.pointer);
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_INTEGER);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	ret = ((union acpi_object *)output.pointer)->integer.value;
+	if (ret < ARRAY_SIZE(info) - 1)
+		status = scnprintf(buf, PAGE_SIZE, "%d: %s\n", ret, info[ret]);
+	else
+		status = scnprintf(buf, PAGE_SIZE, "%d: %s\n", ret,
+				   info[ARRAY_SIZE(info)-1]);
+	kfree(output.pointer);
+	return status;
+}
+
+ssize_t tpm_show_ppi_response(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object *ret_obj;
+	u64 req;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_GETRSP);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_PACKAGE);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	/*
+	 * parameter output.pointer should be of package type, including
+	 * 3 integers. The first means function return code, the second means
+	 * most recent TPM operation request, and the last means response to
+	 * the most recent TPM operation request. Only if the first is 0, and
+	 * the second integer is not 0, the response makes sense.
+	 */
+	ret_obj = ((union acpi_object *)output.pointer)->package.elements;
+	if (ret_obj->type != ACPI_TYPE_INTEGER) {
+		status = -EINVAL;
+		goto cleanup;
+	}
+	if (ret_obj->integer.value) {
+		status = -EFAULT;
+		goto cleanup;
+	}
+	ret_obj++;
+	if (ret_obj->type != ACPI_TYPE_INTEGER) {
+		status = -EINVAL;
+		goto cleanup;
+	}
+	if (ret_obj->integer.value) {
+		req = ret_obj->integer.value;
+		ret_obj++;
+		if (ret_obj->type != ACPI_TYPE_INTEGER) {
+			status = -EINVAL;
+			goto cleanup;
+		}
+		if (ret_obj->integer.value == 0)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
+					   "0: Success");
+		else if (ret_obj->integer.value == 0xFFFFFFF0)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
+					   "0xFFFFFFF0: User Abort");
+		else if (ret_obj->integer.value == 0xFFFFFFF1)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
+					   "0xFFFFFFF1: BIOS Failure");
+		else if (ret_obj->integer.value >= 1 &&
+			 ret_obj->integer.value <= 0x00000FFF)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %llu: %s\n",
+					   req, ret_obj->integer.value,
+					   "Corresponding TPM error");
+		else
+			status = scnprintf(buf, PAGE_SIZE, "%llu %llu: %s\n",
+					   req, ret_obj->integer.value,
+					   "Error");
+	} else {
+		status = scnprintf(buf, PAGE_SIZE, "%llu: %s\n",
+				   ret_obj->integer.value, "No Recent Request");
+	}
+cleanup:
+	kfree(output.pointer);
+	return status;
+}
+
+static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
+{
+	char *str = buf;
+	char version[PPI_VERSION_LEN];
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object obj;
+	int i;
+	u32 ret;
+	char *info[] = {
+		"Not implemented",
+		"BIOS only",
+		"Blocked for OS by BIOS",
+		"User required",
+		"User not required",
+	};
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					 ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+
+	strncpy(version,
+		((union acpi_object *)output.pointer)->string.pointer,
+		PPI_VERSION_LEN);
+	kfree(output.pointer);
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+	if (strcmp(version, "1.2") == -1)
+		return -EPERM;
+
+	params[2].integer.value = TPM_PPI_FN_GETOPR;
+	params[3].package.count = 1;
+	obj.type = ACPI_TYPE_INTEGER;
+	params[3].package.elements = &obj;
+	for (i = start; i <= end; i++) {
+		obj.integer.value = i;
+		status = acpi_evaluate_object_typed(handle, "_DSM",
+			 &input, &output, ACPI_TYPE_INTEGER);
+		if (ACPI_FAILURE(status))
+			return -ENOMEM;
+
+		ret = ((union acpi_object *)output.pointer)->integer.value;
+		if (ret > 0 && ret < ARRAY_SIZE(info))
+			str += scnprintf(str, PAGE_SIZE, "%d %d: %s\n",
+					 i, ret, info[ret]);
+		kfree(output.pointer);
+		output.length = ACPI_ALLOCATE_BUFFER;
+		output.pointer = NULL;
+	}
+	return str - buf;
+}
+
+ssize_t tpm_show_ppi_tcg_operations(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return show_ppi_operations(buf, 0, PPI_TPM_REQ_MAX);
+}
+
+ssize_t tpm_show_ppi_vs_operations(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	return show_ppi_operations(buf, PPI_VS_REQ_START, PPI_VS_REQ_END);
+}
+
+static DEVICE_ATTR(version, S_IRUGO, tpm_show_ppi_version, NULL);
+static DEVICE_ATTR(request, S_IRUGO | S_IWUSR | S_IWGRP,
+		   tpm_show_ppi_request, tpm_store_ppi_request);
+static DEVICE_ATTR(transition_action, S_IRUGO,
+		   tpm_show_ppi_transition_action, NULL);
+static DEVICE_ATTR(response, S_IRUGO, tpm_show_ppi_response, NULL);
+static DEVICE_ATTR(tcg_operations, S_IRUGO, tpm_show_ppi_tcg_operations, NULL);
+static DEVICE_ATTR(vs_operations, S_IRUGO, tpm_show_ppi_vs_operations, NULL);
+
+static struct attribute *ppi_attrs[] = {
+	&dev_attr_version.attr,
+	&dev_attr_request.attr,
+	&dev_attr_transition_action.attr,
+	&dev_attr_response.attr,
+	&dev_attr_tcg_operations.attr,
+	&dev_attr_vs_operations.attr, NULL,
+};
+struct attribute_group ppi_attr_grp = {
+	.attrs = ppi_attrs
+};
+EXPORT_SYMBOL_GPL(ppi_attr_grp);
+
+MODULE_LICENSE("GPL");
-- 
1.7.6.5

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
