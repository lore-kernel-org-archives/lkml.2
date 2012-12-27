Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab2L0W5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:57:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56764 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab2L0W5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:57:42 -0500
Date: Fri, 28 Dec 2012 00:57:01 +0200
From: Felipe Balbi <balbi@ti.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-i2c@vger.kernel.org>,
        <naveenkrishna.ch@gmail.com>, <kgene.kim@samsung.com>,
        <grant.likely@secretlab.ca>, <w.sang@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <taeggyun.ko@samsung.com>,
        <balbi@ti.com>, <thomas.abraham@linaro.org>
Subject: Re: [PATCH 1/2] i2c: exynos5: add High Speed I2C controller driver
Message-ID: <20121227225701.GA12665@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1356434755-13702-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <1356434755-13702-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 25, 2012 at 04:55:54PM +0530, Naveen Krishna Chatradhi wrote:
> Adds support for High Speed I2C driver found in Exynos5 and later
> SoCs from Samsung. This driver currently supports Auto mode.
>=20
> Driver only supports Device Tree method.
>=20
> Signed-off-by: Taekgyun Ko <taeggyun.ko@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v1:
> Fixed the comments from Felipe Balbi and Thomas Abraham.
>=20
>  drivers/i2c/busses/Kconfig       |    7 +
>  drivers/i2c/busses/Makefile      |    1 +
>  drivers/i2c/busses/i2c-exynos5.c |  652 ++++++++++++++++++++++++++++++++=
++++++
>  drivers/i2c/busses/i2c-exynos5.h |  102 ++++++
>  4 files changed, 762 insertions(+)
>  create mode 100644 drivers/i2c/busses/i2c-exynos5.c
>  create mode 100644 drivers/i2c/busses/i2c-exynos5.h
>=20
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index bdca511..4caea76 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -618,6 +618,13 @@ config I2C_S3C2410
>  	  Say Y here to include support for I2C controller in the
>  	  Samsung SoCs.
> =20
> +config I2C_EXYNOS5
> +	tristate "Exynos5 high-speed I2C driver"
> +	depends on ARCH_EXYNOS5
> +	help
> +	  Say Y here to include support for High-speed I2C controller in the
> +	  Exynos5 based Samsung SoCs.
> +
>  config I2C_S6000
>  	tristate "S6000 I2C support"
>  	depends on XTENSA_VARIANT_S6000
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 6181f3f..4b1548c 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -61,6 +61,7 @@ obj-$(CONFIG_I2C_PUV3)		+=3D i2c-puv3.o
>  obj-$(CONFIG_I2C_PXA)		+=3D i2c-pxa.o
>  obj-$(CONFIG_I2C_PXA_PCI)	+=3D i2c-pxa-pci.o
>  obj-$(CONFIG_I2C_S3C2410)	+=3D i2c-s3c2410.o
> +obj-$(CONFIG_I2C_EXYNOS5)	+=3D i2c-exynos5.o
>  obj-$(CONFIG_I2C_S6000)		+=3D i2c-s6000.o
>  obj-$(CONFIG_I2C_SH7760)	+=3D i2c-sh7760.o
>  obj-$(CONFIG_I2C_SH_MOBILE)	+=3D i2c-sh_mobile.o
> diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-ex=
ynos5.c
> new file mode 100644
> index 0000000..7614f60
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-exynos5.c
> @@ -0,0 +1,652 @@
> +/* linux/drivers/i2c/busses/i2c-exynos5.c

no need for the full path. Generally this would look like:

* i2c-exynos5.c - Samsung Exynos 5 I2C Controller Driver

no strong feelings however.

> + * Copyright (C) 2012 Samsung Electronics Co., Ltd.
> + *
> + * High speed I2C controller driver
> + * for Exynos5 and later SoCs from Samsung.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/time.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/clk.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_i2c.h>
> +
> +#include "i2c-exynos5.h"

it doesn't look like this header is even needed. All those macros could
be defined here in the C-source file which is the only user.

> +#define EXYNOS5_I2C_TIMEOUT (msecs_to_jiffies(1000))
> +
> +/* timeout for pm runtime autosuspend */
> +#define EXYNOS5_I2C_PM_TIMEOUT		1000	/* ms */
> +
> +struct exynos5_i2c {
> +	struct i2c_adapter	adap;
> +	unsigned int		suspended:1;
> +
> +	struct i2c_msg		*msg;
> +	unsigned int		msg_idx;
> +	struct completion	msg_complete;
> +	unsigned int		msg_ptr;
> +
> +	unsigned int		irq;
> +
> +	void __iomem		*regs;
> +	struct clk		*clk;
> +	struct device		*dev;
> +	int			gpios[2];
> +
> +	int			bus_num;
> +	int			speed_mode;
> +};
> +
> +static const struct of_device_id exynos5_i2c_match[] =3D {
> +	{ .compatible =3D "samsung,exynos5-hsi2c" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
> +
> +/* TODO: Should go to debugfs */
> +static inline void dump_i2c_register(struct exynos5_i2c *i2c)
> +{
> +	dev_vdbg(i2c->dev, "Register dump(%d) :\n %x\n %x\n %x\n %x\n"
> +		" %x\n %x\n %x\n %x\n %x\n"
> +		" %x\n %x\n %x\n %x\n %x\n"
> +		" %x\n %x\n %x\n %x\n %x\n"
> +		" %x\n %x\n %x\n %x\n %x\n",
> +		i2c->suspended,
> +		readl(i2c->regs + HSI2C_CTL),
> +		readl(i2c->regs + HSI2C_FIFO_CTL),
> +		readl(i2c->regs + HSI2C_TRAILIG_CTL),
> +		readl(i2c->regs + HSI2C_CLK_CTL),
> +		readl(i2c->regs + HSI2C_CLK_SLOT),
> +		readl(i2c->regs + HSI2C_INT_ENABLE),
> +		readl(i2c->regs + HSI2C_INT_STATUS),
> +		readl(i2c->regs + HSI2C_ERR_STATUS),
> +		readl(i2c->regs + HSI2C_FIFO_STATUS),
> +		readl(i2c->regs + HSI2C_TX_DATA),
> +		readl(i2c->regs + HSI2C_RX_DATA),
> +		readl(i2c->regs + HSI2C_CONF),
> +		readl(i2c->regs + HSI2C_AUTO_CONF),
> +		readl(i2c->regs + HSI2C_TIMEOUT),
> +		readl(i2c->regs + HSI2C_MANUAL_CMD),
> +		readl(i2c->regs + HSI2C_TRANS_STATUS),
> +		readl(i2c->regs + HSI2C_TIMING_HS1),
> +		readl(i2c->regs + HSI2C_TIMING_HS2),
> +		readl(i2c->regs + HSI2C_TIMING_HS3),
> +		readl(i2c->regs + HSI2C_TIMING_FS1),
> +		readl(i2c->regs + HSI2C_TIMING_FS2),
> +		readl(i2c->regs + HSI2C_TIMING_FS3),
> +		readl(i2c->regs + HSI2C_TIMING_SLA),
> +		readl(i2c->regs + HSI2C_ADDR));
> +}

NAK, please add debugfs support already. This will be here for a long
time otherwise

> +static inline void exynos5_i2c_stop(struct exynos5_i2c *i2c, int ret)

no need for inline, GCC will handle that. Also, this prototype looks
awkward, you're passing caller's return code to be checked here... it's
weird, to say the least.

> +{
> +	dev_dbg(i2c->dev, "STOP\n");

I would call this dev_vdbg()

> +
> +	i2c->msg_idx++;
> +	if (ret)
> +		i2c->msg_idx =3D ret;
> +
> +	/* Disable interrrupts */
> +	writel(0, i2c->regs + HSI2C_INT_ENABLE);
> +	complete(&i2c->msg_complete);
> +}
> +
> +static void exynos5_i2c_en_timeout(struct exynos5_i2c *i2c)
> +{
> +	unsigned long i2c_timeout =3D readl(i2c->regs + HSI2C_TIMEOUT);
> +
> +	/* Clear to enable Timeout */
> +	i2c_timeout &=3D ~HSI2C_TIMEOUT_EN;
> +	writel(i2c_timeout, i2c->regs + HSI2C_TIMEOUT);
> +}
> +
> +static void exynos5_i2c_master_run(struct exynos5_i2c *i2c)
> +{
> +	/* Start data transfer in Master mode */
> +	u32 i2c_auto_conf =3D readl(i2c->regs + HSI2C_AUTO_CONF);
> +	i2c_auto_conf |=3D HSI2C_MASTER_RUN;
> +	writel(i2c_auto_conf, i2c->regs + HSI2C_AUTO_CONF);
> +}
> +
> +/* exynos5_i2c_set_bus
> + *
> + * get the i2c bus for a master/slave transaction
> + */

multiline comment style is wrong.

> +static int exynos5_i2c_set_bus(struct exynos5_i2c *i2c, int master)

this function is only called with master set to 1, do you even need that
argument ? Do you have some out-of-tree code for supporting slave mode ?

Please remove 'slave' support completely as that's not supported in
mainline as of today, if you need slave support, then add it to the
framework first.

> +{
> +	unsigned long t_status;
> +	int timeout =3D 400;
> +
> +	while (timeout-- > 0) {
> +		t_status =3D readl(i2c->regs + HSI2C_TRANS_STATUS);
> +
> +		if (master) {
> +			if (!(t_status & HSI2C_MASTER_BUSY))
> +				return 0;
> +		} else {
> +			if (!(t_status & HSI2C_SLAVE_BUSY))
> +				return 0;
> +		}
> +
> +		msleep(20);
> +	}
> +
> +	return -ETIMEDOUT;
> +}
> +
> +/* exynos5_i2c_irq
> + *
> + * top level IRQ servicing routine
> + */

multiline comment style is wrong.

> +static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
> +{
> +	struct exynos5_i2c *i2c =3D dev_id;
> +	unsigned long t_stat;
> +	unsigned char byte;
> +
> +	t_stat =3D readl(i2c->regs + HSI2C_TRANS_STATUS);
> +
> +	if (t_stat & HSI2C_TRANS_ABORT) {
> +		/* deal with arbitration loss */
> +		dev_err(i2c->dev, "deal with arbitration loss\n");
> +		goto out;
> +	}
> +	if (i2c->msg->flags & I2C_M_RD) {
> +		if (t_stat & HSI2C_TRANS_DONE) {
> +			dev_dbg(i2c->dev, "Device found.");
> +			while ((readl(i2c->regs + HSI2C_FIFO_STATUS) &
> +					HSI2C_RX_FIFO_EMPTY) =3D=3D 0) {
> +				byte =3D readl(i2c->regs + HSI2C_RX_DATA);
> +				dev_dbg(i2c->dev, "read rx_data =3D %x", byte);
> +				i2c->msg->buf[i2c->msg_ptr++] =3D byte;
> +			}
> +		} else if (t_stat & HSI2C_NO_DEV) {
> +			dev_dbg(i2c->dev, "No device found.");
> +			exynos5_i2c_stop(i2c, -ENXIO);
> +		} else if (t_stat & HSI2C_NO_DEV_ACK &&
> +				!(i2c->msg->flags & I2C_M_IGNORE_NAK)) {
> +			dev_dbg(i2c->dev, "No device Ack.");
> +			exynos5_i2c_stop(i2c, -ENXIO);
> +		}
> +	} else {
> +		byte =3D i2c->msg->buf[i2c->msg_ptr++];
> +		dev_dbg(i2c->dev, "write tx_data =3D %x ", byte);
> +		writel(byte, i2c->regs + HSI2C_TX_DATA);
> +	}
> +
> +	if (i2c->msg_ptr >=3D i2c->msg->len)
> +		exynos5_i2c_stop(i2c, 0);
> +
> + out:
> +	/* Set those bits to clear them */
> +	writel(readl(i2c->regs + HSI2C_INT_STATUS),
> +				i2c->regs + HSI2C_INT_STATUS);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void exynos5_i2c_message_start(struct exynos5_i2c *i2c,
> +				      struct i2c_msg *msgs)
> +{
> +	unsigned long usi_ctl =3D HSI2C_FUNC_MODE_I2C | HSI2C_MASTER;
> +	unsigned long i2c_auto_conf;
> +	unsigned long i2c_addr =3D ((msgs->addr & 0x7f) << 10);
> +	unsigned long usi_int_en =3D 0;
> +
> +	exynos5_i2c_en_timeout(i2c);
> +
> +	if (msgs->flags & I2C_M_RD) {
> +		usi_ctl &=3D ~HSI2C_TXCHON;
> +		usi_ctl |=3D HSI2C_RXCHON;
> +
> +		i2c_auto_conf |=3D HSI2C_READ_WRITE;
> +
> +		usi_int_en |=3D (HSI2C_INT_RX_ALMOSTFULL_EN |
> +			HSI2C_INT_TRAILING_EN);
> +	} else {
> +		usi_ctl &=3D ~HSI2C_RXCHON;
> +		usi_ctl |=3D HSI2C_TXCHON;
> +
> +		i2c_auto_conf &=3D ~HSI2C_READ_WRITE;
> +
> +		usi_int_en |=3D HSI2C_INT_TX_ALMOSTEMPTY_EN;
> +	}
> +
> +	writel(i2c_addr, i2c->regs + HSI2C_ADDR);
> +	writel(usi_ctl, i2c->regs + HSI2C_CTL);
> +
> +	i2c_auto_conf |=3D i2c->msg->len;
> +	i2c_auto_conf |=3D HSI2C_STOP_AFTER_TRANS;
> +	writel(i2c_auto_conf, i2c->regs + HSI2C_AUTO_CONF);
> +
> +	exynos5_i2c_master_run(i2c);
> +
> +	/* Enable appropriate interrupts */
> +	writel(usi_int_en, i2c->regs + HSI2C_INT_ENABLE);
> +}
> +
> +static int exynos5_i2c_doxfer(struct exynos5_i2c *i2c, struct i2c_msg *m=
sgs)
> +{
> +	unsigned long timeout;
> +
> +	if (i2c->suspended) {
> +		dev_err(i2c->dev, "HS-I2C is not initialzed.\n");
> +		return -EIO;
> +	}
> +
> +	if (exynos5_i2c_set_bus(i2c, 1)) {
> +		dev_err(i2c->dev, "cannot get bus, Master busy.\n");
> +		return -EAGAIN;
> +	}
> +
> +	i2c->msg =3D msgs;
> +	i2c->msg_ptr =3D 0;
> +	i2c->msg_idx =3D 0;
> +
> +	INIT_COMPLETION(i2c->msg_complete);
> +
> +	exynos5_i2c_message_start(i2c, msgs);
> +
> +	timeout =3D wait_for_completion_timeout(&i2c->msg_complete,
> +		EXYNOS5_I2C_TIMEOUT);
> +
> +	if (timeout =3D=3D 0)
> +		dev_dbg(i2c->dev, "timeout\n");
> +	else if (i2c->msg_idx !=3D msgs->len)
> +		dev_dbg(i2c->dev, "incomplete xfer (%d)\n", i2c->msg_idx);
> +
> +	return i2c->msg_idx;
> +}
> +
> +static int exynos5_i2c_xfer(struct i2c_adapter *adap,
> +			struct i2c_msg *msgs, int num)
> +{
> +	struct exynos5_i2c *i2c =3D (struct exynos5_i2c *)adap->algo_data;
> +	int retry, i;
> +	int ret;
> +
> +	ret =3D pm_runtime_get_sync(i2c->dev);
> +	if (IS_ERR_VALUE(ret))
> +		goto out;
> +
> +	clk_prepare_enable(i2c->clk);
> +
> +	for (retry =3D 0; retry < adap->retries; retry++) {
> +		for (i =3D 0; i < num; i++) {
> +			ret =3D exynos5_i2c_doxfer(i2c, msgs);
> +			msgs++;
> +
> +			if (ret =3D=3D -EAGAIN)
> +				break;
> +		}
> +		if (i =3D=3D num) {
> +			clk_disable_unprepare(i2c->clk);
> +			ret =3D i2c->msg_idx;
> +			goto out;
> +		}

why don't you just move this to the out label ?

> +		dev_dbg(i2c->dev, "retrying transfer (%d)\n", retry);
> +
> +		udelay(100);
> +	}
> +
> +	ret =3D -EREMOTEIO;
> +	clk_disable_unprepare(i2c->clk);
> + out:
> +	pm_runtime_mark_last_busy(i2c->dev);
> +	pm_runtime_put_autosuspend(i2c->dev);
> +	return ret;
> +}
> +
> +static u32 exynos5_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> +}
> +
> +static const struct i2c_algorithm exynos5_i2c_algorithm =3D {
> +	.master_xfer		=3D exynos5_i2c_xfer,
> +	.functionality		=3D exynos5_i2c_func,
> +};
> +
> +static int exynos5_i2c_set_timing(struct exynos5_i2c *i2c, int speed_mod=
e)
> +{
> +	unsigned long i2c_timing_s1;
> +	unsigned long i2c_timing_s2;
> +	unsigned long i2c_timing_s3;
> +	unsigned long i2c_timing_sla;
> +	unsigned int op_clk;
> +	unsigned int clkin =3D clk_get_rate(i2c->clk);
> +	unsigned int n_clkdiv;
> +	unsigned int t_start_su, t_start_hd;
> +	unsigned int t_stop_su;
> +	unsigned int t_data_su, t_data_hd;
> +	unsigned int t_scl_l, t_scl_h;
> +	unsigned int t_sr_release;
> +	unsigned int t_ftl_cycle;
> +	unsigned int i =3D 0, utemp0 =3D 0, utemp1 =3D 0, utemp2 =3D 0;
> +
> +	if (speed_mode =3D=3D HSI2C_HIGH_SPD)
> +		op_clk =3D HSI2C_HS_TX_CLOCK;
> +	else
> +		op_clk =3D HSI2C_FS_TX_CLOCK;
> +
> +	/* FPCLK / FI2C =3D
> +	 * (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2) + 8 + 2 * FLT_CYCLE
> +	 * uTemp0 =3D (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2)
> +	 * uTemp1 =3D (TSCLK_L + TSCLK_H + 2)
> +	 * uTemp2 =3D TSCLK_L + TSCLK_H
> +	*/

wrong indentation

(back to my vacations now)

--=20
balbi

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ3NI9AAoJEIaOsuA1yqREo/oP/iuXiY9pAvAMIVIbLb3C0b/O
SRlH4sCl8B2K4v1RWuN2MZjPLNVmZQmDn/kHNrU8bVtgE8jVW8Vf6Q2YXbB7w/Rb
8pG1orpKDSPwKaRo3FxNSVfipvlLGLNUn/xq/IQZfxxs5q35/15cnRJXHhXul4Wd
im+2V/b1IreQCuxz2gLpePCkKiQd+xR6yEc8Dk384CFwGl8pCXpEgqARC3hGVLSb
8CgjRHjeqAjWEKjq4zREbXmcMVwdEm74ifyOTas3alPd0ZvJZy9WKvbAB0Q493WO
nQ7lwxfLhFPl0nP9g0rMuVX464weKPi1hFc17ZsQ0cr0RLP5KUSsVcx0Wic9vw9J
7F/E9MRafG8MUxRdeJtEi4g8INy/viowPgjPaFzRWqbS0pRz91gKYogA3EPvuZs8
Rp65rFUClz/lWsk6Hh0+RWoIB3bmLXieM6FfJ/VVjo0uBXRgX3OzKlOa8ejOKwwX
iVPb1fnzAszMQ/c14RUD43mivwyC7IXbukwTw8EYUiw9XhhArmd+dVD7LlTYgbkD
f0Apn2w0HWyAlIeuE4WkA2bYQtD/34jOErCzgfT9Cy/hJO7Owh62X+fIGEe/SIRp
NxhGbYMGvDfuR1IudRRaW/43earYkaL7d3A+Jqm1U2288RzkjRWZlEO4RjHB94PP
/OAITxqDq8WoSzaZL1R0
=I9H1
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
