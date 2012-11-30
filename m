Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030639Ab2K3PMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:12:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43317 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab2K3PM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:12:29 -0500
Date: Fri, 30 Nov 2012 17:04:37 +0200
From: Felipe Balbi <balbi@ti.com>
To: Li Wu <willy.woo@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Li Wu <li.wu@st.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Shawn Landden <shawnlandden@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jianchun <jcbian@pixcir.com.cn>, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <device-drivers-devel@blackfin.uclinux.org>, <victor.phay@st.com>
Subject: Re: [PATCH 1/1] Input: STMicroelectronics multi touch capacitive
 touchscreen ftk
Message-ID: <20121130150437.GE17587@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1354285134-8188-1-git-send-email-willy.woo@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wb5NtZlyOqqy58h0"
Content-Disposition: inline
In-Reply-To: <1354285134-8188-1-git-send-email-willy.woo@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Wb5NtZlyOqqy58h0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 30, 2012 at 09:18:54AM -0500, Li Wu wrote:
> This is a initial driver for STMicroelectronics multi touch
> capacitive touchscren FingertipK. It supports maximum 10 fingers,
> based on I2C interface.
>=20
> Tested on Beagleboard, Android ICS.
>=20
> Signed-off-by: Li Wu <willy.woo@gmail.com>
> ---
>  MAINTAINERS                        |    8 +
>  drivers/input/touchscreen/Kconfig  |   11 +
>  drivers/input/touchscreen/Makefile |    1 +
>  drivers/input/touchscreen/ftk.c    |  792 ++++++++++++++++++++++++++++++=
++++++
>  4 files changed, 812 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/touchscreen/ftk.c
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9386a63..3f5398f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -314,6 +314,14 @@ W:	http://wiki.analog.com/AD7879
>  S:	Supported
>  F:	drivers/input/touchscreen/ad7879.c
> =20
> +STM FTK TOUCHSCREEN DRIVER
> +M:      Li Wu <li.wu@st.com>
> +L:      device-drivers-devel@blackfin.uclinux.org
> +W:      http://www.st.com
> +S:      Supported
> +F:      drivers/input/touchscreen/ftk.c
> +
> +
>  ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR)
>  M:	Jiri Kosina <jkosina@suse.cz>
>  S:	Maintained
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscree=
n/Kconfig
> index f7668b2..c81e2e7 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -900,4 +900,15 @@ config TOUCHSCREEN_TPS6507X
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called tps6507x_ts.
> =20
> +config TOUCHSCREEN_FTK
> +        tristate "STMicroelectronics i2c multitouch touchscreen with Fin=
gerTipK"
> +        depends on I2C
> +        help
> +          Say Y here to enable STMicroelectronics touchscreen support.
> +
> +          If unsure, say N.
> +
> +          To compile this driver as a module, choose M here: the
> +          module will be called STM_ts.
> +
>  endif
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscre=
en/Makefile
> index 178eb12..6feba9b 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -73,3 +73,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+=3D mainsto=
ne-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+=3D zylonite-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+=3D w90p910_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+=3D tps6507x-ts.o
> +obj-$(CONFIG_TOUCHSCREEN_FTK)           +=3D ftk.o
> diff --git a/drivers/input/touchscreen/ftk.c b/drivers/input/touchscreen/=
ftk.c
> new file mode 100644
> index 0000000..7c995f6
> --- /dev/null
> +++ b/drivers/input/touchscreen/ftk.c
> @@ -0,0 +1,792 @@
> +/*
> + * drivers/input/touchscreen/ftk.c
> + *
> + * Driver for STMicroelectronics FTK capacity touchscreen
> + *
> + * Author: JH Jang <jh.jang@st.com>
> + *         Victor Phay <victor.phay@st.com>
> + *	   Li Wu <li.wu@st.com>, <willy.woo@gmail.com>
> + *
> + * Copyright (c) 2012 STMicroelectronics Limited
> + *
> + * This program is free software; you can redistribute  it and/or modify=
 it
> + * under  the terms of  the GNU General  Public License as published by =
the
> + * Free Software Foundation;  either version 2 of the  License, or (at y=
our
> + * option) any later version.
> + *
> + */
> +
> +#include <linux/ctype.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/firmware.h>
> +#include <linux/fs.h>
> +#include <linux/gpio.h>
> +#include <linux/hrtimer.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-dev.h>
> +#include <linux/init.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/serio.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +
> +/*
> + * Definitions & global arrays.
> + */
> +#define DRIVER_DESC                   "ftk i2c touchscreen driver"
> +#define ftk_TS_DRV_NAME               "ftk"
> +#define X_AXIS_MAX                    800
> +#define X_AXIS_MIN                    0
> +#define Y_AXIS_MAX                    480
> +#define Y_AXIS_MIN                    0
> +#define PRESSURE_MIN                  0
> +#define PRESSURE_MAX                  256
> +#define P70_PATCH_ADDR_START          0x00420000
> +#define LEAVE_EVENT                   0x04
> +#define ENTER_EVENT                   0x03
> +#define MOTION_EVENT                  0x05
> +#define RESET_EVENT                   0x10
> +#define MAX_SUPPORTED_FINGERS         10
> +#define MAX_TRANSACTION_LENGTH        8
> +
> +static struct i2c_driver stm_ts_driver;
> +static struct workqueue_struct *stmtouch_wq;
> +static int cor_xyz[10][3];
> +static unsigned char ID_Indx[10] =3D {

no CaMeLcAsE please.

> +	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
> +};

no need to initialize this since it's static.

> +
> +struct B0_write {

no CaMeLcAsE please.

> +	u8 addr;
> +	u8 val;
> +};
> +
> +struct ftk_i2c_platform_data {
> +	int (*power)(int on);
> +};
> +
> +struct ftk_ts {
> +	struct device *dev;
> +	struct i2c_client *client;
> +	struct input_dev *input_dev;
> +	struct hrtimer timer;
> +	struct work_struct work;
> +	spinlock_t lock;
> +	int x;
> +	int y;
> +	int z;
> +	int irq;
> +	int (*power)(int on);
> +#ifdef CONFIG_HAS_EARLYSUSPEND
> +	struct early_suspend early_suspend;
> +#endif

I can't find the definition for struct early_suspend anywhere, not even
on linux-next. Can you point me to the patch adding it ?

> +};
> +
> +#ifdef CONFIG_HAS_EARLYSUSPEND
> +static void stm_ts_early_suspend(struct early_suspend *h);
> +static void stm_ts_late_resume(struct early_suspend *h);
> +#endif
> +
> +static int ftk_write_reg(struct ftk_ts *ftk_ts, u8 *reg, u16 num_com);
> +static int ftk_read_reg(struct ftk_ts *ftk_ts, u8 *reg, int cnum, u8 *bu=
f,
> +			int num);
> +static void touch_ON(struct ftk_ts *ftkts, int x, int y, int z, int id);
> +static void touch_OFF(struct ftk_ts *ftkts);
> +static u8 load_config(struct ftk_ts *ftk_ts, const struct firmware *firm=
ware);
> +static u8 load_patch(struct ftk_ts *ftk_ts, const struct firmware *firmw=
are);
> +static int verify_firmware(const struct firmware *firmware);
> +static int init_ftk(struct ftk_ts *ftk_ts);
> +static enum hrtimer_restart st_ts_timer_func(struct hrtimer *timer);
> +static irqreturn_t ts_interrupt(int irq, void *handle);
> +static u8 decode_data_packet(struct ftk_ts *ftkts, unsigned char data[],
> +			     unsigned char LeftEvent);
> +static void ts_tasklet_proc(struct work_struct *work);
> +static int stm_ts_probe(struct i2c_client *client,
> +			const struct i2c_device_id *idp);
> +static int stm_ts_remove(struct i2c_client *client);
> +static int stm_ts_suspend(struct i2c_client *client, pm_message_t mesg);
> +static int stm_ts_resume(struct i2c_client *client);
> +static int __init stm_ts_init(void);
> +static void __exit stm_ts_exit(void);

make sure to organize your source code correctly so you don't need to
declare a prototype for every single function here.

> +static int ftk_write_reg(struct ftk_ts *ftk_ts, u8 *reg, u16 num_com)
> +{
> +	struct i2c_msg xfer_msg[2];
> +
> +	xfer_msg[0].addr =3D ftk_ts->client->addr;
> +	xfer_msg[0].len =3D num_com;
> +	xfer_msg[0].flags =3D 0;
> +	xfer_msg[0].buf =3D reg;
> +
> +	return i2c_transfer(ftk_ts->client->adapter, xfer_msg, 1);

Doesn't this controller support smbus ?

> +}
> +
> +

one blank line only.

> +static int ftk_read_reg(struct ftk_ts *ftk_ts, u8 *reg, int cnum, u8 *bu=
f,
> +			int num)
> +{
> +	u16 left =3D num;
> +	u16 offset =3D 0;
> +
> +	struct i2c_msg xfer_msg[2];
> +
> +	xfer_msg[0].addr =3D ftk_ts->client->addr;
> +	xfer_msg[0].len =3D cnum;
> +	xfer_msg[0].flags =3D 0;
> +	xfer_msg[0].buf =3D reg;
> +
> +	xfer_msg[1].addr =3D ftk_ts->client->addr;
> +	xfer_msg[1].flags =3D I2C_M_RD;
> +
> +	/* MTK platform */
> +	/* Can only transfer 8 bytes per transaction */
> +	while (left > 0) {
> +		xfer_msg[1].buf =3D &buf[offset];
> +
> +		if (left > MAX_TRANSACTION_LENGTH) {
> +			xfer_msg[1].len =3D MAX_TRANSACTION_LENGTH;
> +			left -=3D MAX_TRANSACTION_LENGTH;
> +			offset +=3D MAX_TRANSACTION_LENGTH;
> +		} else {
> +			xfer_msg[1].len =3D left;
> +			left =3D 0;
> +		}
> +
> +		if (i2c_transfer(ftk_ts->client->adapter, xfer_msg, 2) !=3D 2) {
> +			dev_err(ftk_ts->dev, "FTK - i2c Transfer error!\n");
> +			return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +
> +static void touch_ON(struct ftk_ts *ftkts, int x, int y, int z, int id)
> +{
> +	input_report_key(ftkts->input_dev, BTN_TOUCH, 1);
> +	input_report_abs(ftkts->input_dev, ABS_MT_POSITION_X, x);
> +	input_report_abs(ftkts->input_dev, ABS_MT_POSITION_Y, y);
> +	input_report_abs(ftkts->input_dev, ABS_MT_TOUCH_MAJOR, z);
> +	input_report_abs(ftkts->input_dev, ABS_MT_TRACKING_ID, id);
> +	input_mt_sync(ftkts->input_dev);
> +}
> +
> +
> +static void touch_OFF(struct ftk_ts *ftkts)

all lower cases.

> +{
> +	input_report_key(ftkts->input_dev, BTN_TOUCH, 0);
> +	input_report_abs(ftkts->input_dev, ABS_MT_TRACKING_ID, 0);
> +	input_mt_sync(ftkts->input_dev);
> +}
> +
> +
> +static u8 load_config(struct ftk_ts *ftk_ts, const struct firmware *firm=
ware)
> +{
> +	u16 one_group_length =3D 0;
> +	u16 patch_length =3D 0;
> +	u16 config_length =3D 0;
> +	u16 i =3D 0;
> +	u8 *pdata;
> +	u8 regAdd[8];
> +	u8 val[8];
> +	int ret;
> +
> +	patch_length =3D firmware->data[0] * 256 + firmware->data[1];
> +	config_length =3D
> +		firmware->data[patch_length + 2] * 256 +
> +		firmware->data[patch_length + 2 + 1];
> +	pdata =3D (u8 *)&firmware->data[patch_length + 4];
> +
> +	while (i < config_length) {
> +		one_group_length =3D pdata[i] * 256 + pdata[i + 1];
> +
> +		if ((pdata[i + 2] =3D=3D 0xFF) && (pdata[i + 3] =3D=3D 0xFF))
> +			mdelay(pdata[i + 4]);
> +		else{
> +			ftk_write_reg(ftk_ts, &(pdata[i + 2]),
> +				      one_group_length);
> +			mdelay(100);
> +		}
> +
> +		i =3D i + 2;
> +		i =3D i + one_group_length;
> +	}
> +
> +	regAdd[0] =3D 0xB0;
> +	regAdd[1] =3D 0x05;       /* Set Interrupt Polarity */
> +	regAdd[2] =3D 0x00;       /* '00' - level interrupt */
> +				/* '02' - edge interrupt */
> +	ftk_write_reg(ftk_ts, &regAdd[0], 3);
> +	mdelay(5);
> +
> +	regAdd[0] =3D 0xB0;
> +	regAdd[1] =3D 0x06;       /* Enable Touch Detect Interrupt */
> +	regAdd[2] =3D 0x40;       /* 0xC0 */
> +	ftk_write_reg(ftk_ts, &regAdd[0], 3);
> +	mdelay(5);
> +
> +	regAdd[0] =3D 0xB0;
> +	regAdd[1] =3D 0x07;	/* Read 0x07 to clear ISR */
> +	ret =3D ftk_read_reg(ftk_ts, &regAdd[0], 2, &val[0], 1);
> +	mdelay(5);
> +
> +	regAdd[0] =3D 0x85;
> +	ret =3D ftk_read_reg(ftk_ts, &regAdd[0], 1, &val[0], 8);
> +	mdelay(20);
> +
> +	regAdd[0] =3D 0x85;
> +	ret =3D ftk_read_reg(ftk_ts, &regAdd[0], 1, &val[0], 8);
> +	mdelay(20);
> +
> +	regAdd[0] =3D 0xB0;
> +	regAdd[1] =3D 0x03;
> +	ret =3D ftk_read_reg(ftk_ts, regAdd, 2, val, 1);
> +	mdelay(5);
> +	dev_info(ftk_ts->dev, "Patch loaded, Version =3D%X\n", val[0]);
> +
> +	regAdd[0] =3D 0x83;	/* TS Sense on */
> +	regAdd[1] =3D 0x00;

no magic constants, ever. Please define symbolic constants for
everything.

> +	ret =3D ftk_write_reg(ftk_ts, &regAdd[0], 1);
> +	mdelay(5);
> +	return ret;
> +}
> +
> +
> +static u8 load_patch(struct ftk_ts *ftk_ts, const struct firmware *firmw=
are)
> +{
> +	u32 writeAddr, j =3D 0, i =3D 0;
> +	u16 patch_length =3D 0;
> +	u8 byteWork1[256 + 3] =3D { 0 };
> +	u8 regAdd[3] =3D { 0 };
> +
> +	patch_length =3D firmware->data[0] * 256 + firmware->data[1];
> +
> +	while (j < patch_length) {
> +		writeAddr =3D P70_PATCH_ADDR_START + j;
> +
> +		regAdd[0] =3D 0xB3;
> +		regAdd[1] =3D (writeAddr >> 24) & 0xFF;
> +		regAdd[2] =3D (writeAddr >> 16) & 0xFF;
> +		ftk_write_reg(ftk_ts, &regAdd[0], 3);
> +
> +		byteWork1[0] =3D 0xB1;
> +		byteWork1[1] =3D (writeAddr >> 8) & 0xFF;
> +		byteWork1[2] =3D writeAddr & 0xFF;
> +
> +		i =3D 0;
> +		while ((j < firmware->size) && (i < 256)) {
> +			byteWork1[i + 3] =3D firmware->data[j + 2];
> +			i++;
> +			j++;
> +		}
> +		ftk_write_reg(ftk_ts, &byteWork1[0], 256 + 3);
> +	}
> +
> +	return 0;
> +}
> +
> +
> +static int verify_firmware(const struct firmware *firmware)
> +{
> +	u16 firmware_length;
> +	u16 patch_length;
> +	u16 config_length;
> +
> +	firmware_length =3D firmware->size;
> +	patch_length =3D firmware->data[0] * 256 + firmware->data[1];
> +	config_length =3D
> +		firmware->data[patch_length + 2] * 256 +
> +		firmware->data[patch_length + 2 + 1];
> +
> +	if (firmware_length =3D=3D patch_length + config_length + 4)
> +		return 0;
> +	else
> +		return -1;
> +}
> +
> +
> +static int init_ftk(struct ftk_ts *ftk_ts)
> +{
> +	const struct firmware *firmware;
> +	u8 regAdd[7];
> +	u8 val[8];
> +	int ret;
> +
> +	regAdd[0] =3D 0xB0;
> +	regAdd[1] =3D 0x00;
> +	ret =3D ftk_read_reg(ftk_ts, regAdd, 2, val, 3);
> +
> +	if (ret < 0)
> +		dev_err(ftk_ts->dev, " i2c_transfer failed\n");

why the space before the actual message ?

> +
> +	mdelay(1);
> +	dev_info(ftk_ts->dev, "Chip ID =3D %x %x %x\n", val[0], val[1], val[2]);

how about dev_dbg() ?

> +
> +	regAdd[0] =3D 0x9E; /* TS Soft Reset */
> +	ret =3D ftk_write_reg(ftk_ts, &regAdd[0], 1);
> +	mdelay(1);
> +
> +	ret =3D request_firmware(&firmware, "ftk/ftk.bin", ftk_ts->dev);
> +	if (ret < 0)
> +		dev_err(ftk_ts->dev, " request fw fail ,err =3D %d\n", ret);
> +	else{
> +		ret =3D verify_firmware(firmware);
> +		if (ret =3D=3D 0) {
> +			load_patch(ftk_ts, firmware);
> +			load_config(ftk_ts, firmware);
> +		}
> +	}

istead of if...else you can exit early if request_firmware() fails. That
will decrease the indentation a bit.

> +
> +	release_firmware(firmware);
> +
> +	regAdd[0] =3D 0xB3;
> +	regAdd[1] =3D 0xFF;
> +	regAdd[2] =3D 0xFF;
> +	ftk_write_reg(ftk_ts, &regAdd[0], 3);
> +	mdelay(5);

you need to add a comment to this mdelay().

> +
> +	regAdd[0] =3D 0xA0;
> +	ftk_write_reg(ftk_ts, &regAdd[0], 1);
> +	mdelay(5);
> +
> +	if (ret < 0)
> +		dev_err(ftk_ts->dev, "ftk Not Initialised\n");
> +	else
> +		dev_info(ftk_ts->dev, "ftk Initialised\n");

dev_dbg() ?

> +
> +	return 0;
> +}
> +
> +

one blank line only (ditto to all below)

> +static enum hrtimer_restart st_ts_timer_func(struct hrtimer *timer)
> +{
> +	struct ftk_ts *ftkts =3D container_of(timer, struct ftk_ts, timer);
> +
> +	queue_work(stmtouch_wq, &ftkts->work);
> +	return HRTIMER_NORESTART;
> +}
> +
> +
> +static irqreturn_t ts_interrupt(int irq, void *handle)
> +{
> +	struct ftk_ts *ftk_ts =3D handle;
> +
> +	disable_irq_nosync(ftk_ts->client->irq);
> +	queue_work(stmtouch_wq, &ftk_ts->work);

really ??? you need to use threaded IRQ instead.

> +	return IRQ_HANDLED;
> +}
> +
> +
> +static u8 decode_data_packet(struct ftk_ts *ftkts, unsigned char data[],
> +			     unsigned char LeftEvent)
> +{
> +	u8 EventNum;
> +	u8 TouchID, EventID;
> +	u8 LastLeftEvent =3D 0;
> +	u8 i, num_released_finger;
> +	u8 valid_id =3D 0;
> +
> +	for (EventNum =3D 0; EventNum < LeftEvent; EventNum++) {

no CaMeLcAsE (ditto to all other instances of this).

> +		LastLeftEvent =3D data[7 + EventNum * 8] & 0x0F;
> +		TouchID =3D data[1 + EventNum * 8] & 0x0F;
> +		EventID =3D data[EventNum * 8] & 0xFF;
> +
> +		if ((EventID =3D=3D LEAVE_EVENT) || (EventID =3D=3D ENTER_EVENT) ||
> +		    (EventID =3D=3D MOTION_EVENT)) {
> +			/* Enter, Leave or Motion Event */
> +
> +			if (TouchID < MAX_SUPPORTED_FINGERS) {
> +				valid_id =3D 1;
> +
> +				ID_Indx[TouchID] =3D EventID;
> +				cor_xyz[TouchID][0] =3D
> +					((data[4 + EventNum *
> +					       8] &
> +					  0xF0) >>
> +					 4) | ((data[2 + EventNum * 8]) << 4);
> +				cor_xyz[TouchID][1] =3D
> +					((data[4 + EventNum *
> +					       8] &
> +					  0x0F) |
> +					 ((data[3 + EventNum * 8]) << 4));
> +				cor_xyz[TouchID][2] =3D data[5 + EventNum * 8];
> +			}
> +		} else if (EventID =3D=3D RESET_EVENT) {
> +			/* Reset happened */
> +			for (i =3D 0; i < MAX_SUPPORTED_FINGERS; i++)
> +				ID_Indx[i] =3D 0;
> +
> +			touch_OFF(ftkts);
> +
> +			input_sync(ftkts->input_dev);
> +			init_ftk(ftkts);
> +			return 0;
> +		}
> +	}
> +
> +	if (valid_id) {
> +		/* Report all fingers on panel */
> +		/* ---------------------------------- */
> +		num_released_finger =3D 0;
> +		for (i =3D 0; i < MAX_SUPPORTED_FINGERS; i++) {
> +			if (ID_Indx[i]) {
> +				if (ID_Indx[i] =3D=3D LEAVE_EVENT) {
> +					ID_Indx[i] =3D 0;
> +					num_released_finger++;
> +				}
> +
> +				touch_ON(ftkts, cor_xyz[i][0], cor_xyz[i][1],
> +					 cor_xyz[i][2],
> +					 i);
> +			} else
> +				num_released_finger++;
> +		}
> +
> +		input_sync(ftkts->input_dev);
> +		/* ---------------------------------- */
> +
> +		/* Check if all fingers are released */
> +		/* ---------------------------------- */
> +		if (num_released_finger =3D=3D MAX_SUPPORTED_FINGERS) {
> +			/* All fingers are released */
> +			touch_OFF(ftkts);
> +			input_sync(ftkts->input_dev);
> +		}
> +		/* ---------------------------------- */
> +	}
> +
> +	return LastLeftEvent;
> +}
> +
> +
> +static void ts_tasklet_proc(struct work_struct *work)
> +{
> +	struct ftk_ts *ftkts =3D container_of(work, struct ftk_ts, work);
> +
> +	unsigned char data[256];
> +	int ret;
> +	u8 status;
> +	u8 regAdd;
> +	u8 i;
> +	u8 FirstLeftEvent =3D 0;
> +
> +	data[0] =3D 0xB0;
> +	data[1] =3D 0x07;
> +	ret =3D ftk_read_reg(ftkts, &data[0], 2, &status, 1);
> +
> +	if (status & 0x40) {
> +		regAdd =3D 0x85;
> +		if (ftk_read_reg(ftkts, &regAdd, 1, data, 8) =3D=3D 0) {
> +			FirstLeftEvent =3D decode_data_packet(ftkts, data, 1);
> +
> +			/* Read and process 1 event (8bytes) at a time */
> +			for (i =3D 0; i < FirstLeftEvent; i++) {
> +				regAdd =3D 0x85;
> +				if (ftk_read_reg(ftkts, &regAdd, 1, data,
> +						 8) =3D=3D 0)
> +					FirstLeftEvent =3D decode_data_packet(
> +						ftkts, data, 1);
> +			}
> +		}
> +	}
> +
> +	if (!ftkts->irq)
> +		hrtimer_start(&ftkts->timer, ktime_set(0, 10000000),
> +			      HRTIMER_MODE_REL);
> +	else
> +		enable_irq(ftkts->client->irq);
> +}
> +
> +
> +static int stm_ts_probe(struct i2c_client *client,
> +			const struct i2c_device_id *idp)
> +{
> +	struct ftk_ts *ftk_ts =3D NULL;
> +	struct ftk_i2c_platform_data *pdata;
> +	int ret =3D 0;
> +	int err =3D 0;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(ftk_ts->dev, "err =3D EIO!\n");
> +		err =3D EIO;
> +		goto fail;
> +	}
> +
> +	ftk_ts =3D kzalloc(sizeof(struct ftk_ts), GFP_KERNEL);

devm_kzalloc().

> +	if (!ftk_ts) {
> +		dev_err(ftk_ts->dev, "err =3D ENOMEM!\n");
> +		err =3D ENOMEM;
> +		goto fail;
> +	}
> +
> +	INIT_WORK(&ftk_ts->work, ts_tasklet_proc);
> +
> +	ftk_ts->client =3D client;
> +	i2c_set_clientdata(client, ftk_ts);
> +
> +	pdata =3D client->dev.platform_data;
> +
> +	if (pdata)
> +		ftk_ts->power =3D pdata->power;
> +
> +	if (ftk_ts->power) {
> +		ret =3D ftk_ts->power(1);
> +
> +		pdata->power(1);
> +
> +		if (ret < 0) {
> +			pr_err("ftk_probe power on failed\n");
> +			goto fail;
> +		}
> +	}
> +
> +	ftk_ts->dev =3D &ftk_ts->client->dev;
> +	ftk_ts->input_dev =3D input_allocate_device();
> +	ftk_ts->input_dev->dev.parent =3D &client->dev;
> +	if (!ftk_ts->input_dev) {
> +		dev_err(ftk_ts->dev, "err =3D ENOMEM!\n");
> +		err =3D ENOMEM;
> +		goto fail;
> +	}
> +	ftk_ts->input_dev->name =3D "ftk";
> +	ftk_ts->input_dev->phys =3D "ftk/input0";
> +	ftk_ts->input_dev->id.bustype =3D BUS_I2C;
> +	ftk_ts->input_dev->id.vendor =3D 0x0001;
> +	ftk_ts->input_dev->id.product =3D 0x0002;
> +	ftk_ts->input_dev->id.version =3D 0x0100;
> +
> +	ftk_ts->input_dev->evbit[0] =3D BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +	ftk_ts->input_dev->keybit[BIT_WORD(BTN_TOUCH)] =3D BIT_MASK(BTN_TOUCH);
> +	set_bit(EV_SYN, ftk_ts->input_dev->evbit);
> +	set_bit(EV_KEY, ftk_ts->input_dev->evbit);
> +	set_bit(BTN_TOUCH, ftk_ts->input_dev->keybit);
> +	set_bit(BTN_2, ftk_ts->input_dev->keybit);
> +	set_bit(EV_ABS, ftk_ts->input_dev->evbit);
> +
> +	input_set_abs_params(ftk_ts->input_dev, ABS_X, X_AXIS_MIN, X_AXIS_MAX,
> +			     0, 0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_Y, Y_AXIS_MIN, Y_AXIS_MAX,
> +			     0, 0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_PRESSURE, PRESSURE_MIN,
> +			     PRESSURE_MAX, 0, 0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_MT_TRACKING_ID, 0, 10, 0,
> +			     0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_MT_TOUCH_MAJOR,
> +			     PRESSURE_MIN, PRESSURE_MAX, 0, 0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_MT_WIDTH_MAJOR,
> +			     PRESSURE_MIN, PRESSURE_MAX, 0, 0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_MT_POSITION_X, X_AXIS_MIN,
> +			     X_AXIS_MAX, 0, 0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_MT_POSITION_Y, Y_AXIS_MIN,
> +			     Y_AXIS_MAX, 0, 0);
> +
> +	err =3D input_register_device(ftk_ts->input_dev);
> +	if (err) {
> +		dev_err(ftk_ts->dev, "input_register_device fail!\n");
> +		goto fail;
> +	}
> +
> +	err =3D init_ftk(ftk_ts);
> +	if (err) {
> +		dev_err(ftk_ts->dev, "init_ftk  fail!\n");
> +		goto fail;
> +	}
> +
> +	ftk_ts->irq =3D client->irq;
> +
> +	if (!ftk_ts->irq) {
> +		hrtimer_init(&ftk_ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +		ftk_ts->timer.function =3D st_ts_timer_func;
> +		hrtimer_start(&ftk_ts->timer, ktime_set(1, 0),
> +			      HRTIMER_MODE_REL);
> +	} else {
> +		if (request_irq
> +			    (ftk_ts->irq, ts_interrupt, IRQF_TRIGGER_LOW,
> +			    client->name, ftk_ts)) {

make this:

ret =3D devm_request_threaded_irq(ftk_ts->irq, NULL, ts_interrupt,
	IRQF_TRIGGER_LOW | IRQF_ONESHOT, client->name, ftks_ts);
if (ret) {
	...

> +			dev_err(ftk_ts->dev, "request_irq  fail!\n");
> +			err =3D -EBUSY;
> +			goto fail;
> +		} else
> +			dev_info(ftk_ts->dev, "request_irq  success!\n");

drop this message, it's pretty much useless.

> +	}
> +
> +#ifdef CONFIG_HAS_EARLYSUSPEND
> +	ftk_ts->early_suspend.level =3D EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 1;
> +	ftk_ts->early_suspend.suspend =3D stm_ts_early_suspend;
> +	ftk_ts->early_suspend.resume =3D stm_ts_late_resume;
> +	register_early_suspend(&ftk_ts->early_suspend);
> +#endif
> +
> +	return 0;
> +fail:
> +	if (ftk_ts) {
> +		if (ftk_ts->input_dev)
> +			input_free_device(ftk_ts->input_dev);
> +		kfree(ftk_ts);
> +	}
> +	dev_info(ftk_ts->dev, "--ftkts_probe ret=3D%d\n", err);
> +	return err;
> +}
> +
> +
> +static int stm_ts_remove(struct i2c_client *client)
> +{
> +	struct ftk_ts *ts =3D i2c_get_clientdata(client);
> +
> +#ifdef CONFIG_HAS_EARLYSUSPEND
> +	unregister_early_suspend(&ts->early_suspend);
> +#endif
> +
> +	if (ts->irq)
> +		free_irq(client->irq, ts);
> +	else
> +		hrtimer_cancel(&ts->timer);
> +
> +	input_unregister_device(ts->input_dev);
> +	kfree(ts);
> +	return 0;
> +}
> +
> +
> +static int stm_ts_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	int ret, i;
> +	u8 regAdd[3];
> +
> +	struct ftk_ts *ts =3D i2c_get_clientdata(client);
> +
> +	if (ts->irq)
> +		disable_irq(client->irq);
> +	else
> +		hrtimer_cancel(&ts->timer);
> +
> +	ret =3D cancel_work_sync(&ts->work);
> +
> +	regAdd[0] =3D 0x80;
> +	regAdd[1] =3D 0x00;
> +	ret =3D ftk_write_reg(ts, &regAdd[0], 1);
> +	mdelay(5);
> +
> +	regAdd[0] =3D 0x88;
> +	regAdd[1] =3D 0x00;
> +	ret =3D ftk_write_reg(ts, &regAdd[0], 1);
> +	mdelay(5);
> +
> +	regAdd[0] =3D 0xB0;
> +	regAdd[1] =3D 0x06;
> +	regAdd[2] =3D 0x00;
> +	ret =3D ftk_write_reg(ts, &regAdd[0], 3);
> +	mdelay(5);
> +
> +	for (i =3D 0; i < 10; i++)
> +		ID_Indx[i] =3D 0;
> +
> +	input_mt_sync(ts->input_dev);
> +	input_sync(ts->input_dev);
> +
> +	if (ret < 0)
> +		dev_err(ts->dev, "stm_ts_suspend: i2c_smbus_write_byte_data failed\n");
> +
> +	return 0;
> +}
> +
> +
> +static int stm_ts_resume(struct i2c_client *client)
> +{
> +	int ret;
> +	u8 regAdd[3];
> +	struct ftk_ts *ts =3D i2c_get_clientdata(client);
> +
> +	if (ts->irq)
> +		enable_irq(client->irq);
> +	else
> +		hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
> +
> +	regAdd[0] =3D 0x81;
> +	regAdd[1] =3D 0x00;
> +	ret =3D ftk_write_reg(ts, &regAdd[0], 1);
> +	mdelay(5);
> +
> +	regAdd[0] =3D 0xB0;
> +	regAdd[1] =3D 0x06;
> +	regAdd[2] =3D 0x40;
> +	ret =3D ftk_write_reg(ts, &regAdd[0], 3);
> +	mdelay(5);
> +
> +	if (ret < 0)
> +		dev_err(ts->dev,
> +		       "stm_ts_suspend: i2c_smbus_write_byte_data failed\n");
> +
> +	return 0;
> +}
> +
> +
> +#ifdef CONFIG_HAS_EARLYSUSPEND
> +static void stm_ts_early_suspend(struct early_suspend *h)
> +{
> +	struct ftk_ts *ts;
> +
> +	ts =3D container_of(h, struct ftk_ts, early_suspend);
> +	stm_ts_suspend(ts->client, PMSG_SUSPEND);
> +}
> +
> +
> +static void stm_ts_late_resume(struct early_suspend *h)
> +{
> +	struct ftk_ts *ts;
> +
> +	ts =3D container_of(h, struct ftk_ts, early_suspend);
> +	stm_ts_resume(ts->client);
> +}
> +
> +
> +#endif
> +
> +static const struct i2c_device_id stm_ts_id[] =3D {
> +	{ "ftk", 0 },
> +	{}
> +};
> +
> +static struct i2c_driver stm_ts_driver =3D {
> +	.driver		=3D {
> +		.name	=3D "ftk",
> +	},
> +	.probe		=3D stm_ts_probe,
> +	.remove		=3D stm_ts_remove,
> +#ifndef CONFIG_HAS_EARLYSUSPEND
> +	.suspend	=3D stm_ts_suspend,
> +	.resume		=3D stm_ts_resume,
> +#endif
> +	.id_table	=3D stm_ts_id,
> +};
> +
> +static int __init stm_ts_init(void)
> +{
> +	stmtouch_wq =3D create_singlethread_workqueue("stmtouch_wq");

NAK. you don need this at all.

> +	if (!stmtouch_wq)
> +		return -ENOMEM;
> +
> +	return i2c_add_driver(&stm_ts_driver);
> +}
> +
> +
> +static void __exit stm_ts_exit(void)
> +{
> +	i2c_del_driver(&stm_ts_driver);
> +	if (stmtouch_wq)
> +		destroy_workqueue(stmtouch_wq);
> +}
> +
> +
> +MODULE_DESCRIPTION("STM MultiTouch IC Driver");
> +MODULE_AUTHOR("Li Wu <li.wu@st.com>");
> +MODULE_LICENSE("GPL");
> +
> +module_init(stm_ts_init);
> +module_exit(stm_ts_exit);

BTW, you could be used module_i2c_driver() instead.

--=20
balbi

--Wb5NtZlyOqqy58h0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJQuMsFAAoJEIaOsuA1yqREvRwP+KY1QcKvscEA9NQ8amLAa/OY
SFv6dD96AlxT+u7EOABux9UDLEuTNSH+dAdcCJ21FHyP5MWLl70HRBMfgYzAwDTr
GfOcVHxL5v2ROkbtS8j52J4nvvLtubZdNKpdjImSGzFFPuviNwq204YlU6TyJlxL
fJ76RZNGN2nFRr/VUO5zeh/RTOQg4ocAEAHEeL86eUHrT86l8VoxFirVZVnXNRB9
N0ob/Q9I3oe2XKoDI/Yn4rCtygAJ3Otb9jZcyE4muVzVItpDFfWCQKb3+dFWWUmF
U3zgM2oY/gJXSL9Y3qDX2sQm3JEKc3qEeqqQuiEn30G3uZW8dD4VKwExyK4OuyO9
n1gGsHtVjyAjMcKxHPZQ5XbHRZW4Z1/TX6T6qFxSlpAIUxBA6JfESaKU087cL/Cm
z6tw4IO0VNK0MBDrma2x/YIwtfSXU80BkwJ2g/zVphtCWOeT0MKksLtUslcNWV9h
LBOzC+uyILghBQEcYoCMTVxAJ9jdxFyBA/bx7eYnXdlfW2bro9fYu3Hp+fAOxixg
W2RkItNO5YCtda8x65Qul19JniN6C0EOzHO9yJE7LjysScxgQIJS/LxAmlr7Z3PQ
kj2qIVQypTQBWUxWSvK0Ot1+TAOuw4ZyrKzjWI4OeiFJxY+Wctbcgm9iI5a6QjkX
ZqasOK/ODLsBB96aRHs=
=LoSj
-----END PGP SIGNATURE-----

--Wb5NtZlyOqqy58h0--
