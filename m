Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab2DCCXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:23:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21740 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2DCCUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:20:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 09/14] ACPI: Add acpi_run_dsm()
Date: Mon,  2 Apr 2012 19:19:36 -0700
Message-Id: <1333419581-7836-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
References: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F7A5E4E.0008,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will need to use that get dmar entries for hotplug

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/bus.c   |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h |   10 ++++++
 2 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index e0960c7..9025dbb 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -520,6 +520,83 @@ out_kfree:
 }
 EXPORT_SYMBOL(acpi_run_osc);
 
+static void acpi_print_dsm_error(acpi_handle handle,
+	struct acpi_dsm_context *context, char *error)
+{
+	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER};
+
+	if (ACPI_FAILURE(acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer)))
+		printk(KERN_DEBUG "%s for idx %x\n", error, context->func_idx);
+	else {
+		printk(KERN_DEBUG "%s:%s for idx %x\n",
+			(char *)buffer.pointer, error, context->func_idx);
+		kfree(buffer.pointer);
+	}
+}
+
+acpi_status acpi_run_dsm(acpi_handle handle, struct acpi_dsm_context *context)
+{
+	acpi_status status;
+	struct acpi_object_list input;
+	union acpi_object in_params[4];
+	union acpi_object *out_obj;
+	u8 uuid[16];
+	struct acpi_buffer output = {ACPI_ALLOCATE_BUFFER, NULL};
+
+	if (!context)
+		return AE_ERROR;
+	if (ACPI_FAILURE(acpi_str_to_uuid(context->uuid_str, uuid)))
+		return AE_ERROR;
+	context->ret.length = ACPI_ALLOCATE_BUFFER;
+	context->ret.pointer = NULL;
+
+	/* Setting up input parameters */
+	input.count = 4;
+	input.pointer = in_params;
+	in_params[0].type		= ACPI_TYPE_BUFFER;
+	in_params[0].buffer.length	= 16;
+	in_params[0].buffer.pointer	= uuid;
+	in_params[1].type		= ACPI_TYPE_INTEGER;
+	in_params[1].integer.value	= context->rev;
+	in_params[2].type		= ACPI_TYPE_INTEGER;
+	in_params[2].integer.value	= context->func_idx;
+	in_params[3].type		= ACPI_TYPE_PACKAGE;
+	in_params[3].package.count	= context->func_argc;
+	in_params[3].package.elements	= context->func_argv;
+
+	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	if (!output.length)
+		return AE_NULL_OBJECT;
+
+	out_obj = output.pointer;
+	if (out_obj->type != ACPI_TYPE_BUFFER) {
+		acpi_print_dsm_error(handle, context,
+			"_DSM evaluation returned wrong type");
+		status = AE_TYPE;
+		goto out_kfree;
+	}
+
+	context->ret.length = out_obj->buffer.length;
+	context->ret.pointer = kmalloc(context->ret.length, GFP_KERNEL);
+	if (!context->ret.pointer) {
+		status =  AE_NO_MEMORY;
+		goto out_kfree;
+	}
+	memcpy(context->ret.pointer, out_obj->buffer.pointer,
+		context->ret.length);
+	status =  AE_OK;
+
+out_kfree:
+	kfree(output.pointer);
+	if (status != AE_OK)
+		context->ret.pointer = NULL;
+	return status;
+}
+EXPORT_SYMBOL(acpi_run_dsm);
+
 bool osc_sb_apei_support_acked;
 static u8 sb_uuid_str[] = "0811B06E-4A27-44F9-8D60-3CBBC22E7B48";
 static void acpi_bus_osc_support(void)
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index d78baa7..14ad7d7 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -273,6 +273,16 @@ struct acpi_osc_context {
 
 acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 
+struct acpi_dsm_context {
+	char *uuid_str; /* uuid string */
+	int rev;
+	int func_idx;	/* function index */
+	int func_argc;
+	union acpi_object *func_argv;
+	struct acpi_buffer ret; /* free by caller if success */
+};
+acpi_status acpi_run_dsm(acpi_handle handle, struct acpi_dsm_context *context);
+
 /* platform-wide _OSC bits */
 #define OSC_SB_PAD_SUPPORT		1
 #define OSC_SB_PPC_OST_SUPPORT		2
-- 
1.7.7

