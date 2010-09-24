Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab0IXNs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:48:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35925 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab0IXNsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:48:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:date:x-google-sender-auth:message-id
         :subject:from:to:content-type;
        b=iIDRNYDO4m3NsP9Rl7K9S+95cvVoFCCaTwS3wfrOwksCIzhIRP4fOLm++9h/LyFZ7e
         xsTzp3P/lm74M/b27cr1evbpa4xHH1A0cgcD1JA6p+4sthuqf6gaSi8SkUeLO5Fj1Qsr
         qwmayrZBl5lz6E0nwaaQLZ0e2S2voAFMKS8ps=
MIME-Version: 1.0
Reply-To: pghatwork@gmail.com
Date: Fri, 24 Sep 2010 15:48:08 +0200
X-Google-Sender-Auth: mQrDM9-IVItKqTfI74zP154JosU
Message-ID: <AANLkTimzVXvbRyCOrMd5bChR2CAxFKBcvhH01Kknf0DV@mail.gmail.com>
Subject: [PATCH 2/6] This patch adds support for the ST-Ericsson CG2900
From: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Pavan Savoy <pavan_savoy@sify.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the ST-Ericsson CG2900 connectivity
 controller. This patch registers into the CG2900 framework.
 It handles chip startup and shutdown together with firmware download.
 It also handles Bluetooth and FM flow control due to special H4 channel
 management.

Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
---
 drivers/mfd/Kconfig              |    6 +
 drivers/mfd/cg2900/Makefile      |    2 +
 drivers/mfd/cg2900/cg2900_chip.c | 2060 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/cg2900/cg2900_chip.h |  421 ++++++++
 4 files changed, 2489 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/cg2900/cg2900_chip.c
 create mode 100644 drivers/mfd/cg2900/cg2900_chip.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c0a6652..f1fb334 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -584,6 +584,12 @@ config MFD_CG2900
 	  Supports multiple functionalities muxed over a Bluetooth HCI H:4 interface.
 	  CG2900 support Bluetooth, FM radio, and GPS.

+config MFD_CG2900_CHIP
+	tristate "Support CG2900 Connectivity controller"
+	depends on MFD_CG2900
+	help
+	  Support for ST-Ericsson CG2900 Connectivity Controller
+
 endif # MFD_SUPPORT

 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/cg2900/Makefile b/drivers/mfd/cg2900/Makefile
index 76af761..b49bf6b 100644
--- a/drivers/mfd/cg2900/Makefile
+++ b/drivers/mfd/cg2900/Makefile
@@ -5,3 +5,5 @@
 obj-$(CONFIG_MFD_CG2900)            += cg2900.o
 cg2900-objs                         := cg2900_core.o cg2900_char_devices.o
 export-objs                         := cg2900_core.o
+
+obj-$(CONFIG_MFD_CG2900_CHIP)       += cg2900_chip.o
diff --git a/drivers/mfd/cg2900/cg2900_chip.c b/drivers/mfd/cg2900/cg2900_chip.c
new file mode 100644
index 0000000..4c06416
--- /dev/null
+++ b/drivers/mfd/cg2900/cg2900_chip.c
@@ -0,0 +1,2060 @@
+/*
+ * drivers/mfd/cg2900/cg2900_chip.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/skbuff.h>
+#include <linux/gfp.h>
+#include <linux/stat.h>
+#include <linux/types.h>
+#include <linux/time.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/firmware.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <asm/byteorder.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+
+#include <asm/byteorder.h>
+
+#include <linux/mfd/cg2900.h>
+#include <mach/cg2900_devices.h>
+#include "hci_defines.h"
+#include "cg2900_chip.h"
+#include "cg2900_core.h"
+#include "cg2900_debug.h"
+
+#define LINE_BUFFER_LENGTH			128
+#define FILENAME_MAX				128
+
+#define WQ_NAME					"cg2900_chip_wq"
+#define PATCH_INFO_FILE				"cg2900_patch_info.fw"
+#define FACTORY_SETTINGS_INFO_FILE		"cg2900_settings_info.fw"
+
+/* Size of file chunk ID */
+#define FILE_CHUNK_ID_SIZE			1
+#define FILE_CHUNK_ID_POS			4
+
+/* Times in milliseconds */
+#define POWER_SW_OFF_WAIT			500
+
+/* State setting macros */
+#define SET_BOOT_STATE(__cg2900_new_state) \
+	CG2900_SET_STATE("boot_state", cg2900_info->boot_state, \
+			 __cg2900_new_state)
+#define SET_CLOSING_STATE(__cg2900_new_state) \
+	CG2900_SET_STATE("closing_state", cg2900_info->closing_state, \
+			 __cg2900_new_state)
+#define SET_FILE_LOAD_STATE(__cg2900_new_state) \
+	CG2900_SET_STATE("file_load_state", cg2900_info->file_load_state, \
+			 __cg2900_new_state)
+#define SET_DOWNLOAD_STATE(__cg2900_new_state) \
+	CG2900_SET_STATE("download_state", cg2900_info->download_state, \
+			 __cg2900_new_state)
+
+/** CHANNEL_BT_CMD - Bluetooth HCI H:4 channel
+ * for Bluetooth commands in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_BT_CMD		0x01
+
+/** CHANNEL_BT_ACL - Bluetooth HCI H:4 channel
+ * for Bluetooth ACL data in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_BT_ACL		0x02
+
+/** CHANNEL_BT_EVT - Bluetooth HCI H:4 channel
+ * for Bluetooth events in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_BT_EVT		0x04
+
+/** CHANNEL_FM_RADIO - Bluetooth HCI H:4 channel
+ * for FM radio in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_FM_RADIO		0x08
+
+/** CHANNEL_GNSS - Bluetooth HCI H:4 channel
+ * for GNSS in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_GNSS			0x09
+
+/** CHANNEL_DEBUG - Bluetooth HCI H:4 channel
+ * for internal debug data in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_DEBUG		0x0B
+
+/** CHANNEL_STE_TOOLS - Bluetooth HCI H:4 channel
+ * for development tools data in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_STE_TOOLS		0x0D
+
+/** CHANNEL_HCI_LOGGER - Bluetooth HCI H:4 channel
+ * for logging all transmitted H4 packets (on all channels).
+ */
+#define CHANNEL_HCI_LOGGER		0xFA
+
+/** CHANNEL_US_CTRL - Bluetooth HCI H:4 channel
+ * for user space control of the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_US_CTRL		0xFC
+
+/** CHANNEL_CORE - Bluetooth HCI H:4 channel
+ * for user space control of the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_CORE			0xFD
+
+/**
+ * enum boot_state - BOOT-state for CG2900 chip driver.
+ * @BOOT_NOT_STARTED:			Boot has not yet started.
+ * @BOOT_SEND_BD_ADDRESS:		VS Store In FS command with BD address
+ *					has been sent.
+ * @BOOT_GET_FILES_TO_LOAD:		CG2900 chip driver is retrieving file to
+ *					load.
+ * @BOOT_DOWNLOAD_PATCH:		CG2900 chip driver is downloading
+ *					patches.
+ * @BOOT_ACTIVATE_PATCHES_AND_SETTINGS:	CG2900 chip driver is
activating patches
+ *					and settings.
+ * @BOOT_READY:				CG2900 chip driver boot is ready.
+ * @BOOT_FAILED:			CG2900 chip driver boot failed.
+ */
+enum boot_state {
+	BOOT_NOT_STARTED,
+	BOOT_SEND_BD_ADDRESS,
+	BOOT_GET_FILES_TO_LOAD,
+	BOOT_DOWNLOAD_PATCH,
+	BOOT_ACTIVATE_PATCHES_AND_SETTINGS,
+	BOOT_READY,
+	BOOT_FAILED
+};
+
+/**
+ * enum closing_state - CLOSING-state for CG2900 chip driver.
+ * @CLOSING_RESET:		HCI RESET_CMD has been sent.
+ * @CLOSING_POWER_SWITCH_OFF:	HCI VS_POWER_SWITCH_OFF command has been sent.
+ * @CLOSING_SHUT_DOWN:		We have now shut down the chip.
+ */
+enum closing_state {
+	CLOSING_RESET,
+	CLOSING_POWER_SWITCH_OFF,
+	CLOSING_SHUT_DOWN
+};
+
+/**
+ * enum file_load_state - BOOT_FILE_LOAD-state for CG2900 chip driver.
+ * @FILE_LOAD_GET_PATCH:		Loading patches.
+ * @FILE_LOAD_GET_STATIC_SETTINGS:	Loading static settings.
+ * @FILE_LOAD_NO_MORE_FILES:		No more files to load.
+ * @FILE_LOAD_FAILED:			File loading failed.
+ */
+enum file_load_state {
+	FILE_LOAD_GET_PATCH,
+	FILE_LOAD_GET_STATIC_SETTINGS,
+	FILE_LOAD_NO_MORE_FILES,
+	FILE_LOAD_FAILED
+};
+
+/**
+ * enum download_state - BOOT_DOWNLOAD state.
+ * @DOWNLOAD_PENDING:	Download in progress.
+ * @DOWNLOAD_SUCCESS:	Download successfully finished.
+ * @DOWNLOAD_FAILED:	Downloading failed.
+ */
+enum download_state {
+	DOWNLOAD_PENDING,
+	DOWNLOAD_SUCCESS,
+	DOWNLOAD_FAILED
+};
+
+/**
+ * enum fm_radio_mode - FM Radio mode.
+ * It's needed because some FM do-commands generate interrupts only when
+ * the FM driver is in specific mode and we need to know if we should expect
+ * the interrupt.
+ * @FM_RADIO_MODE_IDLE:	Radio mode is Idle (default).
+ * @FM_RADIO_MODE_FMT:	Radio mode is set to FMT (transmitter).
+ * @FM_RADIO_MODE_FMR:	Radio mode is set to FMR (receiver).
+ */
+enum fm_radio_mode {
+	FM_RADIO_MODE_IDLE = 0,
+	FM_RADIO_MODE_FMT = 1,
+	FM_RADIO_MODE_FMR = 2
+};
+
+/**
+ * struct cg2900_device_id - Structure for connecting H4 channel to named user.
+ * @name:		Name of device.
+ * @h4_channel:	HCI H:4 channel used by this device.
+ */
+struct cg2900_device_id {
+	char	*name;
+	int	h4_channel;
+};
+
+/**
+ * struct cg2900_skb_data - Structure for storing private data in an sk_buffer.
+ * @dev:	CG2900 device for this sk_buffer.
+ */
+struct cg2900_skb_data {
+	struct cg2900_device *dev;
+};
+#define cg2900_skb_data(__skb) ((struct cg2900_skb_data *)((__skb)->cb))
+
+/**
+ * struct cg2900_info - Main info structure for CG2900 chip driver.
+ * @patch_file_name:		Stores patch file name.
+ * @settings_file_name:		Stores settings file name.
+ * @fw_file:			Stores firmware file (patch or settings).
+ * @file_offset:		Current read offset in firmware file.
+ * @chunk_id:			Stores current chunk ID of write file
+ *				operations.
+ * @boot_state:			Current BOOT-state of CG2900 chip driver.
+ * @closing_state:		Current CLOSING-state of CG2900 chip driver.
+ * @file_load_state:		Current BOOT_FILE_LOAD-state of CG2900 chip
+ *				driver.
+ * @download_state:		Current BOOT_DOWNLOAD-state of CG2900 chip
+ *				driver.
+ * @wq:				CG2900 chip driver workqueue.
+ * @chip_dev:			Chip handler info.
+ * @tx_bt_lock:			Spinlock used to protect some global structures
+ *				related to internal BT command flow control.
+ * @tx_fm_lock:			Spinlock used to protect some global structures
+ *				related to internal FM command flow control.
+ * @tx_fm_audio_awaiting_irpt:	Indicates if an FM interrupt event related to
+ *				audio driver command is expected.
+ * @fm_radio_mode:		Current FM radio mode.
+ * @tx_nr_pkts_allowed_bt:	Number of packets allowed to send on BT HCI CMD
+ *				H4 channel.
+ * @audio_bt_cmd_op:		Stores the OpCode of the last sent audio driver
+ *				HCI BT CMD.
+ * @audio_fm_cmd_id:		Stores the command id of the last sent
+ *				HCI FM RADIO command by the fm audio user.
+ * @hci_fm_cmd_func:		Stores the command function of the last sent
+ *				HCI FM RADIO command by the fm radio user.
+ * @tx_queue_bt:		TX queue for HCI BT commands when nr of commands
+ *				allowed is 0 (CG2900 internal flow control).
+ * @tx_queue_fm:		TX queue for HCI FM commands when nr of commands
+ *				allowed is 0 (CG2900 internal flow control).
+ */
+struct cg2900_info {
+	char				*patch_file_name;
+	char				*settings_file_name;
+	const struct firmware		*fw_file;
+	int				file_offset;
+	u8				chunk_id;
+	enum boot_state			boot_state;
+	enum closing_state		closing_state;
+	enum file_load_state		file_load_state;
+	enum download_state		download_state;
+	struct workqueue_struct		*wq;
+	struct cg2900_chip_dev		chip_dev;
+	spinlock_t			tx_bt_lock;
+	spinlock_t			tx_fm_lock;
+	bool				tx_fm_audio_awaiting_irpt;
+	enum fm_radio_mode		fm_radio_mode;
+	int				tx_nr_pkts_allowed_bt;
+	u16				audio_bt_cmd_op;
+	u16				audio_fm_cmd_id;
+	u16				hci_fm_cmd_func;
+	struct sk_buff_head		tx_queue_bt;
+	struct sk_buff_head		tx_queue_fm;
+};
+
+static struct cg2900_info *cg2900_info;
+
+/*
+ * cg2900_channels() - Array containing available H4 channels for the CG2900
+ * ST-Ericsson Connectivity controller.
+ */
+struct cg2900_device_id cg2900_channels[] = {
+	{CG2900_BT_CMD,			CHANNEL_BT_CMD},
+	{CG2900_BT_ACL,			CHANNEL_BT_ACL},
+	{CG2900_BT_EVT,			CHANNEL_BT_EVT},
+	{CG2900_GNSS,			CHANNEL_GNSS},
+	{CG2900_FM_RADIO,		CHANNEL_FM_RADIO},
+	{CG2900_DEBUG,			CHANNEL_DEBUG},
+	{CG2900_STE_TOOLS,		CHANNEL_STE_TOOLS},
+	{CG2900_HCI_LOGGER,		CHANNEL_HCI_LOGGER},
+	{CG2900_US_CTRL,		CHANNEL_US_CTRL},
+	{CG2900_BT_AUDIO,		CHANNEL_BT_CMD},
+	{CG2900_FM_RADIO_AUDIO,		CHANNEL_FM_RADIO},
+	{CG2900_CORE,			CHANNEL_CORE}
+};
+
+/*
+ *	Internal function
+ */
+
+/**
+ * create_and_send_bt_cmd() - Copy and send sk_buffer.
+ * @data:	Data to send.
+ * @length:	Length in bytes of data.
+ *
+ * The create_and_send_bt_cmd() function allocate sk_buffer, copy supplied data
+ * to it, and send the sk_buffer to controller.
+ */
+static void create_and_send_bt_cmd(void *data, int length)
+{
+	struct sk_buff *skb;
+	struct cg2900_hci_logger_config *logger_config;
+	int err;
+
+	skb = cg2900_alloc_skb(length, GFP_ATOMIC);
+	if (!skb) {
+		CG2900_ERR("Couldn't alloc sk_buff with length %d", length);
+		return;
+	}
+
+	memcpy(skb_put(skb, length), data, length);
+	skb_push(skb, CG2900_SKB_RESERVE);
+	skb->data[0] = CHANNEL_BT_CMD;
+
+	logger_config = cg2900_get_hci_logger_config();
+	if (logger_config)
+		err = cg2900_send_to_chip(skb, logger_config->bt_cmd_enable);
+	else
+		err = cg2900_send_to_chip(skb, false);
+
+	if (err) {
+		CG2900_ERR("Failed to transmit to chip (%d)", err);
+		kfree_skb(skb);
+	}
+}
+
+/**
+ * fm_irpt_expected() - check if this FM command will generate an interrupt.
+ * @cmd_id:	command identifier.
+ *
+ * Returns:
+ *   true if the command will generate an interrupt.
+ *   false if it won't.
+ */
+static bool fm_irpt_expected(u16 cmd_id)
+{
+	bool retval = false;
+
+	switch (cmd_id) {
+	case CG2900_FM_DO_AIP_FADE_START:
+		if (cg2900_info->fm_radio_mode == FM_RADIO_MODE_FMT)
+			retval = true;
+		break;
+
+	case CG2900_FM_DO_AUP_BT_FADE_START:
+	case CG2900_FM_DO_AUP_EXT_FADE_START:
+	case CG2900_FM_DO_AUP_FADE_START:
+		if (cg2900_info->fm_radio_mode == FM_RADIO_MODE_FMR)
+			retval = true;
+		break;
+
+	case CG2900_FM_DO_FMR_SETANTENNA:
+	case CG2900_FM_DO_FMR_SP_AFSWITCH_START:
+	case CG2900_FM_DO_FMR_SP_AFUPDATE_START:
+	case CG2900_FM_DO_FMR_SP_BLOCKSCAN_START:
+	case CG2900_FM_DO_FMR_SP_PRESETPI_START:
+	case CG2900_FM_DO_FMR_SP_SCAN_START:
+	case CG2900_FM_DO_FMR_SP_SEARCH_START:
+	case CG2900_FM_DO_FMR_SP_SEARCHPI_START:
+	case CG2900_FM_DO_FMR_SP_TUNE_SETCHANNEL:
+	case CG2900_FM_DO_FMR_SP_TUNE_STEPCHANNEL:
+	case CG2900_FM_DO_FMT_PA_SETCTRL:
+	case CG2900_FM_DO_FMT_PA_SETMODE:
+	case CG2900_FM_DO_FMT_SP_TUNE_SETCHANNEL:
+	case CG2900_FM_DO_GEN_ANTENNACHECK_START:
+	case CG2900_FM_DO_GEN_GOTOMODE:
+	case CG2900_FM_DO_GEN_POWERSUPPLY_SETMODE:
+	case CG2900_FM_DO_GEN_SELECTREFERENCECLOCK:
+	case CG2900_FM_DO_GEN_SETPROCESSINGCLOCK:
+	case CG2900_FM_DO_GEN_SETREFERENCECLOCKPLL:
+	case CG2900_FM_DO_TST_TX_RAMP_START:
+		retval = true;
+		break;
+
+	default:
+		break;
+	}
+
+	if (retval)
+		CG2900_INFO("Following interrupt event expected for this "
+			    "Cmd complete evt, cmd_id = 0x%x.", cmd_id);
+
+	return retval;
+}
+
+/**
+ * fm_is_do_cmd_irpt() - Check if irpt_val is one of the FM DO
command related interrupts.
+ * @irpt_val:	interrupt value.
+ *
+ * Returns:
+ *   true if it's do-command related interrupt value.
+ *   false if it's not.
+ */
+static bool fm_is_do_cmd_irpt(u16 irpt_val)
+{
+	if ((irpt_val & CG2900_FM_IRPT_OPERATION_SUCCEEDED) ||
+	    (irpt_val & CG2900_FM_IRPT_OPERATION_FAILED)) {
+		CG2900_INFO("Irpt evt for FM do-command found, "
+			    "irpt_val = 0x%x.", irpt_val);
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * create_work_item() - Create work item and add it to the work queue.
+ * @work_func:	Work function.
+ *
+ * The create_work_item() function creates work item and add it to
+ * the work queue.
+ */
+static void create_work_item(work_func_t work_func)
+{
+	struct work_struct *new_work;
+	int wq_err;
+
+	new_work = kmalloc(sizeof(*new_work), GFP_ATOMIC);
+	if (!new_work) {
+		CG2900_ERR("Failed to alloc memory for work_struct!");
+		return;
+	}
+
+	INIT_WORK(new_work, work_func);
+
+	wq_err = queue_work(cg2900_info->wq, new_work);
+	if (!wq_err) {
+		CG2900_ERR("Failed to queue work_struct because it's already "
+			   "in the queue!");
+		kfree(new_work);
+	}
+}
+
+/**
+ * fm_reset_flow_ctrl - Clears up internal FM flow control.
+ *
+ * Resets outstanding commands and clear FM TX list and set CG2900 FM mode to
+ * idle.
+ */
+static void fm_reset_flow_ctrl(void)
+{
+	CG2900_INFO("fm_reset_flow_ctrl");
+
+	skb_queue_purge(&cg2900_info->tx_queue_fm);
+
+	/* Reset the fm_cmd_id. */
+	cg2900_info->audio_fm_cmd_id = CG2900_FM_CMD_NONE;
+	cg2900_info->hci_fm_cmd_func = CG2900_FM_CMD_PARAM_NONE;
+
+	cg2900_info->fm_radio_mode = FM_RADIO_MODE_IDLE;
+}
+
+
+/**
+ * fm_parse_cmd - Parses a FM command packet.
+ * @data:	FM command packet.
+ * @cmd_func:	Out: FM legacy command function.
+ * @cmd_id:	Out: FM legacy command ID.
+ */
+static void fm_parse_cmd(u8 *data, u8 *cmd_func, u16 *cmd_id)
+{
+	/* Move past H4-header to start of actual package */
+	struct fm_leg_cmd *pkt = (struct fm_leg_cmd *)(data + HCI_H4_SIZE);
+
+	*cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	*cmd_id   = CG2900_FM_CMD_NONE;
+
+	if (pkt->opcode != CG2900_FM_GEN_ID_LEGACY) {
+		CG2900_ERR("Not an FM legacy command 0x%X", pkt->opcode);
+		return;
+	}
+
+	*cmd_func = pkt->fm_function;
+	CG2900_DBG("cmd_func 0x%X", *cmd_func);
+	if (*cmd_func == CG2900_FM_CMD_PARAM_WRITECOMMAND) {
+		*cmd_id = CG2900_GET_FM_CMD_ID(le16_to_cpu(pkt->fm_cmd.head));
+		CG2900_DBG("cmd_id 0x%X", *cmd_id);
+	}
+}
+
+
+/**
+ * fm_parse_event - Parses a FM event packet
+ * @data:	FM event packet.
+ * @event	Out: FM event.
+ * @cmd_func:	Out: FM legacy command function.
+ * @cmd_id:	Out: FM legacy command ID.
+ * @intr_val:	Out: FM interrupt value.
+ */
+static void fm_parse_event(u8 *data, u8 *event, u8 *cmd_func, u16 *cmd_id,
+			   u16 *intr_val)
+{
+	/* Move past H4-header to start of actual package */
+	union fm_leg_evt_or_irq *pkt =
+		(union fm_leg_evt_or_irq *)(data + HCI_H4_SIZE);
+
+	*cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	*cmd_id = CG2900_FM_CMD_NONE;
+	*intr_val = 0;
+	*event = CG2900_FM_EVENT_UNKNOWN;
+
+	if (pkt->evt.opcode == CG2900_FM_GEN_ID_LEGACY &&
+	    pkt->evt.read_write == CG2900_FM_CMD_LEG_PARAM_WRITE) {
+		/* Command complete */
+		*event = CG2900_FM_EVENT_CMD_COMPLETE;
+		*cmd_func = pkt->evt.fm_function;
+		CG2900_DBG("cmd_func 0x%X", *cmd_func);
+		if (*cmd_func == CG2900_FM_CMD_PARAM_WRITECOMMAND) {
+			*cmd_id = CG2900_GET_FM_CMD_ID(
+				le16_to_cpu(pkt->evt.response_head));
+			CG2900_DBG("cmd_id 0x%X", *cmd_id);
+		}
+	} else if (pkt->irq_v2.opcode == CG2900_FM_GEN_ID_LEGACY &&
+		   pkt->irq_v2.event_type == CG2900_FM_CMD_LEG_PARAM_IRQ) {
+		/* Interrupt, PG2 style */
+		*event = CG2900_FM_EVENT_INTERRUPT;
+		*intr_val = le16_to_cpu(pkt->irq_v2.irq);
+		CG2900_DBG("intr_val 0x%X", *intr_val);
+	} else if (pkt->irq_v1.opcode == CG2900_FM_GEN_ID_LEGACY) {
+		/* Interrupt, PG1 style */
+		*event = CG2900_FM_EVENT_INTERRUPT;
+		*intr_val = le16_to_cpu(pkt->irq_v1.irq);
+		CG2900_DBG("intr_val 0x%X", *intr_val);
+	} else {
+		CG2900_ERR("Not an FM legacy command 0x%X %X %X %X ...",
+			   data[0], data[1], data[2], data[3]);
+	}
+}
+
+/**
+ * fm_update_mode - Updates the FM mode state machine.
+ * @data:	FM command packet.
+ *
+ * Parses a FM command packet and updates the FM mode state machine.
+ */
+static void fm_update_mode(u8 *data)
+{
+	u8 cmd_func;
+	u16 cmd_id;
+
+	fm_parse_cmd(data, &cmd_func, &cmd_id);
+
+	if (cmd_func == CG2900_FM_CMD_PARAM_WRITECOMMAND &&
+	    cmd_id == CG2900_FM_DO_GEN_GOTOMODE) {
+		/* Move past H4-header to start of actual package */
+		struct fm_leg_cmd *pkt =
+			(struct fm_leg_cmd *)(data + HCI_H4_SIZE);
+
+		cg2900_info->fm_radio_mode = le16_to_cpu(pkt->fm_cmd.data[0]);
+		CG2900_INFO("FM Radio mode changed to 0x%x",
+			    cg2900_info->fm_radio_mode);
+	}
+}
+
+
+/**
+ * transmit_skb_from_tx_queue_bt() - Check flow control info and transmit skb.
+ *
+ * The transmit_skb_from_tx_queue_bt() function checks if there are tickets
+ * available and commands waiting in the TX queue and if so transmits them
+ * to the controller.
+ * It shall always be called within spinlock_bh.
+ */
+static void transmit_skb_from_tx_queue_bt(void)
+{
+	struct cg2900_device *dev;
+	struct sk_buff *skb;
+
+	CG2900_INFO("transmit_skb_from_tx_queue_bt");
+
+	/* Dequeue an skb from the head of the list */
+	skb = skb_dequeue(&cg2900_info->tx_queue_bt);
+	while (skb) {
+		if ((cg2900_info->tx_nr_pkts_allowed_bt) <= 0) {
+			/*
+			 * If no more packets allowed just return, we'll get
+			 * back here after next Command Complete/Status event.
+			 * Put skb back at head of queue.
+			 */
+			skb_queue_head(&cg2900_info->tx_queue_bt, skb);
+			return;
+		}
+
+		(cg2900_info->tx_nr_pkts_allowed_bt)--;
+		CG2900_DBG("tx_nr_pkts_allowed_bt = %d",
+			   cg2900_info->tx_nr_pkts_allowed_bt);
+
+		dev = cg2900_skb_data(skb)->dev; /* dev is never NULL */
+
+		/*
+		 * If it's a command from audio application, store the OpCode,
+		 * it'll be used later to decide where to dispatch
+		 * the Command Complete event.
+		 */
+		if (cg2900_get_bt_audio_dev() == dev) {
+			cg2900_info->audio_bt_cmd_op =
+					HCI_BT_GET_ID(skb->data[1],
+							  skb->data[2]);
+			CG2900_DBG("Sending cmd from audio driver, saving "
+				   "OpCode = 0x%X",
+				   cg2900_info->audio_bt_cmd_op);
+		}
+
+		cg2900_send_to_chip(skb, dev->logger_enabled);
+
+		/* Dequeue an skb from the head of the list */
+		skb = skb_dequeue(&cg2900_info->tx_queue_bt);
+	}
+}
+
+/**
+ * transmit_skb_from_tx_queue_fm() - Check flow control info and transmit skb.
+ *
+ * The transmit_skb_from_tx_queue_fm() function checks if it possible to
+ * transmit and commands waiting in the TX queue and if so transmits them
+ * to the controller.
+ * It shall always be called within spinlock_bh.
+ */
+static void transmit_skb_from_tx_queue_fm(void)
+{
+	struct cg2900_device *dev;
+	struct sk_buff *skb;
+
+	CG2900_INFO("transmit_skb_from_tx_queue_fm");
+
+	/* Dequeue an skb from the head of the list */
+	skb = skb_dequeue(&cg2900_info->tx_queue_fm);
+	while (skb) {
+		u16 cmd_id;
+		u8 cmd_func;
+		bool do_transmit = false;
+
+		if (cg2900_info->audio_fm_cmd_id != CG2900_FM_CMD_NONE ||
+		    cg2900_info->hci_fm_cmd_func != CG2900_FM_CMD_PARAM_NONE) {
+			/*
+			 * There are currently outstanding FM commands.
+			 * Wait for them to finish. We will get back here later.
+			 * Queue back the skb at head of list.
+			 */
+			skb_queue_head(&cg2900_info->tx_queue_bt, skb);
+			return;
+		}
+
+		dev = cg2900_skb_data(skb)->dev; /* dev is never NULL */
+
+		fm_parse_cmd(&(skb->data[0]), &cmd_func, &cmd_id);
+
+		/*
+		 * Store the FM command function , it'll be used later to decide
+		 * where to dispatch the Command Complete event.
+		 */
+		if (cg2900_get_fm_audio_dev() == dev) {
+			cg2900_info->audio_fm_cmd_id = cmd_id;
+			CG2900_DBG("audio_fm_cmd_id 0x%X",
+				   cg2900_info->audio_fm_cmd_id);
+			do_transmit = true;
+		}
+		if (cg2900_get_fm_radio_dev() == dev) {
+			cg2900_info->hci_fm_cmd_func = cmd_func;
+			fm_update_mode(&(skb->data[0]));
+			CG2900_DBG("hci_fm_cmd_func 0x%X",
+				   cg2900_info->hci_fm_cmd_func);
+			do_transmit = true;
+		}
+
+		if (do_transmit) {
+			/*
+			 * We have only one ticket on FM. Just return after
+			 * sending the skb.
+			 */
+			cg2900_send_to_chip(skb, dev->logger_enabled);
+			return;
+		}
+
+		/*
+		 * This packet was neither FM or FM audio. That means that
+		 * the user that originally sent it has deregistered.
+		 * Just throw it away and check the next skb in the queue.
+		 */
+		kfree_skb(skb);
+		/* Dequeue an skb from the head of the list */
+		skb = skb_dequeue(&cg2900_info->tx_queue_fm);
+	}
+}
+
+/**
+ * update_flow_ctrl_bt() - Update number of outstanding commands for BT CMD.
+ * @skb:	skb with received packet.
+ *
+ * The update_flow_ctrl_bt() checks if incoming data packet is
+ * BT Command Complete/Command Status Event and if so updates number of tickets
+ * and number of outstanding commands. It also calls function to send queued
+ * commands (if the list of queued commands is not empty).
+ */
+static void update_flow_ctrl_bt(const struct sk_buff * const skb)
+{
+	u8 *data = &(skb->data[CG2900_SKB_RESERVE]);
+	u8 event_code = data[0];
+
+	if (HCI_BT_EVT_CMD_COMPLETE == event_code) {
+		/*
+		 * If it's HCI Command Complete Event then we might get some
+		 * HCI tickets back. Also we can decrease the number outstanding
+		 * HCI commands (if it's not NOP command or one of the commands
+		 * that generate both Command Status Event and Command Complete
+		 * Event).
+		 * Check if we have any HCI commands waiting in the TX list and
+		 * send them if there are tickets available.
+		 */
+		spin_lock_bh(&(cg2900_info->tx_bt_lock));
+		cg2900_info->tx_nr_pkts_allowed_bt =
+				data[HCI_BT_EVT_CMD_COMPL_NR_OF_PKTS_POS];
+		CG2900_DBG("New tx_nr_pkts_allowed_bt = %d",
+			   cg2900_info->tx_nr_pkts_allowed_bt);
+
+		if (!skb_queue_empty(&cg2900_info->tx_queue_bt))
+			transmit_skb_from_tx_queue_bt();
+		spin_unlock_bh(&(cg2900_info->tx_bt_lock));
+	} else if (HCI_BT_EVT_CMD_STATUS == event_code) {
+		/*
+		 * If it's HCI Command Status Event then we might get some
+		 * HCI tickets back. Also we can decrease the number outstanding
+		 * HCI commands (if it's not NOP command).
+		 * Check if we have any HCI commands waiting in the TX queue and
+		 * send them if there are tickets available.
+		 */
+		spin_lock_bh(&(cg2900_info->tx_bt_lock));
+		cg2900_info->tx_nr_pkts_allowed_bt =
+				data[HCI_BT_EVT_CMD_STATUS_NR_OF_PKTS_POS];
+		CG2900_DBG("New tx_nr_pkts_allowed_bt = %d",
+			   cg2900_info->tx_nr_pkts_allowed_bt);
+
+		if (!skb_queue_empty(&cg2900_info->tx_queue_bt))
+			transmit_skb_from_tx_queue_bt();
+		spin_unlock_bh(&(cg2900_info->tx_bt_lock));
+	}
+}
+
+/**
+ * update_flow_ctrl_fm() - Update packets allowed for FM channel.
+ * @skb:	skb with received packet.
+ *
+ * The update_flow_ctrl_fm() checks if incoming data packet is FM packet
+ * indicating that the previous command has been handled and if so update
+ * packets. It also calls function to send queued commands (if the list of
+ * queued commands is not empty).
+ */
+static void update_flow_ctrl_fm(const struct sk_buff * const skb)
+{
+	u8 cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	u16 cmd_id = CG2900_FM_CMD_NONE;
+	u16 irpt_val = 0;
+	u8 event = CG2900_FM_EVENT_UNKNOWN;
+
+	fm_parse_event(&(skb->data[0]), &event, &cmd_func, &cmd_id, &irpt_val);
+
+	if (event == CG2900_FM_EVENT_CMD_COMPLETE) {
+		/* FM legacy command complete event */
+		spin_lock_bh(&(cg2900_info->tx_fm_lock));
+		/*
+		 * Check if it's not an write command complete event, because
+		 * then it cannot be a DO command.
+		 * If it's a write command complete event check that is not a
+		 * DO command complete event before setting the outstanding
+		 * FM packets to none.
+		 */
+		if (cmd_func != CG2900_FM_CMD_PARAM_WRITECOMMAND ||
+		    !fm_irpt_expected(cmd_id)) {
+			cg2900_info->hci_fm_cmd_func = CG2900_FM_CMD_PARAM_NONE;
+			cg2900_info->audio_fm_cmd_id = CG2900_FM_CMD_NONE;
+			CG2900_DBG("FM cmd outstanding cmd func 0x%x",
+				   cg2900_info->hci_fm_cmd_func);
+			CG2900_DBG("FM cmd Audio outstanding cmd id 0x%x",
+				   cg2900_info->audio_fm_cmd_id);
+			transmit_skb_from_tx_queue_fm();
+
+		/*
+		 * If there was a write do command complete event check if it is
+		 * DO command previously sent by the FM audio user. If that's
+		 * the case we need remember that in order to be able to
+		 * dispatch the interrupt to the correct user.
+		 */
+		} else if (cmd_id == cg2900_info->audio_fm_cmd_id) {
+			cg2900_info->tx_fm_audio_awaiting_irpt = true;
+			CG2900_DBG("FM Audio waiting for interrupt = true.");
+		}
+		spin_unlock_bh(&(cg2900_info->tx_fm_lock));
+	} else if (event == CG2900_FM_EVENT_INTERRUPT) {
+		/* FM legacy interrupt */
+		if (fm_is_do_cmd_irpt(irpt_val)) {
+			/*
+			 * If it is an interrupt related to a DO command update
+			 * the outstanding flow control and transmit blocked
+			 * FM commands.
+			 */
+			spin_lock_bh(&(cg2900_info->tx_fm_lock));
+			cg2900_info->hci_fm_cmd_func = CG2900_FM_CMD_PARAM_NONE;
+			cg2900_info->audio_fm_cmd_id = CG2900_FM_CMD_NONE;
+			CG2900_DBG("FM cmd outstanding cmd func 0x%x",
+				   cg2900_info->hci_fm_cmd_func);
+			CG2900_DBG("FM cmd Audio outstanding cmd id 0x%x",
+				   cg2900_info->audio_fm_cmd_id);
+			cg2900_info->tx_fm_audio_awaiting_irpt = false;
+			CG2900_DBG("FM Audio waiting for interrupt = false.");
+			transmit_skb_from_tx_queue_fm();
+			spin_unlock_bh(&(cg2900_info->tx_fm_lock));
+		}
+	}
+}
+
+/**
+ * send_bd_address() - Send HCI VS command with BD address to the chip.
+ */
+static void send_bd_address(void)
+{
+	struct bt_vs_store_in_fs_cmd *cmd;
+	/*
+	 * The '-1' is for the first byte of the data field that's already
+	 * there.
+	 */
+	u8 plen = sizeof(*cmd) + BT_BDADDR_SIZE - 1;
+
+	cmd = kmalloc(plen, GFP_KERNEL);
+	if (!cmd)
+		return;
+
+	cmd->opcode = cpu_to_le16(CG2900_BT_OP_VS_STORE_IN_FS);
+	cmd->plen = BT_PARAM_LEN(plen);
+	cmd->user_id = CG2900_VS_STORE_IN_FS_USR_ID_BD_ADDR;
+	cmd->len = BT_BDADDR_SIZE;
+	/* Now copy the BD address received from user space control app. */
+	memcpy(&(cmd->data), bd_address, BT_BDADDR_SIZE);
+
+	SET_BOOT_STATE(BOOT_SEND_BD_ADDRESS);
+
+	create_and_send_bt_cmd(cmd, plen);
+
+	kfree(cmd);
+}
+
+/**
+ * get_text_line()- Replacement function for stdio function fgets.
+ * @wr_buffer:		Buffer to copy text to.
+ * @max_nbr_of_bytes:	Max number of bytes to read, i.e. size of rd_buffer.
+ * @rd_buffer:		Data to parse.
+ * @bytes_copied:	Number of bytes copied to wr_buffer.
+ *
+ * The get_text_line() function extracts one line of text from input file.
+ *
+ * Returns:
+ *   Pointer to next data to read.
+ */
+static char *get_text_line(char *wr_buffer, int max_nbr_of_bytes,
+			   char *rd_buffer, int *bytes_copied)
+{
+	char *curr_wr = wr_buffer;
+	char *curr_rd = rd_buffer;
+	char in_byte;
+
+	*bytes_copied = 0;
+
+	do {
+		*curr_wr = *curr_rd;
+		in_byte = *curr_wr;
+		curr_wr++;
+		curr_rd++;
+		(*bytes_copied)++;
+	} while ((*bytes_copied <= max_nbr_of_bytes) && (in_byte != '\0') &&
+		 (in_byte != '\n'));
+	*curr_wr = '\0';
+	return curr_rd;
+}
+
+/**
+ * get_file_to_load() - Parse info file and find correct target file.
+ * @fw:		Firmware structure containing file data.
+ * @file_name:	(out) Pointer to name of requested file.
+ *
+ * Returns:
+ *   true,  if target file was found,
+ *   false, otherwise.
+ */
+static bool get_file_to_load(const struct firmware *fw, char **file_name)
+{
+	char *line_buffer;
+	char *curr_file_buffer;
+	int bytes_left_to_parse = fw->size;
+	int bytes_read = 0;
+	bool file_found = false;
+	u32 hci_rev;
+	u32 lmp_sub;
+
+	curr_file_buffer = (char *)&(fw->data[0]);
+
+	line_buffer = kzalloc(LINE_BUFFER_LENGTH, GFP_ATOMIC);
+	if (!line_buffer) {
+		CG2900_ERR("Failed to allocate line_buffer");
+		return false;
+	}
+
+	while (!file_found) {
+		/* Get one line of text from the file to parse */
+		curr_file_buffer = get_text_line(line_buffer,
+					 min(LINE_BUFFER_LENGTH,
+					     (int)(fw->size - bytes_read)),
+					 curr_file_buffer,
+					 &bytes_read);
+
+		bytes_left_to_parse -= bytes_read;
+		if (bytes_left_to_parse <= 0) {
+			/* End of file => Leave while loop */
+			CG2900_ERR("Reached end of file. No file found!");
+			break;
+		}
+
+		/*
+		 * Check if the line of text is a comment or not, comments begin
+		 * with '#'
+		 */
+		if (*line_buffer == '#')
+			continue;
+
+		hci_rev = 0;
+		lmp_sub = 0;
+
+		CG2900_DBG("Found a valid line <%s>", line_buffer);
+
+		/*
+		 * Check if we can find the correct HCI revision and
+		 * LMP subversion as well as a file name in
+		 * the text line.
+		 */
+		if (sscanf(line_buffer, "%x%x%s", &hci_rev, &lmp_sub,
+			   *file_name) == 3
+		    && hci_rev == cg2900_info->chip_dev.chip.hci_revision
+		    && lmp_sub == cg2900_info->chip_dev.chip.hci_sub_version) {
+			CG2900_DBG("File found for chip\n"
+				   "\tFile name = %s\n"
+				   "\tHCI Revision = 0x%X\n"
+				   "\tLMP PAL Subversion = 0x%X",
+				   *file_name, hci_rev, lmp_sub);
+
+			/*
+			 * Name has already been stored above. Nothing more to
+			 * do.
+			 */
+			file_found = true;
+		} else
+			/* Zero the name buffer so it is clear to next read */
+			memset(*file_name, 0x00, FILENAME_MAX + 1);
+	}
+	kfree(line_buffer);
+
+	return file_found;
+}
+
+/**
+ * read_and_send_file_part() - Transmit a part of the supplied file.
+ *
+ * The read_and_send_file_part() function transmit a part of the supplied file
+ * to the controller.
+ * If nothing more to read, set the correct states.
+ */
+static void read_and_send_file_part(void)
+{
+	int bytes_to_copy;
+	struct sk_buff *skb;
+	struct cg2900_hci_logger_config *logger_config;
+	struct bt_vs_write_file_block_cmd *cmd;
+	int plen;
+
+	/*
+	 * Calculate number of bytes to copy;
+	 * either max bytes for HCI packet or number of bytes left in file
+	 */
+	bytes_to_copy = min((int)HCI_BT_SEND_FILE_MAX_CHUNK_SIZE,
+			    (int)(cg2900_info->fw_file->size -
+				  cg2900_info->file_offset));
+
+	if (bytes_to_copy <= 0) {
+		/* Nothing more to read in file. */
+		SET_DOWNLOAD_STATE(DOWNLOAD_SUCCESS);
+		cg2900_info->chunk_id = 0;
+		cg2900_info->file_offset = 0;
+		return;
+	}
+
+	/* There is more data to send */
+	logger_config = cg2900_get_hci_logger_config();
+
+	/*
+	 * There are bytes to transmit. Allocate a sk_buffer.
+	 * When calculating length to alloc the '-1' is because of the first
+	 * byte of the data field that is already defined in the struct.
+	 */
+	plen = sizeof(*cmd) - 1 + bytes_to_copy;
+	skb = cg2900_alloc_skb(plen, GFP_ATOMIC);
+	if (!skb) {
+		CG2900_ERR("Couldn't allocate sk_buffer");
+		SET_BOOT_STATE(BOOT_FAILED);
+		cg2900_chip_startup_finished(-EIO);
+		return;
+	}
+
+	skb_put(skb, plen);
+
+	cmd = (struct bt_vs_write_file_block_cmd *)skb->data;
+	cmd->opcode = cpu_to_le16(CG2900_BT_OP_VS_WRITE_FILE_BLOCK);
+	cmd->plen = BT_PARAM_LEN(plen);
+	cmd->id = cg2900_info->chunk_id;
+	cg2900_info->chunk_id++;
+
+	/* Copy the data from offset position */
+	memcpy(&(cmd->data),
+	       &(cg2900_info->fw_file->data[cg2900_info->file_offset]),
+	       bytes_to_copy);
+
+	/* Increase offset with number of bytes copied */
+	cg2900_info->file_offset += bytes_to_copy;
+
+	skb_push(skb, CG2900_SKB_RESERVE);
+	skb->data[0] = CHANNEL_BT_CMD;
+
+	if (logger_config)
+		cg2900_send_to_chip(skb, logger_config->bt_cmd_enable);
+	else
+		cg2900_send_to_chip(skb, false);
+}
+
+/**
+ * send_settings_file() - Transmit settings file.
+ *
+ * The send_settings_file() function transmit settings file.
+ * The file is read in parts to fit in HCI packets. When finished,
+ * close the settings file and send HCI reset to activate settings and patches.
+ */
+static void send_settings_file(void)
+{
+	/* Transmit a file part */
+	read_and_send_file_part();
+
+	if (cg2900_info->download_state != DOWNLOAD_SUCCESS)
+		return;
+
+	/* Settings file finished. Release used resources */
+	CG2900_DBG("Settings file finished, release used resources");
+	if (cg2900_info->fw_file) {
+		release_firmware(cg2900_info->fw_file);
+		cg2900_info->fw_file = NULL;
+	}
+
+	SET_FILE_LOAD_STATE(FILE_LOAD_NO_MORE_FILES);
+
+	/* Create and send HCI VS Store In FS command with bd address. */
+	send_bd_address();
+}
+
+/**
+ * send_patch_file - Transmit patch file.
+ *
+ * The send_patch_file() function transmit patch file.
+ * The file is read in parts to fit in HCI packets. When the complete file is
+ * transmitted, the file is closed.
+ * When finished, continue with settings file.
+ */
+static void send_patch_file(void)
+{
+	int err;
+
+	/*
+	 * Transmit a part of the supplied file to the controller.
+	 * When nothing more to read, continue to close the patch file.
+	 */
+	read_and_send_file_part();
+
+	if (cg2900_info->download_state != DOWNLOAD_SUCCESS)
+		return;
+
+	/* Patch file finished. Release used resources */
+	CG2900_DBG("Patch file finished, release used resources");
+	if (cg2900_info->fw_file) {
+		release_firmware(cg2900_info->fw_file);
+		cg2900_info->fw_file = NULL;
+	}
+	/* Retrieve the settings file */
+	err = request_firmware(&(cg2900_info->fw_file),
+			       cg2900_info->settings_file_name,
+			       cg2900_info->chip_dev.dev);
+	if (err < 0) {
+		CG2900_ERR("Couldn't get settings file (%d)", err);
+		goto error_handling;
+	}
+	/* Now send the settings file */
+	SET_FILE_LOAD_STATE(FILE_LOAD_GET_STATIC_SETTINGS);
+	SET_DOWNLOAD_STATE(DOWNLOAD_PENDING);
+	send_settings_file();
+	return;
+
+error_handling:
+	SET_BOOT_STATE(BOOT_FAILED);
+	cg2900_chip_startup_finished(err);
+}
+
+/**
+ * work_power_off_chip() - Work item to power off the chip.
+ * @work:	Reference to work data.
+ *
+ * The work_power_off_chip() function handles transmission of the HCI command
+ * vs_power_switch_off and then informs the CG2900 Core that this
chip driver is
+ * finished and the Core driver can now shut off the chip.
+ */
+static void work_power_off_chip(struct work_struct *work)
+{
+	struct sk_buff *skb;
+	u8 *h4_header;
+	struct cg2900_hci_logger_config *logger_config;
+
+	if (!work) {
+		CG2900_ERR("work == NULL");
+		return;
+	}
+
+	/*
+	 * Get the VS Power Switch Off command to use based on connected
+	 * connectivity controller
+	 */
+	skb = cg2900_devices_get_power_switch_off_cmd(NULL);
+
+	/*
+	 * Transmit the received command.
+	 * If no command found for the device, just continue
+	 */
+	if (!skb) {
+		CG2900_ERR("Could not retrieve PowerSwitchOff command");
+		goto shut_down_chip;
+	}
+
+	logger_config = cg2900_get_hci_logger_config();
+
+	CG2900_DBG("Got power_switch_off command. Add H4 header and transmit");
+
+	/*
+	 * Move the data pointer to the H:4 header position and store
+	 * the H4 header
+	 */
+	h4_header = skb_push(skb, CG2900_SKB_RESERVE);
+	*h4_header = CHANNEL_BT_CMD;
+
+	SET_CLOSING_STATE(CLOSING_POWER_SWITCH_OFF);
+
+	if (logger_config)
+		cg2900_send_to_chip(skb, logger_config->bt_cmd_enable);
+	else
+		cg2900_send_to_chip(skb, false);
+
+	/*
+	 * Mandatory to wait 500ms after the power_switch_off command has been
+	 * transmitted, in order to make sure that the controller is ready.
+	 */
+	schedule_timeout_interruptible(msecs_to_jiffies(POWER_SW_OFF_WAIT));
+
+shut_down_chip:
+	SET_CLOSING_STATE(CLOSING_SHUT_DOWN);
+
+	(void)cg2900_chip_shutdown_finished(0);
+
+	kfree(work);
+}
+
+/**
+ * work_reset_after_error() - Handle reset.
+ * @work:	Reference to work data.
+ *
+ * Handle a reset after received Command Complete event.
+ */
+static void work_reset_after_error(struct work_struct *work)
+{
+	if (!work) {
+		CG2900_ERR("work == NULL");
+		return;
+	}
+
+	cg2900_chip_startup_finished(-EIO);
+
+	kfree(work);
+}
+
+/**
+ * work_load_patch_and_settings() - Start loading patches and settings.
+ * @work:	Reference to work data.
+ */
+static void work_load_patch_and_settings(struct work_struct *work)
+{
+	int err = 0;
+	bool file_found;
+	const struct firmware *patch_info;
+	const struct firmware *settings_info;
+
+	if (!work) {
+		CG2900_ERR("work == NULL");
+		return;
+	}
+
+	/* Check that we are in the right state */
+	if (cg2900_info->boot_state != BOOT_GET_FILES_TO_LOAD)
+		goto finished;
+
+	/* Open patch info file. */
+	err = request_firmware(&patch_info, PATCH_INFO_FILE,
+			       cg2900_info->chip_dev.dev);
+	if (err) {
+		CG2900_ERR("Couldn't get patch info file (%d)", err);
+		goto error_handling;
+	}
+
+	/*
+	 * Now we have the patch info file.
+	 * See if we can find the right patch file as well
+	 */
+	file_found = get_file_to_load(patch_info,
+				      &(cg2900_info->patch_file_name));
+
+	/* Now we are finished with the patch info file */
+	release_firmware(patch_info);
+
+	if (!file_found) {
+		CG2900_ERR("Couldn't find patch file! Major error!");
+		goto error_handling;
+	}
+
+	/* Open settings info file. */
+	err = request_firmware(&settings_info,
+			       FACTORY_SETTINGS_INFO_FILE,
+			       cg2900_info->chip_dev.dev);
+	if (err) {
+		CG2900_ERR("Couldn't get settings info file (%d)", err);
+		goto error_handling;
+	}
+
+	/*
+	 * Now we have the settings info file.
+	 * See if we can find the right settings file as well.
+	 */
+	file_found = get_file_to_load(settings_info,
+				      &(cg2900_info->settings_file_name));
+
+	/* Now we are finished with the patch info file */
+	release_firmware(settings_info);
+
+	if (!file_found) {
+		CG2900_ERR("Couldn't find settings file! Major error!");
+		goto error_handling;
+	}
+
+	/* We now all info needed */
+	SET_BOOT_STATE(BOOT_DOWNLOAD_PATCH);
+	SET_DOWNLOAD_STATE(DOWNLOAD_PENDING);
+	SET_FILE_LOAD_STATE(FILE_LOAD_GET_PATCH);
+	cg2900_info->chunk_id = 0;
+	cg2900_info->file_offset = 0;
+	cg2900_info->fw_file = NULL;
+
+	/* OK. Now it is time to download the patches */
+	err = request_firmware(&(cg2900_info->fw_file),
+			       cg2900_info->patch_file_name,
+			       cg2900_info->chip_dev.dev);
+	if (err < 0) {
+		CG2900_ERR("Couldn't get patch file (%d)", err);
+		goto error_handling;
+	}
+	send_patch_file();
+
+	goto finished;
+
+error_handling:
+	SET_BOOT_STATE(BOOT_FAILED);
+	cg2900_chip_startup_finished(-EIO);
+finished:
+	kfree(work);
+}
+
+/**
+ * work_cont_file_download() - A file block has been written.
+ * @work:	Reference to work data.
+ *
+ * Handle a received HCI VS Write File Block Complete event.
+ * Normally this means continue to send files to the controller.
+ */
+static void work_cont_file_download(struct work_struct *work)
+{
+	if (!work) {
+		CG2900_ERR("work == NULL");
+		return;
+	}
+
+	/* Continue to send patches or settings to the controller */
+	if (cg2900_info->file_load_state == FILE_LOAD_GET_PATCH)
+		send_patch_file();
+	else if (cg2900_info->file_load_state == FILE_LOAD_GET_STATIC_SETTINGS)
+		send_settings_file();
+	else
+		CG2900_INFO("No more files to load");
+
+	kfree(work);
+}
+
+/**
+ * handle_reset_cmd_complete() - Handles HCI Reset Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_reset_cmd_complete(u8 *data)
+{
+	u8 status = data[0];
+
+	CG2900_INFO("Received Reset complete event with status 0x%X", status);
+
+	if (CLOSING_RESET != cg2900_info->closing_state)
+		return false;
+
+	if (HCI_BT_ERROR_NO_ERROR != status) {
+		/*
+		 * Continue in case of error, the chip is going to be shut down
+		 * anyway.
+		 */
+		CG2900_ERR("Command complete for HciReset received with "
+			   "error 0x%X !", status);
+	}
+
+	create_work_item(work_power_off_chip);
+
+	return true;
+}
+
+
+/**
+ * handle_vs_store_in_fs_cmd_complete() - Handles HCI VS StoreInFS
Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_store_in_fs_cmd_complete(u8 *data)
+{
+	u8 status = data[0];
+
+	CG2900_INFO("Received Store_in_FS complete event with status 0x%X",
+		    status);
+
+	if (cg2900_info->boot_state != BOOT_SEND_BD_ADDRESS)
+		return false;
+
+	if (HCI_BT_ERROR_NO_ERROR == status) {
+		struct hci_command_hdr cmd;
+
+		/* Send HCI SystemReset command to activate patches */
+		SET_BOOT_STATE(BOOT_ACTIVATE_PATCHES_AND_SETTINGS);
+
+		cmd.opcode = cpu_to_le16(CG2900_BT_OP_VS_SYSTEM_RESET);
+		cmd.plen = 0; /* No parameters for System Reset */
+		create_and_send_bt_cmd(&cmd, sizeof(cmd));
+	} else {
+		CG2900_ERR("Command complete for StoreInFS received with error "
+			   "0x%X", status);
+		SET_BOOT_STATE(BOOT_FAILED);
+		create_work_item(work_reset_after_error);
+	}
+
+	return true;
+}
+
+/**
+ * handle_vs_write_file_block_cmd_complete() - Handles HCI VS
WriteFileBlock Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_write_file_block_cmd_complete(u8 *data)
+{
+	u8 status = data[0];
+
+	if ((cg2900_info->boot_state != BOOT_DOWNLOAD_PATCH) ||
+	    (cg2900_info->download_state != DOWNLOAD_PENDING))
+		return false;
+
+	if (HCI_BT_ERROR_NO_ERROR == status)
+		create_work_item(work_cont_file_download);
+	else {
+		CG2900_ERR("Command complete for WriteFileBlock received with"
+			   " error 0x%X", status);
+		SET_DOWNLOAD_STATE(DOWNLOAD_FAILED);
+		SET_BOOT_STATE(BOOT_FAILED);
+		if (cg2900_info->fw_file) {
+			release_firmware(cg2900_info->fw_file);
+			cg2900_info->fw_file = NULL;
+		}
+		create_work_item(work_reset_after_error);
+	}
+
+	return true;
+}
+
+/**
+ * handle_vs_power_switch_off_cmd_complete() - Handles HCI VS
PowerSwitchOff Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_power_switch_off_cmd_complete(u8 *data)
+{
+	u8 status = data[0];
+
+	if (CLOSING_POWER_SWITCH_OFF != cg2900_info->closing_state)
+		return false;
+
+	/*
+	 * We were waiting for this but we don't need to do anything upon
+	 * reception except warn for error status
+	 */
+	if (HCI_BT_ERROR_NO_ERROR != status)
+		CG2900_ERR("Command Complete for PowerSwitchOff received with "
+			   "error 0x%X", status);
+
+	return true;
+}
+
+/**
+ * handle_vs_system_reset_cmd_complete() - Handle HCI VS SystemReset
Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_system_reset_cmd_complete(u8 *data)
+{
+	u8 status = data[0];
+
+	if (cg2900_info->boot_state != BOOT_ACTIVATE_PATCHES_AND_SETTINGS)
+		return false;
+
+	CG2900_INFO("SYS_CLK_OUT Disabled");
+
+	if (HCI_BT_ERROR_NO_ERROR == status) {
+		/*
+		 * The boot sequence is now finished successfully.
+		 * Set states and signal to waiting thread.
+		 */
+		SET_BOOT_STATE(BOOT_READY);
+		cg2900_chip_startup_finished(0);
+	} else {
+		CG2900_ERR("Received Reset complete event with status 0x%X",
+			   status);
+		SET_BOOT_STATE(BOOT_FAILED);
+		cg2900_chip_startup_finished(-EIO);
+	}
+
+	return true;
+}
+
+/**
+ * handle_rx_data_bt_evt() - Check if received data should be handled
in CG2900 chip driver.
+ * @skb:	Data packet
+ *
+ * The handle_rx_data_bt_evt() function checks if received data should be
+ * handled in CG2900 chip driver. If so handle it correctly.
+ * Received data is always HCI BT Event.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool handle_rx_data_bt_evt(struct sk_buff *skb)
+{
+	bool pkt_handled = false;
+	/* skb cannot be NULL here so it is safe to de-reference */
+	u8 *data = &(skb->data[CG2900_SKB_RESERVE]);
+	struct hci_event_hdr *evt;
+	struct hci_ev_cmd_complete *cmd_complete;
+	u16 op_code;
+
+	evt = (struct hci_event_hdr *)data;
+
+	/* First check the event code. Only handle Command Complete Event */
+	if (HCI_EV_CMD_COMPLETE != evt->evt)
+		return false;
+
+	data += sizeof(*evt);
+	cmd_complete = (struct hci_ev_cmd_complete *)data;
+
+	op_code = le16_to_cpu(cmd_complete->opcode);
+
+	CG2900_DBG_DATA("Received Command Complete: op_code = 0x%04X", op_code);
+	data += sizeof(*cmd_complete); /* Move to first byte after OCF */
+
+	if (op_code == HCI_OP_RESET)
+		pkt_handled = handle_reset_cmd_complete(data);
+	else if (op_code == CG2900_BT_OP_VS_STORE_IN_FS)
+		pkt_handled = handle_vs_store_in_fs_cmd_complete(data);
+	else if (op_code == CG2900_BT_OP_VS_WRITE_FILE_BLOCK)
+		pkt_handled = handle_vs_write_file_block_cmd_complete(data);
+	else if (op_code == CG2900_BT_OP_VS_POWER_SWITCH_OFF)
+		pkt_handled = handle_vs_power_switch_off_cmd_complete(data);
+	else if (op_code == CG2900_BT_OP_VS_SYSTEM_RESET)
+		pkt_handled = handle_vs_system_reset_cmd_complete(data);
+
+	if (pkt_handled)
+		kfree_skb(skb);
+
+	return pkt_handled;
+}
+
+/**
+ * transmit_skb_with_flow_ctrl_bt() - Send the BT skb to the
controller if it is allowed or queue it.
+ * @skb:	Data packet.
+ * @dev:	Pointer to cg2900_device struct.
+ *
+ * The transmit_skb_with_flow_ctrl_bt() function checks if there are
+ * tickets available and if so transmits buffer to controller.
Otherwise the skb
+ * and user name is stored in a list for later sending.
+ * If enabled, copy the transmitted data to the HCI logger as well.
+ */
+static void transmit_skb_with_flow_ctrl_bt(struct sk_buff *skb,
+					   struct cg2900_device *dev)
+{
+	/*
+	 * Because there are more users of some H4 channels (currently audio
+	 * application for BT command and FM channel) we need to have an
+	 * internal HCI command flow control in CG2900 driver.
+	 * So check here how many tickets we have and store skb in a queue if
+	 * there are no tickets left. The skb will be sent later when we get
+	 * more ticket(s).
+	 */
+	spin_lock_bh(&(cg2900_info->tx_bt_lock));
+
+	if ((cg2900_info->tx_nr_pkts_allowed_bt) > 0) {
+		(cg2900_info->tx_nr_pkts_allowed_bt)--;
+		CG2900_DBG("New tx_nr_pkts_allowed_bt = %d",
+			   cg2900_info->tx_nr_pkts_allowed_bt);
+
+		/*
+		 * If it's command from audio app store the OpCode,
+		 * it'll be used later to decide where to dispatch Command
+		 * Complete event.
+		 */
+		if (cg2900_get_bt_audio_dev() == dev) {
+			cg2900_info->audio_bt_cmd_op =
+					HCI_BT_GET_ID(skb->data[1],
+							  skb->data[2]);
+			CG2900_DBG("Sending cmd from audio driver, saving "
+				   "OpCode = 0x%x",
+				   cg2900_info->audio_bt_cmd_op);
+		}
+
+		cg2900_send_to_chip(skb, dev->logger_enabled);
+	} else {
+		CG2900_DBG("Not allowed to send cmd to controller, "
+			    "storing in TX queue.");
+
+		cg2900_skb_data(skb)->dev = dev;
+		skb_queue_tail(&cg2900_info->tx_queue_bt, skb);
+	}
+	spin_unlock_bh(&(cg2900_info->tx_bt_lock));
+}
+
+/**
+ * transmit_skb_with_flow_ctrl_fm() - Send the FM skb to the
controller if it is allowed or queue it.
+ * @skb:	Data packet.
+ * @dev:	Pointer to cg2900_device struct.
+ *
+ * The transmit_skb_with_flow_ctrl_fm() function checks if chip is
available and
+ * if so transmits buffer to controller. Otherwise the skb and user name is
+ * stored in a list for later sending.
+ * Also it updates the FM radio mode if it's FM GOTOMODE command,
this is needed
+ * to know how to handle some FM DO commands complete events.
+ * If enabled, copy the transmitted data to the HCI logger as well.
+ */
+static void transmit_skb_with_flow_ctrl_fm(struct sk_buff *skb,
+					   struct cg2900_device *dev)
+{
+	u8 cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	u16 cmd_id = CG2900_FM_CMD_NONE;
+
+	fm_parse_cmd(&(skb->data[0]), &cmd_func, &cmd_id);
+
+	/*
+	 * If there is an FM IP disable or reset send command and also reset
+	 * the flow control and audio user.
+	 */
+	if (cmd_func == CG2900_FM_CMD_PARAM_DISABLE ||
+	    cmd_func == CG2900_FM_CMD_PARAM_RESET) {
+		spin_lock_bh(&cg2900_info->tx_fm_lock);
+		fm_reset_flow_ctrl();
+		spin_unlock_bh(&cg2900_info->tx_fm_lock);
+		cg2900_send_to_chip(skb, dev->logger_enabled);
+		return;
+	}
+
+	/*
+	 * If there is a FM user and no FM audio user command pending just send
+	 * FM command. It is up to the user of the FM channel to handle its own
+	 * flow control.
+	 */
+	spin_lock_bh(&cg2900_info->tx_fm_lock);
+	if (cg2900_get_fm_radio_dev() == dev &&
+	    cg2900_info->audio_fm_cmd_id == CG2900_FM_CMD_NONE) {
+		cg2900_info->hci_fm_cmd_func = cmd_func;
+		CG2900_DBG("hci_fm_cmd_func 0x%X",
+			   cg2900_info->hci_fm_cmd_func);
+		/* If a GotoMode command update FM mode */
+		fm_update_mode(&(skb->data[0]));
+		cg2900_send_to_chip(skb, dev->logger_enabled);
+	} else if (cg2900_get_fm_audio_dev() == dev &&
+		   cg2900_info->hci_fm_cmd_func == CG2900_FM_CMD_PARAM_NONE &&
+		   cg2900_info->audio_fm_cmd_id == CG2900_FM_CMD_NONE) {
+		/*
+		 * If it's command from fm audio user store the command id.
+		 * It'll be used later to decide where to dispatch
+		 * command complete event.
+		 */
+		cg2900_info->audio_fm_cmd_id = cmd_id;
+		CG2900_DBG("audio_fm_cmd_id 0x%X",
+			   cg2900_info->audio_fm_cmd_id);
+		cg2900_send_to_chip(skb, dev->logger_enabled);
+	} else {
+		CG2900_DBG("Not allowed to send cmd to controller, storing in "
+			   "TX queue");
+
+		cg2900_skb_data(skb)->dev = dev;
+		skb_queue_tail(&cg2900_info->tx_queue_fm, skb);
+	}
+	spin_unlock_bh(&(cg2900_info->tx_fm_lock));
+}
+
+/**
+ * chip_startup() - Start the chip.
+ * @dev:	Chip info.
+ *
+ * The chip_startup() function downloads patches and other needed start
+ * procedures.
+ *
+ * Returns:
+ *   0 if there is no error.
+ */
+static int chip_startup(struct cg2900_chip_dev *dev)
+{
+	/* Start the boot sequence */
+	SET_BOOT_STATE(BOOT_GET_FILES_TO_LOAD);
+	create_work_item(work_load_patch_and_settings);
+
+	return 0;
+}
+
+/**
+ * chip_shutdown() - Shut down the chip.
+ * @dev:	Chip info.
+ *
+ * The chip_shutdown() function shuts down the chip by sending PowerSwitchOff
+ * command.
+ *
+ * Returns:
+ *   0 if there is no error.
+ */
+static int chip_shutdown(struct cg2900_chip_dev *dev)
+{
+	struct hci_command_hdr cmd;
+
+	/*
+	 * Transmit HCI reset command to ensure the chip is using
+	 * the correct transport and to put BT part in reset.
+	 */
+	SET_CLOSING_STATE(CLOSING_RESET);
+	cmd.opcode = cpu_to_le16(HCI_OP_RESET);
+	cmd.plen = 0; /* No parameters for HCI reset */
+	create_and_send_bt_cmd(&cmd, sizeof(cmd));
+
+	return 0;
+}
+
+/**
+ * data_to_chip() - Called when data shall be sent to the chip.
+ * @dev:	Chip info.
+ * @cg2900_dev:	CG2900 user for this packet.
+ * @skb:	Packet to transmit.
+ *
+ * The data_to_chip() function updates flow control and itself
+ * transmits packet to controller if packet is BT command or FM radio.
+ *
+ * Returns:
+ *   true if packet is handled by this driver.
+ *   false otherwise.
+ */
+static bool data_to_chip(struct cg2900_chip_dev *dev,
+			 struct cg2900_device *cg2900_dev,
+			 struct sk_buff *skb)
+{
+	bool packet_handled = false;
+
+	if (cg2900_dev->h4_channel == CHANNEL_BT_CMD) {
+		transmit_skb_with_flow_ctrl_bt(skb, cg2900_dev);
+		packet_handled = true;
+	} else if (cg2900_dev->h4_channel == CHANNEL_FM_RADIO) {
+		transmit_skb_with_flow_ctrl_fm(skb, cg2900_dev);
+		packet_handled = true;
+	}
+
+	return packet_handled;
+}
+
+/**
+ * data_from_chip() - Called when data shall be sent to the chip.
+ * @dev:	Chip info.
+ * @cg2900_dev:	CG2900 user for this packet.
+ * @skb:	Packet received.
+ *
+ * The data_from_chip() function updates flow control and checks
+ * if packet is a response for a packet it itself has transmitted.
+ *
+ * Returns:
+ *   true if packet is handled by this driver.
+ *   false otherwise.
+ */
+static bool data_from_chip(struct cg2900_chip_dev *dev,
+			   struct cg2900_device *cg2900_dev,
+			   struct sk_buff *skb)
+{
+	bool packet_handled;
+	int h4_channel;
+
+	h4_channel = skb->data[0];
+
+	/* First check if we should update flow control */
+	if (h4_channel == CHANNEL_BT_EVT)
+		update_flow_ctrl_bt(skb);
+	else if (h4_channel == CHANNEL_FM_RADIO)
+		update_flow_ctrl_fm(skb);
+
+	/* Then check if this is a response to data we have sent */
+	packet_handled = handle_rx_data_bt_evt(skb);
+
+	return packet_handled;
+}
+
+/**
+ * get_h4_channel() - Returns H:4 channel for the name.
+ * @name:	Chip info.
+ * @h4_channel:	CG2900 user for this packet.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENXIO if channel is not found.
+ */
+static int get_h4_channel(char *name, int *h4_channel)
+{
+	int i;
+	int err = -ENXIO;
+
+	*h4_channel = -1;
+
+	for (i = 0; *h4_channel == -1 && i < ARRAY_SIZE(cg2900_channels); i++) {
+		if (0 == strncmp(name, cg2900_channels[i].name,
+				 CG2900_MAX_NAME_SIZE)) {
+			/* Device found. Return H4 channel */
+			*h4_channel = cg2900_channels[i].h4_channel;
+			err = 0;
+		}
+	}
+
+	return err;
+}
+
+/**
+ * is_bt_audio_user() - Checks if this packet is for the BT audio user.
+ * @h4_channel:	H:4 channel for this packet.
+ * @skb:	Packet to check.
+ *
+ * Returns:
+ *   true if packet is for BT audio user.
+ *   false otherwise.
+ */
+static bool is_bt_audio_user(int h4_channel, const struct sk_buff * const skb)
+{
+	u8 *data = &(skb->data[CG2900_SKB_RESERVE]);
+	u8 event_code = data[0];
+	bool bt_audio = false;
+
+	if (h4_channel == CHANNEL_BT_EVT) {
+		u16 opcode = 0;
+
+		if (HCI_BT_EVT_CMD_COMPLETE == event_code)
+			opcode = HCI_BT_EVENT_GET_ID(data[3], data[4]);
+		else if (HCI_BT_EVT_CMD_STATUS == event_code)
+			opcode = HCI_BT_EVENT_GET_ID(data[4], data[5]);
+
+		if (opcode != 0 && opcode == cg2900_info->audio_bt_cmd_op) {
+			CG2900_DBG("BT OpCode match = 0x%04X", opcode);
+			cg2900_info->audio_bt_cmd_op = CG2900_BT_OPCODE_NONE;
+			bt_audio = true;
+		}
+	}
+
+	return bt_audio;
+}
+
+/**
+ * is_fm_audio_user() - Checks if this packet is for the FM audio user.
+ * @h4_channel:	H:4 channel for this packet.
+ * @skb:	Packet to check.
+ *
+ * Returns:
+ *   true if packet is for BT audio user.
+ *   false otherwise.
+ */
+static bool is_fm_audio_user(int h4_channel, const struct sk_buff * const skb)
+{
+	u8 cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	u16 cmd_id = CG2900_FM_CMD_NONE;
+	u16 irpt_val = 0;
+	u8 event = CG2900_FM_EVENT_UNKNOWN;
+	bool bt_audio = false;
+
+	fm_parse_event(&(skb->data[0]), &event, &cmd_func, &cmd_id, &irpt_val);
+
+	if (h4_channel == CHANNEL_FM_RADIO) {
+		/* Check if command complete event FM legacy interface. */
+		if ((event == CG2900_FM_EVENT_CMD_COMPLETE) &&
+		    (cmd_func == CG2900_FM_CMD_PARAM_WRITECOMMAND) &&
+		    (cmd_id == cg2900_info->audio_fm_cmd_id)) {
+			CG2900_DBG("FM Audio Function Code match = 0x%04X",
+				   cmd_id);
+			bt_audio = true;
+			goto finished;
+		}
+
+		/* Check if Interrupt legacy interface. */
+		if ((event == CG2900_FM_EVENT_INTERRUPT) &&
+		    (fm_is_do_cmd_irpt(irpt_val)) &&
+		    (cg2900_info->tx_fm_audio_awaiting_irpt))
+			bt_audio = true;
+	}
+
+finished:
+	return bt_audio;
+}
+
+/**
+ * last_bt_user_removed() - Called when last BT user is removed.
+ * @dev:	Chip handler info.
+ *
+ * Clears out TX queue for BT.
+ */
+static void last_bt_user_removed(struct cg2900_chip_dev *dev)
+{
+	spin_lock_bh(&cg2900_info->tx_bt_lock);
+
+	skb_queue_purge(&cg2900_info->tx_queue_bt);
+
+	/*
+	 * Reset number of packets allowed and number of outstanding
+	 * BT commands.
+	 */
+	cg2900_info->tx_nr_pkts_allowed_bt = 1;
+	/* Reset the audio_bt_cmd_op. */
+	cg2900_info->audio_bt_cmd_op = CG2900_BT_OPCODE_NONE;
+	spin_unlock_bh(&cg2900_info->tx_bt_lock);
+}
+
+/**
+ * last_fm_user_removed() - Called when last FM user is removed.
+ * @dev:	Chip handler info.
+ *
+ * Clears out TX queue for BT.
+ */
+static void last_fm_user_removed(struct cg2900_chip_dev *dev)
+{
+	spin_lock_bh(&cg2900_info->tx_fm_lock);
+	fm_reset_flow_ctrl();
+	spin_unlock_bh(&cg2900_info->tx_fm_lock);
+}
+
+/**
+ * check_chip_support() - Checks if connected chip is handled by this driver.
+ * @dev:	Chip info structure.
+ *
+ * If supported return true and fill in @callbacks.
+ *
+ * Returns:
+ *   true if chip is handled by this driver.
+ *   false otherwise.
+ */
+static bool check_chip_support(struct cg2900_chip_dev *dev)
+{
+	CG2900_INFO("CG2900: check_chip_support");
+
+	/*
+	 * Check if this is a CG2900 revision.
+	 * We do not care about the sub-version at the moment. Change this if
+	 * necessary.
+	 */
+	if ((dev->chip.manufacturer != CG2900_SUPP_MANUFACTURER) ||
+	    (dev->chip.hci_revision != CG2900_PG1_SPECIAL_REV &&
+	     (dev->chip.hci_revision < CG2900_SUPP_REVISION_MIN ||
+	      dev->chip.hci_revision > CG2900_SUPP_REVISION_MAX))) {
+		CG2900_DBG("Chip not supported by CG2900 driver\n"
+			   "\tMan: 0x%02X\n\tRev: 0x%04X\n\tSub: 0x%04X",
+			   dev->chip.manufacturer, dev->chip.hci_revision,
+			   dev->chip.hci_sub_version);
+		return false;
+	}
+
+	CG2900_INFO("Chip supported by the CG2900 driver");
+	/* Store needed data */
+	dev->user_data = cg2900_info;
+	memcpy(&(cg2900_info->chip_dev), dev, sizeof(*dev));
+	/* Set the callbacks */
+	dev->cb.chip_shutdown = chip_shutdown;
+	dev->cb.chip_startup = chip_startup;
+	dev->cb.data_from_chip = data_from_chip;
+	dev->cb.data_to_chip = data_to_chip;
+	dev->cb.get_h4_channel = get_h4_channel;
+	dev->cb.is_bt_audio_user = is_bt_audio_user;
+	dev->cb.is_fm_audio_user = is_fm_audio_user;
+	dev->cb.last_bt_user_removed = last_bt_user_removed;
+	dev->cb.last_fm_user_removed = last_fm_user_removed;
+
+	return true;
+}
+
+static struct cg2900_id_callbacks chip_support_callbacks = {
+	.check_chip_support = check_chip_support
+};
+
+/**
+ * cg2900_init() - Initialize module.
+ *
+ * The cg2900_init() function initializes the CG2900 driver,
+ * then registers to the CG2900 Core.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM for failed alloc or structure creation.
+ *   Error codes generated by cg2900_register_chip_driver.
+ */
+static int __init cg2900_init(void)
+{
+	int err = 0;
+
+	CG2900_INFO("cg2900_init");
+
+	cg2900_info = kzalloc(sizeof(*cg2900_info), GFP_ATOMIC);
+	if (!cg2900_info) {
+		CG2900_ERR("Couldn't allocate cg2900_info");
+		err = -ENOMEM;
+		goto finished;
+	}
+
+	/*
+	 * Initialize linked lists for HCI BT and FM commands
+	 * that can't be sent due to internal CG2900 flow control.
+	 */
+	skb_queue_head_init(&cg2900_info->tx_queue_bt);
+	skb_queue_head_init(&cg2900_info->tx_queue_fm);
+
+	/* Initialize the spin locks */
+	spin_lock_init(&(cg2900_info->tx_bt_lock));
+	spin_lock_init(&(cg2900_info->tx_fm_lock));
+
+	cg2900_info->tx_nr_pkts_allowed_bt = 1;
+	cg2900_info->audio_bt_cmd_op = CG2900_BT_OPCODE_NONE;
+	cg2900_info->audio_fm_cmd_id = CG2900_FM_CMD_NONE;
+	cg2900_info->hci_fm_cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	cg2900_info->fm_radio_mode = FM_RADIO_MODE_IDLE;
+
+	cg2900_info->wq = create_singlethread_workqueue(WQ_NAME);
+	if (!cg2900_info->wq) {
+		CG2900_ERR("Could not create workqueue");
+		err = -ENOMEM;
+		goto err_handling_free_info;
+	}
+
+	/* Allocate file names that will be used, deallocated in cg2900_exit */
+	cg2900_info->patch_file_name = kzalloc(FILENAME_MAX + 1, GFP_ATOMIC);
+	if (!cg2900_info->patch_file_name) {
+		CG2900_ERR("Couldn't allocate name buffer for patch file.");
+		err = -ENOMEM;
+		goto err_handling_destroy_wq;
+	}
+	/* Allocate file names that will be used, deallocated in cg2900_exit */
+	cg2900_info->settings_file_name = kzalloc(FILENAME_MAX + 1, GFP_ATOMIC);
+	if (!cg2900_info->settings_file_name) {
+		CG2900_ERR("Couldn't allocate name buffers settings file.");
+		err = -ENOMEM;
+		goto err_handling_free_patch_name;
+	}
+
+	err = cg2900_register_chip_driver(&chip_support_callbacks);
+	if (err) {
+		CG2900_ERR("Couldn't register chip driver (%d)", err);
+		goto err_handling_free_settings_name;
+	}
+
+	goto finished;
+
+err_handling_free_settings_name:
+	kfree(cg2900_info->settings_file_name);
+err_handling_free_patch_name:
+	kfree(cg2900_info->patch_file_name);
+err_handling_destroy_wq:
+	destroy_workqueue(cg2900_info->wq);
+err_handling_free_info:
+	kfree(cg2900_info);
+	cg2900_info = NULL;
+finished:
+	return err;
+}
+
+/**
+ * cg2900_exit() - Remove module.
+ */
+static void __exit cg2900_exit(void)
+{
+	CG2900_INFO("cg2900_exit");
+
+	if (!cg2900_info)
+		return;
+
+	kfree(cg2900_info->settings_file_name);
+	kfree(cg2900_info->patch_file_name);
+	destroy_workqueue(cg2900_info->wq);
+	kfree(cg2900_info);
+	cg2900_info = NULL;
+}
+
+module_init(cg2900_init);
+module_exit(cg2900_exit);
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Linux CG2900 Connectivity Device Driver");
diff --git a/drivers/mfd/cg2900/cg2900_chip.h b/drivers/mfd/cg2900/cg2900_chip.h
new file mode 100644
index 0000000..973e305
--- /dev/null
+++ b/drivers/mfd/cg2900/cg2900_chip.h
@@ -0,0 +1,421 @@
+/*
+ * drivers/mfd/cg2900/cg2900_chip.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+
+#ifndef _CG2900_CHIP_H_
+#define _CG2900_CHIP_H_
+
+#include "hci_defines.h"
+
+/* Supported chips */
+#define CG2900_SUPP_MANUFACTURER			0x30
+#define CG2900_SUPP_REVISION_MIN			0x0100
+#define CG2900_SUPP_REVISION_MAX			0x0200
+
+/* Specific chip version data */
+#define CG2900_PG1_REV					0x0101
+#define CG2900_PG2_REV					0x0200
+#define CG2900_PG1_SPECIAL_REV				0x0700
+
+/*
+ *	Bluetooth
+ */
+
+#define BT_SIZE_OF_HDR				(sizeof(__le16) + sizeof(__u8))
+#define BT_PARAM_LEN(__pkt_len)			(__pkt_len - BT_SIZE_OF_HDR)
+
+/* BT VS Store In FS command */
+#define CG2900_BT_OP_VS_STORE_IN_FS			0xFC22
+struct bt_vs_store_in_fs_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	user_id;
+	__u8	len;
+	__u8	data; /* Really a data array of variable size */
+} __attribute__((packed));
+
+/* BT VS Write File Block command */
+#define CG2900_BT_OP_VS_WRITE_FILE_BLOCK		0xFC2E
+struct bt_vs_write_file_block_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	id;
+	__u8	data; /* Really a data array of variable size */
+} __attribute__((packed));
+
+/* Bluetooth Vendor Specific Opcodes */
+#define CG2900_BT_OP_VS_POWER_SWITCH_OFF		0xFD40
+#define CG2900_BT_OP_VS_SYSTEM_RESET			0xFF12
+
+#define CG2900_BT_OPCODE_NONE				0xFFFF
+
+/* BT HCI VS command op codes in LSB-MSB format */
+#define CG2900_BT_VS_SET_HARDWARE_CONFIG_LSB		0x54
+#define CG2900_BT_VS_SET_HARDWARE_CONFIG_MSB		0xFD
+#define CG2900_BT_VS_SET_SESSION_CONFIG_LSB		0x55
+#define CG2900_BT_VS_SET_SESSION_CONFIG_MSB		0xFD
+#define CG2900_BT_VS_SESSION_CTRL_LSB			0x57
+#define CG2900_BT_VS_SESSION_CTRL_MSB			0xFD
+#define CG2900_BT_VS_RESET_SESSION_CONFIG_LSB		0x56
+#define CG2900_BT_VS_RESET_SESSION_CONFIG_MSB		0xFD
+
+/* Defines needed for HCI VS Store In FS cmd creation. */
+#define CG2900_VS_STORE_IN_FS_USR_ID_POS		HCI_BT_CMD_PARAM_POS
+#define CG2900_VS_STORE_IN_FS_USR_ID_SIZE		1
+#define CG2900_VS_STORE_IN_FS_PARAM_LEN_POS		\
+	(CG2900_VS_STORE_IN_FS_USR_ID_POS + CG2900_VS_STORE_IN_FS_USR_ID_SIZE)
+#define CG2900_VS_STORE_IN_FS_PARAM_LEN_SIZE		1
+#define CG2900_VS_STORE_IN_FS_PARAM_POS			\
+	(CG2900_VS_STORE_IN_FS_PARAM_LEN_POS + \
+	CG2900_VS_STORE_IN_FS_PARAM_LEN_SIZE)
+#define CG2900_VS_STORE_IN_FS_USR_ID_BD_ADDR		0xFE
+
+/* BT HCI Command parameters */
+
+/* VS_Set_Hardware_configuration I2S WS Sel param */
+#define CG2900_BT_HW_CONFIG_I2S_WS_SEL_MASTER		0x00
+#define CG2900_BT_HW_CONFIG_I2S_WS_SEL_SLAVE		0x01
+
+/* VS_Set_Hardware_configuration PCM Mode param */
+#define CG2900_BT_HW_CONFIG_PCM_MODE_SLAVE		0x00
+#define CG2900_BT_HW_CONFIG_PCM_MODE_MASTER		0x01
+
+/* VS_Session_Control SessionControl param */
+#define CG2900_BT_SESSION_START				0x00
+#define CG2900_BT_SESSION_STOP				0x01
+#define CG2900_BT_SESSION_PAUSE				0x02
+#define CG2900_BT_SESSION_RESUME			0x03
+
+/* VS_Session_Configuration MediaType param */
+#define CG2900_BT_SESSION_MEDIA_TYPE_AUDIO		0x00
+
+/* VS_Session_Configuration MediaConfiguration param */
+#define CG2900_BT_MEDIA_CONFIG_MONO			0x00
+#define CG2900_BT_MEDIA_CONFIG_STEREO			0x01
+#define CG2900_BT_MEDIA_CONFIG_JOINT_STEREO		0x02
+#define CG2900_BT_MEDIA_CONFIG_DUAL_CHANNEL		0x03
+
+/* VS_Session_Configuration VP Type param */
+#define CG2900_BT_VP_TYPE_PCM				0x00
+#define CG2900_BT_VP_TYPE_I2S				0x01
+#define CG2900_BT_VP_TYPE_SLIMBUS			0x02
+#define CG2900_BT_VP_TYPE_FM				0x03
+#define CG2900_BT_VP_TYPE_BT_SCO			0x04
+#define CG2900_BT_VP_TYPE_BT_A2DP			0x05
+#define CG2900_BT_VP_TYPE_ANALOG			0x07
+
+/* VS_Session_Configuration I2S Index param */
+#define CG2900_BT_SESSION_I2S_INDEX_I2S			0x00
+#define CG2900_BT_SESSION_I2S_INDEX_PCM_I2S		0x01
+
+/* VS_Session_Configuration PCM Index param */
+#define CG2900_BT_SESSION_PCM_INDEX_PCM_I2S		0x00
+
+/* VS_Set_Hardware_Configuration Macros */
+#define CG2900_BT_HW_CONFIG_PCM_SET_DIR(__slot, __val)	(__val << (__slot + 4))
+#define CG2900_BT_HW_CONFIG_PCM_SET_MODE(__mode)	(__mode << 1)
+
+/* VS_Session_Configuration Macros */
+#define CG2900_BT_SESSION_CONF_SET_SAMPLE_RATE(__rate)	(__rate << 4)
+#define CG2900_BT_SESSION_CONF_SET_PCM_SLOT_USE(__slot)	(0x01 << __slot)
+
+/* BT command lengths. Header is always first 3 bytes */
+#define CG2900_BT_LEN_VS_SET_HARDWARE_CONFIG		10
+#define CG2900_BT_LEN_VS_SET_SESSION_CONFIG		37
+#define CG2900_BT_LEN_VS_SESSION_CTRL			5
+#define CG2900_BT_LEN_VS_RESET_SESSION_CONFIG		4
+
+/*
+ * BT command parameter lengths, i.e. command length minus header length
+ * (3 bytes).
+ */
+#define CG2900_BT_PARAM_LEN_VS_SET_SESSION_CONFIG	\
+	(CG2900_BT_LEN_VS_SET_SESSION_CONFIG - 3)
+#define CG2900_BT_PARAM_LEN_VS_SESSION_CTRL		\
+	(CG2900_BT_LEN_VS_SESSION_CTRL - 3)
+
+/* BT parameter lengths */
+#define CG2900_BT_PARAM_LEN_SESSION_ID			1
+
+/*
+ *	FM
+ */
+
+/* FM legacy command packet */
+struct fm_leg_cmd {
+	__u8	length;
+	__u8	opcode;
+	__u8	read_write;
+	__u8	fm_function;
+	union { /* Payload varies with function */
+		__le16	irqmask;
+		struct fm_leg_fm_cmd {
+			__le16	head;
+			__le16	data[];
+		} fm_cmd;
+	};
+} __attribute__((packed));
+
+/* FM legacy command complete packet */
+struct fm_leg_cmd_cmpl {
+	__u8	param_length;
+	__u8	status;
+	__u8	opcode;
+	__u8	read_write;
+	__u8	cmd_status;
+	__u8	fm_function;
+	__le16	response_head;
+	__le16	data[];
+} __attribute__((packed));
+
+/* FM legacy interrupt packet, PG2 style */
+struct fm_leg_irq_v2 {
+	__u8	param_length;
+	__u8	status;
+	__u8	opcode;
+	__u8	event_type;
+	__u8	event_id;
+	__le16	irq;
+} __attribute__((packed));
+
+/* FM legacy interrupt packet, PG1 style */
+struct fm_leg_irq_v1 {
+	__u8	param_length;
+	__u8	opcode;
+	__u8	event_id;
+	__le16	irq;
+} __attribute__((packed));
+
+union fm_leg_evt_or_irq {
+	__u8			param_length;
+	struct fm_leg_cmd_cmpl	evt;
+	struct fm_leg_irq_v2	irq_v2;
+	struct fm_leg_irq_v1	irq_v1;
+} __attribute__((packed));
+
+/* FM Opcode generic*/
+#define CG2900_FM_GEN_ID_LEGACY				0xFE
+
+/* FM Opcode offset generic*/
+#define CG2900_FM_GEN_ID_POS_CMD			2
+#define CG2900_FM_GEN_ID_POS_CMD_CMPL			3
+#define CG2900_FM_GEN_ID_POS_INTERRUPT			2
+
+/* FM Opcode offset legacy */
+#define CG2900_FM_LEG_STATUS_POS_CMD_CMPL		5
+#define CG2900_FM_LEG_FUNC_POS_CMD_CMPL			6
+#define CG2900_FM_LEG_HDR_POS_CMD_CMPL			7
+
+/* FM event*/
+#define CG2900_FM_EVENT_UNKNOWN				0
+#define CG2900_FM_EVENT_CMD_COMPLETE			1
+#define CG2900_FM_EVENT_INTERRUPT			2
+
+/* FM do-command identifiers. */
+#define CG2900_FM_DO_AIP_FADE_START			0x0046
+#define CG2900_FM_DO_AUP_BT_FADE_START			0x01C2
+#define CG2900_FM_DO_AUP_EXT_FADE_START			0x0102
+#define CG2900_FM_DO_AUP_FADE_START			0x00A2
+#define CG2900_FM_DO_FMR_SETANTENNA			0x0663
+#define CG2900_FM_DO_FMR_SP_AFSWITCH_START		0x04A3
+#define CG2900_FM_DO_FMR_SP_AFUPDATE_START		0x0463
+#define CG2900_FM_DO_FMR_SP_BLOCKSCAN_START		0x0683
+#define CG2900_FM_DO_FMR_SP_PRESETPI_START		0x0443
+#define CG2900_FM_DO_FMR_SP_SCAN_START			0x0403
+#define CG2900_FM_DO_FMR_SP_SEARCH_START		0x03E3
+#define CG2900_FM_DO_FMR_SP_SEARCHPI_START		0x0703
+#define CG2900_FM_DO_FMR_SP_TUNE_SETCHANNEL		0x03C3
+#define CG2900_FM_DO_FMR_SP_TUNE_STEPCHANNEL		0x04C3
+#define CG2900_FM_DO_FMT_PA_SETCTRL			0x01A4
+#define CG2900_FM_DO_FMT_PA_SETMODE			0x01E4
+#define CG2900_FM_DO_FMT_SP_TUNE_SETCHANNEL		0x0064
+#define CG2900_FM_DO_GEN_ANTENNACHECK_START		0x02A1
+#define CG2900_FM_DO_GEN_GOTOMODE			0x0041
+#define CG2900_FM_DO_GEN_POWERSUPPLY_SETMODE		0x0221
+#define CG2900_FM_DO_GEN_SELECTREFERENCECLOCK		0x0201
+#define CG2900_FM_DO_GEN_SETPROCESSINGCLOCK		0x0241
+#define CG2900_FM_DO_GEN_SETREFERENCECLOCKPLL		0x01A1
+#define CG2900_FM_DO_TST_TX_RAMP_START			0x0147
+#define CG2900_FM_CMD_NONE				0xFFFF
+#define CG2900_FM_CMD_ID_GEN_GOTO_POWER_DOWN		0x0081
+#define CG2900_FM_CMD_ID_GEN_GOTO_STANDBY		0x0061
+
+/* FM Command IDs */
+#define CG2900_FM_CMD_ID_AUP_EXT_SET_MODE		0x0162
+#define CG2900_FM_CMD_ID_AUP_EXT_SET_CTRL		0x0182
+#define CG2900_FM_CMD_ID_AIP_SET_MODE			0x01C6
+#define CG2900_FM_CMD_ID_AIP_BT_SET_CTRL		0x01A6
+#define CG2900_FM_CMD_ID_AIP_BT_SET_MODE		0x01E6
+
+/* FM Command Parameters. */
+#define CG2900_FM_CMD_PARAM_ENABLE			0x00
+#define CG2900_FM_CMD_PARAM_DISABLE			0x01
+#define CG2900_FM_CMD_PARAM_RESET			0x02
+#define CG2900_FM_CMD_PARAM_WRITECOMMAND		0x10
+#define CG2900_FM_CMD_PARAM_SET_INT_MASK_ALL		0x20
+#define CG2900_FM_CMD_PARAM_GET_INT_MASK_ALL		0x21
+#define CG2900_FM_CMD_PARAM_SET_INT_MASK		0x22
+#define CG2900_FM_CMD_PARAM_GET_INT_MASK		0x23
+#define CG2900_FM_CMD_PARAM_FM_FW_DOWNLOAD		0x30
+#define CG2900_FM_CMD_PARAM_NONE			0xFF
+
+/* FM Legacy Command Parameters */
+#define CG2900_FM_CMD_LEG_PARAM_WRITE			0x00
+#define CG2900_FM_CMD_LEG_PARAM_IRQ			0x01
+
+/* FM Command Status. */
+#define CG2900_FM_CMD_STATUS_COMMAND_SUCCEEDED		0x00
+#define CG2900_FM_CMD_STATUS_HW_FAILURE			0x03
+#define CG2900_FM_CMD_STATUS_INVALID_PARAMS		0x12
+#define CG2900_FM_CMD_STATUS_UNINITILIZED		0x15
+#define CG2900_FM_CMD_STATUS_UNSPECIFIED_ERROR		0x1F
+#define CG2900_FM_CMD_STATUS_COMMAND_DISALLOWED		0x0C
+#define CG2900_FM_CMD_STATUS_FW_WRONG_SEQUENCE_NR	0xF1
+#define CG2900_FM_CMD_STATUS_FW_UNKNOWN_FILE		0xF2
+#define CG2900_FM_CMD_STATUS_FW_FILE_VER_MISMATCH	0xF3
+
+/* FM Interrupts. */
+#define CG2900_FM_IRPT_FIQ				0x0000
+#define CG2900_FM_IRPT_OPERATION_SUCCEEDED		0x0001
+#define CG2900_FM_IRPT_OPERATION_FAILED			0x0002
+#define CG2900_FM_IRPT_BUFFER_FULL			0x0008
+#define CG2900_FM_IRPT_BUFFER_EMPTY			0x0008
+#define CG2900_FM_IRPT_SIGNAL_QUALITY_LOW		0x0010
+#define CG2900_FM_IRPT_MUTE_STATUS_CHANGED		0x0010
+#define CG2900_FM_IRPT_MONO_STEREO_TRANSITION		0x0020
+#define CG2900_FM_IRPT_OVER_MODULATION			0x0020
+#define CG2900_FM_IRPT_RDS_SYNC_FOUND			0x0040
+#define CG2900_FM_IRPT_INPUT_OVERDRIVE			0x0040
+#define CG2900_FM_IRPT_RDS_SYNC_LOST			0x0080
+#define CG2900_FM_IRPT_PI_CODE_CHANGED			0x0100
+#define CG2900_FM_IRPT_REQUEST_BLOCK_AVALIBLE		0x0200
+#define CG2900_FM_IRPT_BUFFER_CLEARED			0x2000
+#define CG2900_FM_IRPT_WARM_BOOT_READY			0x4000
+#define CG2900_FM_IRPT_COLD_BOOT_READY			0x8000
+
+/* FM Legacy Function Command Parameters */
+
+/* AUP_EXT_SetMode Output enum */
+#define CG2900_FM_CMD_AUP_EXT_SET_MODE_DISABLED		0x0000
+#define CG2900_FM_CMD_AUP_EXT_SET_MODE_I2S		0x0001
+#define CG2900_FM_CMD_AUP_EXT_SET_MODE_PARALLEL		0x0002
+
+/* SetControl Conversion enum */
+#define CG2900_FM_CMD_SET_CTRL_CONV_UP			0x0000
+#define CG2900_FM_CMD_SET_CTRL_CONV_DOWN		0x0001
+
+/* AIP_SetMode Input enum */
+#define CG2900_FM_CMD_AIP_SET_MODE_INPUT_ANA		0x0000
+#define CG2900_FM_CMD_AIP_SET_MODE_INPUT_DIG		0x0001
+
+/* AIP_BT_SetMode Input enum */
+#define CG2900_FM_CMD_AIP_BT_SET_MODE_INPUT_RESERVED	0x0000
+#define CG2900_FM_CMD_AIP_BT_SET_MODE_INPUT_I2S		0x0001
+#define CG2900_FM_CMD_AIP_BT_SET_MODE_INPUT_PAR		0x0002
+#define CG2900_FM_CMD_AIP_BT_SET_MODE_INPUT_FIFO	0x0003
+
+/* FM Lengths */
+#define CG2900_FM_CMD_LEN_AUP_EXT_SET_MODE		8
+#define CG2900_FM_CMD_LEN_AUP_EXT_SET_CTRL		8
+#define CG2900_FM_CMD_LEN_AIP_SET_MODE			8
+#define CG2900_FM_CMD_LEN_AIP_BT_SET_CTRL		8
+#define CG2900_FM_CMD_LEN_AIP_BT_SET_MODE		8
+
+/* FM Parameter Lengths = FM command length - length field (1 byte) */
+#define CG2900_FM_CMD_PARAM_LEN_AUP_EXT_SET_MODE	\
+	(CG2900_FM_CMD_LEN_AUP_EXT_SET_MODE - 1)
+#define CG2900_FM_CMD_PARAM_LEN_AUP_EXT_SET_CTRL	\
+	(CG2900_FM_CMD_LEN_AUP_EXT_SET_CTRL - 1)
+#define CG2900_FM_CMD_PARAM_LEN_AIP_SET_MODE		\
+	(CG2900_FM_CMD_LEN_AIP_SET_MODE - 1)
+#define CG2900_FM_CMD_PARAM_LEN_AIP_BT_SET_CTRL		\
+	(CG2900_FM_CMD_LEN_AIP_BT_SET_CTRL - 1)
+#define CG2900_FM_CMD_PARAM_LEN_AIP_BT_SET_MODE		\
+	(CG2900_FM_CMD_LEN_AIP_BT_SET_MODE - 1)
+
+/*
+ * Following defines should be used by users of CG2900 Core, i.e. having no
+ * H:4 header.
+ */
+#define CG2900_FM_USER_GEN_ID_POS_CMD_CMPL			\
+	(CG2900_FM_GEN_ID_POS_CMD_CMPL - HCI_H4_SIZE)
+#define CG2900_FM_USER_LEG_STATUS_POS_CMD_CMPL		\
+	(CG2900_FM_LEG_STATUS_POS_CMD_CMPL - HCI_H4_SIZE)
+#define CG2900_FM_USER_LEG_FUNC_POS_CMD_CMPL			\
+	(CG2900_FM_LEG_FUNC_POS_CMD_CMPL - HCI_H4_SIZE)
+#define CG2900_FM_USER_LEG_HDR_POS_CMD_CMPL			\
+	(CG2900_FM_LEG_HDR_POS_CMD_CMPL - HCI_H4_SIZE)
+
+/*
+ * FM Command ID mapped per byte and shifted 3 bits left
+ * Also adds number of parameters at first 3 bits of LSB.
+ */
+#define CG2900_SET_FM_CMD_ID_LSB(__u16_id, __n_data)	\
+	((u8)(((__u16_id << 3) & 0x00FF) | __n_data))
+#define CG2900_SET_FM_CMD_ID_MSB(__u16_id)		((u8)(__u16_id >> 5))
+#define CG2900_GET_FM_CMD_ID(__u16_arg) (__u16_arg >> 3)
+
+#define CG2900_FM_CMD_ID_AUP_EXT_SET_MODE_LSB		\
+	CG2900_SET_FM_CMD_ID_LSB(CG2900_FM_CMD_ID_AUP_EXT_SET_MODE, 1)
+#define CG2900_FM_CMD_ID_AUP_EXT_SET_MODE_MSB		\
+	CG2900_SET_FM_CMD_ID_MSB(CG2900_FM_CMD_ID_AUP_EXT_SET_MODE)
+#define CG2900_FM_CMD_ID_AUP_EXT_SET_CTRL_LSB		\
+	CG2900_SET_FM_CMD_ID_LSB(CG2900_FM_CMD_ID_AUP_EXT_SET_CTRL, 1)
+#define CG2900_FM_CMD_ID_AUP_EXT_SET_CTRL_MSB		\
+	CG2900_SET_FM_CMD_ID_MSB(CG2900_FM_CMD_ID_AUP_EXT_SET_CTRL)
+#define CG2900_FM_CMD_ID_AIP_SET_MODE_LSB		\
+	CG2900_SET_FM_CMD_ID_LSB(CG2900_FM_CMD_ID_AIP_SET_MODE, 1)
+#define CG2900_FM_CMD_ID_AIP_SET_MODE_MSB		\
+	CG2900_SET_FM_CMD_ID_MSB(CG2900_FM_CMD_ID_AIP_SET_MODE)
+#define CG2900_FM_CMD_ID_AIP_BT_SET_CTRL_LSB		\
+	CG2900_SET_FM_CMD_ID_LSB(CG2900_FM_CMD_ID_AIP_BT_SET_CTRL, 1)
+#define CG2900_FM_CMD_ID_AIP_BT_SET_CTRL_MSB		\
+	CG2900_SET_FM_CMD_ID_MSB(CG2900_FM_CMD_ID_AIP_BT_SET_CTRL)
+#define CG2900_FM_CMD_ID_AIP_BT_SET_MODE_LSB		\
+	CG2900_SET_FM_CMD_ID_LSB(CG2900_FM_CMD_ID_AIP_BT_SET_MODE, 1)
+#define CG2900_FM_CMD_ID_AIP_BT_SET_MODE_MSB		\
+	CG2900_SET_FM_CMD_ID_MSB(CG2900_FM_CMD_ID_AIP_BT_SET_MODE)
+
+/* FM Response IDs. Same construction as FM Command IDs */
+#define CG2900_FM_RSP_ID_AUP_EXT_SET_MODE_LSB		\
+	CG2900_SET_FM_CMD_ID_LSB(CG2900_FM_CMD_ID_AUP_EXT_SET_MODE, 0)
+#define CG2900_FM_RSP_ID_AUP_EXT_SET_MODE_MSB		\
+	CG2900_SET_FM_CMD_ID_MSB(CG2900_FM_CMD_ID_AUP_EXT_SET_MODE)
+#define CG2900_FM_RSP_ID_AUP_EXT_SET_CTRL_LSB		\
+	CG2900_SET_FM_CMD_ID_LSB(CG2900_FM_CMD_ID_AUP_EXT_SET_CTRL, 0)
+#define CG2900_FM_RSP_ID_AUP_EXT_SET_CTRL_MSB		\
+	CG2900_SET_FM_CMD_ID_MSB(CG2900_FM_CMD_ID_AUP_EXT_SET_CTRL)
+#define CG2900_FM_RSP_ID_AIP_SET_MODE_LSB		\
+	CG2900_SET_FM_CMD_ID_LSB(CG2900_FM_CMD_ID_AIP_SET_MODE, 0)
+#define CG2900_FM_RSP_ID_AIP_SET_MODE_MSB		\
+	CG2900_SET_FM_CMD_ID_MSB(CG2900_FM_CMD_ID_AIP_SET_MODE)
+#define CG2900_FM_RSP_ID_AIP_BT_SET_CTRL_LSB		\
+	CG2900_SET_FM_CMD_ID_LSB(CG2900_FM_CMD_ID_AIP_BT_SET_CTRL, 0)
+#define CG2900_FM_RSP_ID_AIP_BT_SET_CTRL_MSB		\
+	CG2900_SET_FM_CMD_ID_MSB(CG2900_FM_CMD_ID_AIP_BT_SET_CTRL)
+#define CG2900_FM_RSP_ID_AIP_BT_SET_MODE_LSB		\
+	CG2900_SET_FM_CMD_ID_LSB(CG2900_FM_CMD_ID_AIP_BT_SET_MODE, 0)
+#define CG2900_FM_RSP_ID_AIP_BT_SET_MODE_MSB		\
+	CG2900_SET_FM_CMD_ID_MSB(CG2900_FM_CMD_ID_AIP_BT_SET_MODE)
+
+/*
+ *	GNSS
+ */
+
+struct gnss_hci_hdr {
+	__u8	op_code;
+	__le16	plen;
+} __attribute__((packed));
+
+#endif /* _CG2900_CHIP_H_ */
-- 
1.6.3.3
