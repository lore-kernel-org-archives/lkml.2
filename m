Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0FXQ56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:57:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59598 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0FXQ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:57:57 -0400
Date: Thu, 24 Jun 2010 18:57:51 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Luotao Fu <l.fu@pengutronix.de>,
       Rabin VINCENT <rabin.vincent@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 5/5] input: STMPE touch controller support
Message-ID: <20100624165751.GA17112@pengutronix.de>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Rabin VINCENT <rabin.vincent@stericsson.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
References: <1277382530-23734-1-git-send-email-l.fu@pengutronix.de> <1277389575-574-1-git-send-email-l.fu@pengutronix.de> <20100624162407.GA18899@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20100624162407.GA18899@core.coreip.homeip.net>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:44:14 up 17 days,  9:12, 31 users,  load average: 0.36, 0.95,
	1.57
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

thanks for reviewing the patch.

On Thu, Jun 24, 2010 at 09:24:07AM -0700, Dmitry Torokhov wrote:
> Hi Luotao,
>=20
> On Thu, Jun 24, 2010 at 04:26:15PM +0200, Luotao Fu wrote:
> > diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchsc=
reen/Makefile
> > index 497964a..2691c62 100644
> > --- a/drivers/input/touchscreen/Makefile
> > +++ b/drivers/input/touchscreen/Makefile
> > @@ -47,3 +47,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+=3D mains=
tone-wm97xx.o
> >  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+=3D zylonite-wm97xx.o
> >  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+=3D w90p910_ts.o
> >  obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+=3D tps6507x-ts.o
> > +obj-$(CONFIG_TOUCHSCREEN_STMPE)		+=3D stmpe-ts.o
>=20
> Please keep Makefile ordered alphabetically, it makes it easier to merge
> stuff. Might try to do the same for Kconfig as well.
>=20

OK, will fix.
> > +
> > +static int inline __stmpe_reset_fifo(struct stmpe *stmpe)
>=20
> Do not mark private function inline unless absolutely necessary - let
> compiler figure out whether it makes sense to inline and what.
>=20
OK, will fix.
> > +{
> > +	int ret;
> > +
> > +	ret =3D stmpe_set_bits(stmpe, STMPE_REG_FIFO_STA,
> > +			STMPE_FIFO_STA_RESET, STMPE_FIFO_STA_RESET);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return stmpe_set_bits(stmpe, STMPE_REG_FIFO_STA,
> > +			STMPE_FIFO_STA_RESET, 0);
> > +}
> > +
> > +static void stmpe_work(struct work_struct *work)
> > +{
> > +	int int_sta;
> > +	u32 timeout =3D 40;
> > +
> > +	struct stmpe_touch *ts =3D
> > +	    container_of(work, struct stmpe_touch, work.work);
> > +
> > +	int_sta =3D stmpe_reg_read(ts->stmpe, STMPE_REG_INT_STA);
> > +
> > +	/* touch_det sometimes get desasserted or just get stuck. This appears
> > +	 * to be a silicon bug, We still have to clearify this with the
> > +	 * manufacture. As a workaround We release the key anyway if the
> > +	 * touch_det keeps coming in after 4ms, while the FIFO contains no va=
lue
> > +	 * during the whole time. */
>=20
> I would appreciate if we could maintain the following format for
> multiline comments (within input at least):
>=20
> /*
>  * This is a long long
>  * long comment.
>  */
>=20

OK, will fix.
> > +	while ((int_sta & (1 << STMPE_IRQ_TOUCH_DET)) && (timeout > 0)) {
> > +		timeout--;
> > +		int_sta =3D stmpe_reg_read(ts->stmpe, STMPE_REG_INT_STA);
> > +		udelay(100);
> > +	}
> > +
> > +	/* reset the FIFO before we report release event */
> > +	__stmpe_reset_fifo(ts->stmpe);
> > +
> > +	input_report_abs(ts->idev, ABS_PRESSURE, 0);
> > +	input_sync(ts->idev);
>=20
> Hmm, this function appears to be always reporting release, no matter
> what the state of hardware is. I do not think this was the intention...
> or was it?
>=20

It unfortunately is. The original idea was polling for touch_det
and only report a release if the timeout was not reached. Unfortunately
the chip just sometime runs amok and never clears the touch_det
carelessly what happend. The only way here is report release any way
both after successed poll or timeout. This works fine, though the
polling sure looks unneccessary. I, however, would like to keep this
since I suppose a silicon bug here. Until the issue is cleared with the
vendor. Hence I'd like to have the polling for wait_det here though it
is sometimes useless.

> > +}
> > +
> > +static irqreturn_t stmpe_ts_handler(int irq, void *data)
> > +{
> > +	u8 data_set[4];
> > +	int x, y, z;
> > +	struct stmpe_touch *ts =3D data;
> > +
> > +	/* Cancel scheduled polling for release if we have new value
> > +	 * available. Wait if the polling is already running. */
> > +	cancel_delayed_work_sync(&ts->work);
> > +
> > +	/*
> > +	 * The FIFO sometimes just crashes and stops generating interrupts. T=
his
> > +	 * appears to be a silicon bug. We still have to clearify this with
> > +	 * the manufacture. As a workaround we disable the TSC while we are
> > +	 * collecting data and flush the FIFO after reading
> > +	 */
> > +	stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
> > +				STMPE_TSC_CTRL_TSC_EN, 0);
> > +
> > +	stmpe_block_read(ts->stmpe, STMPE_REG_TSC_DATA_XYZ, 4, data_set);
> > +
> > +	x =3D (data_set[0] << 4) | (data_set[1] >> 4);
> > +	y =3D ((data_set[1] & 0xf) << 8) | data_set[2];
> > +	z =3D data_set[3];
> > +
> > +	input_report_abs(ts->idev, ABS_X, x);
> > +	input_report_abs(ts->idev, ABS_Y, y);
> > +	input_report_abs(ts->idev, ABS_PRESSURE, z);
> > +	input_sync(ts->idev);
> > +
> > +       /* flush the FIFO after we have read out our values. */
> > +	__stmpe_reset_fifo(ts->stmpe);
> > +
> > +	/* reenable the tsc */
> > +	stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
> > +			STMPE_TSC_CTRL_TSC_EN, STMPE_TSC_CTRL_TSC_EN);
> > +
> > +	/* start polling for touch_det to detect release */
> > +	schedule_delayed_work(&ts->work, HZ / 50);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int stmpe_ts_open(struct input_dev *dev)
> > +{
> > +	struct stmpe_touch *ts =3D input_get_drvdata(dev);
> > +	int ret =3D 0;
> > +
> > +	ret =3D __stmpe_reset_fifo(ts->stmpe);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
> > +			STMPE_TSC_CTRL_TSC_EN, STMPE_TSC_CTRL_TSC_EN);
> > +}
> > +
> > +static void stmpe_ts_close(struct input_dev *dev)
> > +{
> > +	struct stmpe_touch *ts =3D input_get_drvdata(dev);
> > +
> > +	stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
> > +			STMPE_TSC_CTRL_TSC_EN, 0);
> > +}
> > +
> > +static int __devinit stmpe_input_probe(struct platform_device *pdev)
> > +{
> > +	struct stmpe *stmpe =3D dev_get_drvdata(pdev->dev.parent);
> > +	struct stmpe_platform_data *pdata =3D stmpe->pdata;
> > +	struct stmpe_touch *ts;
> > +	struct input_dev *idev;
> > +	struct stmpe_ts_platform_data *ts_pdata =3D NULL;
> > +	int ret =3D 0;
> > +	unsigned int ts_irq;
> > +	u8 adc_ctrl1, adc_ctrl1_mask, tsc_cfg, tsc_cfg_mask;
> > +
> > +	ts_irq =3D platform_get_irq_byname(pdev, "FIFO_TH");
> > +	if (ts_irq < 0)
> > +		return ts_irq;
> > +
> > +	ts =3D kzalloc(sizeof(*ts), GFP_KERNEL);
> > +	if (!ts)
> > +		goto err_out;
> > +
> > +	idev =3D input_allocate_device();
> > +	if (!idev)
> > +		goto err_free_ts;
> > +
> > +	platform_set_drvdata(pdev, ts);
> > +	ts->stmpe =3D stmpe;
> > +	ts->idev =3D idev;
> > +
> > +	if (pdata)
> > +		ts_pdata =3D pdata->ts;
> > +
> > +	if (ts_pdata) {
> > +		ts->sample_time =3D ts_pdata->sample_time;
> > +		ts->mod_12b =3D ts_pdata->mod_12b;
> > +		ts->ref_sel =3D ts_pdata->ref_sel;
> > +		ts->adc_freq =3D ts_pdata->adc_freq;
> > +		ts->ave_ctrl =3D ts_pdata->ave_ctrl;
> > +		ts->touch_det_delay =3D ts_pdata->touch_det_delay;
> > +		ts->settling =3D ts_pdata->settling;
> > +		ts->fraction_z =3D ts_pdata->fraction_z;
> > +		ts->i_drive =3D ts_pdata->i_drive;
> > +	}
> > +
> > +	INIT_DELAYED_WORK(&ts->work, stmpe_work);
> > +
> > +	ret =3D request_threaded_irq(ts_irq, NULL, stmpe_ts_handler,
> > +			IRQF_ONESHOT, STMPE_TS_NAME, ts);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to request IRQ %d\n", ts_irq);
> > +		goto err_free_input;
> > +	}
> > +
> > +	ret =3D stmpe_enable(stmpe, STMPE_BLOCK_TOUCHSCREEN | STMPE_BLOCK_ADC=
);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Could not enable clock for ADC and TS\n");
> > +		goto err_free_irq;
> > +	}
> > +
> > +	adc_ctrl1 =3D SAMPLE_TIME(ts->sample_time) | MOD_12B(ts->mod_12b) |
> > +		REF_SEL(ts->ref_sel);
> > +	adc_ctrl1_mask =3D SAMPLE_TIME(0xff) | MOD_12B(0xff) | REF_SEL(0xff);
> > +	ret =3D stmpe_set_bits(stmpe, STMPE_REG_ADC_CTRL1,
> > +			adc_ctrl1_mask, adc_ctrl1);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Could not setup ADC\n");
> > +		goto err_free_irq;
> > +	}
> > +
> > +	ret =3D stmpe_set_bits(stmpe, STMPE_REG_ADC_CTRL2,
> > +			ADC_FREQ(0xff), ADC_FREQ(ts->adc_freq));
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Could not setup ADC\n");
> > +		goto err_free_irq;
> > +	}
> > +
> > +	tsc_cfg =3D AVE_CTRL(ts->ave_ctrl) | DET_DELAY(ts->touch_det_delay) |
> > +			SETTLING(ts->settling);
> > +	tsc_cfg_mask =3D AVE_CTRL(0xff) | DET_DELAY(0xff) | SETTLING(0xff);
> > +
> > +	ret =3D stmpe_set_bits(stmpe, STMPE_REG_TSC_CFG, tsc_cfg_mask, tsc_cf=
g);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Could not config touch\n");
> > +		goto err_free_irq;
> > +	}
> > +
> > +	ret =3D stmpe_set_bits(stmpe, STMPE_REG_TSC_FRACTION_Z,
> > +			FRACTION_Z(0xff), FRACTION_Z(ts->fraction_z));
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Could not config touch\n");
> > +		goto err_free_irq;
> > +	}
> > +
> > +	ret =3D stmpe_set_bits(stmpe, STMPE_REG_TSC_I_DRIVE,
> > +			I_DRIVE(0xff), I_DRIVE(ts->i_drive));
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Could not config touch\n");
> > +		goto err_free_irq;
> > +	}
> > +
> > +	/* set FIFO to 1 for single point reading */
> > +	ret =3D stmpe_reg_write(stmpe, STMPE_REG_FIFO_TH, 1);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Could not set FIFO\n");
> > +		goto err_free_irq;
> > +	}
> > +
> > +	ret =3D stmpe_set_bits(stmpe, STMPE_REG_TSC_CTRL,
> > +			OP_MODE(0xff), OP_MODE(OP_MOD_XYZ));
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Could not set mode\n");
> > +		goto err_free_irq;
> > +	}
>=20
>=20
> Could we pull all these stmpe_set_bits(...) settig up the hardware into
> a separate function?
>=20

OK, will add a call ala stmpe_init_hw().

> > +
> > +	idev->name =3D STMPE_TS_NAME;
> > +	idev->id.bustype =3D BUS_I2C;
> > +	idev->evbit[0] =3D BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> > +	idev->keybit[BIT_WORD(BTN_TOUCH)] =3D BIT_MASK(BTN_TOUCH);
> > +
> > +	idev->open =3D stmpe_ts_open;
> > +	idev->close =3D stmpe_ts_close;
> > +
> > +	input_set_drvdata(idev, ts);
> > +
> > +	ret =3D input_register_device(idev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Could not register input device\n");
> > +		goto err_free_irq;
> > +	}
> > +
> > +	input_set_abs_params(idev, ABS_X, 0, XY_MASK, 0, 0);
> > +	input_set_abs_params(idev, ABS_Y, 0, XY_MASK, 0, 0);
> > +	input_set_abs_params(idev, ABS_PRESSURE, 0x0, 0xff, 0, 0);
>=20
> These calls better happen before registering the device.
>=20

OK. will fix.

> > +
> > +	return ret;
> > +
> > +err_free_irq:
> > +	free_irq(ts_irq, ts);
> > +err_free_input:
> > +	input_free_device(idev);
> > +	platform_set_drvdata(pdev, NULL);
> > +err_free_ts:
> > +	kfree(ts);
> > +err_out:
> > +	return ret;
> > +}
> > +
> > +static int __devexit stmpe_ts_remove(struct platform_device *pdev)
> > +{
> > +	struct stmpe_touch *ts =3D platform_get_drvdata(pdev);
> > +	unsigned int ts_irq =3D platform_get_irq_byname(pdev, "FIFO_TH");
> > +
> > +	cancel_delayed_work(&ts->work);
>=20
> cancel_delayed_work_sync().
>=20

Ah, forgot this, will fix.

> > +
> > +	stmpe_reg_write(ts->stmpe, STMPE_REG_FIFO_TH, 0);
> > +
> > +	stmpe_disable(ts->stmpe, STMPE_BLOCK_TOUCHSCREEN);
> > +
>=20
> I'd expect the 3 calls above being part of stmpe_ts_close().
>=20

OK, will fix.

> > +	free_irq(ts_irq, ts);
> > +
> > +	platform_set_drvdata(pdev, NULL);
> > +
> > +	input_unregister_device(ts->idev);
> > +	input_free_device(ts->idev);
> > +
> > +	kfree(ts);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver stmpe_ts_driver =3D {
> > +	.driver =3D {
> > +		   .name =3D STMPE_TS_NAME,
>=20
> 		.owner =3D THIS_MODULE,
>=20
> > +		   },
> > +	.probe =3D stmpe_input_probe,
> > +	.remove =3D __devexit_p(stmpe_ts_remove),
>=20
> No PM? Or simply not yet?
>=20

not yet. ;-) will add this in a later patch.

> > +};
> > +
> > +static int __init stmpe_ts_init(void)
> > +{
> > +	return platform_driver_register(&stmpe_ts_driver);
> > +}
> > +
> > +module_init(stmpe_ts_init);
> > +
> > +static void __exit stmpe_ts_exit(void)
> > +{
> > +	platform_driver_unregister(&stmpe_ts_driver);
> > +}
> > +
> > +module_exit(stmpe_ts_exit);
> > +
> > +MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
> > +MODULE_DESCRIPTION("STMPEXXX touchscreen driver");
> > +MODULE_LICENSE("GPL");
> > +MODULE_ALIAS("platform:" STMPE_TS_NAME);
> > --=20
> > 1.7.1
> >=20
>=20
> Thanks.

thanks

>=20
> --=20
> Dmitry

cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwjjo8ACgkQkLuxfMCkDTZFsACeP2jFLJn1Dkg5+UV4PLM4hWR5
0L0AnRr4We5Av9gvD4oWVM1wnk2qoDQU
=iJcy
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
