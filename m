Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2JSJoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:44:01 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45444 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2JSJn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:43:56 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q9J9hgSk008737, This message is released by code: ctlocs8528
From: <rogerable@realtek.com>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>
CC: <linux-kernel@vger.kernel.org>, Roger Tseng <rogerable@realtek.com>
Subject: [PATCH] staging: rts5139: fixed issues when config to built-in object
Date: Fri, 19 Oct 2012 17:43:34 +0800
Message-ID: <1350639814-31678-1-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.7.12.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Tseng <rogerable@realtek.com>

Fixed two issues when CONFIG_RTS5139=y :

  - Makefile doesn't take $(CONFIG_RTS5139). It always uses obj-m and built as
    a loadable module.
  - Rename some symbols with prefix 'rts51x_' to prevent symbol name collisions
    with drivers/staging/rts_pstor when both are configured to be built-in
    objects.

  drivers/staging/rts5139/built-in.o: In function `xd_cleanup_work':
  (.text+0x1435d): multiple definition of `xd_cleanup_work'
  drivers/staging/rts_pstor/built-in.o:(.text+0x2b96a): first defined here
  drivers/staging/rts5139/built-in.o: In function `release_xd_card':
  (.text+0x14393): multiple definition of `release_xd_card'
  drivers/staging/rts_pstor/built-in.o:(.text+0x2c491): first defined here
  drivers/staging/rts5139/built-in.o: In function `set_sense_data':
  (.text+0x1e02): multiple definition of `set_sense_data'
  drivers/staging/rts_pstor/built-in.o:(.text+0xa79f): first defined here
  drivers/staging/rts5139/built-in.o: In function `ms_delay_write':
  ...

Signed-off-by: Roger Tseng <rogerable@realtek.com>
---
 drivers/staging/rts5139/Makefile      |  22 ++--
 drivers/staging/rts5139/ms.c          |  96 +++++++-------
 drivers/staging/rts5139/ms.h          |  18 +--
 drivers/staging/rts5139/ms_mg.c       | 104 +++++++--------
 drivers/staging/rts5139/ms_mg.h       |  14 +-
 drivers/staging/rts5139/rts51x.c      |  10 +-
 drivers/staging/rts5139/rts51x_card.c |  80 ++++++------
 drivers/staging/rts5139/rts51x_card.h |  30 ++---
 drivers/staging/rts5139/rts51x_chip.c |  24 ++--
 drivers/staging/rts5139/rts51x_chip.h |  16 +--
 drivers/staging/rts5139/rts51x_fop.c  |   6 +-
 drivers/staging/rts5139/rts51x_scsi.c | 238 +++++++++++++++++-----------------
 drivers/staging/rts5139/rts51x_scsi.h |   6 +-
 drivers/staging/rts5139/sd.c          |  36 ++---
 drivers/staging/rts5139/sd.h          |  12 +-
 drivers/staging/rts5139/sd_cprm.c     | 124 +++++++++---------
 drivers/staging/rts5139/sd_cprm.h     |  18 +--
 drivers/staging/rts5139/xd.c          |  58 ++++-----
 drivers/staging/rts5139/xd.h          |  10 +-
 19 files changed, 464 insertions(+), 458 deletions(-)

diff --git a/drivers/staging/rts5139/Makefile b/drivers/staging/rts5139/Makefile
index 82b8958..75dd312 100644
--- a/drivers/staging/rts5139/Makefile
+++ b/drivers/staging/rts5139/Makefile
@@ -25,13 +25,19 @@
 # Makefile for the RTS51xx USB Card Reader drivers.
 #
 
-TARGET_MODULE := rts5139
+obj-$(CONFIG_RTS5139) := rts5139.o
 
-EXTRA_CFLAGS := -Idrivers/scsi -I$(PWD)
+ccflags-y := -Idrivers/scsi
 
-obj-m += $(TARGET_MODULE).o
-
-common-obj := rts51x_transport.o rts51x_scsi.o rts51x_fop.o
-
-$(TARGET_MODULE)-objs := $(common-obj) rts51x.o rts51x_chip.o rts51x_card.o \
-		xd.o sd.o ms.o sd_cprm.o ms_mg.o
+rts5139-y :=				\
+		rts51x_transport.o 	\
+		rts51x_scsi.o		\
+		rts51x_fop.o		\
+		rts51x.o		\
+		rts51x_chip.o		\
+		rts51x_card.o		\
+		xd.o			\
+		sd.o			\
+		ms.o			\
+		sd_cprm.o		\
+		ms_mg.o
diff --git a/drivers/staging/rts5139/ms.c b/drivers/staging/rts5139/ms.c
index 6eef33b..a27f7e2 100644
--- a/drivers/staging/rts5139/ms.c
+++ b/drivers/staging/rts5139/ms.c
@@ -160,7 +160,7 @@ int ms_transfer_data(struct rts51x_chip *chip, u8 trans_mode, u8 tpc,
 		rts51x_add_cmd(chip, WRITE_REG_CMD, MS_CFG, MS_2K_SECTOR_MODE,
 			       0);
 
-	trans_dma_enable(dir, chip, sec_cnt * 512, DMA_512);
+	rts51x_trans_dma_enable(dir, chip, sec_cnt * 512, DMA_512);
 
 	rts51x_add_cmd(chip, WRITE_REG_CMD, MS_TRANSFER, 0xFF,
 		       MS_TRANSFER_START | trans_mode);
@@ -602,7 +602,7 @@ static int ms_prepare_reset(struct rts51x_chip *chip)
 	if (!chip->option.FT2_fast_mode) {
 		wait_timeout(250);
 
-		card_power_on(chip, MS_CARD);
+		rts51x_card_power_on(chip, MS_CARD);
 		wait_timeout(150);
 
 #ifdef SUPPORT_OCP
@@ -872,7 +872,7 @@ static int msxc_change_power(struct rts51x_chip *chip, u8 mode)
 	int retval;
 	u8 buf[6];
 
-	ms_cleanup_work(chip);
+	rts51x_ms_cleanup_work(chip);
 
 	/* Set Parameter Register */
 	retval = ms_set_rw_reg_addr(chip, 0, 0, Pro_DataCount1, 6);
@@ -2600,14 +2600,14 @@ BUILD_FAIL:
 	return STATUS_FAIL;
 }
 
-int reset_ms_card(struct rts51x_chip *chip)
+int rts51x_reset_ms_card(struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
 
 	memset(ms_card, 0, sizeof(struct ms_info));
 
-	enable_card_clock(chip, MS_CARD);
+	rts51x_enable_card_clock(chip, MS_CARD);
 
 	retval = rts51x_select_card(chip, MS_CARD);
 	if (retval != STATUS_SUCCESS)
@@ -2936,7 +2936,7 @@ static int mspro_read_format_progress(struct rts51x_chip *chip,
 	return STATUS_SUCCESS;
 }
 
-void mspro_polling_format_status(struct rts51x_chip *chip)
+void rts51x_mspro_polling_format_status(struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	int i;
@@ -2952,25 +2952,25 @@ void mspro_polling_format_status(struct rts51x_chip *chip)
 	return;
 }
 
-void mspro_format_sense(struct rts51x_chip *chip, unsigned int lun)
+void rts51x_mspro_format_sense(struct rts51x_chip *chip, unsigned int lun)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 
 	if (CHK_FORMAT_STATUS(ms_card, FORMAT_SUCCESS)) {
-		set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
 		ms_card->pro_under_formatting = 0;
 		ms_card->progress = 0;
 	} else if (CHK_FORMAT_STATUS(ms_card, FORMAT_IN_PROGRESS)) {
-		set_sense_data(chip, lun, CUR_ERR, 0x02, 0, 0x04, 0x04,
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x02, 0, 0x04, 0x04,
 			       0, (u16) (ms_card->progress));
 	} else {
-		set_sense_type(chip, lun, SENSE_TYPE_FORMAT_CMD_FAILED);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_FORMAT_CMD_FAILED);
 		ms_card->pro_under_formatting = 0;
 		ms_card->progress = 0;
 	}
 }
 
-int mspro_format(struct scsi_cmnd *srb, struct rts51x_chip *chip,
+int rts51x_mspro_format(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 		 int short_data_len, int quick_format)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
@@ -3035,7 +3035,7 @@ int mspro_format(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 		ms_card->pro_under_formatting = 0;
 		ms_card->progress = 0;
 		ms_card->format_status = FORMAT_SUCCESS;
-		set_sense_type(chip, SCSI_LUN(srb), SENSE_TYPE_NO_SENSE);
+		rts51x_set_sense_type(chip, SCSI_LUN(srb), SENSE_TYPE_NO_SENSE);
 		return STATUS_SUCCESS;
 	}
 
@@ -3103,7 +3103,7 @@ static int ms_read_multiple_pages(struct rts51x_chip *chip, u16 phy_blk,
 	rts51x_add_cmd(chip, WRITE_REG_CMD, MS_SECTOR_CNT_H, 0xFF, 0);
 	rts51x_add_cmd(chip, WRITE_REG_CMD, MS_TPC, 0xFF, READ_PAGE_DATA);
 
-	trans_dma_enable(DMA_FROM_DEVICE, chip, 512 * page_cnt, DMA_512);
+	rts51x_trans_dma_enable(DMA_FROM_DEVICE, chip, 512 * page_cnt, DMA_512);
 
 	rts51x_add_cmd(chip, WRITE_REG_CMD, MS_TRANSFER, 0xFF,
 		       MS_TRANSFER_START | MS_TM_MULTI_READ);
@@ -3307,7 +3307,7 @@ static int ms_write_multiple_pages(struct rts51x_chip *chip, u16 old_blk,
 	rts51x_add_cmd(chip, WRITE_REG_CMD, CARD_DATA_SOURCE, 0x01,
 		       RING_BUFFER);
 
-	trans_dma_enable(DMA_TO_DEVICE, chip, 512 * page_cnt, DMA_512);
+	rts51x_trans_dma_enable(DMA_TO_DEVICE, chip, 512 * page_cnt, DMA_512);
 
 	rts51x_add_cmd(chip, WRITE_REG_CMD, MS_TRANSFER, 0xFF,
 		       MS_TRANSFER_START | MS_TM_MULTI_WRITE);
@@ -3467,7 +3467,7 @@ static int ms_read_multiple_pages(struct rts51x_chip *chip, u16 phy_blk,
 		rts51x_add_cmd(chip, WRITE_REG_CMD, MS_TRANS_CFG, 0xFF,
 			       trans_cfg);
 
-		trans_dma_enable(DMA_FROM_DEVICE, chip, 512, DMA_512);
+		rts51x_trans_dma_enable(DMA_FROM_DEVICE, chip, 512, DMA_512);
 
 		rts51x_add_cmd(chip, WRITE_REG_CMD, MS_TRANSFER, 0xFF,
 			       MS_TRANSFER_START | MS_TM_NORMAL_READ);
@@ -3670,7 +3670,7 @@ static int ms_write_multiple_pages(struct rts51x_chip *chip, u16 old_blk,
 		rts51x_add_cmd(chip, WRITE_REG_CMD, MS_TRANS_CFG, 0xFF,
 			       WAIT_INT);
 
-		trans_dma_enable(DMA_TO_DEVICE, chip, 512, DMA_512);
+		rts51x_trans_dma_enable(DMA_TO_DEVICE, chip, 512, DMA_512);
 
 		rts51x_add_cmd(chip, WRITE_REG_CMD, MS_TRANSFER, 0xFF,
 			       MS_TRANSFER_START | MS_TM_NORMAL_WRITE);
@@ -3803,10 +3803,10 @@ static int ms_prepare_write(struct rts51x_chip *chip, u16 old_blk, u16 new_blk,
 	return STATUS_SUCCESS;
 }
 
-int ms_delay_write(struct rts51x_chip *chip)
+int rts51x_ms_delay_write(struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
-	struct ms_delay_write_tag *delay_write = &(ms_card->delay_write);
+	struct rts51x_ms_delay_write_tag *delay_write = &(ms_card->delay_write);
 	int retval;
 
 	if (delay_write->delay_write_flag) {
@@ -3827,16 +3827,16 @@ int ms_delay_write(struct rts51x_chip *chip)
 	return STATUS_SUCCESS;
 }
 
-static inline void ms_rw_fail(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+static inline void rts51x_ms_rw_fail(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	if (srb->sc_data_direction == DMA_FROM_DEVICE)
-		set_sense_type(chip, SCSI_LUN(srb),
+		rts51x_set_sense_type(chip, SCSI_LUN(srb),
 			       SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 	else
-		set_sense_type(chip, SCSI_LUN(srb), SENSE_TYPE_MEDIA_WRITE_ERR);
+		rts51x_set_sense_type(chip, SCSI_LUN(srb), SENSE_TYPE_MEDIA_WRITE_ERR);
 }
 
-static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
+static int rts51x_ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 			      u32 start_sector, u16 sector_cnt)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
@@ -3847,7 +3847,7 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 	u8 start_page, end_page = 0, page_cnt;
 	u8 *buf;
 	void *ptr = NULL;
-	struct ms_delay_write_tag *delay_write = &(ms_card->delay_write);
+	struct rts51x_ms_delay_write_tag *delay_write = &(ms_card->delay_write);
 
 	ms_set_err_code(chip, MS_NO_ERROR);
 
@@ -3857,7 +3857,7 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 
 	retval = ms_switch_clock(chip);
 	if (retval != STATUS_SUCCESS) {
-		ms_rw_fail(srb, chip);
+		rts51x_ms_rw_fail(srb, chip);
 		TRACE_RET(chip, retval);
 	}
 
@@ -3873,7 +3873,7 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 		retval = ms_build_l2p_tbl(chip, seg_no);
 		if (retval != STATUS_SUCCESS) {
 			chip->card_fail |= MS_CARD;
-			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 			TRACE_RET(chip, retval);
 		}
 	}
@@ -3898,7 +3898,7 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 					      start_page);
 #endif
 			if (retval != STATUS_SUCCESS) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_WRITE_ERR);
 				TRACE_RET(chip, retval);
 			}
@@ -3911,9 +3911,9 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 			old_blk = delay_write->old_phyblock;
 			new_blk = delay_write->new_phyblock;
 		} else {
-			retval = ms_delay_write(chip);
+			retval = rts51x_ms_delay_write(chip);
 			if (retval != STATUS_SUCCESS) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_WRITE_ERR);
 				TRACE_RET(chip, retval);
 			}
@@ -3922,7 +3922,7 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 					   log_blk - ms_start_idx[seg_no]);
 			new_blk = ms_get_unused_block(chip, seg_no);
 			if ((old_blk == 0xFFFF) || (new_blk == 0xFFFF)) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_WRITE_ERR);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
@@ -3933,26 +3933,26 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 			if (retval != STATUS_SUCCESS) {
 				if (monitor_card_cd(chip, MS_CARD) ==
 				    CD_NOT_EXIST) {
-					set_sense_type(chip, lun,
+					rts51x_set_sense_type(chip, lun,
 						SENSE_TYPE_MEDIA_NOT_PRESENT);
 					TRACE_RET(chip, STATUS_FAIL);
 				}
 
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_WRITE_ERR);
 				TRACE_RET(chip, retval);
 			}
 		}
 	} else {
-		retval = ms_delay_write(chip);
+		retval = rts51x_ms_delay_write(chip);
 		if (retval != STATUS_SUCCESS) {
 			if (monitor_card_cd(chip, MS_CARD) == CD_NOT_EXIST) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_NOT_PRESENT);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
 
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 			TRACE_RET(chip, retval);
 		}
@@ -3960,7 +3960,7 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 		    ms_get_l2p_tbl(chip, seg_no,
 				   log_blk - ms_start_idx[seg_no]);
 		if (old_blk == 0xFFFF) {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 			TRACE_RET(chip, STATUS_FAIL);
 		}
@@ -3993,12 +3993,12 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 
 		if (retval != STATUS_SUCCESS) {
 			if (monitor_card_cd(chip, MS_CARD) == CD_NOT_EXIST) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_NOT_PRESENT);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
 
-			ms_rw_fail(srb, chip);
+			rts51x_ms_rw_fail(srb, chip);
 			TRACE_RET(chip, retval);
 		}
 		/* Update L2P table if need */
@@ -4030,7 +4030,7 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 			retval = ms_build_l2p_tbl(chip, seg_no);
 			if (retval != STATUS_SUCCESS) {
 				chip->card_fail |= MS_CARD;
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_NOT_PRESENT);
 				TRACE_RET(chip, retval);
 			}
@@ -4040,14 +4040,14 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 		    ms_get_l2p_tbl(chip, seg_no,
 				   log_blk - ms_start_idx[seg_no]);
 		if (old_blk == 0xFFFF) {
-			ms_rw_fail(srb, chip);
+			rts51x_ms_rw_fail(srb, chip);
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 
 		if (srb->sc_data_direction == DMA_TO_DEVICE) {
 			new_blk = ms_get_unused_block(chip, seg_no);
 			if (new_blk == 0xFFFF) {
-				ms_rw_fail(srb, chip);
+				rts51x_ms_rw_fail(srb, chip);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
 		}
@@ -4073,7 +4073,7 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 	return STATUS_SUCCESS;
 }
 
-int ms_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
+int rts51x_ms_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 	  u16 sector_cnt)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
@@ -4084,12 +4084,12 @@ int ms_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 		    mspro_rw_multi_sector(srb, chip, start_sector, sector_cnt);
 	else
 		retval =
-		    ms_rw_multi_sector(srb, chip, start_sector, sector_cnt);
+		    rts51x_ms_rw_multi_sector(srb, chip, start_sector, sector_cnt);
 
 	return retval;
 }
 
-void ms_free_l2p_tbl(struct rts51x_chip *chip)
+void rts51x_ms_free_l2p_tbl(struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	int i = 0;
@@ -4110,7 +4110,7 @@ void ms_free_l2p_tbl(struct rts51x_chip *chip)
 	}
 }
 
-void ms_cleanup_work(struct rts51x_chip *chip)
+void rts51x_ms_cleanup_work(struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 
@@ -4130,7 +4130,7 @@ void ms_cleanup_work(struct rts51x_chip *chip)
 	} else if ((!CHK_MSPRO(ms_card))
 		   && ms_card->delay_write.delay_write_flag) {
 		RTS51X_DEBUGP("MS: delay write\n");
-		ms_delay_write(chip);
+		rts51x_ms_delay_write(chip);
 		ms_card->counter = 0;
 	}
 }
@@ -4161,12 +4161,12 @@ static int ms_power_off_card3v3(struct rts51x_chip *chip)
 	return STATUS_SUCCESS;
 }
 
-int release_ms_card(struct rts51x_chip *chip)
+int rts51x_release_ms_card(struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
 
-	RTS51X_DEBUGP("release_ms_card\n");
+	RTS51X_DEBUGP("rts51x_release_ms_card\n");
 
 	ms_card->delay_write.delay_write_flag = 0;
 	ms_card->pro_under_formatting = 0;
@@ -4175,7 +4175,7 @@ int release_ms_card(struct rts51x_chip *chip)
 	chip->card_fail &= ~MS_CARD;
 	chip->card_wp &= ~MS_CARD;
 
-	ms_free_l2p_tbl(chip);
+	rts51x_ms_free_l2p_tbl(chip);
 
 	rts51x_write_register(chip, SFSM_ED, HW_CMD_STOP, HW_CMD_STOP);
 
diff --git a/drivers/staging/rts5139/ms.h b/drivers/staging/rts5139/ms.h
index 0321d06..857c197 100644
--- a/drivers/staging/rts5139/ms.h
+++ b/drivers/staging/rts5139/ms.h
@@ -231,18 +231,18 @@
 	(((retval) != STATUS_SUCCESS) || \
 	(chip->rsp_buf[0] & MS_TRANSFER_ERR))
 
-void mspro_polling_format_status(struct rts51x_chip *chip);
-void mspro_format_sense(struct rts51x_chip *chip, unsigned int lun);
+void rts51x_mspro_polling_format_status(struct rts51x_chip *chip);
+void rts51x_mspro_format_sense(struct rts51x_chip *chip, unsigned int lun);
 
-int reset_ms_card(struct rts51x_chip *chip);
-int ms_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
+int rts51x_reset_ms_card(struct rts51x_chip *chip);
+int rts51x_ms_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 	  u16 sector_cnt);
-int mspro_format(struct scsi_cmnd *srb, struct rts51x_chip *chip,
+int rts51x_mspro_format(struct scsi_cmnd *srb, struct rts51x_chip *chip,
 		 int short_data_len, int quick_format);
-void ms_free_l2p_tbl(struct rts51x_chip *chip);
-void ms_cleanup_work(struct rts51x_chip *chip);
-int release_ms_card(struct rts51x_chip *chip);
-int ms_delay_write(struct rts51x_chip *chip);
+void rts51x_ms_free_l2p_tbl(struct rts51x_chip *chip);
+void rts51x_ms_cleanup_work(struct rts51x_chip *chip);
+int rts51x_release_ms_card(struct rts51x_chip *chip);
+int rts51x_ms_delay_write(struct rts51x_chip *chip);
 
 #ifdef SUPPORT_MAGIC_GATE
 
diff --git a/drivers/staging/rts5139/ms_mg.c b/drivers/staging/rts5139/ms_mg.c
index 057d96c..54cfd85 100644
--- a/drivers/staging/rts5139/ms_mg.c
+++ b/drivers/staging/rts5139/ms_mg.c
@@ -119,7 +119,7 @@ int mg_set_tpc_para_sub(struct rts51x_chip *chip, int type, u8 mg_entry_num)
   * 2. send SET_ID TPC command to medium with Leaf ID released by host
   * in this SCSI CMD.
   */
-int mg_set_leaf_id(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_mg_set_leaf_id(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	int retval;
 	int i;
@@ -129,10 +129,10 @@ int mg_set_leaf_id(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	RTS51X_DEBUGP("--%s--\n", __func__);
 
 	if (scsi_bufflen(srb) < 12) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, STATUS_FAIL);
 	}
-	ms_cleanup_work(chip);
+	rts51x_ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
@@ -140,7 +140,7 @@ int mg_set_leaf_id(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	retval = mg_send_ex_cmd(chip, MG_SET_LID, 0);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
 		TRACE_RET(chip, retval);
 	}
 
@@ -151,12 +151,12 @@ int mg_set_leaf_id(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	retval =
 	    ms_write_bytes(chip, PRO_WRITE_SHORT_DATA, 32, WAIT_INT, buf1, 32);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
 		TRACE_RET(chip, retval);
 	}
 	retval = mg_check_int_error(chip);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
 		TRACE_RET(chip, retval);
 	}
 
@@ -170,7 +170,7 @@ int mg_set_leaf_id(struct scsi_cmnd *srb, struct rts51x_chip *chip)
   * data(1536 bytes totally) from medium by using READ_LONG_DATA TPC
   * for 3 times, and report data to host with data-length is 1052 bytes.
   */
-int mg_get_local_EKB(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_mg_get_local_EKB(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	int retval = STATUS_FAIL;
 	int bufflen;
@@ -179,7 +179,7 @@ int mg_get_local_EKB(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	RTS51X_DEBUGP("--%s--\n", __func__);
 
-	ms_cleanup_work(chip);
+	rts51x_ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
@@ -196,21 +196,21 @@ int mg_get_local_EKB(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	retval = mg_send_ex_cmd(chip, MG_GET_LEKB, 0);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
 		TRACE_GOTO(chip, GetEKBFinish);
 	}
 
 	retval = ms_transfer_data(chip, MS_TM_AUTO_READ, PRO_READ_LONG_DATA,
 				  3, WAIT_INT, 0, 0, buf + 4, 1536);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
 		rts51x_write_register(chip, CARD_STOP, MS_STOP | MS_CLR_ERR,
 				      MS_STOP | MS_CLR_ERR);
 		TRACE_GOTO(chip, GetEKBFinish);
 	}
 	retval = mg_check_int_error(chip);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
 		TRACE_GOTO(chip, GetEKBFinish);
 	}
 
@@ -229,7 +229,7 @@ GetEKBFinish:
   * TPC commands to the medium for writing 8-bytes data as challenge
   * by host within a short data packet.
   */
-int mg_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_mg_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
@@ -240,7 +240,7 @@ int mg_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	RTS51X_DEBUGP("--%s--\n", __func__);
 
-	ms_cleanup_work(chip);
+	rts51x_ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
@@ -248,19 +248,19 @@ int mg_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	retval = mg_send_ex_cmd(chip, MG_GET_ID, 0);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
 		TRACE_RET(chip, retval);
 	}
 
 	retval =
 	    ms_read_bytes(chip, PRO_READ_SHORT_DATA, 32, WAIT_INT, buf, 32);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
 		TRACE_RET(chip, retval);
 	}
 	retval = mg_check_int_error(chip);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
 		TRACE_RET(chip, retval);
 	}
 
@@ -276,13 +276,13 @@ int mg_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	}
 
 	if (i == 2500) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
 	retval = mg_send_ex_cmd(chip, MG_SET_RD, 0);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
 		TRACE_RET(chip, retval);
 	}
 
@@ -296,12 +296,12 @@ int mg_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	retval =
 	    ms_write_bytes(chip, PRO_WRITE_SHORT_DATA, 32, WAIT_INT, buf, 32);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
 		TRACE_RET(chip, retval);
 	}
 	retval = mg_check_int_error(chip);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
 		TRACE_RET(chip, retval);
 	}
 
@@ -320,7 +320,7 @@ int mg_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
   * The paremeter MagicGateID is the one that adapter has obtained from
   * the medium by TPC commands in Set Leaf ID command phase previously.
   */
-int mg_get_rsp_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_mg_get_rsp_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval, i;
@@ -330,7 +330,7 @@ int mg_get_rsp_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	RTS51X_DEBUGP("--%s--\n", __func__);
 
-	ms_cleanup_work(chip);
+	rts51x_ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
@@ -338,19 +338,19 @@ int mg_get_rsp_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	retval = mg_send_ex_cmd(chip, MG_MAKE_RMS, 0);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
 		TRACE_RET(chip, retval);
 	}
 
 	retval =
 	    ms_read_bytes(chip, PRO_READ_SHORT_DATA, 32, WAIT_INT, buf1, 32);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
 		TRACE_RET(chip, retval);
 	}
 	retval = mg_check_int_error(chip);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
 		TRACE_RET(chip, retval);
 	}
 
@@ -375,7 +375,7 @@ int mg_get_rsp_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	}
 
 	if (i == 2500) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
@@ -389,7 +389,7 @@ int mg_get_rsp_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip)
   * issues TPC commands to the medium for writing 8-bytes data as
   * challenge by host within a short data packet.
   */
-int mg_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_mg_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
@@ -400,7 +400,7 @@ int mg_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	RTS51X_DEBUGP("--%s--\n", __func__);
 
-	ms_cleanup_work(chip);
+	rts51x_ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
@@ -408,7 +408,7 @@ int mg_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	retval = mg_send_ex_cmd(chip, MG_MAKE_KSE, 0);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
 		TRACE_RET(chip, retval);
 	}
 
@@ -422,12 +422,12 @@ int mg_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	retval =
 	    ms_write_bytes(chip, PRO_WRITE_SHORT_DATA, 32, WAIT_INT, buf, 32);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
 		TRACE_RET(chip, retval);
 	}
 	retval = mg_check_int_error(chip);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN);
 		TRACE_RET(chip, retval);
 	}
 
@@ -447,7 +447,7 @@ int mg_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip)
   * precedes data transmission from medium to Ring buffer by DMA mechanism
   * in order to get maximum performance and minimum code size simultaneously.
   */
-int mg_get_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_mg_get_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
@@ -457,7 +457,7 @@ int mg_get_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	RTS51X_DEBUGP("--%s--\n", __func__);
 
-	ms_cleanup_work(chip);
+	rts51x_ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
@@ -474,21 +474,21 @@ int mg_get_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	retval = mg_send_ex_cmd(chip, MG_GET_IBD, ms_card->mg_entry_num);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 		TRACE_GOTO(chip, GetICVFinish);
 	}
 
 	retval = ms_transfer_data(chip, MS_TM_AUTO_READ, PRO_READ_LONG_DATA,
 				  2, WAIT_INT, 0, 0, buf + 4, 1024);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 		rts51x_write_register(chip, CARD_STOP, MS_STOP | MS_CLR_ERR,
 				      MS_STOP | MS_CLR_ERR);
 		TRACE_GOTO(chip, GetICVFinish);
 	}
 	retval = mg_check_int_error(chip);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 		TRACE_GOTO(chip, GetICVFinish);
 	}
 
@@ -511,7 +511,7 @@ GetICVFinish:
   * that sent by host, and it should be skipped by shifting DMA pointer
   * before writing 1024 bytes to medium.
   */
-int mg_set_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_mg_set_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
@@ -524,7 +524,7 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	RTS51X_DEBUGP("--%s--\n", __func__);
 
-	ms_cleanup_work(chip);
+	rts51x_ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
@@ -541,13 +541,13 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	if (retval != STATUS_SUCCESS) {
 		if (ms_card->mg_auth == 0) {
 			if ((buf[5] & 0xC0) != 0)
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
 			else
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					SENSE_TYPE_MG_WRITE_ERR);
 		} else {
-			set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
 		}
 		TRACE_GOTO(chip, SetICVFinish);
 	}
@@ -563,7 +563,7 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		rts51x_add_cmd(chip, WRITE_REG_CMD, MS_TRANS_CFG, 0xFF,
 			       WAIT_INT);
 
-		trans_dma_enable(DMA_TO_DEVICE, chip, 512, DMA_512);
+		rts51x_trans_dma_enable(DMA_TO_DEVICE, chip, 512, DMA_512);
 
 		rts51x_add_cmd(chip, WRITE_REG_CMD, MS_TRANSFER, 0xFF,
 			       MS_TRANSFER_START | MS_TM_NORMAL_WRITE);
@@ -572,7 +572,7 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 		retval = rts51x_send_cmd(chip, MODE_CDOR, 100);
 		if (retval != STATUS_SUCCESS) {
-			set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
 			TRACE_GOTO(chip, SetICVFinish);
 		}
 
@@ -583,13 +583,13 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 			rts51x_clear_ms_error(chip);
 			if (ms_card->mg_auth == 0) {
 				if ((buf[5] & 0xC0) != 0)
-					set_sense_type(chip, lun,
+					rts51x_set_sense_type(chip, lun,
 						SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
 				else
-					set_sense_type(chip, lun,
+					rts51x_set_sense_type(chip, lun,
 						SENSE_TYPE_MG_WRITE_ERR);
 			} else {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MG_WRITE_ERR);
 			}
 			retval = STATUS_FAIL;
@@ -602,13 +602,13 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 			rts51x_clear_ms_error(chip);
 			if (ms_card->mg_auth == 0) {
 				if ((buf[5] & 0xC0) != 0)
-					set_sense_type(chip, lun,
+					rts51x_set_sense_type(chip, lun,
 						SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
 				else
-					set_sense_type(chip, lun,
+					rts51x_set_sense_type(chip, lun,
 						SENSE_TYPE_MG_WRITE_ERR);
 			} else {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MG_WRITE_ERR);
 			}
 			retval = STATUS_FAIL;
@@ -622,13 +622,13 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		rts51x_clear_ms_error(chip);
 		if (ms_card->mg_auth == 0) {
 			if ((buf[5] & 0xC0) != 0)
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB);
 			else
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					SENSE_TYPE_MG_WRITE_ERR);
 		} else {
-			set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_WRITE_ERR);
 		}
 		TRACE_GOTO(chip, SetICVFinish);
 	}
diff --git a/drivers/staging/rts5139/ms_mg.h b/drivers/staging/rts5139/ms_mg.h
index e2ca550..d15733a 100644
--- a/drivers/staging/rts5139/ms_mg.h
+++ b/drivers/staging/rts5139/ms_mg.h
@@ -30,12 +30,12 @@
 #include "rts51x_chip.h"
 #include "ms.h"
 
-int mg_set_leaf_id(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-int mg_get_local_EKB(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-int mg_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-int mg_get_rsp_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-int mg_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-int mg_get_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-int mg_set_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_mg_set_leaf_id(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_mg_get_local_EKB(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_mg_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_mg_get_rsp_chg(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_mg_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_mg_get_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_mg_set_ICV(struct scsi_cmnd *srb, struct rts51x_chip *chip);
 
 #endif /* __RTS51X_MS_MG_H */
diff --git a/drivers/staging/rts5139/rts51x.c b/drivers/staging/rts5139/rts51x.c
index c3fe7dd..0421346 100644
--- a/drivers/staging/rts5139/rts51x.c
+++ b/drivers/staging/rts5139/rts51x.c
@@ -306,7 +306,7 @@ static int rts51x_control_thread(void *__chip)
 
 		/* we've got a command, let's do it! */
 		else {
-			RTS51X_DEBUG(scsi_show_command(chip->srb));
+			RTS51X_DEBUG(rts51x_scsi_show_command(chip->srb));
 			rts51x_invoke_transport(chip->srb, chip);
 		}
 
@@ -397,7 +397,7 @@ static int rts51x_polling_thread(void *__chip)
 		}
 #endif
 
-		mspro_polling_format_status(chip);
+		rts51x_mspro_polling_format_status(chip);
 
 		/* lock the device pointers */
 		mutex_lock(&(chip->usb->dev_mutex));
@@ -478,7 +478,7 @@ static void rts51x_init_options(struct rts51x_chip *chip)
 {
 	struct rts51x_option *option = &(chip->option);
 
-	option->mspro_formatter_enable = 1;
+	option->rts51x_mspro_formatter_enable = 1;
 
 	option->fpga_sd_sdr104_clk = CLK_100;
 	option->fpga_sd_sdr50_clk = CLK_100;
@@ -510,7 +510,7 @@ static void rts51x_init_options(struct rts51x_chip *chip)
 
 	option->FT2_fast_mode = 0;
 	option->pwr_delay = 800;
-	option->xd_rw_step = 0;
+	option->rts51x_xd_rw_step = 0;
 	option->D3318_off_delay = 50;
 	option->delink_delay = 100;
 	option->rts5129_D3318_off_enable = 0;
@@ -518,7 +518,7 @@ static void rts51x_init_options(struct rts51x_chip *chip)
 	option->reset_or_rw_fail_set_pad_drive = 1;
 	option->debounce_num = 2;
 	option->led_toggle_interval = 6;
-	option->xd_rwn_step = 0;
+	option->rts51x_xd_rwn_step = 0;
 	option->sd_send_status_en = 0;
 	option->sdr50_tx_phase = 0x01;
 	option->sdr50_rx_phase = 0x05;
diff --git a/drivers/staging/rts5139/rts51x_card.c b/drivers/staging/rts5139/rts51x_card.c
index 50be42a..509d83e 100644
--- a/drivers/staging/rts5139/rts51x_card.c
+++ b/drivers/staging/rts5139/rts51x_card.c
@@ -41,7 +41,7 @@
 #include "sd.h"
 #include "ms.h"
 
-void do_remaining_work(struct rts51x_chip *chip)
+void rts51x_do_remaining_work(struct rts51x_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	struct xd_info *xd_card = &(chip->xd_card);
@@ -84,27 +84,27 @@ void do_remaining_work(struct rts51x_chip *chip)
 	}
 
 	if (sd_card->counter > POLLING_WAIT_CNT)
-		sd_cleanup_work(chip);
+		rts51x_sd_cleanup_work(chip);
 
 	if (xd_card->counter > POLLING_WAIT_CNT)
-		xd_cleanup_work(chip);
+		rts51x_xd_cleanup_work(chip);
 
 	if (ms_card->counter > POLLING_WAIT_CNT)
-		ms_cleanup_work(chip);
+		rts51x_ms_cleanup_work(chip);
 }
 
-static void do_reset_xd_card(struct rts51x_chip *chip)
+static void do_rts51x_reset_xd_card(struct rts51x_chip *chip)
 {
 	int retval;
 
 	if (chip->card2lun[XD_CARD] >= MAX_ALLOWED_LUN_CNT)
 		return;
 
-	retval = reset_xd_card(chip);
+	retval = rts51x_reset_xd_card(chip);
 	if (retval == STATUS_SUCCESS) {
 		chip->card_ready |= XD_CARD;
 		chip->card_fail &= ~XD_CARD;
-		chip->rw_card[chip->card2lun[XD_CARD]] = xd_rw;
+		chip->rw_card[chip->card2lun[XD_CARD]] = rts51x_xd_rw;
 	} else {
 		chip->card_ready &= ~XD_CARD;
 		chip->card_fail |= XD_CARD;
@@ -120,18 +120,18 @@ static void do_reset_xd_card(struct rts51x_chip *chip)
 	}
 }
 
-void do_reset_sd_card(struct rts51x_chip *chip)
+void rts51x_do_rts51x_reset_sd_card(struct rts51x_chip *chip)
 {
 	int retval;
 
 	if (chip->card2lun[SD_CARD] >= MAX_ALLOWED_LUN_CNT)
 		return;
 
-	retval = reset_sd_card(chip);
+	retval = rts51x_reset_sd_card(chip);
 	if (retval == STATUS_SUCCESS) {
 		chip->card_ready |= SD_CARD;
 		chip->card_fail &= ~SD_CARD;
-		chip->rw_card[chip->card2lun[SD_CARD]] = sd_rw;
+		chip->rw_card[chip->card2lun[SD_CARD]] = rts51x_sd_rw;
 	} else {
 		chip->card_ready &= ~SD_CARD;
 		chip->card_fail |= SD_CARD;
@@ -147,18 +147,18 @@ void do_reset_sd_card(struct rts51x_chip *chip)
 	}
 }
 
-static void do_reset_ms_card(struct rts51x_chip *chip)
+static void do_rts51x_reset_ms_card(struct rts51x_chip *chip)
 {
 	int retval;
 
 	if (chip->card2lun[MS_CARD] >= MAX_ALLOWED_LUN_CNT)
 		return;
 
-	retval = reset_ms_card(chip);
+	retval = rts51x_reset_ms_card(chip);
 	if (retval == STATUS_SUCCESS) {
 		chip->card_ready |= MS_CARD;
 		chip->card_fail &= ~MS_CARD;
-		chip->rw_card[chip->card2lun[MS_CARD]] = ms_rw;
+		chip->rw_card[chip->card2lun[MS_CARD]] = rts51x_ms_rw;
 	} else {
 		chip->card_ready &= ~MS_CARD;
 		chip->card_fail |= MS_CARD;
@@ -301,7 +301,7 @@ void rts51x_init_cards(struct rts51x_chip *chip)
 			chip->card_exist &= ~XD_CARD;
 			chip->card_ejected = 0;
 			if (chip->card_ready & XD_CARD) {
-				release_xd_card(chip);
+				rts51x_release_xd_card(chip);
 				chip->rw_card[chip->card2lun[XD_CARD]] = NULL;
 				clear_bit(chip->card2lun[XD_CARD],
 					  &(chip->lun_mc));
@@ -312,7 +312,7 @@ void rts51x_init_cards(struct rts51x_chip *chip)
 			chip->card_exist &= ~SD_CARD;
 			chip->card_ejected = 0;
 			if (chip->card_ready & SD_CARD) {
-				release_sd_card(chip);
+				rts51x_release_sd_card(chip);
 				chip->rw_card[chip->card2lun[SD_CARD]] = NULL;
 				clear_bit(chip->card2lun[SD_CARD],
 					  &(chip->lun_mc));
@@ -323,7 +323,7 @@ void rts51x_init_cards(struct rts51x_chip *chip)
 			chip->card_exist &= ~MS_CARD;
 			chip->card_ejected = 0;
 			if (chip->card_ready & MS_CARD) {
-				release_ms_card(chip);
+				rts51x_release_ms_card(chip);
 				chip->rw_card[chip->card2lun[MS_CARD]] = NULL;
 				clear_bit(chip->card2lun[MS_CARD],
 					  &(chip->lun_mc));
@@ -339,13 +339,13 @@ void rts51x_init_cards(struct rts51x_chip *chip)
 
 		if (need_reset & XD_CARD) {
 			chip->card_exist |= XD_CARD;
-			do_reset_xd_card(chip);
+			do_rts51x_reset_xd_card(chip);
 		} else if (need_reset & SD_CARD) {
 			chip->card_exist |= SD_CARD;
-			do_reset_sd_card(chip);
+			rts51x_do_rts51x_reset_sd_card(chip);
 		} else if (need_reset & MS_CARD) {
 			chip->card_exist |= MS_CARD;
-			do_reset_ms_card(chip);
+			do_rts51x_reset_ms_card(chip);
 		}
 	}
 }
@@ -353,20 +353,20 @@ void rts51x_init_cards(struct rts51x_chip *chip)
 void rts51x_release_cards(struct rts51x_chip *chip)
 {
 	if (chip->card_ready & SD_CARD) {
-		sd_cleanup_work(chip);
-		release_sd_card(chip);
+		rts51x_sd_cleanup_work(chip);
+		rts51x_release_sd_card(chip);
 		chip->card_ready &= ~SD_CARD;
 	}
 
 	if (chip->card_ready & XD_CARD) {
-		xd_cleanup_work(chip);
-		release_xd_card(chip);
+		rts51x_xd_cleanup_work(chip);
+		rts51x_release_xd_card(chip);
 		chip->card_ready &= ~XD_CARD;
 	}
 
 	if (chip->card_ready & MS_CARD) {
-		ms_cleanup_work(chip);
-		release_ms_card(chip);
+		rts51x_ms_cleanup_work(chip);
+		rts51x_release_ms_card(chip);
 		chip->card_ready &= ~MS_CARD;
 	}
 }
@@ -376,7 +376,7 @@ static inline u8 double_depth(u8 depth)
 	return ((depth > 1) ? (depth - 1) : depth);
 }
 
-int switch_ssc_clock(struct rts51x_chip *chip, int clk)
+int rts51x_switch_ssc_clock(struct rts51x_chip *chip, int clk)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	struct ms_info *ms_card = &(chip->ms_card);
@@ -513,7 +513,7 @@ int switch_ssc_clock(struct rts51x_chip *chip, int clk)
 	return STATUS_SUCCESS;
 }
 
-int switch_normal_clock(struct rts51x_chip *chip, int clk)
+int rts51x_switch_normal_clock(struct rts51x_chip *chip, int clk)
 {
 	int retval;
 	u8 sel, div, mcu_cnt;
@@ -653,7 +653,7 @@ int switch_normal_clock(struct rts51x_chip *chip, int clk)
 	return STATUS_SUCCESS;
 }
 
-int card_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 sec_addr,
+int rts51x_card_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 sec_addr,
 	    u16 sec_cnt)
 {
 	int retval;
@@ -688,7 +688,7 @@ int card_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 sec_addr,
 	return retval;
 }
 
-u8 get_lun_card(struct rts51x_chip *chip, unsigned int lun)
+u8 rts51x_get_lun_card(struct rts51x_chip *chip, unsigned int lun)
 {
 	if ((chip->card_ready & chip->lun2card[lun]) == XD_CARD)
 		return (u8) XD_CARD;
@@ -744,24 +744,24 @@ int rts51x_select_card(struct rts51x_chip *chip, int card)
 	return STATUS_SUCCESS;
 }
 
-void eject_card(struct rts51x_chip *chip, unsigned int lun)
+void rts51x_eject_card(struct rts51x_chip *chip, unsigned int lun)
 {
 	RTS51X_DEBUGP("eject card\n");
 	RTS51X_SET_STAT(chip, STAT_RUN);
-	do_remaining_work(chip);
+	rts51x_do_remaining_work(chip);
 
 	if ((chip->card_ready & chip->lun2card[lun]) == SD_CARD) {
-		release_sd_card(chip);
+		rts51x_release_sd_card(chip);
 		chip->card_ejected |= SD_CARD;
 		chip->card_ready &= ~SD_CARD;
 		chip->capacity[lun] = 0;
 	} else if ((chip->card_ready & chip->lun2card[lun]) == XD_CARD) {
-		release_xd_card(chip);
+		rts51x_release_xd_card(chip);
 		chip->card_ejected |= XD_CARD;
 		chip->card_ready &= ~XD_CARD;
 		chip->capacity[lun] = 0;
 	} else if ((chip->card_ready & chip->lun2card[lun]) == MS_CARD) {
-		release_ms_card(chip);
+		rts51x_release_ms_card(chip);
 		chip->card_ejected |= MS_CARD;
 		chip->card_ready &= ~MS_CARD;
 		chip->capacity[lun] = 0;
@@ -770,7 +770,7 @@ void eject_card(struct rts51x_chip *chip, unsigned int lun)
 			      XD_INT | MS_INT | SD_INT);
 }
 
-void trans_dma_enable(enum dma_data_direction dir, struct rts51x_chip *chip,
+void rts51x_trans_dma_enable(enum dma_data_direction dir, struct rts51x_chip *chip,
 		      u32 byte_cnt, u8 pack_size)
 {
 	if (pack_size > DMA_1024)
@@ -798,7 +798,7 @@ void trans_dma_enable(enum dma_data_direction dir, struct rts51x_chip *chip,
 	}
 }
 
-int enable_card_clock(struct rts51x_chip *chip, u8 card)
+int rts51x_enable_card_clock(struct rts51x_chip *chip, u8 card)
 {
 	u8 clk_en = 0;
 
@@ -814,7 +814,7 @@ int enable_card_clock(struct rts51x_chip *chip, u8 card)
 	return STATUS_SUCCESS;
 }
 
-int card_power_on(struct rts51x_chip *chip, u8 card)
+int rts51x_card_power_on(struct rts51x_chip *chip, u8 card)
 {
 	u8 mask, val1, val2;
 
@@ -863,7 +863,7 @@ int monitor_card_cd(struct rts51x_chip *chip, u8 card)
 	return CD_NOT_EXIST;
 }
 
-int toggle_gpio(struct rts51x_chip *chip, u8 gpio)
+int rts51x_toggle_gpio(struct rts51x_chip *chip, u8 gpio)
 {
 	int retval;
 	u8 temp_reg;
@@ -898,7 +898,7 @@ int toggle_gpio(struct rts51x_chip *chip, u8 gpio)
 	return STATUS_SUCCESS;
 }
 
-int turn_on_led(struct rts51x_chip *chip, u8 gpio)
+int rts51x_turn_on_led(struct rts51x_chip *chip, u8 gpio)
 {
 	int retval;
 	u8 gpio_oe[4] = {
@@ -917,7 +917,7 @@ int turn_on_led(struct rts51x_chip *chip, u8 gpio)
 	return STATUS_SUCCESS;
 }
 
-int turn_off_led(struct rts51x_chip *chip, u8 gpio)
+int rts51x_turn_off_led(struct rts51x_chip *chip, u8 gpio)
 {
 	int retval;
 	u8 gpio_output[4] = {
diff --git a/drivers/staging/rts5139/rts51x_card.h b/drivers/staging/rts5139/rts51x_card.h
index c5c03cc..e62b25c 100644
--- a/drivers/staging/rts5139/rts51x_card.h
+++ b/drivers/staging/rts5139/rts51x_card.h
@@ -737,24 +737,24 @@
 
 int monitor_card_cd(struct rts51x_chip *chip, u8 card);
 
-void do_remaining_work(struct rts51x_chip *chip);
-void do_reset_sd_card(struct rts51x_chip *chip);
+void rts51x_do_remaining_work(struct rts51x_chip *chip);
+void rts51x_do_rts51x_reset_sd_card(struct rts51x_chip *chip);
 void rts51x_init_cards(struct rts51x_chip *chip);
 void rts51x_release_cards(struct rts51x_chip *chip);
-int switch_ssc_clock(struct rts51x_chip *chip, int clk);
-int switch_normal_clock(struct rts51x_chip *chip, int clk);
-int card_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 sec_addr,
+int rts51x_switch_ssc_clock(struct rts51x_chip *chip, int clk);
+int rts51x_switch_normal_clock(struct rts51x_chip *chip, int clk);
+int rts51x_card_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 sec_addr,
 	    u16 sec_cnt);
-u8 get_lun_card(struct rts51x_chip *chip, unsigned int lun);
+u8 rts51x_get_lun_card(struct rts51x_chip *chip, unsigned int lun);
 int rts51x_select_card(struct rts51x_chip *chip, int card);
-void eject_card(struct rts51x_chip *chip, unsigned int lun);
-void trans_dma_enable(enum dma_data_direction dir, struct rts51x_chip *chip,
+void rts51x_eject_card(struct rts51x_chip *chip, unsigned int lun);
+void rts51x_trans_dma_enable(enum dma_data_direction dir, struct rts51x_chip *chip,
 		      u32 byte_cnt, u8 pack_size);
-int enable_card_clock(struct rts51x_chip *chip, u8 card);
-int card_power_on(struct rts51x_chip *chip, u8 card);
-int toggle_gpio(struct rts51x_chip *chip, u8 gpio);
-int turn_on_led(struct rts51x_chip *chip, u8 gpio);
-int turn_off_led(struct rts51x_chip *chip, u8 gpio);
+int rts51x_enable_card_clock(struct rts51x_chip *chip, u8 card);
+int rts51x_card_power_on(struct rts51x_chip *chip, u8 card);
+int rts51x_toggle_gpio(struct rts51x_chip *chip, u8 gpio);
+int rts51x_turn_on_led(struct rts51x_chip *chip, u8 gpio);
+int rts51x_turn_off_led(struct rts51x_chip *chip, u8 gpio);
 
 static inline int check_card_ready(struct rts51x_chip *chip, unsigned int lun)
 {
@@ -830,9 +830,9 @@ static inline int switch_clock(struct rts51x_chip *chip, int clk)
 	int retval = 0;
 
 	if (chip->asic_code)
-		retval = switch_ssc_clock(chip, clk);
+		retval = rts51x_switch_ssc_clock(chip, clk);
 	else
-		retval = switch_normal_clock(chip, clk);
+		retval = rts51x_switch_normal_clock(chip, clk);
 
 	return retval;
 }
diff --git a/drivers/staging/rts5139/rts51x_chip.c b/drivers/staging/rts5139/rts51x_chip.c
index 08dcae8..7d7510d 100644
--- a/drivers/staging/rts5139/rts51x_chip.c
+++ b/drivers/staging/rts5139/rts51x_chip.c
@@ -132,7 +132,7 @@ int rts51x_reset_chip(struct rts51x_chip *chip)
 	}
 #endif
 	if (chip->option.FT2_fast_mode) {
-		card_power_on(chip, SD_CARD | MS_CARD | XD_CARD);
+		rts51x_card_power_on(chip, SD_CARD | MS_CARD | XD_CARD);
 		wait_timeout(10);
 	}
 
@@ -212,8 +212,8 @@ int rts51x_init_chip(struct rts51x_chip *chip)
 
 int rts51x_release_chip(struct rts51x_chip *chip)
 {
-	xd_free_l2p_tbl(chip);
-	ms_free_l2p_tbl(chip);
+	rts51x_xd_free_l2p_tbl(chip);
+	rts51x_ms_free_l2p_tbl(chip);
 	chip->card_ready = 0;
 	return STATUS_SUCCESS;
 }
@@ -227,7 +227,7 @@ static inline void rts51x_blink_led(struct rts51x_chip *chip)
 			chip->led_toggle_counter++;
 		} else {
 			chip->led_toggle_counter = 0;
-			toggle_gpio(chip, LED_GPIO);
+			rts51x_toggle_gpio(chip, LED_GPIO);
 		}
 	}
 }
@@ -325,14 +325,14 @@ void rts51x_polling_func(struct rts51x_chip *chip)
 			    && (chip->card_exist &
 				(SD_CARD | MS_CARD | XD_CARD))
 			    && (!chip->card_ejected)) {
-				turn_on_led(chip, LED_GPIO);
+				rts51x_turn_on_led(chip, LED_GPIO);
 			} else {
 				if (chip->rts5179) {
 					rts51x_ep0_write_register(chip,
 								  CARD_GPIO,
 								  0x03, 0x00);
 				} else {
-					turn_off_led(chip, LED_GPIO);
+					rts51x_turn_off_led(chip, LED_GPIO);
 				}
 
 			}
@@ -353,7 +353,7 @@ void rts51x_polling_func(struct rts51x_chip *chip)
 	switch (RTS51X_GET_STAT(chip)) {
 	case STAT_RUN:
 		rts51x_blink_led(chip);
-		do_remaining_work(chip);
+		rts51x_do_remaining_work(chip);
 		break;
 
 	case STAT_IDLE:
@@ -707,7 +707,7 @@ void rts51x_do_before_power_down(struct rts51x_chip *chip)
 	if (chip->rts5179)
 		rts51x_ep0_write_register(chip, CARD_GPIO, 0x03, 0x00);
 	else
-		turn_off_led(chip, LED_GPIO);
+		rts51x_turn_off_led(chip, LED_GPIO);
 
 	chip->cur_clk = 0;
 	chip->card_exist = 0;
@@ -797,7 +797,7 @@ void rts51x_pp_status(struct rts51x_chip *chip, unsigned int lun, u8 *status,
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	struct ms_info *ms_card = &(chip->ms_card);
-	u8 card = get_lun_card(chip, lun);
+	u8 card = rts51x_get_lun_card(chip, lun);
 #ifdef SUPPORT_OC
 	u8 oc_now_mask = 0, oc_ever_mask = 0;
 #endif
@@ -958,9 +958,9 @@ void rts51x_read_status(struct rts51x_chip *chip, unsigned int lun,
 		rts51x_status[12] = 0;
 
 	/* Detailed Type */
-	if (get_lun_card(chip, lun) == XD_CARD) {
+	if (rts51x_get_lun_card(chip, lun) == XD_CARD) {
 		rts51x_status[13] = 0x40;
-	} else if (get_lun_card(chip, lun) == SD_CARD) {
+	} else if (rts51x_get_lun_card(chip, lun) == SD_CARD) {
 		struct sd_info *sd_card = &(chip->sd_card);
 
 		rts51x_status[13] = 0x20;
@@ -976,7 +976,7 @@ void rts51x_read_status(struct rts51x_chip *chip, unsigned int lun,
 			if (CHK_MMC_SECTOR_MODE(sd_card))
 				rts51x_status[13] |= 0x04; /* Hi capacity */
 		}
-	} else if (get_lun_card(chip, lun) == MS_CARD) {
+	} else if (rts51x_get_lun_card(chip, lun) == MS_CARD) {
 		struct ms_info *ms_card = &(chip->ms_card);
 
 		if (CHK_MSPRO(ms_card)) {
diff --git a/drivers/staging/rts5139/rts51x_chip.h b/drivers/staging/rts5139/rts51x_chip.h
index 64257ca..12deb24 100644
--- a/drivers/staging/rts5139/rts51x_chip.h
+++ b/drivers/staging/rts5139/rts51x_chip.h
@@ -253,7 +253,7 @@ struct sense_data_t {
 #define SUPPORT_UHS50_MMC44		0x40
 
 struct rts51x_option {
-	int mspro_formatter_enable;
+	int rts51x_mspro_formatter_enable;
 
 	/* card clock expected by user for fpga platform */
 	int fpga_sd_sdr104_clk;
@@ -308,7 +308,7 @@ struct rts51x_option {
 	 * add for config delay between 1/4 PMOS and 3/4 PMOS */
 	int pwr_delay;
 
-	int xd_rw_step;		/* add to tune xd tRP */
+	int rts51x_xd_rw_step;		/* add to tune xd tRP */
 	int D3318_off_delay;	/* add to tune D3318 off delay time */
 	int delink_delay;	/* add to tune delink delay time */
 	/* add for rts5129 to enable/disable D3318 off */
@@ -320,7 +320,7 @@ struct rts51x_option {
 
 	u8 debounce_num;	/* debounce number */
 	u8 led_toggle_interval;	/* used to control led toggle speed */
-	int xd_rwn_step;
+	int rts51x_xd_rwn_step;
 	u8 sd_send_status_en;
 	/* used to store default phase which is
 	 * used when phase tune all pass. */
@@ -337,11 +337,11 @@ struct rts51x_option {
 	u8 dv18_voltage;	/* add to tune dv18 voltage */
 };
 
-#define MS_FORMATTER_ENABLED(chip)	((chip)->option.mspro_formatter_enable)
+#define MS_FORMATTER_ENABLED(chip)	((chip)->option.rts51x_mspro_formatter_enable)
 
 struct rts51x_chip;
 
-typedef int (*card_rw_func) (struct scsi_cmnd *srb, struct rts51x_chip *chip,
+typedef int (*rts51x_card_rw_func) (struct scsi_cmnd *srb, struct rts51x_chip *chip,
 			     u32 sec_addr, u16 sec_cnt);
 
 /* For MS Card */
@@ -564,7 +564,7 @@ struct sd_info {
 #define CHK_MS8BIT(ms_card)	(((ms_card)->ms_type & MS_8BIT))
 #define CHK_MS4BIT(ms_card)	(((ms_card)->ms_type & MS_4BIT))
 
-struct ms_delay_write_tag {
+struct rts51x_ms_delay_write_tag {
 	u16 old_phyblock;
 	u16 new_phyblock;
 	u16 logblock;
@@ -605,7 +605,7 @@ struct ms_info {
 	u32 total_sec_cnt;
 	u8 last_rw_int;
 
-	struct ms_delay_write_tag delay_write;
+	struct rts51x_ms_delay_write_tag delay_write;
 
 	int counter;
 
@@ -671,7 +671,7 @@ struct rts51x_chip {
 	u32 capacity[MAX_ALLOWED_LUN_CNT];
 
 	/* read/write card function pointer */
-	card_rw_func rw_card[MAX_ALLOWED_LUN_CNT];
+	rts51x_card_rw_func rw_card[MAX_ALLOWED_LUN_CNT];
 	/* read/write capacity, used for GPIO Toggle */
 	u32 rw_cap[MAX_ALLOWED_LUN_CNT];
 	/* card to lun mapping table */
diff --git a/drivers/staging/rts5139/rts51x_fop.c b/drivers/staging/rts5139/rts51x_fop.c
index bf1a9e6..dee7d8a 100644
--- a/drivers/staging/rts5139/rts51x_fop.c
+++ b/drivers/staging/rts5139/rts51x_fop.c
@@ -70,7 +70,7 @@ static int rts51x_sd_direct_cmnd(struct rts51x_chip *chip,
 	switch (dir) {
 	case 0:
 		/* No data */
-		retval = ext_sd_execute_no_data(chip, chip->card2lun[SD_CARD],
+		retval = ext_rts51x_sd_execute_no_data(chip, chip->card2lun[SD_CARD],
 						cmd_idx, standby, acmd,
 						rsp_code, arg);
 		if (retval != TRANSPORT_GOOD)
@@ -83,7 +83,7 @@ static int rts51x_sd_direct_cmnd(struct rts51x_chip *chip,
 		if (!buf)
 			TRACE_RET(chip, STATUS_NOMEM);
 
-		retval = ext_sd_execute_read_data(chip, chip->card2lun[SD_CARD],
+		retval = ext_rts51x_sd_execute_read_data(chip, chip->card2lun[SD_CARD],
 						  cmd_idx, cmd12, standby, acmd,
 						  rsp_code, arg, len, buf,
 						  cmnd->buf_len, 0);
@@ -117,7 +117,7 @@ static int rts51x_sd_direct_cmnd(struct rts51x_chip *chip,
 		}
 
 		retval =
-		    ext_sd_execute_write_data(chip, chip->card2lun[SD_CARD],
+		    ext_rts51x_sd_execute_write_data(chip, chip->card2lun[SD_CARD],
 					      cmd_idx, cmd12, standby, acmd,
 					      rsp_code, arg, len, buf,
 					      cmnd->buf_len, 0);
diff --git a/drivers/staging/rts5139/rts51x_scsi.c b/drivers/staging/rts5139/rts51x_scsi.c
index e07a1f4..052911c 100644
--- a/drivers/staging/rts5139/rts51x_scsi.c
+++ b/drivers/staging/rts5139/rts51x_scsi.c
@@ -44,7 +44,7 @@
 #include "ms_mg.h"
 #include "trace.h"
 
-void scsi_show_command(struct scsi_cmnd *srb)
+void rts51x_scsi_show_command(struct scsi_cmnd *srb)
 {
 	char *what = NULL;
 	int i, unknown_cmd = 0;
@@ -333,72 +333,72 @@ void scsi_show_command(struct scsi_cmnd *srb)
 	}
 }
 
-void set_sense_type(struct rts51x_chip *chip, unsigned int lun, int sense_type)
+void rts51x_set_sense_type(struct rts51x_chip *chip, unsigned int lun, int sense_type)
 {
 	switch (sense_type) {
 	case SENSE_TYPE_MEDIA_CHANGE:
-		set_sense_data(chip, lun, CUR_ERR, 0x06, 0, 0x28, 0, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x06, 0, 0x28, 0, 0, 0);
 		break;
 
 	case SENSE_TYPE_MEDIA_NOT_PRESENT:
-		set_sense_data(chip, lun, CUR_ERR, 0x02, 0, 0x3A, 0, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x02, 0, 0x3A, 0, 0, 0);
 		break;
 
 	case SENSE_TYPE_MEDIA_LBA_OVER_RANGE:
-		set_sense_data(chip, lun, CUR_ERR, 0x05, 0, 0x21, 0, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x05, 0, 0x21, 0, 0, 0);
 		break;
 
 	case SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT:
-		set_sense_data(chip, lun, CUR_ERR, 0x05, 0, 0x25, 0, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x05, 0, 0x25, 0, 0, 0);
 		break;
 
 	case SENSE_TYPE_MEDIA_WRITE_PROTECT:
-		set_sense_data(chip, lun, CUR_ERR, 0x07, 0, 0x27, 0, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x07, 0, 0x27, 0, 0, 0);
 		break;
 
 	case SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR:
-		set_sense_data(chip, lun, CUR_ERR, 0x03, 0, 0x11, 0, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x03, 0, 0x11, 0, 0, 0);
 		break;
 
 	case SENSE_TYPE_MEDIA_WRITE_ERR:
-		set_sense_data(chip, lun, CUR_ERR, 0x03, 0, 0x0C, 0x02, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x03, 0, 0x0C, 0x02, 0, 0);
 		break;
 
 	case SENSE_TYPE_MEDIA_INVALID_CMD_FIELD:
-		set_sense_data(chip, lun, CUR_ERR, ILGAL_REQ, 0,
+		rts51x_set_sense_data(chip, lun, CUR_ERR, ILGAL_REQ, 0,
 			       ASC_INVLD_CDB, ASCQ_INVLD_CDB, CDB_ILLEGAL, 1);
 		break;
 
 	case SENSE_TYPE_FORMAT_CMD_FAILED:
-		set_sense_data(chip, lun, CUR_ERR, 0x03, 0, 0x31, 0x01, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x03, 0, 0x31, 0x01, 0, 0);
 		break;
 
 #ifdef SUPPORT_MAGIC_GATE
 	case SENSE_TYPE_MG_KEY_FAIL_NOT_ESTAB:
-		set_sense_data(chip, lun, CUR_ERR, 0x05, 0, 0x6F, 0x02, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x05, 0, 0x6F, 0x02, 0, 0);
 		break;
 
 	case SENSE_TYPE_MG_KEY_FAIL_NOT_AUTHEN:
-		set_sense_data(chip, lun, CUR_ERR, 0x05, 0, 0x6F, 0x00, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x05, 0, 0x6F, 0x00, 0, 0);
 		break;
 
 	case SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM:
-		set_sense_data(chip, lun, CUR_ERR, 0x02, 0, 0x30, 0x00, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x02, 0, 0x30, 0x00, 0, 0);
 		break;
 
 	case SENSE_TYPE_MG_WRITE_ERR:
-		set_sense_data(chip, lun, CUR_ERR, 0x03, 0, 0x0C, 0x00, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0x03, 0, 0x0C, 0x00, 0, 0);
 		break;
 #endif
 
 	case SENSE_TYPE_NO_SENSE:
 	default:
-		set_sense_data(chip, lun, CUR_ERR, 0, 0, 0, 0, 0, 0);
+		rts51x_set_sense_data(chip, lun, CUR_ERR, 0, 0, 0, 0, 0, 0);
 		break;
 	}
 }
 
-void set_sense_data(struct rts51x_chip *chip, unsigned int lun, u8 err_code,
+void rts51x_set_sense_data(struct rts51x_chip *chip, unsigned int lun, u8 err_code,
 		    u8 sense_key, u32 info, u8 asc, u8 ascq, u8 sns_key_info0,
 		    u16 sns_key_info1)
 {
@@ -428,13 +428,13 @@ static int test_unit_ready(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	rts51x_init_cards(chip);
 
 	if (!check_card_ready(chip, lun)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		return TRANSPORT_FAILED;
 	}
 
 	if (!check_lun_mc(chip, lun)) {
 		set_lun_mc(chip, lun);
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
 		return TRANSPORT_FAILED;
 	}
 
@@ -457,7 +457,7 @@ static int inquiry(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	char *inquiry_string;
 	unsigned char sendbytes;
 	unsigned char *buf;
-	u8 card = get_lun_card(chip, lun);
+	u8 card = rts51x_get_lun_card(chip, lun);
 	int pro_formatter_flag = 0;
 	unsigned char inquiry_buf[] = {
 		QULIFIRE | DRCT_ACCESS_DEV,
@@ -532,7 +532,7 @@ static int start_stop_unit(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	case UNLOAD_MEDIUM:
 		/* Media shall be unload */
 		if (check_card_ready(chip, lun))
-			eject_card(chip, lun);
+			rts51x_eject_card(chip, lun);
 		return TRANSPORT_GOOD;
 
 	case MAKE_MEDIUM_READY:
@@ -540,7 +540,7 @@ static int start_stop_unit(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		if (check_card_ready(chip, lun)) {
 			return TRANSPORT_GOOD;
 		} else {
-			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
 
@@ -559,7 +559,7 @@ static int allow_medium_removal(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	scsi_set_resid(srb, 0);
 
 	if (prevent) {
-		set_sense_type(chip, SCSI_LUN(srb),
+		rts51x_set_sense_type(chip, SCSI_LUN(srb),
 			       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
@@ -663,10 +663,10 @@ static int mode_sense(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	int status;
 	int pro_formatter_flag;
 	unsigned char pageCode, *buf;
-	u8 card = get_lun_card(chip, lun);
+	u8 card = rts51x_get_lun_card(chip, lun);
 
 	if (!check_card_ready(chip, lun)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		scsi_set_resid(srb, scsi_bufflen(srb));
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
@@ -678,7 +678,7 @@ static int mode_sense(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	if ((get_lun2card(chip, lun) & MS_CARD)) {
 		if (!card || (card == MS_CARD)) {
 			dataSize = 108;
-			if (chip->option.mspro_formatter_enable)
+			if (chip->option.rts51x_mspro_formatter_enable)
 				pro_formatter_flag = 1;
 		}
 	}
@@ -725,7 +725,7 @@ static int mode_sense(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		}
 		status = TRANSPORT_GOOD;
 	} else {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		scsi_set_resid(srb, scsi_bufflen(srb));
 		status = TRANSPORT_FAILED;
 	}
@@ -749,9 +749,9 @@ static int request_sense(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	sense = &(chip->sense_buffer[lun]);
 
-	if ((get_lun_card(chip, lun) == MS_CARD)
+	if ((rts51x_get_lun_card(chip, lun) == MS_CARD)
 	    && PRO_UNDER_FORMATTING(ms_card)) {
-		mspro_format_sense(chip, lun);
+		rts51x_mspro_format_sense(chip, lun);
 	}
 
 	buf = vmalloc(scsi_bufflen(srb));
@@ -766,7 +766,7 @@ static int request_sense(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	scsi_set_resid(srb, 0);
 	/* Reset Sense Data */
-	set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
+	rts51x_set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
 	return TRANSPORT_GOOD;
 }
 
@@ -778,13 +778,13 @@ static int read_write(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	u16 sec_cnt;
 
 	if (!check_card_ready(chip, lun) || (chip->capacity[lun] == 0)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (!check_lun_mc(chip, lun)) {
 		set_lun_mc(chip, lun);
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
 		return TRANSPORT_FAILED;
 	}
 
@@ -812,13 +812,13 @@ static int read_write(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 			((u32) srb->cmnd[7]);
 		sec_cnt = ((u16) (srb->cmnd[9]) << 8) | srb->cmnd[10];
 	} else {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if ((start_sec > chip->capacity[lun]) ||
 	    ((start_sec + sec_cnt) > chip->capacity[lun])) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LBA_OVER_RANGE);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LBA_OVER_RANGE);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -830,17 +830,17 @@ static int read_write(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	if ((srb->sc_data_direction == DMA_TO_DEVICE)
 	    && check_card_wp(chip, lun)) {
 		RTS51X_DEBUGP("Write protected card!\n");
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_PROTECT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_PROTECT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
-	retval = card_rw(srb, chip, start_sec, sec_cnt);
+	retval = rts51x_card_rw(srb, chip, start_sec, sec_cnt);
 	if (retval != STATUS_SUCCESS) {
 		if (srb->sc_data_direction == DMA_FROM_DEVICE) {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 		} else {
-			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
 		}
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
@@ -855,13 +855,13 @@ static int read_format_capacity(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	unsigned char *buf;
 	unsigned int lun = SCSI_LUN(srb);
 	unsigned int buf_len;
-	u8 card = get_lun_card(chip, lun);
+	u8 card = rts51x_get_lun_card(chip, lun);
 	int desc_cnt;
 	int i = 0;
 
 	if (!check_card_ready(chip, lun)) {
-		if (!chip->option.mspro_formatter_enable) {
-			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		if (!chip->option.rts51x_mspro_formatter_enable) {
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
 	}
@@ -877,7 +877,7 @@ static int read_format_capacity(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	buf[i++] = 0;
 
 	/* Capacity List Length */
-	if ((buf_len > 12) && chip->option.mspro_formatter_enable &&
+	if ((buf_len > 12) && chip->option.rts51x_mspro_formatter_enable &&
 	    (chip->lun2card[lun] & MS_CARD) && (!card || (card == MS_CARD))) {
 		buf[i++] = 0x10;
 		desc_cnt = 2;
@@ -933,13 +933,13 @@ static int read_capacity(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 
 	if (!check_card_ready(chip, lun)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (!check_lun_mc(chip, lun)) {
 		set_lun_mc(chip, lun);
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
 		return TRANSPORT_FAILED;
 	}
 
@@ -1021,7 +1021,7 @@ static int read_mem(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		retval = rts51x_ep0_read_register(chip, addr + i, buf + i);
 		if (retval != STATUS_SUCCESS) {
 			vfree(buf);
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
@@ -1066,7 +1066,7 @@ static int write_mem(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		    rts51x_ep0_write_register(chip, addr + i, 0xFF, buf[i]);
 		if (retval != STATUS_SUCCESS) {
 			vfree(buf);
-			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
 	}
@@ -1083,12 +1083,12 @@ static int get_sd_csd(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 
 	if (!check_card_ready(chip, lun)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
-	if (get_lun_card(chip, lun) != SD_CARD) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
+	if (rts51x_get_lun_card(chip, lun) != SD_CARD) {
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1120,7 +1120,7 @@ static int read_phy_register(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 			    rts51x_read_phy_register(chip, addr + i, buf + i);
 			if (retval != STATUS_SUCCESS) {
 				vfree(buf);
-				set_sense_type(chip, SCSI_LUN(srb),
+				rts51x_set_sense_type(chip, SCSI_LUN(srb),
 					SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 				TRACE_RET(chip, TRANSPORT_FAILED);
 			}
@@ -1163,7 +1163,7 @@ static int write_phy_register(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 			    rts51x_write_phy_register(chip, addr + i, buf[i]);
 			if (retval != STATUS_SUCCESS) {
 				vfree(buf);
-				set_sense_type(chip, SCSI_LUN(srb),
+				rts51x_set_sense_type(chip, SCSI_LUN(srb),
 					       SENSE_TYPE_MEDIA_WRITE_ERR);
 				TRACE_RET(chip, TRANSPORT_FAILED);
 			}
@@ -1181,15 +1181,15 @@ static int get_card_bus_width(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	u8 card, bus_width;
 
 	if (!check_card_ready(chip, lun)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
-	card = get_lun_card(chip, lun);
+	card = rts51x_get_lun_card(chip, lun);
 	if ((card == SD_CARD) || (card == MS_CARD)) {
 		bus_width = chip->card_bus_width[lun];
 	} else {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1211,7 +1211,7 @@ static int trace_msg_cmd(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	    ((2 + MSG_FUNC_LEN + MSG_FILE_LEN + TIME_VAL_LEN) * TRACE_ITEM_CNT);
 
 	if ((scsi_bufflen(srb) < buf_len) || (scsi_sglist(srb) == NULL)) {
-		set_sense_type(chip, SCSI_LUN(srb),
+		rts51x_set_sense_type(chip, SCSI_LUN(srb),
 			       SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
@@ -1251,7 +1251,7 @@ static int rw_mem_cmd_buf(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	case ADD_BATCHCMD:
 		cmd_type = srb->cmnd[4];
 		if (cmd_type > 2) {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
@@ -1274,13 +1274,13 @@ static int rw_mem_cmd_buf(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 									  [9]);
 		retval = rts51x_send_cmd(chip, mode, 1000);
 		if (retval != STATUS_SUCCESS) {
-			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
 		if (mode & STAGE_R) {
 			retval = rts51x_get_rsp(chip, len, timeout);
 			if (retval != STATUS_SUCCESS) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 				TRACE_RET(chip, TRANSPORT_FAILED);
 			}
@@ -1291,7 +1291,7 @@ static int rw_mem_cmd_buf(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		idx = srb->cmnd[4];
 		value = chip->rsp_buf[idx];
 		if (scsi_bufflen(srb) < 1) {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
@@ -1300,12 +1300,12 @@ static int rw_mem_cmd_buf(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		break;
 
 	default:
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1357,7 +1357,7 @@ static int app_cmd(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		break;
 
 	default:
-		set_sense_type(chip, SCSI_LUN(srb),
+		rts51x_set_sense_type(chip, SCSI_LUN(srb),
 			       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
@@ -1401,7 +1401,7 @@ static int vendor_cmnd(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		break;
 
 	default:
-		set_sense_type(chip, SCSI_LUN(srb),
+		rts51x_set_sense_type(chip, SCSI_LUN(srb),
 			       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
@@ -1415,15 +1415,15 @@ static int ms_format_cmnd(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	int retval, quick_format;
 
-	if (get_lun_card(chip, lun) != MS_CARD) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
+	if (rts51x_get_lun_card(chip, lun) != MS_CARD) {
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if ((srb->cmnd[3] != 0x4D) || (srb->cmnd[4] != 0x47)
 	    || (srb->cmnd[5] != 0x66) || (srb->cmnd[6] != 0x6D)
 	    || (srb->cmnd[7] != 0x74)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1433,26 +1433,26 @@ static int ms_format_cmnd(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		quick_format = 1;
 
 	if (!(chip->card_ready & MS_CARD)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (chip->card_wp & MS_CARD) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_PROTECT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_PROTECT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (!CHK_MSPRO(ms_card)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	rts51x_prepare_run(chip);
 	RTS51X_SET_STAT(chip, STAT_RUN);
 
-	retval = mspro_format(srb, chip, MS_SHORT_DATA_LEN, quick_format);
+	retval = rts51x_mspro_format(srb, chip, MS_SHORT_DATA_LEN, quick_format);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_FORMAT_CMD_FAILED);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_FORMAT_CMD_FAILED);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1471,18 +1471,18 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	int i;
 
 	if (!check_card_ready(chip, lun)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
-	if ((get_lun_card(chip, lun) != MS_CARD)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
+	if ((rts51x_get_lun_card(chip, lun) != MS_CARD)) {
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if ((srb->cmnd[2] != 0xB0) || (srb->cmnd[4] != 0x4D) ||
 	    (srb->cmnd[5] != 0x53) || (srb->cmnd[6] != 0x49) ||
 	    (srb->cmnd[7] != 0x44)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1490,7 +1490,7 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	if ((CHK_MSXC(ms_card) && (dev_info_id == 0x10)) ||
 	    (!CHK_MSXC(ms_card) && (dev_info_id == 0x13)) ||
 	    !CHK_MSPRO(ms_card)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1576,44 +1576,44 @@ static int sd_extention_cmnd(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	rts51x_prepare_run(chip);
 	RTS51X_SET_STAT(chip, STAT_RUN);
 
-	sd_cleanup_work(chip);
+	rts51x_sd_cleanup_work(chip);
 
 	if (!check_card_ready(chip, lun)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
-	if ((get_lun_card(chip, lun) != SD_CARD)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
+	if ((rts51x_get_lun_card(chip, lun) != SD_CARD)) {
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	switch (srb->cmnd[0]) {
 	case SD_PASS_THRU_MODE:
-		result = sd_pass_thru_mode(srb, chip);
+		result = rts51x_sd_pass_thru_mode(srb, chip);
 		break;
 
 	case SD_EXECUTE_NO_DATA:
-		result = sd_execute_no_data(srb, chip);
+		result = rts51x_sd_execute_no_data(srb, chip);
 		break;
 
 	case SD_EXECUTE_READ:
-		result = sd_execute_read_data(srb, chip);
+		result = rts51x_sd_execute_read_data(srb, chip);
 		break;
 
 	case SD_EXECUTE_WRITE:
-		result = sd_execute_write_data(srb, chip);
+		result = rts51x_sd_execute_write_data(srb, chip);
 		break;
 
 	case SD_GET_RSP:
-		result = sd_get_cmd_rsp(srb, chip);
+		result = rts51x_sd_get_cmd_rsp(srb, chip);
 		break;
 
 	case SD_HW_RST:
-		result = sd_hw_rst(srb, chip);
+		result = rts51x_sd_hw_rst(srb, chip);
 		break;
 
 	default:
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1632,24 +1632,24 @@ static int mg_report_key(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	rts51x_prepare_run(chip);
 	RTS51X_SET_STAT(chip, STAT_RUN);
 
-	ms_cleanup_work(chip);
+	rts51x_ms_cleanup_work(chip);
 
 	if (!check_card_ready(chip, lun)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
-	if ((get_lun_card(chip, lun) != MS_CARD)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
+	if ((rts51x_get_lun_card(chip, lun) != MS_CARD)) {
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (srb->cmnd[7] != KC_MG_R_PRO) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (!CHK_MSPRO(ms_card)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1659,11 +1659,11 @@ static int mg_report_key(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	case KF_GET_LOC_EKB:
 		if ((scsi_bufflen(srb) == 0x41C) &&
 		    (srb->cmnd[8] == 0x04) && (srb->cmnd[9] == 0x1C)) {
-			retval = mg_get_local_EKB(srb, chip);
+			retval = rts51x_mg_get_local_EKB(srb, chip);
 			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
 		} else {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
@@ -1672,11 +1672,11 @@ static int mg_report_key(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	case KF_RSP_CHG:
 		if ((scsi_bufflen(srb) == 0x24) &&
 		    (srb->cmnd[8] == 0x00) && (srb->cmnd[9] == 0x24)) {
-			retval = mg_get_rsp_chg(srb, chip);
+			retval = rts51x_mg_get_rsp_chg(srb, chip);
 			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
 		} else {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
@@ -1690,18 +1690,18 @@ static int mg_report_key(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		    (srb->cmnd[2] == 0x00) &&
 		    (srb->cmnd[3] == 0x00) &&
 		    (srb->cmnd[4] == 0x00) && (srb->cmnd[5] < 32)) {
-			retval = mg_get_ICV(srb, chip);
+			retval = rts51x_mg_get_ICV(srb, chip);
 			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
 		} else {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
 		break;
 
 	default:
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1719,28 +1719,28 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	rts51x_prepare_run(chip);
 	RTS51X_SET_STAT(chip, STAT_RUN);
 
-	ms_cleanup_work(chip);
+	rts51x_ms_cleanup_work(chip);
 
 	if (!check_card_ready(chip, lun)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 	if (check_card_wp(chip, lun)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_PROTECT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_PROTECT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
-	if ((get_lun_card(chip, lun) != MS_CARD)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
+	if ((rts51x_get_lun_card(chip, lun) != MS_CARD)) {
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_LUN_NOT_SUPPORT);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (srb->cmnd[7] != KC_MG_R_PRO) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (!CHK_MSPRO(ms_card)) {
-		set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MG_INCOMPATIBLE_MEDIUM);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1750,11 +1750,11 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	case KF_SET_LEAF_ID:
 		if ((scsi_bufflen(srb) == 0x0C) &&
 		    (srb->cmnd[8] == 0x00) && (srb->cmnd[9] == 0x0C)) {
-			retval = mg_set_leaf_id(srb, chip);
+			retval = rts51x_mg_set_leaf_id(srb, chip);
 			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
 		} else {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
@@ -1763,11 +1763,11 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	case KF_CHG_HOST:
 		if ((scsi_bufflen(srb) == 0x0C) &&
 		    (srb->cmnd[8] == 0x00) && (srb->cmnd[9] == 0x0C)) {
-			retval = mg_chg(srb, chip);
+			retval = rts51x_mg_chg(srb, chip);
 			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
 		} else {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
@@ -1776,11 +1776,11 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	case KF_RSP_HOST:
 		if ((scsi_bufflen(srb) == 0x0C) &&
 		    (srb->cmnd[8] == 0x00) && (srb->cmnd[9] == 0x0C)) {
-			retval = mg_rsp(srb, chip);
+			retval = rts51x_mg_rsp(srb, chip);
 			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
 		} else {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
@@ -1794,18 +1794,18 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		    (srb->cmnd[2] == 0x00) &&
 		    (srb->cmnd[3] == 0x00) &&
 		    (srb->cmnd[4] == 0x00) && (srb->cmnd[5] < 32)) {
-			retval = mg_set_ICV(srb, chip);
+			retval = rts51x_mg_set_ICV(srb, chip);
 			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, TRANSPORT_FAILED);
 		} else {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
 		break;
 
 	default:
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1820,12 +1820,12 @@ int rts51x_scsi_handler(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	int result = TRANSPORT_GOOD;
 
-	if ((get_lun_card(chip, lun) == MS_CARD) &&
+	if ((rts51x_get_lun_card(chip, lun) == MS_CARD) &&
 	    (ms_card->format_status == FORMAT_IN_PROGRESS)) {
 		if ((srb->cmnd[0] != REQUEST_SENSE)
 		    && (srb->cmnd[0] != INQUIRY)) {
 			/* Logical Unit Not Ready Format in Progress */
-			set_sense_data(chip, lun, CUR_ERR, 0x02, 0, 0x04, 0x04,
+			rts51x_set_sense_data(chip, lun, CUR_ERR, 0x02, 0, 0x04, 0x04,
 				       0, (u16) (ms_card->progress));
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
@@ -1908,7 +1908,7 @@ int rts51x_scsi_handler(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		break;
 
 	default:
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		result = TRANSPORT_FAILED;
 	}
 
diff --git a/drivers/staging/rts5139/rts51x_scsi.h b/drivers/staging/rts5139/rts51x_scsi.h
index 9042bc9..cdfe550 100644
--- a/drivers/staging/rts5139/rts51x_scsi.h
+++ b/drivers/staging/rts5139/rts51x_scsi.h
@@ -133,9 +133,9 @@ struct rts51x_chip;
 
 #define SCSI                    0x00	/* Interface ID                     */
 
-void scsi_show_command(struct scsi_cmnd *srb);
-void set_sense_type(struct rts51x_chip *chip, unsigned int lun, int sense_type);
-void set_sense_data(struct rts51x_chip *chip, unsigned int lun, u8 err_code,
+void rts51x_scsi_show_command(struct scsi_cmnd *srb);
+void rts51x_set_sense_type(struct rts51x_chip *chip, unsigned int lun, int sense_type);
+void rts51x_set_sense_data(struct rts51x_chip *chip, unsigned int lun, u8 err_code,
 		    u8 sense_key, u32 info, u8 asc, u8 ascq, u8 sns_key_info0,
 		    u16 sns_key_info1);
 
diff --git a/drivers/staging/rts5139/sd.c b/drivers/staging/rts5139/sd.c
index b739f26..4283b09 100644
--- a/drivers/staging/rts5139/sd.c
+++ b/drivers/staging/rts5139/sd.c
@@ -680,7 +680,7 @@ static int sd_set_init_para(struct rts51x_chip *chip)
 	return STATUS_SUCCESS;
 }
 
-int sd_select_card(struct rts51x_chip *chip, int select)
+int rts51x_sd_select_card(struct rts51x_chip *chip, int select)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	int retval;
@@ -1747,7 +1747,7 @@ static int mmc_ddr_tuning(struct rts51x_chip *chip)
 	return STATUS_SUCCESS;
 }
 
-int sd_switch_clock(struct rts51x_chip *chip)
+int rts51x_sd_switch_clock(struct rts51x_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	int retval;
@@ -1913,7 +1913,7 @@ static int sd_init_power(struct rts51x_chip *chip)
 #endif
 
 		/* Power on card */
-		retval = card_power_on(chip, SD_CARD);
+		retval = rts51x_card_power_on(chip, SD_CARD);
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, retval);
 
@@ -2139,7 +2139,7 @@ RTY_CMD55:
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, retval);
 	/* Select SD card */
-	retval = sd_select_card(chip, 1);
+	retval = rts51x_sd_select_card(chip, 1);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, retval);
 
@@ -2656,7 +2656,7 @@ RTY_MMC_RST:
 	spec_ver = (sd_card->raw_csd[0] & 0x3C) >> 2;
 
 	/* Select MMC card */
-	retval = sd_select_card(chip, 1);
+	retval = rts51x_sd_select_card(chip, 1);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, retval);
 
@@ -2748,7 +2748,7 @@ RTY_MMC_RST:
 	return STATUS_SUCCESS;
 }
 
-int reset_sd_card(struct rts51x_chip *chip)
+int rts51x_reset_sd_card(struct rts51x_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	int retval;
@@ -2764,7 +2764,7 @@ int reset_sd_card(struct rts51x_chip *chip)
 	sd_card->sd_switch_fail = 0;
 
 	sd_clear_reset_fail(chip);
-	enable_card_clock(chip, SD_CARD);
+	rts51x_enable_card_clock(chip, SD_CARD);
 
 	sd_init_power(chip);
 
@@ -2891,7 +2891,7 @@ static void sd_stop_seq_mode(struct rts51x_chip *chip)
 	int retval;
 
 	if (sd_card->seq_mode) {
-		retval = sd_switch_clock(chip);
+		retval = rts51x_sd_switch_clock(chip);
 		if (retval != STATUS_SUCCESS)
 			return;
 
@@ -2923,14 +2923,14 @@ static inline int sd_auto_tune_clock(struct rts51x_chip *chip)
 			sd_card->sd_clock = CLK_50;
 	}
 
-	retval = sd_switch_clock(chip);
+	retval = rts51x_sd_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, retval);
 
 	return STATUS_SUCCESS;
 }
 
-int sd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
+int rts51x_sd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 	  u16 sector_cnt)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
@@ -2947,11 +2947,11 @@ int sd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 	else
 		data_addr = start_sector;
 
-	RTS51X_DEBUGP("sd_rw, data_addr = 0x%x\n", data_addr);
+	RTS51X_DEBUGP("rts51x_sd_rw, data_addr = 0x%x\n", data_addr);
 
 	sd_clr_err_code(chip);
 
-	retval = sd_switch_clock(chip);
+	retval = rts51x_sd_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, retval);
 
@@ -3020,7 +3020,7 @@ int sd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 			       SD_NO_WAIT_BUSY_END | SD_NO_CHECK_CRC7 |
 			       SD_RSP_LEN_0);
 
-		trans_dma_enable(srb->sc_data_direction, chip, sector_cnt * 512,
+		rts51x_trans_dma_enable(srb->sc_data_direction, chip, sector_cnt * 512,
 				 DMA_512);
 
 		if (srb->sc_data_direction == DMA_FROM_DEVICE) {
@@ -3058,7 +3058,7 @@ int sd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 				       SD_NO_WAIT_BUSY_END | SD_CHECK_CRC7 |
 				       SD_RSP_LEN_6);
 
-			trans_dma_enable(srb->sc_data_direction, chip,
+			rts51x_trans_dma_enable(srb->sc_data_direction, chip,
 					 sector_cnt * 512, DMA_512);
 
 			rts51x_add_cmd(chip, WRITE_REG_CMD, SD_TRANSFER, 0xFF,
@@ -3099,7 +3099,7 @@ int sd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 				       SD_NO_WAIT_BUSY_END | SD_NO_CHECK_CRC7 |
 				       SD_RSP_LEN_0);
 
-			trans_dma_enable(srb->sc_data_direction, chip,
+			rts51x_trans_dma_enable(srb->sc_data_direction, chip,
 					 sector_cnt * 512, DMA_512);
 
 			rts51x_add_cmd(chip, WRITE_REG_CMD, SD_TRANSFER, 0xFF,
@@ -3168,7 +3168,7 @@ int sd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 	return STATUS_SUCCESS;
 }
 
-void sd_cleanup_work(struct rts51x_chip *chip)
+void rts51x_sd_cleanup_work(struct rts51x_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 
@@ -3220,12 +3220,12 @@ static int sd_power_off_card3v3(struct rts51x_chip *chip)
 	return STATUS_SUCCESS;
 }
 
-int release_sd_card(struct rts51x_chip *chip)
+int rts51x_release_sd_card(struct rts51x_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	int retval;
 
-	RTS51X_DEBUGP("release_sd_card\n");
+	RTS51X_DEBUGP("rts51x_release_sd_card\n");
 
 	chip->card_ready &= ~SD_CARD;
 	chip->card_fail &= ~SD_CARD;
diff --git a/drivers/staging/rts5139/sd.h b/drivers/staging/rts5139/sd.h
index de155d8..7dd943f 100644
--- a/drivers/staging/rts5139/sd.h
+++ b/drivers/staging/rts5139/sd.h
@@ -256,13 +256,13 @@ struct timing_phase_path {
 	int len;
 };
 
-int sd_select_card(struct rts51x_chip *chip, int select);
-int reset_sd_card(struct rts51x_chip *chip);
-int sd_switch_clock(struct rts51x_chip *chip);
-int sd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
+int rts51x_sd_select_card(struct rts51x_chip *chip, int select);
+int rts51x_reset_sd_card(struct rts51x_chip *chip);
+int rts51x_sd_switch_clock(struct rts51x_chip *chip);
+int rts51x_sd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 	  u16 sector_cnt);
-void sd_cleanup_work(struct rts51x_chip *chip);
-int release_sd_card(struct rts51x_chip *chip);
+void rts51x_sd_cleanup_work(struct rts51x_chip *chip);
+int rts51x_release_sd_card(struct rts51x_chip *chip);
 
 #ifdef SUPPORT_CPRM
 extern int reset_sd(struct rts51x_chip *chip);
diff --git a/drivers/staging/rts5139/sd_cprm.c b/drivers/staging/rts5139/sd_cprm.c
index 0167f7f..d468983 100644
--- a/drivers/staging/rts5139/sd_cprm.c
+++ b/drivers/staging/rts5139/sd_cprm.c
@@ -269,7 +269,7 @@ static int ext_sd_get_rsp(struct rts51x_chip *chip, int len,
 	return STATUS_SUCCESS;
 }
 
-int ext_sd_execute_no_data(struct rts51x_chip *chip, unsigned int lun,
+int ext_rts51x_sd_execute_no_data(struct rts51x_chip *chip, unsigned int lun,
 			   u8 cmd_idx, u8 standby, u8 acmd, u8 rsp_code,
 			   u32 arg)
 {
@@ -277,30 +277,30 @@ int ext_sd_execute_no_data(struct rts51x_chip *chip, unsigned int lun,
 	int retval, rsp_len;
 	u8 rsp_type;
 
-	retval = sd_switch_clock(chip);
+	retval = rts51x_sd_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, TRANSPORT_FAILED);
 
 	if (sd_card->pre_cmd_err) {
 		sd_card->pre_cmd_err = 0;
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 	retval = get_rsp_type(rsp_code, &rsp_type, &rsp_len);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 	sd_card->last_rsp_type = rsp_type;
 
-	retval = sd_switch_clock(chip);
+	retval = rts51x_sd_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	/* Set H/W SD/MMC Bus Width */
 	rts51x_write_register(chip, SD_CFG1, 0x03, SD_BUS_WIDTH_4);
 
 	if (standby) {
-		retval = sd_select_card(chip, 0);
+		retval = rts51x_sd_select_card(chip, 0);
 		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
 	}
@@ -319,7 +319,7 @@ int ext_sd_execute_no_data(struct rts51x_chip *chip, unsigned int lun,
 		TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
 
 	if (standby) {
-		retval = sd_select_card(chip, 1);
+		retval = rts51x_sd_select_card(chip, 1);
 		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Cmd_Failed);
 	}
@@ -328,16 +328,16 @@ int ext_sd_execute_no_data(struct rts51x_chip *chip, unsigned int lun,
 
 SD_Execute_Cmd_Failed:
 	sd_card->pre_cmd_err = 1;
-	set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
-	release_sd_card(chip);
-	do_reset_sd_card(chip);
+	rts51x_set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
+	rts51x_release_sd_card(chip);
+	rts51x_do_rts51x_reset_sd_card(chip);
 	if (!(chip->card_ready & SD_CARD))
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 
 	TRACE_RET(chip, TRANSPORT_FAILED);
 }
 
-int ext_sd_execute_read_data(struct rts51x_chip *chip, unsigned int lun,
+int ext_rts51x_sd_execute_read_data(struct rts51x_chip *chip, unsigned int lun,
 			     u8 cmd_idx, u8 cmd12, u8 standby,
 			     u8 acmd, u8 rsp_code, u32 arg, u32 data_len,
 			     void *data_buf, unsigned int buf_len, int use_sg)
@@ -349,21 +349,21 @@ int ext_sd_execute_read_data(struct rts51x_chip *chip, unsigned int lun,
 
 	if (sd_card->pre_cmd_err) {
 		sd_card->pre_cmd_err = 0;
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
-	retval = sd_switch_clock(chip);
+	retval = rts51x_sd_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
 	retval = get_rsp_type(rsp_code, &rsp_type, &rsp_len);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 	sd_card->last_rsp_type = rsp_type;
 
-	retval = sd_switch_clock(chip);
+	retval = rts51x_sd_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	bus_width = SD_BUS_WIDTH_4;
@@ -376,7 +376,7 @@ int ext_sd_execute_read_data(struct rts51x_chip *chip, unsigned int lun,
 	}
 
 	if (standby) {
-		retval = sd_select_card(chip, 0);
+		retval = rts51x_sd_select_card(chip, 0);
 		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
 	}
@@ -448,7 +448,7 @@ int ext_sd_execute_read_data(struct rts51x_chip *chip, unsigned int lun,
 		rts51x_add_cmd(chip, WRITE_REG_CMD, SD_CMD4, 0xFF, (u8) arg);
 		rts51x_add_cmd(chip, WRITE_REG_CMD, SD_CFG1, 0x03, bus_width);
 		rts51x_add_cmd(chip, WRITE_REG_CMD, SD_CFG2, 0xFF, rsp_type);
-		trans_dma_enable(DMA_FROM_DEVICE, chip, data_len, DMA_512);
+		rts51x_trans_dma_enable(DMA_FROM_DEVICE, chip, data_len, DMA_512);
 		rts51x_add_cmd(chip, WRITE_REG_CMD, SD_TRANSFER, 0xFF,
 			       SD_TM_AUTO_READ_2 | SD_TRANSFER_START);
 		rts51x_add_cmd(chip, CHECK_REG_CMD, SD_TRANSFER,
@@ -490,7 +490,7 @@ int ext_sd_execute_read_data(struct rts51x_chip *chip, unsigned int lun,
 		TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
 
 	if (standby) {
-		retval = sd_select_card(chip, 1);
+		retval = rts51x_sd_select_card(chip, 1);
 		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Read_Cmd_Failed);
 	}
@@ -531,18 +531,18 @@ int ext_sd_execute_read_data(struct rts51x_chip *chip, unsigned int lun,
 
 SD_Execute_Read_Cmd_Failed:
 	sd_card->pre_cmd_err = 1;
-	set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
+	rts51x_set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
 	if (read_err)
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
-	release_sd_card(chip);
-	do_reset_sd_card(chip);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
+	rts51x_release_sd_card(chip);
+	rts51x_do_rts51x_reset_sd_card(chip);
 	if (!(chip->card_ready & SD_CARD))
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 
 	TRACE_RET(chip, TRANSPORT_FAILED);
 }
 
-int ext_sd_execute_write_data(struct rts51x_chip *chip, unsigned int lun,
+int ext_rts51x_sd_execute_write_data(struct rts51x_chip *chip, unsigned int lun,
 			      u8 cmd_idx, u8 cmd12, u8 standby, u8 acmd,
 			      u8 rsp_code, u32 arg, u32 data_len,
 			      void *data_buf, unsigned int buf_len, int use_sg)
@@ -555,22 +555,22 @@ int ext_sd_execute_write_data(struct rts51x_chip *chip, unsigned int lun,
 
 	if (sd_card->pre_cmd_err) {
 		sd_card->pre_cmd_err = 0;
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
-	retval = sd_switch_clock(chip);
+	retval = rts51x_sd_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
 
 	retval = get_rsp_type(rsp_code, &rsp_type, &rsp_len);
 	if (retval != STATUS_SUCCESS) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 	sd_card->last_rsp_type = rsp_type;
 
-	retval = sd_switch_clock(chip);
+	retval = rts51x_sd_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	rts51x_write_register(chip, SD_CFG1, 0x03, SD_BUS_WIDTH_4);
@@ -583,7 +583,7 @@ int ext_sd_execute_write_data(struct rts51x_chip *chip, unsigned int lun,
 	}
 
 	if (standby) {
-		retval = sd_select_card(chip, 0);
+		retval = rts51x_sd_select_card(chip, 0);
 		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
 	}
@@ -690,7 +690,7 @@ int ext_sd_execute_write_data(struct rts51x_chip *chip, unsigned int lun,
 		rts51x_add_cmd(chip, WRITE_REG_CMD, SD_BLOCK_CNT_L,
 			       0xFF, (u8) ((data_len & 0x0001FE00) >> 9));
 
-		trans_dma_enable(DMA_TO_DEVICE, chip, data_len, DMA_512);
+		rts51x_trans_dma_enable(DMA_TO_DEVICE, chip, data_len, DMA_512);
 
 		rts51x_add_cmd(chip, WRITE_REG_CMD, SD_TRANSFER, 0xFF,
 			       SD_TM_AUTO_WRITE_3 | SD_TRANSFER_START);
@@ -724,7 +724,7 @@ int ext_sd_execute_write_data(struct rts51x_chip *chip, unsigned int lun,
 	}
 
 	if (standby) {
-		retval = sd_select_card(chip, 1);
+		retval = rts51x_sd_select_card(chip, 1);
 		if (retval != STATUS_SUCCESS)
 			TRACE_GOTO(chip, SD_Execute_Write_Cmd_Failed);
 	}
@@ -767,18 +767,18 @@ int ext_sd_execute_write_data(struct rts51x_chip *chip, unsigned int lun,
 
 SD_Execute_Write_Cmd_Failed:
 	sd_card->pre_cmd_err = 1;
-	set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
+	rts51x_set_sense_type(chip, lun, SENSE_TYPE_NO_SENSE);
 	if (write_err)
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
-	release_sd_card(chip);
-	do_reset_sd_card(chip);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_WRITE_ERR);
+	rts51x_release_sd_card(chip);
+	rts51x_do_rts51x_reset_sd_card(chip);
 	if (!(chip->card_ready & SD_CARD))
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 
 	TRACE_RET(chip, TRANSPORT_FAILED);
 }
 
-int sd_pass_thru_mode(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_sd_pass_thru_mode(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	unsigned int lun = SCSI_LUN(srb);
@@ -808,7 +808,7 @@ int sd_pass_thru_mode(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 
 	if (!(CHK_BIT(chip->lun_mc, lun))) {
 		SET_BIT(chip->lun_mc, lun);
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -816,7 +816,7 @@ int sd_pass_thru_mode(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	    || (0x20 != srb->cmnd[4]) || (0x43 != srb->cmnd[5])
 	    || (0x61 != srb->cmnd[6]) || (0x72 != srb->cmnd[7])
 	    || (0x64 != srb->cmnd[8])) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -830,7 +830,7 @@ int sd_pass_thru_mode(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		break;
 
 	default:
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -850,7 +850,7 @@ int sd_pass_thru_mode(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	return TRANSPORT_GOOD;
 }
 
-int sd_execute_no_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_sd_execute_no_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	unsigned int lun = SCSI_LUN(srb);
@@ -860,7 +860,7 @@ int sd_execute_no_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	u32 arg;
 
 	if (!sd_card->sd_pass_thru_en) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -876,13 +876,13 @@ int sd_execute_no_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	rsp_code = srb->cmnd[10];
 
 	retval =
-	    ext_sd_execute_no_data(chip, lun, cmd_idx, standby, acmd, rsp_code,
+	    ext_rts51x_sd_execute_no_data(chip, lun, cmd_idx, standby, acmd, rsp_code,
 				   arg);
 	scsi_set_resid(srb, 0);
 	return retval;
 }
 
-int sd_execute_read_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_sd_execute_read_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	int retval;
@@ -891,7 +891,7 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	u32 arg, data_len;
 
 	if (!sd_card->sd_pass_thru_en) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -912,7 +912,7 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	rsp_code = srb->cmnd[10];
 
 	retval =
-	    ext_sd_execute_read_data(chip, lun, cmd_idx, send_cmd12, standby,
+	    ext_rts51x_sd_execute_read_data(chip, lun, cmd_idx, send_cmd12, standby,
 				     acmd, rsp_code, arg, data_len,
 				     scsi_sglist(srb), scsi_bufflen(srb),
 				     scsi_sg_count(srb));
@@ -920,7 +920,7 @@ int sd_execute_read_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	return retval;
 }
 
-int sd_execute_write_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_sd_execute_write_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	int retval;
@@ -929,7 +929,7 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	u32 data_len, arg;
 
 	if (!sd_card->sd_pass_thru_en) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -950,7 +950,7 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	rsp_code = srb->cmnd[10];
 
 	retval =
-	    ext_sd_execute_write_data(chip, lun, cmd_idx, send_cmd12, standby,
+	    ext_rts51x_sd_execute_write_data(chip, lun, cmd_idx, send_cmd12, standby,
 				      acmd, rsp_code, arg, data_len,
 				      scsi_sglist(srb), scsi_bufflen(srb),
 				      scsi_sg_count(srb));
@@ -958,7 +958,7 @@ int sd_execute_write_data(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	return retval;
 }
 
-int sd_get_cmd_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_sd_get_cmd_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	unsigned int lun = SCSI_LUN(srb);
@@ -966,20 +966,20 @@ int sd_get_cmd_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	u16 data_len;
 
 	if (!sd_card->sd_pass_thru_en) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (sd_card->pre_cmd_err) {
 		sd_card->pre_cmd_err = 0;
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	data_len = ((u16) srb->cmnd[7] << 8) | srb->cmnd[8];
 
 	if (sd_card->last_rsp_type == SD_RSP_TYPE_R0) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	} else if (sd_card->last_rsp_type == SD_RSP_TYPE_R2) {
 		count = (data_len < 17) ? data_len : 17;
@@ -997,20 +997,20 @@ int sd_get_cmd_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	return TRANSPORT_GOOD;
 }
 
-int sd_hw_rst(struct scsi_cmnd *srb, struct rts51x_chip *chip)
+int rts51x_sd_hw_rst(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	unsigned int lun = SCSI_LUN(srb);
 	int retval;
 
 	if (!sd_card->sd_pass_thru_en) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	if (sd_card->pre_cmd_err) {
 		sd_card->pre_cmd_err = 0;
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_CHANGE);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
@@ -1018,16 +1018,16 @@ int sd_hw_rst(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 	    || (0x20 != srb->cmnd[4]) || (0x43 != srb->cmnd[5])
 	    || (0x61 != srb->cmnd[6]) || (0x72 != srb->cmnd[7])
 	    || (0x64 != srb->cmnd[8])) {
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
 	switch (srb->cmnd[1] & 0x0F) {
 	case 0:
 		/* SD Card Power Off -> ON and Initialization */
-		retval = reset_sd_card(chip);
+		retval = rts51x_reset_sd_card(chip);
 		if (retval != STATUS_SUCCESS) {
-			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 			sd_card->pre_cmd_err = 1;
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
@@ -1038,14 +1038,14 @@ int sd_hw_rst(struct scsi_cmnd *srb, struct rts51x_chip *chip)
 		 * (without SD Card Power Off -> ON) */
 		retval = reset_sd(chip);
 		if (retval != STATUS_SUCCESS) {
-			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 			sd_card->pre_cmd_err = 1;
 			TRACE_RET(chip, TRANSPORT_FAILED);
 		}
 		break;
 
 	default:
-		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
+		rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, TRANSPORT_FAILED);
 	}
 
diff --git a/drivers/staging/rts5139/sd_cprm.h b/drivers/staging/rts5139/sd_cprm.h
index 75e263b..79dfd27 100644
--- a/drivers/staging/rts5139/sd_cprm.h
+++ b/drivers/staging/rts5139/sd_cprm.h
@@ -31,24 +31,24 @@
 #include "sd.h"
 
 #ifdef SUPPORT_CPRM
-int ext_sd_execute_no_data(struct rts51x_chip *chip, unsigned int lun,
+int ext_rts51x_sd_execute_no_data(struct rts51x_chip *chip, unsigned int lun,
 			   u8 cmd_idx, u8 standby, u8 acmd, u8 rsp_code,
 			   u32 arg);
-int ext_sd_execute_read_data(struct rts51x_chip *chip, unsigned int lun,
+int ext_rts51x_sd_execute_read_data(struct rts51x_chip *chip, unsigned int lun,
 			     u8 cmd_idx, u8 cmd12, u8 standby, u8 acmd,
 			     u8 rsp_code, u32 arg, u32 data_len, void *data_buf,
 			     unsigned int buf_len, int use_sg);
-int ext_sd_execute_write_data(struct rts51x_chip *chip, unsigned int lun,
+int ext_rts51x_sd_execute_write_data(struct rts51x_chip *chip, unsigned int lun,
 			      u8 cmd_idx, u8 cmd12, u8 standby, u8 acmd,
 			      u8 rsp_code, u32 arg, u32 data_len,
 			      void *data_buf, unsigned int buf_len, int use_sg);
 
-int sd_pass_thru_mode(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-int sd_execute_no_data(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-int sd_execute_read_data(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-int sd_execute_write_data(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-int sd_get_cmd_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip);
-int sd_hw_rst(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_sd_pass_thru_mode(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_sd_execute_no_data(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_sd_execute_read_data(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_sd_execute_write_data(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_sd_get_cmd_rsp(struct scsi_cmnd *srb, struct rts51x_chip *chip);
+int rts51x_sd_hw_rst(struct scsi_cmnd *srb, struct rts51x_chip *chip);
 #endif
 
 #endif /* __RTS51X_SD_CPRM_H */
diff --git a/drivers/staging/rts5139/xd.c b/drivers/staging/rts5139/xd.c
index 58f8ba2..10fea7e 100644
--- a/drivers/staging/rts5139/xd.c
+++ b/drivers/staging/rts5139/xd.c
@@ -425,7 +425,7 @@ static int reset_xd(struct rts51x_chip *chip)
 		}
 #endif
 
-		retval = card_power_on(chip, XD_CARD);
+		retval = rts51x_card_power_on(chip, XD_CARD);
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, retval);
 #ifdef SUPPORT_OCP
@@ -472,8 +472,8 @@ static int reset_xd(struct rts51x_chip *chip)
 		rts51x_init_cmd(chip);
 		rts51x_add_cmd(chip, WRITE_REG_CMD, XD_DTCTL, 0xFF,
 			XD_TIME_SETUP_STEP * 3 + XD_TIME_RW_STEP *
-			(2 + i + chip->option.xd_rw_step)
-			+ XD_TIME_RWN_STEP * (i + chip->option.xd_rwn_step));
+			(2 + i + chip->option.rts51x_xd_rw_step)
+			+ XD_TIME_RWN_STEP * (i + chip->option.rts51x_xd_rwn_step));
 		rts51x_add_cmd(chip, WRITE_REG_CMD, XD_CATCTL, 0xFF,
 			XD_TIME_SETUP_STEP * 3 + XD_TIME_RW_STEP * (4 +
 			i) + XD_TIME_RWN_STEP * (3 + i));
@@ -905,7 +905,7 @@ static u32 xd_get_l2p_tbl(struct rts51x_chip *chip, int zone_no, u16 log_off)
 	return (u32) zone->l2p_table[log_off] + ((u32) (zone_no) << 10);
 }
 
-int reset_xd_card(struct rts51x_chip *chip)
+int rts51x_reset_xd_card(struct rts51x_chip *chip)
 {
 	struct xd_info *xd_card = &(chip->xd_card);
 	int retval;
@@ -920,7 +920,7 @@ int reset_xd_card(struct rts51x_chip *chip)
 	xd_card->cis_block = 0xFFFF;
 	xd_card->delay_write.delay_write_flag = 0;
 
-	enable_card_clock(chip, XD_CARD);
+	rts51x_enable_card_clock(chip, XD_CARD);
 
 	retval = reset_xd(chip);
 	if (retval != STATUS_SUCCESS) {
@@ -1526,7 +1526,7 @@ static int xd_read_multiple_pages(struct rts51x_chip *chip, u32 phy_blk,
 	rts51x_add_cmd(chip, WRITE_REG_CMD, XD_CHK_DATA_STATUS,
 		       XD_AUTO_CHK_DATA_STATUS, XD_AUTO_CHK_DATA_STATUS);
 
-	trans_dma_enable(chip->srb->sc_data_direction, chip, page_cnt * 512,
+	rts51x_trans_dma_enable(chip->srb->sc_data_direction, chip, page_cnt * 512,
 			 DMA_512);
 
 	rts51x_add_cmd(chip, WRITE_REG_CMD, XD_TRANSFER, 0xFF,
@@ -1745,7 +1745,7 @@ static int xd_write_multiple_pages(struct rts51x_chip *chip, u32 old_blk,
 	rts51x_add_cmd(chip, WRITE_REG_CMD, CARD_DATA_SOURCE, 0x01,
 		       RING_BUFFER);
 
-	trans_dma_enable(chip->srb->sc_data_direction, chip, page_cnt * 512,
+	rts51x_trans_dma_enable(chip->srb->sc_data_direction, chip, page_cnt * 512,
 			 DMA_512);
 
 	rts51x_add_cmd(chip, WRITE_REG_CMD, XD_TRANSFER, 0xFF,
@@ -1842,7 +1842,7 @@ static int xd_delay_write(struct rts51x_chip *chip)
 	return STATUS_SUCCESS;
 }
 
-int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
+int rts51x_xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 	  u16 sector_cnt)
 {
 	struct xd_info *xd_card = &(chip->xd_card);
@@ -1860,7 +1860,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 
 	xd_card->counter = 0;
 
-	RTS51X_DEBUGP("xd_rw: scsi_bufflen = %d, scsi_sg_count = %d\n",
+	RTS51X_DEBUGP("rts51x_xd_rw: scsi_bufflen = %d, scsi_sg_count = %d\n",
 		       scsi_bufflen(srb), scsi_sg_count(srb));
 	RTS51X_DEBUGP("Data direction: %s\n",
 		       (srb->sc_data_direction ==
@@ -1883,7 +1883,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 		retval = xd_build_l2p_tbl(chip, zone_no);
 		if (retval != STATUS_SUCCESS) {
 			chip->card_fail |= XD_CARD;
-			set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
+			rts51x_set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
 			TRACE_RET(chip, retval);
 		}
 	}
@@ -1900,7 +1900,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 						      delay_write->pageoff,
 						      start_page);
 				if (retval != STATUS_SUCCESS) {
-					set_sense_type(chip, lun,
+					rts51x_set_sense_type(chip, lun,
 						SENSE_TYPE_MEDIA_WRITE_ERR);
 					TRACE_RET(chip, retval);
 				}
@@ -1916,7 +1916,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 		} else {
 			retval = xd_delay_write(chip);
 			if (retval != STATUS_SUCCESS) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_WRITE_ERR);
 				TRACE_RET(chip, retval);
 			}
@@ -1924,7 +1924,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 			new_blk = xd_get_unused_block(chip, zone_no);
 			if ((old_blk == BLK_NOT_FOUND)
 			    || (new_blk == BLK_NOT_FOUND)) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_WRITE_ERR);
 				TRACE_RET(chip, retval);
 			}
@@ -1935,11 +1935,11 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 			if (retval != STATUS_SUCCESS) {
 				if (monitor_card_cd(chip, XD_CARD) ==
 				    CD_NOT_EXIST) {
-					set_sense_type(chip, lun,
+					rts51x_set_sense_type(chip, lun,
 						SENSE_TYPE_MEDIA_NOT_PRESENT);
 					TRACE_RET(chip, STATUS_FAIL);
 				}
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_WRITE_ERR);
 				TRACE_RET(chip, retval);
 			}
@@ -1948,18 +1948,18 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 		retval = xd_delay_write(chip);
 		if (retval != STATUS_SUCCESS) {
 			if (monitor_card_cd(chip, XD_CARD) == CD_NOT_EXIST) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_NOT_PRESENT);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 			TRACE_RET(chip, retval);
 		}
 
 		old_blk = xd_get_l2p_tbl(chip, zone_no, log_off);
 		if (old_blk == BLK_NOT_FOUND) {
-			set_sense_type(chip, lun,
+			rts51x_set_sense_type(chip, lun,
 				       SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 			TRACE_RET(chip, STATUS_FAIL);
 		}
@@ -1980,7 +1980,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 							start_page, end_page,
 							buf, &ptr, &offset);
 			if (retval != STATUS_SUCCESS) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
@@ -1991,7 +1991,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 						    end_page, buf, &ptr,
 						    &offset);
 			if (retval != STATUS_SUCCESS) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_WRITE_ERR);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
@@ -2010,7 +2010,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 			retval = xd_build_l2p_tbl(chip, zone_no);
 			if (retval != STATUS_SUCCESS) {
 				chip->card_fail |= XD_CARD;
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_NOT_PRESENT);
 				TRACE_RET(chip, retval);
 			}
@@ -2019,10 +2019,10 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 		old_blk = xd_get_l2p_tbl(chip, zone_no, log_off);
 		if (old_blk == BLK_NOT_FOUND) {
 			if (srb->sc_data_direction == DMA_FROM_DEVICE) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					SENSE_TYPE_MEDIA_UNRECOVER_READ_ERR);
 			} else {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_WRITE_ERR);
 			}
 			TRACE_RET(chip, STATUS_FAIL);
@@ -2031,7 +2031,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 		if (srb->sc_data_direction == DMA_TO_DEVICE) {
 			new_blk = xd_get_unused_block(chip, zone_no);
 			if (new_blk == BLK_NOT_FOUND) {
-				set_sense_type(chip, lun,
+				rts51x_set_sense_type(chip, lun,
 					       SENSE_TYPE_MEDIA_WRITE_ERR);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
@@ -2054,7 +2054,7 @@ int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 	return STATUS_SUCCESS;
 }
 
-void xd_free_l2p_tbl(struct rts51x_chip *chip)
+void rts51x_xd_free_l2p_tbl(struct rts51x_chip *chip)
 {
 	struct xd_info *xd_card = &(chip->xd_card);
 	int i = 0;
@@ -2075,7 +2075,7 @@ void xd_free_l2p_tbl(struct rts51x_chip *chip)
 	}
 }
 
-void xd_cleanup_work(struct rts51x_chip *chip)
+void rts51x_xd_cleanup_work(struct rts51x_chip *chip)
 {
 	struct xd_info *xd_card = &(chip->xd_card);
 
@@ -2115,12 +2115,12 @@ static int xd_power_off_card3v3(struct rts51x_chip *chip)
 	return STATUS_SUCCESS;
 }
 
-int release_xd_card(struct rts51x_chip *chip)
+int rts51x_release_xd_card(struct rts51x_chip *chip)
 {
 	struct xd_info *xd_card = &(chip->xd_card);
 	int retval;
 
-	RTS51X_DEBUGP("release_xd_card\n");
+	RTS51X_DEBUGP("rts51x_release_xd_card\n");
 
 	chip->card_ready &= ~XD_CARD;
 	chip->card_fail &= ~XD_CARD;
@@ -2128,7 +2128,7 @@ int release_xd_card(struct rts51x_chip *chip)
 
 	xd_card->delay_write.delay_write_flag = 0;
 
-	xd_free_l2p_tbl(chip);
+	rts51x_xd_free_l2p_tbl(chip);
 
 	rts51x_write_register(chip, SFSM_ED, HW_CMD_STOP, HW_CMD_STOP);
 
diff --git a/drivers/staging/rts5139/xd.h b/drivers/staging/rts5139/xd.h
index 55e4205..695a0b4 100644
--- a/drivers/staging/rts5139/xd.h
+++ b/drivers/staging/rts5139/xd.h
@@ -181,11 +181,11 @@
 #define	CIS1_8			(256 + 8)
 #define	CIS1_9			(256 + 9)
 
-int reset_xd_card(struct rts51x_chip *chip);
-int xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
+int rts51x_reset_xd_card(struct rts51x_chip *chip);
+int rts51x_xd_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 start_sector,
 	  u16 sector_cnt);
-void xd_free_l2p_tbl(struct rts51x_chip *chip);
-void xd_cleanup_work(struct rts51x_chip *chip);
-int release_xd_card(struct rts51x_chip *chip);
+void rts51x_xd_free_l2p_tbl(struct rts51x_chip *chip);
+void rts51x_xd_cleanup_work(struct rts51x_chip *chip);
+int rts51x_release_xd_card(struct rts51x_chip *chip);
 
 #endif /* __RTS51X_XD_H */
-- 
1.7.12.1

