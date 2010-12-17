Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0LQLYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 06:24:48 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:49437 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250Ab0LQLYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 06:24:45 -0500
From: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
To: Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: [PATCH 05/11] mfd: Add CG2900 audio
Date: Fri, 17 Dec 2010 12:24:25 +0100
Message-ID: <1292585065-28476-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an audio API for the ST-Ericsson CG2900 controller.
The CG2900 is chip supporting GPS, Bluetooth, and FM radio.
This patch adds support for setting audio paths within the CG2900
and to set for example sample rate for certain use cases such as
FM RX over I2S. This driver does not register to any audio framework
such as ALSA, but is intended to be used by drivers that do register
to audio frameworks.
The driver implements a character device so it is accesible from User
space.

Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
---
 drivers/mfd/Kconfig               |    9 +
 drivers/mfd/cg2900/Makefile       |    2 +
 drivers/mfd/cg2900/cg2900_audio.c | 3415 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/cg2900_audio.h  |  473 +++++
 4 files changed, 3899 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/cg2900/cg2900_audio.c
 create mode 100644 include/linux/mfd/cg2900_audio.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 931cb58..44a36bb 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -290,6 +290,15 @@ config MFD_STLC2690_CHIP
 	  STLC2690 support Bluetooth and FM radio, however FM is not supported
 	  over H:4 interface.
 
+config MFD_CG2900_AUDIO
+	tristate "Support CG2900 audio interface"
+	depends on MFD_CG2900
+	help
+	  Support for ST-Ericsson CG2900 Connectivity audio interface. Gives a
+	  module the ability to setup audio paths within the CG2900 controller.
+	  Does not itself connect to for example ALSA framework, but is used by
+	  ALSA drivers.
+
 config PMIC_DA903X
 	bool "Dialog Semiconductor DA9030/DA9034 PMIC Support"
 	depends on I2C=y
diff --git a/drivers/mfd/cg2900/Makefile b/drivers/mfd/cg2900/Makefile
index c4f4fc8..e4f6a4b 100644
--- a/drivers/mfd/cg2900/Makefile
+++ b/drivers/mfd/cg2900/Makefile
@@ -10,3 +10,5 @@ obj-$(CONFIG_MFD_CG2900)	+= cg2900_char_devices.o
 obj-$(CONFIG_MFD_CG2900_CHIP)	+= cg2900_chip.o
 obj-$(CONFIG_MFD_STLC2690_CHIP)	+= stlc2690_chip.o
 
+obj-$(CONFIG_MFD_CG2900_AUDIO)	+= cg2900_audio.o
+
diff --git a/drivers/mfd/cg2900/cg2900_audio.c b/drivers/mfd/cg2900/cg2900_audio.c
new file mode 100644
index 0000000..2a26cea
--- /dev/null
+++ b/drivers/mfd/cg2900/cg2900_audio.c
@@ -0,0 +1,3415 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth Audio Driver for ST-Ericsson CG2900 controller.
+ */
+#define NAME					"cg2900_audio"
+#define pr_fmt(fmt)				NAME ": " fmt "\n"
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <linux/mfd/cg2900.h>
+#include <linux/mfd/cg2900_audio.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+
+#include "cg2900_chip.h"
+
+#define MAX_NBR_OF_USERS			10
+#define FIRST_USER				1
+
+#define DEFAULT_SCO_HANDLE			0x0008
+
+/* Use a timeout of 5 seconds when waiting for a command response */
+#define RESP_TIMEOUT				5000
+
+#define BT_DEV					(info->dev_bt)
+#define FM_DEV					(info->dev_fm)
+
+/* Bluetooth error codes */
+#define HCI_BT_ERROR_NO_ERROR			0x00
+
+/* Used to select proper API, ignoring subrevisions etc */
+enum chip_revision {
+	CHIP_REV_PG1,
+	CHIP_REV_PG2
+};
+
+/**
+ * enum chip_resp_state - State when communicating with the CG2900 controller.
+ * @IDLE:		No outstanding packets to the controller.
+ * @WAITING:		Packet has been sent to the controller. Waiting for
+ *			response.
+ * @RESP_RECEIVED:	Response from controller has been received but not yet
+ *			handled.
+ */
+enum chip_resp_state {
+	IDLE,
+	WAITING,
+	RESP_RECEIVED
+};
+
+/**
+ * enum main_state - Main state for the CG2900 Audio driver.
+ * @OPENED:	Audio driver has registered to CG2900 Core.
+ * @CLOSED:	Audio driver is not registered to CG2900 Core.
+ * @RESET:	A reset of CG2900 Core has occurred and no user has re-opened
+ *		the audio driver.
+ */
+enum main_state {
+	OPENED,
+	CLOSED,
+	RESET
+};
+
+/**
+ * struct endpoint_list - List for storing endpoint configuration nodes.
+ * @ep_list:		Pointer to first node in list.
+ * @management_mutex:	Mutex for handling access to list.
+ */
+struct endpoint_list {
+	struct list_head	ep_list;
+	struct mutex		management_mutex;
+};
+
+/**
+ * struct endpoint_config_node - Node for storing endpoint configuration.
+ * @list:		list_head struct.
+ * @endpoint_id:	Endpoint ID.
+ * @config:		Stored configuration for this endpoint.
+ */
+struct endpoint_config_node {
+	struct list_head			list;
+	enum cg2900_audio_endpoint_id		endpoint_id;
+	union cg2900_endpoint_config_union	config;
+};
+
+/**
+ * struct audio_info - Main CG2900 Audio driver info structure.
+ * @list:			list_head struct.
+ * @state:			Current state of the CG2900 Audio driver.
+ * @revision:			Chip revision, used to select API.
+ * @misc_dev:			The misc device created by this driver.
+ * @misc_registered:		True if misc device is registered.
+ * @parent:			Parent device.
+ * @dev_bt:			Device registered by this driver for the BT
+ *				audio channel.
+ * @dev_fm:			Device registered by this driver for the FM
+ *				audio channel.
+ * @management_mutex:		Mutex for handling access to CG2900 Audio driver
+ *				management.
+ * @bt_mutex:			Mutex for handling access to BT audio channel.
+ * @fm_mutex:			Mutex for handling access to FM audio channel.
+ * @nbr_of_users_active:	Number of sessions open in the CG2900 Audio
+ *				driver.
+ * @i2s_config:			DAI I2S configuration.
+ * @i2s_pcm_config:		DAI PCM_I2S configuration.
+ * @i2s_config_known:		@true if @i2s_config has been set,
+ *				@false otherwise.
+ * @i2s_pcm_config_known:	@true if @i2s_pcm_config has been set,
+ *				@false otherwise.
+ * @endpoints:			List containing the endpoint configurations.
+ * @stream_ids:			Bitmask for in-use stream ids (only used with
+ *				PG2 chip API).
+ */
+struct audio_info {
+	struct list_head		list;
+	enum main_state			state;
+	enum chip_revision		revision;
+	struct miscdevice		misc_dev;
+	bool				misc_registered;
+	struct device			*parent;
+	struct device			*dev_bt;
+	struct device			*dev_fm;
+	struct mutex			management_mutex;
+	struct mutex			bt_mutex;
+	struct mutex			fm_mutex;
+	int				nbr_of_users_active;
+	struct cg2900_dai_conf_i2s	i2s_config;
+	struct cg2900_dai_conf_i2s_pcm	i2s_pcm_config;
+	bool				i2s_config_known;
+	bool				i2s_pcm_config_known;
+	struct endpoint_list		endpoints;
+	u32				stream_ids;
+};
+
+/**
+ * struct audio_user - CG2900 audio user info structure.
+ * @session:	Stored session for the char device.
+ * @resp_state:	State for controller communications.
+ * @info:	CG2900 audio info structure.
+ */
+struct audio_user {
+	int			session;
+	enum chip_resp_state	resp_state;
+	struct audio_info	*info;
+};
+
+/**
+ * struct audio_cb_info - Callback info structure registered in @user_data.
+ * @user:	Audio user currently awaiting data on the channel.
+ * @wq:		Wait queue for this channel.
+ * @skb_queue:	Sk buffer queue.
+ */
+struct audio_cb_info {
+	struct audio_user	*user;
+	wait_queue_head_t	wq;
+	struct sk_buff_head	skb_queue;
+};
+
+/**
+ * struct char_dev_info - CG2900 character device info structure.
+ * @session:		Stored session for the char device.
+ * @stored_data:	Data returned when executing last command, if any.
+ * @stored_data_len:	Length of @stored_data in bytes.
+ * @management_mutex:	Mutex for handling access to char dev management.
+ * @rw_mutex:		Mutex for handling access to char dev writes and reads.
+ * @info:		CG2900 audio info struct.
+ * @rx_queue:		Data queue.
+ */
+struct char_dev_info {
+	int			session;
+	u8			*stored_data;
+	int			stored_data_len;
+	struct mutex		management_mutex;
+	struct mutex		rw_mutex;
+	struct audio_info	*info;
+	struct sk_buff_head	rx_queue;
+};
+
+/*
+ * cg2900_audio_devices - List of active CG2900 audio devices.
+ */
+LIST_HEAD(cg2900_audio_devices);
+
+/*
+ * cg2900_audio_sessions - Pointers to currently opened sessions (maps
+ *			   session ID to user info).
+ */
+static struct audio_user *cg2900_audio_sessions[MAX_NBR_OF_USERS];
+
+/*
+ *	Internal conversion functions
+ *
+ *	Since the CG2900 APIs uses several different ways to encode the
+ *	same parameter in different cases, we have to use translator
+ *	functions.
+ */
+
+/**
+ * session_config_sample_rate() - Convert sample rate to format used in VS_Set_SessionConfiguration.
+ * @rate: Sample rate in API encoding.
+ */
+static u8 session_config_sample_rate(enum cg2900_endpoint_sample_rate rate)
+{
+	static const u8 codes[] = {
+		[ENDPOINT_SAMPLE_RATE_8_KHZ]    = CG2900_BT_SESSION_RATE_8K,
+		[ENDPOINT_SAMPLE_RATE_16_KHZ]   = CG2900_BT_SESSION_RATE_16K,
+		[ENDPOINT_SAMPLE_RATE_44_1_KHZ] = CG2900_BT_SESSION_RATE_44_1K,
+		[ENDPOINT_SAMPLE_RATE_48_KHZ]   = CG2900_BT_SESSION_RATE_48K
+	};
+
+	return codes[rate];
+}
+
+/**
+ * mc_i2s_sample_rate() - Convert sample rate to format used in VS_Port_Config for I2S.
+ * @rate: Sample rate in API encoding.
+ */
+static u8 mc_i2s_sample_rate(enum cg2900_dai_sample_rate rate)
+{
+	static const u8 codes[] = {
+		[SAMPLE_RATE_8]    = CG2900_MC_I2S_SAMPLE_RATE_8,
+		[SAMPLE_RATE_16]   = CG2900_MC_I2S_SAMPLE_RATE_16,
+		[SAMPLE_RATE_44_1] = CG2900_MC_I2S_SAMPLE_RATE_44_1,
+		[SAMPLE_RATE_48]   = CG2900_MC_I2S_SAMPLE_RATE_48
+	};
+
+	return codes[rate];
+}
+
+/**
+ * mc_pcm_sample_rate() - Convert sample rate to format used in VS_Port_Config for PCM/I2S.
+ * @rate: Sample rate in API encoding.
+ */
+static u8 mc_pcm_sample_rate(enum cg2900_dai_sample_rate rate)
+{
+	static const u8 codes[] = {
+		[SAMPLE_RATE_8]    = CG2900_MC_PCM_SAMPLE_RATE_8,
+		[SAMPLE_RATE_16]   = CG2900_MC_PCM_SAMPLE_RATE_16,
+		[SAMPLE_RATE_44_1] = CG2900_MC_PCM_SAMPLE_RATE_44_1,
+		[SAMPLE_RATE_48]   = CG2900_MC_PCM_SAMPLE_RATE_48
+	};
+
+	return codes[rate];
+}
+
+/**
+ * mc_i2s_channel_select() - Convert channel selection to format used in VS_Port_Config.
+ * @sel: Channel selection in API encoding.
+ */
+static u8 mc_i2s_channel_select(enum cg2900_dai_channel_sel sel)
+{
+	static const u8 codes[] = {
+		[CHANNEL_SELECTION_RIGHT] = CG2900_MC_I2S_RIGHT_CHANNEL,
+		[CHANNEL_SELECTION_LEFT]  = CG2900_MC_I2S_LEFT_CHANNEL,
+		[CHANNEL_SELECTION_BOTH]  = CG2900_MC_I2S_BOTH_CHANNELS
+	};
+	return codes[sel];
+}
+
+/**
+ * get_fs_duration() - Convert framesync-enumeration to real value.
+ * @duration: Framsync duration (API encoding).
+ *
+ * Returns:
+ * Duration in bits.
+ */
+static u16 get_fs_duration(enum cg2900_dai_fs_duration duration)
+{
+	static const u16 values[] = {
+		[SYNC_DURATION_8] = 8,
+		[SYNC_DURATION_16] = 16,
+		[SYNC_DURATION_24] = 24,
+		[SYNC_DURATION_32] = 32,
+		[SYNC_DURATION_48] = 48,
+		[SYNC_DURATION_50] = 50,
+		[SYNC_DURATION_64] = 64,
+		[SYNC_DURATION_75] = 75,
+		[SYNC_DURATION_96] = 96,
+		[SYNC_DURATION_125] = 125,
+		[SYNC_DURATION_128] = 128,
+		[SYNC_DURATION_150] = 150,
+		[SYNC_DURATION_192] = 192,
+		[SYNC_DURATION_250] = 250,
+		[SYNC_DURATION_256] = 256,
+		[SYNC_DURATION_300] = 300,
+		[SYNC_DURATION_384] = 384,
+		[SYNC_DURATION_500] = 500,
+		[SYNC_DURATION_512] = 512,
+		[SYNC_DURATION_600] = 600,
+		[SYNC_DURATION_768] = 768
+	};
+	return values[duration];
+}
+
+/**
+ * mc_i2s_role() - Convert master/slave encoding to format for I2S-ports.
+ * @mode: Master/slave in API encoding.
+ */
+static u8 mc_i2s_role(enum cg2900_dai_mode mode)
+{
+	if (mode == DAI_MODE_SLAVE)
+		return CG2900_I2S_MODE_SLAVE;
+	else
+		return CG2900_I2S_MODE_MASTER;
+}
+
+/**
+ * mc_pcm_role() - Convert master/slave encoding to format for PCM/I2S-port.
+ * @mode: Master/slave in API encoding.
+ */
+static u8 mc_pcm_role(enum cg2900_dai_mode mode)
+{
+	if (mode == DAI_MODE_SLAVE)
+		return CG2900_PCM_MODE_SLAVE;
+	else
+		return CG2900_PCM_MODE_MASTER;
+}
+
+/**
+ * fm_get_conversion() - Convert sample rate to convert up/down used in X_Set_Control FM commands.
+ * @srate: Sample rate.
+ */
+static u16 fm_get_conversion(enum cg2900_endpoint_sample_rate srate)
+{
+	if (srate >= ENDPOINT_SAMPLE_RATE_44_1_KHZ)
+		return CG2900_FM_CMD_SET_CTRL_CONV_UP;
+	else
+		return CG2900_FM_CMD_SET_CTRL_CONV_DOWN;
+}
+
+/**
+ * get_info() - Return info structure for this device.
+ * @dev:	Current device.
+ *
+ * This function returns the info structure on the following basis:
+ *	* If dev is NULL return first info struct found. If none is found return
+ *	  NULL.
+ *	* If dev is valid we will return corresponding info struct if dev is the
+ *	  parent of the info struct or if dev's parent is the parent of the info
+ *	  struct.
+ *	* If dev is valid and no info structure is found, a new info struct is
+ *	  allocated, initialized, and returned.
+ *
+ * Returns:
+ *   Pointer to info struct if there is no error.
+ *   NULL if NULL was supplied and no info structure exist.
+ *   ERR_PTR(-ENOMEM) if allocation fails.
+ */
+static struct audio_info *get_info(struct device *dev)
+{
+	struct list_head *cursor;
+	struct audio_info *tmp;
+	struct audio_info *info = NULL;
+
+	/*
+	 * Find the info structure for dev. If NULL is supplied for dev
+	 * just return first device found.
+	 */
+	list_for_each(cursor, &cg2900_audio_devices) {
+		tmp = list_entry(cursor, struct audio_info, list);
+		if (!dev || tmp->parent == dev->parent || tmp->parent == dev) {
+			info = tmp;
+			break;
+		}
+	}
+
+	if (!dev || info)
+		return info;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(dev, "Could not allocate info struct\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	info->parent = dev->parent;
+
+	/* Initiate the mutexes */
+	mutex_init(&(info->management_mutex));
+	mutex_init(&(info->bt_mutex));
+	mutex_init(&(info->fm_mutex));
+	mutex_init(&(info->endpoints.management_mutex));
+
+	/* Initiate the endpoint list */
+	INIT_LIST_HEAD(&info->endpoints.ep_list);
+
+	list_add_tail(&info->list, &cg2900_audio_devices);
+
+	dev_info(dev, "CG2900 device added\n");
+	return info;
+}
+
+/**
+ * flush_endpoint_list() - Deletes all stored endpoints in @list.
+ * @list:	List of endpoints.
+ */
+static void flush_endpoint_list(struct endpoint_list *list)
+{
+	struct list_head *cursor, *next;
+	struct endpoint_config_node *tmp;
+
+	mutex_lock(&list->management_mutex);
+	list_for_each_safe(cursor, next, &(list->ep_list)) {
+		tmp = list_entry(cursor, struct endpoint_config_node, list);
+		list_del(cursor);
+		kfree(tmp);
+	}
+	mutex_unlock(&list->management_mutex);
+}
+
+/**
+ * device_removed() - Remove device from list if there are no channels left.
+ * @info:	CG2900 audio info structure.
+ */
+static void device_removed(struct audio_info *info)
+{
+	struct list_head *cursor;
+	struct audio_info *tmp;
+
+	if (info->dev_bt || info->dev_fm)
+		/* There are still devices active */
+		return;
+
+	/* Find the stored info structure */
+	list_for_each(cursor, &cg2900_audio_devices) {
+		tmp = list_entry(cursor, struct audio_info, list);
+		if (tmp == info) {
+			list_del(cursor);
+			break;
+		}
+	}
+
+	flush_endpoint_list(&info->endpoints);
+
+	mutex_destroy(&info->management_mutex);
+	mutex_destroy(&info->bt_mutex);
+	mutex_destroy(&info->fm_mutex);
+	mutex_destroy(&info->endpoints.management_mutex);
+
+	kfree(info);
+	pr_info("CG2900 Audio device removed");
+}
+
+/**
+ * read_cb() - Handle data received from STE connectivity driver.
+ * @dev:	Device receiving data.
+ * @skb:	Buffer with data coming form device.
+ */
+static void read_cb(struct cg2900_user_data *dev, struct sk_buff *skb)
+{
+	struct audio_cb_info *cb_info;
+
+	cb_info = cg2900_get_usr(dev);
+
+	if (!(cb_info->user)) {
+		dev_err(dev->dev, "NULL supplied as cb_info->user\n");
+		return;
+	}
+
+	/* Mark that packet has been received */
+	dev_dbg(dev->dev, "New resp_state: RESP_RECEIVED");
+	cb_info->user->resp_state = RESP_RECEIVED;
+	skb_queue_tail(&cb_info->skb_queue, skb);
+	wake_up_interruptible(&cb_info->wq);
+}
+
+/**
+ * reset_cb() - Reset callback function.
+ * @dev:	CG2900_Core device resetting.
+ */
+static void reset_cb(struct cg2900_user_data *dev)
+{
+	struct audio_info *info;
+
+	dev_dbg(dev->dev, "reset_cb\n");
+
+	info = dev_get_drvdata(dev->dev);
+	mutex_lock(&info->management_mutex);
+	info->nbr_of_users_active = 0;
+	info->state = RESET;
+	mutex_unlock(&info->management_mutex);
+}
+
+/**
+ * get_session_user() - Check that supplied session is within valid range.
+ * @session:	Session ID.
+ *
+ * Returns:
+ *   Audio_user if there is no error.
+ *   NULL for bad session ID.
+ */
+static struct audio_user *get_session_user(int session)
+{
+	struct audio_user *audio_user;
+
+	if (session < FIRST_USER || session >= MAX_NBR_OF_USERS) {
+		pr_err("Calling with invalid session %d", session);
+		return NULL;
+	}
+
+	audio_user = cg2900_audio_sessions[session];
+	if (!audio_user)
+		pr_err("Calling with non-opened session %d", session);
+	return audio_user;
+}
+
+/**
+ * del_endpoint_private() - Deletes an endpoint from @list.
+ * @endpoint_id:	Endpoint ID.
+ * @list:		List of endpoints.
+ *
+ * Deletes an endpoint from the supplied endpoint list.
+ * This function is not protected by any semaphore.
+ */
+static void del_endpoint_private(enum cg2900_audio_endpoint_id endpoint_id,
+				 struct endpoint_list *list)
+{
+	struct list_head *cursor, *next;
+	struct endpoint_config_node *tmp;
+
+	list_for_each_safe(cursor, next, &(list->ep_list)) {
+		tmp = list_entry(cursor, struct endpoint_config_node, list);
+		if (tmp->endpoint_id == endpoint_id) {
+			list_del(cursor);
+			kfree(tmp);
+		}
+	}
+}
+
+/**
+ * add_endpoint() - Add endpoint node to @list.
+ * @ep_config:	Endpoint configuration.
+ * @list:	List of endpoints.
+ *
+ * Add endpoint node to the supplied list and copies supplied config to node.
+ * If a node already exists for the supplied endpoint, the old node is removed
+ * and replaced by the new node.
+ */
+static void add_endpoint(struct cg2900_endpoint_config *ep_config,
+			 struct endpoint_list *list)
+{
+	struct endpoint_config_node *item;
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (!item) {
+		pr_err("add_endpoint: Failed to alloc memory");
+		return;
+	}
+
+	/* Store values */
+	item->endpoint_id = ep_config->endpoint_id;
+	memcpy(&(item->config), &(ep_config->config), sizeof(item->config));
+
+	mutex_lock(&(list->management_mutex));
+
+	/*
+	 * Check if endpoint ID already exist in list.
+	 * If that is the case, remove it.
+	 */
+	if (!list_empty(&(list->ep_list)))
+		del_endpoint_private(ep_config->endpoint_id, list);
+
+	list_add_tail(&(item->list), &(list->ep_list));
+
+	mutex_unlock(&(list->management_mutex));
+}
+
+/**
+ * find_endpoint() - Finds endpoint identified by @endpoint_id in @list.
+ * @endpoint_id:	Endpoint ID.
+ * @list:		List of endpoints.
+ *
+ * Returns:
+ *   Endpoint configuration if there is no error.
+ *   NULL if no configuration can be found for @endpoint_id.
+ */
+static union cg2900_endpoint_config_union *
+find_endpoint(enum cg2900_audio_endpoint_id endpoint_id,
+	      struct endpoint_list *list)
+{
+	struct list_head *cursor, *next;
+	struct endpoint_config_node *tmp;
+	struct endpoint_config_node *ret_ep = NULL;
+
+	mutex_lock(&list->management_mutex);
+	list_for_each_safe(cursor, next, &(list->ep_list)) {
+		tmp = list_entry(cursor, struct endpoint_config_node, list);
+		if (tmp->endpoint_id == endpoint_id) {
+			ret_ep = tmp;
+			break;
+		}
+	}
+	mutex_unlock(&list->management_mutex);
+
+	if (ret_ep)
+		return &(ret_ep->config);
+	else
+		return NULL;
+}
+
+/**
+ * new_stream_id() - Allocate a new stream id.
+ * @info:	Current audio info struct.
+ *
+ * Returns:
+ *  0-127 new valid id.
+ *  -ENOMEM if no id is available.
+ */
+static s8 new_stream_id(struct audio_info *info)
+{
+	int r;
+
+	mutex_lock(&info->management_mutex);
+
+	r = find_first_zero_bit(&info->stream_ids,
+				8 * sizeof(info->stream_ids));
+
+	if (r >= 8 * sizeof(info->stream_ids)) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	info->stream_ids |= (0x01u << r);
+
+out:
+	mutex_unlock(&info->management_mutex);
+	return r;
+}
+
+/**
+ * release_stream_id() - Release a stream id.
+ * @info:	Current audio info struct.
+ * @id:		Stream to release.
+ */
+static void release_stream_id(struct audio_info *info, u8 id)
+{
+	if (id >= 8 * sizeof(info->stream_ids))
+		return;
+
+	mutex_lock(&info->management_mutex);
+	info->stream_ids &= ~(0x01u << id);
+	mutex_unlock(&info->management_mutex);
+}
+
+/**
+ * receive_fm_write_response() - Wait for and handle the response to an FM Legacy WriteCommand request.
+ * @audio_user:	Audio user to check for.
+ * @command:	FM command to wait for.
+ *
+ * This function first waits (up to 5 seconds) for a response to an FM
+ * write command and when one arrives, it checks that it is the one we
+ * are waiting for and also that no error has occurred.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -EIO for other errors.
+ */
+static int receive_fm_write_response(struct audio_user *audio_user,
+				     u16 command)
+{
+	int err = 0;
+	int res;
+	struct sk_buff *skb;
+	struct fm_leg_cmd_cmpl *pkt;
+	u16 rsp_cmd;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = audio_user->info;
+	pf_data = dev_get_platdata(info->dev_fm);
+	cb_info = cg2900_get_usr(pf_data);
+
+	/*
+	 * Wait for callback to receive command complete and then wake us up
+	 * again.
+	 */
+	res = wait_event_interruptible_timeout(cb_info->wq,
+				audio_user->resp_state == RESP_RECEIVED,
+				msecs_to_jiffies(RESP_TIMEOUT));
+	if (!res) {
+		dev_err(FM_DEV, "Timeout while waiting for return packet\n");
+		return -ECOMM;
+	} else if (res < 0) {
+		dev_err(FM_DEV,
+			"Error %d occurred while waiting for return packet\n",
+			res);
+		return -ECOMM;
+	}
+
+	/* OK, now we should have received answer. Let's check it. */
+	skb = skb_dequeue_tail(&cb_info->skb_queue);
+	if (!skb) {
+		dev_err(FM_DEV, "No skb in queue when it should be there\n");
+		return -EIO;
+	}
+
+	pkt = (struct fm_leg_cmd_cmpl *)skb->data;
+
+	/* Check if we received the correct event */
+	if (pkt->opcode != CG2900_FM_GEN_ID_LEGACY) {
+		dev_err(FM_DEV,
+			"Received unknown FM packet. 0x%X %X %X %X %X\n",
+			skb->data[0], skb->data[1], skb->data[2],
+			skb->data[3], skb->data[4]);
+		err = -EIO;
+		goto error_handling_free_skb;
+	}
+
+	/* FM Legacy Command complete event */
+	rsp_cmd = cg2900_get_fm_cmd_id(le16_to_cpu(pkt->response_head));
+
+	if (pkt->fm_function != CG2900_FM_CMD_PARAM_WRITECOMMAND ||
+	    rsp_cmd != command) {
+		dev_err(FM_DEV,
+			"Received unexpected packet func 0x%X cmd 0x%04X\n",
+			pkt->fm_function, rsp_cmd);
+		err = -EIO;
+		goto error_handling_free_skb;
+	}
+
+	if (pkt->cmd_status != CG2900_FM_CMD_STATUS_COMMAND_SUCCEEDED) {
+		dev_err(FM_DEV, "FM Command failed (%d)\n", pkt->cmd_status);
+		err = -EIO;
+		goto error_handling_free_skb;
+	}
+	/* Operation succeeded. We are now done */
+
+error_handling_free_skb:
+	kfree_skb(skb);
+	return err;
+}
+
+/**
+ * receive_bt_cmd_complete() - Wait for and handle an BT Command Complete event.
+ * @audio_user:	Audio user to check for.
+ * @rsp:	Opcode of BT command to wait for.
+ * @data:	Pointer to buffer if any received data should be stored (except
+ *		status).
+ * @data_len:	Length of @data in bytes.
+ *
+ * This function first waits for BT Command Complete event (up to 5 seconds)
+ * and when one arrives, it checks that it is the one we are waiting for and
+ * also that no error has occurred.
+ * If @data is supplied it also copies received data into @data.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -EIO for other errors.
+ */
+static int receive_bt_cmd_complete(struct audio_user *audio_user, u16 rsp,
+				   void *data, int data_len)
+{
+	int err = 0;
+	int res;
+	struct sk_buff *skb;
+	struct bt_cmd_cmpl_event *evt;
+	u16 opcode;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = audio_user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	/*
+	 * Wait for callback to receive command complete and then wake us up
+	 * again.
+	 */
+	res = wait_event_interruptible_timeout(cb_info->wq,
+					audio_user->resp_state == RESP_RECEIVED,
+					msecs_to_jiffies(RESP_TIMEOUT));
+	if (!res) {
+		dev_err(BT_DEV, "Timeout while waiting for return packet\n");
+		return -ECOMM;
+	} else if (res < 0) {
+		/* We timed out or an error occurred */
+		dev_err(BT_DEV,
+			"Error %d occurred while waiting for return packet\n",
+			res);
+		return -ECOMM;
+	}
+
+	/* OK, now we should have received answer. Let's check it. */
+	skb = skb_dequeue_tail(&cb_info->skb_queue);
+	if (!skb) {
+		dev_err(BT_DEV, "No skb in queue when it should be there\n");
+		return -EIO;
+	}
+
+	evt = (struct bt_cmd_cmpl_event *)skb->data;
+	if (evt->eventcode != HCI_EV_CMD_COMPLETE) {
+		dev_err(BT_DEV,
+			"We did not receive the event we expected (0x%X)\n",
+			evt->eventcode);
+		err = -EIO;
+		goto error_handling_free_skb;
+	}
+
+	opcode = le16_to_cpu(evt->opcode);
+	if (opcode != rsp) {
+		dev_err(BT_DEV,
+			"Received cmd complete for unexpected command: "
+			"0x%04X\n", opcode);
+		err = -EIO;
+		goto error_handling_free_skb;
+	}
+
+	if (evt->status != HCI_BT_ERROR_NO_ERROR) {
+		dev_err(BT_DEV, "Received command complete with err %d\n",
+			evt->status);
+		err = -EIO;
+		goto error_handling_free_skb;
+	}
+
+	/*
+	 * Copy the rest of the parameters if a buffer has been supplied.
+	 * The caller must have set the length correctly.
+	 */
+	if (data)
+		memcpy(data, evt->data, data_len);
+
+	/* Operation succeeded. We are now done */
+
+error_handling_free_skb:
+	kfree_skb(skb);
+	return err;
+}
+
+/**
+ * send_vs_session_ctrl() - Formats an sends a CG2900_BT_VS_SESSION_CTRL command.
+ * @user:		Audio user this command belongs to.
+ * @stream_handle:	Handle to stream.
+ * @command:		Command to execute on stream, should be one of
+ *			CG2900_BT_SESSION_START, CG2900_BT_SESSION_STOP,
+ *			CG2900_BT_SESSION_PAUSE, CG2900_BT_SESSION_RESUME.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the bt_mutex held.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_vs_session_ctrl(struct audio_user *user,
+				u8 stream_handle, u8 command)
+{
+	int err = 0;
+	struct bt_vs_session_ctrl_cmd *pkt;
+	struct sk_buff *skb;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV, "BT: HCI_VS_Session_Control handle: %d cmd: %d\n",
+		stream_handle, command);
+
+	skb = pf_data->alloc_skb(sizeof(*pkt), GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV,
+			"send_vs_session_ctrl: Could not allocate skb\n");
+		return -ENOMEM;
+	}
+
+	/* Enter data into the skb */
+	pkt = (struct bt_vs_session_ctrl_cmd *) skb_put(skb, sizeof(*pkt));
+
+	pkt->opcode  = cpu_to_le16(CG2900_BT_VS_SESSION_CTRL);
+	pkt->plen    = BT_PARAM_LEN(sizeof(*pkt));
+	pkt->id      = stream_handle;
+	pkt->control = command; /* Start/stop etc */
+
+	cb_info->user = user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished;
+	}
+
+	err = receive_bt_cmd_complete(user, CG2900_BT_VS_SESSION_CTRL,
+				      NULL, 0);
+finished:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * send_vs_session_config() - Formats an sends a CG2900_BT_VS_SESSION_CONFIG command.
+ * @user:		Audio user this command belongs to.
+ * @config_stream:	Custom function for configuring the stream.
+ * @priv_data:		Private data passed to @config_stream untouched.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the bt_mutex held.
+ *
+ * Space is allocated for one stream and a custom function is used to
+ * fill in the stream configuration.
+ *
+ * Returns:
+ *  0-255 stream handle if no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_vs_session_config(struct audio_user *user,
+	void(*config_stream)(struct audio_info *, void *,
+			     struct session_config_stream *),
+	void *priv_data)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	struct bt_vs_session_config_cmd *pkt;
+	u8 session_id;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV, "BT: HCI_VS_Set_Session_Configuration\n");
+
+	skb = pf_data->alloc_skb(sizeof(*pkt), GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV,
+			"send_vs_session_config: Could not allocate skb\n");
+		return -ENOMEM;
+	}
+
+	pkt = (struct bt_vs_session_config_cmd *)skb_put(skb, sizeof(*pkt));
+	/* zero the packet so we don't have to set all reserved fields */
+	memset(pkt, 0, sizeof(*pkt));
+
+	/* Common parameters */
+	pkt->opcode    = cpu_to_le16(CG2900_BT_VS_SET_SESSION_CONFIG);
+	pkt->plen      = BT_PARAM_LEN(sizeof(*pkt));
+	pkt->n_streams = 1; /* 1 stream configuration supplied */
+
+	/* Let the custom-function fill in the rest */
+	config_stream(info, priv_data, &pkt->stream);
+
+	cb_info->user = user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished;
+	}
+
+	err = receive_bt_cmd_complete(user,
+				      CG2900_BT_VS_SET_SESSION_CONFIG,
+				      &session_id, sizeof(session_id));
+	/* Return session id/stream handle if success */
+	if (!err)
+		err = session_id;
+
+finished:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * send_fm_write_1_param() - Formats and sends an FM legacy write command with one parameter.
+ * @user:	Audio user this command belongs to.
+ * @command:	Command.
+ * @param:	Parameter for command.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the fm_mutex held.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_fm_write_1_param(struct audio_user *user,
+				 u16 command, u16 param)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	struct fm_leg_cmd *cmd;
+	size_t len;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_fm);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(FM_DEV, "send_fm_write_1_param cmd 0x%X param 0x%X\n",
+		command, param);
+
+	/* base package + one parameter */
+	len = sizeof(*cmd) + sizeof(cmd->fm_cmd.data[0]);
+
+	skb = pf_data->alloc_skb(len, GFP_KERNEL);
+	if (!skb) {
+		dev_err(FM_DEV,
+			"send_fm_write_1_param: Could not allocate skb\n");
+		return -ENOMEM;
+	}
+
+	cmd = (struct fm_leg_cmd *)skb_put(skb, len);
+
+	cmd->length      = CG2900_FM_CMD_PARAM_LEN(len);
+	cmd->opcode      = CG2900_FM_GEN_ID_LEGACY;
+	cmd->read_write  = CG2900_FM_CMD_LEG_PARAM_WRITE;
+	cmd->fm_function = CG2900_FM_CMD_PARAM_WRITECOMMAND;
+	/* one parameter - builtin assumption for this function */
+	cmd->fm_cmd.head    = cpu_to_le16(cg2900_make_fm_cmd_id(command, 1));
+	cmd->fm_cmd.data[0] = cpu_to_le16(param);
+
+	cb_info->user = user;
+	dev_dbg(FM_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(FM_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished;
+	}
+
+	err = receive_fm_write_response(user, command);
+finished:
+	dev_dbg(FM_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * send_vs_stream_ctrl() - Formats an sends a CG2900_MC_VS_STREAM_CONTROL command.
+ * @user:	Audio user this command belongs to.
+ * @stream:	Stream id.
+ * @command:	Start/stop etc.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the bt_mutex held.
+ *
+ * While the HCI command allows for multiple streams in one command,
+ * this function only handles one.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_vs_stream_ctrl(struct audio_user *user, u8 stream, u8 command)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	struct mc_vs_stream_ctrl_cmd *cmd;
+	size_t len;
+	u8 vs_err;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV, "send_vs_stream_ctrl stream %d command %d\n", stream,
+		command);
+
+	/* basic length + one stream */
+	len = sizeof(*cmd) + sizeof(cmd->stream[0]);
+
+	skb = pf_data->alloc_skb(len, GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV, "send_vs_stream_ctrl:Could not allocate skb\n");
+		return -ENOMEM;
+	}
+
+	cmd = (struct mc_vs_stream_ctrl_cmd *)skb_put(skb, len);
+
+	cmd->opcode  = cpu_to_le16(CG2900_MC_VS_STREAM_CONTROL);
+	cmd->plen    = BT_PARAM_LEN(len);
+	cmd->command = command;
+
+	/* one stream */
+	cmd->n_streams  = 1;
+	cmd->stream[0] = stream;
+
+	cb_info->user = user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished;
+	}
+
+	/* All commands in PG2 API returns one byte with extra status */
+	err = receive_bt_cmd_complete(user,
+				      CG2900_MC_VS_STREAM_CONTROL,
+				      &vs_err, sizeof(vs_err));
+	if (err)
+		dev_err(BT_DEV,
+			"VS_STREAM_CONTROL - failed with error 0x%02x\n",
+			vs_err);
+
+finished:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * send_vs_create_stream() - Formats an sends a CG2900_MC_VS_CREATE_STREAM command.
+ * @user:	Audio user this command belongs to.
+ * @inport:	Stream id.
+ * @outport:	Start/stop etc.
+ * @order:	Activation order.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the bt_mutex held.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_vs_create_stream(struct audio_user *user, u8 inport,
+				 u8 outport, u8 order)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	struct mc_vs_create_stream_cmd *cmd;
+	s8 id;
+	u8 vs_err;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV,
+		"send_vs_create_stream inport %d outport %d order %d\n",
+		inport, outport, order);
+
+	id = new_stream_id(info);
+	if (id < 0) {
+		dev_err(BT_DEV, "No free stream id\n");
+		err = -EIO;
+		goto finished;
+	}
+
+	skb = pf_data->alloc_skb(sizeof(*cmd), GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV,
+			"send_vs_create_stream: Could not allocate skb\n");
+		err = -ENOMEM;
+		goto finished_release_id;
+	}
+
+	cmd = (struct mc_vs_create_stream_cmd *)skb_put(skb, sizeof(*cmd));
+
+	cmd->opcode  = cpu_to_le16(CG2900_MC_VS_CREATE_STREAM);
+	cmd->plen    = BT_PARAM_LEN(sizeof(*cmd));
+	cmd->id      = (u8)id;
+	cmd->inport  = inport;
+	cmd->outport = outport;
+	cmd->order   = order;
+
+	cb_info->user = user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished_release_id;
+	}
+
+	/* All commands in PG2 API returns one byte with extra status */
+	err = receive_bt_cmd_complete(user,
+				      CG2900_MC_VS_CREATE_STREAM,
+				      &vs_err, sizeof(vs_err));
+	if (err) {
+		dev_err(BT_DEV,
+			"VS_CREATE_STREAM - failed with error 0x%02x\n",
+			vs_err);
+		goto finished_release_id;
+	}
+
+	err = id;
+	goto finished;
+
+finished_release_id:
+	release_stream_id(info, id);
+finished:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * send_vs_port_cfg() - Formats an sends a CG2900_MC_VS_PORT_CONFIG command.
+ * @user:	Audio user this command belongs to.
+ * @port:	Port id to configure.
+ * @cfg:	Pointer to specific configuration.
+ * @cfglen:	Length of configuration.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the bt_mutex held.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_vs_port_cfg(struct audio_user *user, u8 port,
+			    const void *cfg, size_t cfglen)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	struct mc_vs_port_cfg_cmd *cmd;
+	void *ptr;
+	u8 vs_err;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV, "send_vs_port_cfg len %d\n", cfglen);
+
+	skb = pf_data->alloc_skb(sizeof(*cmd) + cfglen, GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV, "send_vs_port_cfg: Could not allocate skb\n");
+		return -ENOMEM;
+	}
+
+	/* Fill in common part */
+	cmd = (struct mc_vs_port_cfg_cmd *) skb_put(skb, sizeof(*cmd));
+	cmd->opcode = cpu_to_le16(CG2900_MC_VS_PORT_CONFIG);
+	cmd->plen = BT_PARAM_LEN(sizeof(*cmd) + cfglen);
+	cmd->type = port;
+
+	/* Copy specific configuration */
+	ptr = skb_put(skb, cfglen);
+	memcpy(ptr, cfg, cfglen);
+
+	/* Send */
+	cb_info->user = user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished;
+	}
+
+	/* All commands in PG2 API returns one byte with extra status */
+	err = receive_bt_cmd_complete(user, CG2900_MC_VS_PORT_CONFIG,
+				      &vs_err, sizeof(vs_err));
+	if (err)
+		dev_err(BT_DEV, "VS_PORT_CONFIG - failed with error 0x%02x\n",
+			vs_err);
+
+finished:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * set_dai_config_pg1() - Internal implementation of @cg2900_audio_set_dai_config for PG1 hardware.
+ * @audio_user:	Pointer to audio user struct.
+ * @config:	Pointer to the configuration to set.
+ *
+ * Sets the Digital Audio Interface (DAI) configuration for PG1
+ * hardware. This is and internal function and basic
+ * argument-verification should have been done by the caller.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -EACCESS if port is not supported.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int set_dai_config_pg1(struct audio_user *audio_user,
+			      struct cg2900_dai_config *config)
+{
+	int err = 0;
+	struct cg2900_dai_conf_i2s_pcm *i2s_pcm;
+	struct sk_buff *skb = NULL;
+	struct bt_vs_set_hw_cfg_cmd_i2s *i2s_cmd;
+	struct bt_vs_set_hw_cfg_cmd_pcm *pcm_cmd;
+	struct audio_info *info = audio_user->info;
+	struct cg2900_user_data *pf_data = dev_get_platdata(info->dev_bt);
+	struct audio_cb_info *cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV, "set_dai_config_pg1 port %d\n", config->port);
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any time on
+	 * each channel.
+	 */
+	mutex_lock(&info->bt_mutex);
+
+	/* Allocate the sk_buffer. The length is actually a max length since
+	 * length varies depending on logical transport.
+	 */
+	skb = pf_data->alloc_skb(CG2900_BT_LEN_VS_SET_HARDWARE_CONFIG,
+				 GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV, "set_dai_config_pg1: Could not allocate skb\n");
+		err = -ENOMEM;
+		goto finished_unlock_mutex;
+	}
+
+	/* Fill in hci-command according to received configuration */
+	switch (config->port) {
+	case PORT_0_I2S:
+		i2s_cmd = (struct bt_vs_set_hw_cfg_cmd_i2s *)
+			skb_put(skb, sizeof(*i2s_cmd));
+
+		i2s_cmd->opcode = cpu_to_le16(CG2900_BT_VS_SET_HARDWARE_CONFIG);
+		i2s_cmd->plen   = BT_PARAM_LEN(sizeof(*i2s_cmd));
+
+		i2s_cmd->vp_type = PORT_PROTOCOL_I2S;
+		i2s_cmd->port_id = 0x00; /* First/only I2S port */
+		i2s_cmd->half_period = config->conf.i2s.half_period;
+
+		i2s_cmd->master_slave = mc_i2s_role(config->conf.i2s.mode);
+
+		/* Store the new configuration */
+		mutex_lock(&info->management_mutex);
+		memcpy(&info->i2s_config, &config->conf.i2s,
+		       sizeof(config->conf.i2s));
+		info->i2s_config_known = true;
+		mutex_unlock(&info->management_mutex);
+		break;
+
+	case PORT_1_I2S_PCM:
+		pcm_cmd = (struct bt_vs_set_hw_cfg_cmd_pcm *)
+			skb_put(skb, sizeof(*pcm_cmd));
+
+		pcm_cmd->opcode = cpu_to_le16(CG2900_BT_VS_SET_HARDWARE_CONFIG);
+		pcm_cmd->plen   = BT_PARAM_LEN(sizeof(*pcm_cmd));
+
+		i2s_pcm = &config->conf.i2s_pcm;
+
+		/*
+		 * PG1 chips don't support I2S over the PCM/I2S bus,
+		 * and PG2 chips don't use this command
+		 */
+		if (i2s_pcm->protocol != PORT_PROTOCOL_PCM) {
+			dev_err(BT_DEV,
+				"I2S not supported over the PCM/I2S bus\n");
+			err = -EACCES;
+			goto error_handling_free_skb;
+		}
+
+		pcm_cmd->vp_type = PORT_PROTOCOL_PCM;
+		pcm_cmd->port_id = 0x00; /* First/only PCM port */
+
+		HWCONFIG_PCM_SET_MODE(pcm_cmd, mc_pcm_role(i2s_pcm->mode));
+
+		HWCONFIG_PCM_SET_DIR(pcm_cmd, 0, i2s_pcm->slot_0_dir);
+		HWCONFIG_PCM_SET_DIR(pcm_cmd, 1, i2s_pcm->slot_1_dir);
+		HWCONFIG_PCM_SET_DIR(pcm_cmd, 2, i2s_pcm->slot_2_dir);
+		HWCONFIG_PCM_SET_DIR(pcm_cmd, 3, i2s_pcm->slot_3_dir);
+
+		pcm_cmd->bit_clock = i2s_pcm->clk;
+		pcm_cmd->frame_len =
+			cpu_to_le16(get_fs_duration(i2s_pcm->duration));
+
+		/* Store the new configuration */
+		mutex_lock(&info->management_mutex);
+		memcpy(&info->i2s_pcm_config, &config->conf.i2s_pcm,
+		       sizeof(config->conf.i2s_pcm));
+		info->i2s_pcm_config_known = true;
+		mutex_unlock(&info->management_mutex);
+		break;
+
+	default:
+		dev_err(BT_DEV, "Unknown port configuration %d\n",
+			config->port);
+		err = -EACCES;
+		goto error_handling_free_skb;
+	};
+
+	cb_info->user = audio_user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	audio_user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		goto error_handling_free_skb;
+	}
+
+	err = receive_bt_cmd_complete(audio_user,
+				      CG2900_BT_VS_SET_HARDWARE_CONFIG,
+				      NULL, 0);
+
+	goto finished_unlock_mutex;
+
+error_handling_free_skb:
+	kfree_skb(skb);
+finished_unlock_mutex:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	audio_user->resp_state = IDLE;
+	mutex_unlock(&info->bt_mutex);
+	return err;
+}
+
+/**
+ * set_dai_config_pg2() - Internal implementation of @cg2900_audio_set_dai_config for PG2 hardware.
+ * @audio_user:	Pointer to audio user struct.
+ * @config:	Pointer to the configuration to set.
+ *
+ * Sets the Digital Audio Interface (DAI) configuration for PG2
+ * hardware. This is an internal function and basic
+ * argument-verification should have been done by the caller.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -EACCESS if port is not supported.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int set_dai_config_pg2(struct audio_user *audio_user,
+			      struct cg2900_dai_config *config)
+{
+	int err = 0;
+	struct cg2900_dai_conf_i2s *i2s;
+	struct cg2900_dai_conf_i2s_pcm *i2s_pcm;
+
+	struct mc_vs_port_cfg_i2s i2s_cfg;
+	struct mc_vs_port_cfg_pcm_i2s pcm_cfg;
+	struct audio_info *info = audio_user->info;
+
+	dev_dbg(BT_DEV, "set_dai_config_pg2 port %d\n", config->port);
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any time on
+	 * each channel.
+	 */
+	mutex_lock(&info->bt_mutex);
+
+	switch (config->port) {
+	case PORT_0_I2S:
+		i2s = &config->conf.i2s;
+
+		memset(&i2s_cfg, 0, sizeof(i2s_cfg)); /* just to be safe  */
+
+		/* master/slave */
+		PORTCFG_I2S_SET_ROLE(i2s_cfg, mc_i2s_role(i2s->mode));
+
+		PORTCFG_I2S_SET_HALFPERIOD(i2s_cfg, i2s->half_period);
+		PORTCFG_I2S_SET_CHANNELS(i2s_cfg,
+			mc_i2s_channel_select(i2s->channel_sel));
+		PORTCFG_I2S_SET_SRATE(i2s_cfg,
+			mc_i2s_sample_rate(i2s->sample_rate));
+		switch (i2s->word_width) {
+		case WORD_WIDTH_16:
+			PORTCFG_I2S_SET_WORDLEN(i2s_cfg, CG2900_MC_I2S_WORD_16);
+			break;
+		case WORD_WIDTH_32:
+			PORTCFG_I2S_SET_WORDLEN(i2s_cfg, CG2900_MC_I2S_WORD_32);
+			break;
+		}
+
+		/* Store the new configuration */
+		mutex_lock(&info->management_mutex);
+		memcpy(&(info->i2s_config), &(config->conf.i2s),
+		       sizeof(config->conf.i2s));
+		info->i2s_config_known = true;
+		mutex_unlock(&info->management_mutex);
+
+		/* Send */
+		err = send_vs_port_cfg(audio_user, CG2900_MC_PORT_I2S,
+				       &i2s_cfg, sizeof(i2s_cfg));
+		break;
+
+	case PORT_1_I2S_PCM:
+		i2s_pcm = &config->conf.i2s_pcm;
+
+		memset(&pcm_cfg, 0, sizeof(pcm_cfg)); /* just to be safe  */
+
+		/* master/slave */
+		PORTCFG_PCM_SET_ROLE(pcm_cfg, mc_pcm_role(i2s_pcm->mode));
+
+		/* set direction for all 4 slots */
+		PORTCFG_PCM_SET_DIR(pcm_cfg, 0, i2s_pcm->slot_0_dir);
+		PORTCFG_PCM_SET_DIR(pcm_cfg, 1, i2s_pcm->slot_1_dir);
+		PORTCFG_PCM_SET_DIR(pcm_cfg, 2, i2s_pcm->slot_2_dir);
+		PORTCFG_PCM_SET_DIR(pcm_cfg, 3, i2s_pcm->slot_3_dir);
+
+		/* set used SCO slots, other use cases not supported atm */
+		PORTCFG_PCM_SET_SCO_USED(pcm_cfg, 0, i2s_pcm->slot_0_used);
+		PORTCFG_PCM_SET_SCO_USED(pcm_cfg, 1, i2s_pcm->slot_1_used);
+		PORTCFG_PCM_SET_SCO_USED(pcm_cfg, 2, i2s_pcm->slot_2_used);
+		PORTCFG_PCM_SET_SCO_USED(pcm_cfg, 3, i2s_pcm->slot_3_used);
+
+		/* slot starts */
+		pcm_cfg.slot_start[0] = i2s_pcm->slot_0_start;
+		pcm_cfg.slot_start[1] = i2s_pcm->slot_1_start;
+		pcm_cfg.slot_start[2] = i2s_pcm->slot_2_start;
+		pcm_cfg.slot_start[3] = i2s_pcm->slot_3_start;
+
+		/* audio/voice sample-rate ratio */
+		PORTCFG_PCM_SET_RATIO(pcm_cfg, i2s_pcm->ratio);
+
+		/* PCM or I2S mode */
+		PORTCFG_PCM_SET_MODE(pcm_cfg, i2s_pcm->protocol);
+
+		pcm_cfg.frame_len = i2s_pcm->duration;
+
+		PORTCFG_PCM_SET_BITCLK(pcm_cfg, i2s_pcm->clk);
+		PORTCFG_PCM_SET_SRATE(pcm_cfg,
+			mc_pcm_sample_rate(i2s_pcm->sample_rate));
+
+		/* Store the new configuration */
+		mutex_lock(&info->management_mutex);
+		memcpy(&(info->i2s_pcm_config), &(config->conf.i2s_pcm),
+		       sizeof(config->conf.i2s_pcm));
+		info->i2s_pcm_config_known = true;
+		mutex_unlock(&info->management_mutex);
+
+		/* Send */
+		err = send_vs_port_cfg(audio_user, CG2900_MC_PORT_PCM_I2S,
+				       &pcm_cfg, sizeof(pcm_cfg));
+		break;
+
+	default:
+		dev_err(BT_DEV, "Unknown port configuration %d\n",
+			config->port);
+		err = -EACCES;
+	};
+
+	mutex_unlock(&info->bt_mutex);
+	return err;
+}
+
+/**
+ * struct i2s_fm_stream_config_priv - Helper struct for stream i2s-fm streams.
+ * @fm_config:	FM endpoint configuration.
+ * @rx:		true for FM-RX, false for FM-TX.
+ */
+struct i2s_fm_stream_config_priv {
+	struct cg2900_endpoint_config_fm	*fm_config;
+	bool					rx;
+
+};
+
+/**
+ * config_i2s_fm_stream() - Callback for @send_vs_session_config.
+ * @info:	Audio info structure.
+ * @_priv:	Pointer to a @i2s_fm_stream_config_priv struct.
+ * @cfg:	Pointer to stream config block in command packet.
+ *
+ * Fills in stream configuration for I2S-FM RX/TX.
+ */
+
+static void config_i2s_fm_stream(struct audio_info *info, void *_priv,
+				 struct session_config_stream *cfg)
+{
+	struct i2s_fm_stream_config_priv *priv = _priv;
+	struct session_config_vport *fm;
+	struct session_config_vport *i2s;
+
+	cfg->media_type = CG2900_BT_SESSION_MEDIA_TYPE_AUDIO;
+
+	if (info->i2s_config.channel_sel == CHANNEL_SELECTION_BOTH)
+		SESSIONCFG_SET_CHANNELS(cfg, CG2900_BT_MEDIA_CONFIG_STEREO);
+	else
+		SESSIONCFG_SET_CHANNELS(cfg, CG2900_BT_MEDIA_CONFIG_MONO);
+
+	SESSIONCFG_I2S_SET_SRATE(cfg,
+		session_config_sample_rate(priv->fm_config->sample_rate));
+
+	cfg->codec_type = CG2900_CODEC_TYPE_NONE;
+	/* codec mode and parameters not used  */
+
+	if (priv->rx) {
+		fm  = &cfg->inport;  /* FM is input */
+		i2s = &cfg->outport; /* I2S is output */
+	} else {
+		i2s = &cfg->inport;  /* I2S is input */
+		fm  = &cfg->outport; /* FM is output */
+	}
+
+	fm->type = CG2900_BT_VP_TYPE_FM;
+
+	i2s->type = CG2900_BT_VP_TYPE_I2S;
+	i2s->i2s.index   = CG2900_BT_SESSION_I2S_INDEX_I2S;
+	i2s->i2s.channel = info->i2s_config.channel_sel;
+}
+
+/**
+ * conn_start_i2s_to_fm_rx() - Start an audio stream connecting FM RX to I2S.
+ * @audio_user:		Audio user to check for.
+ * @stream_handle:	[out] Pointer where to store the stream handle.
+ *
+ * This function sets up an FM RX to I2S stream.
+ * It does this by first setting the output mode and then the configuration of
+ * the External Sample Rate Converter.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -ENOMEM upon allocation errors.
+ *   -EIO for other errors.
+ */
+static int conn_start_i2s_to_fm_rx(struct audio_user *audio_user,
+				   unsigned int *stream_handle)
+{
+	int err = 0;
+	union cg2900_endpoint_config_union *fm_config;
+	struct audio_info *info = audio_user->info;
+
+	dev_dbg(FM_DEV, "conn_start_i2s_to_fm_rx\n");
+
+	fm_config = find_endpoint(ENDPOINT_FM_RX, &info->endpoints);
+	if (!fm_config) {
+		dev_err(FM_DEV, "FM RX not configured before stream start\n");
+		return -EIO;
+	}
+
+	if (!(info->i2s_config_known)) {
+		dev_err(FM_DEV,
+			"I2S DAI not configured before stream start\n");
+		return -EIO;
+	}
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any
+	 * time on each channel.
+	 */
+	mutex_lock(&info->fm_mutex);
+	mutex_lock(&info->bt_mutex);
+
+	/*
+	 * Now set the output mode of the External Sample Rate Converter by
+	 * sending HCI_Write command with AUP_EXT_SetMode.
+	 */
+	err = send_fm_write_1_param(audio_user,
+				    CG2900_FM_CMD_ID_AUP_EXT_SET_MODE,
+				    CG2900_FM_CMD_AUP_EXT_SET_MODE_PARALLEL);
+	if (err)
+		goto finished_unlock_mutex;
+
+	/*
+	 * Now configure the External Sample Rate Converter by sending
+	 * HCI_Write command with AUP_EXT_SetControl.
+	 */
+	err = send_fm_write_1_param(
+		audio_user, CG2900_FM_CMD_ID_AUP_EXT_SET_CTRL,
+		fm_get_conversion(fm_config->fm.sample_rate));
+	if (err)
+		goto finished_unlock_mutex;
+
+	/* Set up the stream */
+	if (info->revision == CHIP_REV_PG1) {
+		struct i2s_fm_stream_config_priv stream_priv;
+
+		/* Now send HCI_VS_Set_Session_Configuration command */
+		stream_priv.fm_config = &fm_config->fm;
+		stream_priv.rx = true;
+		err = send_vs_session_config(audio_user, config_i2s_fm_stream,
+					     &stream_priv);
+	} else {
+		struct mc_vs_port_cfg_fm fm_cfg;
+
+		memset(&fm_cfg, 0, sizeof(fm_cfg));
+
+		/* Configure port FM RX */
+		/* Expects 0-3 - same as user API - so no conversion needed */
+		PORTCFG_FM_SET_SRATE(fm_cfg, (u8)fm_config->fm.sample_rate);
+
+		err = send_vs_port_cfg(audio_user, CG2900_MC_PORT_FM_RX_1,
+				       &fm_cfg, sizeof(fm_cfg));
+		if (err)
+			goto finished_unlock_mutex;
+
+		/* CreateStream */
+		err = send_vs_create_stream(audio_user,
+					    CG2900_MC_PORT_FM_RX_1,
+					    CG2900_MC_PORT_I2S,
+					    0); /* chip doesn't care */
+	}
+
+	if (err < 0)
+		goto finished_unlock_mutex;
+
+	/* Store the stream handle (used for start and stop stream) */
+	*stream_handle = (u8)err;
+	dev_dbg(FM_DEV, "stream_handle set to %d\n", *stream_handle);
+
+	/* Now start the stream */
+	if (info->revision == CHIP_REV_PG1)
+		err = send_vs_session_ctrl(audio_user, *stream_handle,
+					   CG2900_BT_SESSION_START);
+	else
+		err = send_vs_stream_ctrl(audio_user, *stream_handle,
+					  CG2900_MC_STREAM_START);
+
+finished_unlock_mutex:
+	dev_dbg(FM_DEV, "New resp_state: IDLE\n");
+	audio_user->resp_state = IDLE;
+	mutex_unlock(&info->bt_mutex);
+	mutex_unlock(&info->fm_mutex);
+	return err;
+}
+
+/**
+ * conn_start_i2s_to_fm_tx() - Start an audio stream connecting FM TX to I2S.
+ * @audio_user:		Audio user to check for.
+ * @stream_handle:	[out] Pointer where to store the stream handle.
+ *
+ * This function sets up an I2S to FM TX stream.
+ * It does this by first setting the Audio Input source and then setting the
+ * configuration and input source of BT sample rate converter.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -ENOMEM upon allocation errors.
+ *   -EIO for other errors.
+ */
+static int conn_start_i2s_to_fm_tx(struct audio_user *audio_user,
+				   unsigned int *stream_handle)
+{
+	int err = 0;
+	union cg2900_endpoint_config_union *fm_config;
+	struct audio_info *info = audio_user->info;
+
+	dev_dbg(FM_DEV, "conn_start_i2s_to_fm_tx\n");
+
+	fm_config = find_endpoint(ENDPOINT_FM_TX, &info->endpoints);
+	if (!fm_config) {
+		dev_err(FM_DEV, "FM TX not configured before stream start\n");
+		return -EIO;
+	}
+
+	if (!(info->i2s_config_known)) {
+		dev_err(FM_DEV,
+			"I2S DAI not configured before stream start\n");
+		return -EIO;
+	}
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any time
+	 * on each channel.
+	 */
+	mutex_lock(&info->fm_mutex);
+	mutex_lock(&info->bt_mutex);
+
+	/*
+	 * Select Audio Input Source by sending HCI_Write command with
+	 * AIP_SetMode.
+	 */
+	dev_dbg(FM_DEV, "FM: AIP_SetMode\n");
+	err = send_fm_write_1_param(audio_user, CG2900_FM_CMD_ID_AIP_SET_MODE,
+				    CG2900_FM_CMD_AIP_SET_MODE_INPUT_DIG);
+	if (err)
+		goto finished_unlock_mutex;
+
+	/*
+	 * Now configure the BT sample rate converter by sending HCI_Write
+	 * command with AIP_BT_SetControl.
+	 */
+	dev_dbg(FM_DEV, "FM: AIP_BT_SetControl\n");
+	err = send_fm_write_1_param(
+		audio_user, CG2900_FM_CMD_ID_AIP_BT_SET_CTRL,
+		fm_get_conversion(fm_config->fm.sample_rate));
+	if (err)
+		goto finished_unlock_mutex;
+
+	/*
+	 * Now set input of the BT sample rate converter by sending HCI_Write
+	 * command with AIP_BT_SetMode.
+	 */
+	dev_dbg(FM_DEV, "FM: AIP_BT_SetMode\n");
+	err = send_fm_write_1_param(audio_user,
+				    CG2900_FM_CMD_ID_AIP_BT_SET_MODE,
+				    CG2900_FM_CMD_AIP_BT_SET_MODE_INPUT_PAR);
+	if (err)
+		goto finished_unlock_mutex;
+
+	/* Set up the stream */
+	if (info->revision == CHIP_REV_PG1) {
+		struct i2s_fm_stream_config_priv stream_priv;
+
+		/* Now send HCI_VS_Set_Session_Configuration command */
+		stream_priv.fm_config = &fm_config->fm;
+		stream_priv.rx = false;
+		err = send_vs_session_config(audio_user, config_i2s_fm_stream,
+					     &stream_priv);
+	} else {
+		struct mc_vs_port_cfg_fm fm_cfg;
+
+		memset(&fm_cfg, 0, sizeof(fm_cfg));
+
+		/* Configure port FM TX */
+		/* Expects 0-3 - same as user API - so no conversion needed */
+		PORTCFG_FM_SET_SRATE(fm_cfg, (u8)fm_config->fm.sample_rate);
+
+		err = send_vs_port_cfg(audio_user, CG2900_MC_PORT_FM_TX,
+				       &fm_cfg, sizeof(fm_cfg));
+		if (err)
+			goto finished_unlock_mutex;
+
+		/* CreateStream */
+		err = send_vs_create_stream(audio_user,
+					    CG2900_MC_PORT_I2S,
+					    CG2900_MC_PORT_FM_TX,
+					    0); /* chip doesn't care */
+	}
+
+	if (err < 0)
+		goto finished_unlock_mutex;
+
+	/* Store the stream handle (used for start and stop stream) */
+	*stream_handle = (u8)err;
+	dev_dbg(FM_DEV, "stream_handle set to %d\n", *stream_handle);
+
+	/* Now start the stream */
+	if (info->revision == CHIP_REV_PG1)
+		err = send_vs_session_ctrl(audio_user, *stream_handle,
+					   CG2900_BT_SESSION_START);
+	else
+		err = send_vs_stream_ctrl(audio_user, *stream_handle,
+					  CG2900_MC_STREAM_START);
+
+finished_unlock_mutex:
+	dev_dbg(FM_DEV, "New resp_state: IDLE\n");
+	audio_user->resp_state = IDLE;
+	mutex_unlock(&info->bt_mutex);
+	mutex_unlock(&info->fm_mutex);
+	return err;
+}
+
+/**
+ * config_pcm_sco_stream() - Callback for @send_vs_session_config.
+ * @info:	Audio info structure.
+ * @_priv:	Pointer to a @cg2900_endpoint_config_sco_in_out struct.
+ * @cfg:	Pointer to stream config block in command packet.
+ *
+ * Fills in stream configuration for PCM-SCO.
+ */
+static void config_pcm_sco_stream(struct audio_info *info, void *_priv,
+				  struct session_config_stream *cfg)
+{
+	struct cg2900_endpoint_config_sco_in_out *sco_ep = _priv;
+
+	cfg->media_type = CG2900_BT_SESSION_MEDIA_TYPE_AUDIO;
+
+	SESSIONCFG_SET_CHANNELS(cfg, CG2900_BT_MEDIA_CONFIG_MONO);
+	SESSIONCFG_I2S_SET_SRATE(cfg,
+		session_config_sample_rate(sco_ep->sample_rate));
+
+	cfg->codec_type = CG2900_CODEC_TYPE_NONE;
+	/* codec mode and parameters not used  */
+
+	cfg->inport.type = CG2900_BT_VP_TYPE_BT_SCO;
+	cfg->inport.sco.acl_handle = cpu_to_le16(DEFAULT_SCO_HANDLE);
+
+	cfg->outport.type = CG2900_BT_VP_TYPE_PCM;
+	cfg->outport.pcm.index = CG2900_BT_SESSION_PCM_INDEX_PCM_I2S;
+
+	SESSIONCFG_PCM_SET_USED(cfg->outport, 0,
+				info->i2s_pcm_config.slot_0_used);
+	SESSIONCFG_PCM_SET_USED(cfg->outport, 1,
+				info->i2s_pcm_config.slot_1_used);
+	SESSIONCFG_PCM_SET_USED(cfg->outport, 2,
+				info->i2s_pcm_config.slot_2_used);
+	SESSIONCFG_PCM_SET_USED(cfg->outport, 3,
+				info->i2s_pcm_config.slot_3_used);
+
+	cfg->outport.pcm.slot_start[0] =
+		info->i2s_pcm_config.slot_0_start;
+	cfg->outport.pcm.slot_start[1] =
+		info->i2s_pcm_config.slot_1_start;
+	cfg->outport.pcm.slot_start[2] =
+		info->i2s_pcm_config.slot_2_start;
+	cfg->outport.pcm.slot_start[3] =
+		info->i2s_pcm_config.slot_3_start;
+}
+
+/**
+ * conn_start_pcm_to_sco() - Start an audio stream connecting Bluetooth (e)SCO to PCM_I2S.
+ * @audio_user:		Audio user to check for.
+ * @stream_handle:	[out] Pointer where to store the stream handle.
+ *
+ * This function sets up a BT to_from PCM_I2S stream. It does this by
+ * first setting the Session configuration and then starting the Audio
+ * Stream.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -ENOMEM upon allocation errors.
+ *   Errors from @cg2900_write
+ *   -EIO for other errors.
+ */
+static int conn_start_pcm_to_sco(struct audio_user *audio_user,
+				 unsigned int *stream_handle)
+{
+	int err = 0;
+	union cg2900_endpoint_config_union *bt_config;
+	struct audio_info *info = audio_user->info;
+
+	dev_dbg(BT_DEV, "conn_start_pcm_to_sco\n");
+
+	bt_config = find_endpoint(ENDPOINT_BT_SCO_INOUT, &info->endpoints);
+	if (!bt_config) {
+		dev_err(BT_DEV, "BT not configured before stream start\n");
+		return -EIO;
+	}
+
+	if (!(info->i2s_pcm_config_known)) {
+		dev_err(BT_DEV,
+			"I2S_PCM DAI not configured before stream start\n");
+		return -EIO;
+	}
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any time on each
+	 * channel.
+	 */
+	mutex_lock(&info->bt_mutex);
+
+	/* Set up the stream */
+	if (info->revision == CHIP_REV_PG1) {
+		err = send_vs_session_config(audio_user, config_pcm_sco_stream,
+					     &bt_config->sco);
+	} else {
+		struct mc_vs_port_cfg_sco sco_cfg;
+
+		/* zero codec params etc */
+		memset(&sco_cfg, 0, sizeof(sco_cfg));
+		sco_cfg.acl_id = DEFAULT_SCO_HANDLE;
+		PORTCFG_SCO_SET_WBS(sco_cfg, 0); /* No WBS yet */
+		PORTCFG_SCO_SET_CODEC(sco_cfg, CG2900_CODEC_TYPE_NONE);
+
+		err = send_vs_port_cfg(audio_user, CG2900_MC_PORT_BT_SCO,
+				       &sco_cfg, sizeof(sco_cfg));
+		if (err)
+			goto finished_unlock_mutex;
+
+		/* CreateStream */
+		err = send_vs_create_stream(audio_user,
+					    CG2900_MC_PORT_PCM_I2S,
+					    CG2900_MC_PORT_BT_SCO,
+					    0); /* chip doesn't care */
+	}
+
+	if (err < 0)
+		goto finished_unlock_mutex;
+
+	/* Store the stream handle (used for start and stop stream) */
+	*stream_handle = (u8)err;
+	dev_dbg(BT_DEV, "stream_handle set to %d\n", *stream_handle);
+
+	/* Now start the stream by sending HCI_VS_Session_Control command */
+	err = send_vs_session_ctrl(audio_user, *stream_handle,
+				   CG2900_BT_SESSION_START);
+
+finished_unlock_mutex:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	audio_user->resp_state = IDLE;
+	mutex_unlock(&info->bt_mutex);
+	return err;
+}
+
+/**
+ * conn_stop_stream() - Stops an audio stream defined by @stream_handle.
+ * @audio_user:		Audio user to check for.
+ * @stream_handle:	Handle of the audio stream.
+ *
+ * This function is used to stop an audio stream defined by a stream
+ * handle. It does this by first stopping the stream and then
+ * resetting the session/stream.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -ENOMEM upon allocation errors.
+ *   Errors from @cg2900_write.
+ *   -EIO for other errors.
+ */
+static int conn_stop_stream(struct audio_user *audio_user,
+			    unsigned int stream_handle)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	u16 opcode;
+	struct audio_info *info = audio_user->info;
+	struct cg2900_user_data *pf_data = dev_get_platdata(info->dev_bt);
+	struct audio_cb_info *cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV, "conn_stop_stream handle %d\n", stream_handle);
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any
+	 * time on each channel.
+	 */
+	mutex_lock(&info->bt_mutex);
+
+	/* Now stop the stream */
+	if (info->revision == CHIP_REV_PG1)
+		err = send_vs_session_ctrl(audio_user, stream_handle,
+					   CG2900_BT_SESSION_STOP);
+	else
+		err = send_vs_stream_ctrl(audio_user, stream_handle,
+					  CG2900_MC_STREAM_STOP);
+	if (err)
+		goto finished_unlock_mutex;
+
+	/* Now delete the stream - format command... */
+	if (info->revision == CHIP_REV_PG1) {
+		struct bt_vs_reset_session_cfg_cmd *cmd;
+
+		dev_dbg(BT_DEV, "BT: HCI_VS_Reset_Session_Configuration\n");
+
+		skb = pf_data->alloc_skb(sizeof(*cmd), GFP_KERNEL);
+		if (!skb) {
+			dev_err(BT_DEV, "Could not allocate skb\n");
+			err = -ENOMEM;
+			goto finished_unlock_mutex;
+		}
+
+		cmd = (struct bt_vs_reset_session_cfg_cmd *)
+			skb_put(skb, sizeof(*cmd));
+
+		opcode = CG2900_BT_VS_RESET_SESSION_CONFIG;
+		cmd->opcode = cpu_to_le16(opcode);
+		cmd->plen   = BT_PARAM_LEN(sizeof(*cmd));
+		cmd->id     = (u8)stream_handle;
+	} else {
+		struct mc_vs_delete_stream_cmd *cmd;
+
+		dev_dbg(BT_DEV, "BT: HCI_VS_Delete_Stream\n");
+
+		skb = pf_data->alloc_skb(sizeof(*cmd), GFP_KERNEL);
+		if (!skb) {
+			dev_err(BT_DEV, "Could not allocate skb\n");
+			err = -ENOMEM;
+			goto finished_unlock_mutex;
+		}
+
+		cmd = (struct mc_vs_delete_stream_cmd *)
+			skb_put(skb, sizeof(*cmd));
+
+		opcode = CG2900_MC_VS_DELETE_STREAM;
+		cmd->opcode = cpu_to_le16(opcode);
+		cmd->plen   = BT_PARAM_LEN(sizeof(*cmd));
+		cmd->stream = (u8)stream_handle;
+	}
+
+	/* ...and send it */
+	cb_info->user = audio_user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	audio_user->resp_state = WAITING;
+
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		goto error_handling_free_skb;
+	}
+
+	/* wait for response */
+	if (info->revision == CHIP_REV_PG1) {
+		err = receive_bt_cmd_complete(audio_user, opcode, NULL, 0);
+	} else {
+		u8 vs_err;
+
+		/* All commands in PG2 API returns one byte extra status */
+		err = receive_bt_cmd_complete(audio_user, opcode,
+					      &vs_err, sizeof(vs_err));
+
+		if (err)
+			dev_err(BT_DEV,
+				"VS_DELETE_STREAM - failed with error 0x%02X\n",
+				vs_err);
+		else
+			release_stream_id(info, stream_handle);
+
+	}
+
+	goto finished_unlock_mutex;
+
+error_handling_free_skb:
+	kfree_skb(skb);
+finished_unlock_mutex:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	audio_user->resp_state = IDLE;
+	mutex_unlock(&info->bt_mutex);
+	return err;
+}
+
+/**
+ * cg2900_audio_get_devices() - Returns connected CG2900 Audio devices.
+ * @devices:	Array of CG2900 Audio devices.
+ * @size:	Max number of devices in array.
+ *
+ * Returns:
+ *   0 if no devices exist.
+ *   > 0 is the number of devices inserted in the list.
+ *   -EINVAL upon bad input parameter.
+ */
+int cg2900_audio_get_devices(struct device *devices[], __u8 size)
+{
+	struct list_head *cursor;
+	struct audio_info *tmp;
+	int i = 0;
+
+	if (!size) {
+		pr_err("No space to insert devices into list\n");
+		return 0;
+	}
+
+	if (!devices) {
+		pr_err("NULL submitted as devices array\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Go through and store the devices. If NULL is supplied for dev
+	 * just return first device found.
+	 */
+	list_for_each(cursor, &cg2900_audio_devices) {
+		tmp = list_entry(cursor, struct audio_info, list);
+		devices[i] = tmp->parent;
+		i++;
+		if (i == size)
+			break;
+	}
+	return i;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_get_devices);
+
+/**
+ * cg2900_audio_open() - Opens a session to the ST-Ericsson CG2900 Audio control interface.
+ * @session:	[out] Address where to store the session identifier.
+ *		Allocated by caller, must not be NULL.
+ * @parent:	Parent device representing the CG2900 controller connected.
+ *		If NULL is supplied the first available device is used.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EACCES if no info structure can be found.
+ *   -EINVAL upon bad input parameter.
+ *   -ENOMEM upon allocation failure.
+ *   -EMFILE if no more user session could be opened.
+ *   -EIO upon failure to register to CG2900.
+ *   Error codes from get_info.
+ */
+int cg2900_audio_open(unsigned int *session, struct device *parent)
+{
+	int err = 0;
+	int i;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data_bt;
+	struct cg2900_user_data *pf_data_fm;
+
+	pr_debug("cg2900_audio_open");
+
+	info = get_info(parent);
+	if (!info) {
+		pr_err("No audio info exist");
+		return -EACCES;
+	} else if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	if (!session) {
+		pr_err("NULL supplied as session");
+		return -EINVAL;
+	}
+
+	mutex_lock(&info->management_mutex);
+
+	*session = 0;
+
+	/*
+	 * First find a free session to use and allocate the session structure.
+	 */
+	for (i = FIRST_USER;
+	     i < MAX_NBR_OF_USERS && cg2900_audio_sessions[i];
+	     i++)
+		; /* Just loop until found or end reached */
+
+	if (i >= MAX_NBR_OF_USERS) {
+		pr_err("Couldn't find free user");
+		err = -EMFILE;
+		goto finished;
+	}
+
+	cg2900_audio_sessions[i] =
+		kzalloc(sizeof(*(cg2900_audio_sessions[0])), GFP_KERNEL);
+	if (!cg2900_audio_sessions[i]) {
+		pr_err("Could not allocate user");
+		err = -ENOMEM;
+		goto finished;
+	}
+	pr_debug("Found free session %d", i);
+	*session = i;
+	info->nbr_of_users_active++;
+
+	cg2900_audio_sessions[*session]->resp_state = IDLE;
+	cg2900_audio_sessions[*session]->session = *session;
+	cg2900_audio_sessions[*session]->info = info;
+
+	pf_data_bt = dev_get_platdata(info->dev_bt);
+	pf_data_fm = dev_get_platdata(info->dev_fm);
+
+	if (info->nbr_of_users_active == 1) {
+		struct cg2900_rev_data rev_data;
+
+		/*
+		 * First user so register to CG2900 Core.
+		 * First the BT audio device.
+		 */
+		err = pf_data_bt->open(pf_data_bt);
+		if (err) {
+			dev_err(BT_DEV, "Failed to open BT audio channel\n");
+			goto error_handling;
+		}
+
+		/* Then the FM audio device */
+		err = pf_data_fm->open(pf_data_fm);
+		if (err) {
+			dev_err(FM_DEV, "Failed to open FM audio channel\n");
+			goto error_handling;
+		}
+
+		/* Read chip revision data */
+		if (!pf_data_bt->get_local_revision(pf_data_bt, &rev_data)) {
+			pr_err("Couldn't retrieve revision data");
+			err = -EIO;
+			goto error_handling;
+		}
+
+		/* Decode revision data */
+		switch (rev_data.revision) {
+		case CG2900_PG1_REV:
+		case CG2900_PG1_SPECIAL_REV:
+			info->revision = CHIP_REV_PG1;
+			break;
+
+		case CG2900_PG2_REV:
+			info->revision = CHIP_REV_PG2;
+			break;
+
+		default:
+			pr_err("Chip rev 0x%04X sub 0x%04X not supported",
+			       rev_data.revision, rev_data.sub_version);
+			err = -EIO;
+			goto error_handling;
+		}
+
+		info->state = OPENED;
+	}
+
+	pr_info("Session %d opened", *session);
+
+	goto finished;
+
+error_handling:
+	if (pf_data_fm->opened)
+		pf_data_fm->close(pf_data_fm);
+	if (pf_data_bt->opened)
+		pf_data_bt->close(pf_data_bt);
+	info->nbr_of_users_active--;
+	kfree(cg2900_audio_sessions[*session]);
+	cg2900_audio_sessions[*session] = NULL;
+finished:
+	mutex_unlock(&info->management_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_open);
+
+/**
+ * cg2900_audio_close() - Closes an opened session to the ST-Ericsson CG2900 audio control interface.
+ * @session:	[in_out] Pointer to session identifier to close.
+ *		Will be 0 after this call.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter.
+ *   -EIO if driver has not been opened.
+ *   -EACCES if session has not opened.
+ */
+int cg2900_audio_close(unsigned int *session)
+{
+	int err = 0;
+	struct audio_user *audio_user;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data_bt;
+	struct cg2900_user_data *pf_data_fm;
+
+	pr_debug("cg2900_audio_close");
+
+	if (!session) {
+		pr_err("NULL pointer supplied");
+		return -EINVAL;
+	}
+
+	audio_user = get_session_user(*session);
+	if (!audio_user) {
+		pr_err("Invalid session ID");
+		return -EINVAL;
+	}
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	mutex_lock(&info->management_mutex);
+
+	pf_data_bt = dev_get_platdata(info->dev_bt);
+	pf_data_fm = dev_get_platdata(info->dev_fm);
+
+	if (!cg2900_audio_sessions[*session]) {
+		dev_err(BT_DEV, "Session %d not opened\n", *session);
+		err = -EACCES;
+		goto err_unlock_mutex;
+	}
+
+	kfree(cg2900_audio_sessions[*session]);
+	cg2900_audio_sessions[*session] = NULL;
+
+	info->nbr_of_users_active--;
+	if (info->nbr_of_users_active == 0) {
+		/* No more sessions open. Close channels */
+		pf_data_fm->close(pf_data_fm);
+		pf_data_bt->close(pf_data_bt);
+		info->state = CLOSED;
+	}
+
+	dev_info(BT_DEV, "Session %d closed\n", *session);
+
+	*session = 0;
+
+err_unlock_mutex:
+	mutex_unlock(&info->management_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_close);
+
+/**
+ * cg2900_audio_set_dai_config() -  Sets the Digital Audio Interface configuration.
+ * @session:	Session identifier this call is related to.
+ * @config:	Pointer to the configuration to set.
+ *		Allocated by caller, must not be NULL.
+ *
+ * Sets the Digital Audio Interface (DAI) configuration. The DAI is the external
+ * interface between the combo chip and the platform.
+ * For example the PCM or I2S interface.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter.
+ *   -EIO if driver has not been opened.
+ *   -ENOMEM upon allocation failure.
+ *   -EACCES if trying to set unsupported configuration.
+ *   Errors from @receive_bt_cmd_complete.
+ */
+int cg2900_audio_set_dai_config(unsigned int session,
+				struct cg2900_dai_config *config)
+{
+	int err = 0;
+	struct audio_user *audio_user;
+	struct audio_info *info;
+
+	pr_debug("cg2900_audio_set_dai_config session %d", session);
+
+	audio_user = get_session_user(session);
+	if (!audio_user)
+		return -EINVAL;
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	/* Different commands are used for PG1 and PG2 */
+	if (info->revision == CHIP_REV_PG1)
+		err = set_dai_config_pg1(audio_user, config);
+	else if (info->revision == CHIP_REV_PG2)
+		err = set_dai_config_pg2(audio_user, config);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_set_dai_config);
+
+/**
+ * cg2900_audio_get_dai_config() - Gets the current Digital Audio Interface configuration.
+ * @session:	Session identifier this call is related to.
+ * @config:	[out] Pointer to the configuration to get.
+ *		Allocated by caller, must not be NULL.
+ *
+ * Gets the current Digital Audio Interface configuration. Currently this method
+ * can only be called after some one has called
+ * cg2900_audio_set_dai_config(), there is today no way of getting
+ * the static settings file parameters from this method.
+ * Note that the @port parameter within @config must be set when calling this
+ * function so that the ST-Ericsson CG2900 Audio driver will know which
+ * configuration to return.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter.
+ *   -EIO if driver has not been opened or configuration has not been set.
+ */
+int cg2900_audio_get_dai_config(unsigned int session,
+				struct cg2900_dai_config *config)
+{
+	int err = 0;
+	struct audio_user *audio_user;
+	struct audio_info *info;
+
+	pr_debug("cg2900_audio_get_dai_config session %d", session);
+
+	if (!config) {
+		pr_err("NULL supplied as config structure");
+		return -EINVAL;
+	}
+
+	audio_user = get_session_user(session);
+	if (!audio_user)
+		return -EINVAL;
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	/*
+	 * Return DAI configuration based on the received port.
+	 * If port has not been configured return error.
+	 */
+	switch (config->port) {
+	case PORT_0_I2S:
+		mutex_lock(&info->management_mutex);
+		if (info->i2s_config_known)
+			memcpy(&config->conf.i2s,
+			       &info->i2s_config,
+			       sizeof(config->conf.i2s));
+		else
+			err = -EIO;
+		mutex_unlock(&info->management_mutex);
+		break;
+
+	case PORT_1_I2S_PCM:
+		mutex_lock(&info->management_mutex);
+		if (info->i2s_pcm_config_known)
+			memcpy(&config->conf.i2s_pcm,
+			       &info->i2s_pcm_config,
+			       sizeof(config->conf.i2s_pcm));
+		else
+			err = -EIO;
+		mutex_unlock(&info->management_mutex);
+		break;
+
+	default:
+		dev_err(BT_DEV, "Unknown port configuration %d\n",
+			config->port);
+		err = -EIO;
+		break;
+	};
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_get_dai_config);
+
+/**
+ * cg2900_audio_config_endpoint() - Configures one endpoint in the combo chip's audio system.
+ * @session:	Session identifier this call is related to.
+ * @config:	Pointer to the endpoint's configuration structure.
+ *
+ * Configures one endpoint in the combo chip's audio system.
+ * Supported @endpoint_id values are:
+ *  * ENDPOINT_BT_SCO_INOUT
+ *  * ENDPOINT_BT_A2DP_SRC
+ *  * ENDPOINT_FM_RX
+ *  * ENDPOINT_FM_TX
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter.
+ *   -EIO if driver has not been opened.
+ *   -EACCES if supplied cg2900_dai_config struct contains not supported
+ *   endpoint_id.
+ */
+int cg2900_audio_config_endpoint(unsigned int session,
+				 struct cg2900_endpoint_config *config)
+{
+	struct audio_user *audio_user;
+	struct audio_info *info;
+
+	dev_dbg(BT_DEV, "cg2900_audio_config_endpoint\n");
+
+	if (!config) {
+		pr_err("NULL supplied as configuration structure");
+		return -EINVAL;
+	}
+
+	audio_user = get_session_user(session);
+	if (!audio_user)
+		return -EINVAL;
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	switch (config->endpoint_id) {
+	case ENDPOINT_BT_SCO_INOUT:
+	case ENDPOINT_BT_A2DP_SRC:
+	case ENDPOINT_FM_RX:
+	case ENDPOINT_FM_TX:
+		add_endpoint(config, &info->endpoints);
+		break;
+
+	case ENDPOINT_PORT_0_I2S:
+	case ENDPOINT_PORT_1_I2S_PCM:
+	case ENDPOINT_SLIMBUS_VOICE:
+	case ENDPOINT_SLIMBUS_AUDIO:
+	case ENDPOINT_BT_A2DP_SNK:
+	case ENDPOINT_ANALOG_OUT:
+	case ENDPOINT_DSP_AUDIO_IN:
+	case ENDPOINT_DSP_AUDIO_OUT:
+	case ENDPOINT_DSP_VOICE_IN:
+	case ENDPOINT_DSP_VOICE_OUT:
+	case ENDPOINT_DSP_TONE_IN:
+	case ENDPOINT_BURST_BUFFER_IN:
+	case ENDPOINT_BURST_BUFFER_OUT:
+	case ENDPOINT_MUSIC_DECODER:
+	case ENDPOINT_HCI_AUDIO_IN:
+	default:
+		dev_err(BT_DEV, "Unsupported endpoint_id %d\n",
+			config->endpoint_id);
+		return -EACCES;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_config_endpoint);
+
+static bool is_dai_port(enum cg2900_audio_endpoint_id ep)
+{
+	/* These are the only supported ones */
+	return (ep == ENDPOINT_PORT_0_I2S) || (ep == ENDPOINT_PORT_1_I2S_PCM);
+}
+
+/**
+ * cg2900_audio_start_stream() - Connects two endpoints and starts the audio stream.
+ * @session:		Session identifier this call is related to.
+ * @ep_1:		One of the endpoints, no relation to direction or role.
+ * @ep_2:		The other endpoint, no relation to direction or role.
+ * @stream_handle:	Pointer where to store the stream handle.
+ *			Allocated by caller, must not be NULL.
+ *
+ * Connects two endpoints and starts the audio stream.
+ * Note that the endpoints need to be configured before the stream is started;
+ * DAI endpoints, such as ENDPOINT_PORT_0_I2S, are
+ * configured through @cg2900_audio_set_dai_config() while other
+ * endpoints are configured through @cg2900_audio_config_endpoint().
+ *
+ * Supported @endpoint_id values are:
+ *  * ENDPOINT_PORT_0_I2S
+ *  * ENDPOINT_PORT_1_I2S_PCM
+ *  * ENDPOINT_BT_SCO_INOUT
+ *  * ENDPOINT_FM_RX
+ *  * ENDPOINT_FM_TX
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter or unsupported configuration.
+ *   -EIO if driver has not been opened.
+ *   Errors from @conn_start_i2s_to_fm_rx, @conn_start_i2s_to_fm_tx, and
+ *   @conn_start_pcm_to_sco.
+ */
+int cg2900_audio_start_stream(unsigned int session,
+			      enum cg2900_audio_endpoint_id ep_1,
+			      enum cg2900_audio_endpoint_id ep_2,
+			      unsigned int *stream_handle)
+{
+	int err;
+	struct audio_user *audio_user;
+	struct audio_info *info;
+
+	pr_debug("cg2900_audio_start_stream session %d ep_1 %d ep_2 %d",
+		 session, ep_1, ep_2);
+
+	audio_user = get_session_user(session);
+	if (!audio_user)
+		return -EINVAL;
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	/* Put digital interface in ep_1 to simplify comparison below */
+	if (!is_dai_port(ep_1)) {
+		/* Swap endpoints */
+		enum cg2900_audio_endpoint_id t = ep_1;
+		ep_1 = ep_2;
+		ep_2 = t;
+	}
+
+	if (ep_1 == ENDPOINT_PORT_1_I2S_PCM && ep_2 == ENDPOINT_BT_SCO_INOUT) {
+		err = conn_start_pcm_to_sco(audio_user, stream_handle);
+	} else if (ep_1 == ENDPOINT_PORT_0_I2S && ep_2 == ENDPOINT_FM_RX) {
+		err = conn_start_i2s_to_fm_rx(audio_user, stream_handle);
+	} else if (ep_1 == ENDPOINT_PORT_0_I2S && ep_2 == ENDPOINT_FM_TX) {
+		err = conn_start_i2s_to_fm_tx(audio_user, stream_handle);
+	} else {
+		dev_err(BT_DEV, "Endpoint config not handled: ep1: %d, "
+			"ep2: %d\n", ep_1, ep_2);
+		err = -EINVAL;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_start_stream);
+
+/**
+ * cg2900_audio_stop_stream() - Stops a stream and disconnects the endpoints.
+ * @session:		Session identifier this call is related to.
+ * @stream_handle:	Handle to the stream to stop.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter.
+ *   -EIO if driver has not been opened.
+ */
+int cg2900_audio_stop_stream(unsigned int session, unsigned int stream_handle)
+{
+	struct audio_user *audio_user;
+	struct audio_info *info;
+
+	pr_debug("cg2900_audio_stop_stream handle %d", stream_handle);
+
+	audio_user = get_session_user(session);
+	if (!audio_user)
+		return -EINVAL;
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	return conn_stop_stream(audio_user, stream_handle);
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_stop_stream);
+
+/**
+ * audio_dev_open() - Open char device.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENOMEM if allocation failed.
+ *   Errors from @cg2900_audio_open.
+ */
+static int audio_dev_open(struct inode *inode, struct file *filp)
+{
+	int err;
+	struct char_dev_info *char_dev_info;
+	int minor;
+	struct audio_info *info = NULL;
+	struct audio_info *tmp;
+	struct list_head *cursor;
+
+	pr_debug("audio_dev_open");
+
+	minor = iminor(inode);
+
+	/* Find the info struct for this file */
+	list_for_each(cursor, &cg2900_audio_devices) {
+		tmp = list_entry(cursor, struct audio_info, list);
+		if (tmp->misc_dev.minor == minor) {
+			info = tmp;
+			break;
+		}
+	}
+	if (!info) {
+		pr_err("Could not identify device in inode");
+		return -EINVAL;
+	}
+
+	/*
+	 * Allocate the char dev info structure. It will be stored inside
+	 * the file pointer and supplied when file_ops are called.
+	 * It's free'd in audio_dev_release.
+	 */
+	char_dev_info = kzalloc(sizeof(*char_dev_info), GFP_KERNEL);
+	if (!char_dev_info) {
+		dev_err(BT_DEV, "Couldn't allocate char_dev_info\n");
+		return -ENOMEM;
+	}
+	filp->private_data = char_dev_info;
+	char_dev_info->info = info;
+
+	mutex_init(&char_dev_info->management_mutex);
+	mutex_init(&char_dev_info->rw_mutex);
+	skb_queue_head_init(&char_dev_info->rx_queue);
+
+	mutex_lock(&char_dev_info->management_mutex);
+	err = cg2900_audio_open(&char_dev_info->session, info->dev_bt->parent);
+	mutex_unlock(&char_dev_info->management_mutex);
+	if (err) {
+		dev_err(BT_DEV, "Failed to open CG2900 Audio driver (%d)\n",
+			err);
+		goto error_handling_free_mem;
+	}
+
+	return 0;
+
+error_handling_free_mem:
+	kfree(char_dev_info);
+	filp->private_data = NULL;
+	return err;
+}
+
+/**
+ * audio_dev_release() - Release char device.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EBADF if NULL pointer was supplied in private data.
+ *   Errors from @cg2900_audio_close.
+ */
+static int audio_dev_release(struct inode *inode, struct file *filp)
+{
+	int err = 0;
+	struct char_dev_info *dev = filp->private_data;
+	struct audio_info *info = dev->info;
+
+	dev_dbg(BT_DEV, "audio_dev_release\n");
+
+	mutex_lock(&dev->management_mutex);
+	err = cg2900_audio_close(&dev->session);
+	if (err)
+		/*
+		 * Just print the error. Still free the char_dev_info since we
+		 * don't know the filp structure is valid after this call
+		 */
+		dev_err(BT_DEV, "Error %d when closing CG2900 audio driver\n",
+			err);
+
+	mutex_unlock(&dev->management_mutex);
+
+	kfree(dev);
+	filp->private_data = NULL;
+
+	return err;
+}
+
+/**
+ * audio_dev_read() - Return information to the user from last @write call.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Received buffer.
+ * @count:	Size of buffer.
+ * @f_pos:	Position in buffer.
+ *
+ * The audio_dev_read() function returns information from
+ * the last @write call to same char device.
+ * The data is in the following format:
+ *   * OpCode of command for this data
+ *   * Data content (Length of data is determined by the command OpCode, i.e.
+ *     fixed for each command)
+ *
+ * Returns:
+ *   Bytes successfully read (could be 0).
+ *   -EBADF if NULL pointer was supplied in private data.
+ *   -EFAULT if copy_to_user fails.
+ *   -ENOMEM upon allocation failure.
+ */
+static ssize_t audio_dev_read(struct file *filp, char __user *buf, size_t count,
+			      loff_t *f_pos)
+{
+	struct char_dev_info *dev = filp->private_data;
+	struct audio_info *info = dev->info;
+	unsigned int bytes_to_copy;
+	int err = 0;
+	struct sk_buff *skb;
+
+	dev_dbg(BT_DEV, "audio_dev_read count %d\n", count);
+
+	mutex_lock(&dev->rw_mutex);
+
+	skb = skb_dequeue(&dev->rx_queue);
+	if (!skb) {
+		/* No data to read */
+		bytes_to_copy = 0;
+		goto finished;
+	}
+
+	bytes_to_copy = min(count, (unsigned int)(skb->len));
+
+	err = copy_to_user(buf, skb->data, bytes_to_copy);
+	if (err) {
+		dev_err(BT_DEV, "copy_to_user error %d\n", err);
+		skb_queue_head(&dev->rx_queue, skb);
+		err = -EFAULT;
+		goto error_handling;
+	}
+
+	skb_pull(skb, bytes_to_copy);
+
+	if (skb->len > 0)
+		skb_queue_head(&dev->rx_queue, skb);
+	else
+		kfree_skb(skb);
+
+	goto finished;
+
+error_handling:
+	mutex_unlock(&dev->rw_mutex);
+	return (ssize_t)err;
+finished:
+	mutex_unlock(&dev->rw_mutex);
+	return bytes_to_copy;
+}
+
+/**
+ * audio_dev_write() - Call CG2900 Audio API function.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Write buffer.
+ * @count:	Size of the buffer write.
+ * @f_pos:	Position of buffer.
+ *
+ * audio_dev_write() function executes supplied data and
+ * interprets it as if it was a function call to the CG2900 Audio API.
+ * The data is according to:
+ *   * OpCode (4 bytes, see API).
+ *   * Data according to OpCode (see API). No padding between parameters.
+ *
+ * Returns:
+ *   Bytes successfully written (could be 0). Equals input @count if successful.
+ *   -EBADF if NULL pointer was supplied in private data.
+ *   -EFAULT if copy_from_user fails.
+ *   Error codes from all CG2900 Audio API functions.
+ */
+static ssize_t audio_dev_write(struct file *filp, const char __user *buf,
+			       size_t count, loff_t *f_pos)
+{
+	u8 *rec_data;
+	struct char_dev_info *dev = filp->private_data;
+	struct audio_info *info;
+	int err = 0;
+	int op_code = 0;
+	u8 *curr_data;
+	unsigned int stream_handle;
+	struct cg2900_dai_config dai_config;
+	struct cg2900_endpoint_config ep_config;
+	enum cg2900_audio_endpoint_id ep_1;
+	enum cg2900_audio_endpoint_id ep_2;
+	int bytes_left = count;
+
+	pr_debug("audio_dev_write count %d", count);
+
+	if (!dev) {
+		pr_err("No dev supplied in private data");
+		return -EBADF;
+	}
+	info = dev->info;
+
+	rec_data = kmalloc(count, GFP_KERNEL);
+	if (!rec_data) {
+		dev_err(BT_DEV, "kmalloc failed (%d bytes)\n", count);
+		return -ENOMEM;
+	}
+
+	mutex_lock(&dev->rw_mutex);
+
+	err = copy_from_user(rec_data, buf, count);
+	if (err) {
+		dev_err(BT_DEV, "copy_from_user failed (%d)\n", err);
+		err = -EFAULT;
+		goto finished_mutex_unlock;
+	}
+
+	/* Initialize temporary data pointer used to traverse the packet */
+	curr_data = rec_data;
+
+	op_code = curr_data[0];
+	/* OpCode is int size to keep data int aligned */
+	curr_data += sizeof(unsigned int);
+	bytes_left -= sizeof(unsigned int);
+
+	switch (op_code) {
+	case CG2900_OPCODE_SET_DAI_CONF:
+		if (bytes_left < sizeof(dai_config)) {
+			dev_err(BT_DEV, "Not enough data supplied for "
+				"CG2900_OPCODE_SET_DAI_CONF\n");
+			err = -EINVAL;
+			goto finished_mutex_unlock;
+		}
+		memcpy(&dai_config, curr_data, sizeof(dai_config));
+		dev_dbg(BT_DEV, "CG2900_OPCODE_SET_DAI_CONF port %d\n",
+			dai_config.port);
+		err = cg2900_audio_set_dai_config(dev->session, &dai_config);
+		break;
+
+	case CG2900_OPCODE_GET_DAI_CONF:
+		if (bytes_left < sizeof(dai_config)) {
+			dev_err(BT_DEV, "Not enough data supplied for "
+				"CG2900_OPCODE_GET_DAI_CONF\n");
+			err = -EINVAL;
+			goto finished_mutex_unlock;
+		}
+		/*
+		 * Only need to copy the port really, but let's copy
+		 * like this for simplicity. It's only test functionality
+		 * after all.
+		 */
+		memcpy(&dai_config, curr_data, sizeof(dai_config));
+		dev_dbg(BT_DEV, "CG2900_OPCODE_GET_DAI_CONF port %d\n",
+			dai_config.port);
+		err = cg2900_audio_get_dai_config(dev->session, &dai_config);
+		if (!err) {
+			int len;
+			struct sk_buff *skb;
+
+			/*
+			 * Command succeeded. Store data so it can be returned
+			 * when calling read.
+			 */
+			len = sizeof(op_code) + sizeof(dai_config);
+			skb = alloc_skb(len, GFP_KERNEL);
+			if (!skb) {
+				dev_err(BT_DEV, "CG2900_OPCODE_GET_DAI_CONF: "
+						"Could not allocate skb\n");
+				err = -ENOMEM;
+				goto finished_mutex_unlock;
+			}
+			memcpy(skb_put(skb, sizeof(op_code)), &op_code,
+			       sizeof(op_code));
+			memcpy(skb_put(skb, sizeof(dai_config)),
+			       &dai_config, sizeof(dai_config));
+			skb_queue_tail(&dev->rx_queue, skb);
+		}
+		break;
+
+	case CG2900_OPCODE_CONFIGURE_ENDPOINT:
+		if (bytes_left < sizeof(ep_config)) {
+			dev_err(BT_DEV, "Not enough data supplied for "
+				"CG2900_OPCODE_CONFIGURE_ENDPOINT\n");
+			err = -EINVAL;
+			goto finished_mutex_unlock;
+		}
+		memcpy(&ep_config, curr_data, sizeof(ep_config));
+		dev_dbg(BT_DEV, "CG2900_OPCODE_CONFIGURE_ENDPOINT ep_id %d\n",
+			ep_config.endpoint_id);
+		err = cg2900_audio_config_endpoint(dev->session, &ep_config);
+		break;
+
+	case CG2900_OPCODE_START_STREAM:
+		if (bytes_left < (sizeof(ep_1) + sizeof(ep_2))) {
+			dev_err(BT_DEV, "Not enough data supplied for "
+				"CG2900_OPCODE_START_STREAM\n");
+			err = -EINVAL;
+			goto finished_mutex_unlock;
+		}
+		memcpy(&ep_1, curr_data, sizeof(ep_1));
+		curr_data += sizeof(ep_1);
+		memcpy(&ep_2, curr_data, sizeof(ep_2));
+		dev_dbg(BT_DEV, "CG2900_OPCODE_START_STREAM ep_1 %d ep_2 %d\n",
+			ep_1, ep_2);
+
+		err = cg2900_audio_start_stream(dev->session,
+			ep_1, ep_2, &stream_handle);
+		if (!err) {
+			int len;
+			struct sk_buff *skb;
+
+			/*
+			 * Command succeeded. Store data so it can be returned
+			 * when calling read.
+			 */
+			len = sizeof(op_code) + sizeof(stream_handle);
+			skb = alloc_skb(len, GFP_KERNEL);
+			if (!skb) {
+				dev_err(BT_DEV, "CG2900_OPCODE_START_STREAM: "
+						"Could not allocate skb\n");
+				err = -ENOMEM;
+				goto finished_mutex_unlock;
+			}
+			memcpy(skb_put(skb, sizeof(op_code)), &op_code,
+			       sizeof(op_code));
+			memcpy(skb_put(skb, sizeof(stream_handle)),
+			       &dai_config, sizeof(stream_handle));
+			skb_queue_tail(&dev->rx_queue, skb);
+
+			dev_dbg(BT_DEV, "stream_handle %d\n", stream_handle);
+		}
+		break;
+
+	case CG2900_OPCODE_STOP_STREAM:
+		if (bytes_left < sizeof(stream_handle)) {
+			dev_err(BT_DEV, "Not enough data supplied for "
+				"CG2900_OPCODE_STOP_STREAM\n");
+			err = -EINVAL;
+			goto finished_mutex_unlock;
+		}
+		memcpy(&stream_handle, curr_data, sizeof(stream_handle));
+		dev_dbg(BT_DEV, "CG2900_OPCODE_STOP_STREAM stream_handle %d\n",
+			stream_handle);
+		err = cg2900_audio_stop_stream(dev->session, stream_handle);
+		break;
+
+	default:
+		dev_err(BT_DEV, "Received bad op_code %d\n", op_code);
+		break;
+	};
+
+finished_mutex_unlock:
+	kfree(rec_data);
+	mutex_unlock(&dev->rw_mutex);
+
+	if (err)
+		return err;
+	else
+		return count;
+}
+
+/**
+ * audio_dev_poll() - Handle POLL call to the interface.
+ * @filp:	Pointer to the file struct.
+ * @wait:	Poll table supplied to caller.
+ *
+ * This function is used by the User Space application to see if the device is
+ * still open and if there is any data available for reading.
+ *
+ * Returns:
+ *   Mask of current set POLL values.
+ */
+static unsigned int audio_dev_poll(struct file *filp, poll_table *wait)
+{
+	struct char_dev_info *dev = filp->private_data;
+	struct audio_info *info;
+	unsigned int mask = 0;
+
+	if (!dev) {
+		pr_err("No dev supplied in private data");
+		return POLLERR | POLLRDHUP;
+	}
+	info = dev->info;
+
+	if (RESET == info->state)
+		mask |= POLLERR | POLLRDHUP | POLLPRI;
+	else
+		/* Unless RESET we can transmit */
+		mask |= POLLOUT;
+
+	if (!skb_queue_empty(&dev->rx_queue))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+static const struct file_operations char_dev_fops = {
+	.open = audio_dev_open,
+	.release = audio_dev_release,
+	.read = audio_dev_read,
+	.write = audio_dev_write,
+	.poll = audio_dev_poll
+};
+
+/**
+ * probe_common() - Register misc device.
+ * @info:	Audio info structure.
+ * @dev:	Current device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENOMEM if allocation fails.
+ *   Error codes from misc_register.
+ */
+static int probe_common(struct audio_info *info, struct device *dev)
+{
+	struct audio_cb_info *cb_info;
+	struct cg2900_user_data *pf_data;
+	int err;
+
+	cb_info = kzalloc(sizeof(*cb_info), GFP_KERNEL);
+	if (!cb_info) {
+		dev_err(dev, "Failed to allocate cb_info\n");
+		return -ENOMEM;
+	}
+	init_waitqueue_head(&cb_info->wq);
+	skb_queue_head_init(&cb_info->skb_queue);
+
+	pf_data = dev_get_platdata(dev);
+	cg2900_set_usr(pf_data, cb_info);
+	pf_data->dev = dev;
+	pf_data->read_cb = read_cb;
+	pf_data->reset_cb = reset_cb;
+
+	/* Only register misc device when both devices (BT and FM) are probed */
+	if (!info->dev_bt || !info->dev_fm)
+		return 0;
+
+	/* Prepare and register MISC device */
+	info->misc_dev.minor = MISC_DYNAMIC_MINOR;
+	info->misc_dev.name = NAME;
+	info->misc_dev.fops = &char_dev_fops;
+	info->misc_dev.parent = dev;
+	info->misc_dev.mode = S_IRUGO | S_IWUGO;
+
+	err = misc_register(&info->misc_dev);
+	if (err) {
+		dev_err(dev, "Error %d registering misc dev\n", err);
+		return err;
+	}
+	info->misc_registered = true;
+
+	dev_info(dev, "CG2900 Audio driver started\n");
+	return 0;
+}
+
+/**
+ * cg2900_audio_bt_probe() - Initialize CG2900 BT audio resources.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENOMEM if allocation fails.
+ *   -EEXIST if device has already been started.
+ *   Error codes from probe_common.
+ */
+static int __devinit cg2900_audio_bt_probe(struct platform_device *pdev)
+{
+	int err;
+	struct audio_info *info;
+
+	dev_dbg(&pdev->dev, "cg2900_audio_bt_probe\n");
+
+	info = get_info(&pdev->dev);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	info->dev_bt = &pdev->dev;
+	dev_set_drvdata(&pdev->dev, info);
+
+	err = probe_common(info, &pdev->dev);
+	if (err) {
+		dev_err(&pdev->dev, "Could not probe audio BT (%d)\n", err);
+		dev_set_drvdata(&pdev->dev, NULL);
+		device_removed(info);
+	}
+
+	return err;
+}
+
+/**
+ * cg2900_audio_bt_probe() - Initialize CG2900 FM audio resources.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENOMEM if allocation fails.
+ *   -EEXIST if device has already been started.
+ *   Error codes from probe_common.
+ */
+static int __devinit cg2900_audio_fm_probe(struct platform_device *pdev)
+{
+	int err;
+	struct audio_info *info;
+
+	dev_dbg(&pdev->dev, "cg2900_audio_fm_probe\n");
+
+	info = get_info(&pdev->dev);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	info->dev_fm = &pdev->dev;
+	dev_set_drvdata(&pdev->dev, info);
+
+	err = probe_common(info, &pdev->dev);
+	if (err) {
+		dev_err(&pdev->dev, "Could not probe audio FM (%d)\n", err);
+		dev_set_drvdata(&pdev->dev, NULL);
+		device_removed(info);
+	}
+
+	return err;
+}
+
+/**
+ * common_remove() - Dergister misc device.
+ * @info:	Audio info structure.
+ * @dev:	Current device.
+ *
+ * Returns:
+ *   0 if success.
+ *   Error codes from misc_deregister.
+ */
+static int common_remove(struct audio_info *info, struct device *dev)
+{
+	int err;
+	struct audio_cb_info *cb_info;
+	struct cg2900_user_data *pf_data;
+
+	pf_data = dev_get_platdata(dev);
+	cb_info = cg2900_get_usr(pf_data);
+	skb_queue_purge(&cb_info->skb_queue);
+	wake_up_interruptible_all(&cb_info->wq);
+	kfree(cb_info);
+
+	if (!info->misc_registered)
+		return 0;
+
+	err = misc_deregister(&info->misc_dev);
+	if (err)
+		dev_err(dev, "Error %d deregistering misc dev\n", err);
+	info->misc_registered = false;
+
+	dev_info(dev, "CG2900 Audio driver removed\n");
+	return err;
+}
+
+/**
+ * cg2900_audio_bt_remove() - Release CG2900 audio resources.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success.
+ *   Error codes from common_remove.
+ */
+static int __devexit cg2900_audio_bt_remove(struct platform_device *pdev)
+{
+	int err;
+	struct audio_info *info;
+
+	dev_dbg(&pdev->dev, "cg2900_audio_bt_remove\n");
+
+	info = dev_get_drvdata(&pdev->dev);
+
+	info->dev_bt = NULL;
+
+	err = common_remove(info, &pdev->dev);
+	if (err)
+		dev_err(&pdev->dev,
+			"cg2900_audio_bt_remove:common_remove failed\n");
+
+	device_removed(info);
+
+	return 0;
+}
+
+/**
+ * cg2900_audio_fm_remove() - Release CG2900 audio resources.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success.
+ *   Error codes from common_remove.
+ */
+static int __devexit cg2900_audio_fm_remove(struct platform_device *pdev)
+{
+	int err;
+	struct audio_info *info;
+
+	dev_dbg(&pdev->dev, "cg2900_audio_fm_remove\n");
+
+	info = dev_get_drvdata(&pdev->dev);
+
+	info->dev_fm = NULL;
+
+	err = common_remove(info, &pdev->dev);
+	if (err)
+		dev_err(&pdev->dev,
+			"cg2900_audio_fm_remove:common_remove failed\n");
+
+	device_removed(info);
+
+	return 0;
+}
+
+static struct platform_driver cg2900_audio_bt_driver = {
+	.driver = {
+		.name	= "cg2900-audiobt",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= cg2900_audio_bt_probe,
+	.remove	= __devexit_p(cg2900_audio_bt_remove),
+};
+
+static struct platform_driver cg2900_audio_fm_driver = {
+	.driver = {
+		.name	= "cg2900-audiofm",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= cg2900_audio_fm_probe,
+	.remove	= __devexit_p(cg2900_audio_fm_remove),
+};
+
+/**
+ * cg2900_audio_init() - Initialize module.
+ *
+ * Registers platform driver.
+ */
+static int __init cg2900_audio_init(void)
+{
+	int err;
+
+	pr_debug("cg2900_audio_init");
+
+	err = platform_driver_register(&cg2900_audio_bt_driver);
+	if (err)
+		return err;
+	return platform_driver_register(&cg2900_audio_fm_driver);
+}
+
+/**
+ * cg2900_audio_exit() - Remove module.
+ *
+ * Unregisters platform driver.
+ */
+static void __exit cg2900_audio_exit(void)
+{
+	pr_debug("cg2900_audio_exit");
+	platform_driver_unregister(&cg2900_audio_fm_driver);
+	platform_driver_unregister(&cg2900_audio_bt_driver);
+}
+
+module_init(cg2900_audio_init);
+module_exit(cg2900_audio_exit);
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_AUTHOR("Kjell Andersson ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Linux Bluetooth Audio ST-Ericsson controller");
diff --git a/include/linux/mfd/cg2900_audio.h b/include/linux/mfd/cg2900_audio.h
new file mode 100644
index 0000000..ff0f053
--- /dev/null
+++ b/include/linux/mfd/cg2900_audio.h
@@ -0,0 +1,473 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth Audio Driver for ST-Ericsson controller.
+ */
+
+#ifndef _CG2900_AUDIO_H_
+#define _CG2900_AUDIO_H_
+
+#include <linux/types.h>
+
+/*
+ * Digital Audio Interface configuration types
+ */
+
+/** CG2900_A2DP_MAX_AVDTP_HDR_LEN - Max length of a AVDTP header.
+ * Max length of a AVDTP header for an A2DP packet.
+ */
+#define CG2900_A2DP_MAX_AVDTP_HDR_LEN		25
+
+/*
+ * Op codes used when writing commands to the audio interface from user space
+ * using the char device.
+ */
+#define CG2900_OPCODE_SET_DAI_CONF		0x01
+#define CG2900_OPCODE_GET_DAI_CONF		0x02
+#define CG2900_OPCODE_CONFIGURE_ENDPOINT	0x03
+#define CG2900_OPCODE_START_STREAM		0x04
+#define CG2900_OPCODE_STOP_STREAM		0x05
+
+/**
+ * enum cg2900_dai_dir - Contains the DAI port directions alternatives.
+ * @DAI_DIR_B_RX_A_TX: Port B as Rx and port A as Tx.
+ * @DAI_DIR_B_TX_A_RX: Port B as Tx and port A as Rx.
+ */
+enum cg2900_dai_dir {
+	DAI_DIR_B_RX_A_TX = 0x00,
+	DAI_DIR_B_TX_A_RX = 0x01
+};
+
+/**
+ * enum cg2900_dai_mode - DAI mode alternatives.
+ * @DAI_MODE_SLAVE: Slave.
+ * @DAI_MODE_MASTER: Master.
+ */
+enum cg2900_dai_mode {
+	DAI_MODE_SLAVE = 0x00,
+	DAI_MODE_MASTER = 0x01
+};
+
+/**
+ * enum cg2900_dai_stream_ratio - Voice stream ratio alternatives.
+ * @STREAM_RATIO_FM16_VOICE16:	FM 16kHz, Voice 16kHz.
+ * @STREAM_RATIO_FM16_VOICE8:	FM 16kHz, Voice 8kHz.
+ * @STREAM_RATIO_FM48_VOICE16:	FM 48kHz, Voice 16Khz.
+ * @STREAM_RATIO_FM48_VOICE8:	FM 48kHz, Voice 8kHz.
+ *
+ * Contains the alternatives for the voice stream ratio between the Audio stream
+ * sample rate and the Voice stream sample rate.
+ */
+enum cg2900_dai_stream_ratio {
+	STREAM_RATIO_FM16_VOICE16 = 0x01,
+	STREAM_RATIO_FM16_VOICE8 = 0x02,
+	STREAM_RATIO_FM48_VOICE16 = 0x03,
+	STREAM_RATIO_FM48_VOICE8 = 0x06
+};
+
+/**
+ * enum cg2900_dai_fs_duration - Frame sync duration alternatives.
+ * @SYNC_DURATION_8: 8 frames sync duration.
+ * @SYNC_DURATION_16: 16 frames sync duration.
+ * @SYNC_DURATION_24: 24 frames sync duration.
+ * @SYNC_DURATION_32: 32 frames sync duration.
+ * @SYNC_DURATION_48: 48 frames sync duration.
+ * @SYNC_DURATION_50: 50 frames sync duration.
+ * @SYNC_DURATION_64: 64 frames sync duration.
+ * @SYNC_DURATION_75: 75 frames sync duration.
+ * @SYNC_DURATION_96: 96 frames sync duration.
+ * @SYNC_DURATION_125: 125 frames sync duration.
+ * @SYNC_DURATION_128: 128 frames sync duration.
+ * @SYNC_DURATION_150: 150 frames sync duration.
+ * @SYNC_DURATION_192: 192 frames sync duration.
+ * @SYNC_DURATION_250: 250 frames sync duration.
+ * @SYNC_DURATION_256: 256 frames sync duration.
+ * @SYNC_DURATION_300: 300 frames sync duration.
+ * @SYNC_DURATION_384: 384 frames sync duration.
+ * @SYNC_DURATION_500: 500 frames sync duration.
+ * @SYNC_DURATION_512: 512 frames sync duration.
+ * @SYNC_DURATION_600: 600 frames sync duration.
+ * @SYNC_DURATION_768: 768 frames sync duration.
+ *
+ * This parameter sets the PCM frame sync duration. It is calculated as the
+ * ratio between the bit clock and the frame rate. For example, if the bit
+ * clock is 512 kHz and the stream sample rate is 8 kHz, the PCM frame sync
+ * duration is 512 / 8 = 64.
+ */
+enum cg2900_dai_fs_duration {
+	SYNC_DURATION_8   = 0,
+	SYNC_DURATION_16  = 1,
+	SYNC_DURATION_24  = 2,
+	SYNC_DURATION_32  = 3,
+	SYNC_DURATION_48  = 4,
+	SYNC_DURATION_50  = 5,
+	SYNC_DURATION_64  = 6,
+	SYNC_DURATION_75  = 7,
+	SYNC_DURATION_96  = 8,
+	SYNC_DURATION_125 = 9,
+	SYNC_DURATION_128 = 10,
+	SYNC_DURATION_150 = 11,
+	SYNC_DURATION_192 = 12,
+	SYNC_DURATION_250 = 13,
+	SYNC_DURATION_256 = 14,
+	SYNC_DURATION_300 = 15,
+	SYNC_DURATION_384 = 16,
+	SYNC_DURATION_500 = 17,
+	SYNC_DURATION_512 = 18,
+	SYNC_DURATION_600 = 19,
+	SYNC_DURATION_768 = 20
+};
+
+/**
+ * enum cg2900_dai_bit_clk - Bit Clock alternatives.
+ * @BIT_CLK_128:	128 Kbits clock.
+ * @BIT_CLK_256:	256 Kbits clock.
+ * @BIT_CLK_512:	512 Kbits clock.
+ * @BIT_CLK_768:	768 Kbits clock.
+ * @BIT_CLK_1024:	1024 Kbits clock.
+ * @BIT_CLK_1411_76:	1411.76 Kbits clock.
+ * @BIT_CLK_1536:	1536 Kbits clock.
+ * @BIT_CLK_2000:	2000 Kbits clock.
+ * @BIT_CLK_2048:	2048 Kbits clock.
+ * @BIT_CLK_2400:	2400 Kbits clock.
+ * @BIT_CLK_2823_52:	2823.52 Kbits clock.
+ * @BIT_CLK_3072:	3072 Kbits clock.
+ *
+ *  This parameter sets the bit clock speed. This is the clocking of the actual
+ *  data. A usual parameter for eSCO voice is 512 kHz.
+ */
+enum cg2900_dai_bit_clk {
+	BIT_CLK_128 = 0x00,
+	BIT_CLK_256 = 0x01,
+	BIT_CLK_512 = 0x02,
+	BIT_CLK_768 = 0x03,
+	BIT_CLK_1024 = 0x04,
+	BIT_CLK_1411_76 = 0x05,
+	BIT_CLK_1536 = 0x06,
+	BIT_CLK_2000 = 0x07,
+	BIT_CLK_2048 = 0x08,
+	BIT_CLK_2400 = 0x09,
+	BIT_CLK_2823_52 = 0x0A,
+	BIT_CLK_3072 = 0x0B
+};
+
+/**
+ * enum cg2900_dai_sample_rate - Sample rates alternatives.
+ * @SAMPLE_RATE_8:	8 kHz sample rate.
+ * @SAMPLE_RATE_16:	16 kHz sample rate.
+ * @SAMPLE_RATE_44_1:	44.1 kHz sample rate.
+ * @SAMPLE_RATE_48:	48 kHz sample rate.
+ */
+enum cg2900_dai_sample_rate {
+	SAMPLE_RATE_8    = 0,
+	SAMPLE_RATE_16   = 1,
+	SAMPLE_RATE_44_1 = 2,
+	SAMPLE_RATE_48   = 3
+};
+
+/**
+ * enum cg2900_dai_port_protocol - Port protocol alternatives.
+ * @PORT_PROTOCOL_PCM: Protocol PCM.
+ * @PORT_PROTOCOL_I2S: Protocol I2S.
+ */
+enum cg2900_dai_port_protocol {
+	PORT_PROTOCOL_PCM = 0x00,
+	PORT_PROTOCOL_I2S = 0x01
+};
+
+/**
+ * enum cg2900_dai_channel_sel - The channel selection alternatives.
+ * @CHANNEL_SELECTION_RIGHT: Right channel used.
+ * @CHANNEL_SELECTION_LEFT: Left channel used.
+ * @CHANNEL_SELECTION_BOTH: Both channels used.
+ */
+enum cg2900_dai_channel_sel {
+	CHANNEL_SELECTION_RIGHT = 0x00,
+	CHANNEL_SELECTION_LEFT = 0x01,
+	CHANNEL_SELECTION_BOTH = 0x02
+};
+
+/**
+ * struct cg2900_dai_conf_i2s_pcm - Port configuration structure.
+ * @mode:		Operational mode of the port configured.
+ * @i2s_channel_sel:	I2S channels used. Only valid if used in I2S mode.
+ * @slot_0_used:	True if SCO slot 0 is used.
+ * @slot_1_used:	True if SCO slot 1 is used.
+ * @slot_2_used:	True if SCO slot 2 is used.
+ * @slot_3_used:	True if SCO slot 3 is used.
+ * @slot_0_dir:		Direction of slot 0.
+ * @slot_1_dir:		Direction of slot 1.
+ * @slot_2_dir:		Direction of slot 2.
+ * @slot_3_dir:		Direction of slot 3.
+ * @slot_0_start:	Slot 0 start (relative to the PCM frame sync).
+ * @slot_1_start:	Slot 1 start (relative to the PCM frame sync)
+ * @slot_2_start:	Slot 2 start (relative to the PCM frame sync)
+ * @slot_3_start:	Slot 3 start (relative to the PCM frame sync)
+ * @ratio:		Voice stream ratio between the Audio stream sample rate
+ *			and the Voice stream sample rate.
+ * @protocol:		Protocol used on port.
+ * @duration:		Frame sync duration.
+ * @clk:		Bit clock.
+ * @sample_rate:	Sample rate.
+ */
+struct cg2900_dai_conf_i2s_pcm {
+	enum cg2900_dai_mode mode;
+	enum cg2900_dai_channel_sel i2s_channel_sel;
+	bool slot_0_used;
+	bool slot_1_used;
+	bool slot_2_used;
+	bool slot_3_used;
+	enum cg2900_dai_dir slot_0_dir;
+	enum cg2900_dai_dir slot_1_dir;
+	enum cg2900_dai_dir slot_2_dir;
+	enum cg2900_dai_dir slot_3_dir;
+	__u8 slot_0_start;
+	__u8 slot_1_start;
+	__u8 slot_2_start;
+	__u8 slot_3_start;
+	enum cg2900_dai_stream_ratio ratio;
+	enum cg2900_dai_port_protocol protocol;
+	enum cg2900_dai_fs_duration duration;
+	enum cg2900_dai_bit_clk clk;
+	enum cg2900_dai_sample_rate sample_rate;
+};
+
+/**
+ * enum cg2900_dai_half_period - Half period duration alternatives.
+ * @HALF_PER_DUR_8:	8 Bits.
+ * @HALF_PER_DUR_16:	16 Bits.
+ * @HALF_PER_DUR_24:	24 Bits.
+ * @HALF_PER_DUR_25:	25 Bits.
+ * @HALF_PER_DUR_32:	32 Bits.
+ * @HALF_PER_DUR_48:	48 Bits.
+ * @HALF_PER_DUR_64:	64 Bits.
+ * @HALF_PER_DUR_75:	75 Bits.
+ * @HALF_PER_DUR_96:	96 Bits.
+ * @HALF_PER_DUR_128:	128 Bits.
+ * @HALF_PER_DUR_150:	150 Bits.
+ * @HALF_PER_DUR_192:	192 Bits.
+ *
+ * This parameter sets the number of bits contained in each I2S half period,
+ * i.e. each channel slot. A usual value is 16 bits.
+ */
+enum cg2900_dai_half_period {
+	HALF_PER_DUR_8 = 0x00,
+	HALF_PER_DUR_16 = 0x01,
+	HALF_PER_DUR_24 = 0x02,
+	HALF_PER_DUR_25 = 0x03,
+	HALF_PER_DUR_32 = 0x04,
+	HALF_PER_DUR_48 = 0x05,
+	HALF_PER_DUR_64 = 0x06,
+	HALF_PER_DUR_75 = 0x07,
+	HALF_PER_DUR_96 = 0x08,
+	HALF_PER_DUR_128 = 0x09,
+	HALF_PER_DUR_150 = 0x0A,
+	HALF_PER_DUR_192 = 0x0B
+};
+
+/**
+ * enum cg2900_dai_word_width - Word width alternatives.
+ * @WORD_WIDTH_16: 16 bits words.
+ * @WORD_WIDTH_32: 32 bits words.
+ */
+enum cg2900_dai_word_width {
+	WORD_WIDTH_16 = 0x00,
+	WORD_WIDTH_32 = 0x01
+};
+
+/**
+ * struct cg2900_dai_conf_i2s - Port configuration struct for I2S.
+ * @mode:		Operational mode of the port.
+ * @half_period:	Half period duration.
+ * @channel_sel:	Channel selection.
+ * @sample_rate:	Sample rate.
+ * @word_width:		Word width.
+ */
+struct cg2900_dai_conf_i2s {
+	enum cg2900_dai_mode			mode;
+	enum cg2900_dai_half_period		half_period;
+	enum cg2900_dai_channel_sel		channel_sel;
+	enum cg2900_dai_sample_rate		sample_rate;
+	enum cg2900_dai_word_width		word_width;
+};
+
+/**
+ * union cg2900_dai_port_conf - DAI port configuration union.
+ * @i2s: The configuration struct for a port supporting only I2S.
+ * @i2s_pcm: The configuration struct for a port supporting both PCM and I2S.
+ */
+union cg2900_dai_port_conf {
+	struct cg2900_dai_conf_i2s i2s;
+	struct cg2900_dai_conf_i2s_pcm i2s_pcm;
+};
+
+/**
+ * enum cg2900_dai_ext_port_id - DAI external port id alternatives.
+ * @PORT_0_I2S: Port id is 0 and it supports only I2S.
+ * @PORT_1_I2S_PCM: Port id is 1 and it supports both I2S and PCM.
+ */
+enum cg2900_dai_ext_port_id {
+	PORT_0_I2S,
+	PORT_1_I2S_PCM
+};
+
+/**
+ * enum cg2900_audio_endpoint_id - Audio endpoint id alternatives.
+ * @ENDPOINT_PORT_0_I2S:	Internal audio endpoint of the external I2S
+ *				interface.
+ * @ENDPOINT_PORT_1_I2S_PCM:	Internal audio endpoint of the external I2S/PCM
+ *				interface.
+ * @ENDPOINT_SLIMBUS_VOICE:	Internal audio endpoint of the external Slimbus
+ *				voice interface. (Currently not supported)
+ * @ENDPOINT_SLIMBUS_AUDIO:	Internal audio endpoint of the external Slimbus
+ *				audio interface. (Currently not supported)
+ * @ENDPOINT_BT_SCO_INOUT:	Bluetooth SCO bidirectional.
+ * @ENDPOINT_BT_A2DP_SRC:	Bluetooth A2DP source.
+ * @ENDPOINT_BT_A2DP_SNK:	Bluetooth A2DP sink.
+ * @ENDPOINT_FM_RX:		FM receive.
+ * @ENDPOINT_FM_TX:		FM transmit.
+ * @ENDPOINT_ANALOG_OUT:	Analog out.
+ * @ENDPOINT_DSP_AUDIO_IN:	DSP audio in.
+ * @ENDPOINT_DSP_AUDIO_OUT:	DSP audio out.
+ * @ENDPOINT_DSP_VOICE_IN:	DSP voice in.
+ * @ENDPOINT_DSP_VOICE_OUT:	DSP voice out.
+ * @ENDPOINT_DSP_TONE_IN:	DSP tone in.
+ * @ENDPOINT_BURST_BUFFER_IN:	Burst buffer in.
+ * @ENDPOINT_BURST_BUFFER_OUT:	Burst buffer out.
+ * @ENDPOINT_MUSIC_DECODER:	Music decoder.
+ * @ENDPOINT_HCI_AUDIO_IN:	HCI audio in.
+ */
+enum cg2900_audio_endpoint_id {
+	ENDPOINT_PORT_0_I2S,
+	ENDPOINT_PORT_1_I2S_PCM,
+	ENDPOINT_SLIMBUS_VOICE,
+	ENDPOINT_SLIMBUS_AUDIO,
+	ENDPOINT_BT_SCO_INOUT,
+	ENDPOINT_BT_A2DP_SRC,
+	ENDPOINT_BT_A2DP_SNK,
+	ENDPOINT_FM_RX,
+	ENDPOINT_FM_TX,
+	ENDPOINT_ANALOG_OUT,
+	ENDPOINT_DSP_AUDIO_IN,
+	ENDPOINT_DSP_AUDIO_OUT,
+	ENDPOINT_DSP_VOICE_IN,
+	ENDPOINT_DSP_VOICE_OUT,
+	ENDPOINT_DSP_TONE_IN,
+	ENDPOINT_BURST_BUFFER_IN,
+	ENDPOINT_BURST_BUFFER_OUT,
+	ENDPOINT_MUSIC_DECODER,
+	ENDPOINT_HCI_AUDIO_IN
+};
+
+/**
+ * struct cg2900_dai_config - Configuration struct for Digital Audio Interface.
+ * @port: The port id to configure. Acts as a discriminator for @conf parameter
+ *	  which is a union.
+ * @conf: The configuration union that contains the parameters for the port.
+ */
+struct cg2900_dai_config {
+	enum cg2900_dai_ext_port_id	port;
+	union cg2900_dai_port_conf	conf;
+};
+
+/*
+ * Endpoint configuration types
+ */
+
+/**
+ * enum cg2900_endpoint_sample_rate - Audio endpoint configuration sample rate alternatives.
+ *
+ * This enum defines the same values as @cg2900_dai_sample_rate, but
+ * is kept to preserve the API.
+ *
+ * @ENDPOINT_SAMPLE_RATE_8_KHZ: 8 kHz sample rate.
+ * @ENDPOINT_SAMPLE_RATE_16_KHZ: 16 kHz sample rate.
+ * @ENDPOINT_SAMPLE_RATE_44_1_KHZ: 44.1 kHz sample rate.
+ * @ENDPOINT_SAMPLE_RATE_48_KHZ: 48 kHz sample rate.
+ */
+enum cg2900_endpoint_sample_rate {
+	ENDPOINT_SAMPLE_RATE_8_KHZ	= SAMPLE_RATE_8,
+	ENDPOINT_SAMPLE_RATE_16_KHZ	= SAMPLE_RATE_16,
+	ENDPOINT_SAMPLE_RATE_44_1_KHZ	= SAMPLE_RATE_44_1,
+	ENDPOINT_SAMPLE_RATE_48_KHZ	= SAMPLE_RATE_48
+};
+
+
+/**
+ * struct cg2900_endpoint_config_a2dp_src - A2DP source audio endpoint configurations.
+ * @sample_rate: Sample rate.
+ * @channel_count: Number of channels.
+ */
+struct cg2900_endpoint_config_a2dp_src {
+	enum cg2900_endpoint_sample_rate	sample_rate;
+	unsigned int				channel_count;
+};
+
+/**
+ * struct cg2900_endpoint_config_fm - Configuration parameters for an FM endpoint.
+ * @sample_rate: The sample rate alternatives for the FM audio endpoints.
+ */
+struct cg2900_endpoint_config_fm {
+	enum cg2900_endpoint_sample_rate	sample_rate;
+};
+
+
+/**
+ * struct cg2900_endpoint_config_sco_in_out - SCO audio endpoint configuration structure.
+ * @sample_rate: Sample rate, valid values are
+ *		 * ENDPOINT_SAMPLE_RATE_8_KHZ
+ *		 * ENDPOINT_SAMPLE_RATE_16_KHZ.
+ */
+struct cg2900_endpoint_config_sco_in_out {
+	enum cg2900_endpoint_sample_rate	sample_rate;
+};
+
+/**
+ * union cg2900_endpoint_config - Different audio endpoint configurations.
+ * @sco:	SCO audio endpoint configuration structure.
+ * @a2dp_src:	A2DP source audio endpoint configuration structure.
+ * @fm:		FM audio endpoint configuration structure.
+ */
+union cg2900_endpoint_config_union {
+	struct cg2900_endpoint_config_sco_in_out	sco;
+	struct cg2900_endpoint_config_a2dp_src		a2dp_src;
+	struct cg2900_endpoint_config_fm		fm;
+};
+
+/**
+ * struct cg2900_endpoint_config - Audio endpoint configuration.
+ * @endpoint_id:	Identifies the audio endpoint. Works as a discriminator
+ *			for the config union.
+ * @config:		Union holding the configuration parameters for
+ *			the endpoint.
+ */
+struct cg2900_endpoint_config {
+	enum cg2900_audio_endpoint_id		endpoint_id;
+	union cg2900_endpoint_config_union	config;
+};
+
+#ifdef __KERNEL__
+#include <linux/device.h>
+
+int cg2900_audio_get_devices(struct device *devices[], __u8 size);
+int cg2900_audio_open(unsigned int *session, struct device *parent);
+int cg2900_audio_close(unsigned int *session);
+int cg2900_audio_set_dai_config(unsigned int session,
+				struct cg2900_dai_config *config);
+int cg2900_audio_get_dai_config(unsigned int session,
+				struct cg2900_dai_config *config);
+int cg2900_audio_config_endpoint(unsigned int session,
+				 struct cg2900_endpoint_config *config);
+int cg2900_audio_start_stream(unsigned int session,
+			      enum cg2900_audio_endpoint_id ep_1,
+			      enum cg2900_audio_endpoint_id ep_2,
+			      unsigned int *stream_handle);
+int cg2900_audio_stop_stream(unsigned int session,
+			     unsigned int stream_handle);
+
+#endif /* __KERNEL__ */
+#endif /* _CG2900_AUDIO_H_ */
-- 
1.7.3.2

