Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2INGoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:44:14 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2371 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2INGoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:44:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Subject: Re: [PATCH 1/3] Add a core driver for SI476x MFD
Date: Fri, 14 Sep 2012 08:44:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc3-tschai; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net> <1347576013-28832-2-git-send-email-andrey.smirnov@convergeddevices.net>
In-Reply-To: <1347576013-28832-2-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209140844.01978.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey!

Thanks for posting this driver. One request for the future: please split this
patch up in smaller pieces: one for each c source for example. That makes it
easier to review.

On Fri September 14 2012 00:40:11 Andrey Smirnov wrote:
> This patch adds a core driver for Silicon Laboratories Si476x series
> of AM/FM tuner chips. The driver as a whole is implemented as an MFD device
> and this patch adds a core portion of it that provides all the necessary
> functionality to the two other drivers that represent radio and audio
> codec subsystems of the chip.
> 
> Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
> ---
>  drivers/mfd/Kconfig             |   14 +
>  drivers/mfd/Makefile            |    3 +
>  drivers/mfd/si476x-cmd.c        | 1509 +++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/si476x-i2c.c        | 1033 +++++++++++++++++++++++++++
>  drivers/mfd/si476x-prop.c       |  477 +++++++++++++
>  include/linux/mfd/si476x-core.h |  522 ++++++++++++++
>  include/media/si476x.h          |  455 ++++++++++++
>  7 files changed, 4013 insertions(+)
>  create mode 100644 drivers/mfd/si476x-cmd.c
>  create mode 100644 drivers/mfd/si476x-i2c.c
>  create mode 100644 drivers/mfd/si476x-prop.c
>  create mode 100644 include/linux/mfd/si476x-core.h
>  create mode 100644 include/media/si476x.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index b1a1462..3fab06d 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -895,6 +895,20 @@ config MFD_WL1273_CORE
>  	  driver connects the radio-wl1273 V4L2 module and the wl1273
>  	  audio codec.
>  
> +config MFD_SI476X_CORE
> +	tristate "Support for Silicon Laboratories 4761/64/68 AM/FM radio."
> +	depends on I2C
> +	select MFD_CORE
> +	default n
> +	help
> +	  This is the core driver for the SI476x series of AM/FM radio. This MFD
> +	  driver connects the radio-si476x V4L2 module and the si476x
> +	  audio codec.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called si476x-core.
> +
> +
>  config MFD_OMAP_USB_HOST
>  	bool "Support OMAP USBHS core driver"
>  	depends on USB_EHCI_HCD_OMAP || USB_OHCI_HCD_OMAP3
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 79dd22d..942257b 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -132,3 +132,6 @@ obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
>  obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
>  obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
>  obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
> +
> +si476x-core-objs := si476x-cmd.o si476x-prop.o si476x-i2c.o
> +obj-$(CONFIG_MFD_SI476X_CORE)	+= si476x-core.o
> diff --git a/drivers/mfd/si476x-cmd.c b/drivers/mfd/si476x-cmd.c
> new file mode 100644
> index 0000000..defe1f5
> --- /dev/null
> +++ b/drivers/mfd/si476x-cmd.c
> @@ -0,0 +1,1509 @@
> +/*
> + * include/media/si476x-cmd.c -- Subroutines implementing command
> + * protocol of si476x series of chips
> + *
> + * Copyright (C) 2012 Innovative Converged Devices(ICD)
> + *
> + * Author: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + */
> +#include <linux/module.h>
> +#include <linux/completion.h>
> +#include <linux/delay.h>
> +#include <linux/atomic.h>
> +#include <linux/i2c.h>
> +#include <linux/device.h>
> +#include <linux/gpio.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/si476x.h>
> +#include <linux/mfd/si476x-core.h>
> +
> +#define msb(x)                  ((u8)((u16) x >> 8))
> +#define lsb(x)                  ((u8)((u16) x &  0x00FF))
> +
> +
> +
> +#define CMD_POWER_UP				0x01
> +#define CMD_POWER_UP_A10_NRESP			1
> +#define CMD_POWER_UP_A10_NARGS			5
> +
> +#define CMD_POWER_UP_A20_NRESP			1
> +#define CMD_POWER_UP_A20_NARGS			5
> +
> +#define POWER_UP_DELAY_MS			110
> +
> +#define CMD_POWER_DOWN				0x11
> +#define CMD_POWER_DOWN_A10_NRESP		1
> +
> +#define CMD_POWER_DOWN_A20_NRESP		1
> +#define CMD_POWER_DOWN_A20_NARGS		1
> +
> +#define CMD_FUNC_INFO				0x12
> +#define CMD_FUNC_INFO_NRESP			7
> +
> +#define CMD_SET_PROPERTY			0x13
> +#define CMD_SET_PROPERTY_NARGS			5
> +#define CMD_SET_PROPERTY_NRESP			1
> +
> +#define CMD_GET_PROPERTY			0x14
> +#define CMD_GET_PROPERTY_NARGS			3
> +#define CMD_GET_PROPERTY_NRESP			4
> +
> +#define CMD_AGC_STATUS				0x17
> +#define CMD_AGC_STATUS_NRESP_A10		2
> +#define CMD_AGC_STATUS_NRESP_A20                6
> +
> +#define PIN_CFG_BYTE(x) (0x7F & (x))
> +#define CMD_DIG_AUDIO_PIN_CFG			0x18
> +#define CMD_DIG_AUDIO_PIN_CFG_NARGS		4
> +#define CMD_DIG_AUDIO_PIN_CFG_NRESP		5
> +
> +#define CMD_ZIF_PIN_CFG				0x19
> +#define CMD_ZIF_PIN_CFG_NARGS			4
> +#define CMD_ZIF_PIN_CFG_NRESP			5
> +
> +#define CMD_IC_LINK_GPO_CTL_PIN_CFG		0x1A
> +#define CMD_IC_LINK_GPO_CTL_PIN_CFG_NARGS	4
> +#define CMD_IC_LINK_GPO_CTL_PIN_CFG_NRESP	5
> +
> +#define CMD_ANA_AUDIO_PIN_CFG			0x1B
> +#define CMD_ANA_AUDIO_PIN_CFG_NARGS		1
> +#define CMD_ANA_AUDIO_PIN_CFG_NRESP		2
> +
> +#define CMD_INTB_PIN_CFG			0x1C
> +#define CMD_INTB_PIN_CFG_NARGS			2
> +#define CMD_INTB_PIN_CFG_A10_NRESP		6
> +#define CMD_INTB_PIN_CFG_A20_NRESP		3
> +
> +#define CMD_FM_TUNE_FREQ			0x30
> +#define CMD_FM_TUNE_FREQ_A10_NARGS		5
> +#define CMD_FM_TUNE_FREQ_A20_NARGS		3
> +#define CMD_FM_TUNE_FREQ_NRESP			1
> +
> +#define CMD_FM_RSQ_STATUS			0x32
> +
> +#define CMD_FM_RSQ_STATUS_A10_NARGS		1
> +#define CMD_FM_RSQ_STATUS_A10_NRESP		17
> +#define CMD_FM_RSQ_STATUS_A30_NARGS		1
> +#define CMD_FM_RSQ_STATUS_A30_NRESP		23
> +
> +
> +#define CMD_FM_SEEK_START			0x31
> +#define CMD_FM_SEEK_START_NARGS			1
> +#define CMD_FM_SEEK_START_NRESP			1
> +
> +#define CMD_FM_RDS_STATUS			0x36
> +#define CMD_FM_RDS_STATUS_NARGS			1
> +#define CMD_FM_RDS_STATUS_NRESP			16
> +
> +#define CMD_FM_RDS_BLOCKCOUNT			0x37
> +#define CMD_FM_RDS_BLOCKCOUNT_NARGS		1
> +#define CMD_FM_RDS_BLOCKCOUNT_NRESP		8
> +
> +#define CMD_FM_PHASE_DIVERSITY			0x38
> +#define CMD_FM_PHASE_DIVERSITY_NARGS		1
> +#define CMD_FM_PHASE_DIVERSITY_NRESP		1
> +
> +#define CMD_FM_PHASE_DIV_STATUS			0x39
> +#define CMD_FM_PHASE_DIV_STATUS_NRESP		2
> +
> +#define CMD_AM_TUNE_FREQ			0x40
> +#define CMD_AM_TUNE_FREQ_NARGS			3
> +#define CMD_AM_TUNE_FREQ_NRESP			1
> +
> +#define CMD_AM_RSQ_STATUS			0x42
> +#define CMD_AM_RSQ_STATUS_NARGS			1
> +#define CMD_AM_RSQ_STATUS_NRESP			13
> +
> +#define CMD_AM_SEEK_START			0x41
> +#define CMD_AM_SEEK_START_NARGS			1
> +#define CMD_AM_SEEK_START_NRESP			1
> +
> +
> +#define CMD_AM_ACF_STATUS			0x45
> +#define CMD_AM_ACF_STATUS_NRESP			6
> +#define CMD_AM_ACF_STATUS_NARGS			1
> +
> +#define CMD_FM_ACF_STATUS			0x35
> +#define CMD_FM_ACF_STATUS_NRESP			8
> +#define CMD_FM_ACF_STATUS_NARGS			1
> +
> +#define CMD_MAX_ARGS_COUNT			(10)
> +
> +
> +enum si476x_acf_status_report_bits {
> +	SI476X_ACF_BLEND_INT	= (1 << 4),
> +	SI476X_ACF_HIBLEND_INT	= (1 << 3),
> +	SI476X_ACF_HICUT_INT	= (1 << 2),
> +	SI476X_ACF_CHBW_INT	= (1 << 1),
> +	SI476X_ACF_SOFTMUTE_INT	= (1 << 0),
> +
> +	SI476X_ACF_SMUTE	= (1 << 0),
> +	SI476X_ACF_SMATTN	= 0b11111,
> +	SI476X_ACF_PILOT	= (1 << 7),
> +	SI476X_ACF_STBLEND	= ~SI476X_ACF_PILOT,
> +};
> +
> +enum si476x_agc_status_report_bits {
> +	SI476X_AGC_MXHI		= (1 << 5),
> +	SI476X_AGC_MXLO		= (1 << 4),
> +	SI476X_AGC_LNAHI	= (1 << 3),
> +	SI476X_AGC_LNALO	= (1 << 2),
> +};
> +
> +enum si476x_errors {
> +	SI476X_ERR_BAD_COMMAND		= 0x10,
> +	SI476X_ERR_BAD_ARG1		= 0x11,
> +	SI476X_ERR_BAD_ARG2		= 0x12,
> +	SI476X_ERR_BAD_ARG3		= 0x13,
> +	SI476X_ERR_BAD_ARG4		= 0x14,
> +	SI476X_ERR_BUSY			= 0x18,
> +	SI476X_ERR_BAD_INTERNAL_MEMORY  = 0x20,
> +	SI476X_ERR_BAD_PATCH		= 0x30,
> +	SI476X_ERR_BAD_BOOT_MODE	= 0x31,
> +	SI476X_ERR_BAD_PROPERTY		= 0x40,
> +};
> +
> +
> +static int si476x_core_parse_and_nag_about_error(struct si476x_core *core)
> +{
> +	int err;
> +	char *cause;
> +	u8 buffer[2];
> +
> +	if (core->revision != SI476X_REVISION_A10) {

It's much easier to reverse the test:

	if (core->revision == SI476X_REVISION_A10)
		return -EIO;

It reduces the indentation.

> +		err = si476x_i2c_xfer(core, SI476X_I2C_RECV,
> +				      buffer, sizeof(buffer));
> +		if (err == sizeof(buffer)) {

Ditto for the test above.

Add an err = -EINVAL line here, then you don't need to add it for all the cases
below.

> +			switch (buffer[1]) {
> +			case SI476X_ERR_BAD_COMMAND:
> +				cause = "Bad command";
> +				err = -EINVAL;
> +				break;
> +			case SI476X_ERR_BAD_ARG1:
> +				cause = "Bad argument #1";
> +				err = -EINVAL;
> +				break;
> +			case SI476X_ERR_BAD_ARG2:
> +				cause = "Bad argument #2";
> +				err = -EINVAL;
> +				break;
> +			case SI476X_ERR_BAD_ARG3:
> +				cause = "Bad argument #3";
> +				err = -EINVAL;
> +				break;
> +			case SI476X_ERR_BAD_ARG4:
> +				cause = "Bad argument #4";
> +				err = -EINVAL;
> +				break;
> +			case SI476X_ERR_BUSY:
> +				cause = "Chip is busy";
> +				err = -EBUSY;
> +				break;
> +			case SI476X_ERR_BAD_INTERNAL_MEMORY:
> +				cause = "Bad internal memory";
> +				err = -EIO;
> +				break;
> +			case SI476X_ERR_BAD_PATCH:
> +				cause = "Bad patch";
> +				err = -EINVAL;
> +				break;
> +			case SI476X_ERR_BAD_BOOT_MODE:
> +				cause = "Bad boot mode";
> +				err = -EINVAL;
> +				break;
> +			case SI476X_ERR_BAD_PROPERTY:
> +				cause = "Bad property";
> +				err = -EINVAL;
> +				break;
> +			default:
> +				cause = "Unknown";
> +				err = -EIO;
> +			}
> +
> +			dev_err(&core->client->dev,
> +				"[Chip error status]: %s\n", cause);
> +		} else {
> +			dev_err(&core->client->dev,
> +				"Failed to fetch error code\n");
> +			err = (err >= 0) ? -EIO : err;
> +		}
> +	} else {
> +		err = -EIO;
> +	}
> +
> +	return err;
> +}
> +
> +/**
> + * __core_send_command() - sends a command to si476x and waits its
> + * response
> + * @core:    si476x_device structure for the device we are
> + *            communicating with
> + * @command:  command id
> + * @args:     command arguments we are sending
> + * @argn:     actual size of @args
> + * @response: buffer to place the expected response from the device
> + * @respn:    actual size of @response
> + * @usecs:    amount of time to wait before reading the response (in
> + *            usecs)
> + *
> + * Function returns 0 on succsess and negative error code on
> + * failure
> + */
> +static int __core_send_command(struct si476x_core *core,
> +				    const u8 command,
> +				    const u8 args[],
> +				    const int argn,
> +				    u8 resp[],
> +				    const int respn,
> +				    const int usecs)
> +{
> +	struct i2c_client *client = core->client;
> +	int err;
> +	u8  data[CMD_MAX_ARGS_COUNT + 1];
> +
> +	if (argn > CMD_MAX_ARGS_COUNT) {
> +		err = -ENOMEM;
> +		goto exit;

Why goto exit? There is no clean up after the exit label, so just return
immediately. Ditto for all the other goto exit's in this function.

> +	}
> +
> +	if (!client->adapter) {
> +		err = -ENODEV;
> +		goto exit;
> +	}
> +
> +	/* First send the command and its arguments */
> +	data[0] = command;
> +	memcpy(&data[1], args, argn);
> +	DBG_BUFFER(&client->dev, "Command:\n", data, argn + 1);
> +
> +	err = si476x_i2c_xfer(core, SI476X_I2C_SEND, (char *) data, argn + 1);
> +	if (err != argn + 1) {
> +		dev_err(&core->client->dev,
> +			"Error while sending command 0x%02x\n",
> +			command);
> +		err = (err >= 0) ? -EIO : err;
> +		goto exit;
> +	}
> +	/* Set CTS to zero only after the command is send to avoid
> +	 * possible racing conditions when working in polling mode */
> +	atomic_set(&core->cts, 0);
> +
> +	if (!wait_event_timeout(core->command,
> +				atomic_read(&core->cts),
> +				usecs_to_jiffies(usecs) + 1))
> +		dev_warn(&core->client->dev,
> +			 "(%s) [CMD 0x%02x] Device took too much time to answer.\n",
> +			 __func__, command);
> +
> +	/*
> +	  When working in polling mode, for some reason the tuner will
> +	  report CTS bit as being set in the first status byte read,
> +	  but all the consequtive ones will return zros until the
> +	  tuner is actually completed the POWER_UP command. To
> +	  workaround that we wait for second CTS to be reported
> +	 */
> +	if (unlikely(!core->client->irq && command == CMD_POWER_UP)) {
> +		if (!wait_event_timeout(core->command,
> +					atomic_read(&core->cts),
> +					usecs_to_jiffies(usecs) + 1))
> +			dev_warn(&core->client->dev,
> +				 "(%s) Power up took too much time.\n",
> +				 __func__);
> +	}
> +
> +	/* Then get the response */
> +	err = si476x_i2c_xfer(core, SI476X_I2C_RECV, resp, respn);
> +	if (err != respn) {
> +		dev_err(&core->client->dev,
> +			"Error while reading response for command 0x%02x\n",
> +			command);
> +		err = (err >= 0) ? -EIO : err;
> +		goto exit;
> +	}
> +	DBG_BUFFER(&client->dev, "Response:\n", resp, respn);
> +
> +	err = 0;
> +
> +	if (resp[0] & SI476X_ERR) {
> +		dev_err(&core->client->dev, "Chip set error flag\n");
> +		err = si476x_core_parse_and_nag_about_error(core);
> +		goto exit;
> +	}
> +
> +	if (!(resp[0] & SI476X_CTS))
> +		err = -EBUSY;
> +exit:
> +	return err;
> +}
> +
> +#define CORE_SEND_COMMAND(core, cmd, args, resp, timeout)		\
> +	__core_send_command(core, cmd, args,				\
> +			    ARRAY_SIZE(args),				\
> +			    resp, ARRAY_SIZE(resp),			\
> +			    timeout)
> +
> +
> +static int __cmd_tune_seek_freq(struct si476x_core *core,
> +				uint8_t cmd,
> +				const uint8_t args[], size_t argn,
> +				uint8_t *resp, size_t respn,
> +				int (*clear_stcint) (struct si476x_core *core))
> +{
> +	int err;
> +
> +	atomic_set(&core->stc, 0);
> +	err = __core_send_command(core, cmd, args, argn,
> +				  resp, respn,
> +				  atomic_read(&core->timeouts.command));
> +	if (!err) {

Invert the test to simplify indentation.

> +		if (!wait_event_timeout(core->tuning,
> +		atomic_read(&core->stc),
> +		usecs_to_jiffies(atomic_read(&core->timeouts.tune)) + 1)) {

Weird indentation above. Indent the arguments more to the right.

> +			dev_warn(&core->client->dev,
> +				 "%s: Device took too much time "
> +				 "to answer (%d usec).\n",
> +				 __func__,
> +				 atomic_read(&core->timeouts.tune));
> +			err = -ETIMEDOUT;
> +		} else {
> +			err = clear_stcint(core);
> +		}
> +	}
> +
> +	return err;
> +}
> +
> +
> +/**
> + * si476x_cmd_func_info() - send 'FUNC_INFO' command to the device
> + * @core: device to send the command to
> + * @info:  struct si476x_func_info to fill all the information
> + *         returned by the command
> + *
> + * The command requests the firmware and patch version for currently
> + * loaded firmware (dependent on the function of the device FM/AM/WB)
> + *
> + * Function returns 0 on succsess and negative error code on

typo: success

> + * failure
> + */
> +int si476x_core_cmd_func_info(struct si476x_core *core,
> +			      struct si476x_func_info *info)
> +{
> +	int err;
> +	u8  resp[CMD_FUNC_INFO_NRESP];
> +
> +	err = __core_send_command(core, CMD_FUNC_INFO,
> +				  NULL, 0,
> +				  resp, ARRAY_SIZE(resp),
> +				  atomic_read(&core->timeouts.command));
> +
> +	info->firmware.major    = resp[1];
> +	info->firmware.minor[0] = resp[2];
> +	info->firmware.minor[1] = resp[3];
> +
> +	info->patch_id = ((u16) resp[4] << 8) | resp[5];
> +	info->func     = resp[6];
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_func_info);
> +
> +/**
> + * si476x_cmd_set_property() - send 'SET_PROPERTY' command to the device
> + * @core:    device to send the command to
> + * @property: property address
> + * @value:    property value
> + *
> + * Function returns 0 on succsess and negative error code on
> + * failure
> + */
> +int si476x_core_cmd_set_property(struct si476x_core *core,
> +				 u16 property, u16 value)
> +{
> +	u8       resp[CMD_SET_PROPERTY_NRESP];
> +	const u8 args[CMD_SET_PROPERTY_NARGS] = {
> +		0x00,
> +		msb(property),
> +		lsb(property),
> +		msb(value),
> +		lsb(value),
> +	};
> +
> +	return CORE_SEND_COMMAND(core, CMD_SET_PROPERTY,
> +				 args, resp,
> +				 atomic_read(&core->timeouts.command));
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_set_property);
> +
> +/**
> + * si476x_cmd_get_property() - send 'GET_PROPERTY' command to the device
> + * @core:    device to send the command to
> + * @property: property address
> + *
> + * Function return the value of property as u16 on success or a
> + * negative error on failure
> + */
> +int si476x_core_cmd_get_property(struct si476x_core *core, u16 property)
> +{
> +	int err;
> +	u8       resp[CMD_GET_PROPERTY_NRESP];
> +	const u8 args[CMD_GET_PROPERTY_NARGS] = {
> +		0x00,
> +		msb(property),
> +		lsb(property),
> +	};
> +
> +	err = CORE_SEND_COMMAND(core, CMD_GET_PROPERTY,
> +				args, resp,
> +				atomic_read(&core->timeouts.command));
> +	if (err < 0)
> +		return err;
> +	else
> +		return be16_to_cpup((__be16 *)(resp + 2));
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_get_property);
> +
> +/**
> + * si476x_cmd_dig_audio_pin_cfg() - send 'DIG_AUDIO_PIN_CFG' command to
> + * the device
> + * @core: device to send the command to
> + * @dclk:  DCLK pin function configuration:
> + *	   #SI476X_DCLK_NOOP     - do not modify the behaviour
> + *         #SI476X_DCLK_TRISTATE - put the pin in tristate condition,
> + *                                 enable 1MOhm pulldown
> + *         #SI476X_DCLK_DAUDIO   - set the pin to be a part of digital
> + *                                 audio interface
> + * @dfs:   DFS pin function configuration:
> + *         #SI476X_DFS_NOOP      - do not modify the behaviour
> + *         #SI476X_DFS_TRISTATE  - put the pin in tristate condition,
> + *                             enable 1MOhm pulldown
> + *      SI476X_DFS_DAUDIO    - set the pin to be a part of digital
> + *                             audio interface
> + * @dout - DOUT pin function configuration:
> + *      SI476X_DOUT_NOOP       - do not modify the behaviour
> + *      SI476X_DOUT_TRISTATE   - put the pin in tristate condition,
> + *                               enable 1MOhm pulldown
> + *      SI476X_DOUT_I2S_OUTPUT - set this pin to be digital out on I2S
> + *                               port 1
> + *      SI476X_DOUT_I2S_INPUT  - set this pin to be digital in on I2S
> + *                               port 1
> + * @xout - XOUT pin function configuration:
> + *	SI476X_XOUT_NOOP        - do not modify the behaviour
> + *      SI476X_XOUT_TRISTATE    - put the pin in tristate condition,
> + *                                enable 1MOhm pulldown
> + *      SI476X_XOUT_I2S_INPUT   - set this pin to be digital in on I2S
> + *                                port 1
> + *      SI476X_XOUT_MODE_SELECT - set this pin to be the input that
> + *                                selects the mode of the I2S audio
> + *                                combiner (analog or HD)
> + *                                [SI4761/63/65/67 Only]
> + *
> + * Function returns 0 on success and negative error code on failure
> + */
> +int si476x_core_cmd_dig_audio_pin_cfg(struct  si476x_core *core,
> +				      enum si476x_dclk_config dclk,
> +				      enum si476x_dfs_config  dfs,
> +				      enum si476x_dout_config dout,
> +				      enum si476x_xout_config xout)
> +{
> +	u8       resp[CMD_DIG_AUDIO_PIN_CFG_NRESP];
> +	const u8 args[CMD_DIG_AUDIO_PIN_CFG_NARGS] = {
> +		PIN_CFG_BYTE(dclk),
> +		PIN_CFG_BYTE(dfs),
> +		PIN_CFG_BYTE(dout),
> +		PIN_CFG_BYTE(xout),
> +	};
> +
> +	return CORE_SEND_COMMAND(core, CMD_DIG_AUDIO_PIN_CFG,
> +				 args, resp,
> +				 atomic_read(&core->timeouts.command));
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_dig_audio_pin_cfg);
> +
> +/**
> + * si476x_cmd_zif_pin_cfg - send 'ZIF_PIN_CFG_COMMAND'
> + * @core - device to send the command to
> + * @iqclk - IQCL pin function configuration:
> + *       SI476X_IQCLK_NOOP     - do not modify the behaviour
> + *       SI476X_IQCLK_TRISTATE - put the pin in tristate condition,
> + *                               enable 1MOhm pulldown
> + *       SI476X_IQCLK_IQ       - set pin to be a part of I/Q interace
> + *                               in master mode
> + * @iqfs - IQFS pin function configuration:
> + *       SI476X_IQFS_NOOP     - do not modify the behaviour
> + *       SI476X_IQFS_TRISTATE - put the pin in tristate condition,
> + *                              enable 1MOhm pulldown
> + *       SI476X_IQFS_IQ       - set pin to be a part of I/Q interace
> + *                              in master mode
> + * @iout - IOUT pin function configuration:
> + *       SI476X_IOUT_NOOP     - do not modify the behaviour
> + *       SI476X_IOUT_TRISTATE - put the pin in tristate condition,
> + *                              enable 1MOhm pulldown
> + *       SI476X_IOUT_OUTPUT   - set pin to be I out
> + * @qout - QOUT pin function configuration:
> + *       SI476X_QOUT_NOOP     - do not modify the behaviour
> + *       SI476X_QOUT_TRISTATE - put the pin in tristate condition,
> + *                              enable 1MOhm pulldown
> + *       SI476X_QOUT_OUTPUT   - set pin to be Q out
> + *
> + * Function returns 0 on success and negative error code on failure
> + */
> +int si476x_core_cmd_zif_pin_cfg(struct si476x_core *core,
> +				enum si476x_iqclk_config iqclk,
> +				enum si476x_iqfs_config iqfs,
> +				enum si476x_iout_config iout,
> +				enum si476x_qout_config qout)
> +{
> +	u8       resp[CMD_ZIF_PIN_CFG_NRESP];
> +	const u8 args[CMD_ZIF_PIN_CFG_NARGS] = {
> +		PIN_CFG_BYTE(iqclk),
> +		PIN_CFG_BYTE(iqfs),
> +		PIN_CFG_BYTE(iout),
> +		PIN_CFG_BYTE(qout),
> +	};
> +
> +	return CORE_SEND_COMMAND(core, CMD_ZIF_PIN_CFG,
> +				 args, resp,
> +				 atomic_read(&core->timeouts.command));
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_zif_pin_cfg);
> +
> +/**
> + * si476x_cmd_ic_link_gpo_ctl_pin_cfg - send
> + * 'IC_LINK_GPIO_CTL_PIN_CFG' comand to the device
> + * @core - device to send the command to
> + * @icin - ICIN pin function configuration:
> + *      SI476X_ICIN_NOOP      - do not modify the behaviour
> + *      SI476X_ICIN_TRISTATE  - put the pin in tristate condition,
> + *                              enable 1MOhm pulldown
> + *      SI476X_ICIN_GPO1_HIGH - set pin to be an output, drive it high
> + *      SI476X_ICIN_GPO1_LOW  - set pin to be an output, drive it low
> + *      SI476X_ICIN_IC_LINK   - set the pin to be a part of Inter-Chip link
> + * @icip - ICIP pin function configuration:
> + *      SI476X_ICIP_NOOP      - do not modify the behaviour
> + *      SI476X_ICIP_TRISTATE  - put the pin in tristate condition,
> + *                              enable 1MOhm pulldown
> + *      SI476X_ICIP_GPO1_HIGH - set pin to be an output, drive it high
> + *      SI476X_ICIP_GPO1_LOW  - set pin to be an output, drive it low
> + *      SI476X_ICIP_IC_LINK   - set the pin to be a part of Inter-Chip link
> + * @icon - ICON pin function configuration:
> + *      SI476X_ICON_NOOP     - do not modify the behaviour
> + *      SI476X_ICON_TRISTATE - put the pin in tristate condition,
> + *                             enable 1MOhm pulldown
> + *      SI476X_ICON_I2S      - set the pin to be a part of audio
> + *                             interface in slave mode (DCLK)
> + *      SI476X_ICON_IC_LINK  - set the pin to be a part of Inter-Chip link
> + * @icop - ICOP pin function configuration:
> + *      SI476X_ICOP_NOOP     - do not modify the behaviour
> + *      SI476X_ICOP_TRISTATE - put the pin in tristate condition,
> + *                             enable 1MOhm pulldown
> + *      SI476X_ICOP_I2S      - set the pin to be a part of audio
> + *                             interface in slave mode (DOUT)
> + *                             [Si4761/63/65/67 Only]
> + *      SI476X_ICOP_IC_LINK  - set the pin to be a part of Inter-Chip link
> + *
> + * Function returns 0 on success and negative error code on failure
> + */
> +int si476x_core_cmd_ic_link_gpo_ctl_pin_cfg(struct si476x_core *core,
> +					    enum si476x_icin_config icin,
> +					    enum si476x_icip_config icip,
> +					    enum si476x_icon_config icon,
> +					    enum si476x_icop_config icop)
> +{
> +	u8       resp[CMD_IC_LINK_GPO_CTL_PIN_CFG_NRESP];
> +	const u8 args[CMD_IC_LINK_GPO_CTL_PIN_CFG_NARGS] = {
> +		PIN_CFG_BYTE(icin),
> +		PIN_CFG_BYTE(icip),
> +		PIN_CFG_BYTE(icon),
> +		PIN_CFG_BYTE(icop),
> +	};
> +
> +	return CORE_SEND_COMMAND(core, CMD_IC_LINK_GPO_CTL_PIN_CFG,
> +				 args, resp,
> +				 atomic_read(&core->timeouts.command));
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_ic_link_gpo_ctl_pin_cfg);
> +
> +/**
> + * si476x_cmd_ana_audio_pin_cfg - send 'ANA_AUDIO_PIN_CFG' to the
> + * device
> + * @core - device to send the command to
> + * @lrout - LROUT pin function configuration:
> + *       SI476X_LROUT_NOOP     - do not modify the behaviour
> + *       SI476X_LROUT_TRISTATE - put the pin in tristate condition,
> + *                               enable 1MOhm pulldown
> + *       SI476X_LROUT_AUDIO    - set pin to be audio output
> + *       SI476X_LROUT_MPX      - set pin to be MPX output
> + *
> + * Function returns 0 on success and negative error code on failure
> + */
> +int si476x_core_cmd_ana_audio_pin_cfg(struct si476x_core *core,
> +				      enum si476x_lrout_config lrout)
> +{
> +	u8       resp[CMD_ANA_AUDIO_PIN_CFG_NRESP];
> +	const u8 args[CMD_ANA_AUDIO_PIN_CFG_NARGS] = {
> +		PIN_CFG_BYTE(lrout),
> +	};
> +
> +	return CORE_SEND_COMMAND(core, CMD_ANA_AUDIO_PIN_CFG,
> +				 args, resp,
> +				 atomic_read(&core->timeouts.command));
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_ana_audio_pin_cfg);
> +
> +
> +/**
> + * si476x_cmd_intb_pin_cfg - send 'INTB_PIN_CFG' command to the device
> + * @core - device to send the command to
> + * @intb - INTB pin function configuration:
> + *      SI476X_INTB_NOOP     - do not modify the behaviour
> + *      SI476X_INTB_TRISTATE - put the pin in tristate condition,
> + *                             enable 1MOhm pulldown
> + *      SI476X_INTB_DAUDIO   - set pin to be a part of digital
> + *                             audio interface in slave mode
> + *      SI476X_INTB_IRQ      - set pin to be an interrupt request line
> + * @a1 - A1 pin function configuration:
> + *      SI476X_A1_NOOP     - do not modify the behaviour
> + *      SI476X_A1_TRISTATE - put the pin in tristate condition,
> + *                           enable 1MOhm pulldown
> + *      SI476X_A1_IRQ      - set pin to be an interrupt request line
> + *
> + * Function returns 0 on success and negative error code on failure
> + */
> +static int si476x_core_cmd_intb_pin_cfg_a10(struct si476x_core *core,
> +					    enum si476x_intb_config intb,
> +					    enum si476x_a1_config a1)
> +{
> +	u8       resp[CMD_INTB_PIN_CFG_A10_NRESP];
> +	const u8 args[CMD_INTB_PIN_CFG_NARGS] = {
> +		PIN_CFG_BYTE(intb),
> +		PIN_CFG_BYTE(a1),
> +	};
> +
> +	return CORE_SEND_COMMAND(core, CMD_INTB_PIN_CFG,
> +				 args, resp,
> +				 atomic_read(&core->timeouts.command));
> +}
> +
> +static int si476x_core_cmd_intb_pin_cfg_a20(struct si476x_core *core,
> +					    enum si476x_intb_config intb,
> +					    enum si476x_a1_config a1)
> +{
> +	u8       resp[CMD_INTB_PIN_CFG_A20_NRESP];
> +	const u8 args[CMD_INTB_PIN_CFG_NARGS] = {
> +		PIN_CFG_BYTE(intb),
> +		PIN_CFG_BYTE(a1),
> +	};
> +
> +	return CORE_SEND_COMMAND(core, CMD_INTB_PIN_CFG,
> +				 args, resp,
> +				 atomic_read(&core->timeouts.command));
> +}
> +
> +
> +
> +/**
> + * si476x_cmd_am_rsq_status - send 'FM_TUNE_FREQ' command to the
> + * device
> + * @core  - device to send the command to
> + * @rsqack - if set command clears RSQINT, SNRINT, SNRLINT, RSSIHINT,
> + *           RSSSILINT, BLENDINT, MULTHINT and MULTLINT
> + * @attune - when set the values in the status report are the values
> + *           that were calculated at tune
> + * @cancel - abort ongoing seek/tune opertation
> + * @stcack - clear the STCINT bin in status register
> + * @report - all signal quality information retured by the command
> + *           (if NULL then the output of the command is ignored)
> + *
> + * Function returns 0 on success and negative error code on failure
> + */
> +int si476x_core_cmd_am_rsq_status(struct si476x_core *core,
> +				  struct si476x_rsq_status_args *rsqargs,
> +				  struct si476x_rsq_status_report *report)
> +{
> +	int err;
> +	u8       resp[CMD_AM_RSQ_STATUS_NRESP];
> +	const u8 args[CMD_AM_RSQ_STATUS_NARGS] = {
> +		rsqargs->rsqack << 3 | rsqargs->attune << 2 |
> +		rsqargs->cancel << 1 | rsqargs->stcack,
> +	};
> +
> +	err = CORE_SEND_COMMAND(core, CMD_AM_RSQ_STATUS,
> +				args, resp,
> +				atomic_read(&core->timeouts.command));
> +
> +	if (report) {
> +		report->snrhint		= 0b00001000 & resp[1];
> +		report->snrlint		= 0b00000100 & resp[1];
> +		report->rssihint	= 0b00000010 & resp[1];
> +		report->rssilint	= 0b00000001 & resp[1];
> +
> +		report->bltf		= 0b10000000 & resp[2];
> +		report->snr_ready	= 0b00100000 & resp[2];
> +		report->rssiready	= 0b00001000 & resp[2];
> +		report->afcrl		= 0b00000010 & resp[2];
> +		report->valid		= 0b00000001 & resp[2];
> +
> +		report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
> +		report->freqoff		= resp[5];
> +		report->rssi		= resp[6];
> +		report->snr		= resp[7];
> +		report->lassi		= resp[9];
> +		report->hassi		= resp[10];
> +		report->mult		= resp[11];
> +		report->dev		= resp[12];
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_am_rsq_status);
> +
> +int si476x_core_cmd_fm_acf_status(struct si476x_core *core,
> +			     struct si476x_acf_status_report *report)
> +{
> +	int err;
> +	u8       resp[CMD_FM_ACF_STATUS_NRESP];
> +	const u8 args[CMD_FM_ACF_STATUS_NARGS] = {
> +		0x0,
> +	};
> +
> +	if (!report)
> +		return -EINVAL;
> +
> +	err = CORE_SEND_COMMAND(core, CMD_FM_ACF_STATUS,
> +				args, resp,
> +				atomic_read(&core->timeouts.command));
> +
> +	if (!err) {
> +		report->blend_int	= resp[1] & SI476X_ACF_BLEND_INT;
> +		report->hblend_int	= resp[1] & SI476X_ACF_HIBLEND_INT;
> +		report->hicut_int	= resp[1] & SI476X_ACF_HICUT_INT;
> +		report->chbw_int	= resp[1] & SI476X_ACF_CHBW_INT;
> +		report->softmute_int	= resp[1] & SI476X_ACF_SOFTMUTE_INT;
> +		report->smute		= resp[2] & SI476X_ACF_SMUTE;
> +		report->smattn		= resp[3] & SI476X_ACF_SMATTN;
> +		report->chbw		= resp[4];
> +		report->hicut		= resp[5];
> +		report->hiblend		= resp[6];
> +		report->pilot		= resp[7] & SI476X_ACF_PILOT;
> +		report->stblend		= resp[7] & SI476X_ACF_STBLEND;
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_acf_status);
> +
> +int si476x_core_cmd_am_acf_status(struct si476x_core *core,
> +				  struct si476x_acf_status_report *report)
> +{
> +	int err;
> +	u8       resp[CMD_AM_ACF_STATUS_NRESP];
> +	const u8 args[CMD_AM_ACF_STATUS_NARGS] = {
> +		0x0,
> +	};
> +
> +	if (!report)
> +		return -EINVAL;
> +
> +	err = CORE_SEND_COMMAND(core, CMD_AM_ACF_STATUS,
> +				args, resp,
> +				atomic_read(&core->timeouts.command));
> +
> +	if (!err) {
> +		report->blend_int	= resp[1] & SI476X_ACF_BLEND_INT;
> +		report->hblend_int	= resp[1] & SI476X_ACF_HIBLEND_INT;
> +		report->hicut_int	= resp[1] & SI476X_ACF_HICUT_INT;
> +		report->chbw_int	= resp[1] & SI476X_ACF_CHBW_INT;
> +		report->softmute_int	= resp[1] & SI476X_ACF_SOFTMUTE_INT;
> +		report->smute		= resp[2] & SI476X_ACF_SMUTE;
> +		report->smattn		= resp[3] & SI476X_ACF_SMATTN;
> +		report->chbw		= resp[4];
> +		report->hicut		= resp[5];
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_am_acf_status);
> +
> +static inline int __fm_clear_stcint(struct si476x_core *core)
> +{
> +	struct si476x_rsq_status_args args = {
> +		.primary	= false,
> +		.rsqack		= false,
> +		.attune		= false,
> +		.cancel		= false,
> +		.stcack		= true,
> +	};
> +	return si476x_core_cmd_fm_rsq_status(core, &args, NULL);
> +}
> +
> +static inline int __am_clear_stcint(struct si476x_core *core)
> +{
> +	struct si476x_rsq_status_args args = {
> +		.primary	= false,
> +		.rsqack		= false,
> +		.attune		= false,
> +		.cancel		= false,
> +		.stcack		= true,
> +	};
> +	return si476x_core_cmd_am_rsq_status(core,  &args, NULL);
> +}
> +
> +
> +
> +/**
> + * si476x_cmd_fm_seek_start - send 'FM_SEEK_START' command to the
> + * device
> + * @core  - device to send the command to
> + * @seekup - if set the direction of the search is 'up'
> + * @wrap   - if set seek wraps when hitting band limit
> + *
> + * This function begins search for a valid station. The station is
> + * considered valid when 'FM_VALID_SNR_THRESHOLD' and
> + * 'FM_VALID_RSSI_THRESHOLD' and 'FM_VALID_MAX_TUNE_ERROR' criteria
> + * are met.
> +} *
> + * Function returns 0 on success and negative error code on failure
> + */
> +int si476x_core_cmd_fm_seek_start(struct si476x_core *core,
> +				  bool seekup, bool wrap)
> +{
> +	u8       resp[CMD_FM_SEEK_START_NRESP];
> +	const u8 args[CMD_FM_SEEK_START_NARGS] = {
> +		seekup << 3 | wrap << 2,
> +	};
> +
> +	return __cmd_tune_seek_freq(core, CMD_FM_SEEK_START,
> +				    args, sizeof(args), resp, sizeof(resp),
> +				    __fm_clear_stcint);
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_seek_start);
> +
> +/**
> + * si476x_cmd_fm_rds_status - send 'FM_RDS_STATUS' command to the
> + * device
> + * @core - device to send the command to
> + * @status_only - if set the data is not removed from RDSFIFO,
> + *                RDSFIFOUSED is not decremented and data in all the
> + *                rest RDS data contains the last valid info received
> + * @mtfifo if set the command clears RDS receive FIFO
> + * @intack if set the command clards the RDSINT bit.
> + *
> + * Function returns 0 on success and negative error code on failure
> + */
> +int si476x_core_cmd_fm_rds_status(struct si476x_core *core,
> +				  bool status_only,
> +				  bool mtfifo,
> +				  bool intack,
> +				  struct si476x_rds_status_report *report)
> +{
> +	int err;
> +	u8       resp[CMD_FM_RDS_STATUS_NRESP];
> +	const u8 args[CMD_FM_RDS_STATUS_NARGS] = {
> +		status_only << 2 | mtfifo << 1 | intack,
> +	};
> +
> +	err = CORE_SEND_COMMAND(core, CMD_FM_RDS_STATUS,
> +				args, resp,
> +				atomic_read(&core->timeouts.command));
> +
> +	if (!err && report) {
> +		report->rdstpptyint	= 0b00010000 & resp[1];
> +		report->rdspiint	= 0b00001000 & resp[1];
> +		report->rdssyncint	= 0b00000010 & resp[1];
> +		report->rdsfifoint	= 0b00000001 & resp[1];
> +
> +		report->tpptyvalid	= 0b00010000 & resp[2];
> +		report->pivalid		= 0b00001000 & resp[2];
> +		report->rdssync		= 0b00000010 & resp[2];
> +		report->rdsfifolost	= 0b00000001 & resp[2];
> +
> +		report->tp		= 0b00100000 & resp[3];
> +		report->pty		= 0b00011111 & resp[3];
> +
> +		report->pi		= be16_to_cpup((__be16 *)(resp + 4));
> +		report->rdsfifoused	= resp[6];
> +
> +		report->ble[V4L2_RDS_BLOCK_A]	= 0b11000000 & resp[7];
> +		report->ble[V4L2_RDS_BLOCK_B]	= 0b00110000 & resp[7];
> +		report->ble[V4L2_RDS_BLOCK_C]	= 0b00001100 & resp[7];
> +		report->ble[V4L2_RDS_BLOCK_D]	= 0b00000011 & resp[7];
> +
> +		report->rds[V4L2_RDS_BLOCK_A].block = V4L2_RDS_BLOCK_A;
> +		report->rds[V4L2_RDS_BLOCK_A].msb = resp[8];
> +		report->rds[V4L2_RDS_BLOCK_A].lsb = resp[9];
> +
> +		report->rds[V4L2_RDS_BLOCK_B].block = V4L2_RDS_BLOCK_B;
> +		report->rds[V4L2_RDS_BLOCK_B].msb = resp[10];
> +		report->rds[V4L2_RDS_BLOCK_B].lsb = resp[11];
> +
> +		report->rds[V4L2_RDS_BLOCK_C].block = V4L2_RDS_BLOCK_C;
> +		report->rds[V4L2_RDS_BLOCK_C].msb = resp[12];
> +		report->rds[V4L2_RDS_BLOCK_C].lsb = resp[13];
> +
> +		report->rds[V4L2_RDS_BLOCK_D].block = V4L2_RDS_BLOCK_D;
> +		report->rds[V4L2_RDS_BLOCK_D].msb = resp[14];
> +		report->rds[V4L2_RDS_BLOCK_D].lsb = resp[15];
> +	}
> +
> +	return err;
> +}
> +
> +int si476x_core_cmd_fm_rds_blockcount(struct si476x_core *core,
> +				bool clear,
> +				struct si476x_rds_blockcount_report *report)
> +{
> +	int err;
> +	u8       resp[CMD_FM_RDS_BLOCKCOUNT_NRESP];
> +	const u8 args[CMD_FM_RDS_BLOCKCOUNT_NARGS] = {
> +		clear,
> +	};
> +
> +	if (!report)
> +		return -EINVAL;
> +
> +	err = CORE_SEND_COMMAND(core, CMD_FM_RDS_BLOCKCOUNT,
> +				args, resp,
> +				atomic_read(&core->timeouts.command));
> +
> +	if (!err) {
> +		report->expected	= be16_to_cpup((__be16 *)(resp + 2));
> +		report->received	= be16_to_cpup((__be16 *)(resp + 4));
> +		report->uncorrectable	= be16_to_cpup((__be16 *)(resp + 6));
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_rds_blockcount);
> +
> +int si476x_core_cmd_fm_phase_diversity(struct si476x_core *core,
> +				       enum si476x_phase_diversity_mode mode)
> +{
> +	u8       resp[CMD_FM_PHASE_DIVERSITY_NRESP];
> +	const u8 args[CMD_FM_PHASE_DIVERSITY_NARGS] = {
> +		mode & 0b111,
> +	};
> +
> +	return CORE_SEND_COMMAND(core, CMD_FM_PHASE_DIVERSITY,
> +				 args, resp,
> +				 atomic_read(&core->timeouts.command));
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_phase_diversity);
> +/**
> + * si476x_core_cmd_fm_phase_div_status() - get the phase diversity
> + * status
> + *
> + * @core: si476x device
> + *
> + * NOTE caller must hold core lock
> + *
> + * Function returns the value of the status bit in case of success and
> + * negative error code in case of failre.
> + */
> +int si476x_core_cmd_fm_phase_div_status(struct si476x_core *core)
> +{
> +	int err;
> +	u8 resp[CMD_FM_PHASE_DIV_STATUS_NRESP];
> +
> +	err = __core_send_command(core, CMD_FM_PHASE_DIV_STATUS,
> +				  NULL, 0,
> +				  resp, ARRAY_SIZE(resp),
> +				  atomic_read(&core->timeouts.command));
> +
> +	return (err < 0) ? err : resp[1];
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_phase_div_status);
> +
> +
> +/**
> + * si476x_cmd_am_seek_start - send 'FM_SEEK_START' command to the
> + * device
> + * @core  - device to send the command to
> + * @seekup - if set the direction of the search is 'up'
> + * @wrap   - if set seek wraps when hitting band limit
> + *
> + * This function begins search for a valid station. The station is
> + * considered valid when 'FM_VALID_SNR_THRESHOLD' and
> + * 'FM_VALID_RSSI_THRESHOLD' and 'FM_VALID_MAX_TUNE_ERROR' criteria
> + * are met.
> + *
> + * Function returns 0 on success and negative error code on failure
> + */
> +int si476x_core_cmd_am_seek_start(struct si476x_core *core,
> +				  bool seekup, bool wrap)
> +{
> +	u8       resp[CMD_AM_SEEK_START_NRESP];
> +	const u8 args[CMD_AM_SEEK_START_NARGS] = {
> +		seekup << 3 | wrap << 2,
> +	};
> +
> +	return __cmd_tune_seek_freq(core,  CMD_AM_SEEK_START,
> +				    args, sizeof(args), resp, sizeof(resp),
> +				    __am_clear_stcint);
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_am_seek_start);
> +
> +
> +
> +static int si476x_core_cmd_power_up_a10(struct si476x_core *core,
> +					struct si476x_power_up_args *puargs)
> +{
> +	u8       resp[CMD_POWER_UP_A10_NRESP];
> +	const bool intsel = (core->pinmux.a1 == SI476X_A1_IRQ);
> +	const bool ctsen  = (core->client->irq != 0);
> +	const u8 args[CMD_POWER_UP_A10_NARGS] = {
> +		0xF7,		/* Reserved, always 0xF7 */
> +		0x3F & puargs->xcload,	/* First two bits are reserved to be
> +				 * zeros */
> +		ctsen << 7 | intsel << 6 | 0x07, /* Last five bits
> +						   * are reserved to
> +						   * be written as 0x7 */
> +		puargs->func << 4 | puargs->freq,
> +		0x11,		/* Reserved, always 0x11 */
> +	};
> +
> +	return CORE_SEND_COMMAND(core, CMD_POWER_UP,
> +				 args, resp,
> +				 atomic_read(&core->timeouts.power_up));
> +}
> +
> +static int si476x_core_cmd_power_up_a20(struct si476x_core *core,
> +				 struct si476x_power_up_args *puargs)
> +{
> +	u8       resp[CMD_POWER_UP_A20_NRESP];
> +	const bool intsel = (core->pinmux.a1 == SI476X_A1_IRQ);
> +	const bool ctsen  = (core->client->irq != 0);
> +	const u8 args[CMD_POWER_UP_A20_NARGS] = {
> +		puargs->ibias6x << 7 | puargs->xstart,
> +		0x3F & puargs->xcload,	/* First two bits are reserved to be
> +					 * zeros */
> +		ctsen << 7 | intsel << 6 | puargs->fastboot << 5 |
> +		puargs->xbiashc << 3 | puargs->xbias,
> +		puargs->func << 4 | puargs->freq,
> +		0x10 | puargs->xmode,
> +	};
> +
> +	return CORE_SEND_COMMAND(core, CMD_POWER_UP,
> +				 args, resp,
> +				 atomic_read(&core->timeouts.power_up));
> +}
> +
> +static int si476x_core_cmd_power_down_a10(struct si476x_core *core,
> +					  struct si476x_power_down_args *pdargs)
> +{
> +	u8 resp[CMD_POWER_DOWN_A10_NRESP];
> +
> +	return __core_send_command(core, CMD_POWER_DOWN,
> +				   NULL, 0,
> +				   resp, ARRAY_SIZE(resp),
> +				   atomic_read(&core->timeouts.command));
> +}
> +
> +static int si476x_core_cmd_power_down_a20(struct si476x_core *core,
> +					  struct si476x_power_down_args *pdargs)
> +{
> +	u8 resp[CMD_POWER_DOWN_A20_NRESP];
> +	const u8 args[CMD_POWER_DOWN_A20_NARGS] = {
> +		pdargs->xosc,
> +	};
> +	return CORE_SEND_COMMAND(core, CMD_POWER_DOWN,
> +				 args, resp,
> +				 atomic_read(&core->timeouts.command));
> +}
> +
> +static int si476x_core_cmd_am_tune_freq_a10(struct si476x_core *core,
> +					struct si476x_tune_freq_args *tuneargs)
> +{
> +
> +	const int am_freq = tuneargs->freq;
> +	u8       resp[CMD_AM_TUNE_FREQ_NRESP];
> +	const u8 args[CMD_AM_TUNE_FREQ_NARGS] = {
> +		(tuneargs->hd << 6),
> +		msb(am_freq),
> +		lsb(am_freq),
> +	};
> +
> +	return __cmd_tune_seek_freq(core, CMD_AM_TUNE_FREQ, args, sizeof(args),
> +			       resp, sizeof(resp), __am_clear_stcint);
> +}
> +
> +static int si476x_core_cmd_am_tune_freq_a20(struct si476x_core *core,
> +					struct si476x_tune_freq_args *tuneargs)
> +{
> +	const int am_freq = tuneargs->freq;
> +	u8       resp[CMD_AM_TUNE_FREQ_NRESP];
> +	const u8 args[CMD_AM_TUNE_FREQ_NARGS] = {
> +		(tuneargs->zifsr << 6) | (tuneargs->injside & 0b11),
> +		msb(am_freq),
> +		lsb(am_freq),
> +	};
> +
> +	return __cmd_tune_seek_freq(core, CMD_AM_TUNE_FREQ, args, sizeof(args),
> +			       resp, sizeof(resp), __am_clear_stcint);
> +}
> +
> +static int si476x_core_cmd_fm_rsq_status_a10(struct si476x_core *core,
> +					struct si476x_rsq_status_args *rsqargs,
> +					struct si476x_rsq_status_report *report)
> +{
> +	int err;
> +	u8       resp[CMD_FM_RSQ_STATUS_A10_NRESP];
> +	const u8 args[CMD_FM_RSQ_STATUS_A10_NARGS] = {
> +		rsqargs->rsqack << 3 | rsqargs->attune << 2 |
> +		rsqargs->cancel << 1 | rsqargs->stcack,
> +	};
> +
> +	err = CORE_SEND_COMMAND(core, CMD_FM_RSQ_STATUS,
> +				args, resp,
> +				atomic_read(&core->timeouts.command));
> +
> +	if (report && !err) {
> +		report->multhint	= 0b10000000 & resp[1];
> +		report->multlint	= 0b01000000 & resp[1];
> +		report->snrhint		= 0b00001000 & resp[1];
> +		report->snrlint		= 0b00000100 & resp[1];
> +		report->rssihint	= 0b00000010 & resp[1];
> +		report->rssilint	= 0b00000001 & resp[1];
> +
> +		report->bltf		= 0b10000000 & resp[2];
> +		report->snr_ready	= 0b00100000 & resp[2];
> +		report->rssiready	= 0b00001000 & resp[2];
> +		report->afcrl		= 0b00000010 & resp[2];
> +		report->valid		= 0b00000001 & resp[2];
> +
> +		report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
> +		report->freqoff		= resp[5];
> +		report->rssi		= resp[6];
> +		report->snr		= resp[7];
> +		report->lassi		= resp[9];
> +		report->hassi		= resp[10];
> +		report->mult		= resp[11];
> +		report->dev		= resp[12];
> +		report->readantcap	= be16_to_cpup((__be16 *)(resp + 13));
> +		report->assi		= resp[15];
> +		report->usn		= resp[16];
> +	}
> +
> +	return err;
> +}
> +
> +static int si476x_core_cmd_fm_rsq_status_a20(struct si476x_core *core,
> +					struct si476x_rsq_status_args *rsqargs,
> +					struct si476x_rsq_status_report *report)
> +{
> +	int err;
> +	u8       resp[CMD_FM_RSQ_STATUS_A10_NRESP];
> +
> +	const u8 args[CMD_FM_RSQ_STATUS_A30_NARGS] = {
> +		rsqargs->primary << 4 | rsqargs->rsqack << 3 |
> +		rsqargs->attune  << 2 | rsqargs->cancel << 1 |
> +		rsqargs->stcack,
> +	};
> +
> +	err = CORE_SEND_COMMAND(core, CMD_FM_RSQ_STATUS,
> +				args, resp,
> +				atomic_read(&core->timeouts.command));
> +
> +	if (report && !err) {
> +		report->multhint	= 0b10000000 & resp[1];
> +		report->multlint	= 0b01000000 & resp[1];
> +		report->snrhint		= 0b00001000 & resp[1];
> +		report->snrlint		= 0b00000100 & resp[1];
> +		report->rssihint	= 0b00000010 & resp[1];
> +		report->rssilint	= 0b00000001 & resp[1];
> +
> +		report->bltf		= 0b10000000 & resp[2];
> +		report->snr_ready	= 0b00100000 & resp[2];
> +		report->rssiready	= 0b00001000 & resp[2];
> +		report->afcrl		= 0b00000010 & resp[2];
> +		report->valid		= 0b00000001 & resp[2];
> +
> +		report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
> +		report->freqoff		= resp[5];
> +		report->rssi		= resp[6];
> +		report->snr		= resp[7];
> +		report->lassi		= resp[9];
> +		report->hassi		= resp[10];
> +		report->mult		= resp[11];
> +		report->dev		= resp[12];
> +		report->readantcap	= be16_to_cpup((__be16 *)(resp + 13));
> +		report->assi		= resp[15];
> +		report->usn		= resp[16];
> +	}
> +
> +	return err;
> +}
> +
> +
> +static int si476x_core_cmd_fm_rsq_status_a30(struct si476x_core *core,
> +					struct si476x_rsq_status_args *rsqargs,
> +					struct si476x_rsq_status_report *report)
> +{
> +	int err;
> +	u8       resp[CMD_FM_RSQ_STATUS_A30_NRESP];
> +	const u8 args[CMD_FM_RSQ_STATUS_A30_NARGS] = {
> +		rsqargs->primary << 4 | rsqargs->rsqack << 3 |
> +		rsqargs->attune << 2 | rsqargs->cancel << 1 |
> +		rsqargs->stcack,
> +	};
> +
> +	err = CORE_SEND_COMMAND(core, CMD_FM_RSQ_STATUS,
> +				args, resp,
> +				atomic_read(&core->timeouts.command));
> +
> +	if (report && !err) {
> +		report->multhint	= 0b10000000 & resp[1];
> +		report->multlint	= 0b01000000 & resp[1];
> +		report->snrhint		= 0b00001000 & resp[1];
> +		report->snrlint		= 0b00000100 & resp[1];
> +		report->rssihint	= 0b00000010 & resp[1];
> +		report->rssilint	= 0b00000001 & resp[1];
> +
> +		report->bltf		= 0b10000000 & resp[2];
> +		report->snr_ready	= 0b00100000 & resp[2];
> +		report->rssiready	= 0b00001000 & resp[2];
> +		report->injside         = 0b00000100 & resp[2];
> +		report->afcrl		= 0b00000010 & resp[2];
> +		report->valid		= 0b00000001 & resp[2];
> +
> +		report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
> +		report->freqoff		= resp[5];
> +		report->rssi		= resp[6];
> +		report->snr		= resp[7];
> +		report->issi		= resp[8];
> +		report->lassi		= resp[9];
> +		report->hassi		= resp[10];
> +		report->mult		= resp[11];
> +		report->dev		= resp[12];
> +		report->readantcap	= be16_to_cpup((__be16 *)(resp + 13));
> +		report->assi		= resp[15];
> +		report->usn		= resp[16];
> +
> +		report->pilotdev	= resp[17];
> +		report->rdsdev		= resp[18];
> +		report->assidev		= resp[19];
> +		report->strongdev	= resp[20];
> +		report->rdspi		= be16_to_cpup((__be16 *)(resp + 21));
> +	}
> +
> +	return err;
> +}
> +
> +static int si476x_core_cmd_fm_tune_freq_a10(struct si476x_core *core,
> +					struct si476x_tune_freq_args *tuneargs)
> +{
> +	u8       resp[CMD_FM_TUNE_FREQ_NRESP];
> +	const u8 args[CMD_FM_TUNE_FREQ_A10_NARGS] = {
> +		(tuneargs->hd << 6) | (tuneargs->tunemode << 4)
> +		| (tuneargs->smoothmetrics << 2),
> +		msb(tuneargs->freq),
> +		lsb(tuneargs->freq),
> +		msb(tuneargs->antcap),
> +		lsb(tuneargs->antcap)
> +	};
> +
> +	return __cmd_tune_seek_freq(core, CMD_FM_TUNE_FREQ, args, sizeof(args),
> +			       resp, sizeof(resp), __fm_clear_stcint);
> +}
> +
> +static int si476x_core_cmd_fm_tune_freq_a20(struct si476x_core *core,
> +					struct si476x_tune_freq_args *tuneargs)
> +{
> +	u8       resp[CMD_FM_TUNE_FREQ_NRESP];
> +	const u8 args[CMD_FM_TUNE_FREQ_A20_NARGS] = {
> +		(tuneargs->hd << 6) | (tuneargs->tunemode << 4)
> +		|  (tuneargs->smoothmetrics << 2) | (tuneargs->injside),
> +		msb(tuneargs->freq),
> +		lsb(tuneargs->freq),
> +	};
> +
> +	return __cmd_tune_seek_freq(core, CMD_FM_TUNE_FREQ, args, sizeof(args),
> +			       resp, sizeof(resp), __fm_clear_stcint);
> +}
> +
> +static int si476x_core_cmd_agc_status_a20(struct si476x_core *core,
> +					struct si476x_agc_status_report *report)
> +{
> +	int err;
> +	u8 resp[CMD_AGC_STATUS_NRESP_A20];
> +
> +	if (!report)
> +		return -EINVAL;
> +
> +	err = __core_send_command(core, CMD_AGC_STATUS,
> +				  NULL, 0,
> +				  resp, ARRAY_SIZE(resp),
> +				  atomic_read(&core->timeouts.command));
> +	if (!err) {
> +		report->mxhi		= resp[1] & SI476X_AGC_MXHI;
> +		report->mxlo		= resp[1] & SI476X_AGC_MXLO;
> +		report->lnahi		= resp[1] & SI476X_AGC_LNAHI;
> +		report->lnalo		= resp[1] & SI476X_AGC_LNALO;
> +		report->fmagc1		= resp[2];
> +		report->fmagc2		= resp[3];
> +		report->pgagain		= resp[4];
> +		report->fmwblang	= resp[5];
> +	}
> +
> +	return err;
> +}
> +
> +static int si476x_core_cmd_agc_status_a10(struct si476x_core *core,
> +					struct si476x_agc_status_report *report)
> +{
> +	int err;
> +	u8 resp[CMD_AGC_STATUS_NRESP_A10];
> +
> +	if (!report)
> +		return -EINVAL;
> +
> +	err = __core_send_command(core, CMD_AGC_STATUS,
> +				  NULL, 0,
> +				  resp, ARRAY_SIZE(resp),
> +				  atomic_read(&core->timeouts.command));
> +	if (!err) {
> +		report->mxhi		= resp[1] & SI476X_AGC_MXHI;
> +		report->mxlo		= resp[1] & SI476X_AGC_MXLO;
> +		report->lnahi		= resp[1] & SI476X_AGC_LNAHI;
> +		report->lnalo		= resp[1] & SI476X_AGC_LNALO;
> +	}
> +
> +	return err;
> +}
> +
> +static struct {
> +	int (*power_up) (struct si476x_core *,
> +			 struct si476x_power_up_args *);
> +	int (*power_down) (struct si476x_core *,
> +			   struct si476x_power_down_args *);
> +
> +	tune_freq_func_t fm_tune_freq;
> +	tune_freq_func_t am_tune_freq;
> +
> +	int (*fm_rsq_status)(struct si476x_core *,
> +			     struct si476x_rsq_status_args *,
> +			     struct si476x_rsq_status_report *);
> +
> +	int (*agc_status)(struct si476x_core *,
> +			  struct si476x_agc_status_report *);
> +	int (*intb_pin_cfg)(struct si476x_core *core,
> +			    enum si476x_intb_config intb,
> +			    enum si476x_a1_config a1);
> +} si476x_cmds_vtable[] = {
> +	[SI476X_REVISION_A10] = {
> +		.power_up	= si476x_core_cmd_power_up_a10,
> +		.power_down	= si476x_core_cmd_power_down_a10,
> +		.fm_tune_freq	= si476x_core_cmd_fm_tune_freq_a10,
> +		.am_tune_freq	= si476x_core_cmd_am_tune_freq_a10,
> +		.fm_rsq_status	= si476x_core_cmd_fm_rsq_status_a10,
> +		.agc_status	= si476x_core_cmd_agc_status_a10,
> +		.intb_pin_cfg   = si476x_core_cmd_intb_pin_cfg_a10,
> +	},
> +	[SI476X_REVISION_A20] = {
> +		.power_up	= si476x_core_cmd_power_up_a20,
> +		.power_down	= si476x_core_cmd_power_down_a20,
> +		.fm_tune_freq	= si476x_core_cmd_fm_tune_freq_a20,
> +		.am_tune_freq	= si476x_core_cmd_am_tune_freq_a20,
> +		.fm_rsq_status	= si476x_core_cmd_fm_rsq_status_a20,
> +		.agc_status	= si476x_core_cmd_agc_status_a20,
> +		.intb_pin_cfg   = si476x_core_cmd_intb_pin_cfg_a20,
> +	},
> +	[SI476X_REVISION_A30] = {
> +		.power_up	= si476x_core_cmd_power_up_a20,
> +		.power_down	= si476x_core_cmd_power_down_a20,
> +		.fm_tune_freq	= si476x_core_cmd_fm_tune_freq_a20,
> +		.am_tune_freq	= si476x_core_cmd_am_tune_freq_a20,
> +		.fm_rsq_status	= si476x_core_cmd_fm_rsq_status_a30,
> +		.agc_status	= si476x_core_cmd_agc_status_a20,
> +		.intb_pin_cfg   = si476x_core_cmd_intb_pin_cfg_a20,
> +	},
> +};
> +
> +int si476x_core_cmd_power_up(struct si476x_core *core,
> +			     struct si476x_power_up_args *args)
> +{
> +	BUG_ON(core->revision > SI476X_REVISION_A30 ||
> +	       core->revision == -1);
> +	return si476x_cmds_vtable[core->revision].power_up(core, args);
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_power_up);
> +
> +int si476x_core_cmd_power_down(struct si476x_core *core,
> +			       struct si476x_power_down_args *args)
> +{
> +	BUG_ON(core->revision > SI476X_REVISION_A30 ||
> +	       core->revision == -1);
> +	return si476x_cmds_vtable[core->revision].power_down(core, args);
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_power_down);
> +
> +int si476x_core_cmd_fm_tune_freq(struct si476x_core *core,
> +				 struct si476x_tune_freq_args *args)
> +{
> +	BUG_ON(core->revision > SI476X_REVISION_A30 ||
> +	       core->revision == -1);
> +	return si476x_cmds_vtable[core->revision].fm_tune_freq(core, args);
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_tune_freq);
> +
> +int si476x_core_cmd_am_tune_freq(struct si476x_core *core,
> +				 struct si476x_tune_freq_args *args)
> +{
> +	BUG_ON(core->revision > SI476X_REVISION_A30 ||
> +	       core->revision == -1);
> +	return si476x_cmds_vtable[core->revision].am_tune_freq(core, args);
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_am_tune_freq);
> +
> +int si476x_core_cmd_fm_rsq_status(struct si476x_core *core,
> +				  struct si476x_rsq_status_args *args,
> +				  struct si476x_rsq_status_report *report)
> +
> +{
> +	BUG_ON(core->revision > SI476X_REVISION_A30 ||
> +	       core->revision == -1);
> +	return si476x_cmds_vtable[core->revision].fm_rsq_status(core, args,
> +								report);
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_fm_rsq_status);
> +
> +int si476x_core_cmd_agc_status(struct si476x_core *core,
> +				  struct si476x_agc_status_report *report)
> +
> +{
> +	BUG_ON(core->revision > SI476X_REVISION_A30 ||
> +	       core->revision == -1);
> +	return si476x_cmds_vtable[core->revision].agc_status(core, report);
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_agc_status);
> +
> +
> +int si476x_core_cmd_intb_pin_cfg(struct si476x_core *core,
> +			    enum si476x_intb_config intb,
> +			    enum si476x_a1_config a1)
> +{
> +	BUG_ON(core->revision > SI476X_REVISION_A30 ||
> +	       core->revision == -1);
> +
> +	return si476x_cmds_vtable[core->revision].intb_pin_cfg(core, intb, a1);
> +}
> +EXPORT_SYMBOL_GPL(si476x_core_cmd_intb_pin_cfg);
> +
> +
> +

Andrey, you should look at the drivers/media/radio/si4713-i2c.c source.
It is for the same chip family and is much, much smaller.

See if you can use some of the code that's there.

Regards,

  Hans
