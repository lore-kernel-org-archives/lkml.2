Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1JGQzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:55:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab1JGQzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:55:32 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i7300_edac: Fix error cleanup logic
Date: Fri,  7 Oct 2011 13:55:21 -0300
Message-Id: <1318006521-14539-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error cleanup logic was broken. Due to that, one error is generated for
every error polling.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7300_edac.c |   51 +++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index a76fe83..6104dba 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -372,7 +372,7 @@ static const char *get_err_from_table(const char *table[], int size, int pos)
 static void i7300_process_error_global(struct mem_ctl_info *mci)
 {
 	struct i7300_pvt *pvt;
-	u32 errnum, value;
+	u32 errnum, error_reg;
 	unsigned long errors;
 	const char *specific;
 	bool is_fatal;
@@ -381,9 +381,9 @@ static void i7300_process_error_global(struct mem_ctl_info *mci)
 
 	/* read in the 1st FATAL error register */
 	pci_read_config_dword(pvt->pci_dev_16_2_fsb_err_regs,
-			      FERR_GLOBAL_HI, &value);
-	if (unlikely(value)) {
-		errors = value;
+			      FERR_GLOBAL_HI, &error_reg);
+	if (unlikely(error_reg)) {
+		errors = error_reg;
 		errnum = find_first_bit(&errors,
 					ARRAY_SIZE(ferr_global_hi_name));
 		specific = GET_ERR_FROM_TABLE(ferr_global_hi_name, errnum);
@@ -391,15 +391,15 @@ static void i7300_process_error_global(struct mem_ctl_info *mci)
 
 		/* Clear the error bit */
 		pci_write_config_dword(pvt->pci_dev_16_2_fsb_err_regs,
-				       FERR_GLOBAL_HI, value);
+				       FERR_GLOBAL_HI, error_reg);
 
 		goto error_global;
 	}
 
 	pci_read_config_dword(pvt->pci_dev_16_2_fsb_err_regs,
-			      FERR_GLOBAL_LO, &value);
-	if (unlikely(value)) {
-		errors = value;
+			      FERR_GLOBAL_LO, &error_reg);
+	if (unlikely(error_reg)) {
+		errors = error_reg;
 		errnum = find_first_bit(&errors,
 					ARRAY_SIZE(ferr_global_lo_name));
 		specific = GET_ERR_FROM_TABLE(ferr_global_lo_name, errnum);
@@ -407,7 +407,7 @@ static void i7300_process_error_global(struct mem_ctl_info *mci)
 
 		/* Clear the error bit */
 		pci_write_config_dword(pvt->pci_dev_16_2_fsb_err_regs,
-				       FERR_GLOBAL_LO, value);
+				       FERR_GLOBAL_LO, error_reg);
 
 		goto error_global;
 	}
@@ -427,7 +427,7 @@ error_global:
 static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 {
 	struct i7300_pvt *pvt;
-	u32 errnum, value;
+	u32 errnum, value, error_reg;
 	u16 val16;
 	unsigned branch, channel, bank, rank, cas, ras;
 	u32 syndrome;
@@ -440,14 +440,14 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 
 	/* read in the 1st FATAL error register */
 	pci_read_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
-			      FERR_FAT_FBD, &value);
-	if (unlikely(value & FERR_FAT_FBD_ERR_MASK)) {
-		errors = value & FERR_FAT_FBD_ERR_MASK ;
+			      FERR_FAT_FBD, &error_reg);
+	if (unlikely(error_reg & FERR_FAT_FBD_ERR_MASK)) {
+		errors = error_reg & FERR_FAT_FBD_ERR_MASK ;
 		errnum = find_first_bit(&errors,
 					ARRAY_SIZE(ferr_fat_fbd_name));
 		specific = GET_ERR_FROM_TABLE(ferr_fat_fbd_name, errnum);
+		branch = (GET_FBD_FAT_IDX(error_reg) == 2) ? 1 : 0;
 
-		branch = (GET_FBD_FAT_IDX(value) == 2) ? 1 : 0;
 		pci_read_config_word(pvt->pci_dev_16_1_fsb_addr_map,
 				     NRECMEMA, &val16);
 		bank = NRECMEMA_BANK(val16);
@@ -455,11 +455,14 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 
 		pci_read_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
 				NRECMEMB, &value);
-
 		is_wr = NRECMEMB_IS_WR(value);
 		cas = NRECMEMB_CAS(value);
 		ras = NRECMEMB_RAS(value);
 
+		/* Clean the error register */
+		pci_write_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
+				FERR_FAT_FBD, error_reg);
+
 		snprintf(pvt->tmp_prt_buffer, PAGE_SIZE,
 			"FATAL (Branch=%d DRAM-Bank=%d %s "
 			"RAS=%d CAS=%d Err=0x%lx (%s))",
@@ -476,21 +479,17 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 
 	/* read in the 1st NON-FATAL error register */
 	pci_read_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
-			      FERR_NF_FBD, &value);
-	if (unlikely(value & FERR_NF_FBD_ERR_MASK)) {
-		errors = value & FERR_NF_FBD_ERR_MASK;
+			      FERR_NF_FBD, &error_reg);
+	if (unlikely(error_reg & FERR_NF_FBD_ERR_MASK)) {
+		errors = error_reg & FERR_NF_FBD_ERR_MASK;
 		errnum = find_first_bit(&errors,
 					ARRAY_SIZE(ferr_nf_fbd_name));
 		specific = GET_ERR_FROM_TABLE(ferr_nf_fbd_name, errnum);
-
-		/* Clear the error bit */
-		pci_write_config_dword(pvt->pci_dev_16_2_fsb_err_regs,
-				       FERR_GLOBAL_LO, value);
+		branch = (GET_FBD_FAT_IDX(error_reg) == 2) ? 1 : 0;
 
 		pci_read_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
 			REDMEMA, &syndrome);
 
-		branch = (GET_FBD_FAT_IDX(value) == 2) ? 1 : 0;
 		pci_read_config_word(pvt->pci_dev_16_1_fsb_addr_map,
 				     RECMEMA, &val16);
 		bank = RECMEMA_BANK(val16);
@@ -498,18 +497,20 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 
 		pci_read_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
 				RECMEMB, &value);
-
 		is_wr = RECMEMB_IS_WR(value);
 		cas = RECMEMB_CAS(value);
 		ras = RECMEMB_RAS(value);
 
 		pci_read_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
 				     REDMEMB, &value);
-
 		channel = (branch << 1);
 		if (IS_SECOND_CH(value))
 			channel++;
 
+		/* Clear the error bit */
+		pci_write_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
+				FERR_NF_FBD, error_reg);
+
 		/* Form out message */
 		snprintf(pvt->tmp_prt_buffer, PAGE_SIZE,
 			"Corrected error (Branch=%d, Channel %d), "
-- 
1.7.6.4

