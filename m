Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab0HSJfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:35:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46755 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0HSJfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:35:39 -0400
Date: Thu, 19 Aug 2010 11:35:37 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Wells <wellsk40@gmail.com>,
        Durgesh Pattamatta <durgesh.pattamatta@nxp.com>
Subject: Re: [rtc-linux] [PATCH] rtc: rtc-lpc32xx: Introduce RTC driver for
 the LPC32XX SoC (v4)
Message-ID: <20100819093537.GB2747@pengutronix.de>
References: <1282075234-18644-1-git-send-email-wellsk40@gmail.com>
 <1282075234-18644-2-git-send-email-wellsk40@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2B/JsCI69OhZNC5r"
Content-Disposition: inline
In-Reply-To: <1282075234-18644-2-git-send-email-wellsk40@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 17, 2010 at 01:00:34PM -0700, wellsk40@gmail.com wrote:
> From: Kevin Wells <wellsk40@gmail.com>
>=20
> This patch contains the RTC driver for the built-in RTC in
> the LPC32XX SoC. This patch includes updates from the initial
> review comments and updates from the v3 review.
>=20
> Signed-off-by: Kevin Wells <wellsk40@gmail.com>
> Signed-off-by: Durgesh Pattamatta <durgesh.pattamatta@nxp.com>

Looks fine from my point of view:

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

> ---
>  drivers/rtc/Kconfig       |    9 +
>  drivers/rtc/Makefile      |    1 +
>  drivers/rtc/rtc-lpc32xx.c |  414 +++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 424 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-lpc32xx.c
>=20
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 48ca713..774a65a 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -952,4 +952,13 @@ config RTC_DRV_JZ4740
>  	  This driver can also be buillt as a module. If so, the module
>  	  will be called rtc-jz4740.
> =20
> +config RTC_DRV_LPC32XX
> +	depends on ARCH_LPC32XX
> +	tristate "NXP LPC32XX RTC"
> +	help
> +	  This enables support for the NXP RTC in the LPC32XX
> +
> +	  This driver can also be buillt as a module. If so, the module
> +	  will be called rtc-lpc32xx.
> +
>  endif # RTC_CLASS
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index 0f207b3..7a7cb32 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -51,6 +51,7 @@ obj-$(CONFIG_RTC_DRV_IMXDI)	+=3D rtc-imxdi.o
>  obj-$(CONFIG_RTC_DRV_ISL1208)	+=3D rtc-isl1208.o
>  obj-$(CONFIG_RTC_DRV_ISL12022)	+=3D rtc-isl12022.o
>  obj-$(CONFIG_RTC_DRV_JZ4740)	+=3D rtc-jz4740.o
> +obj-$(CONFIG_RTC_DRV_LPC32XX)	+=3D rtc-lpc32xx.o
>  obj-$(CONFIG_RTC_DRV_M41T80)	+=3D rtc-m41t80.o
>  obj-$(CONFIG_RTC_DRV_M41T94)	+=3D rtc-m41t94.o
>  obj-$(CONFIG_RTC_DRV_M48T35)	+=3D rtc-m48t35.o
> diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
> new file mode 100644
> index 0000000..ec8701c
> --- /dev/null
> +++ b/drivers/rtc/rtc-lpc32xx.c
> @@ -0,0 +1,414 @@
> +/*
> + * Copyright (C) 2010 NXP Semiconductors
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + *  You should have received a copy of the GNU General Public License al=
ong
> + *  with this program; if not, write to the Free Software Foundation, In=
c.,
> + *  675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +#include <linux/rtc.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +
> +/*
> + * Clock and Power control register offsets
> + */
> +#define LPC32XX_RTC_UCOUNT		0x00
> +#define LPC32XX_RTC_DCOUNT		0x04
> +#define LPC32XX_RTC_MATCH0		0x08
> +#define LPC32XX_RTC_MATCH1		0x0C
> +#define LPC32XX_RTC_CTRL		0x10
> +#define LPC32XX_RTC_INTSTAT		0x14
> +#define LPC32XX_RTC_KEY			0x18
> +#define LPC32XX_RTC_SRAM		0x80
> +
> +#define LPC32XX_RTC_CTRL_MATCH0		(1 << 0)
> +#define LPC32XX_RTC_CTRL_MATCH1		(1 << 1)
> +#define LPC32XX_RTC_CTRL_ONSW_MATCH0	(1 << 2)
> +#define LPC32XX_RTC_CTRL_ONSW_MATCH1	(1 << 3)
> +#define LPC32XX_RTC_CTRL_SW_RESET	(1 << 4)
> +#define LPC32XX_RTC_CTRL_CNTR_DIS	(1 << 6)
> +#define LPC32XX_RTC_CTRL_ONSW_FORCE_HI	(1 << 7)
> +
> +#define LPC32XX_RTC_INTSTAT_MATCH0	(1 << 0)
> +#define LPC32XX_RTC_INTSTAT_MATCH1	(1 << 1)
> +#define LPC32XX_RTC_INTSTAT_ONSW	(1 << 2)
> +
> +#define LPC32XX_RTC_KEY_ONSW_LOADVAL	0xB5C13F27
> +
> +#define RTC_NAME "rtc-lpc32xx"
> +
> +#define rtc_readl(dev, reg) \
> +	__raw_readl((dev)->rtc_base + (reg))
> +#define rtc_writel(dev, reg, val) \
> +	__raw_writel((val), (dev)->rtc_base + (reg))
> +
> +struct lpc32xx_rtc {
> +	void __iomem *rtc_base;
> +	int irq;
> +	unsigned char alarm_enabled;
> +	struct rtc_device *rtc;
> +	spinlock_t lock;
> +};
> +
> +static int lpc32xx_rtc_read_time(struct device *dev, struct rtc_time *ti=
me)
> +{
> +	unsigned long elapsed_sec;
> +	struct lpc32xx_rtc *rtc =3D dev_get_drvdata(dev);
> +
> +	elapsed_sec =3D rtc_readl(rtc, LPC32XX_RTC_UCOUNT);
> +	rtc_time_to_tm(elapsed_sec, time);
> +
> +	return rtc_valid_tm(time);
> +}
> +
> +static int lpc32xx_rtc_set_mmss(struct device *dev, unsigned long secs)
> +{
> +	struct lpc32xx_rtc *rtc =3D dev_get_drvdata(dev);
> +	u32 tmp;
> +
> +	spin_lock_irq(&rtc->lock);
> +
> +	/* RTC must be disabled during count update */
> +	tmp =3D rtc_readl(rtc, LPC32XX_RTC_CTRL);
> +	rtc_writel(rtc, LPC32XX_RTC_CTRL, tmp | LPC32XX_RTC_CTRL_CNTR_DIS);
> +	rtc_writel(rtc, LPC32XX_RTC_UCOUNT, secs);
> +	rtc_writel(rtc, LPC32XX_RTC_DCOUNT, 0xFFFFFFFF - secs);
> +	rtc_writel(rtc, LPC32XX_RTC_CTRL, tmp &=3D ~LPC32XX_RTC_CTRL_CNTR_DIS);
> +
> +	spin_unlock_irq(&rtc->lock);
> +
> +	return 0;
> +}
> +
> +static int lpc32xx_rtc_read_alarm(struct device *dev,
> +	struct rtc_wkalrm *wkalrm)
> +{
> +	struct lpc32xx_rtc *rtc =3D dev_get_drvdata(dev);
> +
> +	rtc_time_to_tm(rtc_readl(rtc, LPC32XX_RTC_MATCH0), &wkalrm->time);
> +	wkalrm->enabled =3D rtc->alarm_enabled;
> +	wkalrm->pending =3D !!(rtc_readl(rtc, LPC32XX_RTC_INTSTAT) &
> +		LPC32XX_RTC_INTSTAT_MATCH0);
> +
> +	return rtc_valid_tm(&wkalrm->time);
> +}
> +
> +static int lpc32xx_rtc_set_alarm(struct device *dev,
> +	struct rtc_wkalrm *wkalrm)
> +{
> +	struct lpc32xx_rtc *rtc =3D dev_get_drvdata(dev);
> +	unsigned long alarmsecs;
> +	u32 tmp;
> +	int ret;
> +
> +	ret =3D rtc_tm_to_time(&wkalrm->time, &alarmsecs);
> +	if (ret < 0) {
> +		dev_warn(dev, "Failed to convert time: %d\n", ret);
> +		return ret;
> +	}
> +
> +	spin_lock_irq(&rtc->lock);
> +
> +	/* Disable alarm during update */
> +	tmp =3D rtc_readl(rtc, LPC32XX_RTC_CTRL);
> +	rtc_writel(rtc, LPC32XX_RTC_CTRL, tmp & ~LPC32XX_RTC_CTRL_MATCH0);
> +
> +	rtc_writel(rtc, LPC32XX_RTC_MATCH0, alarmsecs);
> +
> +	rtc->alarm_enabled =3D wkalrm->enabled;
> +	if (wkalrm->enabled) {
> +		rtc_writel(rtc, LPC32XX_RTC_INTSTAT,
> +			   LPC32XX_RTC_INTSTAT_MATCH0);
> +		rtc_writel(rtc, LPC32XX_RTC_CTRL, tmp |
> +			   LPC32XX_RTC_CTRL_MATCH0);
> +	}
> +
> +	spin_unlock_irq(&rtc->lock);
> +
> +	return 0;
> +}
> +
> +static int lpc32xx_rtc_alarm_irq_enable(struct device *dev,
> +	unsigned int enabled)
> +{
> +	struct lpc32xx_rtc *rtc =3D dev_get_drvdata(dev);
> +	u32 tmp;
> +
> +	spin_lock_irq(&rtc->lock);
> +	tmp =3D rtc_readl(rtc, LPC32XX_RTC_CTRL);
> +
> +	if (enabled) {
> +		rtc->alarm_enabled =3D 1;
> +		tmp |=3D LPC32XX_RTC_CTRL_MATCH0;
> +	} else {
> +		rtc->alarm_enabled =3D 0;
> +		tmp &=3D ~LPC32XX_RTC_CTRL_MATCH0;
> +	}
> +
> +	rtc_writel(rtc, LPC32XX_RTC_CTRL, tmp);
> +	spin_unlock_irq(&rtc->lock);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t lpc32xx_rtc_alarm_interrupt(int irq, void *dev)
> +{
> +	struct lpc32xx_rtc *rtc =3D dev;
> +
> +	spin_lock(&rtc->lock);
> +
> +	/* Disable alarm interrupt */
> +	rtc_writel(rtc, LPC32XX_RTC_CTRL,
> +		rtc_readl(rtc, LPC32XX_RTC_CTRL) &
> +			  ~LPC32XX_RTC_CTRL_MATCH0);
> +	rtc->alarm_enabled =3D 0;
> +
> +	/*
> +	 * Write a large value to the match value so the RTC won't
> +	 * keep firing the match status
> +	 */
> +	rtc_writel(rtc, LPC32XX_RTC_MATCH0, 0xFFFFFFFF);
> +	rtc_writel(rtc, LPC32XX_RTC_INTSTAT, LPC32XX_RTC_INTSTAT_MATCH0);
> +
> +	spin_unlock(&rtc->lock);
> +
> +	rtc_update_irq(rtc->rtc, 1, RTC_IRQF | RTC_AF);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static const struct rtc_class_ops lpc32xx_rtc_ops =3D {
> +	.read_time		=3D lpc32xx_rtc_read_time,
> +	.set_mmss		=3D lpc32xx_rtc_set_mmss,
> +	.read_alarm		=3D lpc32xx_rtc_read_alarm,
> +	.set_alarm		=3D lpc32xx_rtc_set_alarm,
> +	.alarm_irq_enable	=3D lpc32xx_rtc_alarm_irq_enable,
> +};
> +
> +static int __devinit lpc32xx_rtc_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	struct lpc32xx_rtc *rtc;
> +	resource_size_t size;
> +	int rtcirq;
> +	u32 tmp;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "Can't get memory resource\n");
> +		return -ENOENT;
> +	}
> +
> +	rtcirq =3D platform_get_irq(pdev, 0);
> +	if (rtcirq < 0 || rtcirq >=3D NR_IRQS) {
> +		dev_warn(&pdev->dev, "Can't get interrupt resource\n");
> +		rtcirq =3D -1;
> +	}
> +
> +	rtc =3D devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
> +	if (unlikely(!rtc)) {
> +		dev_err(&pdev->dev, "Can't allocate memory\n");
> +		return -ENOMEM;
> +	}
> +	rtc->irq =3D rtcirq;
> +
> +	size =3D resource_size(res);
> +
> +	if (!devm_request_mem_region(&pdev->dev, res->start, size,
> +				     pdev->name)) {
> +		dev_err(&pdev->dev, "RTC registers are not free\n");
> +		return -EBUSY;
> +	}
> +
> +	rtc->rtc_base =3D devm_ioremap(&pdev->dev, res->start, size);
> +	if (!rtc->rtc_base) {
> +		dev_err(&pdev->dev, "Can't map memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_init(&rtc->lock);
> +
> +	/*
> +	 * The RTC is on a seperate power domain and can keep it's state
> +	 * across a chip power cycle. If the RTC has never been previously
> +	 * setup, then set it up now for the first time.
> +	 */
> +	tmp =3D rtc_readl(rtc, LPC32XX_RTC_CTRL);
> +	if (rtc_readl(rtc, LPC32XX_RTC_KEY) !=3D LPC32XX_RTC_KEY_ONSW_LOADVAL) {
> +		tmp &=3D ~(LPC32XX_RTC_CTRL_SW_RESET |
> +			LPC32XX_RTC_CTRL_CNTR_DIS |
> +			LPC32XX_RTC_CTRL_MATCH0 |
> +			LPC32XX_RTC_CTRL_MATCH1 |
> +			LPC32XX_RTC_CTRL_ONSW_MATCH0 |
> +			LPC32XX_RTC_CTRL_ONSW_MATCH1 |
> +			LPC32XX_RTC_CTRL_ONSW_FORCE_HI);
> +		rtc_writel(rtc, LPC32XX_RTC_CTRL, tmp);
> +
> +		/* Clear latched interrupt states */
> +		rtc_writel(rtc, LPC32XX_RTC_MATCH0, 0xFFFFFFFF);
> +		rtc_writel(rtc, LPC32XX_RTC_INTSTAT,
> +			   LPC32XX_RTC_INTSTAT_MATCH0 |
> +			   LPC32XX_RTC_INTSTAT_MATCH1 |
> +			   LPC32XX_RTC_INTSTAT_ONSW);
> +
> +		/* Write key value to RTC so it won't reload on reset */
> +		rtc_writel(rtc, LPC32XX_RTC_KEY,
> +			   LPC32XX_RTC_KEY_ONSW_LOADVAL);
> +	} else {
> +		rtc_writel(rtc, LPC32XX_RTC_CTRL,
> +			   tmp & ~LPC32XX_RTC_CTRL_MATCH0);
> +	}
> +
> +	platform_set_drvdata(pdev, rtc);
> +
> +	rtc->rtc =3D rtc_device_register(RTC_NAME, &pdev->dev, &lpc32xx_rtc_ops,
> +		THIS_MODULE);
> +	if (IS_ERR(rtc->rtc)) {
> +		dev_err(&pdev->dev, "Can't get RTC\n");
> +		platform_set_drvdata(pdev, NULL);
> +		return PTR_ERR(rtc->rtc);
> +	}
> +
> +	/*
> +	 * IRQ is enabled after device registration in case alarm IRQ
> +	 * is pending upon suspend exit.
> +	 */
> +	if (rtc->irq >=3D 0) {
> +		if (devm_request_irq(&pdev->dev, rtc->irq,
> +				     lpc32xx_rtc_alarm_interrupt,
> +				     IRQF_DISABLED, pdev->name, rtc) < 0) {
> +			dev_warn(&pdev->dev, "Can't request interrupt.\n");
> +			rtc->irq =3D -1;
> +		} else {
> +			device_init_wakeup(&pdev->dev, 1);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int __devexit lpc32xx_rtc_remove(struct platform_device *pdev)
> +{
> +	struct lpc32xx_rtc *rtc =3D platform_get_drvdata(pdev);
> +
> +	if (rtc->irq >=3D 0)
> +		device_init_wakeup(&pdev->dev, 0);
> +
> +	platform_set_drvdata(pdev, NULL);
> +	rtc_device_unregister(rtc->rtc);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int lpc32xx_rtc_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct lpc32xx_rtc *rtc =3D platform_get_drvdata(pdev);
> +
> +	if (rtc->irq >=3D 0) {
> +		if (device_may_wakeup(&pdev->dev))
> +			enable_irq_wake(rtc->irq);
> +		else
> +			disable_irq_wake(rtc->irq);
> +	}
> +
> +	return 0;
> +}
> +
> +static int lpc32xx_rtc_resume(struct device *dev)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct lpc32xx_rtc *rtc =3D platform_get_drvdata(pdev);
> +
> +	if (rtc->irq >=3D 0 && device_may_wakeup(&pdev->dev))
> +		disable_irq_wake(rtc->irq);
> +
> +	return 0;
> +}
> +
> +/* Unconditionally disable the alarm */
> +static int lpc32xx_rtc_freeze(struct device *dev)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct lpc32xx_rtc *rtc =3D platform_get_drvdata(pdev);
> +
> +	spin_lock_irq(&rtc->lock);
> +
> +	rtc_writel(rtc, LPC32XX_RTC_CTRL,
> +		rtc_readl(rtc, LPC32XX_RTC_CTRL) &
> +			  ~LPC32XX_RTC_CTRL_MATCH0);
> +
> +	spin_unlock_irq(&rtc->lock);
> +
> +	return 0;
> +}
> +
> +static int lpc32xx_rtc_thaw(struct device *dev)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct lpc32xx_rtc *rtc =3D platform_get_drvdata(pdev);
> +
> +	if (rtc->alarm_enabled) {
> +		spin_lock_irq(&rtc->lock);
> +
> +		rtc_writel(rtc, LPC32XX_RTC_CTRL,
> +			   rtc_readl(rtc, LPC32XX_RTC_CTRL) |
> +			   LPC32XX_RTC_CTRL_MATCH0);
> +
> +		spin_unlock_irq(&rtc->lock);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops lpc32xx_rtc_pm_ops =3D {
> +	.suspend =3D lpc32xx_rtc_suspend,
> +	.resume =3D lpc32xx_rtc_resume,
> +	.freeze =3D lpc32xx_rtc_freeze,
> +	.thaw =3D lpc32xx_rtc_thaw,
> +	.restore =3D lpc32xx_rtc_resume
> +};
> +
> +#define LPC32XX_RTC_PM_OPS (&lpc32xx_rtc_pm_ops)
> +#else
> +#define LPC32XX_RTC_PM_OPS NULL
> +#endif
> +
> +static struct platform_driver lpc32xx_rtc_driver =3D {
> +	.probe		=3D lpc32xx_rtc_probe,
> +	.remove		=3D __devexit_p(lpc32xx_rtc_remove),
> +	.driver =3D {
> +		.name	=3D RTC_NAME,
> +		.owner	=3D THIS_MODULE,
> +		.pm	=3D LPC32XX_RTC_PM_OPS
> +	},
> +};
> +
> +static int __init lpc32xx_rtc_init(void)
> +{
> +	return platform_driver_register(&lpc32xx_rtc_driver);
> +}
> +module_init(lpc32xx_rtc_init);
> +
> +static void __exit lpc32xx_rtc_exit(void)
> +{
> +	platform_driver_unregister(&lpc32xx_rtc_driver);
> +}
> +module_exit(lpc32xx_rtc_exit);
> +
> +MODULE_AUTHOR("Kevin Wells <wellsk40@gmail.com");
> +MODULE_DESCRIPTION("RTC driver for the LPC32xx SoC");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:rtc-lpc32xx");
> --=20
> 1.7.1.1
>=20
> --=20
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--2B/JsCI69OhZNC5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxs+ukACgkQD27XaX1/VRvfWgCgtMu4OF1G+XjdXhqJ0HUq4snL
DUsAnicCe3aV+psYIsFfXJJRcha5cG42
=QseM
-----END PGP SIGNATURE-----

--2B/JsCI69OhZNC5r--
