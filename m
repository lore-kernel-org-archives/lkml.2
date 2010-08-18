Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab0HRIhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:37:04 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50649 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0HRIhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:37:00 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/8] ideapad: add ACPI helpers
Date: Wed, 18 Aug 2010 16:36:53 +0800
Message-Id: <1282120613-11365-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two methods under VPC2004 which is used to access VDAT/VCMD of EC
register. Add helpers for read and write these two registers.

And add read_method_int for reading the return value from ACPI methods which
requires no parameter.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad_acpi.c |  111 +++++++++++++++++++++++++++++++++++
 1 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/ideapad_acpi.c b/drivers/platform/x86/ideapad_acpi.c
index 7984963..af630e2 100644
--- a/drivers/platform/x86/ideapad_acpi.c
+++ b/drivers/platform/x86/ideapad_acpi.c
@@ -49,6 +49,117 @@ static struct {
 	{ "ideapad_killsw",	RFKILL_TYPE_WLAN }
 };
 
+/*
+ * ACPI Helpers
+ */
+#define IDEAPAD_EC_TIMEOUT (25) /* in ms */
+
+static int read_method_int(acpi_handle handle, const char *method, int *val)
+{
+	acpi_status status;
+	unsigned long long result;
+
+	status = acpi_evaluate_integer(handle, (char *)method, NULL, &result);
+	if (ACPI_FAILURE(status)) {
+		*val = -1;
+		return -1;
+	} else {
+		*val = result;
+		return 0;
+	}
+}
+
+static int method_vpcr(acpi_handle handle, int cmd, int *ret)
+{
+	acpi_status status;
+	unsigned long long result;
+	struct acpi_object_list params;
+	union acpi_object in_obj;
+
+	params.count = 1;
+	params.pointer = &in_obj;
+	in_obj.type = ACPI_TYPE_INTEGER;
+	in_obj.integer.value = cmd;
+
+	status = acpi_evaluate_integer(handle, "VPCR", &params, &result);
+
+	if (ACPI_FAILURE(status)) {
+		*ret = -1;
+		return -1;
+	} else {
+		*ret = result;
+		return 0;
+	}
+}
+
+static int method_vpcw(acpi_handle handle, int cmd, int data)
+{
+	struct acpi_object_list params;
+	union acpi_object in_obj[2];
+	acpi_status status;
+
+	params.count = 2;
+	params.pointer = in_obj;
+	in_obj[0].type = ACPI_TYPE_INTEGER;
+	in_obj[0].integer.value = cmd;
+	in_obj[1].type = ACPI_TYPE_INTEGER;
+	in_obj[1].integer.value = data;
+
+	status = acpi_evaluate_object(handle, "VPCW", &params, NULL);
+	if (status != AE_OK)
+		return -1;
+	return 0;
+}
+
+static int read_ec_data(acpi_handle handle, int cmd, unsigned long *data)
+{
+	int val;
+	unsigned long int start_jiffies, now_jiffies;
+
+	if (method_vpcw(handle, 1, cmd))
+		return -1;
+
+	for (start_jiffies = jiffies;; ) {
+		if (method_vpcr(handle, 1, &val))
+			return -1;
+		if (val == 0) {
+			if (method_vpcr(handle, 0, &val))
+				return -1;
+			*data = val;
+			return 0;
+		}
+		now_jiffies = jiffies;
+		if ((now_jiffies-start_jiffies) > (HZ)/IDEAPAD_EC_TIMEOUT+1) {
+			pr_err("timeout in read_ec_cmd\n");
+			return -1;
+		}
+	}
+}
+
+static int write_ec_cmd(acpi_handle handle, int cmd, unsigned long data)
+{
+	int val;
+	unsigned long int start_jiffies, now_jiffies;
+
+	if (method_vpcw(handle, 0, data))
+		return -1;
+	if (method_vpcw(handle, 1, cmd))
+		return -1;
+
+	for (start_jiffies = jiffies;; ) {
+		if (method_vpcr(handle, 1, &val))
+			return -1;
+		if (val == 0)
+			return 0;
+		now_jiffies = jiffies;
+		if ((now_jiffies-start_jiffies) > (HZ)/IDEAPAD_EC_TIMEOUT+1) {
+			pr_err("timeout in write_ec_cmd\n");
+			return -1;
+		}
+	}
+}
+/* the above is ACPI helpers */
+
 static int ideapad_dev_exists(int device)
 {
 	acpi_status status;
-- 
1.7.0.4

