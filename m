Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0IVKih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:38:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41878 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab0IVKhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:37:47 -0400
From: x0130808@ti.com
To: linux-kernel@vger.kernel.org
Cc: Raja Mani <raja_mani@ti.com>, Pramodh AG <pramodh_ag@ti.com>,
        Manjunatha Halli <x0130808@ti.com>
Subject: [RFC/PATCH 5/9] drivers:staging:ti-st: Sources for FM common header
Date: Wed, 22 Sep 2010 07:48:35 -0400
Message-Id: <1285156119-28531-6-git-send-email-x0130808@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1285156119-28531-5-git-send-email-x0130808@ti.com>
References: <1285156119-28531-1-git-send-email-x0130808@ti.com>
 <1285156119-28531-2-git-send-email-x0130808@ti.com>
 <1285156119-28531-3-git-send-email-x0130808@ti.com>
 <1285156119-28531-4-git-send-email-x0130808@ti.com>
 <1285156119-28531-5-git-send-email-x0130808@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raja Mani <raja_mani@ti.com>

These are common headers used in FM submodules (FM V4L2, FM common, FM Rx,
and FM TX).

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 drivers/staging/ti-st/fm.h    |   13 +++
 drivers/staging/ti-st/fmdrv.h |  230 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 243 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/fm.h
 create mode 100644 drivers/staging/ti-st/fmdrv.h

diff --git a/drivers/staging/ti-st/fm.h b/drivers/staging/ti-st/fm.h
new file mode 100644
index 0000000..be41453
--- /dev/null
+++ b/drivers/staging/ti-st/fm.h
@@ -0,0 +1,13 @@
+struct fm_event_hdr {
+	unsigned char plen;
+} __attribute__ ((packed));
+
+#define FM_MAX_FRAME_SIZE 0xFF	/* TODO: */
+#define FM_EVENT_HDR_SIZE 1	/* size of fm_event_hdr */
+#define ST_FM_CH8_PKT 0x8
+
+/* gps stuff */
+struct gps_event_hdr {
+unsigned char opcode;
+unsigned short plen;
+} __attribute__ ((packed));
diff --git a/drivers/staging/ti-st/fmdrv.h b/drivers/staging/ti-st/fmdrv.h
new file mode 100644
index 0000000..4ca368d
--- /dev/null
+++ b/drivers/staging/ti-st/fmdrv.h
@@ -0,0 +1,230 @@
+/*
+ *  FM Driver for Connectivity chip of Texas Instruments.
+ *
+ *  Common header for all FM driver sub-modules.
+ *
+ *  Copyright (C) 2009 Texas Instruments
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
+#ifndef _FM_DRV_H
+#define _FM_DRV_H
+
+#include <linux/skbuff.h>
+#include <linux/interrupt.h>
+#include <sound/core.h>
+#include <sound/initval.h>
+#include <linux/timer.h>
+#include <linux/version.h>
+
+#define FM_DRV_VERSION            "0.01"
+/* Should match with FM_DRV_VERSION */
+#define FM_DRV_RADIO_VERSION      KERNEL_VERSION(0, 0, 1)
+#define FM_DRV_NAME               "ti_fmdrv"
+#define FM_DRV_CARD_SHORT_NAME    "TI FM Radio"
+#define FM_DRV_CARD_LONG_NAME     "Texas Instruments FM Radio"
+
+/* Flag info */
+#define FM_INTTASK_RUNNING            0
+#define FM_INTTASK_SCHEDULE_PENDING   1
+#define FM_FIRMWARE_DW_INPROGRESS     2
+#define FM_CORE_READY                 3
+#define FM_CORE_TRANSPORT_READY       4
+#define FM_AF_SWITCH_INPROGRESS	      5
+#define FM_CORE_TX_XMITING	      6
+
+#define FM_DRV_TX_TIMEOUT      (5*HZ)	/* 5 seconds */
+#define FM_DRV_RX_SEEK_TIMEOUT (20*HZ)	/* 20 seconds */
+
+#define NO_OF_ENTRIES_IN_ARRAY(array) (sizeof(array) / sizeof(array[0]))
+
+enum {
+	FM_MODE_OFF,
+	FM_MODE_TX,
+	FM_MODE_RX,
+	FM_MODE_ENTRY_MAX
+};
+
+#define FM_RX_RDS_INFO_FIELD_MAX	8	/* 4 Group * 2 Bytes */
+
+/* RX RDS data format */
+struct fm_rdsdata_format {
+	union {
+		struct {
+			unsigned char rdsbuff[FM_RX_RDS_INFO_FIELD_MAX];
+		} groupdatabuff;
+		struct {
+			unsigned short pidata;
+			unsigned char block_b_byte1;
+			unsigned char block_b_byte2;
+			unsigned char block_c_byte1;
+			unsigned char block_c_byte2;
+			unsigned char block_d_byte1;
+			unsigned char block_d_byte2;
+		} groupgeneral;
+		struct {
+			unsigned short pidata;
+			unsigned char block_b_byte1;
+			unsigned char block_b_byte2;
+			unsigned char firstaf;
+			unsigned char secondaf;
+			unsigned char firstpsbyte;
+			unsigned char secondpsbyte;
+		} group0A;
+
+		struct {
+			unsigned short pidata;
+			unsigned char block_b_byte1;
+			unsigned char block_b_byte2;
+			unsigned short pidata2;
+			unsigned char firstpsbyte;
+			unsigned char secondpsbyte;
+		} group0B;
+	} rdsdata;
+};
+
+/* FM region (Europe/US, Japan) info */
+struct region_info {
+	unsigned int channel_spacing;
+	unsigned int bottom_frequency;
+	unsigned int top_frequency;
+	unsigned char region_index;
+};
+
+typedef void (*int_handler_prototype) (void *);
+
+/* FM Interrupt processing related info */
+struct fm_irq {
+	unsigned char stage_index;
+	unsigned short flag;	/* FM interrupt flag */
+	unsigned short mask;	/* FM interrupt mask */
+	/* Interrupt process timeout handler */
+	struct timer_list int_timeout_timer;
+	unsigned char irq_service_timeout_retry;
+	int_handler_prototype *fm_int_handlers;
+};
+
+/* RDS info */
+struct fm_rds {
+	unsigned char flag;	/* RX RDS on/off status */
+	unsigned char last_block_index;	/* Last received RDS block */
+
+	/* RDS buffer */
+	wait_queue_head_t read_queue;
+	unsigned int buf_size;	/* Size is always multiple of 3 */
+	unsigned int wr_index;
+	unsigned int rd_index;
+	unsigned char *buffer;
+};
+
+#define FM_RDS_MAX_AF_LIST		25
+
+/*
+ * Current RX channel Alternate Frequency cache.
+ * This info is used to switch to other freq (AF)
+ * when current channel signal strengh is below RSSI threshold.
+ */
+struct tuned_station_info {
+	unsigned short picode;
+	unsigned int af_cache[FM_RDS_MAX_AF_LIST];
+	unsigned char no_of_items_in_afcache;
+	unsigned char af_list_max;
+};
+
+/* FM RX mode info */
+struct fm_rx {
+	struct region_info region;	/* Current selected band */
+	unsigned int curr_freq;	/* Current RX frquency */
+	unsigned char curr_mute_mode;	/* Current mute mode */
+	/* RF dependent soft mute mode */
+	unsigned char curr_rf_depend_mute;
+	unsigned short curr_volume;	/* Current volume level */
+	short curr_rssi_threshold;	/* Current RSSI threshold level */
+	/* Holds the index of the current AF jump */
+	unsigned char cur_afjump_index;
+	/* Will hold the frequency before the jump */
+	unsigned int freq_before_jump;
+	unsigned char rds_mode;	/* RDS operation mode (RDS/RDBS) */
+	unsigned char af_mode;	/* Alternate frequency on/off */
+	struct tuned_station_info cur_station_info;
+	struct fm_rds rds;
+};
+
+/*
+ * FM TX RDS data
+ *
+ * @ text_type: is the text following PS or RT
+ * @ text: radio text string which could either be PS or RT
+ * @ af_freq: alternate frequency for Tx
+ * TODO: to be declared in application
+ */
+struct tx_rds {
+	unsigned char text_type;
+	unsigned char text[25];
+	unsigned char flag;
+	unsigned int af_freq;
+};
+/*
+ * FM TX global data
+ *
+ * @ pwr_lvl: Power Level of the Transmission from mixer control
+ * @ xmit_state: Transmission state = Updated locally upon Start/Stop
+ * @ audio_io: i2S/Analog
+ * @ tx_frq: Transmission frequency
+ */
+struct fmtx_data {
+	unsigned char pwr_lvl;
+	unsigned char xmit_state;
+	unsigned char audio_io;
+	unsigned char region;
+	unsigned short aud_mode;
+	unsigned int preemph;
+	unsigned long tx_frq;
+	struct tx_rds rds;
+};
+
+/* FM driver operation structure */
+struct fmdrv_ops {
+	struct video_device *radio_dev;	/* V4L2 video device pointer */
+	struct snd_card *card;	/* Card which holds FM mixer controls */
+	unsigned short asci_id;
+	spinlock_t rds_buff_lock; /* To protect access to RDS buffer */
+	spinlock_t resp_skb_lock; /* To protect access to received SKB */
+
+	long flag;		/*  FM driver state machine info */
+	char streg_cbdata; /* status of ST registration */
+
+	struct sk_buff_head rx_q;	/* RX queue */
+	struct tasklet_struct rx_task;	/* RX Tasklet */
+
+	struct sk_buff_head tx_q;	/* TX queue */
+	struct tasklet_struct tx_task;	/* TX Tasklet */
+	unsigned long last_tx_jiffies;	/* Timestamp of last pkt sent */
+	atomic_t tx_cnt;	/* Number of packets can send at a time */
+
+	struct sk_buff *response_skb;	/* Response from the chip */
+	/* Main task completion handler */
+	struct completion maintask_completion;
+	/* Opcode of last command sent to the chip */
+	unsigned char last_sent_pkt_opcode;
+	/* Handler used for wakeup when response packet is received */
+	struct completion *response_completion;
+	struct fm_irq irq_info;
+	unsigned char curr_fmmode; /* Current FM chip mode (TX, RX, OFF) */
+	struct fm_rx rx;	/* FM receiver info */
+	struct fmtx_data tx_data;
+};
+#endif
-- 
1.5.6.3

