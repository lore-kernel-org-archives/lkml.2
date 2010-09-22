Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0IVKik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:38:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41876 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0IVKhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:37:47 -0400
From: x0130808@ti.com
To: linux-kernel@vger.kernel.org
Cc: Raja Mani <raja_mani@ti.com>, Pramodh AG <pramodh_ag@ti.com>,
        Manjunatha Halli <x0130808@ti.com>
Subject: [RFC/PATCH 1/9] drivers:staging:ti-st: sources for FM common
Date: Wed, 22 Sep 2010 07:48:31 -0400
Message-Id: <1285156119-28531-2-git-send-email-x0130808@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1285156119-28531-1-git-send-email-x0130808@ti.com>
References: <1285156119-28531-1-git-send-email-x0130808@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raja Mani <raja_mani@ti.com>

These are the sources for the common interfaces required by the FM V4L2
driver for TI WL127x and WL128x chips.

These implement the FM channel-8 protocol communication with the chip.
This makes use of the Shared Transport as its transport.

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 drivers/staging/ti-st/fmdrv_common.c | 2149 ++++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/fmdrv_common.h |  476 ++++++++
 2 files changed, 2625 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/fmdrv_common.c
 create mode 100644 drivers/staging/ti-st/fmdrv_common.h

diff --git a/drivers/staging/ti-st/fmdrv_common.c b/drivers/staging/ti-st/fmdrv_common.c
new file mode 100644
index 0000000..f086ba3
--- /dev/null
+++ b/drivers/staging/ti-st/fmdrv_common.c
@@ -0,0 +1,2149 @@
+/*
+ *  FM Driver for Connectivity chip of Texas Instruments.
+ *
+ *  This sub-module of FM driver is common for FM RX and TX
+ *  functionality. This module is responsible for:
+ *  1) Forming group of Channel-8 commands to perform particular
+ *     functionality (eg., frequency set require more than
+ *     one Channel-8 command to be sent to the chip).
+ *  2) Sending each Channel-8 command to the chip and reading
+ *     response back over Shared Transport.
+ *  3) Managing TX and RX Queues and Tasklets.
+ *  4) Handling FM Interrupt packet and taking appropriate action.
+ *  5) Loading FM firmware to the chip (common, FM TX, and FM RX
+ *     firmware files based on mode selection)
+ *
+ *  Copyright (C) 2010 Texas Instruments
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#undef DEBUG
+
+#include <linux/module.h>
+#include <linux/firmware.h>
+#include <linux/delay.h>
+#include "fmdrv.h"
+#include "fmdrv_v4l2.h"
+#include "fmdrv_common.h"
+#include "st.h"
+#include "fmdrv_rx.h"
+#include "fmdrv_tx.h"
+
+/* FM chip register table */
+static struct fm_reg_table fm_reg_info[] = {
+	/* ----- FM RX registers -------*/
+	/* opcode, type(rd/wr), reg name */
+	{0x00, REG_RD, "STEREO_GET"},
+	{0x01, REG_RD, "RSSI_LVL_GET"},
+	{0x02, REG_RD, "IF_COUNT_GET"},
+	{0x03, REG_RD, "FLAG_GET"},
+	{0x04, REG_RD, "RDS_SYNC_GET"},
+	{0x05, REG_RD, "RDS_DATA_GET"},
+	{0x0a, REG_WR, "FREQ_SET"},
+	{0x0a, REG_RD, "FREQ_GET"},
+	{0x0b, REG_WR, "AF_FREQ_SET"},
+	{0x0b, REG_RD, "AF_FREQ_GET"},
+	{0x0c, REG_WR, "MOST_MODE_SET"},
+	{0x0c, REG_RD, "MOST_MODE_GET"},
+	{0x0d, REG_WR, "MOST_BLEND_SET"},
+	{0x0d, REG_RD, "MOST_BLEND_GET"},
+	{0x0e, REG_WR, "DEMPH_MODE_SET"},
+	{0x0e, REG_RD, "DEMPH_MODE_GET"},
+	{0x0f, REG_WR, "SEARCH_LVL_SET"},
+	{0x0f, REG_RD, "SEARCH_LVL_GET"},
+	{0x10, REG_WR, "RX_BAND_SET"},
+	{0x10, REG_RD, "RX_BAND_GET"},
+	{0x11, REG_WR, "MUTE_STATUS_SET"},
+	{0x11, REG_RD, "MUTE_STATUS_GET"},
+	{0x12, REG_WR, "RDS_PAUSE_LVL_SET"},
+	{0x12, REG_RD, "RDS_PAUSE_LVL_GET"},
+	{0x13, REG_WR, "RDS_PAUSE_DUR_SET"},
+	{0x13, REG_RD, "RDS_PAUSE_DUR_GET"},
+	{0x14, REG_WR, "RDS_MEM_SET"},
+	{0x14, REG_RD, "RDS_MEM_GET"},
+	{0x15, REG_WR, "RDS_BLK_B_SET"},
+	{0x15, REG_RD, "RDS_BLK_B_GET"},
+	{0x16, REG_WR, "RDS_MSK_B_SET"},
+	{0x16, REG_RD, "RDS_MSK_B_GET"},
+	{0x17, REG_WR, "RDS_PI_MASK_SET"},
+	{0x17, REG_RD, "RDS_PI_MASK_GET"},
+	{0x18, REG_WR, "RDS_PI_SET"},
+	{0x18, REG_RD, "RDS_PI_GET"},
+	{0x19, REG_WR, "RDS_SYSTEM_SET"},
+	{0x19, REG_RD, "RDS_SYSTEM_GET"},
+	{0x1a, REG_WR, "INT_MASK_SET"},
+	{0x1a, REG_RD, "INT_MASK_GET"},
+	{0x1b, REG_WR, "SRCH_DIR_SET"},
+	{0x1b, REG_RD, "SRCH_DIR_GET"},
+	{0x1c, REG_WR, "VOLUME_SET"},
+	{0x1c, REG_RD, "VOLUME_GET"},
+	{0x1d, REG_WR, "AUDIO_ENABLE(SET)"},
+	{0x1d, REG_RD, "AUDIO_ENABLE(GET)"},
+	{0x1e, REG_WR, "PCM_MODE_SET"},
+	{0x1e, REG_RD, "PCM_MODE_SET"},
+	{0x1f, REG_WR, "I2S_MD_CFG_SET"},
+	{0x1f, REG_RD, "I2S_MD_CFG_GET"},
+	{0x20, REG_WR, "POWER_SET"},
+	{0x20, REG_RD, "POWER_GET"},
+	{0x21, REG_WR, "INTx_CONFIG_SET"},
+	{0x21, REG_RD, "INTx_CONFIG_GET"},
+	{0x22, REG_WR, "PULL_EN_SET"},
+	{0x22, REG_RD, "PULL_EN_GET"},
+	{0x23, REG_WR, "HILO_SET"},
+	{0x23, REG_RD, "HILO_GET"},
+	{0x24, REG_WR, "SWITCH2FREF"},
+	{0x25, REG_WR, "FREQ_DRIFT_REP"},
+	{0x28, REG_RD, "PCE_GET"},
+	{0x29, REG_RD, "FIRM_VER_GET"},
+	{0x2a, REG_RD, "ASIC_VER_GET"},
+	{0x2b, REG_RD, "ASIC_ID_GET"},
+	{0x2c, REG_RD, "MAIN_ID_GET"},
+	{0x2d, REG_WR, "TUNER_MODE_SET"},
+	{0x2e, REG_WR, "STOP_SEARCH"},
+	{0x2f, REG_WR, "RDS_CNTRL_SET"},
+	{0x64, REG_WR, "WR_HW_REG"},
+	{0x65, REG_WR, "CODE_DOWNLOAD"},
+	{0x66, REG_WR, "RESET"},
+	{0xfe, REG_WR, "FM_POWER_MODE(SET)"},
+	{0xff, REG_RD, "FM_INTERRUPT"},
+
+	/* --- FM TX registers ------ */
+	{0x37, REG_WR, "CHANL_SET"},
+	{0x37, REG_RD, "CHANL_GET"},
+	{0x38, REG_WR, "CHANL_BW_SET"},
+	{0x38, REG_RD, "CHANL_BW_GET"},
+	{0x87, REG_WR, "REF_SET"},
+	{0x87, REG_RD, "REF_GET"},
+	{0x5a, REG_WR, "POWER_ENB_SET"},
+	{0x3a, REG_WR, "POWER_ATT_SET"},
+	{0x3a, REG_RD, "POWER_ATT_GET"},
+	{0x3b, REG_WR, "POWER_LEL_SET"},
+	{0x3b, REG_RD, "POWER_LEL_GET"},
+	{0x3c, REG_WR, "AUDIO_DEV_SET"},
+	{0x3c, REG_RD, "AUDIO_DEV_GET"},
+	{0x3d, REG_WR, "PILOT_DEV_SET"},
+	{0x3d, REG_RD, "PILOT_DEV_GET"},
+	{0x3e, REG_WR, "RDS_DEV_SET"},
+	{0x3e, REG_RD, "RDS_DEV_GET"},
+	{0x5b, REG_WR, "PUPD_SET"},
+	{0x3f, REG_WR, "AUDIO_IO_SET"},
+	{0x40, REG_WR, "PREMPH_SET"},
+	{0x40, REG_RD, "PREMPH_GET"},
+	{0x41, REG_WR, "TX_BAND_SET"},
+	{0x41, REG_RD, "TX_BAND_GET"},
+	{0x42, REG_WR, "MONO_SET"},
+	{0x42, REG_RD, "MONO_GET"},
+	{0x5C, REG_WR, "MUTE"},
+	{0x43, REG_WR, "MPX_LMT_ENABLE"},
+	{0x06, REG_RD, "LOCK_GET"},
+	{0x5d, REG_WR, "REF_ERR_SET"},
+	{0x44, REG_WR, "PI_SET"},
+	{0x44, REG_RD, "PI_GET"},
+	{0x45, REG_WR, "TYPE_SET"},
+	{0x45, REG_RD, "TYPE_GET"},
+	{0x46, REG_WR, "PTY_SET"},
+	{0x46, REG_RD, "PTY_GET"},
+	{0x47, REG_WR, "AF_SET"},
+	{0x47, REG_RD, "AF_GET"},
+	{0x48, REG_WR, "DISPLAY_SIZE_SET"},
+	{0x48, REG_RD, "DISPLAY_SIZE_GET"},
+	{0x49, REG_WR, "RDS_MODE_SET"},
+	{0x49, REG_RD, "RDS_MODE_GET"},
+	{0x4a, REG_WR, "DISPLAY_MODE_SET"},
+	{0x4a, REG_RD, "DISPLAY_MODE_GET"},
+	{0x62, REG_WR, "LENGTH_SET"},
+	{0x4b, REG_RD, "LENGTH_GET"},
+	{0x4c, REG_WR, "TOGGLE_AB_SET"},
+	{0x4c, REG_RD, "TOGGLE_AB_GET"},
+	{0x4d, REG_WR, "RDS_REP_SET"},
+	{0x4d, REG_RD, "RDS_REP_GET"},
+	{0x63, REG_WR, "RDS_DATA_SET"},
+	{0x5e, REG_WR, "RDS_DATA_ENB"},
+	{0x4e, REG_WR, "TA_SET"},
+	{0x4e, REG_RD, "TA_GET"},
+	{0x4f, REG_WR, "TP_SET"},
+	{0x4f, REG_RD, "TP_GET"},
+	{0x50, REG_WR, "DI_SET"},
+	{0x50, REG_RD, "DI_GET"},
+	{0x51, REG_WR, "MS_SET"},
+	{0x51, REG_RD, "MS_GET"},
+	{0x52, REG_WR, "PS_SCROLL_SPEED_SET"},
+	{0x52, REG_RD, "PS_SCROLL_SPEED_GET"},
+	{0x57, REG_WR, "ANT_IMP_SET"},
+	{0x57, REG_RD, "ANT_IMP_GET"},
+};
+
+/* Region info */
+static struct region_info region_configs[] = {
+	/* Europe/US */
+	{
+	 .channel_spacing = 50,	/* 50 KHz */
+	 .bottom_frequency = 87500,	/* 87.5 MHz */
+	 .top_frequency = 108000,	/* 108 MHz */
+	 .region_index = 0,
+	 },
+	/* Japan */
+	{
+	 .channel_spacing = 50,	/* 50 KHz */
+	 .bottom_frequency = 76000,	/* 76 MHz */
+	 .top_frequency = 90000,	/* 90 MHz */
+	 .region_index = 1,
+	 },
+};
+
+/* Band selection */
+static unsigned char default_radio_region;	/* Europe/US */
+module_param(default_radio_region, byte, 0);
+MODULE_PARM_DESC(default_radio_region, "Region: 0=Europe/US, 1=Japan");
+
+/* RDS buffer blocks */
+static unsigned int default_rds_buf = 300;
+module_param(default_rds_buf, uint, 0444);
+MODULE_PARM_DESC(rds_buf, "RDS buffer entries");
+
+/* Radio Nr */
+static int radio_nr = -1;
+module_param(radio_nr, int, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio Nr");
+
+/* FM irq handlers forward declaration */
+static void fm_irq_send_flag_getcmd(void *);
+static void fm_irq_handle_flag_getcmd_resp(void *);
+static void fm_irq_handle_hw_malfunction(void *);
+static void fm_irq_handle_rds_start(void *);
+static void fm_irq_send_rdsdata_getcmd(void *);
+static void fm_irq_handle_rdsdata_getcmd_resp(void *);
+static void fm_irq_handle_rds_finish(void *);
+static void fm_irq_handle_tune_op_ended(void *);
+static void fm_irq_handle_power_enb(void *);
+static void fm_irq_handle_low_rssi_start(void *);
+static void fm_irq_afjump_set_pi(void *);
+static void fm_irq_handle_set_pi_resp(void *);
+static void fm_irq_afjump_set_pimask(void *);
+static void fm_irq_handle_set_pimask_resp(void *);
+static void fm_irq_afjump_setfreq(void *);
+static void fm_irq_handle_setfreq_resp(void *);
+static void fm_irq_afjump_enableint(void *);
+static void fm_irq_afjump_enableint_resp(void *);
+static void fm_irq_start_afjump(void *);
+static void fm_irq_handle_start_afjump_resp(void *);
+static void fm_irq_afjump_rd_freq(void *);
+static void fm_irq_afjump_rd_freq_resp(void *);
+static void fm_irq_handle_low_rssi_finish(void *);
+static void fm_irq_send_intmsk_cmd(void *);
+static void fm_irq_handle_intmsk_cmd_resp(void *);
+
+/*
+ * When FM common module receives interrupt packet, following handlers
+ * will be executed one after another to service the interrupt(s)
+ */
+enum fmc_irq_handler_index{
+	FM_SEND_FLAG_GETCMD_INDEX,
+	FM_HANDLE_FLAG_GETCMD_RESP_INDEX,
+
+	/* HW malfunction irq handler */
+	FM_HW_MAL_FUNC_INDEX,
+
+	/* RDS threshold reached irq handler */
+	FM_RDS_START_INDEX,
+	FM_RDS_SEND_RDS_GETCMD_INDEX,
+	FM_RDS_HANDLE_RDS_GETCMD_RESP_INDEX,
+	FM_RDS_FINISH_INDEX,
+
+	/* Tune operation ended irq handler */
+	FM_HW_TUNE_OP_ENDED_INDEX,
+
+	/* TX power enable irq handler */
+	FM_HW_POWER_ENB_INDEX,
+
+	/* Low RSSI irq handler */
+	FM_LOW_RSSI_START_INDEX,
+	FM_AF_JUMP_SETPI_INDEX,
+	FM_AF_JUMP_HANDLE_SETPI_RESP_INDEX,
+	FM_AF_JUMP_SETPI_MASK_INDEX,
+	FM_AF_JUMP_HANDLE_SETPI_MASK_RESP_INDEX,
+	FM_AF_JUMP_SET_AF_FREQ_INDEX,
+	FM_AF_JUMP_HENDLE_SET_AFFREQ_RESP_INDEX,
+	FM_AF_JUMP_ENABLE_INT_INDEX,
+	FM_AF_JUMP_ENABLE_INT_RESP_INDEX,
+	FM_AF_JUMP_START_AFJUMP_INDEX,
+	FM_AF_JUMP_HANDLE_START_AFJUMP_RESP_INDEX,
+	FM_AF_JUMP_RD_FREQ_INDEX,
+	FM_AF_JUMP_RD_FREQ_RESP_INDEX,
+	FM_LOW_RSSI_FINISH_INDEX,
+
+	/* Interrupt process post action */
+	FM_SEND_INTMSK_CMD_INDEX,
+	FM_HANDLE_INTMSK_CMD_RESP_INDEX,
+};
+
+/* FM interrupt handler table */
+static int_handler_prototype g_IntHandlerTable[] = {
+	fm_irq_send_flag_getcmd,
+	fm_irq_handle_flag_getcmd_resp,
+	fm_irq_handle_hw_malfunction,
+	fm_irq_handle_rds_start, /* RDS threshold reached irq handler */
+	fm_irq_send_rdsdata_getcmd,
+	fm_irq_handle_rdsdata_getcmd_resp,
+	fm_irq_handle_rds_finish,
+	fm_irq_handle_tune_op_ended,
+	fm_irq_handle_power_enb, /* TX power enable irq handler */
+	fm_irq_handle_low_rssi_start,
+	fm_irq_afjump_set_pi,
+	fm_irq_handle_set_pi_resp,
+	fm_irq_afjump_set_pimask,
+	fm_irq_handle_set_pimask_resp,
+	fm_irq_afjump_setfreq,
+	fm_irq_handle_setfreq_resp,
+	fm_irq_afjump_enableint,
+	fm_irq_afjump_enableint_resp,
+	fm_irq_start_afjump,
+	fm_irq_handle_start_afjump_resp,
+	fm_irq_afjump_rd_freq,
+	fm_irq_afjump_rd_freq_resp,
+	fm_irq_handle_low_rssi_finish,
+	fm_irq_send_intmsk_cmd, /* Interrupt process post action */
+	fm_irq_handle_intmsk_cmd_resp
+};
+
+long (*g_st_write) (struct sk_buff *skb);
+static struct completion wait_for_fmdrv_reg_comp;
+
+#ifdef FM_DUMP_TXRX_PKT
+ /* To dump outgoing FM Channel-8 packets */
+inline void dump_tx_skb_data(struct sk_buff *skb)
+{
+	int len, len_org;
+	char index;
+	struct fm_cmd_msg_hdr *cmd_hdr;
+
+	cmd_hdr = (struct fm_cmd_msg_hdr *)skb->data;
+	printk(KERN_INFO "<<%shdr:%02x len:%02x opcode:%02x type:%s dlen:%02x",
+	       fm_cb(skb)->completion ? " " : "*", cmd_hdr->header,
+	       cmd_hdr->len, cmd_hdr->fm_opcode,
+	       cmd_hdr->rd_wr ? "RD" : "WR", cmd_hdr->dlen);
+
+	len_org = skb->len - FM_CMD_MSG_HDR_SIZE;
+	if (len_org > 0) {
+		printk("\n   data(%d): ", cmd_hdr->dlen);
+		len = min(len_org, 14);
+		for (index = 0; index < len; index++)
+			printk("%x ",
+			       skb->data[FM_CMD_MSG_HDR_SIZE + index]);
+		printk("%s", (len_org > 14) ? ".." : "");
+	}
+	printk("\n");
+}
+
+ /* To dump incoming FM Channel-8 packets */
+inline void dump_rx_skb_data(struct sk_buff *skb)
+{
+	int len, len_org;
+	char index;
+	struct fm_event_msg_hdr *evt_hdr;
+
+	evt_hdr = (struct fm_event_msg_hdr *)skb->data;
+	printk(KERN_INFO ">> hdr:%02x len:%02x sts:%02x numhci:%02x "
+	    "opcode:%02x type:%s dlen:%02x", evt_hdr->header, evt_hdr->len,
+	    evt_hdr->status, evt_hdr->num_fm_hci_cmds, evt_hdr->fm_opcode,
+	    (evt_hdr->rd_wr) ? "RD" : "WR", evt_hdr->dlen);
+
+	len_org = skb->len - FM_EVT_MSG_HDR_SIZE;
+	if (len_org > 0) {
+		printk("\n   data(%d): ", evt_hdr->dlen);
+		len = min(len_org, 14);
+		for (index = 0; index < len; index++)
+			printk("%x ",
+			       skb->data[FM_EVT_MSG_HDR_SIZE + index]);
+		printk("%s", (len_org > 14) ? ".." : "");
+	}
+	printk("\n");
+}
+#endif
+
+void fmc_update_region_info(struct fmdrv_ops *fmdev,
+				unsigned char region_to_set)
+{
+	memcpy(&fmdev->rx.region, &region_configs[region_to_set],
+		sizeof(struct region_info));
+}
+
+/*
+ * FM common sub-module will schedule this tasklet whenever it receives
+ * FM packet from ST driver.
+ */
+static void __recv_tasklet(unsigned long arg)
+{
+	struct fmdrv_ops *fmdev;
+	struct fm_event_msg_hdr *fm_evt_hdr;
+	struct sk_buff *skb;
+	unsigned char num_fm_hci_cmds;
+	unsigned long flags;
+
+	fmdev = (struct fmdrv_ops *)arg;
+	/* Process all packets in the RX queue */
+	while ((skb = skb_dequeue(&fmdev->rx_q))) {
+		if (skb->len < sizeof(struct fm_event_msg_hdr)) {
+			pr_err("(fmdrv): skb(%p) has only %d bytes"
+				"atleast need %d bytes to decode\n",
+				skb, skb->len,
+				sizeof(struct fm_event_msg_hdr));
+			kfree_skb(skb);
+			continue;
+		}
+
+		fm_evt_hdr = (void *)skb->data;
+		num_fm_hci_cmds = fm_evt_hdr->num_fm_hci_cmds;
+
+		/* FM interrupt packet? */
+		if (fm_evt_hdr->fm_opcode == fm_reg_info[FM_INTERRUPT].opcode) {
+			/* FM interrupt handler started already? */
+			if (!test_bit(FM_INTTASK_RUNNING, &fmdev->flag)) {
+				set_bit(FM_INTTASK_RUNNING, &fmdev->flag);
+				if (fmdev->irq_info.stage_index != 0) {
+					pr_err("(fmdrv): Invalid stage index,"
+						"resetting to zero\n");
+					fmdev->irq_info.stage_index = 0;
+				}
+
+				/*
+				 * Execute first function in interrupt handler
+				 * table.
+				 */
+				fmdev->irq_info.fm_int_handlers
+					[fmdev->irq_info.stage_index](fmdev);
+			} else {
+				set_bit(FM_INTTASK_SCHEDULE_PENDING,
+				&fmdev->flag);
+			}
+			kfree_skb(skb);
+		}
+		/* Anyone waiting for this with completion handler? */
+		else if (fm_evt_hdr->fm_opcode == fmdev->last_sent_pkt_opcode &&
+			fmdev->response_completion != NULL) {
+			if (fmdev->response_skb != NULL)
+				pr_err("(fmdrv): Response SKB ptr not NULL\n");
+
+			spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
+			fmdev->response_skb = skb;
+			spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
+			complete(fmdev->response_completion);
+
+			fmdev->response_completion = NULL;
+			atomic_set(&fmdev->tx_cnt, 1);
+		}
+		/* Is this for interrupt handler? */
+		else if (fm_evt_hdr->fm_opcode == fmdev->last_sent_pkt_opcode &&
+			fmdev->response_completion == NULL) {
+			if (fmdev->response_skb != NULL)
+				pr_err("(fmdrv): Response SKB ptr not NULL\n");
+
+			spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
+			fmdev->response_skb = skb;
+			spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
+
+			/* Execute interrupt handler where state index points */
+			fmdev->irq_info.fm_int_handlers
+				[fmdev->irq_info.stage_index](fmdev);
+
+			kfree_skb(skb);
+			atomic_set(&fmdev->tx_cnt, 1);
+		} else {
+			pr_err("(fmdrv): Nobody claimed SKB(%p),purging\n",
+				skb);
+		}
+
+		/*
+		 * Check flow control field. If Num_FM_HCI_Commands field is
+		 * not zero, schedule FM TX tasklet.
+		 */
+		if (num_fm_hci_cmds && atomic_read(&fmdev->tx_cnt)) {
+			if (!skb_queue_empty(&fmdev->tx_q))
+				tasklet_schedule(&fmdev->tx_task);
+		}
+	}
+}
+
+/* FM send tasklet: is scheduled when FM packet has to be sent to chip */
+static void __send_tasklet(unsigned long arg)
+{
+	struct fmdrv_ops *fmdev;
+	struct sk_buff *skb;
+	int len;
+
+	fmdev = (struct fmdrv_ops *)arg;
+	/* Check, is there any timeout happenned to last transmitted packet */
+	if (!atomic_read(&fmdev->tx_cnt) &&
+		((jiffies - fmdev->last_tx_jiffies) > FM_DRV_TX_TIMEOUT)) {
+		pr_err("(fmdrv): TX timeout occurred\n");
+		atomic_set(&fmdev->tx_cnt, 1);
+	}
+	/* Send queued FM TX packets */
+	if (atomic_read(&fmdev->tx_cnt)) {
+		skb = skb_dequeue(&fmdev->tx_q);
+		if (skb) {
+			atomic_dec(&fmdev->tx_cnt);
+			fmdev->last_sent_pkt_opcode = fm_cb(skb)->fm_opcode;
+
+			if (fmdev->response_completion != NULL)
+				pr_err("(fmdrv): Response completion handler"
+						"is not NULL\n");
+
+			fmdev->response_completion = fm_cb(skb)->completion;
+
+			/* Write FM packet to ST driver */
+			len = g_st_write(skb);
+			if (len < 0) {
+				kfree_skb(skb);
+				fmdev->response_completion = NULL;
+				pr_err("(fmdrv): TX tasklet failed to send"
+					"skb(%p)\n", skb);
+				atomic_set(&fmdev->tx_cnt, 1);
+			} else {
+				fmdev->last_tx_jiffies = jiffies;
+			}
+		}
+	}
+}
+
+/*
+ * Queues FM Channel-8 packet to FM TX queue and schedules FM TX tasklet for
+ * transmission
+ */
+static int __fm_send_cmd(struct fmdrv_ops *fmdev, unsigned char fmreg_index,
+				void *payload, int payload_len,
+				struct completion *wait_completion)
+{
+	struct sk_buff *skb;
+	struct fm_cmd_msg_hdr *cmd_hdr;
+	int size;
+
+
+	if (fmreg_index >= FM_REG_MAX_ENTRIES) {
+		pr_err("(fmdrv): Invalid fm register index\n");
+		return -EINVAL;
+	}
+	if (test_bit(FM_FIRMWARE_DW_INPROGRESS, &fmdev->flag) &&
+			payload == NULL) {
+		pr_err("(fmdrv): Payload data is NULL during fw download\n");
+		return -EINVAL;
+	}
+	if (!test_bit(FM_FIRMWARE_DW_INPROGRESS, &fmdev->flag))
+		size =
+		    FM_CMD_MSG_HDR_SIZE + ((payload == NULL) ? 0 : payload_len);
+	else
+		size = payload_len;
+
+	skb = alloc_skb(size, GFP_ATOMIC);
+	if (!skb) {
+		pr_err("(fmdrv): No memory to create new SKB\n");
+		return -ENOMEM;
+	}
+	/*
+	 * Don't fill FM header info for the commands which come from
+	 * FM firmware file.
+	 */
+	if (!test_bit(FM_FIRMWARE_DW_INPROGRESS, &fmdev->flag) ||
+	    test_bit(FM_INTTASK_RUNNING, &fmdev->flag)) {
+		/* Fill command header info */
+		cmd_hdr =
+		    (struct fm_cmd_msg_hdr *)skb_put(skb, FM_CMD_MSG_HDR_SIZE);
+		cmd_hdr->header = FM_PKT_LOGICAL_CHAN_NUMBER;	/* 0x08 */
+		/* 3 (fm_opcode,rd_wr,dlen) + payload len) */
+		cmd_hdr->len = ((payload == NULL) ? 0 : payload_len) + 3;
+		/* FM opcode */
+		cmd_hdr->fm_opcode = fm_reg_info[fmreg_index].opcode;
+		/* read/write type */
+		cmd_hdr->rd_wr = fm_reg_info[fmreg_index].type;
+		cmd_hdr->dlen = payload_len;
+		fm_cb(skb)->fm_opcode = fm_reg_info[fmreg_index].opcode;
+	} else if (payload != NULL) {
+		fm_cb(skb)->fm_opcode = *((char *)payload + 2);
+	}
+	if (payload != NULL)
+		memcpy(skb_put(skb, payload_len), payload, payload_len);
+
+	fm_cb(skb)->completion = wait_completion;
+	skb_queue_tail(&fmdev->tx_q, skb);
+	tasklet_schedule(&fmdev->tx_task);
+
+	return 0;
+}
+
+/* Sends FM Channel-8 command to the chip and waits for the reponse */
+int fmc_send_cmd(struct fmdrv_ops *fmdev, unsigned char fmreg_index,
+			void *payload, int payload_len,
+			struct completion *wait_completion, void *reponse,
+			int *reponse_len)
+{
+	struct sk_buff *skb;
+	struct fm_event_msg_hdr *fm_evt_hdr;
+	unsigned long timeleft;
+	unsigned long flags;
+	int ret;
+
+	init_completion(wait_completion);
+	ret = __fm_send_cmd(fmdev, fmreg_index, payload, payload_len,
+			    wait_completion);
+	if (ret < 0)
+		return ret;
+
+	timeleft = wait_for_completion_timeout(wait_completion,
+					       FM_DRV_TX_TIMEOUT);
+	if (!timeleft) {
+		pr_err("(fmdrv): Timeout(%d sec),didn't get reg"
+			   "completion signal from RX tasklet\n",
+			   jiffies_to_msecs(FM_DRV_TX_TIMEOUT) / 1000);
+		return -ETIMEDOUT;
+	}
+	if (!fmdev->response_skb) {
+		pr_err("(fmdrv): Reponse SKB is missing\n");
+		return -EFAULT;
+	}
+	spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
+	skb = fmdev->response_skb;
+	fmdev->response_skb = NULL;
+	spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
+
+	fm_evt_hdr = (void *)skb->data;
+	if (fm_evt_hdr->status != 0) {
+		pr_err("(fmdrv): Received event pkt status(%d) is not zero\n",
+			   fm_evt_hdr->status);
+		kfree_skb(skb);
+		return -EIO;
+	}
+	/* Send reponse data to caller */
+	if (reponse != NULL && reponse_len != NULL && fm_evt_hdr->dlen) {
+		/* Skip header info and copy only response data */
+		skb_pull(skb, sizeof(struct fm_event_msg_hdr));
+		memcpy(reponse, skb->data, fm_evt_hdr->dlen);
+		*reponse_len = fm_evt_hdr->dlen;
+	} else if (reponse_len != NULL && fm_evt_hdr->dlen == 0) {
+		*reponse_len = 0;
+	}
+	kfree_skb(skb);
+	return 0;
+}
+
+/* --- Helper functions used in FM interrupt handlers ---*/
+static inline int __check_cmdresp_status(struct fmdrv_ops *fmdev,
+						struct sk_buff **skb)
+{
+	struct fm_event_msg_hdr *fm_evt_hdr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
+	*skb = fmdev->response_skb;
+	fmdev->response_skb = NULL;
+	spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
+
+	fm_evt_hdr = (void *)(*skb)->data;
+	if (fm_evt_hdr->status != 0) {
+		pr_err("(fmdrv): irq: opcode %x response status is not zero\n",
+			   fm_evt_hdr->fm_opcode);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Interrupt process timeout handler.
+ * One of the irq handler did not get proper response from the chip. So take
+ * recovery action here. FM interrupts are disabled in the beginning of
+ * interrupt process. Therefore reset stage index to re-enable default
+ * interrupts. So that next interrupt will be processed as usual.
+ */
+static void __int_timeout_handler(unsigned long data)
+{
+	struct fmdrv_ops *fmdev;
+
+	pr_debug("(fmdrv): irq: timeout,trying to re-enable fm interrupts\n");
+	fmdev = (struct fmdrv_ops *)data;
+	fmdev->irq_info.irq_service_timeout_retry++;
+
+	if (fmdev->irq_info.irq_service_timeout_retry <=
+	    FM_IRQ_TIMEOUT_RETRY_MAX) {
+		fmdev->irq_info.stage_index = FM_SEND_INTMSK_CMD_INDEX;
+		fmdev->irq_info.fm_int_handlers[fmdev->irq_info.
+							 stage_index] (fmdev);
+	} else {
+		/*
+		 * Stop recovery action (interrupt reenable process) and
+		 * reset stage index & retry count values
+		 */
+		fmdev->irq_info.stage_index = 0;
+		fmdev->irq_info.irq_service_timeout_retry = 0;
+		pr_err("(fmdrv): Recovery action failed during"
+			"irq processing, max retry reached\n");
+	}
+}
+
+/* --------- FM interrupt handlers ------------*/
+static void fm_irq_send_flag_getcmd(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	unsigned short flag;
+	int ret;
+
+	fmdev = arg;
+	/* Send FLAG_GET command , to know the source of interrupt */
+	ret = __fm_send_cmd(fmdev, FLAG_GET, NULL, sizeof(flag), NULL);
+	if (ret)
+		pr_err("(fmdrv): irq: failed to send flag_get command,"
+			   "initiating irq recovery process\n");
+	else
+		fmdev->irq_info.stage_index = FM_HANDLE_FLAG_GETCMD_RESP_INDEX;
+
+	mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+		  FM_DRV_TX_TIMEOUT);
+}
+
+static void fm_irq_handle_flag_getcmd_resp(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	struct sk_buff *skb;
+	struct fm_event_msg_hdr *fm_evt_hdr;
+	char ret;
+
+	fmdev = arg;
+	del_timer(&fmdev->irq_info.int_timeout_timer);
+
+	ret = __check_cmdresp_status(fmdev, &skb);
+	if (ret < 0) {
+		pr_err("(fmdrv): Initiating irq recovery process\n");
+		mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+			  FM_DRV_TX_TIMEOUT);
+		return;
+	}
+	fm_evt_hdr = (void *)skb->data;
+
+	/* Skip header info and copy only response data */
+	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
+	memcpy(&fmdev->irq_info.flag, skb->data, fm_evt_hdr->dlen);
+
+	FM_STORE_BE16_TO_LE16(fmdev->irq_info.flag, fmdev->irq_info.flag);
+	pr_debug("(fmdrv): irq: flag register(0x%x)\n", fmdev->irq_info.flag);
+
+	/* Continue next function in interrupt handler table */
+	fmdev->irq_info.stage_index = FM_HW_MAL_FUNC_INDEX;
+
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_handle_hw_malfunction(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+
+	fmdev = arg;
+	if (fmdev->irq_info.flag & FM_MAL_EVENT & fmdev->irq_info.mask)
+		pr_err("(fmdrv): irq: HW MAL int received - do nothing\n");
+
+	/* Continue next function in interrupt handler table */
+	fmdev->irq_info.stage_index = FM_RDS_START_INDEX;
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_handle_rds_start(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+
+	fmdev = arg;
+	if (fmdev->irq_info.flag & FM_RDS_EVENT & fmdev->irq_info.mask) {
+		pr_debug("(fmdrv): irq: rds threshold reached\n");
+		fmdev->irq_info.stage_index = FM_RDS_SEND_RDS_GETCMD_INDEX;
+	} else {
+		/* Continue next function in interrupt handler table */
+		fmdev->irq_info.stage_index = FM_HW_TUNE_OP_ENDED_INDEX;
+	}
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_send_rdsdata_getcmd(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	int ret;
+
+	fmdev = arg;
+	/* Send the command to read RDS data from the chip */
+	ret = __fm_send_cmd(fmdev, RDS_DATA_GET, NULL,
+			    (FM_RX_RDS_FIFO_THRESHOLD * 3), NULL);
+	if (ret < 0)
+		pr_err("(fmdrv): irq : failed to send rds get command,"
+			   "initiating irq recovery process\n");
+	else
+		fmdev->irq_info.stage_index =
+		    FM_RDS_HANDLE_RDS_GETCMD_RESP_INDEX;
+
+	/* Start timer to track timeout */
+	mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+		  FM_DRV_TX_TIMEOUT);
+}
+
+/* Keeps track of current RX channel AF (Alternate Frequency) */
+static void __fm_rx_update_af_cache(struct fmdrv_ops *fmdev,
+					unsigned char af)
+{
+	unsigned char index;
+	unsigned int freq;
+
+	/* First AF indicates the number of AF follows. Reset the list */
+	if ((af >= FM_RDS_1_AF_FOLLOWS) && (af <= FM_RDS_25_AF_FOLLOWS)) {
+		fmdev->rx.cur_station_info.af_list_max =
+		    (af - FM_RDS_1_AF_FOLLOWS + 1);
+		fmdev->rx.cur_station_info.no_of_items_in_afcache = 0;
+		pr_debug("(fmdrv): No of expected AF : %d\n",
+			   fmdev->rx.cur_station_info.af_list_max);
+	} else if (((af >= FM_RDS_MIN_AF)
+		    && (fmdev->rx.region.region_index == FM_BAND_EUROPE_US)
+		    && (af <= FM_RDS_MAX_AF)) || ((af >= FM_RDS_MIN_AF)
+						  && (fmdev->rx.region.
+						      region_index ==
+						      FM_BAND_JAPAN)
+						  && (af <=
+						      FM_RDS_MAX_AF_JAPAN))) {
+		freq = fmdev->rx.region.bottom_frequency + (af * 100);
+		if (freq == fmdev->rx.curr_freq) {
+			pr_debug("(fmdrv): Current frequency(%d) is"
+				"matching with received AF(%d)\n",
+			    fmdev->rx.curr_freq, freq);
+			return;
+		}
+		/* Do check in AF cache */
+		for (index = 0;
+		     index < fmdev->rx.cur_station_info.no_of_items_in_afcache;
+		     index++) {
+			if (fmdev->rx.cur_station_info.af_cache[index] == freq)
+				break;
+		}
+		/* Reached the limit of the list - ignore the next AF */
+		if (index == fmdev->rx.cur_station_info.af_list_max) {
+			pr_debug("(fmdrv): AF cache is full\n");
+			return;
+		}
+		/*
+		 * If we reached the end of the list then this AF is not
+		 * in the list - add it.
+		 */
+		if (index == fmdev->rx.cur_station_info.
+				   no_of_items_in_afcache) {
+			pr_debug("(fmdrv): Storing AF %d to cache index %d\n",
+					freq, index);
+			fmdev->rx.cur_station_info.af_cache[index] = freq;
+			fmdev->rx.cur_station_info.no_of_items_in_afcache++;
+		}
+	}
+}
+
+/*
+ * Converts RDS buffer data from big endian format
+ * to little endian format.
+ */
+static void __fm_rdsparse_swapbytes(struct fmdrv_ops *fmdev,
+					struct fm_rdsdata_format *rds_format)
+{
+	unsigned char byte1;
+	unsigned char index = 0;
+	char *rds_buff;
+
+	/*
+	 * Since in Orca the 2 RDS Data bytes are in little endian and
+	 * in Dolphin they are in big endian, the parsing of the RDS data
+	 * is chip dependent
+	 */
+	if (fmdev->asci_id != 0x6350) {
+		rds_buff = &rds_format->rdsdata.groupdatabuff.rdsbuff[0];
+		while (index + 1 < FM_RX_RDS_INFO_FIELD_MAX) {
+			byte1 = rds_buff[index];
+			rds_buff[index] = rds_buff[index + 1];
+			rds_buff[index + 1] = byte1;
+			index += 2;
+		}
+	}
+}
+
+static void fm_irq_handle_rdsdata_getcmd_resp(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	struct sk_buff *skb;
+	char *rds_data;
+	char meta_data;
+	unsigned char type, block_index;
+	unsigned long group_index;
+	struct fm_rdsdata_format rds_format;
+	int rds_len, ret;
+	unsigned short cur_picode;
+	unsigned char tmpbuf[3];
+	unsigned long flags;
+
+	fmdev = arg;
+	del_timer(&fmdev->irq_info.int_timeout_timer);
+
+	ret = __check_cmdresp_status(fmdev, &skb);
+	if (ret < 0) {
+		pr_err("(fmdrv): Initiating irq recovery process\n");
+		mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+			  FM_DRV_TX_TIMEOUT);
+		return;
+	}
+	/* Skip header info */
+	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
+	rds_data = skb->data;
+	rds_len = skb->len;
+
+	/* Parse the RDS data */
+	while (rds_len >= FM_RDS_BLOCK_SIZE) {
+		meta_data = rds_data[2];
+		/*
+		 * Get the type:
+		 * 0=A, 1=B, 2=C, 3=C', 4=D, 5=E
+		 */
+		type = (meta_data & 0x07);
+
+		/*
+		 * Transform the block type into an
+		 * index sequence (0, 1, 2, 3, 4)
+		 */
+		block_index = (type <= FM_RDS_BLOCK_C ? type : (type - 1));
+		pr_debug("(fmdrv): Block index:%d(%s)\n", block_index,
+			   (meta_data & FM_RDS_STATUS_ERROR_MASK) ? "Bad" :
+			   "Ok");
+		if (((meta_data & FM_RDS_STATUS_ERROR_MASK) == 0)
+		    && (block_index == FM_RDS_BLOCK_INDEX_A
+			|| (block_index == fmdev->rx.rds.last_block_index + 1
+			    && block_index <= FM_RDS_BLOCK_INDEX_D))) {
+			/*
+			 * Skip checkword (control) byte and copy only data
+			 * byte
+			 */
+			memcpy(&rds_format.rdsdata.groupdatabuff.
+			       rdsbuff[block_index * (FM_RDS_BLOCK_SIZE - 1)],
+			       rds_data, (FM_RDS_BLOCK_SIZE - 1));
+			fmdev->rx.rds.last_block_index = block_index;
+
+			/* If completed a whole group then handle it */
+			if (block_index == FM_RDS_BLOCK_INDEX_D) {
+				pr_debug("(fmdrv): Good block received\n");
+				__fm_rdsparse_swapbytes(fmdev, &rds_format);
+
+				/*
+				 * Extract PI code and store in local cache.
+				 * We need this during AF switch processing.
+				 */
+				cur_picode =
+				    FM_BE16_TO_LE16(rds_format.rdsdata.
+						    groupgeneral.pidata);
+				if (fmdev->rx.cur_station_info.picode !=
+				    cur_picode)
+					fmdev->rx.cur_station_info.picode =
+					    cur_picode;
+				pr_debug("(fmdrv): picode:%d\n", cur_picode);
+
+				group_index =
+				    (rds_format.rdsdata.groupgeneral.
+				     block_b_byte1 >> 3);
+				pr_debug("(fmdrv):Group:%ld%s\n", group_index/2,
+					   (group_index % 2) ? "B" : "A");
+
+				group_index =
+				    1 << (rds_format.rdsdata.groupgeneral.
+					  block_b_byte1 >> 3);
+				if (group_index == FM_RDS_GROUP_TYPE_MASK_0A) {
+					__fm_rx_update_af_cache
+					    (fmdev, rds_format.rdsdata.
+					     group0A.firstaf);
+					__fm_rx_update_af_cache
+						(fmdev, rds_format.
+						 rdsdata.group0A.secondaf);
+				}
+			}
+		} else {
+			pr_debug("(fmdrv): Block sequence mismatch\n");
+			fmdev->rx.rds.last_block_index = -1;
+		}
+		rds_len -= FM_RDS_BLOCK_SIZE;
+		rds_data += FM_RDS_BLOCK_SIZE;
+	}
+
+	/* Copy raw rds data to internal rds buffer */
+	rds_data = skb->data;
+	rds_len = skb->len;
+
+	spin_lock_irqsave(&fmdev->rds_buff_lock, flags);
+	while (rds_len > 0) {
+		/*
+		 * Fill RDS buffer as per V4L2 specification.
+		 * Store control byte
+		 */
+		type = (rds_data[2] & 0x07);
+		block_index = (type <= FM_RDS_BLOCK_C ? type : (type - 1));
+		tmpbuf[2] = block_index;	/* Offset name */
+		tmpbuf[2] |= block_index << 3;	/* Received offset */
+
+		/* Store data byte */
+		tmpbuf[0] = rds_data[0];
+		tmpbuf[1] = rds_data[1];
+
+		memcpy(&fmdev->rx.rds.buffer[fmdev->rx.rds.wr_index], &tmpbuf,
+		       FM_RDS_BLOCK_SIZE);
+		fmdev->rx.rds.wr_index =
+		    (fmdev->rx.rds.wr_index +
+		     FM_RDS_BLOCK_SIZE) % fmdev->rx.rds.buf_size;
+
+		/* Check for overflow & start over */
+		if (fmdev->rx.rds.wr_index == fmdev->rx.rds.rd_index) {
+			pr_debug("(fmdrv): RDS buffer overflow\n");
+			fmdev->rx.rds.wr_index = 0;
+			fmdev->rx.rds.rd_index = 0;
+			break;
+		}
+		rds_len -= FM_RDS_BLOCK_SIZE;
+		rds_data += FM_RDS_BLOCK_SIZE;
+	}
+	spin_unlock_irqrestore(&fmdev->rds_buff_lock, flags);
+
+	/* Wakeup read queue */
+	if (fmdev->rx.rds.wr_index != fmdev->rx.rds.rd_index)
+		wake_up_interruptible(&fmdev->rx.rds.read_queue);
+
+	fmdev->irq_info.stage_index = FM_RDS_FINISH_INDEX;
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_handle_rds_finish(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+
+	fmdev = arg;
+	/* Continue next function in interrupt handler table */
+	fmdev->irq_info.stage_index = FM_HW_TUNE_OP_ENDED_INDEX;
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_handle_tune_op_ended(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+
+	fmdev = arg;
+	if (fmdev->irq_info.flag & (FM_FR_EVENT | FM_BL_EVENT) & fmdev->
+	    irq_info.mask) {
+		pr_debug("(fmdrv): irq: tune ended/bandlimit reached\n");
+		if (test_and_clear_bit(FM_AF_SWITCH_INPROGRESS, &fmdev->flag)) {
+			fmdev->irq_info.stage_index = FM_AF_JUMP_RD_FREQ_INDEX;
+		} else {
+			complete(&fmdev->maintask_completion);
+			fmdev->irq_info.stage_index = FM_HW_POWER_ENB_INDEX;
+		}
+	} else
+		fmdev->irq_info.stage_index = FM_HW_POWER_ENB_INDEX;
+
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_handle_power_enb(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+
+	fmdev = arg;
+	if (fmdev->irq_info.flag & FM_POW_ENB_EVENT) {
+		pr_debug("(fmdrv): irq: Power Enabled/Disabled\n");
+		complete(&fmdev->maintask_completion);
+	}
+
+	/* Continue next function in interrupt handler table */
+	fmdev->irq_info.stage_index = FM_LOW_RSSI_START_INDEX;
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_handle_low_rssi_start(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+
+	fmdev = arg;
+	if ((fmdev->rx.af_mode == FM_RX_RDS_AF_SWITCH_MODE_ON) &&
+	    (fmdev->irq_info.flag & FM_LEV_EVENT & fmdev->irq_info.mask) &&
+	    (fmdev->rx.curr_freq != FM_UNDEFINED_FREQ) &&
+	    (fmdev->rx.cur_station_info.no_of_items_in_afcache != 0)) {
+		pr_debug("(fmdrv): irq: rssi level has fallen below"
+			" threshold level\n");
+
+		/* Disable further low RSSI interrupts */
+		fmdev->irq_info.mask &= ~FM_LEV_EVENT;
+
+		fmdev->rx.cur_afjump_index = 0;
+		fmdev->rx.freq_before_jump = fmdev->rx.curr_freq;
+		fmdev->irq_info.stage_index = FM_AF_JUMP_SETPI_INDEX;
+	} else {
+		/* Continue next function in interrupt handler table */
+		fmdev->irq_info.stage_index = FM_SEND_INTMSK_CMD_INDEX;
+	}
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_afjump_set_pi(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	int ret;
+	unsigned short payload;
+
+	fmdev = arg;
+	/* Set PI code - must be updated if the AF list is not empty */
+	payload = FM_LE16_TO_BE16(fmdev->rx.cur_station_info.picode);
+	ret = __fm_send_cmd(fmdev, RDS_PI_SET, &payload, sizeof(payload),
+			    NULL);
+	if (ret < 0)
+		pr_err("(fmdrv): irq : failed to set PI,"
+			   "initiating irq recovery process\n");
+	else
+		fmdev->irq_info.stage_index =
+		    FM_AF_JUMP_HANDLE_SETPI_RESP_INDEX;
+
+	mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+		  FM_DRV_TX_TIMEOUT);
+}
+
+static void fm_irq_handle_set_pi_resp(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	struct sk_buff *skb;
+	int ret;
+
+	fmdev = arg;
+	del_timer(&fmdev->irq_info.int_timeout_timer);
+
+	ret = __check_cmdresp_status(fmdev, &skb);
+	if (ret < 0) {
+		pr_err("(fmdrv): Initiating irq recovery process\n");
+		mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+			  FM_DRV_TX_TIMEOUT);
+		return;
+	}
+	/* Continue next function in interrupt handler table */
+	fmdev->irq_info.stage_index = FM_AF_JUMP_SETPI_MASK_INDEX;
+
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+/*
+ * Set PI mask.
+ * 0xFFFF = Enable PI code matching
+ * 0x0000 = Disable PI code matching
+ */
+static void fm_irq_afjump_set_pimask(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	int ret;
+	unsigned short payload;
+
+	fmdev = arg;
+	payload = 0x0000;
+	ret = __fm_send_cmd(fmdev, RDS_PI_MASK_SET, &payload, sizeof(payload),
+				NULL);
+	if (ret < 0)
+		pr_err("(fmdrv): irq: failed to set PI mask, "
+			   "initiating irq recovery process\n");
+	else
+		fmdev->irq_info.stage_index =
+		    FM_AF_JUMP_HANDLE_SETPI_MASK_RESP_INDEX;
+
+	mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+		  FM_DRV_TX_TIMEOUT);
+}
+
+static void fm_irq_handle_set_pimask_resp(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	struct sk_buff *skb;
+	int ret;
+
+	fmdev = arg;
+	del_timer(&fmdev->irq_info.int_timeout_timer);
+
+	ret = __check_cmdresp_status(fmdev, &skb);
+	if (ret < 0) {
+		pr_err("(fmdrv): Initiating irq recovery process\n");
+		mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+			  FM_DRV_TX_TIMEOUT);
+		return;
+	}
+	/* Continue next function in interrupt handler table */
+	fmdev->irq_info.stage_index = FM_AF_JUMP_SET_AF_FREQ_INDEX;
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_afjump_setfreq(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	unsigned short frq_index;
+	unsigned short payload;
+	int ret;
+
+	fmdev = arg;
+	pr_debug("(fmdrv): Swtiching to %d KHz\n",
+	       fmdev->rx.cur_station_info.af_cache[fmdev->rx.cur_afjump_index]);
+	frq_index =
+	    (fmdev->rx.cur_station_info.af_cache[fmdev->rx.cur_afjump_index] -
+	     fmdev->rx.region.bottom_frequency) /
+	    fmdev->rx.region.channel_spacing;
+
+	FM_STORE_LE16_TO_BE16(payload, frq_index);
+	ret = __fm_send_cmd(fmdev, AF_FREQ_SET, &payload, sizeof(payload),
+				NULL);
+	if (ret < 0)
+		pr_err("(fmdrv): irq : failed to set AF freq, "
+			   "initiating irq recovery process\n");
+	else
+		fmdev->irq_info.stage_index =
+		    FM_AF_JUMP_HENDLE_SET_AFFREQ_RESP_INDEX;
+
+	mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+		  FM_DRV_TX_TIMEOUT);
+}
+
+static void fm_irq_handle_setfreq_resp(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	struct sk_buff *skb;
+	int ret;
+
+	fmdev = arg;
+	del_timer(&fmdev->irq_info.int_timeout_timer);
+
+	ret = __check_cmdresp_status(fmdev, &skb);
+	if (ret < 0) {
+		pr_err("(fmdrv): Initiating irq recovery process\n");
+		mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+			  FM_DRV_TX_TIMEOUT);
+		return;
+	} else {
+		/* Continue next function in interrupt handler table */
+		fmdev->irq_info.stage_index = FM_AF_JUMP_ENABLE_INT_INDEX;
+	}
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_afjump_enableint(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	unsigned short payload;
+	int ret;
+
+	fmdev = arg;
+	/* Enable FR (tuning operation ended) interrupt */
+	payload = FM_LE16_TO_BE16(FM_FR_EVENT);
+	ret = __fm_send_cmd(fmdev, INT_MASK_SET, &payload, sizeof(payload),
+				NULL);
+	if (ret)
+		pr_err("(fmdrv): irq : failed to enable FR interrupt, "
+			   "initiating irq recovery process\n");
+	else
+		fmdev->irq_info.stage_index = FM_AF_JUMP_ENABLE_INT_RESP_INDEX;
+
+	mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+		  FM_DRV_TX_TIMEOUT);
+}
+
+static void fm_irq_afjump_enableint_resp(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	struct sk_buff *skb;
+	int ret;
+
+	fmdev = arg;
+	del_timer(&fmdev->irq_info.int_timeout_timer);
+
+	ret = __check_cmdresp_status(fmdev, &skb);
+	if (ret < 0) {
+		pr_err("(fmdrv): Initiating irq recovery process\n");
+		mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+			  FM_DRV_TX_TIMEOUT);
+		return;
+	}
+	/* Continue next function in interrupt handler table */
+	fmdev->irq_info.stage_index = FM_AF_JUMP_START_AFJUMP_INDEX;
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_start_afjump(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	unsigned short payload;
+	int ret;
+
+	fmdev = arg;
+	FM_STORE_LE16_TO_BE16(payload, FM_TUNER_AF_JUMP_MODE);
+	ret = __fm_send_cmd(fmdev, TUNER_MODE_SET, &payload, sizeof(payload),
+				NULL);
+	if (ret)
+		pr_err("(fmdrv): irq : failed to start af switch, "
+			   "initiating irq recovery process\n");
+	else
+		fmdev->irq_info.stage_index =
+		    FM_AF_JUMP_HANDLE_START_AFJUMP_RESP_INDEX;
+
+	mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+		  FM_DRV_TX_TIMEOUT);
+}
+
+static void fm_irq_handle_start_afjump_resp(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	struct sk_buff *skb;
+	int ret;
+
+	fmdev = arg;
+	del_timer(&fmdev->irq_info.int_timeout_timer);
+
+	ret = __check_cmdresp_status(fmdev, &skb);
+	if (ret < 0) {
+		pr_err("(fmdrv): Initiating irq recovery process\n");
+		mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+			  FM_DRV_TX_TIMEOUT);
+		return;
+	}
+	fmdev->irq_info.stage_index = FM_SEND_FLAG_GETCMD_INDEX;
+	set_bit(FM_AF_SWITCH_INPROGRESS, &fmdev->flag);
+	clear_bit(FM_INTTASK_RUNNING, &fmdev->flag);
+}
+
+static void fm_irq_afjump_rd_freq(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	unsigned short payload;
+	int ret;
+
+	fmdev = arg;
+	ret = __fm_send_cmd(fmdev, FREQ_GET, NULL, sizeof(payload), NULL);
+	if (ret < 0)
+		pr_err("(fmdrv): irq: failed to read cur freq, "
+			   "initiating irq recovery process\n");
+	else
+		fmdev->irq_info.stage_index = FM_AF_JUMP_RD_FREQ_RESP_INDEX;
+
+	/* Start timer to track timeout */
+	mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+		  FM_DRV_TX_TIMEOUT);
+}
+
+static void fm_irq_afjump_rd_freq_resp(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	struct sk_buff *skb;
+	unsigned short read_freq;
+	unsigned int curr_freq, jumped_freq;
+	int ret;
+
+	fmdev = arg;
+	del_timer(&fmdev->irq_info.int_timeout_timer);
+
+	ret = __check_cmdresp_status(fmdev, &skb);
+	if (ret < 0) {
+		pr_err("(fmdrv): Initiating irq recovery process\n");
+		mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+			  FM_DRV_TX_TIMEOUT);
+		return;
+	}
+	/* Skip header info and copy only response data */
+	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
+	memcpy(&read_freq, skb->data, sizeof(read_freq));
+	read_freq = FM_BE16_TO_LE16(read_freq);
+	curr_freq = fmdev->rx.region.bottom_frequency +
+	    ((unsigned int)read_freq * fmdev->rx.region.channel_spacing);
+
+	jumped_freq =
+	    fmdev->rx.cur_station_info.af_cache[fmdev->rx.cur_afjump_index];
+
+	/* If the frequency was changed the jump succeeded */
+	if ((curr_freq != fmdev->rx.freq_before_jump) &&
+	    (curr_freq == jumped_freq)) {
+		pr_debug("(fmdrv): Successfully switched to alternate"
+			"frequency %d\n", curr_freq);
+		fmdev->rx.curr_freq = curr_freq;
+		fm_rx_reset_rds_cache(fmdev);
+
+		/* AF feature is on, enable low level RSSI interrupt */
+		if (fmdev->rx.af_mode == FM_RX_RDS_AF_SWITCH_MODE_ON)
+			fmdev->irq_info.mask |= FM_LEV_EVENT;
+
+		fmdev->irq_info.stage_index = FM_LOW_RSSI_FINISH_INDEX;
+	} else {		/* jump to the next freq in the AF list */
+		fmdev->rx.cur_afjump_index++;
+
+		/* If we reached the end of the list - stop searching */
+		if (fmdev->rx.cur_afjump_index >=
+		    fmdev->rx.cur_station_info.no_of_items_in_afcache) {
+			pr_debug("(fmdrv): AF switch processing failed\n");
+			fmdev->irq_info.stage_index = FM_LOW_RSSI_FINISH_INDEX;
+		} else {	/* AF List is not over - try next one */
+
+			pr_debug("(fmdrv): Trying next freq in AF cache\n");
+			fmdev->irq_info.stage_index = FM_AF_JUMP_SETPI_INDEX;
+		}
+	}
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_handle_low_rssi_finish(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+
+	fmdev = arg;
+	/* Continue next function in interrupt handler table */
+	fmdev->irq_info.stage_index = FM_SEND_INTMSK_CMD_INDEX;
+	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
+}
+
+static void fm_irq_send_intmsk_cmd(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	unsigned short payload;
+	int ret;
+
+	fmdev = arg;
+
+	/* Re-enable FM interrupts */
+	FM_STORE_LE16_TO_BE16(payload, fmdev->irq_info.mask);
+	ret = __fm_send_cmd(fmdev, INT_MASK_SET, &payload, sizeof(payload),
+				NULL);
+	if (ret)
+		pr_err("(fmdrv): irq: failed to send int_mask_set cmd, "
+			   "initiating irq recovery process\n");
+	else
+		fmdev->irq_info.stage_index = FM_HANDLE_INTMSK_CMD_RESP_INDEX;
+
+	/* Start timer to track timeout */
+	mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+		  FM_DRV_TX_TIMEOUT);
+}
+
+static void fm_irq_handle_intmsk_cmd_resp(void *arg)
+{
+	struct fmdrv_ops *fmdev;
+	struct sk_buff *skb;
+	int ret;
+
+	fmdev = arg;
+	del_timer(&fmdev->irq_info.int_timeout_timer);
+
+	ret = __check_cmdresp_status(fmdev, &skb);
+	if (ret < 0) {
+		pr_err("(fmdrv): Initiating irq recovery process\n");
+		mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
+			  FM_DRV_TX_TIMEOUT);
+		return;
+	}
+	/*
+	 * This is last function in interrupt table to be executed.
+	 * So, reset stage index to 0.
+	 */
+	fmdev->irq_info.stage_index = FM_SEND_FLAG_GETCMD_INDEX;
+
+	/* Start processing any pending interrupt */
+	if (test_and_clear_bit(FM_INTTASK_SCHEDULE_PENDING, &fmdev->flag)) {
+		fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index]
+						(fmdev);
+	} else
+		clear_bit(FM_INTTASK_RUNNING, &fmdev->flag);
+}
+
+/* Returns availability of RDS data in internel buffer */
+int fmc_is_rds_data_available(struct fmdrv_ops *fmdev, struct file *file,
+				struct poll_table_struct *pts)
+{
+	poll_wait(file, &fmdev->rx.rds.read_queue, pts);
+	if (fmdev->rx.rds.rd_index != fmdev->rx.rds.wr_index)
+		return 0;
+
+	return -EAGAIN;
+}
+
+/* Copies RDS data from internal buffer to user buffer */
+int fmc_transfer_rds_from_internal_buff(struct fmdrv_ops *fmdev,
+					struct file *file,
+					char __user *buf, size_t count)
+{
+	unsigned int block_count;
+	unsigned long flags;
+	int ret;
+
+	if (fmdev->rx.rds.wr_index == fmdev->rx.rds.rd_index) {
+		if (file->f_flags & O_NONBLOCK)
+			return -EWOULDBLOCK;
+
+		ret = wait_event_interruptible(fmdev->rx.rds.read_queue,
+					       (fmdev->rx.rds.wr_index !=
+						fmdev->rx.rds.rd_index));
+		if (ret)
+			return -EINTR;
+	}
+
+	/* Calculate block count from byte count */
+	count /= 3;
+	block_count = 0;
+	ret = 0;
+
+	spin_lock_irqsave(&fmdev->rds_buff_lock, flags);
+
+	while (block_count < count) {
+		if (fmdev->rx.rds.wr_index == fmdev->rx.rds.rd_index)
+			break;
+
+		if (copy_to_user
+		    (buf, &fmdev->rx.rds.buffer[fmdev->rx.rds.rd_index],
+		     FM_RDS_BLOCK_SIZE))
+			break;
+
+		fmdev->rx.rds.rd_index += FM_RDS_BLOCK_SIZE;
+		if (fmdev->rx.rds.rd_index >= fmdev->rx.rds.buf_size)
+			fmdev->rx.rds.rd_index = 0;
+
+		block_count++;
+		buf += FM_RDS_BLOCK_SIZE;
+		ret += FM_RDS_BLOCK_SIZE;
+	}
+	spin_unlock_irqrestore(&fmdev->rds_buff_lock, flags);
+	return ret;
+}
+
+int fmc_set_frequency(struct fmdrv_ops *fmdev, unsigned int freq_to_set)
+{
+	int ret;
+
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		ret = fm_rx_set_frequency(fmdev, freq_to_set);
+		break;
+
+	case FM_MODE_TX:
+		ret = fm_tx_set_frequency(fmdev, freq_to_set);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+int fmc_get_frequency(struct fmdrv_ops *fmdev, unsigned int *cur_tuned_frq)
+{
+	int ret = 0;
+
+	if (fmdev->rx.curr_freq == FM_UNDEFINED_FREQ) {
+		pr_err("(fmdrv): RX frequency is not set\n");
+		return -EPERM;
+	}
+	if (cur_tuned_frq == NULL) {
+		pr_err("(fmdrv): Invalid memory\n");
+		return -ENOMEM;
+	}
+
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		*cur_tuned_frq = fmdev->rx.curr_freq;
+		break;
+
+	case FM_MODE_TX:
+		*cur_tuned_frq = 0;	/* TODO : Change this later */
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+int fmc_set_region(struct fmdrv_ops *fmdev, unsigned char region_to_set)
+{
+	int ret;
+
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		ret = fm_rx_set_region(fmdev, region_to_set);
+		break;
+
+	case FM_MODE_TX:
+		ret = fm_tx_set_region(fmdev, region_to_set);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+int fmc_set_mute_mode(struct fmdrv_ops *fmdev, unsigned char mute_mode_toset)
+{
+	int ret;
+
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		ret = fm_rx_set_mute_mode(fmdev, mute_mode_toset);
+		break;
+
+	case FM_MODE_TX:
+		ret = fm_tx_set_mute_mode(fmdev, mute_mode_toset);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+int fmc_set_stereo_mono(struct fmdrv_ops *fmdev, unsigned short mode)
+{
+	int ret;
+
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		ret = fm_rx_set_stereo_mono(fmdev, mode);
+		break;
+
+	case FM_MODE_TX:
+		ret = fm_tx_set_stereo_mono(fmdev, mode);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+int fmc_set_rds_mode(struct fmdrv_ops *fmdev, unsigned char rds_en_dis)
+{
+	int ret;
+
+	switch (fmdev->curr_fmmode) {
+	case FM_MODE_RX:
+		ret = fm_rx_set_rds_mode(fmdev, rds_en_dis);
+		break;
+
+	case FM_MODE_TX:
+		ret = fm_tx_set_rds_mode(fmdev, rds_en_dis);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+/* Sends power off command to the chip */
+static int fm_power_down(struct fmdrv_ops *fmdev)
+{
+	unsigned short payload;
+	int ret = 0;
+
+	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
+		pr_err("(fmdrv): FM core is not ready\n");
+		return -EPERM;
+	}
+	if (fmdev->curr_fmmode == FM_MODE_OFF) {
+		pr_debug("(fmdrv): FM chip is already in OFF state\n");
+		return ret;
+	}
+
+	FM_STORE_LE16_TO_BE16(payload, 0x0);
+	ret = fmc_send_cmd(fmdev, FM_POWER_MODE, &payload, sizeof(payload),
+			   &fmdev->maintask_completion, NULL, NULL);
+	if (ret < 0) {
+		pr_err("(fmdrv): Failed to send power down command - %d\n",
+			ret);
+		return ret;
+	}
+
+	ret = fmc_release(fmdev);
+	if (ret < 0)
+		pr_err("(fmdrv): FM CORE release failed\n");
+
+	return ret;
+}
+
+/* Reads init command from FM firmware file and loads to the chip */
+static int fm_download_firmware(struct fmdrv_ops *fmdev,
+				const char *firmware_name)
+{
+	const struct firmware *fw_entry;
+	struct bts_header *fw_header;
+	struct bts_action *action;
+	struct bts_action_delay *delay;
+	char *fw_data;
+	int ret, fw_len, cmd_cnt;
+
+	cmd_cnt = 0;
+	set_bit(FM_FIRMWARE_DW_INPROGRESS, &fmdev->flag);
+
+	ret = request_firmware(&fw_entry, firmware_name,
+				&fmdev->radio_dev->dev);
+	if (ret < 0) {
+		pr_err("(fmdrv): Unable to read firmware(%s) content\n",
+			   firmware_name);
+		goto exit;
+	}
+	pr_debug("(fmdrv): Firmware(%s) length : %d bytes\n", firmware_name,
+		   fw_entry->size);
+
+	fw_data = (void *)fw_entry->data;
+	fw_len = fw_entry->size;
+
+	fw_header = (struct bts_header *)fw_data;
+	if (fw_header->magic != FM_FW_FILE_HEADER_MAGIC) {
+		pr_err("(fmdrv): %s not a legal TI firmware file\n",
+			firmware_name);
+		ret = -EINVAL;
+		goto rel_fw;
+	}
+	pr_debug("(fmdrv): Firmware(%s) magic number : 0x%x\n", firmware_name,
+		   fw_header->magic);
+
+	/* Skip file header info , we already verified it */
+	fw_data += sizeof(struct bts_header);
+	fw_len -= sizeof(struct bts_header);
+
+	while (fw_data && fw_len > 0) {
+		action = (struct bts_action *)fw_data;
+
+		switch (action->type) {
+		case ACTION_SEND_COMMAND:	/* Send */
+			ret = fmc_send_cmd(fmdev, 0, action->data,
+				action->size, &fmdev->maintask_completion,
+				NULL, NULL);
+			if (ret < 0)
+				goto rel_fw;
+
+			cmd_cnt++;
+			break;
+
+		case ACTION_DELAY:	/* Delay */
+			delay = (struct bts_action_delay *)action->data;
+			mdelay(delay->msec);
+			break;
+		}
+
+		fw_data += (sizeof(struct bts_action) + (action->size));
+		fw_len -= (sizeof(struct bts_action) + (action->size));
+	}
+	pr_debug("(fmdrv): Firmare commands(%d) loaded to chip\n", cmd_cnt);
+rel_fw:
+	release_firmware(fw_entry);
+	clear_bit(FM_FIRMWARE_DW_INPROGRESS, &fmdev->flag);
+exit:
+	return ret;
+}
+
+/* Loads default RX configuration to the chip */
+static int __load_default_rx_configuration(struct fmdrv_ops *fmdev)
+{
+	int ret;
+
+	ret = fm_rx_set_volume(fmdev, FM_DEFAULT_RX_VOLUME);
+	if (ret < 0)
+		return ret;
+
+	ret = fm_rx_set_rssi_threshold(fmdev, FM_DEFAULT_RSSI_THRESHOLD);
+	return ret;
+}
+
+/* Does FM power on sequence */
+static int fm_power_up(struct fmdrv_ops *fmdev, unsigned char fw_option)
+{
+	unsigned short payload, asic_id, asic_ver;
+	int resp_len, ret;
+	char fw_name[50];
+
+	if (fw_option >= FM_MODE_ENTRY_MAX) {
+		pr_err("(fmdrv): Invalid firmware download option\n");
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	/*
+	 * Initialize FM common module. FM GPIO toggling is
+	 * taken care in Shared Transport driver.
+	 */
+	ret = fmc_prepare(fmdev);
+	if (ret < 0) {
+		pr_err("(fmdrv): Unable to prepare FM Common\n");
+		goto exit;
+	}
+
+	FM_STORE_LE16_TO_BE16(payload, FM_ENABLE);
+	ret = fmc_send_cmd(fmdev, FM_POWER_MODE, &payload, sizeof(payload),
+			   &fmdev->maintask_completion, NULL, NULL);
+	if (ret < 0) {
+		pr_err("(fmdrv): Failed enable FM over Channel 8\n");
+		goto rel;
+	}
+
+	/* Allow the chip to settle down in Channel-8 mode */
+	msleep(5);
+
+	ret = fmc_send_cmd(fmdev, ASIC_ID_GET, NULL, sizeof(asic_id),
+			   &fmdev->maintask_completion, &asic_id,
+			   &resp_len);
+	if (ret < 0) {
+		pr_err("(fmdrv): Failed read FM chip ASIC ID\n");
+		goto rel;
+	}
+	ret = fmc_send_cmd(fmdev, ASIC_VER_GET, NULL, sizeof(asic_ver),
+			   &fmdev->maintask_completion, &asic_ver,
+			   &resp_len);
+	if (ret < 0) {
+		pr_err("(fmdrv): Failed read FM chip ASIC Version\n");
+		goto rel;
+	}
+
+	pr_debug("(fmdrv): ASIC ID: 0x%x , ASIC Version: %d\n",
+		FM_BE16_TO_LE16(asic_id), FM_BE16_TO_LE16(asic_ver));
+
+	sprintf(fw_name, "%s_%x.%d.bts", FM_FMC_FW_FILE_START,
+		FM_BE16_TO_LE16(asic_id), FM_BE16_TO_LE16(asic_ver));
+	ret = fm_download_firmware(fmdev, fw_name);
+	if (ret < 0) {
+		pr_debug("(fmdrv): Failed to download firmware file %s\n",
+			fw_name);
+		goto rel;
+	}
+
+	sprintf(fw_name, "%s_%x.%d.bts", (fw_option == FM_MODE_RX) ?
+		FM_RX_FW_FILE_START : FM_TX_FW_FILE_START,
+		FM_BE16_TO_LE16(asic_id), FM_BE16_TO_LE16(asic_ver));
+	ret = fm_download_firmware(fmdev, fw_name);
+	if (ret < 0) {
+		pr_debug("(fmdrv): Failed to download firmware file %s\n",
+			fw_name);
+		goto rel;
+	} else
+		goto exit;
+rel:
+	fmc_release(fmdev);
+exit:
+	return ret;
+}
+
+/* Set FM Modes(TX, RX, OFF) */
+int fmc_set_mode(struct fmdrv_ops *fmdev, unsigned char fm_mode)
+{
+	int ret = 0;
+
+	if (fm_mode >= FM_MODE_ENTRY_MAX) {
+		pr_err("(fmdrv): Invalid FM mode\n");
+		ret = -EINVAL;
+		goto exit;
+	}
+	if (fmdev->curr_fmmode == fm_mode) {
+		pr_debug("(fmdrv): Already fm is in mode(%d)\n", fm_mode);
+		goto exit;
+	}
+
+	switch (fm_mode) {
+	case FM_MODE_OFF:	/* OFF Mode */
+		ret = fm_power_down(fmdev);
+		if (ret < 0) {
+			pr_err("(fmdrv): Failed to set OFF mode\n");
+			goto exit;
+		}
+		break;
+
+	case FM_MODE_TX:	/* TX Mode */
+	case FM_MODE_RX:	/* RX Mode */
+		/* Power down before switching to TX or RX mode */
+		if (fmdev->curr_fmmode != FM_MODE_OFF) {
+			ret = fm_power_down(fmdev);
+			if (ret < 0) {
+				pr_err("(fmdrv): Failed to set OFF mode\n");
+				goto exit;
+			}
+			msleep(30);
+		}
+		ret = fm_power_up(fmdev, fm_mode);
+		if (ret < 0) {
+			pr_err("(fmdrv): Failed to load firmware\n");
+			goto exit;
+		}
+	}
+	fmdev->curr_fmmode = fm_mode;
+
+	/* Set default configuration */
+	if (fmdev->curr_fmmode == FM_MODE_RX) {
+		pr_debug("(fmdrv): Loading default rx configuration..\n");
+		ret = __load_default_rx_configuration(fmdev);
+		if (ret < 0)
+			pr_err("(fmdrv): Failed to load default values\n");
+	}
+exit:
+	return ret;
+}
+
+/* Returns current FM mode (TX, RX, OFF) */
+int fmc_get_mode(struct fmdrv_ops *fmdev, unsigned char *fmmode)
+{
+	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
+		pr_err("(fmdrv): FM core is not ready\n");
+		return -EPERM;
+	}
+	if (fmmode == NULL) {
+		pr_err("(fmdrv): Invalid memory\n");
+		return -ENOMEM;
+	}
+
+	*fmmode = fmdev->curr_fmmode;
+	return 0;
+}
+
+/* Called by ST layer when FM packet is available */
+static long fm_st_receive(void *arg, struct sk_buff *skb)
+{
+	struct fmdrv_ops *fmdev;
+
+	fmdev = (struct fmdrv_ops *)arg;
+
+	if (skb == NULL) {
+		pr_err("(fmdrv): Invalid SKB received from ST\n");
+		return -EFAULT;
+	}
+
+	if (skb->cb[0] != FM_PKT_LOGICAL_CHAN_NUMBER) {
+		pr_err("(fmdrv): Received SKB (%p) is not FM Channel 8 pkt\n",
+			skb);
+		return -EINVAL;
+	}
+
+	memcpy(skb_push(skb, 1), &skb->cb[0], 1);
+	skb_queue_tail(&fmdev->rx_q, skb);
+	tasklet_schedule(&fmdev->rx_task);
+
+	return 0;
+}
+
+/*
+ * Called by ST layer to indicate protocol registration completion
+ * status.
+ */
+static void fm_st_reg_comp_cb(void *arg, char data)
+{
+	struct fmdrv_ops *fmdev;
+
+	fmdev = (struct fmdrv_ops *)arg;
+	fmdev->streg_cbdata = data;
+	complete(&wait_for_fmdrv_reg_comp);
+}
+
+/*
+ * This function will be called from FM V4L2 open function.
+ * Register with ST driver and initialize driver data.
+ */
+int fmc_prepare(struct fmdrv_ops *fmdev)
+{
+	static struct st_proto_s fm_st_proto;
+	unsigned long timeleft;
+	int ret = 0;
+
+	if (test_bit(FM_CORE_READY, &fmdev->flag)) {
+		pr_debug("(fmdrv): FM Core is already up\n");
+		goto exit;
+	}
+
+	memset(&fm_st_proto, 0, sizeof(fm_st_proto));
+	fm_st_proto.type = ST_FM;
+	fm_st_proto.recv = fm_st_receive;
+	fm_st_proto.match_packet = NULL;
+	fm_st_proto.reg_complete_cb = fm_st_reg_comp_cb;
+	fm_st_proto.write = NULL; /* TI ST driver will fill write pointer */
+	fm_st_proto.priv_data = fmdev;
+
+	ret = st_register(&fm_st_proto);
+	if (ret == -EINPROGRESS) {
+		init_completion(&wait_for_fmdrv_reg_comp);
+		fmdev->streg_cbdata = -EINPROGRESS;
+		pr_debug("(fmdrv): %s waiting for ST reg completion signal\n",
+			__func__);
+
+		timeleft =
+		wait_for_completion_timeout(&wait_for_fmdrv_reg_comp,
+		FM_ST_REGISTER_TIMEOUT);
+
+		if (!timeleft) {
+			pr_err("(fmdrv): Timeout(%d sec), didn't get reg "
+			"completion signal from ST\n",
+			jiffies_to_msecs(FM_ST_REGISTER_TIMEOUT) / 1000);
+			ret = -ETIMEDOUT;
+			goto exit;
+		}
+		if (fmdev->streg_cbdata != 0) {
+			pr_err("(fmdrv): ST reg comp CB called with error "
+			"status %d\n", fmdev->streg_cbdata);
+			ret = -EAGAIN;
+			goto exit;
+		}
+		ret = 0;
+	} else if (ret == -1) {
+		pr_err("(fmdrv): st_register failed %d\n", ret);
+		ret = -EAGAIN;
+		goto exit;
+	}
+
+	if (fm_st_proto.write != NULL) {
+		g_st_write = fm_st_proto.write;
+	} else {
+		pr_err("(fmdrv): Failed to get ST write func pointer\n");
+		ret = st_unregister(ST_FM);
+		if (ret < 0)
+			pr_err("(fmdrv): st_unregister failed %d\n", ret);
+		ret = -EAGAIN;
+		goto exit;
+	}
+
+	spin_lock_init(&fmdev->rds_buff_lock);
+	spin_lock_init(&fmdev->resp_skb_lock);
+
+	/* Initialize TX queue and TX tasklet */
+	skb_queue_head_init(&fmdev->tx_q);
+	tasklet_init(&fmdev->tx_task, __send_tasklet, (unsigned long)fmdev);
+
+	/* Initialize RX Queue and RX tasklet */
+	skb_queue_head_init(&fmdev->rx_q);
+	tasklet_init(&fmdev->rx_task, __recv_tasklet, (unsigned long)fmdev);
+
+	fmdev->irq_info.stage_index = 0;
+	atomic_set(&fmdev->tx_cnt, 1);
+	fmdev->response_completion = NULL;
+
+	init_timer(&fmdev->irq_info.int_timeout_timer);
+	fmdev->irq_info.int_timeout_timer.function =
+	    &__int_timeout_handler;
+	fmdev->irq_info.int_timeout_timer.data = (unsigned long)fmdev;
+	fmdev->irq_info.mask =
+	    FM_MAL_EVENT /*| FM_STIC_EVENT <<Enable this later>> */ ;
+
+	/* Region info */
+	memcpy(&fmdev->rx.region, &region_configs[default_radio_region],
+	       sizeof(struct region_info));
+
+	fmdev->rx.curr_mute_mode = FM_MUTE_OFF;
+	fmdev->rx.curr_rf_depend_mute = FM_RX_RF_DEPENDENT_MUTE_OFF;
+	fmdev->rx.rds.flag = FM_RDS_DISABLE;
+	fmdev->rx.curr_freq = FM_UNDEFINED_FREQ;
+	fmdev->rx.rds_mode = FM_RDS_SYSTEM_RDS;
+	fmdev->rx.af_mode = FM_RX_RDS_AF_SWITCH_MODE_OFF;
+	fmdev->irq_info.irq_service_timeout_retry = 0;
+
+	fm_rx_reset_rds_cache(fmdev);
+	init_waitqueue_head(&fmdev->rx.rds.read_queue);
+
+	fm_rx_reset_curr_station_info(fmdev);
+	set_bit(FM_CORE_READY, &fmdev->flag);
+exit:
+	return ret;
+}
+
+/*
+ * This function will be called from FM V4L2 release function.
+ * Unregister from ST driver.
+ */
+int fmc_release(struct fmdrv_ops *fmdev)
+{
+	int ret;
+
+	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
+		pr_debug("(fmdrv): FM Core is already down\n");
+		return 0;
+	}
+	/* Sevice pending read */
+	wake_up_interruptible(&fmdev->rx.rds.read_queue);
+
+	tasklet_kill(&fmdev->tx_task);
+	tasklet_kill(&fmdev->rx_task);
+
+	skb_queue_purge(&fmdev->tx_q);
+	skb_queue_purge(&fmdev->rx_q);
+
+	fmdev->response_completion = NULL;
+	fmdev->rx.curr_freq = 0;
+
+	ret = st_unregister(ST_FM);
+	if (ret < 0)
+		pr_err("(fmdrv): Failed to de-register FM from ST %d\n", ret);
+	else
+		pr_debug("(fmdrv): Successfully unregistered from ST\n");
+
+	clear_bit(FM_CORE_READY, &fmdev->flag);
+	return ret;
+}
+
+/*
+ * Module init function. Ask FM V4L module to register video device.
+ * Allocate memory for FM driver context and RX RDS buffer.
+ */
+static int __init fm_drv_init(void)
+{
+	struct fmdrv_ops *fmdev = NULL;
+	int ret = -ENOMEM;
+
+	pr_debug("(fmdrv): FM driver version %s\n", FM_DRV_VERSION);
+
+	fmdev = kzalloc(sizeof(struct fmdrv_ops), GFP_KERNEL);
+	if (NULL == fmdev) {
+		pr_err("(fmdrv): Can't allocate operation structure memory\n");
+		goto exit;
+	}
+	fmdev->rx.rds.buf_size = default_rds_buf * FM_RDS_BLOCK_SIZE;
+	fmdev->rx.rds.buffer = kzalloc(fmdev->rx.rds.buf_size, GFP_KERNEL);
+	if (NULL == fmdev->rx.rds.buffer) {
+		pr_err("(fmdrv): Can't allocate rds ring buffer\n");
+		goto rel_dev;
+	}
+
+	ret = fm_v4l2_init_video_device(fmdev, radio_nr);
+	if (ret < 0)
+		goto rel_rdsbuf;
+
+	fmdev->irq_info.fm_int_handlers = g_IntHandlerTable;
+	fmdev->curr_fmmode = FM_MODE_OFF;
+	fmdev->tx_data.pwr_lvl = FM_PWR_LVL_DEF;
+	fmdev->tx_data.preemph = FM_TX_PREEMPH_50US;
+	goto exit;
+
+rel_rdsbuf:
+	kfree(fmdev->rx.rds.buffer);
+rel_dev:
+	kfree(fmdev);
+exit:
+	return ret;
+}
+
+/* Module exit function. Ask FM V4L module to unregister video device */
+static void __exit fm_drv_exit(void)
+{
+	struct fmdrv_ops *fmdev = NULL;
+
+	fmdev = fm_v4l2_deinit_video_device();
+	if (fmdev != NULL) {
+		kfree(fmdev->rx.rds.buffer);
+		kfree(fmdev);
+	}
+}
+
+module_init(fm_drv_init);
+module_exit(fm_drv_exit);
+
+/* ------------- Module Info ------------- */
+MODULE_AUTHOR("Raja Mani <raja_mani@ti.com>");
+MODULE_DESCRIPTION("FM Driver for Connectivity chip of Texas Instruments. "
+		   FM_DRV_VERSION);
+MODULE_VERSION(FM_DRV_VERSION);
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/ti-st/fmdrv_common.h b/drivers/staging/ti-st/fmdrv_common.h
new file mode 100644
index 0000000..e5b508a
--- /dev/null
+++ b/drivers/staging/ti-st/fmdrv_common.h
@@ -0,0 +1,476 @@
+/*
+ *  FM Driver for Connectivity chip of Texas Instruments.
+ *  FM Common module header file
+ *
+ *  Copyright (C) 2010 Texas Instruments
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef _FMDRV_COMMON_H
+#define _FMDRV_COMMON_H
+
+#define FM_ST_REGISTER_TIMEOUT   msecs_to_jiffies(6000)	/* 6 sec */
+#define FM_PKT_LOGICAL_CHAN_NUMBER  0x08   /* Logical channel 8 */
+
+#define REG_RD       0x1
+#define REG_WR      0x0
+
+struct fm_reg_table {
+	unsigned char opcode;
+	unsigned char type;
+	char *name;
+};
+
+/* FM register index */
+enum fm_reg_index {
+	/* FM RX registers */
+	STEREO_GET,
+	RSSI_LVL_GET,
+	IF_COUNT_GET,
+	FLAG_GET,
+	RDS_SYNC_GET,
+	RDS_DATA_GET,
+	FREQ_SET,
+	FREQ_GET,
+	AF_FREQ_SET,
+	AF_FREQ_GET,
+	MOST_MODE_SET,
+	MOST_MODE_GET,
+	MOST_BLEND_SET,
+	MOST_BLEND_GET,
+	DEMPH_MODE_SET,
+	DEMPH_MODE_GET,
+	SEARCH_LVL_SET,
+	SEARCH_LVL_GET,
+	RX_BAND_SET,
+	RX_BAND_GET,
+	MUTE_STATUS_SET,
+	MUTE_STATUS_GET,
+	RDS_PAUSE_LVL_SET,
+	RDS_PAUSE_LVL_GET,
+	RDS_PAUSE_DUR_SET,
+	RDS_PAUSE_DUR_GET,
+	RDS_MEM_SET,
+	RDS_MEM_GET,
+	RDS_BLK_B_SET,
+	RDS_BLK_B_GET,
+	RDS_MSK_B_SET,
+	RDS_MSK_B_GET,
+	RDS_PI_MASK_SET,
+	RDS_PI_MASK_GET,
+	RDS_PI_SET,
+	RDS_PI_GET,
+	RDS_SYSTEM_SET,
+	RDS_SYSTEM_GET,
+	INT_MASK_SET,
+	INT_MASK_GET,
+	SEARCH_DIR_SET,
+	SEARCH_DIR_GET,
+	VOLUME_SET,
+	VOLUME_GET,
+	AUDIO_ENABLE_SET,
+	AUDIO_ENABLE_GET,
+	PCM_MODE_SET,
+	PCM_MODE_GET,
+	I2S_MODE_CONFIG_SET,
+	I2S_MODE_CONFIG_GET,
+	POWER_SET,
+	POWER_GET,
+	INTx_CONFIG_SET,
+	INTx_CONFIG_GET,
+	PULL_EN_SET,
+	PULL_EN_GET,
+	HILO_SET,
+	HILO_GET,
+	SWITCH2FREF,
+	FREQ_DRIFT_REPORT,
+	PCE_GET,
+	FIRM_VER_GET,
+	ASIC_VER_GET,
+	ASIC_ID_GET,
+	MAIN_ID_GET,
+	TUNER_MODE_SET,
+	STOP_SEARCH,
+	RDS_CNTRL_SET,
+	WRITE_HARDWARE_REG,
+	CODE_DOWNLOAD,
+	RESET,
+	FM_POWER_MODE,
+	FM_INTERRUPT,
+
+	/* FM TX registers */
+	CHANL_SET,
+	CHANL_GET,
+	CHANL_BW_SET,
+	CHANL_BW_GET,
+	REF_SET,
+	REF_GET,
+	POWER_ENB_SET,
+	POWER_ATT_SET,
+	POWER_ATT_GET,
+	POWER_LEL_SET,
+	POWER_LEL_GET,
+	AUDIO_DEV_SET,
+	AUDIO_DEV_GET,
+	PILOT_DEV_SET,
+	PILOT_DEV_GET,
+	RDS_DEV_SET,
+	RDS_DEV_GET,
+	PUPD_SET,
+	AUDIO_IO_SET,
+	PREMPH_SET,
+	PREMPH_GET,
+	TX_BAND_SET,
+	TX_BAND_GET,
+	MONO_SET,
+	MONO_GET,
+	MUTE,
+	MPX_LMT_ENABLE,
+	LOCK_GET,
+	REF_ERR_SET,
+	PI_SET,
+	PI_GET,
+	TYPE_SET,
+	TYPE_GET,
+	PTY_SET,
+	PTY_GET,
+	AF_SET,
+	AF_GET,
+	DISPLAY_SIZE_SET,
+	DISPLAY_SIZE_GET,
+	RDS_MODE_SET,
+	RDS_MODE_GET,
+	DISPLAY_MODE_SET,
+	DISPLAY_MODE_GET,
+	LENGTH_SET,
+	LENGTH_GET,
+	TOGGLE_AB_SET,
+	TOGGLE_AB_GET,
+	RDS_REP_SET,
+	RDS_REP_GET,
+	RDS_DATA_SET,
+	RDS_DATA_ENB,
+	TA_SET,
+	TA_GET,
+	TP_SET,
+	TP_GET,
+	DI_SET,
+	DI_GET,
+	MS_SET,
+	MS_GET,
+	PS_SCROLL_SPEED_SET,
+	PS_SCROLL_SPEED_GET,
+	IMP_SET,
+	IMP_GET,
+
+	FM_REG_MAX_ENTRIES
+};
+
+/* SKB helpers */
+struct fm_skb_cb {
+	__u8 fm_opcode;
+	struct completion *completion;
+};
+
+#define fm_cb(skb) ((struct fm_skb_cb *)(skb->cb))
+
+/* FM Channel-8 command message format */
+struct fm_cmd_msg_hdr {
+	__u8 header;		/* Logical Channel-8 */
+	__u8 len;		/* Number of bytes follows */
+	__u8 fm_opcode;		/* FM Opcode */
+	__u8 rd_wr;		/* Read/Write command */
+	__u8 dlen;		/* Length of payload */
+} __attribute__ ((packed));
+
+#define FM_CMD_MSG_HDR_SIZE    5	/* sizeof(struct fm_cmd_msg_hdr) */
+
+/* FM Channel-8 event messgage format */
+struct fm_event_msg_hdr {
+	__u8 header;		/* Logical Channel-8 */
+	__u8 len;		/* Number of bytes follows */
+	__u8 status;		/* Event status */
+	__u8 num_fm_hci_cmds;	/* Number of pkts the host allowed to send */
+	__u8 fm_opcode;		/* FM Opcode */
+	__u8 rd_wr;		/* Read/Write command */
+	__u8 dlen;		/* Length of payload */
+} __attribute__ ((packed));
+
+#define FM_EVT_MSG_HDR_SIZE     7	/* sizeof(struct fm_event_msg_hdr) */
+
+/* TI's magic number in firmware file */
+#define FM_FW_FILE_HEADER_MAGIC	     0x42535442
+
+/* Firmware header */
+struct bts_header {
+	uint32_t magic;
+	uint32_t version;
+	uint8_t future[24];
+	uint8_t actions[0];
+} __attribute__ ((packed));
+
+/* Firmware action */
+struct bts_action {
+	uint16_t type;
+	uint16_t size;
+	uint8_t data[0];
+} __attribute__ ((packed));
+
+/* Firmware delay */
+struct bts_action_delay {
+	uint32_t msec;
+} __attribute__ ((packed));
+
+#define ACTION_SEND_COMMAND	1
+#define ACTION_WAIT_EVENT	2
+#define ACTION_SERIAL		3
+#define ACTION_DELAY		4
+#define ACTION_REMARKS		6
+
+/* Converts little endian to big endian */
+#define FM_STORE_LE16_TO_BE16(data, value)   \
+	(data = ((value >> 8) | ((value & 0xFF) << 8)))
+#define FM_LE16_TO_BE16(value)   (((value >> 8) | ((value & 0xFF) << 8)))
+
+/* Converts big endian to little endian */
+#define FM_STORE_BE16_TO_LE16(data, value)   \
+	(data = ((value & 0xFF) << 8) | ((value >> 8)))
+#define FM_BE16_TO_LE16(value)   (((value & 0xFF) << 8) | ((value >> 8)))
+
+#define FM_ENABLE   1
+#define FM_DISABLE  0
+
+/* FLAG_GET register bits */
+#define FM_FR_EVENT		(1 << 0)
+#define FM_BL_EVENT		(1 << 1)
+#define FM_RDS_EVENT		(1 << 2)
+#define FM_BBLK_EVENT		(1 << 3)
+#define FM_LSYNC_EVENT		(1 << 4)
+#define FM_LEV_EVENT		(1 << 5)
+#define FM_IFFR_EVENT		(1 << 6)
+#define FM_PI_EVENT		(1 << 7)
+#define FM_PD_EVENT		(1 << 8)
+#define FM_STIC_EVENT		(1 << 9)
+#define FM_MAL_EVENT		(1 << 10)
+#define FM_POW_ENB_EVENT	(1 << 11)
+
+/*
+ * Firmware files of FM. ASIC ID and ASIC version will be appened to this,
+ * later.
+ */
+#define FM_FMC_FW_FILE_START      ("fmc_ch8")
+#define FM_RX_FW_FILE_START       ("fm_rx_ch8")
+#define FM_TX_FW_FILE_START       ("fm_tx_ch8")
+
+#define FM_UNDEFINED_FREQ		   0xFFFFFFFF
+
+/* Band types */
+#define FM_BAND_EUROPE_US	0
+#define FM_BAND_JAPAN		1
+
+/* Seek directions */
+#define FM_SEARCH_DIRECTION_DOWN	0
+#define FM_SEARCH_DIRECTION_UP		1
+
+/* Tunner modes */
+#define FM_TUNER_STOP_SEARCH_MODE	0
+#define FM_TUNER_PRESET_MODE		1
+#define FM_TUNER_AUTONOMOUS_SEARCH_MODE	2
+#define FM_TUNER_AF_JUMP_MODE		3
+
+/* Min and Max volume */
+#define FM_RX_VOLUME_MIN	0
+#define FM_RX_VOLUME_MAX	70
+
+/* Volume gain step */
+#define FM_RX_VOLUME_GAIN_STEP	0x370
+
+/* Mute modes */
+#define FM_MUTE_OFF		0
+#define	FM_MUTE_ON		1
+#define	FM_MUTE_ATTENUATE	2
+
+#define FM_RX_MUTE_UNMUTE_MODE		0x00
+#define FM_RX_MUTE_RF_DEP_MODE		0x01
+#define FM_RX_MUTE_AC_MUTE_MODE		0x02
+#define FM_RX_MUTE_HARD_MUTE_LEFT_MODE	0x04
+#define FM_RX_MUTE_HARD_MUTE_RIGHT_MODE	0x08
+#define FM_RX_MUTE_SOFT_MUTE_FORCE_MODE	0x10
+
+/* RF dependent mute mode */
+#define FM_RX_RF_DEPENDENT_MUTE_ON	1
+#define FM_RX_RF_DEPENDENT_MUTE_OFF	0
+
+/* RSSI threshold min and max */
+#define FM_RX_RSSI_THRESHOLD_MIN	-128
+#define FM_RX_RSSI_THRESHOLD_MAX	127
+
+/* Stereo/Mono mode */
+#define FM_STEREO_MODE		0
+#define FM_MONO_MODE		1
+#define FM_STEREO_SOFT_BLEND	1
+
+/* FM RX De-emphasis filter modes */
+#define FM_RX_EMPHASIS_FILTER_50_USEC	0
+#define FM_RX_EMPHASIS_FILTER_75_USEC	1
+
+/* FM RDS modes */
+#define FM_RDS_DISABLE	0
+#define FM_RDS_ENABLE	1
+
+#define FM_NO_PI_CODE	0
+
+/* FM and RX RDS block enable/disable  */
+#define FM_RX_POWER_SET_FM_ON_RDS_OFF		0x1
+#define FM_RX_POWET_SET_FM_AND_RDS_BLK_ON	0x3
+#define FM_RX_POWET_SET_FM_AND_RDS_BLK_OFF	0x0
+
+/* RX RDS */
+#define FM_RX_RDS_FLUSH_FIFO		0x1
+#define FM_RX_RDS_FIFO_THRESHOLD	64	/* tuples */
+#define FM_RDS_BLOCK_SIZE		3	/* 3 bytes */
+
+/* RDS block types */
+#define FM_RDS_BLOCK_A		0
+#define FM_RDS_BLOCK_B		1
+#define FM_RDS_BLOCK_C		2
+#define FM_RDS_BLOCK_Ctag	3
+#define FM_RDS_BLOCK_D		4
+#define FM_RDS_BLOCK_E		5
+
+#define FM_RDS_BLOCK_INDEX_A		0
+#define FM_RDS_BLOCK_INDEX_B		1
+#define FM_RDS_BLOCK_INDEX_C		2
+#define FM_RDS_BLOCK_INDEX_D		3
+#define FM_RDS_BLOCK_INDEX_UNKNOWN	0xF0
+
+#define FM_RDS_STATUS_ERROR_MASK	0x18
+
+/*
+ * Represents an RDS group type & version.
+ * There are 15 groups, each group has 2 versions: A and B.
+ */
+#define FM_RDS_GROUP_TYPE_MASK_0A	    ((unsigned long)1<<0)
+#define FM_RDS_GROUP_TYPE_MASK_0B	    ((unsigned long)1<<1)
+#define FM_RDS_GROUP_TYPE_MASK_1A	    ((unsigned long)1<<2)
+#define FM_RDS_GROUP_TYPE_MASK_1B	    ((unsigned long)1<<3)
+#define FM_RDS_GROUP_TYPE_MASK_2A	    ((unsigned long)1<<4)
+#define FM_RDS_GROUP_TYPE_MASK_2B	    ((unsigned long)1<<5)
+#define FM_RDS_GROUP_TYPE_MASK_3A	    ((unsigned long)1<<6)
+#define FM_RDS_GROUP_TYPE_MASK_3B           ((unsigned long)1<<7)
+#define FM_RDS_GROUP_TYPE_MASK_4A	    ((unsigned long)1<<8)
+#define FM_RDS_GROUP_TYPE_MASK_4B	    ((unsigned long)1<<9)
+#define FM_RDS_GROUP_TYPE_MASK_5A	    ((unsigned long)1<<10)
+#define FM_RDS_GROUP_TYPE_MASK_5B	    ((unsigned long)1<<11)
+#define FM_RDS_GROUP_TYPE_MASK_6A	    ((unsigned long)1<<12)
+#define FM_RDS_GROUP_TYPE_MASK_6B	    ((unsigned long)1<<13)
+#define FM_RDS_GROUP_TYPE_MASK_7A	    ((unsigned long)1<<14)
+#define FM_RDS_GROUP_TYPE_MASK_7B	    ((unsigned long)1<<15)
+#define FM_RDS_GROUP_TYPE_MASK_8A           ((unsigned long)1<<16)
+#define FM_RDS_GROUP_TYPE_MASK_8B	    ((unsigned long)1<<17)
+#define FM_RDS_GROUP_TYPE_MASK_9A	    ((unsigned long)1<<18)
+#define FM_RDS_GROUP_TYPE_MASK_9B	    ((unsigned long)1<<19)
+#define FM_RDS_GROUP_TYPE_MASK_10A	    ((unsigned long)1<<20)
+#define FM_RDS_GROUP_TYPE_MASK_10B	    ((unsigned long)1<<21)
+#define FM_RDS_GROUP_TYPE_MASK_11A	    ((unsigned long)1<<22)
+#define FM_RDS_GROUP_TYPE_MASK_11B	    ((unsigned long)1<<23)
+#define FM_RDS_GROUP_TYPE_MASK_12A	    ((unsigned long)1<<24)
+#define FM_RDS_GROUP_TYPE_MASK_12B	    ((unsigned long)1<<25)
+#define FM_RDS_GROUP_TYPE_MASK_13A	    ((unsigned long)1<<26)
+#define FM_RDS_GROUP_TYPE_MASK_13B	    ((unsigned long)1<<27)
+#define FM_RDS_GROUP_TYPE_MASK_14A	    ((unsigned long)1<<28)
+#define FM_RDS_GROUP_TYPE_MASK_14B	    ((unsigned long)1<<29)
+#define FM_RDS_GROUP_TYPE_MASK_15A	    ((unsigned long)1<<30)
+#define FM_RDS_GROUP_TYPE_MASK_15B	    ((unsigned long)1<<31)
+
+/* RX Alternate Frequency info */
+#define FM_RDS_MIN_AF		          1
+#define FM_RDS_MAX_AF		        204
+#define FM_RDS_MAX_AF_JAPAN	        140
+#define FM_RDS_1_AF_FOLLOWS	        225
+#define FM_RDS_25_AF_FOLLOWS	        249
+
+/* RDS system type (RDS/RBDS) */
+#define FM_RDS_SYSTEM_RDS		0
+#define FM_RDS_SYSTEM_RBDS		1
+
+/* AF on/off */
+#define FM_RX_RDS_AF_SWITCH_MODE_ON	1
+#define FM_RX_RDS_AF_SWITCH_MODE_OFF	0
+
+/* Retry count when interrupt process goes wrong */
+#define FM_IRQ_TIMEOUT_RETRY_MAX	5	/* 5 times */
+
+/* Audio IO set values */
+#define FM_RX_FM_AUDIO_ENABLE_I2S	0x01
+#define FM_RX_FM_AUDIO_ENABLE_ANALOG	0x02
+#define FM_RX_FM_AUDIO_ENABLE_I2S_AND_ANALOG	0x03
+#define FM_RX_FM_AUDIO_ENABLE_DISABLE	0x00
+
+/* HI/LO set values */
+#define FM_RX_IFFREQ_TO_HI_SIDE		0x0
+#define FM_RX_IFFREQ_TO_LO_SIDE		0x1
+#define FM_RX_IFFREQ_HILO_AUTOMATIC	0x2
+
+/*
+ * Default RX mode configuration. Chip will be configured
+ * with this default values after loading RX firmware.
+ */
+#define FM_DEFAULT_RX_VOLUME		10
+#define FM_DEFAULT_RSSI_THRESHOLD	3
+
+/* Range for TX power level in units for dB/uV */
+#define FM_PWR_LVL_LOW			91
+#define FM_PWR_LVL_HIGH			122
+
+/* Chip specific default TX power level value */
+#define FM_PWR_LVL_DEF			4
+
+/* FM TX Pre-emphasis filter values */
+#define FM_TX_PREEMPH_OFF		1
+#define FM_TX_PREEMPH_50US		0
+#define FM_TX_PREEMPH_75US		2
+
+/* FM TX antenna impedence values */
+#define FM_TX_ANT_IMP_50		0
+#define FM_TX_ANT_IMP_200		1
+#define FM_TX_ANT_IMP_500		2
+
+/* Functions exported by FM common sub-module */
+int fmc_prepare(struct fmdrv_ops *);
+int fmc_release(struct fmdrv_ops *);
+
+void fmc_update_region_info(struct fmdrv_ops *, unsigned char);
+int fmc_send_cmd(struct fmdrv_ops *, unsigned char, void *, int,
+			struct completion *, void *, int *);
+int fmc_is_rds_data_available(struct fmdrv_ops *, struct file *,
+				struct poll_table_struct *);
+int fmc_transfer_rds_from_internal_buff(struct fmdrv_ops *, struct file *,
+					char __user *, size_t);
+
+int fmc_set_frequency(struct fmdrv_ops *, unsigned int);
+int fmc_set_mode(struct fmdrv_ops *, unsigned char);
+int fmc_set_region(struct fmdrv_ops *, unsigned char);
+int fmc_set_mute_mode(struct fmdrv_ops *, unsigned char);
+int fmc_set_stereo_mono(struct fmdrv_ops *, unsigned short);
+int fmc_set_rds_mode(struct fmdrv_ops *, unsigned char);
+
+int fmc_get_frequency(struct fmdrv_ops *, unsigned int *);
+int fmc_get_region(struct fmdrv_ops *, unsigned char *);
+int fmc_get_mode(struct fmdrv_ops *, unsigned char *);
+
+#endif
+
-- 
1.5.6.3

