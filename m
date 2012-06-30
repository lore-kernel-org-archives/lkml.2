Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2F3FNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 01:13:49 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:65043 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2F3FNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 01:13:47 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        stable@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 6/8] ACPI, APEI, Avoid too much error reporting in runtime
Date: Sat, 30 Jun 2012 01:07:33 -0400
Message-Id: <34ddeb035d704eafdcdb3cbc781894300136c3c4.1341032550.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.1.104.ge7b44f1
In-Reply-To: <1341032855-27139-1-git-send-email-lenb@kernel.org>
References: <1341032855-27139-1-git-send-email-lenb@kernel.org>
In-Reply-To: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
References: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

This patch fixed the following bug.

https://bugzilla.kernel.org/show_bug.cgi?id=43282

This is caused by a firmware bug checking (checking generic address
register provided by firmware) in runtime.  The checking should be
done in address mapping time instead of runtime to avoid too much
error reporting in runtime.

Reported-by: Pawel Sikora <pluto@agmk.net>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Tested-by: Jean Delvare <khali@linux-fr.org>
Cc: stable@vger.kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/apei-base.c     | 17 +++++++++++++++--
 drivers/acpi/apei/apei-internal.h |  9 +++++++++
 drivers/acpi/apei/ghes.c          |  6 +++---
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 5577762..6686b1e 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -243,7 +243,7 @@ static int pre_map_gar_callback(struct apei_exec_context *ctx,
 	u8 ins = entry->instruction;
 
 	if (ctx->ins_table[ins].flags & APEI_EXEC_INS_ACCESS_REGISTER)
-		return acpi_os_map_generic_address(&entry->register_region);
+		return apei_map_generic_address(&entry->register_region);
 
 	return 0;
 }
@@ -276,7 +276,7 @@ static int post_unmap_gar_callback(struct apei_exec_context *ctx,
 	u8 ins = entry->instruction;
 
 	if (ctx->ins_table[ins].flags & APEI_EXEC_INS_ACCESS_REGISTER)
-		acpi_os_unmap_generic_address(&entry->register_region);
+		apei_unmap_generic_address(&entry->register_region);
 
 	return 0;
 }
@@ -606,6 +606,19 @@ static int apei_check_gar(struct acpi_generic_address *reg, u64 *paddr,
 	return 0;
 }
 
+int apei_map_generic_address(struct acpi_generic_address *reg)
+{
+	int rc;
+	u32 access_bit_width;
+	u64 address;
+
+	rc = apei_check_gar(reg, &address, &access_bit_width);
+	if (rc)
+		return rc;
+	return acpi_os_map_generic_address(reg);
+}
+EXPORT_SYMBOL_GPL(apei_map_generic_address);
+
 /* read GAR in interrupt (including NMI) or process context */
 int apei_read(u64 *val, struct acpi_generic_address *reg)
 {
diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei-internal.h
index cca240a..f220d64 100644
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -7,6 +7,8 @@
 #define APEI_INTERNAL_H
 
 #include <linux/cper.h>
+#include <linux/acpi.h>
+#include <linux/acpi_io.h>
 
 struct apei_exec_context;
 
@@ -68,6 +70,13 @@ static inline int apei_exec_run_optional(struct apei_exec_context *ctx, u8 actio
 /* IP has been set in instruction function */
 #define APEI_EXEC_SET_IP	1
 
+int apei_map_generic_address(struct acpi_generic_address *reg);
+
+static inline void apei_unmap_generic_address(struct acpi_generic_address *reg)
+{
+	acpi_os_unmap_generic_address(reg);
+}
+
 int apei_read(u64 *val, struct acpi_generic_address *reg);
 int apei_write(u64 val, struct acpi_generic_address *reg);
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 9b3cac0..1599566 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -301,7 +301,7 @@ static struct ghes *ghes_new(struct acpi_hest_generic *generic)
 	if (!ghes)
 		return ERR_PTR(-ENOMEM);
 	ghes->generic = generic;
-	rc = acpi_os_map_generic_address(&generic->error_status_address);
+	rc = apei_map_generic_address(&generic->error_status_address);
 	if (rc)
 		goto err_free;
 	error_block_length = generic->error_block_length;
@@ -321,7 +321,7 @@ static struct ghes *ghes_new(struct acpi_hest_generic *generic)
 	return ghes;
 
 err_unmap:
-	acpi_os_unmap_generic_address(&generic->error_status_address);
+	apei_unmap_generic_address(&generic->error_status_address);
 err_free:
 	kfree(ghes);
 	return ERR_PTR(rc);
@@ -330,7 +330,7 @@ err_free:
 static void ghes_fini(struct ghes *ghes)
 {
 	kfree(ghes->estatus);
-	acpi_os_unmap_generic_address(&ghes->generic->error_status_address);
+	apei_unmap_generic_address(&ghes->generic->error_status_address);
 }
 
 enum {
-- 
1.7.11.1.104.ge7b44f1

