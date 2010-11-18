Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0KRITf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:19:35 -0500
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3716 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab0KRITd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:19:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: manjunatha_halli@ti.com
Subject: Re: [PATCH v4 3/6] drivers:staging: ti-st: fmdrv_common sources
Date: Thu, 18 Nov 2010 09:19:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com> <1289913494-21590-3-git-send-email-manjunatha_halli@ti.com> <1289913494-21590-4-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1289913494-21590-4-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011180919.23001.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 16, 2010 14:18:11 manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli <manjunatha_halli@ti.com>
> 
> These are the sources for the common interfaces required by the FM
> V4L2 driver for TI WL127x and WL128x chips.
> 
> These implement the FM channel-8 protocol communication with
> the chip. This makes use of the Shared Transport as its transport.
> 
> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
> ---
>  drivers/staging/ti-st/fmdrv_common.c | 2141 ++++++++++++++++++++++++++++++++++
>  drivers/staging/ti-st/fmdrv_common.h |  458 ++++++++
>  2 files changed, 2599 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/ti-st/fmdrv_common.c
>  create mode 100644 drivers/staging/ti-st/fmdrv_common.h
> 
> diff --git a/drivers/staging/ti-st/fmdrv_common.c b/drivers/staging/ti-st/fmdrv_common.c
> new file mode 100644
> index 0000000..7b8f2da
> --- /dev/null
> +++ b/drivers/staging/ti-st/fmdrv_common.c
> @@ -0,0 +1,2141 @@
> +/*
> + *  FM Driver for Connectivity chip of Texas Instruments.
> + *
> + *  This sub-module of FM driver is common for FM RX and TX
> + *  functionality. This module is responsible for:
> + *  1) Forming group of Channel-8 commands to perform particular
> + *     functionality (eg., frequency set require more than
> + *     one Channel-8 command to be sent to the chip).
> + *  2) Sending each Channel-8 command to the chip and reading
> + *     response back over Shared Transport.
> + *  3) Managing TX and RX Queues and Tasklets.
> + *  4) Handling FM Interrupt packet and taking appropriate action.
> + *  5) Loading FM firmware to the chip (common, FM TX, and FM RX
> + *     firmware files based on mode selection)
> + *
> + *  Copyright (C) 2010 Texas Instruments
> + *  Author: Raja Mani <raja_mani@ti.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/firmware.h>
> +#include <linux/delay.h>
> +#include "fmdrv.h"
> +#include "fmdrv_v4l2.h"
> +#include "fmdrv_common.h"
> +#include <linux/ti_wilink_st.h>
> +#include "fmdrv_rx.h"
> +#include "fmdrv_tx.h"
> +
> +/* FM chip register table */
> +static struct fm_reg_table fm_reg_info[] = {
> +	/* ----- FM RX registers -------*/
> +	/* opcode, type(rd/wr), reg name */
> +	{0x00, REG_RD, "STEREO_GET"},
> +	{0x01, REG_RD, "RSSI_LVL_GET"},
> +	{0x02, REG_RD, "IF_COUNT_GET"},
> +	{0x03, REG_RD, "FLAG_GET"},
> +	{0x04, REG_RD, "RDS_SYNC_GET"},
> +	{0x05, REG_RD, "RDS_DATA_GET"},
> +	{0x0a, REG_WR, "FREQ_SET"},
> +	{0x0a, REG_RD, "FREQ_GET"},
> +	{0x0b, REG_WR, "AF_FREQ_SET"},
> +	{0x0b, REG_RD, "AF_FREQ_GET"},
> +	{0x0c, REG_WR, "MOST_MODE_SET"},
> +	{0x0c, REG_RD, "MOST_MODE_GET"},
> +	{0x0d, REG_WR, "MOST_BLEND_SET"},
> +	{0x0d, REG_RD, "MOST_BLEND_GET"},
> +	{0x0e, REG_WR, "DEMPH_MODE_SET"},
> +	{0x0e, REG_RD, "DEMPH_MODE_GET"},
> +	{0x0f, REG_WR, "SEARCH_LVL_SET"},
> +	{0x0f, REG_RD, "SEARCH_LVL_GET"},
> +	{0x10, REG_WR, "RX_BAND_SET"},
> +	{0x10, REG_RD, "RX_BAND_GET"},
> +	{0x11, REG_WR, "MUTE_STATUS_SET"},
> +	{0x11, REG_RD, "MUTE_STATUS_GET"},
> +	{0x12, REG_WR, "RDS_PAUSE_LVL_SET"},
> +	{0x12, REG_RD, "RDS_PAUSE_LVL_GET"},
> +	{0x13, REG_WR, "RDS_PAUSE_DUR_SET"},
> +	{0x13, REG_RD, "RDS_PAUSE_DUR_GET"},
> +	{0x14, REG_WR, "RDS_MEM_SET"},
> +	{0x14, REG_RD, "RDS_MEM_GET"},
> +	{0x15, REG_WR, "RDS_BLK_B_SET"},
> +	{0x15, REG_RD, "RDS_BLK_B_GET"},
> +	{0x16, REG_WR, "RDS_MSK_B_SET"},
> +	{0x16, REG_RD, "RDS_MSK_B_GET"},
> +	{0x17, REG_WR, "RDS_PI_MASK_SET"},
> +	{0x17, REG_RD, "RDS_PI_MASK_GET"},
> +	{0x18, REG_WR, "RDS_PI_SET"},
> +	{0x18, REG_RD, "RDS_PI_GET"},
> +	{0x19, REG_WR, "RDS_SYSTEM_SET"},
> +	{0x19, REG_RD, "RDS_SYSTEM_GET"},
> +	{0x1a, REG_WR, "INT_MASK_SET"},
> +	{0x1a, REG_RD, "INT_MASK_GET"},
> +	{0x1b, REG_WR, "SRCH_DIR_SET"},
> +	{0x1b, REG_RD, "SRCH_DIR_GET"},
> +	{0x1c, REG_WR, "VOLUME_SET"},
> +	{0x1c, REG_RD, "VOLUME_GET"},
> +	{0x1d, REG_WR, "AUDIO_ENABLE(SET)"},
> +	{0x1d, REG_RD, "AUDIO_ENABLE(GET)"},
> +	{0x1e, REG_WR, "PCM_MODE_SET"},
> +	{0x1e, REG_RD, "PCM_MODE_SET"},
> +	{0x1f, REG_WR, "I2S_MD_CFG_SET"},
> +	{0x1f, REG_RD, "I2S_MD_CFG_GET"},
> +	{0x20, REG_WR, "POWER_SET"},
> +	{0x20, REG_RD, "POWER_GET"},
> +	{0x21, REG_WR, "INTx_CONFIG_SET"},
> +	{0x21, REG_RD, "INTx_CONFIG_GET"},
> +	{0x22, REG_WR, "PULL_EN_SET"},
> +	{0x22, REG_RD, "PULL_EN_GET"},
> +	{0x23, REG_WR, "HILO_SET"},
> +	{0x23, REG_RD, "HILO_GET"},
> +	{0x24, REG_WR, "SWITCH2FREF"},
> +	{0x25, REG_WR, "FREQ_DRIFT_REP"},
> +	{0x28, REG_RD, "PCE_GET"},
> +	{0x29, REG_RD, "FIRM_VER_GET"},
> +	{0x2a, REG_RD, "ASIC_VER_GET"},
> +	{0x2b, REG_RD, "ASIC_ID_GET"},
> +	{0x2c, REG_RD, "MAIN_ID_GET"},
> +	{0x2d, REG_WR, "TUNER_MODE_SET"},
> +	{0x2e, REG_WR, "STOP_SEARCH"},
> +	{0x2f, REG_WR, "RDS_CNTRL_SET"},
> +	{0x64, REG_WR, "WR_HW_REG"},
> +	{0x65, REG_WR, "CODE_DOWNLOAD"},
> +	{0x66, REG_WR, "RESET"},
> +	{0xfe, REG_WR, "FM_POWER_MODE(SET)"},
> +	{0xff, REG_RD, "FM_INTERRUPT"},
> +
> +	/* --- FM TX registers ------ */
> +	{0x37, REG_WR, "CHANL_SET"},
> +	{0x37, REG_RD, "CHANL_GET"},
> +	{0x38, REG_WR, "CHANL_BW_SET"},
> +	{0x38, REG_RD, "CHANL_BW_GET"},
> +	{0x87, REG_WR, "REF_SET"},
> +	{0x87, REG_RD, "REF_GET"},
> +	{0x5a, REG_WR, "POWER_ENB_SET"},
> +	{0x3a, REG_WR, "POWER_ATT_SET"},
> +	{0x3a, REG_RD, "POWER_ATT_GET"},
> +	{0x3b, REG_WR, "POWER_LEL_SET"},
> +	{0x3b, REG_RD, "POWER_LEL_GET"},
> +	{0x3c, REG_WR, "AUDIO_DEV_SET"},
> +	{0x3c, REG_RD, "AUDIO_DEV_GET"},
> +	{0x3d, REG_WR, "PILOT_DEV_SET"},
> +	{0x3d, REG_RD, "PILOT_DEV_GET"},
> +	{0x3e, REG_WR, "RDS_DEV_SET"},
> +	{0x3e, REG_RD, "RDS_DEV_GET"},
> +	{0x5b, REG_WR, "PUPD_SET"},
> +	{0x3f, REG_WR, "AUDIO_IO_SET"},
> +	{0x40, REG_WR, "PREMPH_SET"},
> +	{0x40, REG_RD, "PREMPH_GET"},
> +	{0x41, REG_WR, "TX_BAND_SET"},
> +	{0x41, REG_RD, "TX_BAND_GET"},
> +	{0x42, REG_WR, "MONO_SET"},
> +	{0x42, REG_RD, "MONO_GET"},
> +	{0x5C, REG_WR, "MUTE"},
> +	{0x43, REG_WR, "MPX_LMT_ENABLE"},
> +	{0x06, REG_RD, "LOCK_GET"},
> +	{0x5d, REG_WR, "REF_ERR_SET"},
> +	{0x44, REG_WR, "PI_SET"},
> +	{0x44, REG_RD, "PI_GET"},
> +	{0x45, REG_WR, "TYPE_SET"},
> +	{0x45, REG_RD, "TYPE_GET"},
> +	{0x46, REG_WR, "PTY_SET"},
> +	{0x46, REG_RD, "PTY_GET"},
> +	{0x47, REG_WR, "AF_SET"},
> +	{0x47, REG_RD, "AF_GET"},
> +	{0x48, REG_WR, "DISPLAY_SIZE_SET"},
> +	{0x48, REG_RD, "DISPLAY_SIZE_GET"},
> +	{0x49, REG_WR, "RDS_MODE_SET"},
> +	{0x49, REG_RD, "RDS_MODE_GET"},
> +	{0x4a, REG_WR, "DISPLAY_MODE_SET"},
> +	{0x4a, REG_RD, "DISPLAY_MODE_GET"},
> +	{0x62, REG_WR, "LENGTH_SET"},
> +	{0x4b, REG_RD, "LENGTH_GET"},
> +	{0x4c, REG_WR, "TOGGLE_AB_SET"},
> +	{0x4c, REG_RD, "TOGGLE_AB_GET"},
> +	{0x4d, REG_WR, "RDS_REP_SET"},
> +	{0x4d, REG_RD, "RDS_REP_GET"},
> +	{0x63, REG_WR, "RDS_DATA_SET"},
> +	{0x5e, REG_WR, "RDS_DATA_ENB"},
> +	{0x4e, REG_WR, "TA_SET"},
> +	{0x4e, REG_RD, "TA_GET"},
> +	{0x4f, REG_WR, "TP_SET"},
> +	{0x4f, REG_RD, "TP_GET"},
> +	{0x50, REG_WR, "DI_SET"},
> +	{0x50, REG_RD, "DI_GET"},
> +	{0x51, REG_WR, "MS_SET"},
> +	{0x51, REG_RD, "MS_GET"},
> +	{0x52, REG_WR, "PS_SCROLL_SPEED_SET"},
> +	{0x52, REG_RD, "PS_SCROLL_SPEED_GET"},
> +	{0x57, REG_WR, "ANT_IMP_SET"},
> +	{0x57, REG_RD, "ANT_IMP_GET"},

This array seems way overkill. The name is not used at all, so why waste the
space? Make it a comment instead.

It is also a bit weird: the enum fm_reg_index maps into this array and is
used to obtain the opcode, which looks suspiciously like a register address
to me. Are you sure you shouldn't be using the opcode directly?

> +};
> +
> +/* Region info */
> +static struct region_info region_configs[] = {
> +	/* Europe/US */
> +	{
> +	 .channel_spacing = FM_CHANNEL_SPACING_50KHZ * FM_FREQ_MUL,
> +	 .bottom_frequency = 87500,	/* 87.5 MHz */
> +	 .top_frequency = 108000,	/* 108 MHz */
> +	 .region_index = 0,
> +	 },
> +	/* Japan */
> +	{
> +	 .channel_spacing = FM_CHANNEL_SPACING_50KHZ * FM_FREQ_MUL,
> +	 .bottom_frequency = 76000,	/* 76 MHz */
> +	 .top_frequency = 90000,	/* 90 MHz */
> +	 .region_index = 1,
> +	 },
> +};
> +
> +/* Band selection */
> +static unsigned char default_radio_region;	/* Europe/US */
> +module_param(default_radio_region, byte, 0);
> +MODULE_PARM_DESC(default_radio_region, "Region: 0=Europe/US, 1=Japan");
> +
> +/* RDS buffer blocks */
> +static unsigned int default_rds_buf = 300;
> +module_param(default_rds_buf, uint, 0444);
> +MODULE_PARM_DESC(rds_buf, "RDS buffer entries");
> +
> +/* Radio Nr */
> +static int radio_nr = -1;
> +module_param(radio_nr, int, 0444);
> +MODULE_PARM_DESC(radio_nr, "Radio Nr");
> +
> +/* FM irq handlers forward declaration */
> +static void fm_irq_send_flag_getcmd(void *);
> +static void fm_irq_handle_flag_getcmd_resp(void *);
> +static void fm_irq_handle_hw_malfunction(void *);
> +static void fm_irq_handle_rds_start(void *);
> +static void fm_irq_send_rdsdata_getcmd(void *);
> +static void fm_irq_handle_rdsdata_getcmd_resp(void *);
> +static void fm_irq_handle_rds_finish(void *);
> +static void fm_irq_handle_tune_op_ended(void *);
> +static void fm_irq_handle_power_enb(void *);
> +static void fm_irq_handle_low_rssi_start(void *);
> +static void fm_irq_afjump_set_pi(void *);
> +static void fm_irq_handle_set_pi_resp(void *);
> +static void fm_irq_afjump_set_pimask(void *);
> +static void fm_irq_handle_set_pimask_resp(void *);
> +static void fm_irq_afjump_setfreq(void *);
> +static void fm_irq_handle_setfreq_resp(void *);
> +static void fm_irq_afjump_enableint(void *);
> +static void fm_irq_afjump_enableint_resp(void *);
> +static void fm_irq_start_afjump(void *);
> +static void fm_irq_handle_start_afjump_resp(void *);
> +static void fm_irq_afjump_rd_freq(void *);
> +static void fm_irq_afjump_rd_freq_resp(void *);
> +static void fm_irq_handle_low_rssi_finish(void *);
> +static void fm_irq_send_intmsk_cmd(void *);
> +static void fm_irq_handle_intmsk_cmd_resp(void *);
> +
> +/*
> + * When FM common module receives interrupt packet, following handlers
> + * will be executed one after another to service the interrupt(s)
> + */
> +enum fmc_irq_handler_index {
> +	FM_SEND_FLAG_GETCMD_INDEX,
> +	FM_HANDLE_FLAG_GETCMD_RESP_INDEX,
> +
> +	/* HW malfunction irq handler */
> +	FM_HW_MAL_FUNC_INDEX,
> +
> +	/* RDS threshold reached irq handler */
> +	FM_RDS_START_INDEX,
> +	FM_RDS_SEND_RDS_GETCMD_INDEX,
> +	FM_RDS_HANDLE_RDS_GETCMD_RESP_INDEX,
> +	FM_RDS_FINISH_INDEX,
> +
> +	/* Tune operation ended irq handler */
> +	FM_HW_TUNE_OP_ENDED_INDEX,
> +
> +	/* TX power enable irq handler */
> +	FM_HW_POWER_ENB_INDEX,
> +
> +	/* Low RSSI irq handler */
> +	FM_LOW_RSSI_START_INDEX,
> +	FM_AF_JUMP_SETPI_INDEX,
> +	FM_AF_JUMP_HANDLE_SETPI_RESP_INDEX,
> +	FM_AF_JUMP_SETPI_MASK_INDEX,
> +	FM_AF_JUMP_HANDLE_SETPI_MASK_RESP_INDEX,
> +	FM_AF_JUMP_SET_AF_FREQ_INDEX,
> +	FM_AF_JUMP_HENDLE_SET_AFFREQ_RESP_INDEX,
> +	FM_AF_JUMP_ENABLE_INT_INDEX,
> +	FM_AF_JUMP_ENABLE_INT_RESP_INDEX,
> +	FM_AF_JUMP_START_AFJUMP_INDEX,
> +	FM_AF_JUMP_HANDLE_START_AFJUMP_RESP_INDEX,
> +	FM_AF_JUMP_RD_FREQ_INDEX,
> +	FM_AF_JUMP_RD_FREQ_RESP_INDEX,
> +	FM_LOW_RSSI_FINISH_INDEX,
> +
> +	/* Interrupt process post action */
> +	FM_SEND_INTMSK_CMD_INDEX,
> +	FM_HANDLE_INTMSK_CMD_RESP_INDEX,
> +};
> +
> +/* FM interrupt handler table */
> +static int_handler_prototype g_IntHandlerTable[] = {
> +	fm_irq_send_flag_getcmd,
> +	fm_irq_handle_flag_getcmd_resp,
> +	fm_irq_handle_hw_malfunction,
> +	fm_irq_handle_rds_start, /* RDS threshold reached irq handler */
> +	fm_irq_send_rdsdata_getcmd,
> +	fm_irq_handle_rdsdata_getcmd_resp,
> +	fm_irq_handle_rds_finish,
> +	fm_irq_handle_tune_op_ended,
> +	fm_irq_handle_power_enb, /* TX power enable irq handler */
> +	fm_irq_handle_low_rssi_start,
> +	fm_irq_afjump_set_pi,
> +	fm_irq_handle_set_pi_resp,
> +	fm_irq_afjump_set_pimask,
> +	fm_irq_handle_set_pimask_resp,
> +	fm_irq_afjump_setfreq,
> +	fm_irq_handle_setfreq_resp,
> +	fm_irq_afjump_enableint,
> +	fm_irq_afjump_enableint_resp,
> +	fm_irq_start_afjump,
> +	fm_irq_handle_start_afjump_resp,
> +	fm_irq_afjump_rd_freq,
> +	fm_irq_afjump_rd_freq_resp,
> +	fm_irq_handle_low_rssi_finish,
> +	fm_irq_send_intmsk_cmd, /* Interrupt process post action */
> +	fm_irq_handle_intmsk_cmd_resp
> +};
> +
> +long (*g_st_write) (struct sk_buff *skb);
> +static struct completion wait_for_fmdrv_reg_comp;
> +
> +#ifdef FM_DUMP_TXRX_PKT
> + /* To dump outgoing FM Channel-8 packets */
> +inline void dump_tx_skb_data(struct sk_buff *skb)
> +{
> +	int len, len_org;
> +	char index;
> +	struct fm_cmd_msg_hdr *cmd_hdr;
> +
> +	cmd_hdr = (struct fm_cmd_msg_hdr *)skb->data;
> +	printk(KERN_INFO "<<%shdr:%02x len:%02x opcode:%02x type:%s dlen:%02x",
> +	       fm_cb(skb)->completion ? " " : "*", cmd_hdr->header,
> +	       cmd_hdr->len, cmd_hdr->fm_opcode,
> +	       cmd_hdr->rd_wr ? "RD" : "WR", cmd_hdr->dlen);
> +
> +	len_org = skb->len - FM_CMD_MSG_HDR_SIZE;
> +	if (len_org > 0) {
> +		printk("\n   data(%d): ", cmd_hdr->dlen);
> +		len = min(len_org, 14);
> +		for (index = 0; index < len; index++)
> +			printk("%x ",
> +			       skb->data[FM_CMD_MSG_HDR_SIZE + index]);
> +		printk("%s", (len_org > 14) ? ".." : "");
> +	}
> +	printk("\n");
> +}
> +
> + /* To dump incoming FM Channel-8 packets */
> +inline void dump_rx_skb_data(struct sk_buff *skb)
> +{
> +	int len, len_org;
> +	char index;
> +	struct fm_event_msg_hdr *evt_hdr;
> +
> +	evt_hdr = (struct fm_event_msg_hdr *)skb->data;
> +	printk(KERN_INFO ">> hdr:%02x len:%02x sts:%02x numhci:%02x "
> +	    "opcode:%02x type:%s dlen:%02x", evt_hdr->header, evt_hdr->len,
> +	    evt_hdr->status, evt_hdr->num_fm_hci_cmds, evt_hdr->fm_opcode,
> +	    (evt_hdr->rd_wr) ? "RD" : "WR", evt_hdr->dlen);
> +
> +	len_org = skb->len - FM_EVT_MSG_HDR_SIZE;
> +	if (len_org > 0) {
> +		printk("\n   data(%d): ", evt_hdr->dlen);
> +		len = min(len_org, 14);
> +		for (index = 0; index < len; index++)
> +			printk("%x ",
> +			       skb->data[FM_EVT_MSG_HDR_SIZE + index]);
> +		printk("%s", (len_org > 14) ? ".." : "");
> +	}
> +	printk("\n");
> +}
> +#endif
> +
> +void fmc_update_region_info(struct fmdrv_ops *fmdev,
> +				unsigned char region_to_set)
> +{
> +	memcpy(&fmdev->rx.region, &region_configs[region_to_set],
> +		sizeof(struct region_info));
> +}
> +
> +/*
> + * FM common sub-module will schedule this tasklet whenever it receives
> + * FM packet from ST driver.
> + */
> +static void __recv_tasklet(unsigned long arg)
> +{
> +	struct fmdrv_ops *fmdev;
> +	struct fm_event_msg_hdr *fm_evt_hdr;
> +	struct sk_buff *skb;
> +	unsigned char num_fm_hci_cmds;
> +	unsigned long flags;
> +
> +	fmdev = (struct fmdrv_ops *)arg;
> +	/* Process all packets in the RX queue */
> +	while ((skb = skb_dequeue(&fmdev->rx_q))) {
> +		if (skb->len < sizeof(struct fm_event_msg_hdr)) {
> +			pr_err("(fmdrv): skb(%p) has only %d bytes"
> +				"atleast need %d bytes to decode\n",
> +				skb, skb->len,
> +				sizeof(struct fm_event_msg_hdr));
> +			kfree_skb(skb);
> +			continue;
> +		}
> +
> +		fm_evt_hdr = (void *)skb->data;
> +		num_fm_hci_cmds = fm_evt_hdr->num_fm_hci_cmds;
> +
> +		/* FM interrupt packet? */
> +		if (fm_evt_hdr->fm_opcode == fm_reg_info[FM_INTERRUPT].opcode) {
> +			/* FM interrupt handler started already? */
> +			if (!test_bit(FM_INTTASK_RUNNING, &fmdev->flag)) {
> +				set_bit(FM_INTTASK_RUNNING, &fmdev->flag);
> +				if (fmdev->irq_info.stage_index != 0) {
> +					pr_err("(fmdrv): Invalid stage index,"
> +						"resetting to zero\n");
> +					fmdev->irq_info.stage_index = 0;
> +				}
> +
> +				/*
> +				 * Execute first function in interrupt handler
> +				 * table.
> +				 */
> +				fmdev->irq_info.fm_int_handlers
> +					[fmdev->irq_info.stage_index](fmdev);
> +			} else {
> +				set_bit(FM_INTTASK_SCHEDULE_PENDING,
> +				&fmdev->flag);
> +			}
> +			kfree_skb(skb);
> +		}
> +		/* Anyone waiting for this with completion handler? */
> +		else if (fm_evt_hdr->fm_opcode == fmdev->last_sent_pkt_opcode &&
> +			fmdev->response_completion != NULL) {
> +			if (fmdev->response_skb != NULL)
> +				pr_err("(fmdrv): Response SKB ptr not NULL\n");
> +
> +			spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
> +			fmdev->response_skb = skb;
> +			spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
> +			complete(fmdev->response_completion);
> +
> +			fmdev->response_completion = NULL;
> +			atomic_set(&fmdev->tx_cnt, 1);
> +		}
> +		/* Is this for interrupt handler? */
> +		else if (fm_evt_hdr->fm_opcode == fmdev->last_sent_pkt_opcode &&
> +			fmdev->response_completion == NULL) {
> +			if (fmdev->response_skb != NULL)
> +				pr_err("(fmdrv): Response SKB ptr not NULL\n");
> +
> +			spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
> +			fmdev->response_skb = skb;
> +			spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
> +
> +			/* Execute interrupt handler where state index points */
> +			fmdev->irq_info.fm_int_handlers
> +				[fmdev->irq_info.stage_index](fmdev);
> +
> +			kfree_skb(skb);
> +			atomic_set(&fmdev->tx_cnt, 1);
> +		} else {
> +			pr_err("(fmdrv): Nobody claimed SKB(%p),purging\n",
> +				skb);
> +		}
> +
> +		/*
> +		 * Check flow control field. If Num_FM_HCI_Commands field is
> +		 * not zero, schedule FM TX tasklet.
> +		 */
> +		if (num_fm_hci_cmds && atomic_read(&fmdev->tx_cnt)) {
> +			if (!skb_queue_empty(&fmdev->tx_q))
> +				tasklet_schedule(&fmdev->tx_task);
> +		}
> +	}
> +}
> +
> +/* FM send tasklet: is scheduled when FM packet has to be sent to chip */
> +static void __send_tasklet(unsigned long arg)
> +{
> +	struct fmdrv_ops *fmdev;
> +	struct sk_buff *skb;
> +	int len;
> +
> +	fmdev = (struct fmdrv_ops *)arg;
> +	/* Check, is there any timeout happenned to last transmitted packet */
> +	if (!atomic_read(&fmdev->tx_cnt) &&
> +		((jiffies - fmdev->last_tx_jiffies) > FM_DRV_TX_TIMEOUT)) {
> +		pr_err("(fmdrv): TX timeout occurred\n");
> +		atomic_set(&fmdev->tx_cnt, 1);
> +	}
> +	/* Send queued FM TX packets */
> +	if (atomic_read(&fmdev->tx_cnt)) {
> +		skb = skb_dequeue(&fmdev->tx_q);
> +		if (skb) {
> +			atomic_dec(&fmdev->tx_cnt);
> +			fmdev->last_sent_pkt_opcode = fm_cb(skb)->fm_opcode;
> +
> +			if (fmdev->response_completion != NULL)
> +				pr_err("(fmdrv): Response completion handler"
> +						"is not NULL\n");
> +
> +			fmdev->response_completion = fm_cb(skb)->completion;
> +
> +			/* Write FM packet to ST driver */
> +			len = g_st_write(skb);
> +			if (len < 0) {
> +				kfree_skb(skb);
> +				fmdev->response_completion = NULL;
> +				pr_err("(fmdrv): TX tasklet failed to send"
> +					"skb(%p)\n", skb);
> +				atomic_set(&fmdev->tx_cnt, 1);
> +			} else {
> +				fmdev->last_tx_jiffies = jiffies;
> +			}
> +		}
> +	}
> +}
> +
> +/*
> + * Queues FM Channel-8 packet to FM TX queue and schedules FM TX tasklet for
> + * transmission
> + */
> +static int __fm_send_cmd(struct fmdrv_ops *fmdev, unsigned char fmreg_index,
> +				void *payload, int payload_len,
> +				struct completion *wait_completion)
> +{
> +	struct sk_buff *skb;
> +	struct fm_cmd_msg_hdr *cmd_hdr;
> +	int size;
> +
> +
> +	if (fmreg_index >= FM_REG_MAX_ENTRIES) {
> +		pr_err("(fmdrv): Invalid fm register index\n");
> +		return -EINVAL;
> +	}
> +	if (test_bit(FM_FIRMWARE_DW_INPROGRESS, &fmdev->flag) &&
> +			payload == NULL) {
> +		pr_err("(fmdrv): Payload data is NULL during fw download\n");
> +		return -EINVAL;
> +	}
> +	if (!test_bit(FM_FIRMWARE_DW_INPROGRESS, &fmdev->flag))
> +		size =
> +		    FM_CMD_MSG_HDR_SIZE + ((payload == NULL) ? 0 : payload_len);
> +	else
> +		size = payload_len;
> +
> +	skb = alloc_skb(size, GFP_ATOMIC);
> +	if (!skb) {
> +		pr_err("(fmdrv): No memory to create new SKB\n");
> +		return -ENOMEM;
> +	}
> +	/*
> +	 * Don't fill FM header info for the commands which come from
> +	 * FM firmware file.
> +	 */
> +	if (!test_bit(FM_FIRMWARE_DW_INPROGRESS, &fmdev->flag) ||
> +	    test_bit(FM_INTTASK_RUNNING, &fmdev->flag)) {
> +		/* Fill command header info */
> +		cmd_hdr =
> +		    (struct fm_cmd_msg_hdr *)skb_put(skb, FM_CMD_MSG_HDR_SIZE);
> +		cmd_hdr->header = FM_PKT_LOGICAL_CHAN_NUMBER;	/* 0x08 */
> +		/* 3 (fm_opcode,rd_wr,dlen) + payload len) */
> +		cmd_hdr->len = ((payload == NULL) ? 0 : payload_len) + 3;
> +		/* FM opcode */
> +		cmd_hdr->fm_opcode = fm_reg_info[fmreg_index].opcode;
> +		/* read/write type */
> +		cmd_hdr->rd_wr = fm_reg_info[fmreg_index].type;
> +		cmd_hdr->dlen = payload_len;
> +		fm_cb(skb)->fm_opcode = fm_reg_info[fmreg_index].opcode;
> +	} else if (payload != NULL) {
> +		fm_cb(skb)->fm_opcode = *((char *)payload + 2);
> +	}
> +	if (payload != NULL)
> +		memcpy(skb_put(skb, payload_len), payload, payload_len);
> +
> +	fm_cb(skb)->completion = wait_completion;
> +	skb_queue_tail(&fmdev->tx_q, skb);
> +	tasklet_schedule(&fmdev->tx_task);
> +
> +	return 0;
> +}
> +
> +/* Sends FM Channel-8 command to the chip and waits for the reponse */
> +int fmc_send_cmd(struct fmdrv_ops *fmdev, unsigned char fmreg_index,
> +			void *payload, int payload_len,
> +			struct completion *wait_completion, void *reponse,
> +			int *reponse_len)
> +{
> +	struct sk_buff *skb;
> +	struct fm_event_msg_hdr *fm_evt_hdr;
> +	unsigned long timeleft;
> +	unsigned long flags;
> +	int ret;
> +
> +	init_completion(wait_completion);
> +	ret = __fm_send_cmd(fmdev, fmreg_index, payload, payload_len,
> +			    wait_completion);
> +	if (ret < 0)
> +		return ret;
> +
> +	timeleft = wait_for_completion_timeout(wait_completion,
> +					       FM_DRV_TX_TIMEOUT);
> +	if (!timeleft) {
> +		pr_err("(fmdrv): Timeout(%d sec),didn't get reg"
> +			   "completion signal from RX tasklet\n",
> +			   jiffies_to_msecs(FM_DRV_TX_TIMEOUT) / 1000);
> +		return -ETIMEDOUT;
> +	}
> +	if (!fmdev->response_skb) {
> +		pr_err("(fmdrv): Reponse SKB is missing\n");
> +		return -EFAULT;
> +	}
> +	spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
> +	skb = fmdev->response_skb;
> +	fmdev->response_skb = NULL;
> +	spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
> +
> +	fm_evt_hdr = (void *)skb->data;
> +	if (fm_evt_hdr->status != 0) {
> +		pr_err("(fmdrv): Received event pkt status(%d) is not zero\n",
> +			   fm_evt_hdr->status);
> +		kfree_skb(skb);
> +		return -EIO;
> +	}
> +	/* Send reponse data to caller */
> +	if (reponse != NULL && reponse_len != NULL && fm_evt_hdr->dlen) {
> +		/* Skip header info and copy only response data */
> +		skb_pull(skb, sizeof(struct fm_event_msg_hdr));
> +		memcpy(reponse, skb->data, fm_evt_hdr->dlen);
> +		*reponse_len = fm_evt_hdr->dlen;
> +	} else if (reponse_len != NULL && fm_evt_hdr->dlen == 0) {
> +		*reponse_len = 0;
> +	}
> +	kfree_skb(skb);
> +	return 0;
> +}
> +
> +/* --- Helper functions used in FM interrupt handlers ---*/
> +static inline int __check_cmdresp_status(struct fmdrv_ops *fmdev,
> +						struct sk_buff **skb)
> +{
> +	struct fm_event_msg_hdr *fm_evt_hdr;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fmdev->resp_skb_lock, flags);
> +	*skb = fmdev->response_skb;
> +	fmdev->response_skb = NULL;
> +	spin_unlock_irqrestore(&fmdev->resp_skb_lock, flags);
> +
> +	fm_evt_hdr = (void *)(*skb)->data;
> +	if (fm_evt_hdr->status != 0) {
> +		pr_err("(fmdrv): irq: opcode %x response status is not zero\n",
> +			   fm_evt_hdr->fm_opcode);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Interrupt process timeout handler.
> + * One of the irq handler did not get proper response from the chip. So take
> + * recovery action here. FM interrupts are disabled in the beginning of
> + * interrupt process. Therefore reset stage index to re-enable default
> + * interrupts. So that next interrupt will be processed as usual.
> + */
> +static void __int_timeout_handler(unsigned long data)
> +{
> +	struct fmdrv_ops *fmdev;
> +
> +	pr_debug("(fmdrv): irq: timeout,trying to re-enable fm interrupts\n");
> +	fmdev = (struct fmdrv_ops *)data;
> +	fmdev->irq_info.irq_service_timeout_retry++;
> +
> +	if (fmdev->irq_info.irq_service_timeout_retry <=
> +	    FM_IRQ_TIMEOUT_RETRY_MAX) {
> +		fmdev->irq_info.stage_index = FM_SEND_INTMSK_CMD_INDEX;
> +		fmdev->irq_info.fm_int_handlers[fmdev->irq_info.
> +							 stage_index] (fmdev);
> +	} else {
> +		/*
> +		 * Stop recovery action (interrupt reenable process) and
> +		 * reset stage index & retry count values
> +		 */
> +		fmdev->irq_info.stage_index = 0;
> +		fmdev->irq_info.irq_service_timeout_retry = 0;
> +		pr_err("(fmdrv): Recovery action failed during"
> +			"irq processing, max retry reached\n");
> +	}
> +}
> +
> +/* --------- FM interrupt handlers ------------*/
> +static void fm_irq_send_flag_getcmd(void *arg)
> +{
> +	struct fmdrv_ops *fmdev;
> +	unsigned short flag;
> +	int ret;
> +
> +	fmdev = arg;
> +	/* Send FLAG_GET command , to know the source of interrupt */
> +	ret = __fm_send_cmd(fmdev, FLAG_GET, NULL, sizeof(flag), NULL);
> +	if (ret)
> +		pr_err("(fmdrv): irq: failed to send flag_get command,"
> +			   "initiating irq recovery process\n");
> +	else
> +		fmdev->irq_info.stage_index = FM_HANDLE_FLAG_GETCMD_RESP_INDEX;
> +
> +	mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
> +		  FM_DRV_TX_TIMEOUT);
> +}
> +
> +static void fm_irq_handle_flag_getcmd_resp(void *arg)
> +{
> +	struct fmdrv_ops *fmdev;
> +	struct sk_buff *skb;
> +	struct fm_event_msg_hdr *fm_evt_hdr;
> +	char ret;
> +
> +	fmdev = arg;
> +	del_timer(&fmdev->irq_info.int_timeout_timer);
> +
> +	ret = __check_cmdresp_status(fmdev, &skb);
> +	if (ret < 0) {
> +		pr_err("(fmdrv): Initiating irq recovery process\n");
> +		mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
> +			  FM_DRV_TX_TIMEOUT);
> +		return;
> +	}
> +	fm_evt_hdr = (void *)skb->data;
> +
> +	/* Skip header info and copy only response data */
> +	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
> +	memcpy(&fmdev->irq_info.flag, skb->data, fm_evt_hdr->dlen);
> +
> +	FM_STORE_BE16_TO_LE16(fmdev->irq_info.flag, fmdev->irq_info.flag);
> +	pr_debug("(fmdrv): irq: flag register(0x%x)\n", fmdev->irq_info.flag);
> +
> +	/* Continue next function in interrupt handler table */
> +	fmdev->irq_info.stage_index = FM_HW_MAL_FUNC_INDEX;
> +
> +	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
> +}

OK, I think the way interrupts are handled should be revamped. It is way too
complex IMHO. All these action/response handlers have a similar structure,
particularly for the response handlers as this part of the code is the same
for all as far as I can tell:

	del_timer(&fmdev->irq_info.int_timeout_timer);

	ret = __check_cmdresp_status(fmdev, &skb);
	if (ret < 0) {
		pr_err("(fmdrv): Initiating irq recovery process\n");
		mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
			  FM_DRV_TX_TIMEOUT);
		return;
	}

What I think should happen is that rather than having each handler chain the
other there is one core handler that is taking care of that. So the boilerplate
code is in that core handler and it is calling the other handlers. So e.g. the
hw_malfunction handler below could become something like this:

static int fm_irq_handle_hw_malfunction(struct fmdrv_ops *fmdev, unsigned events)
{
	if (!(events & FM_MAL_EVENT))
		pr_err("(fmdrv): irq: HW MAL int received - do nothing\n");
	return FM_RDS_START_INDEX;
}

And unsigned events is set to fmdev->irq_info.flag & fmdev->irq_info.mask.

This would refactor out a lot of code.

> +static void fm_irq_handle_hw_malfunction(void *arg)
> +{
> +	struct fmdrv_ops *fmdev;
> +
> +	fmdev = arg;
> +	if (fmdev->irq_info.flag & FM_MAL_EVENT & fmdev->irq_info.mask)
> +		pr_err("(fmdrv): irq: HW MAL int received - do nothing\n");
> +
> +	/* Continue next function in interrupt handler table */
> +	fmdev->irq_info.stage_index = FM_RDS_START_INDEX;
> +	fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
> +}

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
