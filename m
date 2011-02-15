Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1BONNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:13:05 -0500
Received: from smtp.nokia.com ([147.243.128.26]:49804 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab1BONMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:12:36 -0500
From: tapio.vihuri@nokia.com
To: dmitry.torokhov@gmail.com
Cc: peter.ujfalusi@nokia.com, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        ilkka.koskinen@nokia.com, samu.p.onkalo@nokia.com
Subject: [PATCH v7 1/2] ECI: input: introduce ECI accessory input driver
Date: Tue, 15 Feb 2011 15:11:59 +0200
Message-Id: <1297775520-1993-2-git-send-email-tapio.vihuri@nokia.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1297775520-1993-1-git-send-email-tapio.vihuri@nokia.com>
References: <1297775520-1993-1-git-send-email-tapio.vihuri@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tapio Vihuri <tapio.vihuri@nokia.com>

ECI stands for (Enhancement Control Interface).

ECI is better known as Multimedia Headset for Nokia phones.
If headset has many buttons, like play, vol+, vol- etc. then it is propably
ECI accessory.
Among multiple buttons ECI accessory contains memory for storing several
parameters.

ECI input driver provides the following features:
- reading ECI configuration memory
- ECI buttons as input events
- ECI i2c-controller part as a bridge between host CPU I2C and
  ECI accessory communication

Signed-off-by: Tapio Vihuri <tapio.vihuri@nokia.com>
---
 drivers/input/misc/Kconfig        |   47 ++
 drivers/input/misc/Makefile       |    3 +-
 drivers/input/misc/eci.c          |  851 +++++++++++++++++++++++++++++++++++++
 drivers/input/misc/eci_at20-i2c.c |  713 +++++++++++++++++++++++++++++++
 include/linux/input/eci.h         |  189 ++++++++
 5 files changed, 1802 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/misc/eci.c
 create mode 100644 drivers/input/misc/eci_at20-i2c.c
 create mode 100644 include/linux/input/eci.h

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index b0c6772..2f02eda 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -114,6 +114,53 @@ config INPUT_APANEL
 	 To compile this driver as a module, choose M here: the module will
 	 be called apanel.
 
+config INPUT_ECI
+	tristate "AV ECI (Enhancement Control Interface) input driver"
+	default n
+	select INPUT_SPARSEKMAP
+	help
+	The Enhancement Control Interface functionality
+	  ECI is better known as Multimedia Headset for Nokia phones.
+	  If headset has many buttons, like play, vol+, vol- etc. then
+	  it is propably ECI accessory.
+	  Among multiple buttons ECI accessory contains memory for storing
+	  several parameters.
+
+	  ECI input driver provides the following features:
+	  - reading ECI configuration memory
+	  - ECI buttons as input events
+
+	  ECI input driver needs some ECI controller method, select
+	  appropriate controller below.
+
+	  Say 'y' here to statically link this module into the kernel or 'm'
+	  to build it as a dynamically loadable module. The module will be
+	  called eci.ko
+
+config ECI_DEBUG
+	bool "ECI driver debug"
+	depends on INPUT_ECI
+	help
+	  Say Y here to enable debugging messages for ECI input driver.
+
+	  Ease understanding ECI accessory configuration embedded in
+	  accessory's memory.
+	  Add memory and buttons parsing info to module eci.ko
+
+config INPUT_ECI_AT20
+	tristate "ECI controller method"
+	depends on INPUT_ECI && I2C && X86_MRST && INPUT_MISC
+	default y
+	help
+	  This selects the used ECI controller
+
+	  ECI controller is kind of bridge between host CPU I2C and
+	  ECI accessory ECI communication.
+
+	  Say 'y' here to statically link this module into the kernel or 'm'
+	  to build it as a dynamically loadable module. The module will be
+	  called eci_at20-i2c.ko
+
 config INPUT_IXP4XX_BEEPER
 	tristate "IXP4XX Beeper support"
 	depends on ARCH_IXP4XX
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 9b47971..7631b33 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -23,6 +23,8 @@ obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
+obj-$(CONFIG_INPUT_ECI)			+= eci.o
+obj-$(CONFIG_INPUT_ECI_AT20)		+= eci_at20-i2c.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
 obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
 obj-$(CONFIG_INPUT_M68K_BEEP)		+= m68kspkr.o
@@ -43,4 +45,3 @@ obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
 obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
 obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
-
diff --git a/drivers/input/misc/eci.c b/drivers/input/misc/eci.c
new file mode 100644
index 0000000..81a5c20
--- /dev/null
+++ b/drivers/input/misc/eci.c
@@ -0,0 +1,851 @@
+/*
+ * This file is part of ECI (Enhancement Control Interface) accessory input
+ * driver
+ *
+ * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Tapio Vihuri <tapio.vihuri@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+/*
+ * ECI stands for (Enhancement Control Interface).
+ *
+ * ECI is better known as Multimedia Headset for Nokia phones.
+ * If headset has many buttons, like play, vol+, vol- etc. then it is propably
+ * ECI accessory.
+ * Among several buttons ECI accessory contains memory for storing several
+ * parameters.
+ *
+ * ECI input driver provides the following features:
+ *  - reading ECI configuration memory
+ *  - ECI buttons as input events
+ */
+
+#if defined(CONFIG_ECI_DEBUG)
+#define DEBUG
+#endif
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+
+#include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
+#include <linux/input/eci.h>
+
+#define ECI_DRIVERNAME	"ECI_accessory"
+
+#define ECI_WAIT_SEND_BUTTON		5	/* ms */
+#define ECI_WAIT_BUS_SETTLE		40	/* ms */
+#define ECI_TRY_GET_MEMORY		2000	/* ms */
+#define ECI_TRY_INIT_IO			200	/* ms */
+#define ECI_TRY_SET_MIC			200	/* ms */
+#define ECI_KEY_REPEAT_INTERVAL		400	/* ms */
+
+#define ECI_EKEY_BLOCK_ID			0xb3
+#define ECI_ENHANCEMENT_FEATURE_BLOCK_ID	0x02
+
+/* Map ECI inputs to events */
+static const struct key_entry eci_keymap[] = {
+	{ KE_KEY, 0x00, { KEY_UNKNOWN } }, /* No feature */
+	{ KE_KEY, 0x01, { KEY_UNKNOWN } }, /* Ignition Sense */
+	{ KE_KEY, 0x02, { KEY_UNKNOWN } }, /* Car-Kit Handset Hook */
+	{ KE_KEY, 0x03, { KEY_BATTERY } }, /* Power Supply/Car Battery Det  */
+	{ KE_KEY, 0x06, { KEY_AUDIO } },   /* External audio In */
+	{ KE_KEY, 0x07, { KEY_PHONE } },   /* Send, End, and Voice Recogn */
+	{ KE_VSW, 0x08, { .sw = { SW_HEADPHONE_INSERT} } }, /* Headphone plug */
+	{ KE_KEY, 0x0a, { KEY_UNKNOWN } },    /* Device Power Request */
+	{ KE_KEY, 0x0b, { KEY_VOLUMEUP } },   /* Volume Up */
+	{ KE_KEY, 0x0c, { KEY_VOLUMEDOWN } }, /* Volume Down */
+	{ KE_KEY, 0x0d, { KEY_PLAYPAUSE } },  /* Play / Pause */
+	{ KE_KEY, 0x0e, { KEY_STOP } },       /* Stop */
+	{ KE_KEY, 0x0f, { KEY_FORWARD } }, /* Next/Fast Fward/Autosearch up */
+	{ KE_KEY, 0x10, { KEY_REWIND } },  /* Prev/Rewind/Autosearch down */
+	{ KE_KEY, 0x11, { KEY_UNKNOWN } }, /* Push to Talk over Cellular */
+	{ KE_KEY, 0x14, { KEY_UNKNOWN } }, /* Synchronization Button */
+	{ KE_KEY, 0x15, { KEY_RADIO } },   /* Music/Radio/Off Selector */
+	{ KE_KEY, 0x16, { KEY_UNKNOWN } }, /* Redial */
+	{ KE_KEY, 0x17, { KEY_UNKNOWN } }, /* Left Soft Key */
+	{ KE_KEY, 0x18, { KEY_UNKNOWN } }, /* Right Soft key */
+	{ KE_KEY, 0x19, { KEY_SEND } },    /* Send key */
+	{ KE_KEY, 0x1a, { KEY_END } },     /* End key */
+	{ KE_KEY, 0x1b, { KEY_UNKNOWN } }, /* Middle Soft key */
+	{ KE_KEY, 0x1c, { KEY_UP } },      /* UP key/joystick direction */
+	{ KE_KEY, 0x1d, { KEY_DOWN } },    /* DOWN key/joystick direction */
+	{ KE_KEY, 0x1e, { KEY_RIGHT } },   /* RIGHT key/joystick direction */
+	{ KE_KEY, 0x1f, { KEY_LEFT } },    /* LEFT key/joystick direction */
+	{ KE_KEY, 0x20, { KEY_UNKNOWN } }, /* Symbian Application key */
+	{ KE_KEY, 0x21, { KEY_UNKNOWN } }, /* Terminal Applicat Ctrl Input */
+	{ KE_KEY, 0x23, { KEY_UNKNOWN } }, /* USB Class Switching */
+	{ KE_KEY, 0x24, { KEY_MUTE } },    /* Mute */
+	{ KE_END, 0 },
+};
+
+#define ECI_KEY_MAX	0x24
+
+#define ECI_INT_ENABLE		1
+#define ECI_INT_DELAY_ENABLE	(1<<1)
+#define ECI_INT_LEN_76MS	0
+#define ECI_INT_LEN_82MS	(1<<5)
+#define ECI_INT_LEN_37MS	(2<<5)
+#define ECI_INT_LEN_19MS	(3<<5)
+#define ECI_INT_LEN_10MS	(4<<5)
+#define ECI_INT_LEN_5MS		(5<<5)
+#define ECI_INT_LEN_2MS		(6<<5)
+#define ECI_INT_LEN_120US	(7<<5)
+
+struct eci_mem_block {
+	u8 id;
+	u8 len;
+	u16 size;
+};
+
+static struct eci_cb eci_callback;
+static struct audio_hsmic_event hsmic_event;
+
+static struct eci_data *the_eci;
+
+/* Returns size of accessory memory or error */
+static int eci_get_ekey(struct eci_data *eci, int *key)
+{
+	u8 buf[4];
+	struct eci_mem_block *ekey = (void *)buf;
+	int ret;
+
+	/* Read always four bytes */
+	ret = eci->eci_hw_ops->acc_read_direct(0, buf);
+
+	if (ret)
+		return ret;
+
+	if (ekey->id != ECI_EKEY_BLOCK_ID)
+		return -ENODEV;
+
+	*key = cpu_to_be16(ekey->size);
+
+	return 0;
+}
+
+/* Read ECI device memory into buffer */
+static int eci_get_memory(struct eci_data *eci, int *restart)
+{
+	int i, ret;
+
+	for (i = *restart; i < eci->mem_size; i += 4) {
+		ret = eci->eci_hw_ops->acc_read_direct(i, eci->memory + i);
+		*restart = i;
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+/*
+ * This should be really init_features, but most oftens these are just buttons
+ */
+static int eci_init_buttons(struct eci_data *eci)
+{
+	struct enchancement_features_fixed *eff = eci->e_features_fix;
+	u8 n, mireg;
+	int ret;
+	u8 buf[4];
+
+	n = eff->number_of_features;
+
+	if (n > ECI_MAX_FEATURE_COUNT)
+		return -EINVAL;
+
+	ret = eci->eci_hw_ops->acc_write_reg(ECICMD_MIC_CTRL, ECI_MIC_OFF);
+	if (ret)
+		return ret;
+
+	ret = eci->eci_hw_ops->acc_read_reg(ECICMD_MASTER_INT_REG, buf, 1);
+	if (ret)
+		return ret;
+
+	mireg = buf[0];
+	mireg &= ~ECI_INT_ENABLE;
+	mireg |= ECI_INT_LEN_120US | ECI_INT_DELAY_ENABLE;
+
+	ret = eci->eci_hw_ops->acc_write_reg(ECICMD_MASTER_INT_REG, mireg);
+	if (ret)
+		return ret;
+
+	msleep(ECI_WAIT_BUS_SETTLE);
+	mireg |= ECI_INT_ENABLE;
+	ret = eci->eci_hw_ops->acc_write_reg(ECICMD_MASTER_INT_REG, mireg);
+	if (ret)
+		return ret;
+
+	msleep(ECI_WAIT_BUS_SETTLE);
+
+	return ret;
+}
+
+/* Find "enchangement features" block from buffer */
+static int eci_get_enchancement_features(struct eci_data *eci)
+{
+	u8 *mem = (void *)eci->memory;
+	struct eci_mem_block *b = (void *)mem;
+	struct eci_mem_block *mem_end = (void *)(eci->memory + eci->mem_size);
+
+	if (b->id != ECI_EKEY_BLOCK_ID)
+		return -ENODEV;
+
+	do {
+		dev_dbg(eci->dev, "skip BLOCK 0x%02x, LEN 0x%02x\n",
+				b->id, b->len);
+		if (!b->len)
+			return -EINVAL;
+
+		mem += b->len;
+		b = (void *)mem;
+		eci->e_features_fix = (void *)b;
+		dev_dbg(eci->dev, "found BLOCK 0x%02x, LEN 0x%02x\n",
+				b->id, b->len);
+		if (b->id == ECI_ENHANCEMENT_FEATURE_BLOCK_ID)
+			return 0;
+	} while (b < mem_end);
+
+	dev_dbg(eci->dev, "can't find ECI enchangement features block\n");
+
+	return -ENFILE;
+}
+
+/*
+ * Find out ECI features.
+ * All ECI memory block parsing are done here, be carefull as
+ * pointers to memory tend to go wrong easily.
+ * ECI "Enhancement Features block has variable size, so we try to
+ * catch pointers out of block due memory reading errors etc.
+ *
+ * I/O support field is not implemented.
+ * Data direction field is not implemented, nor writing to the ECI I/O
+ */
+static int eci_parse_enchancement_features(struct eci_data *eci)
+{
+	struct enchancement_features_fixed *eff = eci->e_features_fix;
+	struct enchancement_features_variable *efv = &eci->e_features_var;
+	int i;
+	u8 n, k;
+	void *mem_end = (void *)((u8 *)eff + eff->length);
+
+	dev_dbg(eci->dev, "block id 0x%02x length 0x%02x connector "
+			"configuration 0x%02x\n", eff->block_id, eff->length,
+			eff->connector_conf);
+	n = eff->number_of_features;
+	dev_dbg(eci->dev, "number of features %d\n", n);
+
+	if (n > ECI_MAX_FEATURE_COUNT) {
+		dev_dbg(eci->dev, "number of features out of range\n");
+		return -EINVAL;
+	}
+
+	k = DIV_ROUND_UP(n, 8);
+	dev_dbg(eci->dev, "I/O support bytes count %d\n", k);
+
+	efv->io_support = &eff->number_of_features + 1;
+	/* efv->io_functionality[0] is not used! pins are in 1..31 range */
+	efv->io_functionality = efv->io_support + k - 1;
+	efv->active_state = efv->io_functionality + n + 1;
+
+	if ((void *)&efv->active_state[k] > mem_end) {
+		dev_dbg(eci->dev, "I/O support bytes points out of memory\n");
+		return -EINVAL;
+	}
+
+	/* Last part of block */
+	for (i = 0; i < k; i++)
+		dev_dbg(eci->dev, "active_state[%d] 0x%02x\n", i,
+				efv->active_state[i]);
+
+	eci->buttons_data.buttons_up_mask =
+		~(u32)(cpu_to_le32(*(u32 *)efv->active_state));
+	dev_dbg(eci->dev, "buttons mask 0x%08x\n",
+			eci->buttons_data.buttons_up_mask);
+
+	/*
+	 * ECI accessory responces as many bytes needed for used I/O pins
+	 * up to four bytes, when lines 24..31 are used
+	 * all tested ECI accessories how ever return two data bytes
+	 * event though there are less than eight I/O pins
+	 *
+	 * so we get alway reading error if there are less than eight I/Os
+	 * meanwhile just use this kludge, FIXME
+	 */
+	k = DIV_ROUND_UP(n + 1, 8);
+	if (k > 4) {
+		dev_dbg(eci->dev, "maximum port reg count is four\n");
+		return -EINVAL;
+	}
+
+	if (k == 1)
+		k = 2;
+	eci->port_reg_count = k;
+
+	return 0;
+}
+
+static int eci_init_accessory(struct eci_data *eci)
+{
+	int ret, key = 0, restart = 0;
+	unsigned long future;
+
+	eci->mem_ok = false;
+
+	if (!eci->eci_hw_ops)
+		return -ENXIO;
+
+	ret = eci->eci_hw_ops->acc_reset();
+	if (ret)
+		return ret;
+
+	msleep(ECI_WAIT_BUS_SETTLE);
+
+	ret = eci->eci_hw_ops->acc_write_reg(ECICMD_MIC_CTRL, ECI_MIC_OFF);
+	if (ret) {
+		dev_dbg(eci->dev, "unable to turn ECI mic off\n");
+		return ret;
+	}
+
+	/* Get ECI ekey block to determine memory size */
+	future = jiffies + msecs_to_jiffies(ECI_TRY_GET_MEMORY);
+	do {
+		ret = eci_get_ekey(eci, &key);
+		if (time_is_before_jiffies(future))
+			break;
+	} while (ret);
+
+	if (ret) {
+		dev_dbg(eci->dev, "can't read ECI memory ekey block\n");
+		return ret;
+	}
+
+	eci->mem_size = key;
+	if (eci->mem_size > ECI_MAX_MEM_SIZE) {
+		dev_dbg(eci->dev, "reported ECI memory size out of range\n");
+		return -EINVAL;
+	}
+
+	/* Get ECI memory */
+	future = jiffies + msecs_to_jiffies(ECI_TRY_GET_MEMORY);
+	do {
+		ret = eci_get_memory(eci, &restart);
+		if (time_is_before_jiffies(future))
+			break;
+	} while (ret);
+
+	if (ret) {
+		dev_dbg(eci->dev, "can't read ECI memory\n");
+		return ret;
+	}
+
+	if (eci_get_enchancement_features(eci))
+		return -EIO;
+
+	if (eci_parse_enchancement_features(eci))
+		return -EIO;
+
+	/*
+	 * Now that enchancement features table has been parsed,
+	 * we can configure ECI buttons.
+	 */
+	msleep(ECI_WAIT_BUS_SETTLE);
+	future = jiffies + msecs_to_jiffies(ECI_TRY_INIT_IO);
+	do {
+		ret = eci_init_buttons(eci);
+		if (time_is_before_jiffies(future))
+			break;
+	} while (ret);
+
+	if (ret) {
+		dev_dbg(eci->dev, "can't init ECI buttons\n");
+		return ret;
+	}
+
+	eci->mem_ok = true;
+	msleep(ECI_WAIT_BUS_SETTLE);
+
+	if (eci->eci_hw_ops->acc_write_reg(ECICMD_MIC_CTRL, eci->mic_state))
+		dev_err(eci->dev, "Unable to control headset microphone\n");
+
+	return 0;
+}
+
+/* Press/release accessory button(s) */
+static int eci_get_button(struct eci_data *eci)
+{
+	struct enchancement_features_fixed *eff = eci->e_features_fix;
+	struct eci_buttons_data *b = &eci->buttons_data;
+
+	if (!eci->mem_ok)
+		return -ENXIO;
+
+	if (((b->buttons & b->buttons_up_mask) == 0) &&
+			(eff->number_of_features > 2)) {
+		dev_err(eci->dev, "ECI report all buttons down, rejected\n");
+		return -EINVAL;
+	}
+
+	if (b->windex < ECI_BUTTON_BUF_SIZE) {
+		if (b->buttons_buf[b->windex] == 0)
+			b->buttons_buf[b->windex] = b->buttons;
+		else
+			dev_err(eci->dev, "ECI button queue owerflow\n");
+	}
+	b->windex++;
+	if (b->windex == ECI_BUTTON_BUF_SIZE)
+		b->windex = 0;
+
+	return 0;
+}
+
+/* Intended to use ONLY inside eci_parse_button() ! */
+#define ACTIVE_STATE(x) (u32)(cpu_to_le32(*(u32 *)efv->active_state) & BIT(x-1))
+#define BUTTON_STATE(x) ((buttons & BIT(x))>>1)
+
+static int eci_parse_button(struct eci_data *eci, u32 buttons)
+{
+	int pin, state;
+	u8 n, io_fun;
+	struct enchancement_features_variable *efv = &eci->e_features_var;
+	struct enchancement_features_fixed *eff = eci->e_features_fix;
+
+	if (!eci->mem_ok)
+		return -ENXIO;
+
+	n = eff->number_of_features;
+
+	for (pin = 1; pin <= n; pin++) {
+		io_fun = efv->io_functionality[pin] & ~BIT(7);
+		if (io_fun > ECI_KEY_MAX)
+			break;
+		state = (BUTTON_STATE(pin) == ACTIVE_STATE(pin));
+		if (state)
+			dev_dbg(eci->dev, "I/O functionality 0x%02x\n", io_fun);
+
+		sparse_keymap_report_event(eci->acc_input, io_fun, state,
+				false);
+	}
+	input_sync(eci->acc_input);
+
+	return 0;
+}
+static int eci_send_button(struct eci_data *eci)
+{
+	int i;
+	struct enchancement_features_fixed *eff = eci->e_features_fix;
+	struct eci_buttons_data *b = &eci->buttons_data;
+	u8 n;
+
+	if (!eci->mem_ok)
+		return -ENXIO;
+
+	n = eff->number_of_features;
+
+	if (n > ECI_MAX_FEATURE_COUNT)
+		return -EINVAL;
+
+	/* Let input system take care multiple key events */
+	for (i = 0; i < ECI_BUTTON_BUF_SIZE; i++) {
+		if (b->buttons_buf[b->rindex] == 0)
+			break;
+
+		if (eci_parse_button(eci, b->buttons_buf[b->rindex]))
+			return -ENXIO;
+
+		b->buttons_buf[b->rindex] = 0;
+		b->rindex++;
+		if (b->rindex == ECI_BUTTON_BUF_SIZE)
+			b->rindex = 0;
+	}
+
+	return 0;
+}
+
+/* General work func (eci_ws) for several tasks */
+static void eci_work(struct work_struct *ws)
+{
+	struct eci_data *eci;
+	int ret;
+
+	eci = container_of((struct delayed_work *)ws, struct eci_data, eci_ws);
+
+	ret = eci_send_button(eci);
+	if (ret)
+		dev_err(eci->dev, "Error sending event\n");
+}
+
+/* This is called from platform audio driver when microphone routings changes */
+static void eci_hsmic_event(void *priv, bool on)
+{
+	struct eci_data *eci = priv;
+	unsigned long future;
+	int ret;
+
+	if (!eci)
+		return;
+
+	if (!eci->plugged)
+		return;
+
+	if (on)
+		eci->mic_state = ECI_MIC_AUTO;
+	else
+		eci->mic_state = ECI_MIC_OFF;
+
+	future = jiffies + msecs_to_jiffies(ECI_TRY_SET_MIC);
+	do {
+		ret = eci->eci_hw_ops->acc_write_reg(ECICMD_MIC_CTRL,
+				eci->mic_state);
+		if (time_is_before_jiffies(future))
+			break;
+	} while (ret);
+
+	if (ret)
+		dev_err(eci->dev, "Unable to control headset microphone\n");
+}
+
+/*
+ * Other driver(s) can call this after registering themselves using
+ * eci_register()
+ */
+static void eci_accessory_event(int event, void *priv)
+{
+	struct eci_data *eci = priv;
+	struct eci_buttons_data *b = &eci->buttons_data;
+	int delay = 0;
+	int ret = 0;
+
+	eci->event = event;
+	switch (event) {
+	case ECI_EVENT_IS_ECI:
+		eci->is_eci = true;
+		ret = eci->eci_hw_ops->acc_reset();
+		if (ret)
+			eci->is_eci = false;
+		break;
+	case ECI_EVENT_PLUG_IN:
+		eci->first_event = true;
+		ret = eci_init_accessory(eci);
+		if (ret < 0)
+			ret = eci_init_accessory(eci);
+		if (ret) {
+			dev_err(eci->dev, "Accessory init %s%s%s%s\n",
+					ret & ACI_COMMERR ? "COMMERR " : "",
+					ret & ACI_FRAERR ? "FRAERR " : "",
+					ret & ACI_RESERR ? "RESERR " : "",
+					ret & ACI_COLL ? "COLLERR " : "");
+			break;
+		}
+		break;
+	case ECI_EVENT_PLUG_OUT:
+		/* send all buttons up as last event */
+		b->buttons = b->buttons_up_mask;
+		eci_get_button(eci);
+		eci_send_button(eci);
+		eci->mem_ok = false;
+		break;
+	case ECI_EVENT_BUTTON:
+		/*
+		 * First event might not be valid due plug insertion
+		 * so we filter it out if it seems garbage
+		 */
+		if (eci->first_event) {
+			eci->first_event = false;
+			if ((b->buttons & 0xff) == 0)
+				break;
+		}
+		eci_get_button(eci);
+		delay = msecs_to_jiffies(ECI_WAIT_SEND_BUTTON);
+		schedule_delayed_work(&eci->eci_ws, delay);
+		break;
+	default:
+		dev_err(eci->dev, "Unknown accessory event %d\n", event);
+		break;
+	}
+
+	return;
+}
+
+static void __eci_disable(struct eci_data *eci)
+{
+	/* Disconnect ECI accessory's microphone */
+	eci_hsmic_event(eci, false);
+}
+
+static void __eci_enable(struct eci_data *eci)
+{
+	/* ECI accessory's microphone into auto mode */
+	eci_hsmic_event(eci, true);
+}
+
+void eci_suspend(struct eci_data *eci)
+{
+	mutex_lock(&eci->mutex);
+
+	if (!eci->suspended && eci->opened)
+		__eci_disable(eci);
+
+	eci->suspended = true;
+
+	mutex_unlock(&eci->mutex);
+}
+EXPORT_SYMBOL(eci_suspend);
+
+void eci_resume(struct eci_data *eci)
+{
+	mutex_lock(&eci->mutex);
+
+	if (eci->suspended && eci->opened)
+		__eci_enable(eci);
+
+	eci->suspended = false;
+
+	mutex_unlock(&eci->mutex);
+}
+EXPORT_SYMBOL(eci_resume);
+
+/*
+ * sysfs entries:
+ * memory	R	ECI accessory memory content
+ * cable	RW	accessory plugged/unplugged 0/1
+ */
+static ssize_t show_eci_memory(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct eci_data *eci = the_eci;
+
+	if (!eci->mem_ok)
+		return -ENXIO;
+
+	memcpy(buf, eci->memory, eci->mem_size);
+
+	return eci->mem_size;
+}
+
+static ssize_t show_cable_plugged(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct eci_data *eci = the_eci;
+
+	return snprintf(buf, sizeof(buf), "%d\n", eci->plugged);
+}
+
+static ssize_t store_cable_plugged(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t len)
+{
+	struct eci_data *eci = the_eci;
+	long unsigned int tmp;
+
+	if (strict_strtoul(buf, 0, &tmp))
+		return -EINVAL;
+
+	eci->plugged = !!tmp;
+	if (eci->plugged)
+		eci_accessory_event(ECI_EVENT_PLUG_IN, eci);
+	else
+		eci_accessory_event(ECI_EVENT_PLUG_OUT, eci);
+
+	return len;
+}
+
+static DEVICE_ATTR(memory, S_IRUGO, show_eci_memory, NULL);
+static DEVICE_ATTR(cable, S_IRUGO | S_IWUSR , show_cable_plugged,
+		store_cable_plugged);
+
+static struct attribute *eci_attributes[] = {
+	&dev_attr_memory.attr,
+	&dev_attr_cable.attr,
+	NULL
+};
+
+static struct attribute_group eci_attr_group = {
+	.attrs = eci_attributes
+};
+
+static int eci_input_open(struct input_dev *input)
+{
+	struct eci_data *eci = the_eci;
+
+	mutex_lock(&eci->mutex);
+
+	if (!eci->suspended)
+		__eci_enable(eci);
+
+	eci->opened = true;
+
+	mutex_unlock(&eci->mutex);
+
+	return 0;
+}
+
+static void eci_input_close(struct input_dev *input)
+{
+	struct eci_data *eci = the_eci;
+
+	mutex_lock(&eci->mutex);
+
+	if (!eci->suspended)
+		__eci_disable(eci);
+
+	eci->opened = false;
+
+	mutex_unlock(&eci->mutex);
+}
+
+static int init_accessory_input(struct eci_data *eci)
+{
+	int err;
+
+	eci->acc_input = input_allocate_device();
+	if (!eci->acc_input) {
+		dev_err(eci->dev, "Error allocating input device\n");
+		return -ENOMEM;
+	}
+
+	eci->acc_input->name = "ECI Accessory";
+	eci->acc_input->open = eci_input_open;
+	eci->acc_input->close = eci_input_close;
+
+	input_set_drvdata(eci->acc_input, eci);
+
+	err = sparse_keymap_setup(eci->acc_input, eci_keymap, NULL);
+	if (err)
+		goto err_free_dev;
+
+	__set_bit(EV_REP, eci->acc_input->evbit);
+
+	err = input_register_device(eci->acc_input);
+	if (err) {
+		dev_err(eci->dev, "Error registering input device\n");
+		goto err_free_keymap;
+	}
+
+	/* Must set after input_register_device() to take effect */
+	eci->acc_input->rep[REP_PERIOD] = ECI_KEY_REPEAT_INTERVAL;
+
+	return 0;
+
+err_free_keymap:
+	sparse_keymap_free(eci->acc_input);
+err_free_dev:
+	input_free_device(eci->acc_input);
+	return err;
+}
+
+struct eci_cb *eci_register(struct device *dev, struct eci_hw_ops *eci_ops)
+{
+	struct eci_data *eci;
+	int ret;
+
+	eci = kzalloc(sizeof(*eci), GFP_KERNEL);
+	if (!eci)
+		return ERR_PTR(-ENOMEM);
+
+	eci->dev = dev;
+
+	the_eci = eci;
+
+	if (!eci_ops || !eci_ops->acc_read_direct ||
+			!eci_ops->acc_read_reg || !eci_ops->acc_write_reg ||
+			!eci_ops->acc_reset ||
+			!eci_ops->register_hsmic_event_cb)
+		return ERR_PTR(-EINVAL);
+
+	eci->eci_hw_ops = eci_ops;
+	/*
+	 * If platform machine has audio driver providing
+	 * register_hsmic_event_cb, we should give accessory microphone control,
+	 * ie. eci_hsmic_event to it.
+	 * This way audio driver get control to ECI accessory microphone and
+	 * we can save power
+	 */
+	if (eci_ops->register_hsmic_event_cb) {
+		hsmic_event.private	= eci;
+		hsmic_event.event	= eci_hsmic_event;
+		eci_ops->register_hsmic_event_cb(&hsmic_event);
+	}
+
+	mutex_init(&eci->mutex);
+
+	eci_callback.event              = eci_accessory_event;
+	eci_callback.priv               = eci;
+
+	/* /sys/bus/i2c/devices/<adapter>-<address> */
+	ret = sysfs_create_group(&dev->kobj, &eci_attr_group);
+	if (ret) {
+		dev_err(eci->dev, "Could not create sysfs entries\n");
+		goto err_sysfs;
+	}
+
+	ret = init_accessory_input(eci);
+	if (ret) {
+		dev_err(eci->dev, "ERROR initializing accessory input\n");
+		goto err_input;
+	}
+
+	init_waitqueue_head(&eci->wait);
+	INIT_DELAYED_WORK(&eci->eci_ws, eci_work);
+
+	eci->plugged = 0;
+	eci->mem_ok = false;
+	/*
+	 * By default ECI driver leaves microphone off, to save power.
+	 * Audio driver can set microphone on by using
+	 * hsmic_event.event
+	 */
+	eci->mic_state = ECI_MIC_OFF;
+
+	/* Init buttons_data indexes and buffer */
+	memset(&eci->buttons_data, 0, sizeof(struct eci_buttons_data));
+	eci->buttons_data.buttons = 0xffffffff;
+
+	return &eci_callback;
+
+err_input:
+	sysfs_remove_group(&dev->kobj, &eci_attr_group);
+
+err_sysfs:
+	kfree(eci);
+
+	return ERR_PTR(-EBUSY);
+}
+EXPORT_SYMBOL(eci_register);
+
+int eci_remove(struct eci_data *eci)
+{
+	eci->eci_hw_ops->register_hsmic_event_cb(NULL);
+	cancel_delayed_work_sync(&eci->eci_ws);
+	sysfs_remove_group(&eci->dev->kobj, &eci_attr_group);
+	input_unregister_device(eci->acc_input);
+	kfree(eci);
+
+	return 0;
+}
+EXPORT_SYMBOL(eci_remove);
+
+MODULE_ALIAS("i2c:" ECI_DRIVERNAME);
+MODULE_AUTHOR("Nokia Corporation");
+MODULE_DESCRIPTION("ECI accessory driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/misc/eci_at20-i2c.c b/drivers/input/misc/eci_at20-i2c.c
new file mode 100644
index 0000000..9f9bf53
--- /dev/null
+++ b/drivers/input/misc/eci_at20-i2c.c
@@ -0,0 +1,713 @@
+/*
+ * This file is part of ECI (Enhancement Control Interface) controller
+ * driver
+ *
+ * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Tapio Vihuri <tapio.vihuri@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+/*
+ * ECI stands for (Enhancement Control Interface).
+ *
+ * ECI is better known as Multimedia Headset for Nokia phones.
+ * If headset has many buttons, like play, vol+, vol- etc. then it is propably
+ * ECI accessory.
+ *
+ * ECI controller is kind of bridge between host CPU I2C and ECI accessory
+ * ECI communication.
+ */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/debugfs.h>
+#include <linux/input/eci.h>
+
+#define DRIVER_NAME	"eci_ctrl"
+
+#define ECICTRL_STATUS_DATA_READY	0x01
+#define ECICTRL_STATUS_ACCESSORY_INT	0x02
+
+#define ECICTRL_WAIT_IRQ		100	/* msec */
+#define ECI_RST_MIN		62
+#define ECI_RST_WAIT		10	/* msec */
+
+struct eci_at20_data {
+	struct device		*dev;
+	struct eci_cb		*eci_callback;
+	int			eci_rst_gpio;
+	int			eci_sw_ctrl_gpio;
+	int			eci_int_gpio;
+	wait_queue_head_t	wait;
+	bool			wait_eci_buttons;
+	bool			wait_data;
+};
+
+static struct eci_at20_data *the_ed;
+
+/* For eci_at20 controller internal registers */
+static int eci_at20_read_reg(u8 reg)
+{
+	struct i2c_client *client = to_i2c_client(the_ed->dev);
+
+	if (reg <= ECICMD_RESERVED)
+		return -EINVAL;
+
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static int eci_at20_write_reg(u8 reg, u8 param)
+{
+	struct i2c_client *client = to_i2c_client(the_ed->dev);
+
+	if (reg <= ECICMD_RESERVED)
+		return -EINVAL;
+
+	return i2c_smbus_write_byte_data(client, reg, param);
+}
+
+/*
+ * Struct eci_data is ECI input driver (dealing ECI accessories) data.
+ * Struct eci_at20_data is this driver data, dealing just ECI communication.
+ * Global eci_register() pairs structs so that we can call ECI input driver
+ * event function with eci_data
+ */
+static void eci_at20_emit_buttons(struct eci_at20_data *ed, bool force_up)
+{
+	struct eci_data *eci = ed->eci_callback->priv;
+	struct eci_buttons_data *b = &eci->buttons_data;
+
+	if (force_up)
+		b->buttons = b->buttons_up_mask;
+
+	ed->eci_callback->event(ECI_EVENT_BUTTON, eci);
+}
+
+/* Trigger ECI accessory register data write (from accessory) */
+static int eci_fire_acc_read_reg(u8 reg, int count)
+{
+	struct i2c_client *client = to_i2c_client(the_ed->dev);
+
+	if (!eci_at20_write_reg(ECIREG_READ_COUNT, count))
+		return i2c_smbus_read_byte_data(client, reg);
+	else
+		return -EIO;
+}
+
+/* For ECI accessory internal registers */
+static int eci_acc_read_reg(u8 reg, u8 *buf, int count)
+{
+	s32 ret;
+	int i;
+
+	if (reg > ECICMD_RESERVED)
+		return -EINVAL;
+
+	the_ed->wait_data = false;
+	if (eci_fire_acc_read_reg(reg, count))
+		return -EIO;
+
+	if (!wait_event_timeout(the_ed->wait, the_ed->wait_data == true,
+				msecs_to_jiffies(ECICTRL_WAIT_IRQ)))
+		return -EIO;
+
+	for (i = 0; i < count; i++) {
+		ret = eci_at20_read_reg(ECIREG_READ_DIRECT + i);
+		if (ret < 0)
+			return ret;
+
+		buf[i] = ret;
+	}
+
+	return 0;
+}
+
+/* ECI accessory register write */
+static int eci_acc_write_reg(u8 reg, u8 param)
+{
+	struct i2c_client *client = to_i2c_client(the_ed->dev);
+
+	if (reg > ECICMD_RESERVED)
+		return -EINVAL;
+
+	return i2c_smbus_write_byte_data(client, reg, param);
+}
+
+/*
+ * debugfs entries:
+ * reset	RW	ECI controller reset line
+ * button	W	fake button data
+ * debug	RW	ECI controller test register
+ * mic		RW	accessory's microphone auto/on/off
+ */
+#ifdef CONFIG_DEBUG_FS
+static struct dentry *eci_at20_debugfs_dir;
+
+static ssize_t reset_read(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	struct eci_at20_data *ed = file->private_data;
+	char buf[80];
+	int len = 0;
+	int ret;
+
+	if (*ppos == 0) {
+		ret = !!gpio_get_value(ed->eci_rst_gpio);
+		len = snprintf(buf, sizeof(buf), "%d\n", ret);
+	}
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	return ret;
+}
+
+static ssize_t reset_write(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	/* Assosiated in default_open() */
+	struct eci_at20_data *ed = file->private_data;
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	if (!memcmp(buf, "0", 1))
+		gpio_set_value(ed->eci_rst_gpio, 0);
+	else if (!memcmp(buf, "1", 1))
+		gpio_set_value(ed->eci_rst_gpio, 1);
+
+	return count;
+}
+
+static ssize_t button_write(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	/* Assosiated in default_open() */
+	struct eci_at20_data *ed = file->private_data;
+	struct eci_data *eci = ed->eci_callback->priv;
+	struct eci_buttons_data *b = &eci->buttons_data;
+	char buf[32];
+	int buf_size, ret;
+	unsigned long val;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	ret = strict_strtoul(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	b->buttons = val;
+	eci_at20_emit_buttons(ed, ECI_REAL_BUTTONS);
+
+	return count;
+}
+
+static ssize_t debug_read(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	char buf[80];
+	int len = 0;
+	int ret;
+
+	if (*ppos == 0) {
+		ret = eci_at20_read_reg(ECIREG_TEST_IN);
+		if (ret < 0)
+			return ret;
+		len += snprintf(buf + len, sizeof(buf) - len, "%02x\n", ret);
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	return ret;
+}
+
+static ssize_t debug_write(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	char buf[80];
+	int buf_size;
+	unsigned long val;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	buf[buf_size] = '\0';
+	if (!strict_strtoul(buf, 0, &val))
+		eci_at20_write_reg(ECIREG_TEST_OUT, val);
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t mic_read(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	/* Assosiated in default_open() */
+	struct eci_at20_data *ed = file->private_data;
+	struct eci_data *eci = ed->eci_callback->priv;
+	char buf[80], *state;
+	int len = 0;
+	int ret;
+
+	if (!eci->mem_ok)
+		return -ENODEV;
+
+	/* Do not run twice */
+	if (*ppos == 0) {
+		ret = eci_acc_read_reg(ECICMD_MIC_CTRL, buf, 1);
+		if (ret)
+			return ret;
+
+		eci->mic_state = buf[0];
+		switch (eci->mic_state) {
+		case ECI_MIC_AUTO:
+			state = "auto";
+			break;
+		case ECI_MIC_OFF:
+			state = "off";
+			break;
+		case ECI_MIC_ON:
+			state = "on";
+			break;
+		default:
+			state = "unknown";
+			break;
+		}
+
+		len = snprintf(buf, sizeof(buf), "microphone %s\n", state);
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	return ret;
+}
+
+static ssize_t mic_write(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	/* Assosiated in default_open() */
+	struct eci_at20_data *ed = file->private_data;
+	struct eci_data *eci = ed->eci_callback->priv;
+	char buf[80];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	if (!memcmp(buf, "auto", 4))
+		eci->mic_state = ECI_MIC_AUTO;
+	else if (!memcmp(buf, "off", 3))
+		eci->mic_state = ECI_MIC_OFF;
+	else if (!memcmp(buf, "on", 2))
+		eci->mic_state = ECI_MIC_ON;
+
+	if (eci_acc_write_reg(ECICMD_MIC_CTRL, eci->mic_state))
+		dev_err(eci->dev, "Unable to control headset microphone\n");
+
+	return count;
+}
+
+static int default_open(struct inode *inode, struct file *file)
+{
+	/* Assosiated in debugfs_create_file() */
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static const struct file_operations reset_fops = {
+	.open	= default_open,
+	.read	= reset_read,
+	.write	= reset_write,
+};
+
+static const struct file_operations button_fops = {
+	.open	= default_open,
+	.write	= button_write,
+};
+
+static const struct file_operations debug_fops = {
+	.open	= default_open,
+	.read	= debug_read,
+	.write	= debug_write,
+};
+
+static const struct file_operations mic_fops = {
+	.open	= default_open,
+	.read	= mic_read,
+	.write	= mic_write,
+};
+
+static void eci_at20_uninitialize_debugfs(void)
+{
+	if (eci_at20_debugfs_dir)
+		debugfs_remove_recursive(eci_at20_debugfs_dir);
+}
+
+static long eci_at20_initialize_debugfs(struct eci_at20_data *ed)
+{
+	void *ok;
+
+	/* /sys/kernel/debug/eci_ctrl */
+	eci_at20_debugfs_dir = debugfs_create_dir(ed->dev->driver->name, NULL);
+	if (!eci_at20_debugfs_dir)
+		return -ENOENT;
+
+	/* Struct ed assosiated to inode->i_private */
+	ok = debugfs_create_file("reset", S_IRUGO | S_IWUSR,
+			eci_at20_debugfs_dir, ed, &reset_fops);
+	if (!ok)
+		goto fail;
+
+	ok = debugfs_create_file("button", S_IWUSR,
+			eci_at20_debugfs_dir, ed, &button_fops);
+	if (!ok)
+		goto fail;
+
+	ok = debugfs_create_file("debug", S_IRUGO,
+			eci_at20_debugfs_dir, ed, &debug_fops);
+	if (!ok)
+		goto fail;
+
+	ok = debugfs_create_file("mic", S_IRUGO | S_IWUSR,
+			eci_at20_debugfs_dir, ed, &mic_fops);
+	if (!ok)
+		goto fail;
+
+	return 0;
+fail:
+	eci_at20_uninitialize_debugfs();
+	return -ENOENT;
+}
+#else
+#define eci_at20_initialize_debugfs(ed)	1
+#define eci_at20_uninitialize_debugfs()
+#endif
+
+/* Reset and learn ECI accessory, ie. get speed */
+static int eci_acc_reset(void)
+{
+	s32 ret;
+
+	eci_at20_write_reg(ECIREG_RST_LEARN, 0);
+
+	msleep(ECI_RST_WAIT);
+
+	ret = eci_at20_read_reg(ECIREG_RST_LEARN);
+	if (ret < ECI_RST_MIN)
+		return -EIO;
+
+	return 0;
+}
+
+/* Read always four bytes, as stated in ECI specification */
+static int eci_acc_read_direct(u8 addr, char *buf)
+{
+	s32 ret;
+	int i;
+
+	/* Initiate ECI accessory memory read */
+	the_ed->wait_data = false;
+	if (!eci_at20_write_reg(ECIREG_READ_COUNT, 4))
+		if (eci_at20_write_reg(ECIREG_READ_DIRECT, addr))
+			return -EIO;
+
+	if (!wait_event_timeout(the_ed->wait, the_ed->wait_data == true,
+				msecs_to_jiffies(ECICTRL_WAIT_IRQ)))
+		return -EIO;
+
+	for (i = 0; i < 4; i++) {
+		ret = eci_at20_read_reg(ECIREG_READ_DIRECT + i);
+		if (ret < 0)
+			return ret;
+		buf[i] = ret;
+		usleep_range(2000, 10000);
+	}
+	return 0;
+}
+
+static void eci_at20_get_buttons(u8 *buf, u8 count)
+{
+	int i, ret;
+
+	if (count > 4) {
+		dev_err(the_ed->dev, "Maximum four bytes allowed\n");
+		return;
+	}
+
+	for (i = 0; i <= count; i++) {
+		ret = eci_at20_read_reg(ECIREG_READ_DIRECT + i);
+		buf[i] = ret;
+	}
+}
+
+static irqreturn_t eci_at20_irq_handler(int irq, void *_ed)
+{
+	struct eci_at20_data *ed = _ed;
+	struct eci_data *eci = ed->eci_callback->priv;
+	struct eci_buttons_data *b = &eci->buttons_data;
+	int status;
+	char buf[4];
+
+	/* Clears eci_at20 DATA interrupt */
+	status = eci_at20_read_reg(ECIREG_STATUS);
+
+	if (status & ECICTRL_STATUS_DATA_READY) {
+		/*
+		 * Buttons are special case as we want be fast with them
+		 * and this way we cope with nested button and data interrupts
+		 * The number of bytes needed to read is parsed in ECI
+		 * input driver, based on data in ECI accessory.
+		 * Maximum four bytes.
+		 */
+		if (ed->wait_eci_buttons) {
+			eci_at20_get_buttons(buf, eci->port_reg_count);
+			b->buttons = cpu_to_le32(*(u32 *)buf);
+			eci_at20_emit_buttons(ed, ECI_REAL_BUTTONS);
+			ed->wait_eci_buttons = false;
+		}
+		/* Complete ECI data reading */
+		ed->wait_data = true;
+		wake_up(&ed->wait);
+	}
+
+	/* Accessory interrupt, ie. button pressed */
+	if (status & ECICTRL_STATUS_ACCESSORY_INT) {
+		if (eci->mem_ok) {
+			eci_fire_acc_read_reg(ECICMD_PORT_DATA_0, 2);
+			ed->wait_eci_buttons = true;
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct eci_at20_data *eci_at20_initialize(struct device *dev)
+{
+	struct eci_at20_data *ed;
+	struct eci_platform_data *pd = dev->platform_data;
+	int ret;
+
+	if (!pd) {
+		dev_err(dev, "platform_data not available\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	ed = kzalloc(sizeof(*ed), GFP_KERNEL);
+	if (!ed)
+		return ERR_PTR(-ENOMEM);
+
+	ed->dev = dev;
+	ed->eci_rst_gpio = pd->eci_rst_gpio;
+	ed->eci_sw_ctrl_gpio = pd->eci_sw_ctrl_gpio;
+	ed->eci_int_gpio = pd->eci_int_gpio;
+
+	if (ed->eci_rst_gpio == 0 || ed->eci_sw_ctrl_gpio == 0 ||
+			ed->eci_int_gpio == 0) {
+		ret = -ENXIO;
+		goto gpio_err;
+	}
+
+	the_ed = ed;
+
+	ret = eci_at20_initialize_debugfs(ed);
+	if (ret)
+		dev_err(dev, "could not create debugfs entries\n");
+
+	ret = gpio_request(ed->eci_rst_gpio, "ECI_RSTn");
+	if (ret) {
+		dev_err(dev, "could not request ECI_RSTn gpio %d\n",
+				ed->eci_rst_gpio);
+		goto rst_gpio_err;
+	}
+
+	gpio_direction_output(ed->eci_rst_gpio, 0);
+	gpio_set_value(ed->eci_rst_gpio, 1);
+
+	ret = gpio_request(ed->eci_sw_ctrl_gpio, "ECI_SW_CTRL");
+	if (ret) {
+		dev_err(dev, "could not request ECI_SW_CTRL gpio %d\n",
+				ed->eci_sw_ctrl_gpio);
+		goto sw_ctrl_gpio_err;
+	}
+
+	gpio_direction_input(ed->eci_sw_ctrl_gpio);
+
+	ret = gpio_request(ed->eci_int_gpio, "ECI_INT");
+	if (ret) {
+		dev_err(dev, "could not request ECI_INT gpio %d\n",
+				ed->eci_int_gpio);
+		goto int_gpio_err;
+	}
+
+	gpio_direction_input(ed->eci_int_gpio);
+
+	ret = request_threaded_irq(gpio_to_irq(ed->eci_int_gpio), NULL,
+			eci_at20_irq_handler, IRQF_TRIGGER_RISING,
+			"ECI_INT", ed);
+	if (ret) {
+		dev_err(dev, "could not request irq %d\n",
+				gpio_to_irq(ed->eci_int_gpio));
+		goto int_irq_err;
+	}
+
+	init_waitqueue_head(&ed->wait);
+
+	return ed;
+
+int_irq_err:
+	gpio_free(ed->eci_int_gpio);
+int_gpio_err:
+	gpio_free(ed->eci_sw_ctrl_gpio);
+sw_ctrl_gpio_err:
+	gpio_set_value(ed->eci_rst_gpio, 0);
+	gpio_free(ed->eci_rst_gpio);
+rst_gpio_err:
+	eci_at20_uninitialize_debugfs();
+gpio_err:
+	kfree(ed);
+
+	return ERR_PTR(ret);
+}
+
+static struct eci_hw_ops eci_at20_hw_ops = {
+	.acc_reset              = eci_acc_reset,
+	.acc_read_direct        = eci_acc_read_direct,
+	.acc_read_reg           = eci_acc_read_reg,
+	.acc_write_reg          = eci_acc_write_reg,
+};
+
+static int __devinit eci_at20_i2c_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct eci_at20_data *ed;
+	struct eci_platform_data *pd = client->dev.platform_data;
+
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&client->dev, "SMBUS byte data not supported\n");
+		return -EIO;
+	}
+
+	ed = eci_at20_initialize(&client->dev);
+
+	if (IS_ERR(ed))
+		return PTR_ERR(ed);
+
+	eci_at20_hw_ops.register_hsmic_event_cb = pd->register_hsmic_event_cb;
+	/* Register itself to the ECI core */
+	ed->eci_callback = eci_register(&client->dev, &eci_at20_hw_ops);
+
+	i2c_set_clientdata(client, ed);
+
+	return 0;
+}
+
+static int __devexit eci_at20_remove(struct i2c_client *client)
+{
+	struct eci_at20_data *ed = i2c_get_clientdata(client);
+	struct eci_data *eci = ed->eci_callback->priv;
+
+	eci_remove(eci);
+
+	gpio_set_value(ed->eci_rst_gpio, 0);
+	gpio_free(ed->eci_rst_gpio);
+
+	gpio_free(ed->eci_sw_ctrl_gpio);
+
+	free_irq(gpio_to_irq(ed->eci_int_gpio), ed);
+	gpio_free(ed->eci_int_gpio);
+
+	eci_at20_uninitialize_debugfs();
+
+	kfree(ed);
+
+	return 0;
+}
+
+#ifdef	CONFIG_PM
+static int eci_at20_suspend(struct i2c_client *client, pm_message_t message)
+{
+	struct eci_at20_data *ed = i2c_get_clientdata(client);
+	struct eci_data *eci = ed->eci_callback->priv;
+
+	eci_suspend(eci);
+
+	return 0;
+}
+
+static int eci_at20_resume(struct i2c_client *client)
+{
+	struct eci_at20_data *ed = i2c_get_clientdata(client);
+	struct eci_data *eci = ed->eci_callback->priv;
+
+	eci_resume(eci);
+
+	return 0;
+}
+#else
+#define	eci_at20_suspend	NULL
+#define	eci_at20_resume		NULL
+#endif
+
+static const struct i2c_device_id eci_id[] = {
+	{ DRIVER_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, eci_id);
+
+static struct i2c_driver eci_i2c_driver = {
+	.driver = {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= eci_at20_i2c_probe,
+	.remove		= __devexit_p(eci_at20_remove),
+	.suspend	= eci_at20_suspend,
+	.resume		= eci_at20_resume,
+	.id_table	= eci_id,
+};
+
+static int __init eci_at20_init(void)
+{
+	return i2c_add_driver(&eci_i2c_driver);
+}
+module_init(eci_at20_init);
+
+static void __devexit eci_at20_exit(void)
+{
+	i2c_del_driver(&eci_i2c_driver);
+}
+module_exit(eci_at20_exit);
+
+MODULE_DESCRIPTION("ECI accessory controller driver");
+MODULE_AUTHOR("Nokia Corporation");
+MODULE_ALIAS("i2c:eci_ctrl");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/input/eci.h b/include/linux/input/eci.h
new file mode 100644
index 0000000..60b820e
--- /dev/null
+++ b/include/linux/input/eci.h
@@ -0,0 +1,189 @@
+/*
+ * This file is part of ECI (Enhancement Control Interface) driver
+ *
+ * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Tapio Vihuri <tapio.vihuri@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+#ifndef __ECI_H__
+#define __ECI_H__
+
+#define ECI_MAX_MEM_SIZE	0x7c
+#define ECI_BUTTON_BUF_SIZE	32
+#define ECI_MAX_FEATURE_COUNT	31
+
+#define ACI_COMMERR	0x010
+#define ACI_FRAERR	0x020
+#define ACI_RESERR	0x040
+#define ACI_COLL	0x080
+
+#define ECI_REAL_BUTTONS	0
+#define ECI_FORCE_BUTTONS_UP	1
+
+/* ECI accessory register's bits */
+#define ECI_MIC_AUTO	0x00
+#define ECI_MIC_OFF	0x5a
+#define ECI_MIC_ON	0xff
+
+/*
+ * VPROG2CNT - VPROG2 Control Register
+ * 2.5V | normal | normal
+ * 10   | 111    | 111
+ * 2.5V | off    | off
+ * 10   | 100    | 100
+ */
+#define AvP_MSIC_VPROG2		0xd7
+#define AvP_MSIC_VPROG2_2V5_ON	0xbf
+#define AvP_MSIC_VPROG2_2V5_OFF 0xa4
+
+#define GPIO_ECI_RSTn		126	/* GP_CORE_030 + 96 */
+#define GPIO_ECI_SW_CTRL	178	/* GP_CORE_082 + 96 */
+#define GPIO_ECI_INT		16	/* GP_AON_016 */
+
+/* fixed in ECI HW, do not change */
+enum {
+	ECICMD_HWID,
+	ECICMD_SWID,
+	ECICMD_ECI_BUS_SPEED,
+	ECICMD_MIC_CTRL,
+	ECICMD_MASTER_INT_REG,
+	ECICMD_HW_CONF_MEM_ACCESS,
+	ECICMD_EXTENDED_MEM_ACCESS,
+	ECICMD_INDIRECT_MEM_ACCESS,
+	ECICMD_PORT_DATA_0,
+	ECICMD_PORT_DATA_1,
+	ECICMD_PORT_DATA_2,
+	ECICMD_PORT_DATA_3,
+	ECICMD_LATCHED_PORT_DATA_0,
+	ECICMD_LATCHED_PORT_DATA_1,
+	ECICMD_LATCHED_PORT_DATA_2,
+	ECICMD_LATCHED_PORT_DATA_3,
+	ECICMD_DATA_DIR_0,
+	ECICMD_DATA_DIR_1,
+	ECICMD_DATA_DIR_2,
+	ECICMD_DATA_DIR_3,
+	ECICMD_INT_CONFIG_0_LOW,
+	ECICMD_INT_CONFIG_0_HIGH,
+	ECICMD_INT_CONFIG_1_LOW,
+	ECICMD_INT_CONFIG_1_HIGH,
+	ECICMD_INT_CONFIG_2_LOW,
+	ECICMD_INT_CONFIG_2_HIGH,
+	ECICMD_INT_CONFIG_3_LOW,
+	ECICMD_INT_CONFIG_3_HIGH,
+	/*
+	 * 0x1c - 0x2f reserved for future
+	 * 0x30 - 0x3d reserved
+	 */
+	ECICMD_EEPROM_LOCK = 0x3e,
+	ECICMD_RESERVED,	/* 0x3f */
+	ECIREG_STATUS,		/* 0x40 */
+	ECIREG_READ_COUNT,	/* 0x41 */
+	ECIREG_BUF_COUNT,	/* 0x42 */
+	ECIREG_RST_LEARN,	/* 0x43 */
+	/* 0x44 - 0xdf as data buffer */
+	ECIREG_READ_DIRECT,	/* 0x44 */
+	ECIREG_HW_ID = 0xe0,	/* 0xe0 */
+	ECIREG_FW_ID,		/* 0xe1 */
+	ECIREG_TEST_IN,		/* 0xe2 */
+	ECIREG_TEST_OUT,	/* 0xe3 */
+};
+
+enum {
+	ECI_EVENT_IS_ECI,
+	ECI_EVENT_PLUG_IN,
+	ECI_EVENT_PLUG_OUT,
+	ECI_EVENT_BUTTON,
+	ECI_EVENT_NO,
+};
+
+struct audio_hsmic_event {
+	void *private;
+	void (*event)(void *priv, bool on);
+};
+
+struct eci_hw_ops {
+	int (*acc_reset)(void);
+	int (*acc_read_direct)(u8 addr, char *buf);
+	int (*acc_read_reg)(u8 reg, u8 *buf, int count);
+	int (*acc_write_reg)(u8 reg, u8 param);
+	void (*register_hsmic_event_cb)(struct audio_hsmic_event *);
+};
+
+struct eci_cb {
+	void *priv;
+	void (*event)(int event, void *priv);
+};
+
+struct enchancement_features_fixed {
+	u8	block_id;
+	u8	length;
+	u8	connector_conf;
+	u8	number_of_features;
+};
+
+struct enchancement_features_variable {
+	u8	*io_support;
+	u8	*io_functionality;
+	u8	*active_state;
+};
+
+struct eci_buttons_data {
+	u32	buttons;
+	int	windex;
+	int	rindex;
+	u32	buttons_up_mask;
+	u32	buttons_buf[ECI_BUTTON_BUF_SIZE];
+};
+
+struct eci_data {
+	struct device				*dev;
+	struct delayed_work			eci_ws;
+	wait_queue_head_t			 wait;
+	struct input_dev			*acc_input;
+	int					event;
+	bool					first_event;
+	bool					mem_ok;
+	u16					mem_size;
+	u8					memory[ECI_MAX_MEM_SIZE];
+	struct enchancement_features_fixed	*e_features_fix;
+	struct enchancement_features_variable	e_features_var;
+	u8					port_reg_count;
+	struct eci_buttons_data			buttons_data;
+	struct eci_hw_ops			*eci_hw_ops;
+	u8					mic_state;
+	u8					plugged;
+	bool					is_eci;
+	struct mutex				mutex;
+	bool					opened;
+	bool					suspended;
+};
+
+/* Exported functions */
+void eci_suspend(struct eci_data *eci);
+void eci_resume(struct eci_data *eci);
+struct eci_cb *eci_register(struct device *dev, struct eci_hw_ops *eci_ops);
+int eci_remove(struct eci_data *eci);
+
+/* eci paltform related data */
+struct eci_platform_data {
+	int	eci_rst_gpio;
+	int	eci_sw_ctrl_gpio;
+	int	eci_int_gpio;
+	void	(*register_hsmic_event_cb)(struct audio_hsmic_event *);
+};
+#endif
-- 
1.6.5

