Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935485Ab2JaRqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:46:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759523Ab2JaRpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:45:34 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC EDAC/GHES 3/3] ghes: add support for reporting errors via EDAC
Date: Wed, 31 Oct 2012 15:44:55 -0200
Message-Id: <654292c78376dfe2b65cd9027787ab54705eeaa6.1351705248.git.mchehab@redhat.com>
In-Reply-To: <cover.1351705248.git.mchehab@redhat.com>
References: <cover.1351705248.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/acpi/apei/ghes.c | 52 +++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/edac.h     |  1 +
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 9466d36..54c2d97 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -115,6 +115,7 @@ struct ghes {
 struct ghes_estatus_node {
 	struct llist_node llnode;
 	struct acpi_hest_generic *generic;
+	struct ghes *ghes;
 };
 
 struct ghes_estatus_cache {
@@ -457,7 +458,49 @@ static void ghes_clear_estatus(struct ghes *ghes)
 	ghes->flags &= ~GHES_TO_CLEAR;
 }
 
-static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
+static void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
+				       struct cper_sec_mem_err *mem_err)
+{
+#ifdef CONFIG_EDAC_MM_EDAC
+	enum hw_event_mc_err_type type;
+	unsigned long page = 0, offset = 0, grain = 0;
+	char location[80];
+	char *label = "unknown";
+
+	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
+		page = mem_err->physical_addr >> PAGE_SHIFT;
+		offset = mem_err->physical_addr & ~PAGE_MASK;
+		grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
+	}
+
+	switch(sev) {
+	case GHES_SEV_CORRECTED:
+		type = HW_EVENT_ERR_CORRECTED;
+		break;
+	case GHES_SEV_RECOVERABLE:
+		type = HW_EVENT_ERR_UNCORRECTED;
+		break;
+	case GHES_SEV_PANIC:
+		type = HW_EVENT_ERR_FATAL;
+		break;
+	default:
+	case GHES_SEV_NO:
+		type = HW_EVENT_ERR_INFO;
+	}
+
+	sprintf(location,"node:%d card:%d module:%d bank:%d device:%d row: %d column:%d bit_pos:%d",
+		mem_err->node, mem_err->card, mem_err->module,
+		mem_err->bank, mem_err->device, mem_err->row, mem_err->column,
+		mem_err->bit_pos);
+
+	edac_raw_mc_handle_error(type, ghes->mci, grain, 1, 0, 0, 0,
+				 page, offset, 0,
+				 "APEI", location, label, "", 0);
+#endif
+}
+
+static void ghes_do_proc(struct ghes *ghes,
+			 const struct acpi_hest_generic_status *estatus)
 {
 	int sev, sec_sev;
 	struct acpi_hest_generic_data *gdata;
@@ -469,6 +512,8 @@ static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
 				 CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err;
 			mem_err = (struct cper_sec_mem_err *)(gdata+1);
+			ghes_edac_report_mem_error(ghes, sev, mem_err);
+
 #ifdef CONFIG_X86_MCE
 			apei_mce_report_mem_error(sev == GHES_SEV_CORRECTED,
 						  mem_err);
@@ -687,7 +732,7 @@ static int ghes_proc(struct ghes *ghes)
 		if (ghes_print_estatus(NULL, ghes->generic, ghes->estatus))
 			ghes_estatus_cache_add(ghes->generic, ghes->estatus);
 	}
-	ghes_do_proc(ghes->estatus);
+	ghes_do_proc(ghes, ghes->estatus);
 out:
 	ghes_clear_estatus(ghes);
 	return 0;
@@ -780,7 +825,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
 		len = apei_estatus_len(estatus);
 		node_len = GHES_ESTATUS_NODE_LEN(len);
-		ghes_do_proc(estatus);
+		ghes_do_proc(estatus_node->ghes, estatus);
 		if (!ghes_estatus_cached(estatus)) {
 			generic = estatus_node->generic;
 			if (ghes_print_estatus(NULL, generic, estatus))
@@ -869,6 +914,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 		estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool,
 						      node_len);
 		if (estatus_node) {
+			estatus_node->ghes = ghes;
 			estatus_node->generic = ghes->generic;
 			estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
 			memcpy(estatus, ghes->estatus, len);
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 1e9d19b..f26fe40 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -100,6 +100,7 @@ enum hw_event_mc_err_type {
 	HW_EVENT_ERR_CORRECTED,
 	HW_EVENT_ERR_UNCORRECTED,
 	HW_EVENT_ERR_FATAL,
+	HW_EVENT_ERR_INFO,
 };
 
 /**
-- 
1.7.11.7

