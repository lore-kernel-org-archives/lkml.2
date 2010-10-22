Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0JVWXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 18:23:53 -0400
Received: from mail.perches.com ([173.55.12.10]:3515 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab0JVWXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 18:23:51 -0400
Subject: [PATCH] drivers/acpi: Add and use pr_fmt(fmt)
From: Joe Perches <joe@perches.com>
To: Len Brown <lenb@kernel.org>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1010220131320.7016@localhost.localdomain>
References: <1287713982.16920.39.camel@Joe-Laptop>
	 <alpine.LFD.2.00.1010220131320.7016@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 15:23:49 -0700
Message-ID: <1287786229.28393.29.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use #define pr_fmt(fmt) with appropriate prefix.
Remove use PREFIX/<foo>_PFX from pr_<level>.
Remove #defines of PREFIX and <foo>_PFX.
Coalesce some formats.

This changes the output of messages that use FW_WARN/FW_BUG
so that the prefix is first then FW_<LEVEL>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/acpi/apei/apei-base.c |   37 ++++++++++++------------
 drivers/acpi/apei/einj.c      |   26 ++++++++---------
 drivers/acpi/apei/erst.c      |   42 ++++++++++++---------------
 drivers/acpi/apei/ghes.c      |   50 ++++++++++++++++----------------
 drivers/acpi/apei/hest.c      |   22 +++++++-------
 drivers/acpi/ec.c             |   62 ++++++++++++++++++++---------------------
 6 files changed, 115 insertions(+), 124 deletions(-)

diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 4a904a4..d32b05a 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -30,6 +30,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) "apei: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -44,8 +46,6 @@
 
 #include "apei-internal.h"
 
-#define APEI_PFX "APEI: "
-
 /*
  * APEI ERST (Error Record Serialization Table) and EINJ (Error
  * INJection) interpreter framework.
@@ -181,9 +181,9 @@ rewind:
 		if (ip == ctx->ip) {
 			if (entry->instruction >= ctx->instructions ||
 			    !ctx->ins_table[entry->instruction].run) {
-				pr_warning(FW_WARN APEI_PFX
+				pr_warn(FW_WARN
 			"Invalid action table, unknown instruction type: %d\n",
-					   entry->instruction);
+					entry->instruction);
 				return -EINVAL;
 			}
 			run = ctx->ins_table[entry->instruction].run;
@@ -222,9 +222,9 @@ static int apei_exec_for_each_entry(struct apei_exec_context *ctx,
 		if (end)
 			*end = i;
 		if (ins >= ctx->instructions || !ins_table[ins].run) {
-			pr_warning(FW_WARN APEI_PFX
+			pr_warn(FW_WARN
 			"Invalid action table, unknown instruction type: %d\n",
-				   ins);
+				ins);
 			return -EINVAL;
 		}
 		rc = func(ctx, entry, data);
@@ -458,7 +458,7 @@ int apei_resources_request(struct apei_resources *resources,
 		r = request_mem_region(res->start, res->end - res->start,
 				       desc);
 		if (!r) {
-			pr_err(APEI_PFX
+			pr_err(
 		"Can not request iomem region <%016llx-%016llx> for GARs.\n",
 			       (unsigned long long)res->start,
 			       (unsigned long long)res->end);
@@ -470,7 +470,7 @@ int apei_resources_request(struct apei_resources *resources,
 	list_for_each_entry(res, &resources->ioport, list) {
 		r = request_region(res->start, res->end - res->start, desc);
 		if (!r) {
-			pr_err(APEI_PFX
+			pr_err(
 		"Can not request ioport region <%016llx-%016llx> for GARs.\n",
 			       (unsigned long long)res->start,
 			       (unsigned long long)res->end);
@@ -481,7 +481,7 @@ int apei_resources_request(struct apei_resources *resources,
 
 	rc = apei_resources_merge(&apei_resources_all, resources);
 	if (rc) {
-		pr_err(APEI_PFX "Fail to merge resources!\n");
+		pr_err("Fail to merge resources!\n");
 		goto err_unmap_ioport;
 	}
 
@@ -515,7 +515,7 @@ void apei_resources_release(struct apei_resources *resources)
 
 	rc = apei_resources_sub(&apei_resources_all, resources);
 	if (rc)
-		pr_err(APEI_PFX "Fail to sub resources!\n");
+		pr_err("Fail to sub resources!\n");
 }
 EXPORT_SYMBOL_GPL(apei_resources_release);
 
@@ -528,24 +528,23 @@ static int apei_check_gar(struct acpi_generic_address *reg, u64 *paddr)
 	/* Handle possible alignment issues */
 	memcpy(paddr, &reg->address, sizeof(*paddr));
 	if (!*paddr) {
-		pr_warning(FW_BUG APEI_PFX
-			   "Invalid physical address in GAR [0x%llx/%u/%u]\n",
-			   *paddr, width, space_id);
+		pr_warn(FW_BUG
+			"Invalid physical address in GAR [0x%llx/%u/%u]\n",
+			*paddr, width, space_id);
 		return -EINVAL;
 	}
 
 	if ((width != 8) && (width != 16) && (width != 32) && (width != 64)) {
-		pr_warning(FW_BUG APEI_PFX
-			   "Invalid bit width in GAR [0x%llx/%u/%u]\n",
-			   *paddr, width, space_id);
+		pr_warn(FW_BUG "Invalid bit width in GAR [0x%llx/%u/%u]\n",
+			*paddr, width, space_id);
 		return -EINVAL;
 	}
 
 	if (space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY &&
 	    space_id != ACPI_ADR_SPACE_SYSTEM_IO) {
-		pr_warning(FW_BUG APEI_PFX
-			   "Invalid address space type in GAR [0x%llx/%u/%u]\n",
-			   *paddr, width, space_id);
+		pr_warn(FW_BUG
+			"Invalid address space type in GAR [0x%llx/%u/%u]\n",
+			*paddr, width, space_id);
 		return -EINVAL;
 	}
 
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index cf29df6..5b60e6d 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -24,6 +24,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -36,8 +38,6 @@
 
 #include "apei-internal.h"
 
-#define EINJ_PFX "EINJ: "
-
 #define SPIN_UNIT		100			/* 100ns */
 /* Firmware should respond within 1 miliseconds */
 #define FIRMWARE_TIMEOUT	(1 * NSEC_PER_MSEC)
@@ -136,8 +136,7 @@ static int einj_get_available_error_type(u32 *type)
 static int einj_timedout(u64 *t)
 {
 	if ((s64)*t < SPIN_UNIT) {
-		pr_warning(FW_WARN EINJ_PFX
-			   "Firmware does not respond in time\n");
+		pr_warn(FW_WARN "Firmware does not respond in time\n");
 		return 1;
 	}
 	*t -= SPIN_UNIT;
@@ -196,7 +195,7 @@ static int __einj_error_trigger(u64 trigger_paddr)
 	r = request_mem_region(trigger_paddr, sizeof(*trigger_tab),
 			       "APEI EINJ Trigger Table");
 	if (!r) {
-		pr_err(EINJ_PFX
+		pr_err(
 	"Can not request iomem region <%016llx-%016llx> for Trigger table.\n",
 		       (unsigned long long)trigger_paddr,
 		       (unsigned long long)trigger_paddr+sizeof(*trigger_tab));
@@ -204,13 +203,12 @@ static int __einj_error_trigger(u64 trigger_paddr)
 	}
 	trigger_tab = ioremap_cache(trigger_paddr, sizeof(*trigger_tab));
 	if (!trigger_tab) {
-		pr_err(EINJ_PFX "Failed to map trigger table!\n");
+		pr_err("Failed to map trigger table!\n");
 		goto out_rel_header;
 	}
 	rc = einj_check_trigger_header(trigger_tab);
 	if (rc) {
-		pr_warning(FW_BUG EINJ_PFX
-			   "The trigger error action table is invalid\n");
+		pr_warn(FW_BUG "The trigger error action table is invalid\n");
 		goto out_rel_header;
 	}
 	rc = -EIO;
@@ -219,7 +217,7 @@ static int __einj_error_trigger(u64 trigger_paddr)
 			       table_size - sizeof(*trigger_tab),
 			       "APEI EINJ Trigger Table");
 	if (!r) {
-		pr_err(EINJ_PFX
+		pr_err(
 "Can not request iomem region <%016llx-%016llx> for Trigger Table Entry.\n",
 		       (unsigned long long)trigger_paddr+sizeof(*trigger_tab),
 		       (unsigned long long)trigger_paddr + table_size);
@@ -228,7 +226,7 @@ static int __einj_error_trigger(u64 trigger_paddr)
 	iounmap(trigger_tab);
 	trigger_tab = ioremap_cache(trigger_paddr, table_size);
 	if (!trigger_tab) {
-		pr_err(EINJ_PFX "Failed to map trigger table!\n");
+		pr_err("Failed to map trigger table!\n");
 		goto out_rel_entry;
 	}
 	trigger_entry = (struct acpi_whea_header *)
@@ -454,17 +452,17 @@ static int __init einj_init(void)
 	status = acpi_get_table(ACPI_SIG_EINJ, 0,
 				(struct acpi_table_header **)&einj_tab);
 	if (status == AE_NOT_FOUND) {
-		pr_info(EINJ_PFX "Table is not found!\n");
+		pr_info("Table is not found!\n");
 		return -ENODEV;
 	} else if (ACPI_FAILURE(status)) {
 		const char *msg = acpi_format_exception(status);
-		pr_err(EINJ_PFX "Failed to get table, %s\n", msg);
+		pr_err("Failed to get table, %s\n", msg);
 		return -EINVAL;
 	}
 
 	rc = einj_check_table(einj_tab);
 	if (rc) {
-		pr_warning(FW_BUG EINJ_PFX "EINJ table is invalid\n");
+		pr_warn(FW_BUG "EINJ table is invalid\n");
 		return -EINVAL;
 	}
 
@@ -513,7 +511,7 @@ static int __init einj_init(void)
 			goto err_unmap;
 	}
 
-	pr_info(EINJ_PFX "Error INJection is initialized.\n");
+	pr_info("Error INJection is initialized.\n");
 
 	return 0;
 
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 1211c03..039f72f 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -24,6 +24,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -38,8 +40,6 @@
 
 #include "apei-internal.h"
 
-#define ERST_PFX "ERST: "
-
 /* ERST command status */
 #define ERST_STATUS_SUCCESS			0x0
 #define ERST_STATUS_NOT_ENOUGH_SPACE		0x1
@@ -108,8 +108,7 @@ static inline int erst_errno(int command_status)
 static int erst_timedout(u64 *t, u64 spin_unit)
 {
 	if ((s64)*t < spin_unit) {
-		pr_warning(FW_WARN ERST_PFX
-			   "Firmware does not respond in time\n");
+		pr_warn(FW_WARN "Firmware does not respond in time\n");
 		return 1;
 	}
 	*t -= spin_unit;
@@ -185,9 +184,9 @@ static int erst_exec_stall(struct apei_exec_context *ctx,
 
 	if (ctx->value > FIRMWARE_MAX_STALL) {
 		if (!in_nmi())
-			pr_warning(FW_WARN ERST_PFX
+			pr_warn(FW_WARN
 			"Too long stall time for stall instruction: %llx.\n",
-				   ctx->value);
+				ctx->value);
 		stall_time = FIRMWARE_MAX_STALL;
 	} else
 		stall_time = ctx->value;
@@ -205,9 +204,9 @@ static int erst_exec_stall_while_true(struct apei_exec_context *ctx,
 
 	if (ctx->var1 > FIRMWARE_MAX_STALL) {
 		if (!in_nmi())
-			pr_warning(FW_WARN ERST_PFX
+			pr_warn(FW_WARN
 		"Too long stall time for stall while true instruction: %llx.\n",
-				   ctx->var1);
+				ctx->var1);
 		stall_time = FIRMWARE_MAX_STALL;
 	} else
 		stall_time = ctx->var1;
@@ -270,8 +269,7 @@ static int erst_exec_move_data(struct apei_exec_context *ctx,
 
 	/* ioremap does not work in interrupt context */
 	if (in_interrupt()) {
-		pr_warning(ERST_PFX
-			   "MOVE_DATA can not be used in interrupt context");
+		pr_warn("MOVE_DATA can not be used in interrupt context\n");
 		return -EBUSY;
 	}
 
@@ -589,8 +587,7 @@ static int __erst_clear_from_storage(u64 record_id)
 static void pr_unimpl_nvram(void)
 {
 	if (printk_ratelimit())
-		pr_warning(ERST_PFX
-		"NVRAM ERST Log Address Range is not implemented yet\n");
+		pr_warn("NVRAM ERST Log Address Range is not implemented yet\n");
 }
 
 static int __erst_write_to_nvram(const struct cper_record_header *record)
@@ -793,7 +790,7 @@ static int __init erst_init(void)
 		goto err;
 
 	if (erst_disable) {
-		pr_info(ERST_PFX
+		pr_info(
 	"Error Record Serialization Table (ERST) support is disabled.\n");
 		goto err;
 	}
@@ -801,18 +798,18 @@ static int __init erst_init(void)
 	status = acpi_get_table(ACPI_SIG_ERST, 0,
 				(struct acpi_table_header **)&erst_tab);
 	if (status == AE_NOT_FOUND) {
-		pr_info(ERST_PFX "Table is not found!\n");
+		pr_info("Table is not found!\n");
 		goto err;
 	} else if (ACPI_FAILURE(status)) {
 		const char *msg = acpi_format_exception(status);
-		pr_err(ERST_PFX "Failed to get table, %s\n", msg);
+		pr_err("Failed to get table, %s\n", msg);
 		rc = -EINVAL;
 		goto err;
 	}
 
 	rc = erst_check_table(erst_tab);
 	if (rc) {
-		pr_err(FW_BUG ERST_PFX "ERST table is invalid\n");
+		pr_err(FW_BUG "ERST table is invalid\n");
 		goto err;
 	}
 
@@ -830,21 +827,20 @@ static int __init erst_init(void)
 	rc = erst_get_erange(&erst_erange);
 	if (rc) {
 		if (rc == -ENODEV)
-			pr_info(ERST_PFX
+			pr_info(
 	"The corresponding hardware device or firmware implementation "
 	"is not available.\n");
 		else
-			pr_err(ERST_PFX
-			       "Failed to get Error Log Address Range.\n");
+			pr_err("Failed to get Error Log Address Range.\n");
 		goto err_unmap_reg;
 	}
 
 	r = request_mem_region(erst_erange.base, erst_erange.size, "APEI ERST");
 	if (!r) {
-		pr_err(ERST_PFX
+		pr_err(
 		"Can not request iomem region <0x%16llx-0x%16llx> for ERST.\n",
-		(unsigned long long)erst_erange.base,
-		(unsigned long long)erst_erange.base + erst_erange.size);
+		       (unsigned long long)erst_erange.base,
+		       (unsigned long long)erst_erange.base + erst_erange.size);
 		rc = -EIO;
 		goto err_unmap_reg;
 	}
@@ -854,7 +850,7 @@ static int __init erst_init(void)
 	if (!erst_erange.vaddr)
 		goto err_release_erange;
 
-	pr_info(ERST_PFX
+	pr_info(
 	"Error Record Serialization Table (ERST) support is initialized.\n");
 
 	return 0;
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 0d505e5..a15c8d5 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -33,6 +33,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -50,8 +52,6 @@
 
 #include "apei-internal.h"
 
-#define GHES_PFX	"GHES: "
-
 #define GHES_ESTATUS_MAX_SIZE		65536
 
 /*
@@ -107,10 +107,10 @@ static struct ghes *ghes_new(struct acpi_hest_generic *generic)
 		goto err_free;
 	error_block_length = generic->error_block_length;
 	if (error_block_length > GHES_ESTATUS_MAX_SIZE) {
-		pr_warning(FW_WARN GHES_PFX
-			   "Error status block length is too long: %u for "
-			   "generic hardware error source: %d.\n",
-			   error_block_length, generic->header.source_id);
+		pr_warn(FW_WARN
+			"Error status block length is too long: %u for "
+			"generic hardware error source: %d.\n",
+			error_block_length, generic->header.source_id);
 		error_block_length = GHES_ESTATUS_MAX_SIZE;
 	}
 	ghes->estatus = kmalloc(error_block_length, GFP_KERNEL);
@@ -186,9 +186,9 @@ static int ghes_read_estatus(struct ghes *ghes, int silent)
 	rc = acpi_atomic_read(&buf_paddr, &g->error_status_address);
 	if (rc) {
 		if (!silent && printk_ratelimit())
-			pr_warning(FW_WARN GHES_PFX
-"Failed to read error status block address for hardware error source: %d.\n",
-				   g->header.source_id);
+			pr_warn(FW_WARN
+"Failed to read error status block address for hardware error source: %d\n",
+				g->header.source_id);
 		return -EIO;
 	}
 	if (!buf_paddr)
@@ -223,8 +223,7 @@ static int ghes_read_estatus(struct ghes *ghes, int silent)
 
 err_read_block:
 	if (rc && !silent)
-		pr_warning(FW_WARN GHES_PFX
-			   "Failed to read error status block!\n");
+		pr_warn(FW_WARN "Failed to read error status block!\n");
 	return rc;
 }
 
@@ -257,9 +256,9 @@ static void ghes_do_proc(struct ghes *ghes)
 	}
 
 	if (!processed && printk_ratelimit())
-		pr_warning(GHES_PFX
-		"Unknown error record from generic hardware error source: %d\n",
-			   ghes->generic->header.source_id);
+		pr_warn(
+	"Unknown error record from generic hardware error source: %d\n",
+			ghes->generic->header.source_id);
 }
 
 static int ghes_proc(struct ghes *ghes)
@@ -308,17 +307,17 @@ static int __devinit ghes_probe(struct platform_device *ghes_dev)
 
 	if (generic->error_block_length <
 	    sizeof(struct acpi_hest_generic_status)) {
-		pr_warning(FW_BUG GHES_PFX
+		pr_warn(FW_BUG
 "Invalid error block length: %u for generic hardware error source: %d\n",
-			   generic->error_block_length,
-			   generic->header.source_id);
+			generic->error_block_length,
+			generic->header.source_id);
 		goto err;
 	}
 	if (generic->records_to_preallocate == 0) {
-		pr_warning(FW_BUG GHES_PFX
+		pr_warn(FW_BUG
 "Invalid records to preallocate: %u for generic hardware error source: %d\n",
-			   generic->records_to_preallocate,
-			   generic->header.source_id);
+			generic->records_to_preallocate,
+			generic->header.source_id);
 		goto err;
 	}
 	ghes = ghes_new(generic);
@@ -349,13 +348,14 @@ static int __devinit ghes_probe(struct platform_device *ghes_dev)
 			break;
 		}
 		if (notify) {
-			pr_warning(GHES_PFX
+			pr_warn(
 "Generic hardware error source: %d notified via %s is not supported!\n",
-				   generic->header.source_id, notify);
+				generic->header.source_id, notify);
 		} else {
-			pr_warning(FW_WARN GHES_PFX
+			pr_warn(FW_WARN
 "Unknown notification type: %u for generic hardware error source: %d\n",
-			generic->notify.type, generic->header.source_id);
+				generic->notify.type,
+				generic->header.source_id);
 		}
 		rc = -ENODEV;
 		goto err;
@@ -416,7 +416,7 @@ static int __init ghes_init(void)
 		return -ENODEV;
 
 	if (hest_disable) {
-		pr_info(GHES_PFX "HEST is not enabled!\n");
+		pr_info("HEST is not enabled!\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index 1a3508a..7b92833 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -27,6 +27,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -39,8 +41,6 @@
 
 #include "apei-internal.h"
 
-#define HEST_PFX "HEST: "
-
 int hest_disable;
 EXPORT_SYMBOL_GPL(hest_disable);
 
@@ -96,15 +96,15 @@ int apei_hest_parse(apei_hest_func_t func, void *data)
 	for (i = 0; i < hest_tab->error_source_count; i++) {
 		len = hest_esrc_len(hest_hdr);
 		if (!len) {
-			pr_warning(FW_WARN HEST_PFX
-				   "Unknown or unused hardware error source "
-				   "type: %d for hardware error source: %d.\n",
-				   hest_hdr->type, hest_hdr->source_id);
+			pr_warn(FW_WARN
+				"Unknown or unused hardware error source "
+				"type: %d for hardware error source: %d.\n",
+				hest_hdr->type, hest_hdr->source_id);
 			return -EINVAL;
 		}
 		if ((void *)hest_hdr + len >
 		    (void *)hest_tab + hest_tab->header.length) {
-			pr_warning(FW_BUG HEST_PFX
+			pr_warn(FW_BUG
 		"Table contents overflow for hardware error source: %d.\n",
 				hest_hdr->source_id);
 			return -EINVAL;
@@ -205,18 +205,18 @@ static int __init hest_init(void)
 		goto err;
 
 	if (hest_disable) {
-		pr_info(HEST_PFX "HEST tabling parsing is disabled.\n");
+		pr_info("HEST tabling parsing is disabled.\n");
 		goto err;
 	}
 
 	status = acpi_get_table(ACPI_SIG_HEST, 0,
 				(struct acpi_table_header **)&hest_tab);
 	if (status == AE_NOT_FOUND) {
-		pr_info(HEST_PFX "Table is not found!\n");
+		pr_info("Table is not found!\n");
 		goto err;
 	} else if (ACPI_FAILURE(status)) {
 		const char *msg = acpi_format_exception(status);
-		pr_err(HEST_PFX "Failed to get table, %s\n", msg);
+		pr_err("Failed to get table, %s\n", msg);
 		rc = -EINVAL;
 		goto err;
 	}
@@ -229,7 +229,7 @@ static int __init hest_init(void)
 	if (rc)
 		goto err;
 
-	pr_info(HEST_PFX "HEST table parsing is initialized.\n");
+	pr_info("HEST table parsing is initialized.\n");
 
 	return 0;
 err:
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index f31291b..4f4953d 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -29,6 +29,8 @@
 /* Uncomment next line to get verbose printout */
 /* #define DEBUG */
 
+#define pr_fmt(fmt) "ACPI: EC: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -49,9 +51,6 @@
 #define ACPI_EC_DEVICE_NAME		"Embedded Controller"
 #define ACPI_EC_FILE_INFO		"info"
 
-#undef PREFIX
-#define PREFIX				"ACPI: EC: "
-
 /* EC status register */
 #define ACPI_EC_FLAG_OBF	0x01	/* Output buffer full */
 #define ACPI_EC_FLAG_IBF	0x02	/* Input buffer full */
@@ -121,26 +120,26 @@ static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
 static inline u8 acpi_ec_read_status(struct acpi_ec *ec)
 {
 	u8 x = inb(ec->command_addr);
-	pr_debug(PREFIX "---> status = 0x%2.2x\n", x);
+	pr_debug("---> status = 0x%2.2x\n", x);
 	return x;
 }
 
 static inline u8 acpi_ec_read_data(struct acpi_ec *ec)
 {
 	u8 x = inb(ec->data_addr);
-	pr_debug(PREFIX "---> data = 0x%2.2x\n", x);
+	pr_debug("---> data = 0x%2.2x\n", x);
 	return x;
 }
 
 static inline void acpi_ec_write_cmd(struct acpi_ec *ec, u8 command)
 {
-	pr_debug(PREFIX "<--- command = 0x%2.2x\n", command);
+	pr_debug("<--- command = 0x%2.2x\n", command);
 	outb(command, ec->command_addr);
 }
 
 static inline void acpi_ec_write_data(struct acpi_ec *ec, u8 data)
 {
-	pr_debug(PREFIX "<--- data = 0x%2.2x\n", data);
+	pr_debug("<--- data = 0x%2.2x\n", data);
 	outb(data, ec->data_addr);
 }
 
@@ -227,7 +226,7 @@ static int ec_poll(struct acpi_ec *ec)
 		} while (time_before(jiffies, delay));
 		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF)
 			break;
-		pr_debug(PREFIX "controller reset, restart transaction\n");
+		pr_debug("controller reset, restart transaction\n");
 		spin_lock_irqsave(&ec->curr_lock, flags);
 		start_transaction(ec);
 		spin_unlock_irqrestore(&ec->curr_lock, flags);
@@ -295,12 +294,11 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 		}
 	}
 	if (ec_wait_ibf0(ec)) {
-		pr_err(PREFIX "input buffer is not empty, "
-				"aborting transaction\n");
+		pr_err("input buffer is not empty, aborting transaction\n");
 		status = -ETIME;
 		goto end;
 	}
-	pr_debug(PREFIX "transaction start\n");
+	pr_debug("transaction start\n");
 	/* disable GPE during transaction if storm is detected */
 	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
 		/* It has to be disabled, so that it doesn't trigger. */
@@ -316,11 +314,10 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 		/* It is safe to enable the GPE outside of the transaction. */
 		acpi_enable_gpe(NULL, ec->gpe);
 	} else if (t->irq_count > ACPI_EC_STORM_THRESHOLD) {
-		pr_info(PREFIX "GPE storm detected, "
-			"transactions will use polling mode\n");
+		pr_info("GPE storm detected, transactions will use polling mode\n");
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
-	pr_debug(PREFIX "transaction end\n");
+	pr_debug("transaction end\n");
 end:
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);
@@ -545,12 +542,12 @@ static void acpi_ec_run(void *cxt)
 	struct acpi_ec_query_handler *handler = cxt;
 	if (!handler)
 		return;
-	pr_debug(PREFIX "start query execution\n");
+	pr_debug("start query execution\n");
 	if (handler->func)
 		handler->func(handler->data);
 	else if (handler->handle)
 		acpi_evaluate_object(handler->handle, NULL, NULL, NULL);
-	pr_debug(PREFIX "stop query execution\n");
+	pr_debug("stop query execution\n");
 	kfree(handler);
 }
 
@@ -568,7 +565,8 @@ static int acpi_ec_sync_query(struct acpi_ec *ec)
 			if (!copy)
 				return -ENOMEM;
 			memcpy(copy, handler, sizeof(*copy));
-			pr_debug(PREFIX "push query execution (0x%2x) on queue\n", value);
+			pr_debug("push query execution (0x%2x) on queue\n",
+				 value);
 			return acpi_os_execute((copy->func) ?
 				OSL_NOTIFY_HANDLER : OSL_GPE_HANDLER,
 				acpi_ec_run, copy);
@@ -593,7 +591,7 @@ static int ec_check_sci(struct acpi_ec *ec, u8 state)
 {
 	if (state & ACPI_EC_FLAG_SCI) {
 		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags)) {
-			pr_debug(PREFIX "push gpe query to the queue\n");
+			pr_debug("push gpe query to the queue\n");
 			return acpi_os_execute(OSL_NOTIFY_HANDLER,
 				acpi_ec_gpe_query, ec);
 		}
@@ -605,7 +603,7 @@ static u32 acpi_ec_gpe_handler(void *data)
 {
 	struct acpi_ec *ec = data;
 
-	pr_debug(PREFIX "~~~> interrupt\n");
+	pr_debug("~~~> interrupt\n");
 
 	advance_transaction(ec, acpi_ec_read_status(ec));
 	if (ec_transaction_done(ec) &&
@@ -751,8 +749,8 @@ static int ec_install_handlers(struct acpi_ec *ec)
 			 * The AE_NOT_FOUND error will be ignored and OS
 			 * continue to initialize EC.
 			 */
-			printk(KERN_ERR "Fail in evaluating the _REG object"
-				" of EC device. Broken bios is suspected.\n");
+			pr_err(
+"Fail in evaluating the _REG object of EC device. Broken bios is suspected.\n");
 		} else {
 			acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler);
@@ -770,10 +768,10 @@ static void ec_remove_handlers(struct acpi_ec *ec)
 	acpi_disable_gpe(NULL, ec->gpe);
 	if (ACPI_FAILURE(acpi_remove_address_space_handler(ec->handle,
 				ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
-		pr_err(PREFIX "failed to remove space handler\n");
+		pr_err("failed to remove space handler\n");
 	if (ACPI_FAILURE(acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler)))
-		pr_err(PREFIX "failed to remove gpe handler\n");
+		pr_err("failed to remove gpe handler\n");
 	clear_bit(EC_FLAGS_HANDLERS_INSTALLED, &ec->flags);
 }
 
@@ -817,8 +815,8 @@ static int acpi_ec_add(struct acpi_device *device)
 	WARN(!request_region(ec->command_addr, 1, "EC cmd"),
 	     "Could not request EC cmd io port 0x%lx", ec->command_addr);
 
-	pr_info(PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
-			  ec->gpe, ec->command_addr, ec->data_addr);
+	pr_info("GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
+		ec->gpe, ec->command_addr, ec->data_addr);
 
 	ret = ec_install_handlers(ec);
 
@@ -908,7 +906,7 @@ static int ec_validate_ecdt(const struct dmi_system_id *id)
 /* MSI EC needs special treatment, enable it */
 static int ec_flag_msi(const struct dmi_system_id *id)
 {
-	printk(KERN_DEBUG PREFIX "Detected MSI hardware, enabling workarounds.\n");
+	printk(KERN_DEBUG pr_fmt("Detected MSI hardware, enabling workarounds\n"));
 	EC_FLAGS_MSI = 1;
 	EC_FLAGS_VALIDATE_ECDT = 1;
 	return 0;
@@ -951,7 +949,7 @@ int __init acpi_ec_ecdt_probe(void)
 	status = acpi_get_table(ACPI_SIG_ECDT, 1,
 				(struct acpi_table_header **)&ecdt_ptr);
 	if (ACPI_SUCCESS(status)) {
-		pr_info(PREFIX "EC description table is found, configuring boot EC\n");
+		pr_info("EC description table is found, configuring boot EC\n");
 		boot_ec->command_addr = ecdt_ptr->control.address;
 		boot_ec->data_addr = ecdt_ptr->data.address;
 		boot_ec->gpe = ecdt_ptr->gpe;
@@ -971,7 +969,7 @@ int __init acpi_ec_ecdt_probe(void)
 
 	/* This workaround is needed only on some broken machines,
 	 * which require early EC, but fail to provide ECDT */
-	printk(KERN_DEBUG PREFIX "Look up EC in DSDT\n");
+	printk(KERN_DEBUG pr_fmt("Look up EC in DSDT\n"));
 	status = acpi_get_devices(ec_device_ids[0].id, ec_parse_device,
 					boot_ec, NULL);
 	/* Check that acpi_get_devices actually find something */
@@ -983,10 +981,10 @@ int __init acpi_ec_ecdt_probe(void)
 		    saved_ec->data_addr != boot_ec->data_addr ||
 		    saved_ec->gpe != boot_ec->gpe ||
 		    saved_ec->handle != boot_ec->handle)
-			pr_info(PREFIX "ASUSTek keeps feeding us with broken "
-			"ECDT tables, which are very hard to workaround. "
-			"Trying to use DSDT EC info instead. Please send "
-			"output of acpidump to linux-acpi@vger.kernel.org\n");
+			pr_info(
+"ASUSTek keeps feeding us with broken ECDT tables, which are very hard to workaround. "
+"Trying to use DSDT EC info instead. "
+"Please send output of acpidump to linux-acpi@vger.kernel.org\n");
 		kfree(saved_ec);
 		saved_ec = NULL;
 	} else {


