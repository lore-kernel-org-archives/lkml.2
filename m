Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab1BPH5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:57:21 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:36880 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab1BPH5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:57:19 -0500
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH 1/2] staging: rts_pstor: delete a function
Date: Wed, 16 Feb 2011 15:56:10 +0800
X-BOX-Message-Id: p1G7v9AL009190
Message-ID: <1297842971-2861-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Delete a function named rtsx_transfer_sglist which won't be called.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/rtsx_transport.c |  136 ----------------------------
 1 files changed, 0 insertions(+), 136 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx_transport.c b/drivers/staging/rts_pstor/rtsx_transport.c
index e581f15..3b160dc 100644
--- a/drivers/staging/rts_pstor/rtsx_transport.c
+++ b/drivers/staging/rts_pstor/rtsx_transport.c
@@ -715,142 +715,6 @@ out:
 	return err;
 }
 
-int rtsx_transfer_sglist(struct rtsx_chip *chip, u8 card,
-		struct scatterlist *sg, int num_sg,
-		enum dma_data_direction dma_dir, int timeout)
-{
-	struct rtsx_dev *rtsx = chip->rtsx;
-	struct completion trans_done;
-	u8 dir;
-	int buf_cnt, i;
-	int err = 0;
-	long timeleft;
-
-	if ((sg == NULL) || (num_sg <= 0))
-		return -EIO;
-
-	if (dma_dir == DMA_TO_DEVICE) {
-		dir = HOST_TO_DEVICE;
-	} else if (dma_dir == DMA_FROM_DEVICE) {
-		dir = DEVICE_TO_HOST;
-	} else {
-		return -ENXIO;
-	}
-
-	if (card == SD_CARD) {
-		rtsx->check_card_cd = SD_EXIST;
-	} else if (card == MS_CARD) {
-		rtsx->check_card_cd = MS_EXIST;
-	} else if (card == XD_CARD) {
-		rtsx->check_card_cd = XD_EXIST;
-	} else {
-		rtsx->check_card_cd = 0;
-	}
-
-	spin_lock_irq(&rtsx->reg_lock);
-
-	/* set up data structures for the wakeup system */
-	rtsx->done = &trans_done;
-
-	rtsx->trans_state = STATE_TRANS_SG;
-	rtsx->trans_result = TRANS_NOT_READY;
-
-	spin_unlock_irq(&rtsx->reg_lock);
-
-	buf_cnt = dma_map_sg(&(rtsx->pci->dev), sg, num_sg, dma_dir);
-
-	for (i = 0; i < buf_cnt; i++) {
-		u32 bier = 0;
-		u32 val = (1 << 31);
-		dma_addr_t addr = sg_dma_address(sg + i);
-		unsigned int len = sg_dma_len(sg + i);
-
-		RTSX_DEBUGP("dma_addr = 0x%x, dma_len = %d\n",
-			     (unsigned int)addr, len);
-
-		val |= (u32)(dir & 0x01) << 29;
-		val |= (u32)(len & 0x00FFFFFF);
-
-		spin_lock_irq(&rtsx->reg_lock);
-
-		init_completion(&trans_done);
-
-		if (i == (buf_cnt - 1)) {
-			/* If last transfer, disable data interrupt */
-			bier = rtsx_readl(chip, RTSX_BIER);
-			rtsx_writel(chip, RTSX_BIER, bier & 0xBFFFFFFF);
-		}
-
-		rtsx_writel(chip, RTSX_HDBAR, addr);
-		rtsx_writel(chip, RTSX_HDBCTLR, val);
-
-		spin_unlock_irq(&rtsx->reg_lock);
-
-		timeleft = wait_for_completion_interruptible_timeout(
-			&trans_done, timeout * HZ / 1000);
-		if (timeleft <= 0) {
-			RTSX_DEBUGP("Timeout (%s %d)\n", __func__, __LINE__);
-			RTSX_DEBUGP("chip->int_reg = 0x%x\n", chip->int_reg);
-			err = -ETIMEDOUT;
-			if (i == (buf_cnt - 1))
-				rtsx_writel(chip, RTSX_BIER, bier);
-			goto out;
-		}
-
-		spin_lock_irq(&rtsx->reg_lock);
-		if (rtsx->trans_result == TRANS_RESULT_FAIL) {
-			err = -EIO;
-			spin_unlock_irq(&rtsx->reg_lock);
-			if (i == (buf_cnt - 1))
-				rtsx_writel(chip, RTSX_BIER, bier);
-			goto out;
-		}
-		spin_unlock_irq(&rtsx->reg_lock);
-
-		if (i == (buf_cnt - 1)) {
-			/* If last transfer, enable data interrupt
-			 * after transfer finished
-			 */
-			rtsx_writel(chip, RTSX_BIER, bier);
-		}
-	}
-
-	/* Wait for TRANS_OK_INT */
-	spin_lock_irq(&rtsx->reg_lock);
-	if (rtsx->trans_result == TRANS_NOT_READY) {
-		init_completion(&trans_done);
-		spin_unlock_irq(&rtsx->reg_lock);
-		timeleft = wait_for_completion_interruptible_timeout(
-			&trans_done, timeout * HZ / 1000);
-		if (timeleft <= 0) {
-			RTSX_DEBUGP("Timeout (%s %d)\n", __func__, __LINE__);
-			RTSX_DEBUGP("chip->int_reg = 0x%x\n", chip->int_reg);
-			err = -ETIMEDOUT;
-			goto out;
-		}
-	} else {
-		spin_unlock_irq(&rtsx->reg_lock);
-	}
-
-	spin_lock_irq(&rtsx->reg_lock);
-	if (rtsx->trans_result == TRANS_RESULT_FAIL) {
-		err = -EIO;
-	} else if (rtsx->trans_result == TRANS_RESULT_OK) {
-		err = 0;
-	}
-	spin_unlock_irq(&rtsx->reg_lock);
-
-out:
-	rtsx->done = NULL;
-	rtsx->trans_state = STATE_TRANS_NONE;
-	dma_unmap_sg(&(rtsx->pci->dev), sg, num_sg, dma_dir);
-
-	if (err < 0)
-		rtsx_stop_cmd(chip, card);
-
-	return err;
-}
-
 int rtsx_transfer_data_partial(struct rtsx_chip *chip, u8 card,
 		void *buf, size_t len, int use_sg, unsigned int *index,
 		unsigned int *offset, enum dma_data_direction dma_dir,
-- 
1.7.4

