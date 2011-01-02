Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1ABIrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:47:15 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51958 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1ABIqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 03:46:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wRhywg1IoKg/5qT+5eyOlh80+R9B68wpFnriIJ4uaBwEB09G8FkTam8pjyvQ+lvLSz
         67Xt5gZ/NA7M47wRS+R7zHaleq6oiSoegoH9PgqaU3Ngi/+1BuEmAMumltjmdZIiu4zJ
         IwzymlDfehH+etYAwCIP03dp31NESPuu59vhM=
Date: Sun, 2 Jan 2011 00:19:22 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: tapio.vihuri@nokia.com
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, ilkka.koskinen@nokia.com,
        samu.p.onkalo@nokia.com
Subject: Re: [PATCH v2 1/3] ECI: input: introduce ECI accessory input driver
Message-ID: <20110102081922.GD5429@core.coreip.homeip.net>
References: <1293716219-26089-1-git-send-email-tapio.vihuri@nokia.com>
 <1293716219-26089-2-git-send-email-tapio.vihuri@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293716219-26089-2-git-send-email-tapio.vihuri@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tapio,

On Thu, Dec 30, 2010 at 03:36:57PM +0200, tapio.vihuri@nokia.com wrote:
> From: Tapio Vihuri <tapio.vihuri@nokia.com>
> 
> ECI stands for (Enhancement Control Interface).
> 
> ECI is better known as Multimedia Headset for Nokia phones.
> If headset has many buttons, like play, vol+, vol- etc. then it is propably
> ECI accessory.
> Among several buttons ECI accessory contains memory for storing several
> parameters.
> 
> ECI input driver provides the following features:
> - reading ECI configuration memory
> - ECI buttons as input events
> 
> Signed-off-by: Tapio Vihuri <tapio.vihuri@nokia.com>
> ---
>  drivers/input/misc/Kconfig  |   18 +
>  drivers/input/misc/Makefile |    2 +-
>  drivers/input/misc/eci.c    | 1002 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/input/eci.h   |  157 +++++++
>  4 files changed, 1178 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/input/misc/eci.c
>  create mode 100644 include/linux/input/eci.h
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index b99b8cb..7a15bc6 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -448,4 +448,22 @@ config INPUT_ADXL34X_SPI
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called adxl34x-spi.
>  
> +config INPUT_ECI
> +	tristate "AV ECI (Enhancement Control Interface) input driver"
> +	help
> +	The Enhancement Control Interface functionality
> +	  ECI is better known as Multimedia Headset for Nokia phones.
> +	  If headset has many buttons, like play, vol+, vol- etc. then
> +	  it is propably ECI accessory.
> +	  Among several buttons ECI accessory contains memory for storing
> +	  several parameters.
> +
> +	  ECI input driver provides the following features:
> +	  - reading ECI configuration memory
> +	  - ECI buttons as input events
> +
> +	  Say 'y' here to statically link this module into the kernel or 'm'
> +	  to build it as a dynamically loadable module. The module will be
> +	  called eci.ko
> +
>  endif
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 1fe1f6c..99d2289 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -42,4 +42,4 @@ obj-$(CONFIG_INPUT_WINBOND_CIR)		+= winbond-cir.o
>  obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
>  obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
>  obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
> -
> +obj-$(CONFIG_INPUT_ECI)			+= eci.o

Please keep Makefile and Kconfig sorted alphabetically.

> diff --git a/drivers/input/misc/eci.c b/drivers/input/misc/eci.c
> new file mode 100644
> index 0000000..72efccf
> --- /dev/null
> +++ b/drivers/input/misc/eci.c
> @@ -0,0 +1,1002 @@
> +/*
> + * This file is part of ECI (Enhancement Control Interface) accessory input
> + * driver
> + *
> + * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
> + *
> + * Contact: Tapio Vihuri <tapio.vihuri@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +/*
> + * ECI stands for (Enhancement Control Interface).
> + *
> + * ECI is better known as Multimedia Headset for Nokia phones.
> + * If headset has many buttons, like play, vol+, vol- etc. then it is propably
> + * ECI accessory.
> + * Among several buttons ECI accessory contains memory for storing several
> + * parameters.
> + *
> + * ECI input driver provides the following features:
> + *  - reading ECI configuration memory
> + *  - ECI buttons as input events
> + */
> +
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/debugfs.h>
> +
> +#include <linux/input.h>
> +#include <linux/input/eci.h>
> +#include <linux/miscdevice.h>
> +
> +#define ECI_DRIVERNAME	"ECI_accessory"
> +
> +#define ECI_WAIT_SEND_BUTTON		5	/* ms */
> +#define ECI_WAIT_BUS_SETTLE		40	/* ms */
> +#define ECI_TRY_GET_MEMORY		2000	/* ms */
> +#define ECI_TRY_INIT_IO			200	/* ms */
> +#define ECI_TRY_SET_MIC			200	/* ms */
> +#define ECI_KEY_REPEAT_INTERVAL		400	/* ms */
> +
> +#define ECI_EKEY_BLOCK_ID			0xb3
> +#define ECI_ENHANCEMENT_FEATURE_BLOCK_ID	0x02
> +
> +/* ECI Inputs */
> +#define ECI_NIL_FEATURE			0x00 /* No feature */
> +#define ECI_IGNS			0x01 /* Ignition Sense */
> +#define ECI_CK_HANDSET_HOOK		0x02 /* Car-Kit Handset Hook */
> +#define ECI_POWER_SUPPLY		0x03 /* Power Supply/Car Battery Det  */
> +#define ECI_EXT_AUD_IN			0x06 /* External audio In */
> +#define ECI_SEND_END_VR			0x07 /* Send, End, and Voice Recogn */
> +#define ECI_HD_PLUG			0x08 /* Headphone plug */
> +#define ECI_DEV_POWER_REQ		0x0a /* Device Power Request */
> +#define ECI_VOL_UP			0x0b /* Volume Up */
> +#define ECI_VOL_DOWN			0x0c /* Volume Down */
> +#define ECI_PLAY_PAUSE_CTRL		0x0d /* Play / Pause */
> +#define ECI_STOP			0x0e /* Stop */
> +#define ECI_NEXT_FF_AUTOSRC_UP		0x0f /* Next/Fast Fward/Autosearch up */
> +#define ECI_PREV_REW_AUTOSEARCH_DOWN	0x10 /* Prev/Rewind/Autosearch down */
> +#define ECI_POC				0x11 /* Push to Talk over Cellular */
> +#define ECI_SYNC_BTN			0x14 /* Synchronization Button */
> +#define ECI_MUSIC_RADIO_OFF_SELECTOR	0x15 /* Music/Radio/Off Selector */
> +#define ECI_REDIAL			0x16 /* Redial */
> +#define ECI_LEFT_SOFT_KEY		0x17 /* Left Soft Key */
> +#define ECI_RIGHT_SOFT_KEY		0x18 /* Right Soft key */
> +#define ECI_SEND_KEY			0x19 /* Send key */
> +#define ECI_END_KEY			0x1a /* End key */
> +#define ECI_MIDDLE_SOFT_KEY		0x1b /* Middle Soft key */
> +#define ECI_UP				0x1c /* UP key/joystick direction */
> +#define ECI_DOWN			0x1d /* DOWN key/joystick direction */
> +#define ECI_RIGHT			0x1e /* RIGHT key/joystick direction */
> +#define ECI_LEFT			0x1f /* LEFT key/joystick direction */
> +#define ECI_SYMBIAN_NAVY_KEY		0x20 /* Symbian Application key */
> +#define ECI_TERMINAL_APP_CTRL_IN	0x21 /* Terminal Applicat Ctrl Input */
> +#define ECI_USB_CLASS_SWITCHING		0x23 /* USB Class Switching */
> +#define ECI_MUTE			0x24 /* Mute */
> +/* ECI Outputs */
> +#define ECI_CRM				0x82 /* Car Radio Mute */
> +#define ECI_PWR				0x83 /* Power */
> +#define ECI_AUD_AMP			0x85 /* Audio Amplifier */
> +#define ECI_EXT_AUD_SWITCH		0x86 /* External Audio Switch */
> +#define ECI_HANDSET_AUDIO		0x87 /* Handset Audio */
> +#define ECI_RING_INDICATOR		0x88 /* Ringing Indicator */
> +#define ECI_CALL_ACTIVE			0x89 /* Call Active */
> +#define ECI_ENHANCEMENT_DETECTED	0x8b /* Enhancement Detected */
> +#define ECI_AUDIO_BLOCK_IN_USE		0x8e /* Audio Block In Use */
> +#define ECI_STEREO_AUDIO_ACTIVE		0x8f /* stereo audio used in terminal */
> +#define ECI_MONO_AUDIO_ACTIVE		0x90 /* mono audio used in terminal */
> +#define ECI_TERMINAL_APP_CTRL_OUT	0x91 /* Terminal Applicat Ctrl Output */
> +
> +/*
> + * Most of these are key events.
> + * Switch event codes are put on top of keys (KEY_MAX ->)
> + */
> +static int eci_codes[] = {
> +	KEY_UNKNOWN,		/* 0  ECI_NIL_FEATURE */
> +	KEY_UNKNOWN,		/* 1  ECI_IGNS */
> +	KEY_UNKNOWN,		/* 2  ECI_CK_HANDSET_HOOK */
> +	KEY_BATTERY,		/* 3  ECI_POWER_SUPPLY */
> +	KEY_RESERVED,		/* 4  ECI feature not defined */
> +	KEY_RESERVED,		/* 5  ECI feature not defined */
> +	KEY_AUDIO,		/* 6  ECI_EXT_AUD_IN */
> +	KEY_PHONE,		/* 7  ECI_SEND_END_VR */
> +	KEY_MAX + SW_HEADPHONE_INSERT,	/* 8  ECI_HD_PLUG, type switchs */
> +	KEY_RESERVED,		/* 9  ECI feature not defined */
> +	KEY_UNKNOWN,		/* 10 ECI_DEV_POWER_REQ */
> +	KEY_VOLUMEUP,		/* 11 ECI_VOL_UP */
> +	KEY_VOLUMEDOWN,		/* 12 ECI_VOL_DOWN */
> +	KEY_PLAYPAUSE,		/* 13 ECI_PLAY_PAUSE_CTRL */
> +	KEY_STOP,		/* 14 ECI_STOP */
> +	KEY_FORWARD,		/* 15 ECI_NEXT_FF_AUTOSRC_UP */
> +	KEY_REWIND,		/* 16 ECI_PREV_REW_AUTOSEARCH_DOWN */
> +	KEY_UNKNOWN,		/* 17 ECI_POC */
> +	KEY_RESERVED,		/* 18 ECI feature not defined */
> +	KEY_RESERVED,		/* 19 ECI feature not defined */
> +	KEY_UNKNOWN,		/* 20 ECI_SYNC_BTN */
> +	KEY_RADIO,		/* 21 ECI_MUSIC_RADIO_OFF_SELECTOR */
> +	KEY_UNKNOWN,		/* 22 ECI_REDIAL */
> +	KEY_UNKNOWN,		/* 23 ECI_LEFT_SOFT_KEY */
> +	KEY_UNKNOWN,		/* 24 ECI_RIGHT_SOFT_KEY */
> +	KEY_SEND,		/* 25 ECI_SEND_KEY */
> +	KEY_END,		/* 26 ECI_END_KEY */
> +	KEY_UNKNOWN,		/* 27 ECI_MIDDLE_SOFT_KEY */
> +	KEY_UP,			/* 28 ECI_UP */
> +	KEY_DOWN,		/* 29 ECI_DOWN */
> +	KEY_RIGHT,		/* 30 ECI_RIGHT */
> +	KEY_LEFT,		/* 31 ECI_LEFT */
> +	KEY_UNKNOWN,		/* 32 ECI_SYMBIAN_NAVY_KEY */
> +	KEY_UNKNOWN,		/* 33 ECI_TERMINAL_APP_CTRL_IN */
> +	KEY_RESERVED,		/* 34 ECI feature not defined */
> +	KEY_UNKNOWN,		/* 35 ECI_USB_CLASS_SWITCHING */
> +	KEY_MUTE,		/* 36 ECI_MUTE */
> +};

Consider switching to sparse keymap library. You won't be needing ugly
KEY_MAX + SW_XXX hacks and it will also support remapping keys from
userspace.

> +
> +/* ECI accessory register's bits */
> +#define ECI_MIC_AUTO	0x00
> +#define ECI_MIC_OFF	0x5a
> +#define ECI_MIC_ON	0xff
> +
> +#define ECI_INT_ENABLE		1
> +#define ECI_INT_DELAY_ENABLE	(1<<1)
> +#define ECI_INT_LEN_76MS	0
> +#define ECI_INT_LEN_82MS	(1<<5)
> +#define ECI_INT_LEN_37MS	(2<<5)
> +#define ECI_INT_LEN_19MS	(3<<5)
> +#define ECI_INT_LEN_10MS	(4<<5)
> +#define ECI_INT_LEN_5MS		(5<<5)
> +#define ECI_INT_LEN_2MS		(6<<5)
> +#define ECI_INT_LEN_120US	(7<<5)
> +
> +struct eci_mem_block {
> +	u8 id;
> +	u8 len;
> +	u16 size;
> +};
> +
> +static struct eci_cb eci_callback;
> +static struct audio_hsmic_event hsmic_event;
> +
> +static struct eci_data *the_eci;
> +
> +#ifdef CONFIG_DEBUG_FS
> +static void eci_accessory_event(int event, void *priv);
> +static void eci_hsmic_event(void *priv, bool on);
> +
> +static struct dentry *eci_debugfs_dir;
> +
> +static ssize_t mic_read(struct file *file, char __user *user_buf,
> +		size_t count, loff_t *ppos)
> +{
> +	/* Assosiated in default_open() */
> +	struct eci_data *eci = file->private_data;
> +	char buf[80], *state;
> +	int len = 0;
> +	int ret;
> +
> +	/* Do not run twice */
> +	if (*ppos == 0) {
> +		ret = eci->eci_hw_ops->acc_read_reg(ECICMD_MIC_CTRL, buf, 1);
> +		if (ret)
> +			return ret;
> +
> +		eci->mic_state = buf[0];
> +		switch (eci->mic_state) {
> +		case ECI_MIC_AUTO:
> +			state = "auto";
> +			break;
> +		case ECI_MIC_OFF:
> +			state = "off";
> +			break;
> +		case ECI_MIC_ON:
> +			state = "on";
> +			break;
> +		default:
> +			state = "unknown";
> +			break;
> +		}
> +
> +		len = snprintf(buf, sizeof(buf), "microphone %s\n", state);
> +	}
> +
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
> +
> +	return ret;
> +}
> +
> +static ssize_t mic_write(struct file *file, const char __user *user_buf,
> +		size_t count, loff_t *ppos)
> +{
> +	/* Assosiated in default_open() */
> +	struct eci_data *eci = file->private_data;
> +	char buf[80];
> +	int buf_size;
> +
> +	buf_size = min(count, (sizeof(buf) - 1));
> +	if (copy_from_user(buf, user_buf, buf_size))
> +		return -EFAULT;
> +
> +	if (!memcmp(buf, "auto", 4))
> +		eci_hsmic_event(eci, true);
> +	else if (!memcmp(buf, "off", 3))
> +		eci_hsmic_event(eci, false);
> +	else if (!memcmp(buf, "on", 2)) {
> +		eci->mic_state = ECI_MIC_ON;
> +		if (eci->eci_hw_ops->acc_write_reg(ECICMD_MIC_CTRL,
> +					eci->mic_state))
> +			dev_err(eci->dev, "Unable to control headset"
> +					"microphone\n");

Do not break strings on 80 column boundaries, wither align the arguments
differently or just go past 80 columns, like this:

			dev_err(eci->dev,
				"Unable to control headset microphone\n");

> +	}
> +
> +	return count;
> +}
> +
> +static int default_open(struct inode *inode, struct file *file)
> +{
> +	/* Assosiated in debugfs_create_file() */
> +	if (inode->i_private)
> +		file->private_data = inode->i_private;
> +
> +	return 0;
> +}
> +
> +static const struct file_operations mic_fops = {
> +	.open		= default_open,
> +	.read		= mic_read,
> +	.write		= mic_write,
> +};
> +
> +static void eci_uninitialize_debugfs(void)
> +{
> +	if (eci_debugfs_dir)
> +		debugfs_remove_recursive(eci_debugfs_dir);
> +}
> +
> +static long eci_initialize_debugfs(struct eci_data *eci)
> +{
> +	void *ok;
> +
> +	/* /sys/kernel/debug/ECI_accessory.# */
> +	eci_debugfs_dir = debugfs_create_dir(dev_name(eci->dev), NULL);
> +	if (!eci_debugfs_dir)
> +		return -ENOENT;
> +
> +	/* Struct eci assosiated to inode->i_private */
> +	ok = debugfs_create_file("mic", S_IRUGO | S_IWUSR,
> +			eci_debugfs_dir, eci, &mic_fops);
> +	if (!ok)
> +		goto fail;
> +
> +	return 0;
> +fail:
> +	eci_uninitialize_debugfs();
> +	return -ENOENT;
> +}
> +#else
> +#define eci_initialize_debugfs(eci)	1

Should be 0 I think, and not have a parameter, preferably

static inline int eci_initialize_debugfs(void)
{
	return 0;
}

> +#define eci_uninitialize_debugfs()
> +#endif
> +
> +/* Returns size of accessory memory or error */
> +static int eci_get_ekey(struct eci_data *eci, int *key)
> +{
> +	u8 buf[4];
> +	struct eci_mem_block *ekey = (void *)buf;
> +	int ret;
> +
> +	/* Read always four bytes */
> +	ret = eci->eci_hw_ops->acc_read_direct(0, buf);
> +
> +	if (ret)
> +		return ret;
> +
> +	if (ekey->id != ECI_EKEY_BLOCK_ID)
> +		return -ENODEV;
> +
> +	*key = cpu_to_be16(ekey->size);

cpu_to_be16()??? This looks really wierd.

> +
> +	return 0;
> +}
> +
> +static ssize_t show_eci_memory(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	if (!the_eci->mem_ok)
> +		return -ENXIO;
> +
> +	memcpy(buf, the_eci->memory, the_eci->mem_size);
> +
> +	return the_eci->mem_size;
> +}
> +
> +static ssize_t show_cable_plugged(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct eci_data *eci = dev_get_drvdata(dev);
> +
> +	return snprintf(buf, sizeof(buf), "Cable plugged %s\n",
> +				eci->plugged ? "in" : "out");

Should it be dsimple 0/1? How is this attribute supposed to be used?

> +}
> +
> +static ssize_t store_cable_plugged(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf, size_t len)
> +{
> +	struct eci_data *eci = dev_get_drvdata(dev);
> +
> +	if (!memcmp(buf, "in", 2)) {
> +		eci->plugged = true;
> +		eci_accessory_event(ECI_EVENT_PLUG_IN, eci);
> +	} else if (!memcmp(buf, "out", 3)) {
> +		eci->plugged = false;
> +		eci_accessory_event(ECI_EVENT_PLUG_OUT, eci);
> +	}

Same here. Should it be in debugfs probably?

> +
> +	return len;
> +}
> +
> +static DEVICE_ATTR(memory, S_IRUGO, show_eci_memory, NULL);
> +static DEVICE_ATTR(cable, S_IRUGO | S_IWUSR , show_cable_plugged,
> +		store_cable_plugged);
> +
> +static struct attribute *eci_attributes[] = {
> +	&dev_attr_memory.attr,
> +	&dev_attr_cable.attr,
> +	NULL
> +};
> +
> +static struct attribute_group eci_attr_group = {
> +	.attrs = eci_attributes
> +};
> +
> +/* Read ECI device memory into buffer */
> +static int eci_get_memory(struct eci_data *eci, int *restart)
> +{
> +	int i, ret;
> +
> +	for (i = *restart; i < eci->mem_size; i += 4) {
> +		ret = eci->eci_hw_ops->acc_read_direct(i, eci->memory + i);
> +		*restart = i;
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * This should be really init_features, but most oftens these are just buttons
> + */
> +static int eci_init_buttons(struct eci_data *eci)
> +{
> +	struct enchancement_features_fixed *eff = eci->e_features_fix;
> +	u8 n, mireg;
> +	int ret;
> +	u8 buf[4];
> +
> +	n = eff->number_of_features;
> +
> +	if (n > ECI_MAX_FEATURE_COUNT)
> +		return -EINVAL;
> +
> +	ret = eci->eci_hw_ops->acc_write_reg(ECICMD_MIC_CTRL, ECI_MIC_OFF);
> +	if (ret)
> +		return ret;
> +
> +	ret = eci->eci_hw_ops->acc_read_reg(ECICMD_MASTER_INT_REG, buf, 1);
> +	if (ret)
> +		return ret;
> +
> +	mireg = buf[0];
> +	mireg &= ~ECI_INT_ENABLE;
> +	mireg |= ECI_INT_LEN_120US | ECI_INT_DELAY_ENABLE;
> +
> +	ret = eci->eci_hw_ops->acc_write_reg(ECICMD_MASTER_INT_REG, mireg);
> +	if (ret)
> +		return ret;
> +
> +	msleep(ECI_WAIT_BUS_SETTLE);
> +	mireg |= ECI_INT_ENABLE;
> +	ret = eci->eci_hw_ops->acc_write_reg(ECICMD_MASTER_INT_REG, mireg);
> +	if (ret)
> +		return ret;
> +
> +	msleep(ECI_WAIT_BUS_SETTLE);
> +
> +	return ret;
> +}
> +
> +/* Find "enchangement features" block from buffer */
> +static int eci_get_enchancement_features(struct eci_data *eci)
> +{
> +	u8 *mem = (void *)eci->memory;
> +	struct eci_mem_block *b = (void *)mem;
> +	struct eci_mem_block *mem_end = (void *)(eci->memory + eci->mem_size);
> +
> +	if (b->id != ECI_EKEY_BLOCK_ID)
> +		return -ENODEV;
> +
> +	do {
> +		dev_dbg(eci->dev, "skip BLOCK 0x%02x, LEN 0x%02x\n",
> +				b->id, b->len);
> +		if (!b->len)
> +			return -EINVAL;
> +
> +		mem += b->len;
> +		b = (void *)mem;
> +		eci->e_features_fix = (void *)b;
> +		dev_dbg(eci->dev, "found BLOCK 0x%02x, LEN 0x%02x\n",
> +				b->id, b->len);
> +		if (b->id == ECI_ENHANCEMENT_FEATURE_BLOCK_ID)
> +			return 0;
> +	} while (b < mem_end);
> +
> +	return -ENFILE;
> +}
> +
> +/*
> + * Find out ECI features.
> + * All ECI memory block parsing are done here, be carefull as
> + * pointers to memory tend to go wrong easily.
> + * ECI "Enhancement Features block has variable size, so we try to
> + * catch pointers out of block due memory reading errors etc.
> + *
> + * I/O support field is not implemented.
> + * Data direction field is not implemented, nor writing to the ECI I/O
> + */
> +static int eci_parse_enchancement_features(struct eci_data *eci)
> +{
> +	struct enchancement_features_fixed *eff = eci->e_features_fix;
> +	struct enchancement_features_variable *efv = &eci->e_features_var;
> +	int i;
> +	u8 n, k;
> +	void *mem_end = (void *)((u8 *)eff + eff->length);
> +
> +	dev_dbg(eci->dev, "block id 0x%02x length 0x%02x connector "
> +			"configuration 0x%02x\n", eff->block_id, eff->length,
> +			eff->connector_conf);
> +	n = eff->number_of_features;
> +	dev_dbg(eci->dev, "number of features %d\n", n);
> +
> +	if (n > ECI_MAX_FEATURE_COUNT)
> +		return -EINVAL;
> +
> +	k = DIV_ROUND_UP(n, 8);
> +	dev_dbg(eci->dev, "I/O support bytes count %d\n", k);
> +
> +	efv->io_support = &eff->number_of_features + 1;
> +	/* efv->io_functionality[0] is not used! pins are in 1..31 range */
> +	efv->io_functionality = efv->io_support + k - 1;
> +	efv->active_state = efv->io_functionality + n + 1;
> +
> +	if ((void *)&efv->active_state[k] > mem_end)
> +		return -EINVAL;
> +
> +	/* Last part of block */
> +	for (i = 0; i < k; i++)
> +		dev_dbg(eci->dev, "active_state[%d] 0x%02x\n", i,
> +				efv->active_state[i]);
> +
> +	eci->buttons_data.buttons_up_mask =
> +		~(u32)(cpu_to_le32(*(u32 *)efv->active_state));
> +
> +	/*
> +	 * ECI accessory responces as many bytes needed for used I/O pins
> +	 * up to four bytes, when lines 24..31 are used
> +	 * all tested ECI accessories how ever return two data bytes
> +	 * event though there are less than eight I/O pins
> +	 *
> +	 * so we get alway reading error if there are less than eight I/Os
> +	 * meanwhile just use this kludge, FIXME
> +	 */
> +	k = DIV_ROUND_UP(n + 1, 8);
> +	if (k == 1)
> +		k = 2;
> +	eci->port_reg_count = k;
> +
> +	return 0;
> +}
> +
> +static int eci_init_accessory(struct eci_data *eci)
> +{
> +	int ret, key = 0, restart = 0;
> +	unsigned long future;
> +
> +	eci->mem_ok = false;
> +
> +	if (!eci->eci_hw_ops)
> +		return -ENXIO;
> +
> +	ret = eci->eci_hw_ops->acc_reset();
> +	if (ret)
> +		return ret;
> +
> +	msleep(ECI_WAIT_BUS_SETTLE);
> +
> +	ret = eci->eci_hw_ops->acc_write_reg(ECICMD_MIC_CTRL, ECI_MIC_OFF);
> +	if (ret)
> +		return ret;
> +
> +	/* Get ECI ekey block to determine memory size */
> +	future = jiffies + msecs_to_jiffies(ECI_TRY_GET_MEMORY);
> +	do {
> +		ret = eci_get_ekey(eci, &key);
> +		if (time_is_before_jiffies(future))
> +			break;
> +	} while (ret);
> +
> +	if (ret)
> +		return ret;
> +
> +	eci->mem_size = key;
> +	if (eci->mem_size > ECI_MAX_MEM_SIZE)
> +		return -EINVAL;
> +
> +	/* Get ECI memory */
> +	future = jiffies + msecs_to_jiffies(ECI_TRY_GET_MEMORY);
> +	do {
> +		ret = eci_get_memory(eci, &restart);
> +		if (time_is_before_jiffies(future))
> +			break;
> +	} while (ret);
> +
> +	if (ret)
> +		return ret;
> +
> +	if (eci_get_enchancement_features(eci))
> +		return -EIO;
> +
> +	if (eci_parse_enchancement_features(eci))
> +		return -EIO;
> +
> +	/*
> +	 * Configure ECI buttons now as we have after parsed
> +	 * enchancement features table
> +	 */

I do not understand this comment.

> +	msleep(ECI_WAIT_BUS_SETTLE);
> +	future = jiffies + msecs_to_jiffies(ECI_TRY_INIT_IO);
> +	do {
> +		ret = eci_init_buttons(eci);
> +		if (time_is_before_jiffies(future))
> +			break;
> +	} while (ret);
> +
> +	if (ret)
> +		return ret;
> +
> +	eci->mem_ok = true;
> +	msleep(ECI_WAIT_BUS_SETTLE);
> +
> +	if (eci->eci_hw_ops->acc_write_reg(ECICMD_MIC_CTRL, eci->mic_state))
> +		dev_err(eci->dev, "Unable to control headset microphone\n");
> +
> +	return 0;
> +}
> +
> +static int init_accessory_input(struct eci_data *eci)
> +{
> +	int err, i, code;
> +
> +	eci->acc_input = input_allocate_device();
> +	if (!eci->acc_input) {
> +		dev_err(eci->dev, "Error allocating input device: %d\n",
> +				__LINE__);
> +		return -ENOMEM;
> +	}
> +
> +	eci->acc_input->name = "ECI Accessory";
> +
> +	/* Codes on top of KEY_MAX are switch events */
> +	for (i = 0; i < ARRAY_SIZE(eci_codes); i++) {
> +		code = eci_codes[i];
> +		if (code >= KEY_MAX) {
> +			code -= KEY_MAX;
> +			set_bit(code, eci->acc_input->swbit);
> +		} else {
> +			set_bit(code, eci->acc_input->keybit);
> +		}
> +	}
> +
> +	set_bit(EV_KEY, eci->acc_input->evbit);
> +	set_bit(EV_SW, eci->acc_input->evbit);
> +	set_bit(EV_REP, eci->acc_input->evbit);

__set_bit(), no neded to lock bus.

> +
> +	err = input_register_device(eci->acc_input);
> +	if (err) {
> +		dev_err(eci->dev, "Error registering input device: %d\n",
> +				__LINE__);
> +		goto err_free_dev;
> +	}
> +
> +	/* Must set after input_register_device() to take effect */
> +	eci->acc_input->rep[REP_PERIOD] = ECI_KEY_REPEAT_INTERVAL;
> +
> +	return 0;
> +
> +err_free_dev:
> +	input_free_device(eci->acc_input);
> +	return err;
> +}
> +
> +static void remove_accessory_input(struct eci_data *eci)
> +{
> +	input_unregister_device(eci->acc_input);
> +}
> +
> +/* Press/release ccessory button(s) */
> +static int eci_get_button(struct eci_data *eci)
> +{
> +	struct enchancement_features_fixed *eff = eci->e_features_fix;
> +	struct eci_buttons_data *b = &eci->buttons_data;
> +
> +	if (!eci->mem_ok)
> +		return -ENXIO;
> +
> +	if (((b->buttons & 0x0000ffff) == 0) && (eff->number_of_features > 2)) {
> +		dev_err(eci->dev, "ECI report all buttons down, rejected %d\n",
> +			       __LINE__);
> +		return -EINVAL;
> +	}
> +
> +	if (b->windex < ECI_BUTTON_BUF_SIZE) {
> +		if (b->buttons_buf[b->windex] == 0)
> +			b->buttons_buf[b->windex] = b->buttons;
> +		else
> +			dev_err(eci->dev, "ECI button queue owerflow %d\n",
> +			       __LINE__);
> +	}
> +	b->windex++;
> +	if (b->windex == ECI_BUTTON_BUF_SIZE)
> +		b->windex = 0;
> +
> +	return 0;
> +}
> +
> +/* Intended to use ONLY inside eci_parse_button() ! */
> +#define ACTIVE_STATE(x) (u32)(cpu_to_le32(*(u32 *)efv->active_state) & BIT(x-1))
> +#define BUTTON_STATE(x) ((buttons & BIT(x))>>1)
> +
> +static int eci_parse_button(struct eci_data *eci, u32 buttons)
> +{
> +	int pin, code, state;
> +	u8 n, io_fun;
> +	struct enchancement_features_variable *efv = &eci->e_features_var;
> +	struct enchancement_features_fixed *eff = eci->e_features_fix;
> +
> +	if (!eci->mem_ok)
> +		return -ENXIO;
> +
> +	n = eff->number_of_features;
> +
> +	for (pin = 1; pin <= n; pin++) {
> +		io_fun = efv->io_functionality[pin] & ~BIT(7);
> +		if (io_fun > ECI_MUTE)
> +			break;
> +		code = eci_codes[io_fun];
> +		state = (BUTTON_STATE(pin) == ACTIVE_STATE(pin));
> +		if (state)
> +			dev_dbg(eci->dev, "I/O functionality 0x%02x\n", io_fun);
> +		if (code >= KEY_MAX)
> +			input_report_switch(eci->acc_input, code - KEY_MAX,
> +					state);
> +		else
> +			input_report_key(eci->acc_input, code, state);
> +	}
> +	input_sync(eci->acc_input);
> +
> +	return 0;
> +}
> +
> +static int eci_send_button(struct eci_data *eci)
> +{
> +	int i;
> +	struct enchancement_features_fixed *eff = eci->e_features_fix;
> +	struct eci_buttons_data *b = &eci->buttons_data;
> +	u8 n;
> +
> +	if (!eci->mem_ok)
> +		return -ENXIO;
> +
> +	n = eff->number_of_features;
> +
> +	if (n > ECI_MAX_FEATURE_COUNT)
> +		return -EINVAL;
> +	/*
> +	 * Codes on top of KEY_MAX are switch events.
> +	 * Let input system take care multiple key events
> +	 */
> +	for (i = 0; i < ECI_BUTTON_BUF_SIZE; i++) {
> +		if (b->buttons_buf[b->rindex] == 0)
> +			break;
> +
> +		if (eci_parse_button(eci, b->buttons_buf[b->rindex]))
> +			return -ENXIO;
> +
> +		b->buttons_buf[b->rindex] = 0;
> +		b->rindex++;
> +		if (b->rindex == ECI_BUTTON_BUF_SIZE)
> +			b->rindex = 0;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Other driver(s) can call this after registering themselves using
> + * eci_register()
> + */
> +static void eci_accessory_event(int event, void *priv)
> +{
> +	struct eci_data *eci = priv;
> +	struct eci_buttons_data *b = &eci->buttons_data;
> +	int delay = 0;
> +	int ret = 0;
> +
> +	eci->event = event;
> +	switch (event) {
> +	case ECI_EVENT_IS_ECI:
> +		eci->is_eci = true;
> +		ret = eci->eci_hw_ops->acc_reset();
> +		if (ret)
> +			eci->is_eci = false;
> +		break;
> +	case ECI_EVENT_PLUG_IN:
> +		eci->first_event = true;
> +		ret = eci_init_accessory(eci);
> +		if (ret < 0)
> +			ret = eci_init_accessory(eci);
> +		if (ret) {
> +			dev_err(eci->dev, "Accessory init %s%s%s%sat: %d\n",
> +					ret & ACI_COMMERR ? "COMMERR " : "",
> +					ret & ACI_FRAERR ? "FRAERR " : "",
> +					ret & ACI_RESERR ? "RESERR " : "",
> +					ret & ACI_COLL ? "COLLERR " : "",
> +					__LINE__);
> +			break;
> +		}
> +		break;
> +	case ECI_EVENT_PLUG_OUT:
> +		eci->mem_ok = false;
> +		break;
> +	case ECI_EVENT_BUTTON:
> +		/*
> +		 * First event might not be valid due plug insertion
> +		 * so we filter it out if it seems garbage
> +		 */
> +		if (eci->first_event) {
> +			eci->first_event = false;
> +			if ((b->buttons & 0xff) == 0)
> +				break;
> +		}
> +		eci_get_button(eci);
> +		delay = msecs_to_jiffies(ECI_WAIT_SEND_BUTTON);
> +		schedule_delayed_work(&eci->eci_ws, delay);
> +		break;
> +	default:
> +		dev_err(eci->dev, "unknown event %d: %d\n", event, __LINE__);
> +		break;
> +	}
> +
> +	return;
> +}
> +
> +static void eci_hsmic_event(void *priv, bool on)
> +{
> +	struct eci_data *eci = priv;
> +	unsigned long future;
> +	int ret;
> +
> +	if (!eci)
> +		return;
> +
> +	if (on)
> +		eci->mic_state = ECI_MIC_AUTO;
> +	else
> +		eci->mic_state = ECI_MIC_OFF;
> +
> +	future = jiffies + msecs_to_jiffies(ECI_TRY_SET_MIC);
> +	do {
> +		ret = eci->eci_hw_ops->acc_write_reg(ECICMD_MIC_CTRL,
> +				eci->mic_state);
> +		if (time_is_before_jiffies(future))
> +			break;
> +	} while (ret);
> +
> +	if (ret)
> +		dev_err(eci->dev, "Unable to control headset microphone\n");
> +}
> +
> +/* General work func (eci_ws) for several tasks */
> +static void eci_work(struct work_struct *ws)
> +{
> +	struct eci_data *eci;
> +	int ret;
> +
> +	eci = container_of((struct delayed_work *)ws, struct eci_data,
> +			eci_ws);
> +
> +	ret = eci_send_button(eci);
> +	if (ret)
> +		dev_err(eci->dev, "Error sending event: %d\n", __LINE__);
> +}
> +
> +static struct miscdevice eci_device = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = ECI_DRIVERNAME,
> +};

What does this device do?

> +
> +struct eci_cb *eci_register(struct eci_hw_ops *eci_ops)
> +{
> +	if (!the_eci)
> +		return ERR_PTR(-EBUSY);
> +
> +	if (!eci_ops || !eci_ops->acc_read_direct ||
> +			!eci_ops->acc_read_reg || !eci_ops->acc_write_reg ||
> +			!eci_ops->acc_reset)
> +		return ERR_PTR(-EINVAL);
> +
> +	the_eci->eci_hw_ops = eci_ops;
> +
> +	return &eci_callback;
> +}
> +EXPORT_SYMBOL(eci_register);
> +
> +static int __init eci_probe(struct platform_device *pdev)
> +{
> +	struct eci_data *eci;
> +	struct eci_platform_data *pdata = pdev->dev.platform_data;
> +	int ret;
> +
> +	eci = kzalloc(sizeof(*eci), GFP_KERNEL);
> +	if (!eci)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, eci);
> +	eci->dev = &pdev->dev;
> +
> +	ret = misc_register(&eci_device);
> +	if (ret) {
> +		dev_err(eci->dev, "could not register misc_device: %d\n",
> +				__LINE__);
> +		goto err_misc;
> +	}
> +
> +	the_eci = eci;
> +
> +	eci_callback.event              = eci_accessory_event;
> +	eci_callback.priv               = eci;
> +
> +	ret = sysfs_create_group(&pdev->dev.kobj, &eci_attr_group);
> +	if (ret) {
> +		dev_err(eci->dev, "could not create sysfs entries: %d\n",
> +				__LINE__);
> +		goto err_sysfs;
> +	}
> +
> +	ret = eci_initialize_debugfs(eci);
> +	if (ret)
> +		dev_err(eci->dev, "could not create debugfs entries: %d\n",
> +				__LINE__);
> +
> +	ret = init_accessory_input(eci);
> +	if (ret) {
> +		dev_err(eci->dev, "ERROR initializing accessory input: %d\n",
> +				__LINE__);
> +		goto err_input;
> +	}
> +
> +	/*
> +	 * If platform machine has audio driver providing
> +	 * register_hsmic_event_cb, we should give accessory microphone control,
> +	 * ie. eci_hsmic_event to it.
> +	 * This way audio driver get control to ECI accessory microphone and
> +	 * we can save power
> +	 */
> +	if (pdata) {
> +		if (pdata->register_hsmic_event_cb) {
> +			hsmic_event.private	= eci;
> +			hsmic_event.event	= eci_hsmic_event;
> +			pdata->register_hsmic_event_cb(&hsmic_event);
> +		}
> +	}
> +
> +	init_waitqueue_head(&eci->wait);
> +	INIT_DELAYED_WORK(&eci->eci_ws, eci_work);
> +
> +	eci->mem_ok = false;
> +	/*
> +	 * By default ECI driver leaves microphone off, to save power.
> +	 * Audio driver can set microphone on by using
> +	 * hsmic_event.event
> +	 */
> +	eci->mic_state = ECI_MIC_OFF;
> +
> +	/* Init buttons_data indexes and buffer */
> +	memset(&eci->buttons_data, 0, sizeof(struct eci_buttons_data));
> +	eci->buttons_data.buttons = 0xffffffff;
> +
> +	return 0;
> +
> +err_input:
> +	eci_uninitialize_debugfs();
> +	sysfs_remove_group(&pdev->dev.kobj, &eci_attr_group);
> +
> +err_sysfs:
> +	misc_deregister(&eci_device);
> +
> +err_misc:
> +	kfree(eci);
> +
> +	return ret;
> +}
> +
> +static int __exit eci_remove(struct platform_device *pdev)
> +{
> +	struct eci_data *eci = platform_get_drvdata(pdev);
> +	struct eci_platform_data *pdata = pdev->dev.platform_data;
> +
> +	pdata->register_hsmic_event_cb(NULL);
> +	cancel_delayed_work_sync(&eci->eci_ws);
> +	eci_uninitialize_debugfs();
> +	sysfs_remove_group(&pdev->dev.kobj, &eci_attr_group);
> +	remove_accessory_input(eci);
> +	kfree(eci);
> +	misc_deregister(&eci_device);
> +
> +	return 0;
> +}
> +
> +#ifdef	CONFIG_PM
> +
> +static int eci_suspend(struct platform_device *pdev, pm_message_t mesg)
> +{
> +	return -ENOSYS;
> +}
> +#else
> +#define	eci_suspend	NULL
> +#endif
> +
> +static struct platform_driver eci_driver = {
> +	.probe		= eci_probe,
> +	.remove		= __exit_p(eci_remove),
> +	.suspend	= eci_suspend,
> +	.driver		= {
> +		.name	= ECI_DRIVERNAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init eci_init(void)
> +{
> +	return platform_driver_register(&eci_driver);
> +}
> +device_initcall(eci_init);
> +
> +static void __exit eci_exit(void)
> +{
> +	platform_driver_unregister(&eci_driver);
> +}
> +module_exit(eci_exit);
> +
> +MODULE_ALIAS("platform:" ECI_DRIVERNAME);
> +MODULE_AUTHOR("Nokia Corporation");
> +MODULE_DESCRIPTION("ECI accessory driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/input/eci.h b/include/linux/input/eci.h
> new file mode 100644
> index 0000000..b8be99c
> --- /dev/null
> +++ b/include/linux/input/eci.h
> @@ -0,0 +1,157 @@
> +/*
> + * This file is part of ECI (Enhancement Control Interface) driver
> + *
> + * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
> + *
> + * Contact: Tapio Vihuri <tapio.vihuri@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +#ifndef __ECI_H__
> +#define __ECI_H__
> +
> +#define ECI_MAX_MEM_SIZE	0x7c
> +#define ECI_BUTTON_BUF_SIZE	32
> +#define ECI_MAX_FEATURE_COUNT	31
> +
> +#define ACI_COMMERR	0x010
> +#define ACI_FRAERR	0x020
> +#define ACI_RESERR	0x040
> +#define ACI_COLL	0x080
> +
> +#define ECI_REAL_BUTTONS	0
> +#define ECI_FORCE_BUTTONS_UP	1
> +
> +/* fixed in ECI HW, do not change */
> +enum {
> +	ECICMD_HWID,
> +	ECICMD_SWID,
> +	ECICMD_ECI_BUS_SPEED,
> +	ECICMD_MIC_CTRL,
> +	ECICMD_MASTER_INT_REG,
> +	ECICMD_HW_CONF_MEM_ACCESS,
> +	ECICMD_EXTENDED_MEM_ACCESS,
> +	ECICMD_INDIRECT_MEM_ACCESS,
> +	ECICMD_PORT_DATA_0,
> +	ECICMD_PORT_DATA_1,
> +	ECICMD_PORT_DATA_2,
> +	ECICMD_PORT_DATA_3,
> +	ECICMD_LATCHED_PORT_DATA_0,
> +	ECICMD_LATCHED_PORT_DATA_1,
> +	ECICMD_LATCHED_PORT_DATA_2,
> +	ECICMD_LATCHED_PORT_DATA_3,
> +	ECICMD_DATA_DIR_0,
> +	ECICMD_DATA_DIR_1,
> +	ECICMD_DATA_DIR_2,
> +	ECICMD_DATA_DIR_3,
> +	ECICMD_INT_CONFIG_0_LOW,
> +	ECICMD_INT_CONFIG_0_HIGH,
> +	ECICMD_INT_CONFIG_1_LOW,
> +	ECICMD_INT_CONFIG_1_HIGH,
> +	ECICMD_INT_CONFIG_2_LOW,
> +	ECICMD_INT_CONFIG_2_HIGH,
> +	ECICMD_INT_CONFIG_3_LOW,
> +	ECICMD_INT_CONFIG_3_HIGH,
> +	/*
> +	 * 0x1c - 0x2f reserved for future
> +	 * 0x30 - 0x3d reserved
> +	 */
> +	ECICMD_EEPROM_LOCK = 0x3e,
> +	ECICMD_RESERVED,	/* 0x3f */
> +	ECIREG_STATUS,		/* 0x40 */
> +	ECIREG_READ_COUNT,	/* 0x41 */
> +	ECIREG_BUF_COUNT,	/* 0x42 */
> +	ECIREG_RST_LEARN,	/* 0x43 */
> +	/* 0x44 - 0xdf as data buffer */
> +	ECIREG_READ_DIRECT,	/* 0x44 */
> +	ECIREG_HW_ID = 0xe0,	/* 0xe0 */
> +	ECIREG_FW_ID,		/* 0xe1 */
> +	ECIREG_TEST_IN,		/* 0xe2 */
> +	ECIREG_TEST_OUT,	/* 0xe3 */
> +};
> +
> +enum {
> +	ECI_EVENT_IS_ECI,
> +	ECI_EVENT_PLUG_IN,
> +	ECI_EVENT_PLUG_OUT,
> +	ECI_EVENT_BUTTON,
> +	ECI_EVENT_NO,
> +};
> +
> +struct eci_hw_ops {
> +	int (*acc_reset)(void);
> +	int (*acc_read_direct)(u8 addr, char *buf);
> +	int (*acc_read_reg)(u8 reg, u8 *buf, int count);
> +	int (*acc_write_reg)(u8 reg, u8 param);
> +};
> +
> +struct eci_cb {
> +	void *priv;
> +	void (*event)(int event, void *priv);
> +};
> +
> +struct audio_hsmic_event {
> +	void *private;
> +	void (*event)(void *priv, bool on);
> +};
> +
> +struct eci_platform_data {
> +	void (*register_hsmic_event_cb)(struct audio_hsmic_event *);
> +};
> +
> +struct enchancement_features_fixed {
> +	u8	block_id;
> +	u8	length;
> +	u8	connector_conf;
> +	u8	number_of_features;
> +};
> +
> +struct enchancement_features_variable {
> +	u8	*io_support;
> +	u8	*io_functionality;
> +	u8	*active_state;
> +};
> +
> +struct eci_buttons_data {
> +	u32	buttons;
> +	int	windex;
> +	int	rindex;
> +	u32	buttons_up_mask;
> +	u32	buttons_buf[ECI_BUTTON_BUF_SIZE];
> +};
> +
> +struct eci_data {
> +	struct device				*dev;
> +	struct delayed_work			eci_ws;
> +	wait_queue_head_t			 wait;
> +	struct input_dev			*acc_input;
> +	int					event;
> +	bool					first_event;
> +	bool					mem_ok;
> +	u16					mem_size;
> +	u8					memory[ECI_MAX_MEM_SIZE];
> +	struct enchancement_features_fixed	*e_features_fix;
> +	struct enchancement_features_variable	e_features_var;
> +	u8					port_reg_count;
> +	struct eci_buttons_data			buttons_data;
> +	struct eci_hw_ops			*eci_hw_ops;
> +	u8					mic_state;
> +	bool					plugged;
> +	bool					is_eci;
> +};
> +
> +struct eci_cb *eci_register(struct eci_hw_ops *eci_ops);
> +#endif
> -- 
> 1.6.5
> 

Thank you.

-- 
Dmitry
