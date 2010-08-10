Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab0HJKZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 06:25:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34988 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab0HJKZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 06:25:10 -0400
Date: Tue, 10 Aug 2010 12:25:07 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Wells <wellsk40@gmail.com>,
        Durgesh Pattamatta <durgesh.pattamatta@nxp.com>
Subject: Re: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
 for the LPC32XX SoC
Message-ID: <20100810102507.GB4268@pengutronix.de>
References: <1281370650-29520-1-git-send-email-wellsk40@gmail.com>
 <1281370650-29520-2-git-send-email-wellsk40@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <1281370650-29520-2-git-send-email-wellsk40@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kevin,

driver seems to work fine here, a few comments though.

On Mon, Aug 09, 2010 at 09:17:29AM -0700, wellsk40@gmail.com wrote:
> From: Kevin Wells <wellsk40@gmail.com>
>=20
> This patch contains the RTC driver for the built-in RTC in
> the LPC32XX SoC.
>=20
> Signed-off-by: Kevin Wells <wellsk40@gmail.com>
> Signed-off-by: Durgesh Pattamatta <durgesh.pattamatta@nxp.com>
> ---
>  drivers/rtc/rtc-lpc32xx.c |  391 +++++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 391 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-lpc32xx.c
>=20
> diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
> new file mode 100644
> index 0000000..7803c68
> --- /dev/null
> +++ b/drivers/rtc/rtc-lpc32xx.c
> @@ -0,0 +1,391 @@
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
> +#define RTC_UCOUNT		0x00
> +#define RTC_DCOUNT		0x04
> +#define RTC_MATCH0		0x08
> +#define RTC_MATCH1		0x0C
> +#define RTC_CTRL		0x10
> +#define RTC_INTSTAT		0x14
> +#define RTC_KEY			0x18
> +#define RTC_SRAM		0x80
> +
> +#define RTC_MATCH0_EN		(1 << 0)
> +#define RTC_MATCH1_EN		(1 << 1)
> +#define RTC_ONSW_MATCH0_EN	(1 << 2)
> +#define RTC_ONSW_MATCH1_EN	(1 << 3)
> +#define RTC_SW_RESET		(1 << 4)
> +#define RTC_CNTR_DIS		(1 << 6)
> +#define RTC_ONSW_FORCE_HIGH	(1 << 7)
> +
> +#define RTC_MATCH0_INT_STS	(1 << 0)
> +#define RTC_MATCH1_INT_STS	(1 << 1)
> +#define RTC_ONSW_INT_STS	(1 << 2)
> +
> +#define RTC_KEY_ONSW_LOADVAL	0xB5C13F27
> +
> +#define RTC_NAME "rtc-lpc32xx"
> +
> +#define rtc_readl(dev, reg) \
> +	__raw_readl((dev)->rtc_base + reg)
> +#define rtc_writel(dev, reg, val) \
> +	__raw_writel((val), (dev)->rtc_base + reg)
> +
> +struct lpc32xx_rtc {
> +	void __iomem *rtc_base;
> +	unsigned int irq;
> +	int alarm_enabled;
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
> +	elapsed_sec =3D rtc_readl(rtc, RTC_UCOUNT);
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
> +	tmp =3D rtc_readl(rtc, RTC_CTRL);
> +	rtc_writel(rtc, RTC_CTRL, tmp | RTC_CNTR_DIS);
> +	rtc_writel(rtc, RTC_UCOUNT, secs);
> +	rtc_writel(rtc, RTC_DCOUNT, 0xFFFFFFFF - secs);
> +	rtc_writel(rtc, RTC_CTRL, tmp &=3D ~RTC_CNTR_DIS);
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
> +	rtc_time_to_tm(rtc_readl(rtc, RTC_MATCH0), &wkalrm->time);
> +	wkalrm->enabled =3D rtc->alarm_enabled;
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

Empty line to seperate variables from the code

> +	ret =3D rtc_tm_to_time(&wkalrm->time, &alarmsecs);
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to convert time: %d\n", ret);
> +		return ret;
> +	}
> +
> +	spin_lock_irq(&rtc->lock);
> +
> +	/* Disable alarm during update */
> +	tmp =3D rtc_readl(rtc, RTC_CTRL);
> +	rtc_writel(rtc, RTC_CTRL, tmp & ~RTC_MATCH0_EN);
> +
> +	rtc->alarm_enabled =3D wkalrm->enabled =3D 1;
> +	if (wkalrm->enabled) {
> +		rtc_writel(rtc, RTC_MATCH0, alarmsecs);
> +		rtc_writel(rtc, RTC_INTSTAT, RTC_MATCH0_INT_STS);
> +		rtc_writel(rtc, RTC_CTRL, tmp | RTC_MATCH0_EN);
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
> +	rtc->alarm_enabled =3D (int) enabled;
> +	tmp =3D rtc_readl(rtc, RTC_CTRL);
> +
> +	if (enabled)
> +		tmp |=3D RTC_MATCH0_EN;
> +	else
> +		tmp &=3D ~RTC_MATCH0_EN;
> +
> +	rtc_writel(rtc, RTC_CTRL, tmp);
> +	spin_unlock_irq(&rtc->lock);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t lpc32xx_rtc_alarm_interrupt(int irq, void *dev)
> +{
> +	struct lpc32xx_rtc *rtc =3D (struct lpc32xx_rtc *) dev;

You can drop this cast.

> +
> +	spin_lock(&rtc->lock);
> +
> +	/* Disable alarm interrupt */
> +	rtc_writel(rtc, RTC_CTRL,
> +		rtc_readl(rtc, RTC_CTRL) & ~RTC_MATCH0_EN);
> +	rtc->alarm_enabled =3D 0;
> +
> +	/*
> +	 * Write a large value to the match value so the RTC won't
> +	 * keep firing the match status
> +	 */
> +	rtc_writel(rtc, RTC_MATCH0, 0xFFFFFFFF);
> +	rtc_writel(rtc, RTC_INTSTAT, RTC_MATCH0_INT_STS);
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
> +	struct resource *res, *mem =3D NULL;
> +	struct lpc32xx_rtc *rtc =3D NULL;
> +	int rtcirq, retval;
> +	u32 tmp;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "Can't get memory resource\n");
> +		return -ENOENT;
> +	}
> +
> +	rtcirq =3D platform_get_irq(pdev, 0);
> +	if ((rtcirq < 0) || (rtcirq >=3D NR_IRQS)) {
> +		dev_err(&pdev->dev, "Can't get interrupt resource\n");
> +		return -ENOENT;
> +	}
> +
> +	rtc =3D kzalloc(sizeof(struct lpc32xx_rtc), GFP_KERNEL);
> +	if (unlikely(!rtc)) {
> +		dev_err(&pdev->dev, "Can't allocate memory\n");
> +		return -ENOMEM;
> +	}
> +	rtc->irq =3D rtcirq;
> +
> +	mem =3D request_mem_region(res->start, resource_size(res), pdev->name);
> +	if (!mem) {
> +		dev_err(&pdev->dev, "RTC registers are not free\n");
> +		retval =3D -EBUSY;
> +		goto err_reqmem;
> +	}
> +
> +	rtc->rtc_base =3D ioremap(res->start, res->end - res->start + 1);

How about using managed resources (devm_*)? They usually simplify the
error paths and make the probe more readable.

> +	if (!rtc->rtc_base) {
> +		dev_err(&pdev->dev, "Can't map memory\n");
> +		retval =3D -EIO;
> +		goto err_noremap;
> +	}
> +
> +	spin_lock_init(&rtc->lock);
> +
> +	/*
> +	 * The RTC is on a seperate power domain and can keep it's state
> +	 * across a chip power cycle. If the RTC has never been previously
> +	 * setup, then set it up now for the first time.
> +	 */
> +	if (rtc_readl(rtc, RTC_KEY) =3D=3D RTC_KEY_ONSW_LOADVAL) {
> +		tmp =3D rtc_readl(rtc, RTC_CTRL);
> +		tmp &=3D ~(RTC_SW_RESET | RTC_CNTR_DIS | RTC_MATCH0_EN |
> +			RTC_MATCH1_EN |	RTC_ONSW_MATCH0_EN |
> +			RTC_ONSW_MATCH1_EN | RTC_ONSW_FORCE_HIGH);
> +		rtc_writel(rtc, RTC_CTRL, tmp);
> +
> +		/* Clear latched interrupt states */
> +		rtc_writel(rtc, RTC_MATCH0, 0xFFFFFFFF);
> +		rtc_writel(rtc, RTC_INTSTAT, RTC_MATCH0_INT_STS |
> +			RTC_MATCH1_INT_STS | RTC_ONSW_INT_STS);
> +
> +		/* Write key value to RTC so it won't reload on reset */
> +		rtc_writel(rtc, RTC_KEY, RTC_KEY_ONSW_LOADVAL);
> +	} else if (rtc_readl(rtc, RTC_CTRL) & RTC_MATCH0_EN)
> +		rtc->alarm_enabled =3D 1;
> +
> +	platform_set_drvdata(pdev, rtc);
> +
> +	device_init_wakeup(&pdev->dev, 1);
> +	rtc->rtc =3D rtc_device_register(RTC_NAME, &pdev->dev, &lpc32xx_rtc_ops,
> +		THIS_MODULE);
> +	if (IS_ERR(rtc->rtc)) {
> +		dev_err(&pdev->dev, "Can't get RTC\n");
> +		retval =3D PTR_ERR(rtc->rtc);
> +		goto err_noreg;
> +	}
> +
> +	retval =3D request_irq(rtc->irq, lpc32xx_rtc_alarm_interrupt,
> +		IRQF_DISABLED, "rtcalarm", rtc);
> +	if (retval < 0) {
> +		dev_err(&pdev->dev, "Can't request interrupt\n");
> +		goto err_free_irq;
> +	}

I saw that a number of rtc-drivers register their irq after they
register the device. I wonder if this is OK here? Couldn't it happen
that after rtc_device_register() there is a preemption and another
process could set the alarm? Then there is a race between interrupts
already enabled and no handler available, no?

> +
> +	return 0;
> +
> +err_free_irq:
> +	rtc_device_unregister(rtc->rtc);
> +err_noreg:
> +	iounmap(rtc->rtc_base);
> +err_noremap:
> +	release_resource(mem);
> +err_reqmem:
> +	kfree(rtc);
> +
> +	return retval;
> +}
> +
> +static int __devexit lpc32xx_rtc_remove(struct platform_device *pdev)
> +{
> +	struct lpc32xx_rtc *rtc =3D platform_get_drvdata(pdev);
> +
> +	free_irq(rtc->irq, pdev);
> +	rtc_device_unregister(rtc->rtc);
> +	iounmap(rtc->rtc_base);
> +	release_resource(dev_get_drvdata(&rtc->rtc->dev));
> +	kfree(rtc);
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
> +	if (device_may_wakeup(&pdev->dev))
> +		enable_irq_wake(rtc->irq);
> +	else
> +		disable_irq_wake(rtc->irq);
> +
> +	return 0;
> +}
> +
> +static int lpc32xx_rtc_resume(struct device *dev)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct lpc32xx_rtc *rtc =3D platform_get_drvdata(pdev);
> +
> +	if (device_may_wakeup(&pdev->dev))
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
> +	rtc_writel(rtc, RTC_CTRL,
> +		rtc_readl(rtc, RTC_CTRL) & ~RTC_MATCH0_EN);
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
> +	if (rtc->alarm_enabled)
> +		rtc_writel(rtc, RTC_CTRL,
> +			rtc_readl(rtc, RTC_CTRL) | RTC_MATCH0_EN);
> +
> +	return 0;
> +}
> +
> +#else
> +#define lpc32xx_rtc_suspend NULL
> +#define lpc32xx_rtc_resume NULL
> +#define lpc32xx_rtc_freeze NULL
> +#define lpc32xx_rtc_thaw NULL
> +#endif
> +
> +static const struct dev_pm_ops lpc32xx_rtc_pm_ops =3D {
> +	.suspend =3D lpc32xx_rtc_suspend,
> +	.resume =3D lpc32xx_rtc_resume,
> +	.freeze =3D lpc32xx_rtc_freeze,
> +	.thaw =3D lpc32xx_rtc_thaw,
> +	.restore =3D lpc32xx_rtc_resume
> +};
> +
> +static struct platform_driver lpc32xx_rtc_driver =3D {
> +	.probe		=3D lpc32xx_rtc_probe,
> +	.remove		=3D __devexit_p(lpc32xx_rtc_remove),
> +	.driver =3D {
> +		.name =3D RTC_NAME,
> +		.pm =3D &lpc32xx_rtc_pm_ops,
> +	},
> +};
> +
> +static int __init lpc32xx_rtc_init(void)
> +{
> +	return platform_driver_register(&lpc32xx_rtc_driver);
> +}
> +
> +static void __exit lpc32xx_rtc_exit(void)
> +{
> +	platform_driver_unregister(&lpc32xx_rtc_driver);
> +}
> +
> +module_init(lpc32xx_rtc_init);
> +module_exit(lpc32xx_rtc_exit);

Minor nitpick: The trend seems to be to put those lines directly after
the function.

> +
> +MODULE_AUTHOR("Kevin Wells <wellsk40@gmail.com");
> +MODULE_DESCRIPTION("RTC driver for the LPC32xx SoC");
> +MODULE_LICENSE("GPL");
> --=20
> 1.7.1.1
>=20
> --=20
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxhKQMACgkQD27XaX1/VRuAagCgjhjLBCCX8zT33AtCvPj8G8iz
gu4An0b5YfYbal3MIUrGFAwY2sctggBp
=8Xx4
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
