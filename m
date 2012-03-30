Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab2C3KUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:20:21 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52218 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292Ab2C3KSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:18:54 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 62/76] ACPI, APEI, EINJ, new parameter to control trigger action
Date: Fri, 30 Mar 2012 06:14:05 -0400
Message-id: <ee49089dc7d9fc78db51e18f4fba68e88edc49a4.1333101989.git.len.brown@intel.com>
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

From: Chen Gong <gong.chen@linux.intel.com>

Some APEI firmware implementation will access injected address
specified in param1 to trigger the error when injecting memory
error, which means if one SRAR error is injected, the crash
always happens because it is executed in kernel context. This
new parameter can disable trigger action and control is taken
over by the user. In this way, an SRAR error can happen in user
context instead of crashing the system. This function is highly
depended on BIOS implementation so please ensure you know the
BIOS trigger procedure before you enable this switch.

v2:
  notrigger should be created together with param1/param2

Tested-by: Tony Luck <tony.luck@lintel.com>
Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/einj.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 3d3816f..8e17936 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -74,6 +74,8 @@ struct vendor_error_type_extension {
 	u8	reserved[3];
 };
 
+static u32 notrigger;
+
 static u32 vendor_flags;
 static struct debugfs_blob_wrapper vendor_blob;
 static char vendor_dev[64];
@@ -496,9 +498,11 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 	if (rc)
 		return rc;
 	trigger_paddr = apei_exec_ctx_get_output(&ctx);
-	rc = __einj_error_trigger(trigger_paddr, type, param1, param2);
-	if (rc)
-		return rc;
+	if (notrigger == 0) {
+		rc = __einj_error_trigger(trigger_paddr, type, param1, param2);
+		if (rc)
+			return rc;
+	}
 	rc = apei_exec_run_optional(&ctx, ACPI_EINJ_END_OPERATION);
 
 	return rc;
@@ -700,6 +704,11 @@ static int __init einj_init(void)
 					    einj_debug_dir, &error_param2);
 		if (!fentry)
 			goto err_unmap;
+
+		fentry = debugfs_create_x32("notrigger", S_IRUSR | S_IWUSR,
+					    einj_debug_dir, &notrigger);
+		if (!fentry)
+			goto err_unmap;
 	}
 
 	if (vendor_dev[0]) {
-- 
1.7.10.rc2.19.gfae9d

