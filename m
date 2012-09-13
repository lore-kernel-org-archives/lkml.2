Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab2IMWqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:46:32 -0400
Received: from 173-160-178-141-Washington.hfc.comcastbusiness.net ([173.160.178.141]:45781
	"EHLO relay" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753345Ab2IMWqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:46:03 -0400
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=201/3=5D=20Add=20a=20core=20driver=20for=20SI476x=20MFD?=
Date: Thu, 13 Sep 2012 15:40:11 -0700
Message-Id: <1347576013-28832-2-git-send-email-andrey.smirnov@convergeddevices.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net>
References: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a core driver for Silicon Laboratories Si476x series
of AM/FM tuner chips. The driver as a whole is implemented as an MFD device
and this patch adds a core portion of it that provides all the necessary
functionality to the two other drivers that represent radio and audio
codec subsystems of the chip.

Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
---
 drivers/mfd/Kconfig             |   14 +
 drivers/mfd/Makefile            |    3 +
 drivers/mfd/si476x-cmd.c        | 1509 +++++++++++++++++++++++++++++++++++++++
 drivers/mfd/si476x-i2c.c        | 1033 +++++++++++++++++++++++++++
 drivers/mfd/si476x-prop.c       |  477 +++++++++++++
 include/linux/mfd/si476x-core.h |  522 ++++++++++++++
 include/media/si476x.h          |  455 ++++++++++++
 7 files changed, 4013 insertions(+)
 create mode 100644 drivers/mfd/si476x-cmd.c
 create mode 100644 drivers/mfd/si476x-i2c.c
 create mode 100644 drivers/mfd/si476x-prop.c
 create mode 100644 include/linux/mfd/si476x-core.h
 create mode 100644 include/media/si476x.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b1a1462..3fab06d 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -895,6 +895,20 @@ config MFD_WL1273_CORE
 	  driver connects the radio-wl1273 V4L2 module and the wl1273
 	  audio codec.
 
+config MFD_SI476X_CORE
+	tristate "Support for Silicon Laboratories 4761/64/68 AM/FM radio."
+	depends on I2C
+	select MFD_CORE
+	default n
+	help
+	  This is the core driver for the SI476x series of AM/FM radio. This MFD
+	  driver connects the radio-si476x V4L2 module and the si476x
+	  audio codec.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called si476x-core.
+
+
 config MFD_OMAP_USB_HOST
 	bool "Support OMAP USBHS core driver"
 	depends on USB_EHCI_HCD_OMAP || USB_OHCI_HCD_OMAP3
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 79dd22d..942257b 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -132,3 +132,6 @@ obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
 obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
 obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
 obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
+
+si476x-core-objs := si476x-cmd.o si476x-prop.o si476x-i2c.o
+obj-$(CONFIG_MFD_SI476X_CORE)	+= si476x-core.o
diff --git a/drivers/mfd/si476x-cmd.c b/drivers/mfd/si476x-cmd.c
new file mode 100644
index 0000000..defe1f5
--- /dev/null
+++ b/drivers/mfd/si476x-cmd.c
@@ -0,0 +1,1509 @@
+/*
+ * include/media/si476x-cmd.c -- Subroutines implementing command
+ * protocol of si476x series of chips
+ *
+ * Copyright (C) 2012 Innovative Converged Devices(ICD)
+ *
+ * Author: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+#include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/atomic.h>
+#include <linux/i2c.h>
+#include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/videodev2.h>
+
+#include <media/si476x.h>
+#include <linux/mfd/si476x-core.h>
+
+#define msb(x)                  ((u8)((u16) x >> 8))
+#define lsb(x)                  ((u8)((u16) x &  0x00FF))
+
+
+
+#define CMD_POWER_UP				0x01
+#define CMD_POWER_UP_A10_NRESP			1
+#define CMD_POWER_UP_A10_NARGS			5
+
+#define CMD_POWER_UP_A20_NRESP			1
+#define CMD_POWER_UP_A20_NARGS			5
+
+#define POWER_UP_DELAY_MS			110
+
+#define CMD_POWER_DOWN				0x11
+#define CMD_POWER_DOWN_A10_NRESP		1
+
+#define CMD_POWER_DOWN_A20_NRESP		1
+#define CMD_POWER_DOWN_A20_NARGS		1
+
+#define CMD_FUNC_INFO				0x12
+#define CMD_FUNC_INFO_NRESP			7
+
+#define CMD_SET_PROPERTY			0x13
+#define CMD_SET_PROPERTY_NARGS			5
+#define CMD_SET_PROPERTY_NRESP			1
+
+#define CMD_GET_PROPERTY			0x14
+#define CMD_GET_PROPERTY_NARGS			3
+#define CMD_GET_PROPERTY_NRESP			4
+
+#define CMD_AGC_STATUS				0x17
+#define CMD_AGC_STATUS_NRESP_A10		2
+#define CMD_AGC_STATUS_NRESP_A20                6
+
+#define PIN_CFG_BYTE(x) (0x7F & (x))
+#define CMD_DIG_AUDIO_PIN_CFG			0x18
+#define CMD_DIG_AUDIO_PIN_CFG_NARGS		4
+#define CMD_DIG_AUDIO_PIN_CFG_NRESP		5
+
+#define CMD_ZIF_PIN_CFG				0x19
+#define CMD_ZIF_PIN_CFG_NARGS			4
+#define CMD_ZIF_PIN_CFG_NRESP			5
+
+#define CMD_IC_LINK_GPO_CTL_PIN_CFG		0x1A
+#define CMD_IC_LINK_GPO_CTL_PIN_CFG_NARGS	4
+#define CMD_IC_LINK_GPO_CTL_PIN_CFG_NRESP	5
+
+#define CMD_ANA_AUDIO_PIN_CFG			0x1B
+#define CMD_ANA_AUDIO_PIN_CFG_NARGS		1
+#define CMD_ANA_AUDIO_PIN_CFG_NRESP		2
+
+#define CMD_INTB_PIN_CFG			0x1C
+#define CMD_INTB_PIN_CFG_NARGS			2
+#define CMD_INTB_PIN_CFG_A10_NRESP		6
+#define CMD_INTB_PIN_CFG_A20_NRESP		3
+
+#define CMD_FM_TUNE_FREQ			0x30
+#define CMD_FM_TUNE_FREQ_A10_NARGS		5
+#define CMD_FM_TUNE_FREQ_A20_NARGS		3
+#define CMD_FM_TUNE_FREQ_NRESP			1
+
+#define CMD_FM_RSQ_STATUS			0x32
+
+#define CMD_FM_RSQ_STATUS_A10_NARGS		1
+#define CMD_FM_RSQ_STATUS_A10_NRESP		17
+#define CMD_FM_RSQ_STATUS_A30_NARGS		1
+#define CMD_FM_RSQ_STATUS_A30_NRESP		23
+
+
+#define CMD_FM_SEEK_START			0x31
+#define CMD_FM_SEEK_START_NARGS			1
+#define CMD_FM_SEEK_START_NRESP			1
+
+#define CMD_FM_RDS_STATUS			0x36
+#define CMD_FM_RDS_STATUS_NARGS			1
+#define CMD_FM_RDS_STATUS_NRESP			16
+
+#define CMD_FM_RDS_BLOCKCOUNT			0x37
+#define CMD_FM_RDS_BLOCKCOUNT_NARGS		1
+#define CMD_FM_RDS_BLOCKCOUNT_NRESP		8
+
+#define CMD_FM_PHASE_DIVERSITY			0x38
+#define CMD_FM_PHASE_DIVERSITY_NARGS		1
+#define CMD_FM_PHASE_DIVERSITY_NRESP		1
+
+#define CMD_FM_PHASE_DIV_STATUS			0x39
+#define CMD_FM_PHASE_DIV_STATUS_NRESP		2
+
+#define CMD_AM_TUNE_FREQ			0x40
+#define CMD_AM_TUNE_FREQ_NARGS			3
+#define CMD_AM_TUNE_FREQ_NRESP			1
+
+#define CMD_AM_RSQ_STATUS			0x42
+#define CMD_AM_RSQ_STATUS_NARGS			1
+#define CMD_AM_RSQ_STATUS_NRESP			13
+
+#define CMD_AM_SEEK_START			0x41
+#define CMD_AM_SEEK_START_NARGS			1
+#define CMD_AM_SEEK_START_NRESP			1
+
+
+#define CMD_AM_ACF_STATUS			0x45
+#define CMD_AM_ACF_STATUS_NRESP			6
+#define CMD_AM_ACF_STATUS_NARGS			1
+
+#define CMD_FM_ACF_STATUS			0x35
+#define CMD_FM_ACF_STATUS_NRESP			8
+#define CMD_FM_ACF_STATUS_NARGS			1
+
+#define CMD_MAX_ARGS_COUNT			(10)
+
+
+enum si476x_acf_status_report_bits {
+	SI476X_ACF_BLEND_INT	= (1 << 4),
+	SI476X_ACF_HIBLEND_INT	= (1 << 3),
+	SI476X_ACF_HICUT_INT	= (1 << 2),
+	SI476X_ACF_CHBW_INT	= (1 << 1),
+	SI476X_ACF_SOFTMUTE_INT	= (1 << 0),
+
+	SI476X_ACF_SMUTE	= (1 << 0),
+	SI476X_ACF_SMATTN	= 0b11111,
+	SI476X_ACF_PILOT	= (1 << 7),
+	SI476X_ACF_STBLEND	= ~SI476X_ACF_PILOT,
+};
+
+enum si476x_agc_status_report_bits {
+	SI476X_AGC_MXHI		= (1 << 5),
+	SI476X_AGC_MXLO		= (1 << 4),
+	SI476X_AGC_LNAHI	= (1 << 3),
+	SI476X_AGC_LNALO	= (1 << 2),
+};
+
+enum si476x_errors {
+	SI476X_ERR_BAD_COMMAND		= 0x10,
+	SI476X_ERR_BAD_ARG1		= 0x11,
+	SI476X_ERR_BAD_ARG2		= 0x12,
+	SI476X_ERR_BAD_ARG3		= 0x13,
+	SI476X_ERR_BAD_ARG4		= 0x14,
+	SI476X_ERR_BUSY			= 0x18,
+	SI476X_ERR_BAD_INTERNAL_MEMORY  = 0x20,
+	SI476X_ERR_BAD_PATCH		= 0x30,
+	SI476X_ERR_BAD_BOOT_MODE	= 0x31,
+	SI476X_ERR_BAD_PROPERTY		= 0x40,
+};
+
+
+static int si476x_core_parse_and_nag_about_error(struct si476x_core *core)
+{
+	int err;
+	char *cause;
+	u8 buffer[2];
+
+	if (core->revision != SI476X_REVISION_A10) {
+		err = si476x_i2c_xfer(core, SI476X_I2C_RECV,
+				      buffer, sizeof(buffer));
+		if (err == sizeof(buffer)) {
+			switch (buffer[1]) {
+			case SI476X_ERR_BAD_COMMAND:
+				cause = "Bad command";
+				err = -EINVAL;
+				break;
+			case SI476X_ERR_BAD_ARG1:
+				cause = "Bad argument #1";
+				err = -EINVAL;
+				break;
+			case SI476X_ERR_BAD_ARG2:
+				cause = "Bad argument #2";
+				err = -EINVAL;
+				break;
+			case SI476X_ERR_BAD_ARG3:
+				cause = "Bad argument #3";
+				err = -EINVAL;
+				break;
+			case SI476X_ERR_BAD_ARG4:
+				cause = "Bad argument #4";
+				err = -EINVAL;
+				break;
+			case SI476X_ERR_BUSY:
+				cause = "Chip is busy";
+				err = -EBUSY;
+				break;
+			case SI476X_ERR_BAD_INTERNAL_MEMORY:
+				cause = "Bad internal memory";
+				err = -EIO;
+				break;
+			case SI476X_ERR_BAD_PATCH:
+				cause = "Bad patch";
+				err = -EINVAL;
+				break;
+			case SI476X_ERR_BAD_BOOT_MODE:
+				cause = "Bad boot mode";
+				err = -EINVAL;
+				break;
+			case SI476X_ERR_BAD_PROPERTY:
+				cause = "Bad property";
+				err = -EINVAL;
+				break;
+			default:
+				cause = "Unknown";
+				err = -EIO;
+			}
+
+			dev_err(&core->client->dev,
+				"[Chip error status]: %s\n", cause);
+		} else {
+			dev_err(&core->client->dev,
+				"Failed to fetch error code\n");
+			err = (err >= 0) ? -EIO : err;
+		}
+	} else {
+		err = -EIO;
+	}
+
+	return err;
+}
+
+/**
+ * __core_send_command() - sends a command to si476x and waits its
+ * response
+ * @core:    si476x_device structure for the device we are
+ *            communicating with
+ * @command:  command id
+ * @args:     command arguments we are sending
+ * @argn:     actual size of @args
+ * @response: buffer to place the expected response from the device
+ * @respn:    actual size of @response
+ * @usecs:    amount of time to wait before reading the response (in
+ *            usecs)
+ *
+ * Function returns 0 on succsess and negative error code on
+ * failure
+ */
+static int __core_send_command(struct si476x_core *core,
+				    const u8 command,
+				    const u8 args[],
+				    const int argn,
+				    u8 resp[],
+				    const int respn,
+				    const int usecs)
+{
+	struct i2c_client *client = core->client;
+	int err;
+	u8  data[CMD_MAX_ARGS_COUNT + 1];
+
+	if (argn > CMD_MAX_ARGS_COUNT) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	if (!client->adapter) {
+		err = -ENODEV;
+		goto exit;
+	}
+
+	/* First send the command and its arguments */
+	data[0] = command;
+	memcpy(&data[1], args, argn);
+	DBG_BUFFER(&client->dev, "Command:\n", data, argn + 1);
+
+	err = si476x_i2c_xfer(core, SI476X_I2C_SEND, (char *) data, argn + 1);
+	if (err != argn + 1) {
+		dev_err(&core->client->dev,
+			"Error while sending command 0x%02x\n",
+			command);
+		err = (err >= 0) ? -EIO : err;
+		goto exit;
+	}
+	/* Set CTS to zero only after the command is send to avoid
+	 * possible racing conditions when working in polling mode */
+	atomic_set(&core->cts, 0);
+
+	if (!wait_event_timeout(core->command,
+				atomic_read(&core->cts),
+				usecs_to_jiffies(usecs) + 1))
+		dev_warn(&core->client->dev,
+			 "(%s) [CMD 0x%02x] Device took too much time to answer.\n",
+			 __func__, command);
+
+	/*
+	  When working in polling mode, for some reason the tuner will
+	  report CTS bit as being set in the first status byte read,
+	  but all the consequtive ones will return zros until the
+	  tuner is actually completed the POWER_UP command. To
+	  workaround that we wait for second CTS to be reported
+	 */
+	if (unlikely(!core->client->irq && command == CMD_POWER_UP)) {
+		if (!wait_event_timeout(core->command,
+					atomic_read(&core->cts),
+					usecs_to_jiffies(usecs) + 1))
+			dev_warn(&core->client->dev,
+				 "(%s) Power up took too much time.\n",
+				 __func__);
+	}
+
+	/* Then get the response */
+	err = si476x_i2c_xfer(core, SI476X_I2C_RECV, resp, respn);
+	if (err != respn) {
+		dev_err(&core->client->dev,
+			"Error while reading response for command 0x%02x\n",
+			command);
+		err = (err >= 0) ? -EIO : err;
+		goto exit;
+	}
+	DBG_BUFFER(&client->dev, "Response:\n", resp, respn);
+
+	err = 0;
+
+	if (resp[0] & SI476X_ERR) {
+		dev_err(&core->client->dev, "Chip set error flag\n");
+		err = si476x_core_parse_and_nag_about_error(core);
+		goto exit;
+	}
+
+	if (!(resp[0] & SI476X_CTS))
+		err = -EBUSY;
+exit:
+	return err;
+}
+
+#define CORE_SEND_COMMAND(core, cmd, args, resp, timeout)		\
+	__core_send_command(core, cmd, args,				\
+			    ARRAY_SIZE(args),				\
+			    resp, ARRAY_SIZE(resp),			\
+			    timeout)
+
+
+static int __cmd_tune_seek_freq(struct si476x_core *core,
+				uint8_t cmd,
+				const uint8_t args[], size_t argn,
+				uint8_t *resp, size_t respn,
+				int (*clear_stcint) (struct si476x_core *core))
+{
+	int err;
+
+	atomic_set(&core->stc, 0);
+	err = __core_send_command(core, cmd, args, argn,
+				  resp, respn,
+				  atomic_read(&core->timeouts.command));
+	if (!err) {
+		if (!wait_event_timeout(core->tuning,
+		atomic_read(&core->stc),
+		usecs_to_jiffies(atomic_read(&core->timeouts.tune)) + 1)) {
+			dev_warn(&core->client->dev,
+				 "%s: Device took too much time "
+				 "to answer (%d usec).\n",
+				 __func__,
+				 atomic_read(&core->timeouts.tune));
+			err = -ETIMEDOUT;
+		} else {
+			err = clear_stcint(core);
+		}
+	}
+
+	return err;
+}
+
+
+/**
+ * si476x_cmd_func_info() - send 'FUNC_INFO' command to the device
+ * @core: device to send the command to
+ * @info:  struct si476x_func_info to fill all the information
+ *         returned by the command
+ *
+ * The command requests the firmware and patch version for currently
+ * loaded firmware (dependent on the function of the device FM/AM/WB)
+ *
+ * Function returns 0 on succsess and negative error code on
+ * failure
+ */
+int si476x_core_cmd_func_info(struct si476x_core *core,
+			      struct si476x_func_info *info)
+{
+	int err;
+	u8  resp[CMD_FUNC_INFO_NRESP];
+
+	err = __core_send_command(core, CMD_FUNC_INFO,
+				  NULL, 0,
+				  resp, ARRAY_SIZE(resp),
+				  atomic_read(&core->timeouts.command));
+
+	info->firmware.major    = resp[1];
+	info->firmware.minor[0] = resp[2];
+	info->firmware.minor[1] = resp[3];
+
+	info->patch_id = ((u16) resp[4] << 8) | resp[5];
+	info->func     = resp[6];
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_func_info);
+
+/**
+ * si476x_cmd_set_property() - send 'SET_PROPERTY' command to the device
+ * @core:    device to send the command to
+ * @property: property address
+ * @value:    property value
+ *
+ * Function returns 0 on succsess and negative error code on
+ * failure
+ */
+int si476x_core_cmd_set_property(struct si476x_core *core,
+				 u16 property, u16 value)
+{
+	u8       resp[CMD_SET_PROPERTY_NRESP];
+	const u8 args[CMD_SET_PROPERTY_NARGS] = {
+		0x00,
+		msb(property),
+		lsb(property),
+		msb(value),
+		lsb(value),
+	};
+
+	return CORE_SEND_COMMAND(core, CMD_SET_PROPERTY,
+				 args, resp,
+				 atomic_read(&core->timeouts.command));
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_set_property);
+
+/**
+ * si476x_cmd_get_property() - send 'GET_PROPERTY' command to the device
+ * @core:    device to send the command to
+ * @property: property address
+ *
+ * Function return the value of property as u16 on success or a
+ * negative error on failure
+ */
+int si476x_core_cmd_get_property(struct si476x_core *core, u16 property)
+{
+	int err;
+	u8       resp[CMD_GET_PROPERTY_NRESP];
+	const u8 args[CMD_GET_PROPERTY_NARGS] = {
+		0x00,
+		msb(property),
+		lsb(property),
+	};
+
+	err = CORE_SEND_COMMAND(core, CMD_GET_PROPERTY,
+				args, resp,
+				atomic_read(&core->timeouts.command));
+	if (err < 0)
+		return err;
+	else
+		return be16_to_cpup((__be16 *)(resp + 2));
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_get_property);
+
+/**
+ * si476x_cmd_dig_audio_pin_cfg() - send 'DIG_AUDIO_PIN_CFG' command to
+ * the device
+ * @core: device to send the command to
+ * @dclk:  DCLK pin function configuration:
+ *	   #SI476X_DCLK_NOOP     - do not modify the behaviour
+ *         #SI476X_DCLK_TRISTATE - put the pin in tristate condition,
+ *                                 enable 1MOhm pulldown
+ *         #SI476X_DCLK_DAUDIO   - set the pin to be a part of digital
+ *                                 audio interface
+ * @dfs:   DFS pin function configuration:
+ *         #SI476X_DFS_NOOP      - do not modify the behaviour
+ *         #SI476X_DFS_TRISTATE  - put the pin in tristate condition,
+ *                             enable 1MOhm pulldown
+ *      SI476X_DFS_DAUDIO    - set the pin to be a part of digital
+ *                             audio interface
+ * @dout - DOUT pin function configuration:
+ *      SI476X_DOUT_NOOP       - do not modify the behaviour
+ *      SI476X_DOUT_TRISTATE   - put the pin in tristate condition,
+ *                               enable 1MOhm pulldown
+ *      SI476X_DOUT_I2S_OUTPUT - set this pin to be digital out on I2S
+ *                               port 1
+ *      SI476X_DOUT_I2S_INPUT  - set this pin to be digital in on I2S
+ *                               port 1
+ * @xout - XOUT pin function configuration:
+ *	SI476X_XOUT_NOOP        - do not modify the behaviour
+ *      SI476X_XOUT_TRISTATE    - put the pin in tristate condition,
+ *                                enable 1MOhm pulldown
+ *      SI476X_XOUT_I2S_INPUT   - set this pin to be digital in on I2S
+ *                                port 1
+ *      SI476X_XOUT_MODE_SELECT - set this pin to be the input that
+ *                                selects the mode of the I2S audio
+ *                                combiner (analog or HD)
+ *                                [SI4761/63/65/67 Only]
+ *
+ * Function returns 0 on success and negative error code on failure
+ */
+int si476x_core_cmd_dig_audio_pin_cfg(struct  si476x_core *core,
+				      enum si476x_dclk_config dclk,
+				      enum si476x_dfs_config  dfs,
+				      enum si476x_dout_config dout,
+				      enum si476x_xout_config xout)
+{
+	u8       resp[CMD_DIG_AUDIO_PIN_CFG_NRESP];
+	const u8 args[CMD_DIG_AUDIO_PIN_CFG_NARGS] = {
+		PIN_CFG_BYTE(dclk),
+		PIN_CFG_BYTE(dfs),
+		PIN_CFG_BYTE(dout),
+		PIN_CFG_BYTE(xout),
+	};
+
+	return CORE_SEND_COMMAND(core, CMD_DIG_AUDIO_PIN_CFG,
+				 args, resp,
+				 atomic_read(&core->timeouts.command));
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_dig_audio_pin_cfg);
+
+/**
+ * si476x_cmd_zif_pin_cfg - send 'ZIF_PIN_CFG_COMMAND'
+ * @core - device to send the command to
+ * @iqclk - IQCL pin function configuration:
+ *       SI476X_IQCLK_NOOP     - do not modify the behaviour
+ *       SI476X_IQCLK_TRISTATE - put the pin in tristate condition,
+ *                               enable 1MOhm pulldown
+ *       SI476X_IQCLK_IQ       - set pin to be a part of I/Q interace
+ *                               in master mode
+ * @iqfs - IQFS pin function configuration:
+ *       SI476X_IQFS_NOOP     - do not modify the behaviour
+ *       SI476X_IQFS_TRISTATE - put the pin in tristate condition,
+ *                              enable 1MOhm pulldown
+ *       SI476X_IQFS_IQ       - set pin to be a part of I/Q interace
+ *                              in master mode
+ * @iout - IOUT pin function configuration:
+ *       SI476X_IOUT_NOOP     - do not modify the behaviour
+ *       SI476X_IOUT_TRISTATE - put the pin in tristate condition,
+ *                              enable 1MOhm pulldown
+ *       SI476X_IOUT_OUTPUT   - set pin to be I out
+ * @qout - QOUT pin function configuration:
+ *       SI476X_QOUT_NOOP     - do not modify the behaviour
+ *       SI476X_QOUT_TRISTATE - put the pin in tristate condition,
+ *                              enable 1MOhm pulldown
+ *       SI476X_QOUT_OUTPUT   - set pin to be Q out
+ *
+ * Function returns 0 on success and negative error code on failure
+ */
+int si476x_core_cmd_zif_pin_cfg(struct si476x_core *core,
+				enum si476x_iqclk_config iqclk,
+				enum si476x_iqfs_config iqfs,
+				enum si476x_iout_config iout,
+				enum si476x_qout_config qout)
+{
+	u8       resp[CMD_ZIF_PIN_CFG_NRESP];
+	const u8 args[CMD_ZIF_PIN_CFG_NARGS] = {
+		PIN_CFG_BYTE(iqclk),
+		PIN_CFG_BYTE(iqfs),
+		PIN_CFG_BYTE(iout),
+		PIN_CFG_BYTE(qout),
+	};
+
+	return CORE_SEND_COMMAND(core, CMD_ZIF_PIN_CFG,
+				 args, resp,
+				 atomic_read(&core->timeouts.command));
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_zif_pin_cfg);
+
+/**
+ * si476x_cmd_ic_link_gpo_ctl_pin_cfg - send
+ * 'IC_LINK_GPIO_CTL_PIN_CFG' comand to the device
+ * @core - device to send the command to
+ * @icin - ICIN pin function configuration:
+ *      SI476X_ICIN_NOOP      - do not modify the behaviour
+ *      SI476X_ICIN_TRISTATE  - put the pin in tristate condition,
+ *                              enable 1MOhm pulldown
+ *      SI476X_ICIN_GPO1_HIGH - set pin to be an output, drive it high
+ *      SI476X_ICIN_GPO1_LOW  - set pin to be an output, drive it low
+ *      SI476X_ICIN_IC_LINK   - set the pin to be a part of Inter-Chip link
+ * @icip - ICIP pin function configuration:
+ *      SI476X_ICIP_NOOP      - do not modify the behaviour
+ *      SI476X_ICIP_TRISTATE  - put the pin in tristate condition,
+ *                              enable 1MOhm pulldown
+ *      SI476X_ICIP_GPO1_HIGH - set pin to be an output, drive it high
+ *      SI476X_ICIP_GPO1_LOW  - set pin to be an output, drive it low
+ *      SI476X_ICIP_IC_LINK   - set the pin to be a part of Inter-Chip link
+ * @icon - ICON pin function configuration:
+ *      SI476X_ICON_NOOP     - do not modify the behaviour
+ *      SI476X_ICON_TRISTATE - put the pin in tristate condition,
+ *                             enable 1MOhm pulldown
+ *      SI476X_ICON_I2S      - set the pin to be a part of audio
+ *                             interface in slave mode (DCLK)
+ *      SI476X_ICON_IC_LINK  - set the pin to be a part of Inter-Chip link
+ * @icop - ICOP pin function configuration:
+ *      SI476X_ICOP_NOOP     - do not modify the behaviour
+ *      SI476X_ICOP_TRISTATE - put the pin in tristate condition,
+ *                             enable 1MOhm pulldown
+ *      SI476X_ICOP_I2S      - set the pin to be a part of audio
+ *                             interface in slave mode (DOUT)
+ *                             [Si4761/63/65/67 Only]
+ *      SI476X_ICOP_IC_LINK  - set the pin to be a part of Inter-Chip link
+ *
+ * Function returns 0 on success and negative error code on failure
+ */
+int si476x_core_cmd_ic_link_gpo_ctl_pin_cfg(struct si476x_core *core,
+					    enum si476x_icin_config icin,
+					    enum si476x_icip_config icip,
+					    enum si476x_icon_config icon,
+					    enum si476x_icop_config icop)
+{
+	u8       resp[CMD_IC_LINK_GPO_CTL_PIN_CFG_NRESP];
+	const u8 args[CMD_IC_LINK_GPO_CTL_PIN_CFG_NARGS] = {
+		PIN_CFG_BYTE(icin),
+		PIN_CFG_BYTE(icip),
+		PIN_CFG_BYTE(icon),
+		PIN_CFG_BYTE(icop),
+	};
+
+	return CORE_SEND_COMMAND(core, CMD_IC_LINK_GPO_CTL_PIN_CFG,
+				 args, resp,
+				 atomic_read(&core->timeouts.command));
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_ic_link_gpo_ctl_pin_cfg);
+
+/**
+ * si476x_cmd_ana_audio_pin_cfg - send 'ANA_AUDIO_PIN_CFG' to the
+ * device
+ * @core - device to send the command to
+ * @lrout - LROUT pin function configuration:
+ *       SI476X_LROUT_NOOP     - do not modify the behaviour
+ *       SI476X_LROUT_TRISTATE - put the pin in tristate condition,
+ *                               enable 1MOhm pulldown
+ *       SI476X_LROUT_AUDIO    - set pin to be audio output
+ *       SI476X_LROUT_MPX      - set pin to be MPX output
+ *
+ * Function returns 0 on success and negative error code on failure
+ */
+int si476x_core_cmd_ana_audio_pin_cfg(struct si476x_core *core,
+				      enum si476x_lrout_config lrout)
+{
+	u8       resp[CMD_ANA_AUDIO_PIN_CFG_NRESP];
+	const u8 args[CMD_ANA_AUDIO_PIN_CFG_NARGS] = {
+		PIN_CFG_BYTE(lrout),
+	};
+
+	return CORE_SEND_COMMAND(core, CMD_ANA_AUDIO_PIN_CFG,
+				 args, resp,
+				 atomic_read(&core->timeouts.command));
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_ana_audio_pin_cfg);
+
+
+/**
+ * si476x_cmd_intb_pin_cfg - send 'INTB_PIN_CFG' command to the device
+ * @core - device to send the command to
+ * @intb - INTB pin function configuration:
+ *      SI476X_INTB_NOOP     - do not modify the behaviour
+ *      SI476X_INTB_TRISTATE - put the pin in tristate condition,
+ *                             enable 1MOhm pulldown
+ *      SI476X_INTB_DAUDIO   - set pin to be a part of digital
+ *                             audio interface in slave mode
+ *      SI476X_INTB_IRQ      - set pin to be an interrupt request line
+ * @a1 - A1 pin function configuration:
+ *      SI476X_A1_NOOP     - do not modify the behaviour
+ *      SI476X_A1_TRISTATE - put the pin in tristate condition,
+ *                           enable 1MOhm pulldown
+ *      SI476X_A1_IRQ      - set pin to be an interrupt request line
+ *
+ * Function returns 0 on success and negative error code on failure
+ */
+static int si476x_core_cmd_intb_pin_cfg_a10(struct si476x_core *core,
+					    enum si476x_intb_config intb,
+					    enum si476x_a1_config a1)
+{
+	u8       resp[CMD_INTB_PIN_CFG_A10_NRESP];
+	const u8 args[CMD_INTB_PIN_CFG_NARGS] = {
+		PIN_CFG_BYTE(intb),
+		PIN_CFG_BYTE(a1),
+	};
+
+	return CORE_SEND_COMMAND(core, CMD_INTB_PIN_CFG,
+				 args, resp,
+				 atomic_read(&core->timeouts.command));
+}
+
+static int si476x_core_cmd_intb_pin_cfg_a20(struct si476x_core *core,
+					    enum si476x_intb_config intb,
+					    enum si476x_a1_config a1)
+{
+	u8       resp[CMD_INTB_PIN_CFG_A20_NRESP];
+	const u8 args[CMD_INTB_PIN_CFG_NARGS] = {
+		PIN_CFG_BYTE(intb),
+		PIN_CFG_BYTE(a1),
+	};
+
+	return CORE_SEND_COMMAND(core, CMD_INTB_PIN_CFG,
+				 args, resp,
+				 atomic_read(&core->timeouts.command));
+}
+
+
+
+/**
+ * si476x_cmd_am_rsq_status - send 'FM_TUNE_FREQ' command to the
+ * device
+ * @core  - device to send the command to
+ * @rsqack - if set command clears RSQINT, SNRINT, SNRLINT, RSSIHINT,
+ *           RSSSILINT, BLENDINT, MULTHINT and MULTLINT
+ * @attune - when set the values in the status report are the values
+ *           that were calculated at tune
+ * @cancel - abort ongoing seek/tune opertation
+ * @stcack - clear the STCINT bin in status register
+ * @report - all signal quality information retured by the command
+ *           (if NULL then the output of the command is ignored)
+ *
+ * Function returns 0 on success and negative error code on failure
+ */
+int si476x_core_cmd_am_rsq_status(struct si476x_core *core,
+				  struct si476x_rsq_status_args *rsqargs,
+				  struct si476x_rsq_status_report *report)
+{
+	int err;
+	u8       resp[CMD_AM_RSQ_STATUS_NRESP];
+	const u8 args[CMD_AM_RSQ_STATUS_NARGS] = {
+		rsqargs->rsqack << 3 | rsqargs->attune << 2 |
+		rsqargs->cancel << 1 | rsqargs->stcack,
+	};
+
+	err = CORE_SEND_COMMAND(core, CMD_AM_RSQ_STATUS,
+				args, resp,
+				atomic_read(&core->timeouts.command));
+
+	if (report) {
+		report->snrhint		= 0b00001000 & resp[1];
+		report->snrlint		= 0b00000100 & resp[1];
+		report->rssihint	= 0b00000010 & resp[1];
+		report->rssilint	= 0b00000001 & resp[1];
+
+		report->bltf		= 0b10000000 & resp[2];
+		report->snr_ready	= 0b00100000 & resp[2];
+		report->rssiready	= 0b00001000 & resp[2];
+		report->afcrl		= 0b00000010 & resp[2];
+		report->valid		= 0b00000001 & resp[2];
+
+		report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
+		report->freqoff		= resp[5];
+		report->rssi		= resp[6];
+		report->snr		= resp[7];
+		report->lassi		= resp[9];
+		report->hassi		= resp[10];
+		report->mult		= resp[11];
+		report->dev		= resp[12];
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_am_rsq_status);
+
+int si476x_core_cmd_fm_acf_status(struct si476x_core *core,
+			     struct si476x_acf_status_report *report)
+{
+	int err;
+	u8       resp[CMD_FM_ACF_STATUS_NRESP];
+	const u8 args[CMD_FM_ACF_STATUS_NARGS] = {
+		0x0,
+	};
+
+	if (!report)
+		return -EINVAL;
+
+	err = CORE_SEND_COMMAND(core, CMD_FM_ACF_STATUS,
+				args, resp,
+				atomic_read(&core->timeouts.command));
+
+	if (!err) {
+		report->blend_int	= resp[1] & SI476X_ACF_BLEND_INT;
+		report->hblend_int	= resp[1] & SI476X_ACF_HIBLEND_INT;
+		report->hicut_int	= resp[1] & SI476X_ACF_HICUT_INT;
+		report->chbw_int	= resp[1] & SI476X_ACF_CHBW_INT;
+		report->softmute_int	= resp[1] & SI476X_ACF_SOFTMUTE_INT;
+		report->smute		= resp[2] & SI476X_ACF_SMUTE;
+		report->smattn		= resp[3] & SI476X_ACF_SMATTN;
+		report->chbw		= resp[4];
+		report->hicut		= resp[5];
+		report->hiblend		= resp[6];
+		report->pilot		= resp[7] & SI476X_ACF_PILOT;
+		report->stblend		= resp[7] & SI476X_ACF_STBLEND;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_acf_status);
+
+int si476x_core_cmd_am_acf_status(struct si476x_core *core,
+				  struct si476x_acf_status_report *report)
+{
+	int err;
+	u8       resp[CMD_AM_ACF_STATUS_NRESP];
+	const u8 args[CMD_AM_ACF_STATUS_NARGS] = {
+		0x0,
+	};
+
+	if (!report)
+		return -EINVAL;
+
+	err = CORE_SEND_COMMAND(core, CMD_AM_ACF_STATUS,
+				args, resp,
+				atomic_read(&core->timeouts.command));
+
+	if (!err) {
+		report->blend_int	= resp[1] & SI476X_ACF_BLEND_INT;
+		report->hblend_int	= resp[1] & SI476X_ACF_HIBLEND_INT;
+		report->hicut_int	= resp[1] & SI476X_ACF_HICUT_INT;
+		report->chbw_int	= resp[1] & SI476X_ACF_CHBW_INT;
+		report->softmute_int	= resp[1] & SI476X_ACF_SOFTMUTE_INT;
+		report->smute		= resp[2] & SI476X_ACF_SMUTE;
+		report->smattn		= resp[3] & SI476X_ACF_SMATTN;
+		report->chbw		= resp[4];
+		report->hicut		= resp[5];
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_am_acf_status);
+
+static inline int __fm_clear_stcint(struct si476x_core *core)
+{
+	struct si476x_rsq_status_args args = {
+		.primary	= false,
+		.rsqack		= false,
+		.attune		= false,
+		.cancel		= false,
+		.stcack		= true,
+	};
+	return si476x_core_cmd_fm_rsq_status(core, &args, NULL);
+}
+
+static inline int __am_clear_stcint(struct si476x_core *core)
+{
+	struct si476x_rsq_status_args args = {
+		.primary	= false,
+		.rsqack		= false,
+		.attune		= false,
+		.cancel		= false,
+		.stcack		= true,
+	};
+	return si476x_core_cmd_am_rsq_status(core,  &args, NULL);
+}
+
+
+
+/**
+ * si476x_cmd_fm_seek_start - send 'FM_SEEK_START' command to the
+ * device
+ * @core  - device to send the command to
+ * @seekup - if set the direction of the search is 'up'
+ * @wrap   - if set seek wraps when hitting band limit
+ *
+ * This function begins search for a valid station. The station is
+ * considered valid when 'FM_VALID_SNR_THRESHOLD' and
+ * 'FM_VALID_RSSI_THRESHOLD' and 'FM_VALID_MAX_TUNE_ERROR' criteria
+ * are met.
+} *
+ * Function returns 0 on success and negative error code on failure
+ */
+int si476x_core_cmd_fm_seek_start(struct si476x_core *core,
+				  bool seekup, bool wrap)
+{
+	u8       resp[CMD_FM_SEEK_START_NRESP];
+	const u8 args[CMD_FM_SEEK_START_NARGS] = {
+		seekup << 3 | wrap << 2,
+	};
+
+	return __cmd_tune_seek_freq(core, CMD_FM_SEEK_START,
+				    args, sizeof(args), resp, sizeof(resp),
+				    __fm_clear_stcint);
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_seek_start);
+
+/**
+ * si476x_cmd_fm_rds_status - send 'FM_RDS_STATUS' command to the
+ * device
+ * @core - device to send the command to
+ * @status_only - if set the data is not removed from RDSFIFO,
+ *                RDSFIFOUSED is not decremented and data in all the
+ *                rest RDS data contains the last valid info received
+ * @mtfifo if set the command clears RDS receive FIFO
+ * @intack if set the command clards the RDSINT bit.
+ *
+ * Function returns 0 on success and negative error code on failure
+ */
+int si476x_core_cmd_fm_rds_status(struct si476x_core *core,
+				  bool status_only,
+				  bool mtfifo,
+				  bool intack,
+				  struct si476x_rds_status_report *report)
+{
+	int err;
+	u8       resp[CMD_FM_RDS_STATUS_NRESP];
+	const u8 args[CMD_FM_RDS_STATUS_NARGS] = {
+		status_only << 2 | mtfifo << 1 | intack,
+	};
+
+	err = CORE_SEND_COMMAND(core, CMD_FM_RDS_STATUS,
+				args, resp,
+				atomic_read(&core->timeouts.command));
+
+	if (!err && report) {
+		report->rdstpptyint	= 0b00010000 & resp[1];
+		report->rdspiint	= 0b00001000 & resp[1];
+		report->rdssyncint	= 0b00000010 & resp[1];
+		report->rdsfifoint	= 0b00000001 & resp[1];
+
+		report->tpptyvalid	= 0b00010000 & resp[2];
+		report->pivalid		= 0b00001000 & resp[2];
+		report->rdssync		= 0b00000010 & resp[2];
+		report->rdsfifolost	= 0b00000001 & resp[2];
+
+		report->tp		= 0b00100000 & resp[3];
+		report->pty		= 0b00011111 & resp[3];
+
+		report->pi		= be16_to_cpup((__be16 *)(resp + 4));
+		report->rdsfifoused	= resp[6];
+
+		report->ble[V4L2_RDS_BLOCK_A]	= 0b11000000 & resp[7];
+		report->ble[V4L2_RDS_BLOCK_B]	= 0b00110000 & resp[7];
+		report->ble[V4L2_RDS_BLOCK_C]	= 0b00001100 & resp[7];
+		report->ble[V4L2_RDS_BLOCK_D]	= 0b00000011 & resp[7];
+
+		report->rds[V4L2_RDS_BLOCK_A].block = V4L2_RDS_BLOCK_A;
+		report->rds[V4L2_RDS_BLOCK_A].msb = resp[8];
+		report->rds[V4L2_RDS_BLOCK_A].lsb = resp[9];
+
+		report->rds[V4L2_RDS_BLOCK_B].block = V4L2_RDS_BLOCK_B;
+		report->rds[V4L2_RDS_BLOCK_B].msb = resp[10];
+		report->rds[V4L2_RDS_BLOCK_B].lsb = resp[11];
+
+		report->rds[V4L2_RDS_BLOCK_C].block = V4L2_RDS_BLOCK_C;
+		report->rds[V4L2_RDS_BLOCK_C].msb = resp[12];
+		report->rds[V4L2_RDS_BLOCK_C].lsb = resp[13];
+
+		report->rds[V4L2_RDS_BLOCK_D].block = V4L2_RDS_BLOCK_D;
+		report->rds[V4L2_RDS_BLOCK_D].msb = resp[14];
+		report->rds[V4L2_RDS_BLOCK_D].lsb = resp[15];
+	}
+
+	return err;
+}
+
+int si476x_core_cmd_fm_rds_blockcount(struct si476x_core *core,
+				bool clear,
+				struct si476x_rds_blockcount_report *report)
+{
+	int err;
+	u8       resp[CMD_FM_RDS_BLOCKCOUNT_NRESP];
+	const u8 args[CMD_FM_RDS_BLOCKCOUNT_NARGS] = {
+		clear,
+	};
+
+	if (!report)
+		return -EINVAL;
+
+	err = CORE_SEND_COMMAND(core, CMD_FM_RDS_BLOCKCOUNT,
+				args, resp,
+				atomic_read(&core->timeouts.command));
+
+	if (!err) {
+		report->expected	= be16_to_cpup((__be16 *)(resp + 2));
+		report->received	= be16_to_cpup((__be16 *)(resp + 4));
+		report->uncorrectable	= be16_to_cpup((__be16 *)(resp + 6));
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_rds_blockcount);
+
+int si476x_core_cmd_fm_phase_diversity(struct si476x_core *core,
+				       enum si476x_phase_diversity_mode mode)
+{
+	u8       resp[CMD_FM_PHASE_DIVERSITY_NRESP];
+	const u8 args[CMD_FM_PHASE_DIVERSITY_NARGS] = {
+		mode & 0b111,
+	};
+
+	return CORE_SEND_COMMAND(core, CMD_FM_PHASE_DIVERSITY,
+				 args, resp,
+				 atomic_read(&core->timeouts.command));
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_phase_diversity);
+/**
+ * si476x_core_cmd_fm_phase_div_status() - get the phase diversity
+ * status
+ *
+ * @core: si476x device
+ *
+ * NOTE caller must hold core lock
+ *
+ * Function returns the value of the status bit in case of success and
+ * negative error code in case of failre.
+ */
+int si476x_core_cmd_fm_phase_div_status(struct si476x_core *core)
+{
+	int err;
+	u8 resp[CMD_FM_PHASE_DIV_STATUS_NRESP];
+
+	err = __core_send_command(core, CMD_FM_PHASE_DIV_STATUS,
+				  NULL, 0,
+				  resp, ARRAY_SIZE(resp),
+				  atomic_read(&core->timeouts.command));
+
+	return (err < 0) ? err : resp[1];
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_phase_div_status);
+
+
+/**
+ * si476x_cmd_am_seek_start - send 'FM_SEEK_START' command to the
+ * device
+ * @core  - device to send the command to
+ * @seekup - if set the direction of the search is 'up'
+ * @wrap   - if set seek wraps when hitting band limit
+ *
+ * This function begins search for a valid station. The station is
+ * considered valid when 'FM_VALID_SNR_THRESHOLD' and
+ * 'FM_VALID_RSSI_THRESHOLD' and 'FM_VALID_MAX_TUNE_ERROR' criteria
+ * are met.
+ *
+ * Function returns 0 on success and negative error code on failure
+ */
+int si476x_core_cmd_am_seek_start(struct si476x_core *core,
+				  bool seekup, bool wrap)
+{
+	u8       resp[CMD_AM_SEEK_START_NRESP];
+	const u8 args[CMD_AM_SEEK_START_NARGS] = {
+		seekup << 3 | wrap << 2,
+	};
+
+	return __cmd_tune_seek_freq(core,  CMD_AM_SEEK_START,
+				    args, sizeof(args), resp, sizeof(resp),
+				    __am_clear_stcint);
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_am_seek_start);
+
+
+
+static int si476x_core_cmd_power_up_a10(struct si476x_core *core,
+					struct si476x_power_up_args *puargs)
+{
+	u8       resp[CMD_POWER_UP_A10_NRESP];
+	const bool intsel = (core->pinmux.a1 == SI476X_A1_IRQ);
+	const bool ctsen  = (core->client->irq != 0);
+	const u8 args[CMD_POWER_UP_A10_NARGS] = {
+		0xF7,		/* Reserved, always 0xF7 */
+		0x3F & puargs->xcload,	/* First two bits are reserved to be
+				 * zeros */
+		ctsen << 7 | intsel << 6 | 0x07, /* Last five bits
+						   * are reserved to
+						   * be written as 0x7 */
+		puargs->func << 4 | puargs->freq,
+		0x11,		/* Reserved, always 0x11 */
+	};
+
+	return CORE_SEND_COMMAND(core, CMD_POWER_UP,
+				 args, resp,
+				 atomic_read(&core->timeouts.power_up));
+}
+
+static int si476x_core_cmd_power_up_a20(struct si476x_core *core,
+				 struct si476x_power_up_args *puargs)
+{
+	u8       resp[CMD_POWER_UP_A20_NRESP];
+	const bool intsel = (core->pinmux.a1 == SI476X_A1_IRQ);
+	const bool ctsen  = (core->client->irq != 0);
+	const u8 args[CMD_POWER_UP_A20_NARGS] = {
+		puargs->ibias6x << 7 | puargs->xstart,
+		0x3F & puargs->xcload,	/* First two bits are reserved to be
+					 * zeros */
+		ctsen << 7 | intsel << 6 | puargs->fastboot << 5 |
+		puargs->xbiashc << 3 | puargs->xbias,
+		puargs->func << 4 | puargs->freq,
+		0x10 | puargs->xmode,
+	};
+
+	return CORE_SEND_COMMAND(core, CMD_POWER_UP,
+				 args, resp,
+				 atomic_read(&core->timeouts.power_up));
+}
+
+static int si476x_core_cmd_power_down_a10(struct si476x_core *core,
+					  struct si476x_power_down_args *pdargs)
+{
+	u8 resp[CMD_POWER_DOWN_A10_NRESP];
+
+	return __core_send_command(core, CMD_POWER_DOWN,
+				   NULL, 0,
+				   resp, ARRAY_SIZE(resp),
+				   atomic_read(&core->timeouts.command));
+}
+
+static int si476x_core_cmd_power_down_a20(struct si476x_core *core,
+					  struct si476x_power_down_args *pdargs)
+{
+	u8 resp[CMD_POWER_DOWN_A20_NRESP];
+	const u8 args[CMD_POWER_DOWN_A20_NARGS] = {
+		pdargs->xosc,
+	};
+	return CORE_SEND_COMMAND(core, CMD_POWER_DOWN,
+				 args, resp,
+				 atomic_read(&core->timeouts.command));
+}
+
+static int si476x_core_cmd_am_tune_freq_a10(struct si476x_core *core,
+					struct si476x_tune_freq_args *tuneargs)
+{
+
+	const int am_freq = tuneargs->freq;
+	u8       resp[CMD_AM_TUNE_FREQ_NRESP];
+	const u8 args[CMD_AM_TUNE_FREQ_NARGS] = {
+		(tuneargs->hd << 6),
+		msb(am_freq),
+		lsb(am_freq),
+	};
+
+	return __cmd_tune_seek_freq(core, CMD_AM_TUNE_FREQ, args, sizeof(args),
+			       resp, sizeof(resp), __am_clear_stcint);
+}
+
+static int si476x_core_cmd_am_tune_freq_a20(struct si476x_core *core,
+					struct si476x_tune_freq_args *tuneargs)
+{
+	const int am_freq = tuneargs->freq;
+	u8       resp[CMD_AM_TUNE_FREQ_NRESP];
+	const u8 args[CMD_AM_TUNE_FREQ_NARGS] = {
+		(tuneargs->zifsr << 6) | (tuneargs->injside & 0b11),
+		msb(am_freq),
+		lsb(am_freq),
+	};
+
+	return __cmd_tune_seek_freq(core, CMD_AM_TUNE_FREQ, args, sizeof(args),
+			       resp, sizeof(resp), __am_clear_stcint);
+}
+
+static int si476x_core_cmd_fm_rsq_status_a10(struct si476x_core *core,
+					struct si476x_rsq_status_args *rsqargs,
+					struct si476x_rsq_status_report *report)
+{
+	int err;
+	u8       resp[CMD_FM_RSQ_STATUS_A10_NRESP];
+	const u8 args[CMD_FM_RSQ_STATUS_A10_NARGS] = {
+		rsqargs->rsqack << 3 | rsqargs->attune << 2 |
+		rsqargs->cancel << 1 | rsqargs->stcack,
+	};
+
+	err = CORE_SEND_COMMAND(core, CMD_FM_RSQ_STATUS,
+				args, resp,
+				atomic_read(&core->timeouts.command));
+
+	if (report && !err) {
+		report->multhint	= 0b10000000 & resp[1];
+		report->multlint	= 0b01000000 & resp[1];
+		report->snrhint		= 0b00001000 & resp[1];
+		report->snrlint		= 0b00000100 & resp[1];
+		report->rssihint	= 0b00000010 & resp[1];
+		report->rssilint	= 0b00000001 & resp[1];
+
+		report->bltf		= 0b10000000 & resp[2];
+		report->snr_ready	= 0b00100000 & resp[2];
+		report->rssiready	= 0b00001000 & resp[2];
+		report->afcrl		= 0b00000010 & resp[2];
+		report->valid		= 0b00000001 & resp[2];
+
+		report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
+		report->freqoff		= resp[5];
+		report->rssi		= resp[6];
+		report->snr		= resp[7];
+		report->lassi		= resp[9];
+		report->hassi		= resp[10];
+		report->mult		= resp[11];
+		report->dev		= resp[12];
+		report->readantcap	= be16_to_cpup((__be16 *)(resp + 13));
+		report->assi		= resp[15];
+		report->usn		= resp[16];
+	}
+
+	return err;
+}
+
+static int si476x_core_cmd_fm_rsq_status_a20(struct si476x_core *core,
+					struct si476x_rsq_status_args *rsqargs,
+					struct si476x_rsq_status_report *report)
+{
+	int err;
+	u8       resp[CMD_FM_RSQ_STATUS_A10_NRESP];
+
+	const u8 args[CMD_FM_RSQ_STATUS_A30_NARGS] = {
+		rsqargs->primary << 4 | rsqargs->rsqack << 3 |
+		rsqargs->attune  << 2 | rsqargs->cancel << 1 |
+		rsqargs->stcack,
+	};
+
+	err = CORE_SEND_COMMAND(core, CMD_FM_RSQ_STATUS,
+				args, resp,
+				atomic_read(&core->timeouts.command));
+
+	if (report && !err) {
+		report->multhint	= 0b10000000 & resp[1];
+		report->multlint	= 0b01000000 & resp[1];
+		report->snrhint		= 0b00001000 & resp[1];
+		report->snrlint		= 0b00000100 & resp[1];
+		report->rssihint	= 0b00000010 & resp[1];
+		report->rssilint	= 0b00000001 & resp[1];
+
+		report->bltf		= 0b10000000 & resp[2];
+		report->snr_ready	= 0b00100000 & resp[2];
+		report->rssiready	= 0b00001000 & resp[2];
+		report->afcrl		= 0b00000010 & resp[2];
+		report->valid		= 0b00000001 & resp[2];
+
+		report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
+		report->freqoff		= resp[5];
+		report->rssi		= resp[6];
+		report->snr		= resp[7];
+		report->lassi		= resp[9];
+		report->hassi		= resp[10];
+		report->mult		= resp[11];
+		report->dev		= resp[12];
+		report->readantcap	= be16_to_cpup((__be16 *)(resp + 13));
+		report->assi		= resp[15];
+		report->usn		= resp[16];
+	}
+
+	return err;
+}
+
+
+static int si476x_core_cmd_fm_rsq_status_a30(struct si476x_core *core,
+					struct si476x_rsq_status_args *rsqargs,
+					struct si476x_rsq_status_report *report)
+{
+	int err;
+	u8       resp[CMD_FM_RSQ_STATUS_A30_NRESP];
+	const u8 args[CMD_FM_RSQ_STATUS_A30_NARGS] = {
+		rsqargs->primary << 4 | rsqargs->rsqack << 3 |
+		rsqargs->attune << 2 | rsqargs->cancel << 1 |
+		rsqargs->stcack,
+	};
+
+	err = CORE_SEND_COMMAND(core, CMD_FM_RSQ_STATUS,
+				args, resp,
+				atomic_read(&core->timeouts.command));
+
+	if (report && !err) {
+		report->multhint	= 0b10000000 & resp[1];
+		report->multlint	= 0b01000000 & resp[1];
+		report->snrhint		= 0b00001000 & resp[1];
+		report->snrlint		= 0b00000100 & resp[1];
+		report->rssihint	= 0b00000010 & resp[1];
+		report->rssilint	= 0b00000001 & resp[1];
+
+		report->bltf		= 0b10000000 & resp[2];
+		report->snr_ready	= 0b00100000 & resp[2];
+		report->rssiready	= 0b00001000 & resp[2];
+		report->injside         = 0b00000100 & resp[2];
+		report->afcrl		= 0b00000010 & resp[2];
+		report->valid		= 0b00000001 & resp[2];
+
+		report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
+		report->freqoff		= resp[5];
+		report->rssi		= resp[6];
+		report->snr		= resp[7];
+		report->issi		= resp[8];
+		report->lassi		= resp[9];
+		report->hassi		= resp[10];
+		report->mult		= resp[11];
+		report->dev		= resp[12];
+		report->readantcap	= be16_to_cpup((__be16 *)(resp + 13));
+		report->assi		= resp[15];
+		report->usn		= resp[16];
+
+		report->pilotdev	= resp[17];
+		report->rdsdev		= resp[18];
+		report->assidev		= resp[19];
+		report->strongdev	= resp[20];
+		report->rdspi		= be16_to_cpup((__be16 *)(resp + 21));
+	}
+
+	return err;
+}
+
+static int si476x_core_cmd_fm_tune_freq_a10(struct si476x_core *core,
+					struct si476x_tune_freq_args *tuneargs)
+{
+	u8       resp[CMD_FM_TUNE_FREQ_NRESP];
+	const u8 args[CMD_FM_TUNE_FREQ_A10_NARGS] = {
+		(tuneargs->hd << 6) | (tuneargs->tunemode << 4)
+		| (tuneargs->smoothmetrics << 2),
+		msb(tuneargs->freq),
+		lsb(tuneargs->freq),
+		msb(tuneargs->antcap),
+		lsb(tuneargs->antcap)
+	};
+
+	return __cmd_tune_seek_freq(core, CMD_FM_TUNE_FREQ, args, sizeof(args),
+			       resp, sizeof(resp), __fm_clear_stcint);
+}
+
+static int si476x_core_cmd_fm_tune_freq_a20(struct si476x_core *core,
+					struct si476x_tune_freq_args *tuneargs)
+{
+	u8       resp[CMD_FM_TUNE_FREQ_NRESP];
+	const u8 args[CMD_FM_TUNE_FREQ_A20_NARGS] = {
+		(tuneargs->hd << 6) | (tuneargs->tunemode << 4)
+		|  (tuneargs->smoothmetrics << 2) | (tuneargs->injside),
+		msb(tuneargs->freq),
+		lsb(tuneargs->freq),
+	};
+
+	return __cmd_tune_seek_freq(core, CMD_FM_TUNE_FREQ, args, sizeof(args),
+			       resp, sizeof(resp), __fm_clear_stcint);
+}
+
+static int si476x_core_cmd_agc_status_a20(struct si476x_core *core,
+					struct si476x_agc_status_report *report)
+{
+	int err;
+	u8 resp[CMD_AGC_STATUS_NRESP_A20];
+
+	if (!report)
+		return -EINVAL;
+
+	err = __core_send_command(core, CMD_AGC_STATUS,
+				  NULL, 0,
+				  resp, ARRAY_SIZE(resp),
+				  atomic_read(&core->timeouts.command));
+	if (!err) {
+		report->mxhi		= resp[1] & SI476X_AGC_MXHI;
+		report->mxlo		= resp[1] & SI476X_AGC_MXLO;
+		report->lnahi		= resp[1] & SI476X_AGC_LNAHI;
+		report->lnalo		= resp[1] & SI476X_AGC_LNALO;
+		report->fmagc1		= resp[2];
+		report->fmagc2		= resp[3];
+		report->pgagain		= resp[4];
+		report->fmwblang	= resp[5];
+	}
+
+	return err;
+}
+
+static int si476x_core_cmd_agc_status_a10(struct si476x_core *core,
+					struct si476x_agc_status_report *report)
+{
+	int err;
+	u8 resp[CMD_AGC_STATUS_NRESP_A10];
+
+	if (!report)
+		return -EINVAL;
+
+	err = __core_send_command(core, CMD_AGC_STATUS,
+				  NULL, 0,
+				  resp, ARRAY_SIZE(resp),
+				  atomic_read(&core->timeouts.command));
+	if (!err) {
+		report->mxhi		= resp[1] & SI476X_AGC_MXHI;
+		report->mxlo		= resp[1] & SI476X_AGC_MXLO;
+		report->lnahi		= resp[1] & SI476X_AGC_LNAHI;
+		report->lnalo		= resp[1] & SI476X_AGC_LNALO;
+	}
+
+	return err;
+}
+
+static struct {
+	int (*power_up) (struct si476x_core *,
+			 struct si476x_power_up_args *);
+	int (*power_down) (struct si476x_core *,
+			   struct si476x_power_down_args *);
+
+	tune_freq_func_t fm_tune_freq;
+	tune_freq_func_t am_tune_freq;
+
+	int (*fm_rsq_status)(struct si476x_core *,
+			     struct si476x_rsq_status_args *,
+			     struct si476x_rsq_status_report *);
+
+	int (*agc_status)(struct si476x_core *,
+			  struct si476x_agc_status_report *);
+	int (*intb_pin_cfg)(struct si476x_core *core,
+			    enum si476x_intb_config intb,
+			    enum si476x_a1_config a1);
+} si476x_cmds_vtable[] = {
+	[SI476X_REVISION_A10] = {
+		.power_up	= si476x_core_cmd_power_up_a10,
+		.power_down	= si476x_core_cmd_power_down_a10,
+		.fm_tune_freq	= si476x_core_cmd_fm_tune_freq_a10,
+		.am_tune_freq	= si476x_core_cmd_am_tune_freq_a10,
+		.fm_rsq_status	= si476x_core_cmd_fm_rsq_status_a10,
+		.agc_status	= si476x_core_cmd_agc_status_a10,
+		.intb_pin_cfg   = si476x_core_cmd_intb_pin_cfg_a10,
+	},
+	[SI476X_REVISION_A20] = {
+		.power_up	= si476x_core_cmd_power_up_a20,
+		.power_down	= si476x_core_cmd_power_down_a20,
+		.fm_tune_freq	= si476x_core_cmd_fm_tune_freq_a20,
+		.am_tune_freq	= si476x_core_cmd_am_tune_freq_a20,
+		.fm_rsq_status	= si476x_core_cmd_fm_rsq_status_a20,
+		.agc_status	= si476x_core_cmd_agc_status_a20,
+		.intb_pin_cfg   = si476x_core_cmd_intb_pin_cfg_a20,
+	},
+	[SI476X_REVISION_A30] = {
+		.power_up	= si476x_core_cmd_power_up_a20,
+		.power_down	= si476x_core_cmd_power_down_a20,
+		.fm_tune_freq	= si476x_core_cmd_fm_tune_freq_a20,
+		.am_tune_freq	= si476x_core_cmd_am_tune_freq_a20,
+		.fm_rsq_status	= si476x_core_cmd_fm_rsq_status_a30,
+		.agc_status	= si476x_core_cmd_agc_status_a20,
+		.intb_pin_cfg   = si476x_core_cmd_intb_pin_cfg_a20,
+	},
+};
+
+int si476x_core_cmd_power_up(struct si476x_core *core,
+			     struct si476x_power_up_args *args)
+{
+	BUG_ON(core->revision > SI476X_REVISION_A30 ||
+	       core->revision == -1);
+	return si476x_cmds_vtable[core->revision].power_up(core, args);
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_power_up);
+
+int si476x_core_cmd_power_down(struct si476x_core *core,
+			       struct si476x_power_down_args *args)
+{
+	BUG_ON(core->revision > SI476X_REVISION_A30 ||
+	       core->revision == -1);
+	return si476x_cmds_vtable[core->revision].power_down(core, args);
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_power_down);
+
+int si476x_core_cmd_fm_tune_freq(struct si476x_core *core,
+				 struct si476x_tune_freq_args *args)
+{
+	BUG_ON(core->revision > SI476X_REVISION_A30 ||
+	       core->revision == -1);
+	return si476x_cmds_vtable[core->revision].fm_tune_freq(core, args);
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_tune_freq);
+
+int si476x_core_cmd_am_tune_freq(struct si476x_core *core,
+				 struct si476x_tune_freq_args *args)
+{
+	BUG_ON(core->revision > SI476X_REVISION_A30 ||
+	       core->revision == -1);
+	return si476x_cmds_vtable[core->revision].am_tune_freq(core, args);
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_am_tune_freq);
+
+int si476x_core_cmd_fm_rsq_status(struct si476x_core *core,
+				  struct si476x_rsq_status_args *args,
+				  struct si476x_rsq_status_report *report)
+
+{
+	BUG_ON(core->revision > SI476X_REVISION_A30 ||
+	       core->revision == -1);
+	return si476x_cmds_vtable[core->revision].fm_rsq_status(core, args,
+								report);
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_rsq_status);
+
+int si476x_core_cmd_agc_status(struct si476x_core *core,
+				  struct si476x_agc_status_report *report)
+
+{
+	BUG_ON(core->revision > SI476X_REVISION_A30 ||
+	       core->revision == -1);
+	return si476x_cmds_vtable[core->revision].agc_status(core, report);
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_agc_status);
+
+
+int si476x_core_cmd_intb_pin_cfg(struct si476x_core *core,
+			    enum si476x_intb_config intb,
+			    enum si476x_a1_config a1)
+{
+	BUG_ON(core->revision > SI476X_REVISION_A30 ||
+	       core->revision == -1);
+
+	return si476x_cmds_vtable[core->revision].intb_pin_cfg(core, intb, a1);
+}
+EXPORT_SYMBOL_GPL(si476x_core_cmd_intb_pin_cfg);
+
+
+
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Andrey Smirnov <andrey.smirnov@convergeddevices.net>");
+MODULE_DESCRIPTION("API for command exchange for si476x");
diff --git a/drivers/mfd/si476x-i2c.c b/drivers/mfd/si476x-i2c.c
new file mode 100644
index 0000000..d515158
--- /dev/null
+++ b/drivers/mfd/si476x-i2c.c
@@ -0,0 +1,1033 @@
+/*
+ * include/media/si476x-i2c.c -- Core device driver for si476x MFD
+ * device
+ *
+ * Copyright (C) 2012 Innovative Converged Devices(ICD)
+ *
+ * Author: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+#include <linux/module.h>
+
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/regulator/consumer.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+
+#include <linux/mfd/si476x-core.h>
+
+/* Command Timeouts */
+#define DEFAULT_TIMEOUT				10000
+#define TIMEOUT_TUNE				700000
+#define TIMEOUT_POWER_UP			330000
+
+#define MAX_IO_ERRORS 10
+
+#define SI476X_DRIVER_RDS_FIFO_DEPTH		128
+
+#define SI476X_STATUS_POLL_US 0
+
+/**
+ * si476x_core_config_pinmux() - pin function configuration function
+ *
+ * @core: Core device structure
+ *
+ * Configure the functions of the pins of the radio chip.
+ *
+ * The function returns zero in case of succes or negative error code
+ * otherwise.
+ */
+static int si476x_core_config_pinmux(struct si476x_core *core)
+{
+	int err;
+	dev_dbg(&core->client->dev, "Configuring pinmux\n");
+	err = si476x_core_cmd_dig_audio_pin_cfg(core,
+						core->pinmux.dclk,
+						core->pinmux.dfs,
+						core->pinmux.dout,
+						core->pinmux.xout);
+	if (err < 0) {
+		dev_err(&core->client->dev,
+			"Failed to configure digital audio pins(err = %d)\n",
+			err);
+		return err;
+	}
+
+	err = si476x_core_cmd_zif_pin_cfg(core,
+					  core->pinmux.iqclk,
+					  core->pinmux.iqfs,
+					  core->pinmux.iout,
+					  core->pinmux.qout);
+	if (err < 0) {
+		dev_err(&core->client->dev,
+			"Failed to configure ZIF pins(err = %d)\n",
+			err);
+		return err;
+	}
+
+	err = si476x_core_cmd_ic_link_gpo_ctl_pin_cfg(core,
+						      core->pinmux.icin,
+						      core->pinmux.icip,
+						      core->pinmux.icon,
+						      core->pinmux.icop);
+	if (err < 0) {
+		dev_err(&core->client->dev,
+			"Failed to configure IC-Link/GPO pins(err = %d)\n",
+			err);
+		return err;
+	}
+
+	err = si476x_core_cmd_ana_audio_pin_cfg(core,
+						core->pinmux.lrout);
+	if (err < 0) {
+		dev_err(&core->client->dev,
+			"Failed to configure analog audio pins(err = %d)\n",
+			err);
+		return err;
+	}
+
+	err = si476x_core_cmd_intb_pin_cfg(core,
+					   core->pinmux.intb,
+					   core->pinmux.a1);
+	if (err < 0) {
+		dev_err(&core->client->dev,
+			"Failed to configure interrupt pins(err = %d)\n",
+			err);
+		return err;
+	}
+
+	return 0;
+}
+
+static inline void si476x_schedule_polling_work(struct si476x_core *core)
+{
+	schedule_delayed_work(&core->status_monitor,
+			usecs_to_jiffies(atomic_read(&core->polling_interval)));
+}
+
+/**
+ * si476x_core_start() - early chip startup function
+ * @core: Core device structure
+ * @soft: When set, this flag forces "soft" startup, where "soft"
+ * power down is the one done by sending appropriate command instead
+ * of using reset pin of the tuner
+ *
+ * Perform required startup sequence to correctly power
+ * up the chip and perform initial configuration. It does the
+ * following sequence of actions:
+ *       1. Claims and enables the power supplies VD and VIO1 required
+ *          for I2C interface of the chip operation.
+ *       2. Waits for 100us, pulls the reset line up, enables irq,
+ *          waits for another 100us as it is specified by the
+ *          datasheet.
+ *       3. Sends 'POWER_UP' command to the device with all provided
+ *          information about power-up parameters.
+ *       4. Configures, pin multiplexor, disables digital audio and
+ *          configures interrupt sources.
+ *
+ * The function returns zero in case of succes or negative error code
+ * otherwise.
+ */
+int si476x_core_start(struct si476x_core *core, bool soft)
+{
+	struct i2c_client *client = core->client;
+	int err;
+
+	if (!soft) {
+		if (gpio_is_valid(core->gpio_reset))
+			gpio_set_value_cansleep(core->gpio_reset, 1);
+
+		if (client->irq)
+			enable_irq(client->irq);
+
+		udelay(100);
+
+		if (!client->irq) {
+			atomic_set(&core->is_alive, 1);
+			si476x_schedule_polling_work(core);
+		}
+	} else {
+		if (client->irq)
+			enable_irq(client->irq);
+		else {
+			atomic_set(&core->is_alive, 1);
+			si476x_schedule_polling_work(core);
+		}
+	}
+
+	err = si476x_core_cmd_power_up(core,
+				       &core->power_up_parameters);
+
+	if (err < 0) {
+		dev_err(&core->client->dev,
+			"Power up failure(err = %d)\n",
+			err);
+		goto disable_irq;
+	}
+
+	if (client->irq)
+		atomic_set(&core->is_alive, 1);
+
+	err = si476x_core_config_pinmux(core);
+	if (err < 0) {
+		dev_err(&core->client->dev,
+			"Failed to configure pinmux(err = %d)\n",
+			err);
+		goto disable_irq;
+	}
+
+
+	err = si476x_core_disable_digital_audio(core);
+	if (err < 0) {
+		dev_err(&core->client->dev,
+			"Failed to disable digital audio(err = %d)\n",
+			err);
+		goto disable_irq;
+	}
+
+	if (client->irq) {
+		err = si476x_core_set_int_ctl_enable(core,
+						     SI476X_RDSIEN |
+						     SI476X_STCIEN |
+						     SI476X_CTSIEN);
+		if (err < 0) {
+			dev_err(&core->client->dev,
+				"Failed to configure interrupt sources"
+				"(err = %d)\n", err);
+			goto disable_irq;
+		}
+	}
+
+	if (core->power_up_parameters.func == SI476X_FUNC_FM_RECEIVER &&
+	    core->diversity_mode) {
+		err = si476x_core_cmd_fm_phase_diversity(core,
+							 core->diversity_mode);
+		if (err < 0) {
+			dev_err(&core->client->dev,
+				"Failed to configure diversitymode role"
+				"(err = %d)\n", err);
+			goto disable_irq;
+		}
+	}
+
+	return 0;
+
+disable_irq:
+	if (err == -ENODEV)
+		atomic_set(&core->is_alive, 0);
+
+	if (client->irq)
+		disable_irq(client->irq);
+	else
+		cancel_delayed_work_sync(&core->status_monitor);
+
+	if (gpio_is_valid(core->gpio_reset))
+		gpio_set_value_cansleep(core->gpio_reset, 0);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(si476x_core_start);
+
+/**
+ * si476x_core_stop() - chip power-down function
+ * @core: Core device structure
+ * @soft: When set, function sends a POWER_DOWN command instead of
+ * bringing reset line low
+ *
+ * Power down the chip by performing following actions:
+ * 1. Disable IRQ or stop the polling worker
+ * 2. Send the POWER_DOWN command if the power down is soft or bring
+ *    reset line low if not.
+ *
+ * The function returns zero in case of succes or negative error code
+ * otherwise.
+ */
+int si476x_core_stop(struct si476x_core *core, bool soft)
+{
+	int err;
+	if (core->client->irq)
+		disable_irq(core->client->irq);
+	else
+		cancel_delayed_work_sync(&core->status_monitor);
+
+	atomic_set(&core->is_alive, 0);
+
+	if (soft) {
+		/* TODO: This probably shoud be a configurable option,
+		 * so it is possible to have the chips keep their
+		 * oscillators running
+		 */
+		struct si476x_power_down_args args = {
+			.xosc = false,
+		};
+		err = si476x_core_cmd_power_down(core, &args);
+	} else {
+		err = 0;
+		if (gpio_is_valid(core->gpio_reset))
+			gpio_set_value_cansleep(core->gpio_reset, 0);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(si476x_core_stop);
+
+/**
+ * si476x_core_set_power_state() - set the level at which the power is
+ * supplied for the chip.
+ * @core: Core device structure
+ * @next_state: enum si476x_power_state describing power state to
+ *              switch to.
+ *
+ * Switch on all the required power supplies
+ *
+ * This function returns 0 in case of suvccess and negative error code
+ * otherwise.
+ */
+int si476x_core_set_power_state(struct si476x_core *core,
+				enum si476x_power_state next_state)
+{
+	/*
+	   It is not clear form the datasheet if it is possible to
+	   work with device if not all power domains are operational.
+	   So for now the power-up policy is "full-steam ahead"
+	 */
+	int err = 0;
+
+	if (core->power_state == SI476X_POWER_INCONSISTENT) {
+		dev_err(&core->client->dev,
+			"The device in inconsistent power state\n");
+		return -EINVAL;
+	}
+
+	if (next_state != core->power_state) {
+		switch (next_state) {
+		case SI476X_POWER_UP_FULL:
+			if (core->supplies.va) {
+				err = regulator_enable(core->supplies.va);
+				if (err < 0)
+					break;
+			}
+			if (core->supplies.vio2) {
+				err = regulator_enable(core->supplies.vio2);
+				if (err < 0)
+					goto disable_va;
+			}
+
+			if (core->supplies.vd) {
+				err = regulator_enable(core->supplies.vd);
+				if (err < 0)
+					goto disable_vio2;
+			}
+			if (core->supplies.vio1) {
+				err = regulator_enable(core->supplies.vio1);
+				if (err < 0)
+					goto disable_vd;
+			}
+
+			udelay(100);		/* See startup timing diagram*/
+
+			err = si476x_core_start(core, false);
+			if (err < 0)
+				goto disable_vio1;
+
+			core->power_state = next_state;
+			break;
+
+		case SI476X_POWER_DOWN:
+			core->power_state = next_state;
+			err = si476x_core_stop(core, false);
+			if (err < 0)
+				core->power_state = \
+					SI476X_POWER_INCONSISTENT;
+disable_vio1:
+			if (core->supplies.vio1) {
+				err = regulator_disable(core->supplies.vio1);
+				if (err < 0)
+					core->power_state = \
+						SI476X_POWER_INCONSISTENT;
+			}
+disable_vd:
+			if (core->supplies.vd) {
+				err = regulator_disable(core->supplies.vd);
+				if (err < 0)
+					core->power_state = \
+						SI476X_POWER_INCONSISTENT;
+			}
+disable_vio2:
+			if (core->supplies.vio2) {
+				err = regulator_disable(core->supplies.vio2);
+				if (err < 0)
+					core->power_state = \
+						SI476X_POWER_INCONSISTENT;
+			}
+disable_va:
+			if (core->supplies.va) {
+				err = regulator_disable(core->supplies.va);
+				if (err < 0)
+					core->power_state = \
+						SI476X_POWER_INCONSISTENT;
+			}
+			break;
+		default:
+			BUG();
+		}
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_power_state);
+
+/**
+ * si476x_core_report_drainer_stop() - mark the completion of the RDS
+ * buffer drain porcess by the worker.
+ *
+ * @core: Core device structure
+ */
+static inline void si476x_core_report_drainer_stop(struct si476x_core *core)
+{
+	mutex_lock(&core->rds_drainer_status_lock);
+	core->rds_drainer_is_working = false;
+	mutex_unlock(&core->rds_drainer_status_lock);
+}
+
+/**
+ * si476x_core_start_rds_drainer_once() - start RDS drainer worker if
+ * ther is none working, do nothing otherwise
+ *
+ * @core: Datastructure corresponding to the chip.
+ */
+static inline void si476x_core_start_rds_drainer_once(struct si476x_core *core)
+{
+	mutex_lock(&core->rds_drainer_status_lock);
+	if (!core->rds_drainer_is_working) {
+		core->rds_drainer_is_working = true;
+		schedule_work(&core->rds_fifo_drainer);
+	}
+	mutex_unlock(&core->rds_drainer_status_lock);
+}
+/**
+ * si476x_drain_rds_fifo() - RDS buffer drainer.
+ * @work: struct work_struct being ppassed to the function by the
+ * kernel.
+ *
+ * Drain the contents of the RDS FIFO of
+ */
+static void si476x_drain_rds_fifo(struct work_struct *work)
+{
+	int err;
+
+	struct si476x_core *core = container_of(work, struct si476x_core,
+						rds_fifo_drainer);
+
+	struct si476x_rds_status_report report;
+
+	si476x_core_lock(core);
+	err = si476x_core_cmd_fm_rds_status(core, true, false, false, &report);
+	if (!err) {
+		int i = report.rdsfifoused;
+		dev_dbg(&core->client->dev,
+			"%d elements in RDS FIFO. Draining.\n", i);
+		for (; i > 0; --i) {
+			err = si476x_core_cmd_fm_rds_status(core, false, false,
+							    (i == 1), &report);
+			if (err < 0)
+				goto unlock;
+
+			kfifo_in(&core->rds_fifo, report.rds,
+				 sizeof(report.rds));
+			DBG_BUFFER(&core->client->dev, "RDS data:\n",
+				   report.rds, sizeof(report.rds));
+		}
+		dev_dbg(&core->client->dev, "Drrrrained!\n");
+		wake_up_interruptible(&core->rds_read_queue);
+	}
+
+unlock:
+	si476x_core_unlock(core);
+	si476x_core_report_drainer_stop(core);
+}
+
+/**
+ * si476x_core_pronounce_dead()
+ *
+ * @core: Core device structure
+ *
+ * Mark the device as being dead and wake up all potentially waiting
+ * threads of execution.
+ *
+ */
+static void si476x_core_pronounce_dead(struct si476x_core *core)
+{
+	dev_info(&core->client->dev, "Core device is dead.\n");
+
+	atomic_set(&core->is_alive, 0);
+
+	/* Wake up al possible waiting processes */
+	wake_up_interruptible(&core->rds_read_queue);
+
+	atomic_set(&core->cts, 1);
+	wake_up(&core->command);
+
+	atomic_set(&core->stc, 1);
+	wake_up(&core->tuning);
+}
+
+/**
+ * si476x_i2c_xfer()
+ *
+ * @core: Core device structure
+ * @type: Transfer type
+ * @buf: Transfer buffer for/with data
+ * @count: Transfer buffer size
+ *
+ * Perfrom and I2C transfer(either read or write) and keep a counter
+ * of I/O errors. If the error counter rises above the threshold
+ * pronounce device dead.
+ *
+ * The function returns zero on succes or negative error code on
+ * failure.
+ */
+int si476x_i2c_xfer(struct si476x_core *core,
+		    enum si476x_i2c_type type,
+		    char *buf, int count)
+{
+	static int io_errors_count;
+	int err;
+	if (type == SI476X_I2C_SEND)
+		err = i2c_master_send(core->client, buf, count);
+	else
+		err = i2c_master_recv(core->client, buf, count);
+
+	if (err < 0) {
+		if (io_errors_count++ > MAX_IO_ERRORS)
+			si476x_core_pronounce_dead(core);
+	} else {
+		io_errors_count = 0;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(si476x_i2c_xfer);
+
+/**
+ * si476x_get_status()
+ * @core: Core device structure
+ *
+ * Get the status byte of the core device by berforming one byte I2C
+ * read.
+ *
+ * The function returns a status value or a negative error code on
+ * error.
+ */
+static int si476x_get_status(struct si476x_core *core)
+{
+	u8 response;
+	int err = si476x_i2c_xfer(core, SI476X_I2C_RECV,
+				  &response, sizeof(response));
+
+	return (err < 0) ? err : response;
+}
+
+/**
+ * si476x_get_and_signal_status() - IRQ dispatcher
+ * @core: Core device structure
+ *
+ * Dispatch the arrived interrupt request based on the value of the
+ * status byte reported by the tuner.
+ *
+ */
+static void si476x_get_and_signal_status(struct si476x_core *core)
+{
+	int status = si476x_get_status(core);
+	if (status < 0) {
+		dev_err(&core->client->dev, "Failed to get status\n");
+		return;
+	}
+
+	if (status & SI476X_CTS) {
+		/* Unfortunately completions could not be used for
+		 * signalling CTS since this flag cannot be cleared
+		 * in status byte, and therefore once it becomes true
+		 * multiple callse to 'complete' would cause the
+		 * commands following the current one to be completed
+		 * before they actually are */
+		dev_dbg(&core->client->dev, "[interrupt] CTSINT\n");
+		atomic_set(&core->cts, 1);
+		wake_up(&core->command);
+	}
+
+	if (status & SI476X_FM_RDS_INT) {
+		dev_dbg(&core->client->dev, "[interrupt] RDSINT\n");
+		si476x_core_start_rds_drainer_once(core);
+	}
+
+	if (status & SI476X_STC_INT) {
+		dev_dbg(&core->client->dev, "[interrupt] STCINT\n");
+		atomic_set(&core->stc, 1);
+		wake_up(&core->tuning);
+	}
+}
+
+static void si476x_poll_loop(struct work_struct *work)
+{
+	struct si476x_core *core = SI476X_WORK_TO_CORE(work);
+
+	si476x_get_and_signal_status(core);
+
+	if (atomic_read(&core->is_alive))
+		si476x_schedule_polling_work(core);
+}
+/**
+ */
+static irqreturn_t si476x_interrupt(int irq, void *dev)
+{
+	struct si476x_core *core = dev;
+
+	si476x_get_and_signal_status(core);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * si476x_firmware_version_to_revision()
+ * @core: Core device structure
+ * @major:  Firmware major number
+ * @minor1: Firmware first minor number
+ * @minor2: Firmware second minor number
+ *
+ * Convert a chip's firmware version number into an offset that later
+ * will be used to as offset in "vtable" of tuner functions
+ *
+ * This function returns a positive offset in case of success and a -1
+ * in case of failure.
+ */
+static inline int si476x_firmware_version_to_revision(struct si476x_core *core,
+						      int func, int major,
+						      int minor1, int minor2)
+{
+	switch (func) {
+	case SI476X_FUNC_FM_RECEIVER:
+		switch (major) {
+		case 5:
+			return SI476X_REVISION_A10;
+		case 8:
+			return SI476X_REVISION_A20;
+		case 10:
+			return SI476X_REVISION_A30;
+		default:
+			goto unknown_revision;
+		}
+	case SI476X_FUNC_AM_RECEIVER:
+		switch (major) {
+		case 5:
+			return SI476X_REVISION_A10;
+		case 7:
+			return SI476X_REVISION_A20;
+		case 9:
+			return SI476X_REVISION_A30;
+		default:
+			goto unknown_revision;
+		}
+	case SI476X_FUNC_WB_RECEIVER:
+		switch (major) {
+		case 3:
+			return SI476X_REVISION_A10;
+		case 5:
+			return SI476X_REVISION_A20;
+		case 7:
+			return SI476X_REVISION_A30;
+		default:
+			goto unknown_revision;
+		}
+	case SI476X_FUNC_BOOTLOADER:
+	default:		/* FALLTHROUG */
+		BUG();
+		return -1;
+	}
+
+unknown_revision:
+	dev_err(&core->client->dev,
+		"Unsupported version of the firmware: %d.%d.%d, "
+		"reverting to A10 comptible functions\n",
+		major, minor1, minor2);
+
+	return SI476X_REVISION_A10;
+}
+
+/**
+ * si476x_get_revision_info()
+ * @core: Core device structure
+ *
+ * Get the firmware version number of the device. It is done in
+ * following three steps:
+ *    1. Power-up the device
+ *    2. Send the 'FUNC_INFO' command
+ *    3. Powering the device down.
+ *
+ * The function return zero on success and a negative error code on
+ * failure.
+ */
+static int si476x_get_revision_info(struct si476x_core *core)
+{
+	int rval;
+	struct si476x_func_info info;
+
+	si476x_core_lock(core);
+	rval = si476x_core_set_power_state(core,
+					   SI476X_POWER_UP_FULL);
+	if (!rval) {
+		rval = si476x_core_cmd_func_info(core, &info);
+		if (!rval)
+			core->revision = \
+				si476x_firmware_version_to_revision(core,
+						    info.func,
+						    info.firmware.major,
+						    info.firmware.minor[0],
+						    info.firmware.minor[1]);
+		si476x_core_set_power_state(core,
+					    SI476X_POWER_DOWN);
+	}
+
+	si476x_core_unlock(core);
+
+	return rval;
+}
+
+#define ATOMIC_CORE_DEV_ATTR(__attr_name, __field_name)			\
+	static ssize_t __attr_name##_show(struct device *dev,		\
+					  struct device_attribute *attr, \
+					  char *buf)			\
+	{								\
+		struct i2c_client  *client;				\
+		struct si476x_core *core;				\
+									\
+		client = container_of(dev, struct i2c_client, dev);	\
+		core   = i2c_get_clientdata(client);			\
+									\
+		return sprintf(buf, "%u", atomic_read(&core->__field_name)); \
+	}								\
+	static ssize_t __attr_name##_store(struct device *dev,		\
+					   struct device_attribute *attr, \
+					   const char *buf, size_t count) \
+	{								\
+		unsigned int delay;					\
+									\
+		struct i2c_client  *client;				\
+		struct si476x_core *core;				\
+									\
+		if (sscanf(buf, "%u", &delay) != 1)			\
+			return -EINVAL;					\
+									\
+		client = container_of(dev, struct i2c_client, dev);	\
+		core   = i2c_get_clientdata(client);			\
+									\
+		atomic_set(&core->__field_name, delay);			\
+		return count;						\
+	}								\
+	static DEVICE_ATTR(__attr_name, S_IWUSR|S_IRUGO,		\
+			   __attr_name##_show, __attr_name##_store)
+
+
+ATOMIC_CORE_DEV_ATTR(polling_interval_us, polling_interval);
+ATOMIC_CORE_DEV_ATTR(tune_timeout_us, timeouts.tune);
+ATOMIC_CORE_DEV_ATTR(command_timeout_us, timeouts.command);
+ATOMIC_CORE_DEV_ATTR(power_up_timeout_us, timeouts.power_up);
+
+static struct attribute *si476x_core_attrs[] = {
+	&dev_attr_polling_interval_us.attr,
+	&dev_attr_tune_timeout_us.attr,
+	&dev_attr_command_timeout_us.attr,
+	&dev_attr_power_up_timeout_us.attr,
+	NULL
+};
+
+static struct attribute_group si476x_core_attr_group = {
+	.attrs = si476x_core_attrs,
+};
+
+
+static int __devinit si476x_core_probe(struct i2c_client *client,
+				       const struct i2c_device_id *id)
+{
+	int rval;
+	struct si476x_core          *core;
+	struct si476x_platform_data *pdata;
+	struct mfd_cell *cell;
+	int              cell_num;
+
+	core = kzalloc(sizeof(*core), GFP_KERNEL);
+	if (!core) {
+		pr_err("si476x-core: failed to allocate " \
+		       "'struct si476x_core'\n");
+		return -ENOMEM;
+	}
+
+	core->client = client;
+	i2c_set_clientdata(client, core);
+
+	atomic_set(&core->is_alive, 0);
+	core->power_state = SI476X_POWER_DOWN;
+
+	pdata = client->dev.platform_data;
+	if (pdata) {
+		memcpy(&core->power_up_parameters,
+		       &pdata->power_up_parameters,
+		       sizeof(core->power_up_parameters));
+
+		core->gpio_reset = -1;
+		if (gpio_is_valid(pdata->gpio_reset)) {
+			rval = gpio_request(pdata->gpio_reset, "si476x reset");
+			if (rval) {
+				dev_err(&client->dev,
+					"Failed to request gpio: %d\n", rval);
+				goto free_core;
+			}
+			core->gpio_reset = pdata->gpio_reset;
+			gpio_direction_output(core->gpio_reset, 0);
+		}
+
+		core->diversity_mode = pdata->diversity_mode;
+		memcpy(&core->pinmux, &pdata->pinmux,
+		       sizeof(struct si476x_pinmux));
+	} else {
+		dev_err(&client->dev, "No platform data provided\n");
+		rval = -EINVAL;
+		goto free_core;
+	}
+
+	core->supplies.vio1 = regulator_get(&client->dev, "vio1");
+	if (IS_ERR_OR_NULL(core->supplies.vio1)) {
+		dev_info(&client->dev, "No vio1 regulator found\n");
+		core->supplies.vio1 = NULL;
+	}
+
+	core->supplies.vd = regulator_get(&client->dev, "vd");
+	if (IS_ERR_OR_NULL(core->supplies.vd)) {
+		dev_info(&client->dev, "No vd regulator found" "\n");
+		core->supplies.vd = NULL;
+	}
+
+	core->supplies.va = regulator_get(&client->dev, "va");
+	if (IS_ERR_OR_NULL(core->supplies.va)) {
+		dev_info(&client->dev, "No va regulator found\n");
+		core->supplies.va = NULL;
+	}
+
+	core->supplies.vio2 = regulator_get(&client->dev, "vio2");
+	if (IS_ERR_OR_NULL(core->supplies.vio2)) {
+		dev_info(&client->dev, "No vio2 regulator found\n");
+		core->supplies.vio2 = NULL;
+	}
+
+	mutex_init(&core->cmd_lock);
+	init_waitqueue_head(&core->command);
+	init_waitqueue_head(&core->tuning);
+
+	rval = kfifo_alloc(&core->rds_fifo,
+			   SI476X_DRIVER_RDS_FIFO_DEPTH * \
+			   sizeof(struct v4l2_rds_data),
+			   GFP_KERNEL);
+	if (rval) {
+		dev_err(&client->dev, "Could not alloate the FIFO\n");
+		goto put_reg;
+	}
+	mutex_init(&core->rds_drainer_status_lock);
+	init_waitqueue_head(&core->rds_read_queue);
+	INIT_WORK(&core->rds_fifo_drainer, si476x_drain_rds_fifo);
+
+	atomic_set(&core->polling_interval, SI476X_STATUS_POLL_US);
+
+	atomic_set(&core->timeouts.tune, TIMEOUT_TUNE);
+	atomic_set(&core->timeouts.power_up, TIMEOUT_POWER_UP);
+	atomic_set(&core->timeouts.command, DEFAULT_TIMEOUT);
+
+
+	rval = sysfs_create_group(&client->dev.kobj, &si476x_core_attr_group);
+	if (rval < 0) {
+		dev_err(&client->dev, "Failed to create sysfs attributes\n");
+		goto free_kfifo;
+	}
+
+	if (client->irq) {
+		rval = request_threaded_irq(client->irq, NULL, si476x_interrupt,
+					    IRQF_TRIGGER_FALLING,
+					    client->name, core);
+		if (rval < 0) {
+			dev_err(&client->dev, "Could not request IRQ %d\n",
+				client->irq);
+			goto free_sysfs;
+		}
+		disable_irq(client->irq);
+		dev_dbg(&client->dev, "IRQ requested.\n");
+
+		core->rds_fifo_depth = 20;
+	} else {
+		INIT_DELAYED_WORK(&core->status_monitor,
+				  si476x_poll_loop);
+		dev_info(&client->dev,
+			 "No IRQ number specified, will use polling\n");
+
+		core->rds_fifo_depth = 5;
+	}
+
+	core->chip_id = id->driver_data;
+
+	rval = si476x_get_revision_info(core);
+	if (rval < 0) {
+		rval = -ENODEV;
+		goto free_irq;
+	}
+
+	cell_num = 0;
+
+	cell = &core->cells[SI476X_RADIO_CELL];
+	cell->name          = "si476x-radio";
+	cell->platform_data = &core;
+	cell->pdata_size    = sizeof(core);
+	cell_num++;
+
+	if (core->chip_id < 5                           &&
+	    core->pinmux.dclk == SI476X_DCLK_DAUDIO     &&
+	    core->pinmux.dfs  == SI476X_DFS_DAUDIO      &&
+	    core->pinmux.dout == SI476X_DOUT_I2S_OUTPUT &&
+	    core->pinmux.xout == SI476X_XOUT_TRISTATE) {
+		cell = &core->cells[SI476X_CODEC_CELL];
+		cell->name          = "si476x-codec";
+		cell->platform_data = &core;
+		cell->pdata_size    = sizeof(core);
+		cell_num++;
+	}
+
+	kref_init(&core->kref);
+	rval = mfd_add_devices(&client->dev,
+			       (client->adapter->nr << 8) + client->addr,
+			       core->cells, cell_num, NULL, 0);
+	if (!rval)
+		return 0;
+
+
+free_irq:
+	if (client->irq)
+		free_irq(client->irq, core);
+free_sysfs:
+	sysfs_remove_group(&client->dev.kobj, &si476x_core_attr_group);
+free_kfifo:
+	kfifo_free(&core->rds_fifo);
+
+put_reg:
+	if (core->supplies.vio2)
+		regulator_put(core->supplies.vio2);
+	if (core->supplies.va)
+		regulator_put(core->supplies.va);
+	if (core->supplies.vd)
+		regulator_put(core->supplies.vd);
+	if (core->supplies.vio1)
+		regulator_put(core->supplies.vio1);
+	if (gpio_is_valid(core->gpio_reset))
+		gpio_free(core->gpio_reset);
+free_core:
+	kfree(core);
+	return rval;
+}
+
+static void si476x_core_delete(struct kref *kref)
+{
+	struct si476x_core *core = kref_to_si476x_core(kref);
+
+	kfifo_free(&core->rds_fifo);
+	kfree(core);
+}
+
+void si476x_core_get(struct si476x_core *core)
+{
+	kref_get(&core->kref);
+}
+EXPORT_SYMBOL_GPL(si476x_core_get);
+
+void si476x_core_put(struct si476x_core *core)
+{
+	kref_put(&core->kref, si476x_core_delete);
+}
+EXPORT_SYMBOL_GPL(si476x_core_put);
+
+static int si476x_core_remove(struct i2c_client *client)
+{
+	struct si476x_core *core = i2c_get_clientdata(client);
+
+	si476x_core_pronounce_dead(core);
+
+	mfd_remove_devices(&client->dev);
+
+	if (client->irq) {
+		disable_irq(client->irq);
+		free_irq(client->irq, core);
+	} else {
+		cancel_delayed_work_sync(&core->status_monitor);
+	}
+
+	sysfs_remove_group(&client->dev.kobj, &si476x_core_attr_group);
+
+	if (core->supplies.vio2)
+		regulator_put(core->supplies.vio2);
+	if (core->supplies.va)
+		regulator_put(core->supplies.va);
+	if (core->supplies.vd)
+		regulator_put(core->supplies.vd);
+	if (core->supplies.vio1)
+		regulator_put(core->supplies.vio1);
+
+	if (gpio_is_valid(core->gpio_reset))
+		gpio_free(core->gpio_reset);
+
+	si476x_core_put(core);
+
+	return 0;
+}
+
+
+static const struct i2c_device_id si476x_id[] = {
+	{ "si4761", 1 },
+	{ "si4764", 4 },
+	{ "si4768", 8 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, si476x_id);
+
+static struct i2c_driver si476x_core_driver = {
+	.driver		= {
+		.name	= "si476x-core",
+		.owner  = THIS_MODULE,
+	},
+	.probe		= si476x_core_probe,
+	.remove         = __devexit_p(si476x_core_remove),
+	.id_table       = si476x_id,
+};
+
+static int __init si476x_core_init(void)
+{
+	return i2c_add_driver(&si476x_core_driver);
+}
+
+static void __exit si476x_core_exit(void)
+{
+	i2c_del_driver(&si476x_core_driver);
+}
+late_initcall(si476x_core_init);
+module_exit(si476x_core_exit);
+
+
+MODULE_AUTHOR("Andrey Smirnov <andrey.smirnov@convergeddevices.net>");
+MODULE_DESCRIPTION("Si4761/64/68 AM/FM MFD core device driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/si476x-prop.c b/drivers/mfd/si476x-prop.c
new file mode 100644
index 0000000..d633c08
--- /dev/null
+++ b/drivers/mfd/si476x-prop.c
@@ -0,0 +1,477 @@
+/*
+ * include/media/si476x-prop.c -- Subroutines to manipulate with
+ * properties of si476x chips
+ *
+ * Copyright (C) 2012 Innovative Converged Devices(ICD)
+ *
+ * Author: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/module.h>
+
+#include <media/si476x.h>
+#include <linux/mfd/si476x-core.h>
+
+
+enum si476x_common_receiver_properties {
+	SI476X_PROP_INT_CTL_ENABLE			= 0x0000,
+	SI476X_PROP_DIGITAL_IO_INPUT_SAMPLE_RATE	= 0x0200,
+	SI476X_PROP_DIGITAL_IO_INPUT_FORMAT		= 0x0201,
+	SI476X_PROP_DIGITAL_IO_OUTPUT_SAMPLE_RATE	= 0x0202,
+	SI476X_PROP_DIGITAL_IO_OUTPUT_FORMAT		= 0x0203,
+
+	SI476X_PROP_AUDIO_ANALOG_VOLUME			= 0x0300,
+	SI476X_PROP_AUDIO_MUTE				= 0x0301,
+
+	SI476X_PROP_ZIF_OUTPUT_CFG			= 0x0600,
+
+	SI476X_PROP_SEEK_BAND_BOTTOM			= 0x1100,
+	SI476X_PROP_SEEK_BAND_TOP			= 0x1101,
+	SI476X_PROP_SEEK_FREQUENCY_SPACING		= 0x1102,
+
+	SI476X_PROP_VALID_MAX_TUNE_ERROR		= 0x2000,
+	SI476X_PROP_VALID_SNR_THRESHOLD			= 0x2003,
+
+	SI476X_PROP_VALID_RSSI_THRESHOLD		= 0x2004,
+};
+
+enum si476x_am_receiver_properties {
+	SI476X_PROP_AUDIO_PWR_LINE_FILTER		= 0x0303,
+};
+
+enum si476x_fm_receiver_properties {
+	SI476X_PROP_AUDIO_DEEMPHASIS				= 0x0302,
+
+	SI476X_PROP_FM_VALID_RSSI_TIME				= 0x2001,
+	SI476X_PROP_FM_VALID_SNR_TIME				= 0x2002,
+	SI476X_PROP_FM_VALID_AF_TIME				= 0x2007,
+
+	SI476X_PROP_FM_RDS_INTERRUPT_SOURCE			= 0x4000,
+	SI476X_PROP_FM_RDS_INTERRUPT_FIFO_COUNT			= 0x4001,
+	SI476X_PROP_FM_RDS_CONFIG				= 0x4002,
+};
+
+struct si476x_property_range {
+	u16 low, high;
+};
+
+static bool __element_is_in_array(u16 element, const u16 array[], size_t size)
+{
+	int i;
+
+	for (i = 0; i < size; i++)
+		if (element == array[i])
+			return true;
+
+	return false;
+}
+
+static bool __element_is_in_range(u16 element,
+				  const struct si476x_property_range range[],
+				  size_t size)
+{
+	int i;
+
+	for (i = 0; i < size; i++)
+		if (element <= range[i].high && element >= range[i].low)
+			return true;
+
+	return false;
+}
+
+static bool si476x_core_is_valid_property_a10(struct si476x_core *core,
+					      u16 property)
+{
+	static const u16 valid_properties[] = {
+		0x0000,
+		0x0500, 0x0501,
+		0x0600,
+		0x0709, 0x070C, 0x070D, 0x70E, 0x710,
+		0x718,		/* FIXME: Magic property */
+		0x1207, 0x1208,
+		0x2007,
+		0x2300,
+	};
+
+	static const struct si476x_property_range valid_ranges[] = {
+		{ 0x0200, 0x0203 },
+		{ 0x0300, 0x0303 },
+		{ 0x0400, 0x0404 },
+		{ 0x0700, 0x0707 },
+		{ 0x1100, 0x1102 },
+		{ 0x1200, 0x1204 },
+		{ 0x1300, 0x1306 },
+		{ 0x2000, 0x2005 },
+		{ 0x2100, 0x2104 },
+		{ 0x2106, 0x2106 },
+		{ 0x2200, 0x220E },
+		{ 0x3100, 0x3104 },
+		{ 0x3207, 0x320F },
+		{ 0x3300, 0x3304 },
+		{ 0x3500, 0x3517 },
+		{ 0x3600, 0x3617 },
+		{ 0x3700, 0x3717 },
+		{ 0x4000, 0x4003 },
+	};
+
+	return	__element_is_in_range(property, valid_ranges,
+				     ARRAY_SIZE(valid_ranges)) ||
+		__element_is_in_array(property, valid_properties,
+				      ARRAY_SIZE(valid_properties));
+}
+
+static bool si476x_core_is_valid_property_a20(struct si476x_core *core,
+					      u16 property)
+{
+	static const u16 valid_properties[] = {
+		0x071B,
+		0x1006,
+		0x2210,
+		0x3401,
+	};
+
+	static const struct si476x_property_range valid_ranges[] = {
+		{ 0x2215, 0x2219 },
+	};
+
+	return	si476x_core_is_valid_property_a10(core, property) ||
+		__element_is_in_range(property, valid_ranges,
+				      ARRAY_SIZE(valid_ranges))  ||
+		__element_is_in_array(property, valid_properties,
+				      ARRAY_SIZE(valid_properties));
+}
+
+static bool si476x_core_is_valid_property_a30(struct si476x_core *core,
+					      u16 property)
+{
+	static const u16 valid_properties[] = {
+		0x071C, 0x071D,
+		0x1007, 0x1008,
+		0x220F, 0x2214,
+		0x2301,
+		0x3105, 0x3106,
+		0x3402,
+	};
+
+	static const struct si476x_property_range valid_ranges[] = {
+		{ 0x0405, 0x0411 },
+		{ 0x2008, 0x200B },
+		{ 0x2220, 0x2223 },
+		{ 0x3100, 0x3106 },
+	};
+
+	return	si476x_core_is_valid_property_a20(core, property) ||
+		__element_is_in_range(property, valid_ranges,
+				      ARRAY_SIZE(valid_ranges)) ||
+		__element_is_in_array(property, valid_properties,
+				      ARRAY_SIZE(valid_properties));
+}
+
+typedef bool (*valid_property_pred_t) (struct si476x_core *, u16);
+
+bool si476x_core_is_valid_property(struct si476x_core *core, u16 property)
+{
+	static const valid_property_pred_t is_valid_property[] = {
+		[SI476X_REVISION_A10] = si476x_core_is_valid_property_a10,
+		[SI476X_REVISION_A20] = si476x_core_is_valid_property_a20,
+		[SI476X_REVISION_A30] = si476x_core_is_valid_property_a30,
+	};
+
+	BUG_ON(core->revision > SI476X_REVISION_A30 ||
+	       core->revision == -1);
+	return is_valid_property[core->revision](core, property);
+}
+EXPORT_SYMBOL_GPL(si476x_core_is_valid_property);
+
+bool si476x_core_is_readonly_property(struct si476x_core *core, u16 property)
+{
+	BUG_ON(core->revision > SI476X_REVISION_A30 ||
+	       core->revision == -1);
+
+	switch (core->revision) {
+	case SI476X_REVISION_A10:
+		return (property == 0x3200);
+	case SI476X_REVISION_A20:
+		return (property == 0x1006 ||
+			property == 0x2210 ||
+			property == 0x3200);
+	case SI476X_REVISION_A30:
+		return false;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(si476x_core_is_readonly_property);
+
+int si476x_core_set_int_ctl_enable(struct si476x_core *core,
+				   enum si476x_interrupt_flags flags)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_INT_CTL_ENABLE, flags);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_int_ctl_enable);
+
+
+int si476x_core_set_audio_pwr_line_filter(struct si476x_core *core,
+					bool enable,
+					enum si476x_power_grid_type power_grid,
+					int harmonics_count)
+{
+	const u16 value = (enable << 9) | (power_grid << 8) | harmonics_count;
+
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_AUDIO_PWR_LINE_FILTER,
+					    value);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_audio_pwr_line_filter);
+
+int si476x_core_get_audio_pwr_line_filter(struct si476x_core *core)
+{
+	return si476x_core_cmd_get_property(core,
+					    SI476X_PROP_AUDIO_PWR_LINE_FILTER);
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_audio_pwr_line_filter);
+
+int si476x_core_set_frequency_spacing(struct si476x_core *core, int spacing)
+{
+	/* FIXME: Magic numbers */
+	if (0 < spacing && spacing <= 310000)
+		return si476x_core_cmd_set_property(core,
+					SI476X_PROP_SEEK_FREQUENCY_SPACING,
+					hz_to_si476x(core, spacing));
+	else
+		return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_frequency_spacing);
+
+int si476x_core_get_frequency_spacing(struct si476x_core *core)
+{
+	int value;
+	value = si476x_core_cmd_get_property(core,
+					SI476X_PROP_SEEK_FREQUENCY_SPACING);
+	if (value >= 0)
+		value = si476x_to_hz(core, value);
+
+	return value;
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_frequency_spacing);
+
+int si476x_core_set_seek_band_top(struct si476x_core *core,
+				  int top)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_SEEK_BAND_TOP,
+					    hz_to_si476x(core, top));
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_seek_band_top);
+
+int si476x_core_get_seek_band_top(struct si476x_core *core)
+{
+	int value;
+	value = si476x_core_cmd_get_property(core,
+					     SI476X_PROP_SEEK_BAND_TOP);
+	if (value >= 0)
+		value = si476x_to_hz(core, value);
+
+	return value;
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_seek_band_top);
+
+int si476x_core_set_seek_band_bottom(struct si476x_core *core,
+				     int bottom)
+{
+	return si476x_core_cmd_set_property(core,
+					   SI476X_PROP_SEEK_BAND_BOTTOM,
+					    hz_to_si476x(core, bottom));
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_seek_band_bottom);
+
+int si476x_core_get_seek_band_bottom(struct si476x_core *core)
+{
+	int value;
+	value = si476x_core_cmd_get_property(core,
+					     SI476X_PROP_SEEK_BAND_BOTTOM);
+	if (value >= 0)
+		value = si476x_to_hz(core, value);
+
+	return value;
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_seek_band_bottom);
+
+int si476x_core_set_audio_deemphasis(struct si476x_core *core,
+				     int deemphasis)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_AUDIO_DEEMPHASIS,
+					    deemphasis);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_audio_deemphasis);
+
+int si476x_core_get_audio_deemphasis(struct si476x_core *core)
+{
+	int value;
+	value = si476x_core_cmd_get_property(core,
+					     SI476X_PROP_AUDIO_DEEMPHASIS);
+	if (value >= 0)
+		value = si476x_to_hz(core, value);
+
+	return value;
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_audio_deemphasis);
+
+int si476x_core_set_fm_rds_interrupt_fifo_count(struct si476x_core *core,
+						int count)
+{
+	return si476x_core_cmd_set_property(core,
+				       SI476X_PROP_FM_RDS_INTERRUPT_FIFO_COUNT,
+				       count);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_fm_rds_interrupt_fifo_count);
+
+int si476x_core_set_rds_interrupt_source(struct si476x_core *core,
+				    enum si476x_rdsint_sources sources)
+{
+	return si476x_core_cmd_set_property(core,
+				       SI476X_PROP_FM_RDS_INTERRUPT_SOURCE,
+				       sources);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_rds_interrupt_source);
+
+int si476x_core_set_digital_io_input_sample_rate(struct si476x_core *core,
+					    u16 rate)
+{
+	return si476x_core_cmd_set_property(core,
+				SI476X_PROP_DIGITAL_IO_INPUT_SAMPLE_RATE,
+				rate);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_digital_io_input_sample_rate);
+
+int si476x_core_disable_digital_audio(struct si476x_core *core)
+{
+	return si476x_core_set_digital_io_input_sample_rate(core, 0);
+}
+EXPORT_SYMBOL_GPL(si476x_core_disable_digital_audio);
+
+int si476x_core_set_valid_snr_threshold(struct si476x_core *core, int threshold)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_VALID_SNR_THRESHOLD,
+					    threshold);
+
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_valid_snr_threshold);
+
+int si476x_core_get_valid_snr_threshold(struct si476x_core *core)
+{
+	return si476x_core_cmd_get_property(core,
+					    SI476X_PROP_VALID_SNR_THRESHOLD);
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_valid_snr_threshold);
+
+int si476x_core_set_valid_rssi_threshold(struct si476x_core *core,
+					 int threshold)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_VALID_RSSI_THRESHOLD,
+					    threshold);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_valid_rssi_threshold);
+
+int si476x_core_get_valid_rssi_threshold(struct si476x_core *core)
+{
+	return si476x_core_cmd_get_property(core,
+					    SI476X_PROP_VALID_RSSI_THRESHOLD);
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_valid_rssi_threshold);
+
+int si476x_core_set_valid_max_tune_error(struct si476x_core *core, int value)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_VALID_MAX_TUNE_ERROR,
+					    value);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_valid_max_tune_error);
+
+int si476x_core_get_valid_max_tune_error(struct si476x_core *core)
+{
+	return si476x_core_cmd_get_property(core,
+					    SI476X_PROP_VALID_MAX_TUNE_ERROR);
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_valid_max_tune_error);
+
+
+#define SI476X_RDSEN 0x1
+
+int si476x_core_get_rds_reception(struct si476x_core *core)
+{
+	int property = si476x_core_cmd_get_property(core,
+						    SI476X_PROP_FM_RDS_CONFIG);
+
+	return (property < 0) ? property : (property & SI476X_RDSEN);
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_rds_reception);
+
+static int __set_rdsen(struct si476x_core *core, bool rdsen)
+{
+	int property = si476x_core_cmd_get_property(core,
+					   SI476X_PROP_FM_RDS_CONFIG);
+	if (property >= 0) {
+		property = (rdsen) ?
+			(property | SI476X_RDSEN) :
+			(property & ~SI476X_RDSEN);
+
+		return si476x_core_cmd_set_property(core,
+						    SI476X_PROP_FM_RDS_CONFIG,
+						    property);
+	} else {
+		return property;
+	}
+}
+
+int si476x_core_set_rds_reception(struct si476x_core *core, int enable)
+{
+	int err;
+
+	if (enable) {
+		err = si476x_core_set_fm_rds_interrupt_fifo_count(core,
+							core->rds_fifo_depth);
+		if (err < 0) {
+			dev_err(&core->client->dev, "Failed to set RDS FIFO " \
+				"count\n");
+			goto exit;
+		}
+
+		err = si476x_core_set_rds_interrupt_source(core,
+							   SI476X_RDSRECV);
+		if (err < 0) {
+			dev_err(&core->client->dev,
+				"Failed to set RDS interrupt sources\n");
+			goto exit;
+		}
+
+		/* Drain RDS FIFO befor enabling RDS processing */
+		err = si476x_core_cmd_fm_rds_status(core, false,
+						    true, true, NULL);
+		if (err < 0) {
+			dev_err(&core->client->dev,
+				"Failed to drain RDS queue\n");
+			goto exit;
+		}
+
+		err = __set_rdsen(core, true);
+	} else {
+		err = __set_rdsen(core, false);
+	}
+
+exit:
+	return err;
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_rds_reception);
diff --git a/include/linux/mfd/si476x-core.h b/include/linux/mfd/si476x-core.h
new file mode 100644
index 0000000..e810bf6
--- /dev/null
+++ b/include/linux/mfd/si476x-core.h
@@ -0,0 +1,522 @@
+/*
+ * include/media/si476x-core.h -- Common definitions for si476x core
+ * device
+ *
+ * Copyright (C) 2012 Innovative Converged Devices(ICD)
+ *
+ * Author: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#ifndef SI476X_CORE_H
+#define SI476X_CORE_H
+
+#include <linux/kfifo.h>
+#include <linux/atomic.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/videodev2.h>
+
+#include <media/si476x.h>
+
+#ifdef DEBUG
+#define DBG_BUFFER(device, header, buffer, bcount)			\
+	do {								\
+		dev_info((device), header);				\
+		print_hex_dump_bytes("",				\
+				     DUMP_PREFIX_OFFSET,		\
+				     buffer, bcount);			\
+	} while (0)
+#else
+#define DBG_BUFFER(device, header, buffer, bcount)			\
+	do {} while (0)
+#endif
+
+
+enum si476x_mfd_cells {
+	SI476X_RADIO_CELL = 0,
+	SI476X_CODEC_CELL,
+	SI476X_MFD_CELLS,
+};
+
+
+/**
+ * enum si476x_power_state - possible power state of the si476x
+ * device.
+ *
+ * @SI476X_POWER_DOWN: In this state all regulators are turned off
+ * and the reset line is pulled low. The device is completely
+ * inactive.
+ * @SI476X_POWER_UP_FULL: In this state all the power regualtors are
+ * turned on, reset line pulled high, IRQ line is enabled(polling is
+ * active for polling use scenario) and device is turned on with
+ * POWER_UP command. The device is ready to be used.
+ * @SI476X_POWER_INCONSISTENT: This state indicates that previous
+ * power down was inconsisten meaning some of he regulators wer not
+ * turned down and thus the consequent use of the device, without
+ * power-cycling it is impossible.
+ */
+enum si476x_power_state {
+	SI476X_POWER_DOWN		= 0,
+	SI476X_POWER_UP_FULL		= 1,
+	SI476X_POWER_INCONSISTENT	= 2,
+};
+
+/**
+ * struct si476x_core - internal data structure representing the
+ * underlying "core" device which all the MFD cell-devices use.
+ *
+ * @client: Actual I2C client used to transfer commands to the chip.
+ * @chip_id: Last digit of the chip model(E.g. "1" for SI4761)
+ * @cells: MFD cell devices created by this driver.
+ * @cmd_lock: Mutex used to serialize all the requests to the core
+ * device. This filed should not be used directly. Instead
+ * si476x_core_lock()/si476x_core_unlock() should be used to get
+ * exclusive access to the "core" device.
+ * @users: Active users counter(Used by the radio cell)
+ * @rds_read_queue: Wait queue used to wait for RDS data.
+ * @rds_fifo: FIFO in which all the RDS data received from the chip is
+ * placed.
+ * @rds_fifo_drainer: Worker that drains on-chip RDS FIFO.
+ * @rds_drainer_is_working: Flag used for launching only one instance
+ * of the @rds_fifo_drainer.
+ * @rds_drainer_status_lock: Lock used to guard access to the
+ * @rds_drainer_is_working variable.
+ * @command: Wait queue for wainting on the command comapletion.
+ * @cts: Clear To Send flag set upon receiving first status with CTS
+ * set.
+ * @tuning: Wait queue used for wainting for tune/seek comand
+ * completion.
+ * @stc: Similar to @cts, but for the STC bit of the status value.
+ * @power_up_parameters: Parameters used as argument for POWER_UP
+ * command when the device is started.
+ * @state: Current power state of the device.
+ * @supplues: Structure containing handles to all power supplies used
+ * by the device (NULL ones are ignored).
+ * @gpio_reset: GPIO pin connectet to the RSTB pin of the chip.
+ * @pinmux: Chip's configurable pins configuration.
+ * @diversity_mode: Chips role when functioning in diversity mode.
+ * @status_monitor: Polling worker used in polling use case scenarion
+ * (when IRQ is not avalible).
+ * @revision: Chip's running firmware revision number(Used for correct
+ * command set support).
+ */
+
+struct si476x_core {
+	struct i2c_client *client;
+	int chip_id;
+	struct mfd_cell cells[SI476X_MFD_CELLS];
+
+	struct mutex cmd_lock; /* for serializing fm radio operations */
+	atomic_t users;
+
+	wait_queue_head_t  rds_read_queue;
+	struct kfifo       rds_fifo;
+	struct work_struct rds_fifo_drainer;
+	bool               rds_drainer_is_working;
+	struct mutex       rds_drainer_status_lock;
+
+
+	wait_queue_head_t command;
+	atomic_t          cts;
+
+	wait_queue_head_t tuning;
+	atomic_t          stc;
+
+	struct si476x_power_up_args power_up_parameters;
+
+	enum si476x_power_state power_state;
+
+	struct {
+		struct regulator *vio1;
+		struct regulator *vd;
+		struct regulator *va;
+		struct regulator *vio2;
+	} supplies;
+
+	int gpio_reset;
+
+	struct si476x_pinmux pinmux;
+	enum si476x_phase_diversity_mode diversity_mode;
+
+	atomic_t is_alive;
+
+	struct delayed_work status_monitor;
+#define SI476X_WORK_TO_CORE(w) container_of(to_delayed_work(w),	\
+					    struct si476x_core,	\
+					    status_monitor)
+
+	int revision;
+
+	int rds_fifo_depth;
+
+	struct {
+		atomic_t tune;
+		atomic_t power_up;
+		atomic_t command;
+	} timeouts;
+
+	atomic_t polling_interval;
+
+	struct kref kref;
+};
+
+static inline struct si476x_core *kref_to_si476x_core(struct kref *d)
+{
+	return container_of(d, struct si476x_core, kref);
+}
+
+
+/**
+ * si476x_core_lock() - lock the core device to get an exclusive acces
+ * to it.
+ */
+static inline void si476x_core_lock(struct si476x_core *core)
+{
+	mutex_lock(&core->cmd_lock);
+}
+
+/**
+ * si476x_core_unlock() - unlock the core device to relinquish an
+ * exclusive acces to it.
+ */
+static inline void si476x_core_unlock(struct si476x_core *core)
+{
+	mutex_unlock(&core->cmd_lock);
+}
+
+void si476x_core_get(struct si476x_core *core);
+void si476x_core_put(struct si476x_core *core);
+
+
+/* *_TUNE_FREQ family of commands accept frequency in multiples of
+    10kHz */
+static inline u16 hz_to_si476x(struct si476x_core *core, int freq)
+{
+	u16 result;
+
+	switch (core->power_up_parameters.func) {
+	default:
+	case SI476X_FUNC_FM_RECEIVER:
+		result = freq / 10000;
+		break;
+	case SI476X_FUNC_AM_RECEIVER:
+		result = freq / 1000;
+		break;
+	}
+
+	return result;
+}
+
+static inline int si476x_to_hz(struct si476x_core *core, u16 freq)
+{
+	int result;
+
+	switch (core->power_up_parameters.func) {
+	default:
+	case SI476X_FUNC_FM_RECEIVER:
+		result = freq * 10000;
+		break;
+	case SI476X_FUNC_AM_RECEIVER:
+		result = freq * 1000;
+		break;
+	}
+
+	return result;
+}
+
+/* Since the V4L2_TUNER_CAP_LOW flag is supplied, V4L2 subsystem
+ * mesures frequency in 62.5 Hz units */
+
+static inline int hz_to_v4l2(int freq)
+{
+	return (freq * 10) / 625;
+}
+
+static inline int v4l2_to_hz(int freq)
+{
+	return (freq * 625) / 10;
+}
+
+static inline u16 v4l2_to_si476x(struct si476x_core *core, int freq)
+{
+	return hz_to_si476x(core, v4l2_to_hz(freq));
+}
+
+static inline int si476x_to_v4l2(struct si476x_core *core, u16 freq)
+{
+	return hz_to_v4l2(si476x_to_hz(core, freq));
+}
+
+
+
+/**
+ * struct si476x_func_info - structure containing result of the
+ * FUNC_INFO command.
+ *
+ * @firmware.major: Firmare major number.
+ * @firmware.minor[...]: Firmare minor numbers.
+ * @patch_id:
+ * @func: Mode tuner is working in.
+ */
+struct si476x_func_info {
+	struct {
+		u8 major, minor[2];
+	} firmware;
+	u16 patch_id;
+	enum si476x_func func;
+};
+
+/**
+ * struct si476x_power_down_args - structure used to pass parameters
+ * to POWER_DOWN command
+ *
+ * @xosc: true - Power down, but leav oscillator running.
+ *        false - Full power down.
+ */
+struct si476x_power_down_args {
+	bool xosc;
+};
+
+/**
+ * enum si476x_tunemode - enum representing possible tune modes for
+ * the chip.
+ * @SI476X_TM_VALIDATED_NORMAL_TUNE: Unconditionally stay on the new
+ * channel after tune, tune status is valid.
+ * @SI476X_TM_INVALIDATED_FAST_TUNE: Unconditionally stay in the new
+ * channel after tune, tune status invalid.
+ * @SI476X_TM_VALIDATED_AF_TUNE: Jump back to previous channel if
+ * metric thresholds are not met.
+ * @SI476X_TM_VALIDATED_AF_CHECK: Unconditionally jump back to the
+ * previous channel.
+ */
+enum si476x_tunemode {
+	SI476X_TM_VALIDATED_NORMAL_TUNE = 0,
+	SI476X_TM_INVALIDATED_FAST_TUNE = 1,
+	SI476X_TM_VALIDATED_AF_TUNE     = 2,
+	SI476X_TM_VALIDATED_AF_CHECK    = 3,
+};
+
+/**
+ * enum si476x_smoothmetrics - enum containing the possible setting fo
+ * audio transitioning of the chip
+ * @SI476X_SM_INITIALIZE_AUDIO: Initialize audio state to match this
+ * new channel
+ * @SI476X_SM_TRANSITION_AUDIO: Transition audio state from previous
+ * channel values to the new values
+ */
+enum si476x_smoothmetrics {
+	SI476X_SM_INITIALIZE_AUDIO = 0,
+	SI476X_SM_TRANSITION_AUDIO = 1,
+};
+
+/**
+ * struct si476x_rds_status_report - the structure representing the
+ * response to 'FM_RD_STATUS' command
+ * @rdstpptyint: Traffic program flag(TP) and/or program type(PTY)
+ * code has changed.
+ * @rdspiint: Program indentifiaction(PI) code has changed.
+ * @rdssyncint: RDS synchronization has changed.
+ * @rdsfifoint: RDS was received and the RDS FIFO has at least
+ * 'FM_RDS_INTERRUPT_FIFO_COUNT' elements in it.
+ * @tpptyvalid: TP flag and PTY code are valid falg.
+ * @pivalid: PI code is valid flag.
+ * @rdssync: RDS is currently synchronized.
+ * @rdsfifolost: On or more RDS groups have been lost/discarded flag.
+ * @tp: Current channel's TP flag.
+ * @pty: Current channel's PTY code.
+ * @pi: Current channel's PI code.
+ * @rdsfifoused: Number of blocks remaining in the RDS FIFO (0 if
+ * empty).
+ */
+struct si476x_rds_status_report {
+	bool rdstpptyint, rdspiint, rdssyncint, rdsfifoint;
+	bool tpptyvalid, pivalid, rdssync, rdsfifolost;
+	bool tp;
+
+	u8 pty;
+	u16 pi;
+
+	u8 rdsfifoused;
+	u8 ble[4];
+
+	struct v4l2_rds_data rds[4];
+};
+
+struct si476x_rsq_status_args {
+	bool primary;
+	bool rsqack;
+	bool attune;
+	bool cancel;
+	bool stcack;
+};
+
+enum si476x_injside {
+	SI476X_INJSIDE_AUTO	= 0,
+	SI476X_INJSIDE_LOW	= 1,
+	SI476X_INJSIDE_HIGH	= 2,
+};
+
+struct si476x_tune_freq_args {
+	bool zifsr;
+	bool hd;
+	enum si476x_injside injside;
+	int freq;
+	enum si476x_tunemode tunemode;
+	enum si476x_smoothmetrics smoothmetrics;
+	int antcap;
+};
+
+int si476x_core_stop(struct si476x_core *, bool);
+int si476x_core_start(struct si476x_core *, bool);
+int si476x_core_set_power_state(struct si476x_core *, enum si476x_power_state);
+int si476x_core_cmd_func_info(struct si476x_core *, struct si476x_func_info *);
+int si476x_core_cmd_set_property(struct si476x_core *, u16, u16);
+int si476x_core_cmd_get_property(struct si476x_core *, u16);
+int si476x_core_cmd_dig_audio_pin_cfg(struct si476x_core *,
+				      enum si476x_dclk_config,
+				      enum si476x_dfs_config,
+				      enum si476x_dout_config,
+				      enum si476x_xout_config);
+int si476x_core_cmd_zif_pin_cfg(struct si476x_core *,
+				enum si476x_iqclk_config,
+				enum si476x_iqfs_config,
+				enum si476x_iout_config,
+				enum si476x_qout_config);
+int si476x_core_cmd_ic_link_gpo_ctl_pin_cfg(struct si476x_core *,
+					    enum si476x_icin_config,
+					    enum si476x_icip_config,
+					    enum si476x_icon_config,
+					    enum si476x_icop_config);
+int si476x_core_cmd_ana_audio_pin_cfg(struct si476x_core *,
+				      enum si476x_lrout_config);
+int si476x_core_cmd_intb_pin_cfg(struct si476x_core *, enum si476x_intb_config,
+				 enum si476x_a1_config);
+int si476x_core_cmd_fm_seek_start(struct si476x_core *, bool, bool);
+int si476x_core_cmd_am_seek_start(struct si476x_core *, bool, bool);
+int si476x_core_cmd_fm_rds_status(struct si476x_core *, bool, bool, bool,
+				  struct si476x_rds_status_report *);
+int si476x_core_cmd_fm_rds_blockcount(struct si476x_core *, bool,
+				      struct si476x_rds_blockcount_report *);
+int si476x_core_cmd_fm_tune_freq(struct si476x_core *,
+				 struct si476x_tune_freq_args *);
+int si476x_core_cmd_am_tune_freq(struct si476x_core *,
+				 struct si476x_tune_freq_args *);
+int si476x_core_cmd_am_rsq_status(struct si476x_core *,
+				  struct si476x_rsq_status_args *,
+				  struct si476x_rsq_status_report *);
+int si476x_core_cmd_fm_rsq_status(struct si476x_core *,
+				  struct si476x_rsq_status_args *,
+				  struct si476x_rsq_status_report *);
+int si476x_core_cmd_power_up(struct si476x_core *,
+			     struct si476x_power_up_args *);
+int si476x_core_cmd_power_down(struct si476x_core *,
+			       struct si476x_power_down_args *);
+int si476x_core_cmd_fm_phase_div_status(struct si476x_core *);
+int si476x_core_cmd_fm_phase_diversity(struct si476x_core *,
+				       enum si476x_phase_diversity_mode);
+
+int si476x_core_cmd_fm_acf_status(struct si476x_core *,
+				  struct si476x_acf_status_report *);
+int si476x_core_cmd_am_acf_status(struct si476x_core *,
+				  struct si476x_acf_status_report *);
+int si476x_core_cmd_agc_status(struct si476x_core *,
+			       struct si476x_agc_status_report *);
+
+enum si476x_power_grid_type {
+	SI476X_POWER_GRID_50HZ = 0,
+	SI476X_POWER_GRID_60HZ,
+};
+
+/* Properties  */
+
+enum si476x_interrupt_flags {
+	SI476X_STCIEN = (1 << 0),
+	SI476X_ACFIEN = (1 << 1),
+	SI476X_RDSIEN = (1 << 2),
+	SI476X_RSQIEN = (1 << 3),
+
+	SI476X_ERRIEN = (1 << 6),
+	SI476X_CTSIEN = (1 << 7),
+
+	SI476X_STCREP = (1 << 8),
+	SI476X_ACFREP = (1 << 9),
+	SI476X_RDSREP = (1 << 10),
+	SI476X_RSQREP = (1 << 11),
+};
+
+enum si476x_rdsint_sources {
+	SI476X_RDSTPPTY = (1 << 4),
+	SI476X_RDSPI    = (1 << 3),
+	SI476X_RDSSYNC	= (1 << 1),
+	SI476X_RDSRECV	= (1 << 0),
+};
+
+enum si476x_status_response_bits {
+	SI476X_CTS	  = (1 << 7),
+	SI476X_ERR	  = (1 << 6),
+	/* Status response for WB receiver */
+	SI476X_WB_ASQ_INT = (1 << 4),
+	SI476X_RSQ_INT    = (1 << 3),
+	/* Status response for FM receiver */
+	SI476X_FM_RDS_INT = (1 << 2),
+	SI476X_ACF_INT    = (1 << 1),
+	SI476X_STC_INT    = (1 << 0),
+};
+
+bool si476x_core_is_valid_property(struct si476x_core *, u16);
+bool si476x_core_is_readonly_property(struct si476x_core *, u16);
+int si476x_core_set_int_ctl_enable(struct si476x_core *,
+				   enum si476x_interrupt_flags);
+
+int si476x_core_set_frequency_spacing(struct si476x_core *, int);
+int si476x_core_set_seek_band_top(struct si476x_core *, int);
+int si476x_core_set_seek_band_bottom(struct si476x_core *, int);
+int si476x_core_set_audio_deemphasis(struct si476x_core *, int);
+int si476x_core_set_rds_reception(struct si476x_core *, int);
+int si476x_core_set_audio_pwr_line_filter(struct si476x_core *, bool,
+					  enum si476x_power_grid_type, int);
+
+int si476x_core_set_valid_snr_threshold(struct si476x_core *, int);
+int si476x_core_set_valid_rssi_threshold(struct si476x_core *, int);
+int si476x_core_set_valid_max_tune_error(struct si476x_core *, int);
+
+int si476x_core_get_frequency_spacing(struct si476x_core *);
+int si476x_core_get_seek_band_top(struct si476x_core *);
+int si476x_core_get_seek_band_bottom(struct si476x_core *);
+int si476x_core_get_audio_deemphasis(struct si476x_core *);
+int si476x_core_get_rds_reception(struct si476x_core *);
+int si476x_core_get_audio_pwr_line_filter(struct si476x_core *);
+
+int si476x_core_get_valid_snr_threshold(struct si476x_core *);
+int si476x_core_get_valid_rssi_threshold(struct si476x_core *);
+int si476x_core_get_valid_max_tune_error(struct si476x_core *);
+
+int si476x_core_set_fm_rds_interrupt_fifo_count(struct si476x_core *, int);
+int si476x_core_set_rds_interrupt_source(struct si476x_core *,
+					 enum si476x_rdsint_sources);
+int si476x_core_set_digital_io_input_sample_rate(struct si476x_core *, u16);
+int si476x_core_disable_digital_audio(struct si476x_core *);
+
+typedef int (*tune_freq_func_t) (struct si476x_core *,
+				 struct si476x_tune_freq_args *);
+
+enum si476x_i2c_type {
+	SI476X_I2C_SEND,
+	SI476X_I2C_RECV
+};
+
+int si476x_i2c_xfer(struct si476x_core *,
+		    enum si476x_i2c_type,
+		    char *, int);
+#endif	/* SI476X_CORE_H */
diff --git a/include/media/si476x.h b/include/media/si476x.h
new file mode 100644
index 0000000..5595f25
--- /dev/null
+++ b/include/media/si476x.h
@@ -0,0 +1,455 @@
+/*
+ * include/media/si476x.h -- Common definitions for si476x driver
+ *
+ * Copyright (C) 2012 Innovative Converged Devices(ICD)
+ *
+ * Author: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#ifndef SI476X_H
+#define SI476X_H
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+struct si476x_device;
+
+/* It is possible to select one of the four adresses using pins A0
+ * and A1 on SI476x */
+#define SI476X_I2C_ADDR_1	0x60
+#define SI476X_I2C_ADDR_2	0x61
+#define SI476X_I2C_ADDR_3	0x62
+#define SI476X_I2C_ADDR_4	0x63
+
+enum si476x_iqclk_config {
+	SI476X_IQCLK_NOOP = 0,
+	SI476X_IQCLK_TRISTATE = 1,
+	SI476X_IQCLK_IQ = 21,
+};
+enum si476x_iqfs_config {
+	SI476X_IQFS_NOOP = 0,
+	SI476X_IQFS_TRISTATE = 1,
+	SI476X_IQFS_IQ = 21,
+};
+enum si476x_iout_config {
+	SI476X_IOUT_NOOP = 0,
+	SI476X_IOUT_TRISTATE = 1,
+	SI476X_IOUT_OUTPUT = 22,
+};
+enum si476x_qout_config {
+	SI476X_QOUT_NOOP = 0,
+	SI476X_QOUT_TRISTATE = 1,
+	SI476X_QOUT_OUTPUT = 22,
+};
+
+enum si476x_dclk_config {
+	SI476X_DCLK_NOOP      = 0,
+	SI476X_DCLK_TRISTATE  = 1,
+	SI476X_DCLK_DAUDIO    = 10,
+};
+
+enum si476x_dfs_config {
+	SI476X_DFS_NOOP      = 0,
+	SI476X_DFS_TRISTATE  = 1,
+	SI476X_DFS_DAUDIO    = 10,
+};
+
+enum si476x_dout_config {
+	SI476X_DOUT_NOOP       = 0,
+	SI476X_DOUT_TRISTATE   = 1,
+	SI476X_DOUT_I2S_OUTPUT = 12,
+	SI476X_DOUT_I2S_INPUT  = 13,
+};
+
+enum si476x_xout_config {
+	SI476X_XOUT_NOOP        = 0,
+	SI476X_XOUT_TRISTATE    = 1,
+	SI476X_XOUT_I2S_INPUT   = 13,
+	SI476X_XOUT_MODE_SELECT = 23,
+};
+
+
+enum si476x_icin_config {
+	SI476X_ICIN_NOOP	= 0,
+	SI476X_ICIN_TRISTATE	= 1,
+	SI476X_ICIN_GPO1_HIGH	= 2,
+	SI476X_ICIN_GPO1_LOW	= 3,
+	SI476X_ICIN_IC_LINK	= 30,
+};
+
+enum si476x_icip_config {
+	SI476X_ICIP_NOOP	= 0,
+	SI476X_ICIP_TRISTATE	= 1,
+	SI476X_ICIP_GPO2_HIGH	= 2,
+	SI476X_ICIP_GPO2_LOW	= 3,
+	SI476X_ICIP_IC_LINK	= 30,
+};
+
+enum si476x_icon_config {
+	SI476X_ICON_NOOP	= 0,
+	SI476X_ICON_TRISTATE	= 1,
+	SI476X_ICON_I2S		= 10,
+	SI476X_ICON_IC_LINK	= 30,
+};
+
+enum si476x_icop_config {
+	SI476X_ICOP_NOOP	= 0,
+	SI476X_ICOP_TRISTATE	= 1,
+	SI476X_ICOP_I2S		= 10,
+	SI476X_ICOP_IC_LINK	= 30,
+};
+
+
+enum si476x_lrout_config {
+	SI476X_LROUT_NOOP	= 0,
+	SI476X_LROUT_TRISTATE	= 1,
+	SI476X_LROUT_AUDIO	= 2,
+	SI476X_LROUT_MPX	= 3,
+};
+
+
+enum si476x_intb_config {
+	SI476X_INTB_NOOP     = 0,
+	SI476X_INTB_TRISTATE = 1,
+	SI476X_INTB_DAUDIO   = 10,
+	SI476X_INTB_IRQ      = 40,
+};
+
+enum si476x_a1_config {
+	SI476X_A1_NOOP     = 0,
+	SI476X_A1_TRISTATE = 1,
+	SI476X_A1_IRQ      = 40,
+};
+
+enum si476x_part_revisions {
+	SI476X_REVISION_A10 = 0,
+	SI476X_REVISION_A20 = 1,
+	SI476X_REVISION_A30 = 2,
+};
+
+struct si476x_pinmux {
+	enum si476x_dclk_config  dclk;
+	enum si476x_dfs_config   dfs;
+	enum si476x_dout_config  dout;
+	enum si476x_xout_config  xout;
+
+	enum si476x_iqclk_config iqclk;
+	enum si476x_iqfs_config  iqfs;
+	enum si476x_iout_config  iout;
+	enum si476x_qout_config  qout;
+
+	enum si476x_icin_config  icin;
+	enum si476x_icip_config  icip;
+	enum si476x_icon_config  icon;
+	enum si476x_icop_config  icop;
+
+	enum si476x_lrout_config lrout;
+
+	enum si476x_intb_config  intb;
+	enum si476x_a1_config    a1;
+};
+
+/**
+ * enum si476x_phase_diversity_mode - possbile phase diversity modes
+ * for SI4764/5/6/7 chips.
+ *
+ * @SI476X_PHDIV_DISABLED:		Phase diversity feature is
+ *					disabled.
+ * @SI476X_PHDIV_PRIMARY_COMBINING:	Tuner works as a primary tuner
+ *					in combination with a
+ *					secondary one.
+ * @SI476X_PHDIV_PRIMARY_ANTENNA:	Tuner works as a primary tuner
+ *					using only its own antenna.
+ * @SI476X_PHDIV_SECONDARY_ANTENNA:	Tuner works as a primary tuner
+ *					usning seconary tuner's antenna.
+ * @SI476X_PHDIV_SECONDARY_COMBINING:	Tuner works as a secondary
+ *					tuner in combination with the
+ *					primary one.
+ */
+enum si476x_phase_diversity_mode {
+	SI476X_PHDIV_DISABLED			= 0,
+	SI476X_PHDIV_PRIMARY_COMBINING		= 1,
+	SI476X_PHDIV_PRIMARY_ANTENNA		= 2,
+	SI476X_PHDIV_SECONDARY_ANTENNA		= 3,
+	SI476X_PHDIV_SECONDARY_COMBINING	= 5,
+};
+
+
+enum si476x_ibias6x {
+	SI476X_IBIAS6X_OTHER			= 0,
+	SI476X_IBIAS6X_RCVR1_NON_4MHZ_CLK	= 1,
+};
+
+enum si476x_xstart {
+	SI476X_XSTART_MULTIPLE_TUNER	= 0x11,
+	SI476X_XSTART_NORMAL		= 0x77,
+};
+
+enum si476x_freq {
+	SI476X_FREQ_4_MHZ		= 0,
+	SI476X_FREQ_37P209375_MHZ	= 1,
+	SI476X_FREQ_36P4_MHZ		= 2,
+	SI476X_FREQ_37P8_MHZ		=  3,
+};
+
+enum si476x_xmode {
+	SI476X_XMODE_CRYSTAL_RCVR1	= 1,
+	SI476X_XMODE_EXT_CLOCK		= 2,
+	SI476X_XMODE_CRYSTAL_RCVR2_3	= 3,
+};
+
+enum si476x_xbiashc {
+	SI476X_XBIASHC_SINGLE_RECEIVER = 0,
+	SI476X_XBIASHC_MULTIPLE_RECEIVER = 1,
+};
+
+enum si476x_xbias {
+	SI476X_XBIAS_RCVR2_3	= 0,
+	SI476X_XBIAS_4MHZ_RCVR1 = 3,
+	SI476X_XBIAS_RCVR1	= 7,
+};
+
+enum si476x_func {
+	SI476X_FUNC_BOOTLOADER	= 0,
+	SI476X_FUNC_FM_RECEIVER = 1,
+	SI476X_FUNC_AM_RECEIVER = 2,
+	SI476X_FUNC_WB_RECEIVER = 3,
+};
+
+
+/**
+ * @xcload: Selects the amount of additional on-chip capacitance to
+ *          be connected between XTAL1 and gnd and between XTAL2 and
+ *          GND. One half of the capacitance value shown here is the
+ *          additional load capacitance presented to the xtal. The
+ *          minimum step size is 0.277 pF. Recommended value is 0x28
+ *          but it will be layout dependent. Range is 0–0x3F i.e.
+ *          (0–16.33 pF)
+ * @ctsien: enable CTSINT(interrupt request when CTS condition
+ *          arises) when set
+ * @intsel: when set A1 pin becomes the interrupt pin; otherwise,
+ *          INTB is the interrupt pin
+ * @func:   selects the boot function of the device. I.e.
+ *          SI476X_BOOTLOADER  - Boot loader
+ *          SI476X_FM_RECEIVER - FM receiver
+ *          SI476X_AM_RECEIVER - AM receiver
+ *          SI476X_WB_RECEIVER - Weatherband receiver
+ * @freq:   oscillator's crystal frequency:
+ *          SI476X_XTAL_37P209375_MHZ - 37.209375 Mhz
+ *          SI476X_XTAL_36P4_MHZ      - 36.4 Mhz
+ *          SI476X_XTAL_37P8_MHZ      - 37.8 Mhz
+ */
+struct si476x_power_up_args {
+	enum si476x_ibias6x ibias6x;
+	enum si476x_xstart  xstart;
+	u8   xcload;
+	bool fastboot;
+	enum si476x_xbiashc xbiashc;
+	enum si476x_xbias   xbias;
+	enum si476x_func    func;
+	enum si476x_freq    freq;
+	enum si476x_xmode   xmode;
+};
+
+
+enum si476x_ctrl_id {
+	SI476X_CID_RSSI_THRESHOLD = V4L2_CID_PRIVATE_BASE,
+	SI476X_CID_SNR_THRESHOLD,
+	SI476X_CID_MAX_TUNE_ERROR,
+	SI476X_CID_SEEK_SPACING,
+	SI476X_CID_SEEK_BAND_TOP,
+	SI476X_CID_SEEK_BAND_BOTTOM,
+	SI476X_CID_RDS_RECEPTION,
+	SI476X_CID_DEEMPHASIS,
+
+	SI476X_CID_HARMONICS_COUNT,
+	SI476X_CID_GRID_FREQUENCY,
+};
+
+/*
+ * Platform dependent definition
+ */
+struct si476x_platform_data {
+	int gpio_reset; /* < 0 if not used */
+
+	struct si476x_power_up_args power_up_parameters;
+	enum si476x_phase_diversity_mode diversity_mode;
+
+	struct si476x_pinmux pinmux;
+};
+
+/**
+ * struct si476x_rsq_status - structure containing received signal
+ * quality
+ * @multhint:   Multipath Detect High.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_MULTIPATH_HIGH_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_MULTIPATH_HIGH_THRESHOLD
+ * @multlint:   Multipath Detect Low.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_MULTIPATH_LOW_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_MULTIPATH_LOW_THRESHOLD
+ * @snrhint:    SNR Detect High.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_SNR_HIGH_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_SNR_HIGH_THRESHOLD
+ * @snrlint:    SNR Detect Low.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_SNR_LOW_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_SNR_LOW_THRESHOLD
+ * @rssihint:   RSSI Detect High.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_RSSI_HIGH_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_RSSI_HIGH_THRESHOLD
+ * @rssilint:   RSSI Detect Low.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_RSSI_LOW_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_RSSI_LOW_THRESHOLD
+ * @bltf:       Band Limit.
+ *              Set if seek command hits the band limit or wrapped to
+ *              the original frequency.
+ * @snr_ready:  SNR measurement in progress.
+ * @rssiready:  RSSI measurement in progress.
+ * @afcrl:      Set if FREQOFF >= MAX_TUNE_ERROR
+ * @valid:      Set if the channel is valid
+ *               rssi < FM_VALID_RSSI_THRESHOLD
+ *               snr  < FM_VALID_SNR_THRESHOLD
+ *               tune_error < FM_VALID_MAX_TUNE_ERROR
+ * @readfreq:   Current tuned frequency.
+ * @freqoff:    Signed frequency offset.
+ * @rssi:       Received Signal Strength Indicator(dBuV).
+ * @snr:        RF SNR Indicator(dB).
+ * @lassi:
+ * @hassi:      Low/High side Adjacent(100 kHz) Channel Strength Indicator
+ * @mult:       Multipath indicator
+ * @dev:        Who knows? But values may vary.
+ * @readantcap: Antenna tuning capacity value.
+ * @assi:       Adjacent Channel(+/- 200kHz) Strength Indicator
+ * @usn:        Ultrasonic Noise Inticator in -DBFS
+ */
+struct si476x_rsq_status_report {
+	__u8 multhint, multlint;
+	__u8 snrhint,  snrlint;
+	__u8 rssihint, rssilint;
+	__u8 bltf;
+	__u8 snr_ready;
+	__u8 rssiready;
+	__u8 injside;
+	__u8 afcrl;
+	__u8 valid;
+
+	__u16 readfreq;
+	__s8  freqoff;
+	__s8  rssi;
+	__s8  snr;
+	__s8  issi;
+	__s8  lassi, hassi;
+	__s8  mult;
+	__u8  dev;
+	__u16 readantcap;
+	__s8  assi;
+	__s8  usn;
+
+	__u8 pilotdev;
+	__u8 rdsdev;
+	__u8 assidev;
+	__u8 strongdev;
+	__u16 rdspi;
+};
+
+/**
+ * si476x_acf_status_report - ACF report results
+ *
+ * @blend_int: If set, indicates that stereo separation has crossed
+ * below the blend threshold as set by FM_ACF_BLEND_THRESHOLD
+ * @hblend_int: If set, indicates that HiBlend cutoff frequency is
+ * lower than threshold as set by FM_ACF_HBLEND_THRESHOLD
+ * @hicut_int:  If set, indicates that HiCut cutoff frequency is lower
+ * than the threshold set by ACF_
+
+ */
+struct si476x_acf_status_report {
+	__u8 blend_int;
+	__u8 hblend_int;
+	__u8 hicut_int;
+	__u8 chbw_int;
+	__u8 softmute_int;
+	__u8 smute;
+	__u8 smattn;
+	__u8 chbw;
+	__u8 hicut;
+	__u8 hiblend;
+	__u8 pilot;
+	__u8 stblend;
+};
+
+enum si476x_fmagc {
+	SI476X_FMAGC_10K_OHM	= 0,
+	SI476X_FMAGC_800_OHM	= 1,
+	SI476X_FMAGC_400_OHM	= 2,
+	SI476X_FMAGC_200_OHM	= 4,
+	SI476X_FMAGC_100_OHM	= 8,
+	SI476X_FMAGC_50_OHM	= 16,
+	SI476X_FMAGC_25_OHM	= 32,
+	SI476X_FMAGC_12P5_OHM	= 64,
+	SI476X_FMAGC_6P25_OHM	= 128,
+};
+
+struct si476x_agc_status_report {
+	__u8 mxhi;
+	__u8 mxlo;
+	__u8 lnahi;
+	__u8 lnalo;
+	__u8 fmagc1;
+	__u8 fmagc2;
+	__u8 pgagain;
+	__u8 fmwblang;
+};
+
+struct si476x_rds_blockcount_report {
+	__u16 expected;
+	__u16 received;
+	__u16 uncorrectable;
+};
+
+#define SI476X_PHDIV_STATUS_LINK_LOCKED(status) (0b10000000 & (status))
+#define SI476X_PHDIV_STATS_MODE(status) (0b111 & (status))
+
+#define SI476X_IOC_GET_RSQ		_IOWR('V', BASE_VIDIOC_PRIVATE + 0, \
+					      struct si476x_rsq_status_report)
+
+#define SI476X_IOC_SET_PHDIV_MODE	_IOW('V', BASE_VIDIOC_PRIVATE + 1, \
+					     enum si476x_phase_diversity_mode)
+
+#define SI476X_IOC_GET_PHDIV_STATUS	_IOWR('V', BASE_VIDIOC_PRIVATE + 2, \
+					      int)
+
+#define SI476X_IOC_GET_RSQ_PRIMARY	_IOWR('V', BASE_VIDIOC_PRIVATE + 3, \
+					      struct si476x_rsq_status_report)
+
+#define SI476X_IOC_GET_ACF		_IOWR('V', BASE_VIDIOC_PRIVATE + 4, \
+					      struct si476x_acf_status_report)
+
+#define SI476X_IOC_GET_AGC		_IOWR('V', BASE_VIDIOC_PRIVATE + 5, \
+					      struct si476x_agc_status_report)
+
+#define SI476X_IOC_GET_RDS_BLKCNT	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, \
+					    struct si476x_rds_blockcount_report)
+
+#endif /* SI476X_H*/
-- 
1.7.9.5

