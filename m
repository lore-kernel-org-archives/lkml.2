Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0FXQcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:32:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58945 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab0FXQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hLIFWX14hxyGrpVSbXE09f/L312dCcrtLVnRo3HbfZ50iytRfR4+1EE1QLG3gtdCIv
         /WVpepZnhWvebBikuKyGvAPEm5yHWrtFl8/Ds7+6NSaF5beQDYiPtyTY8kxD7oZthzuc
         TyzdQxdKAr3yZYJ8x9e5x9z+gTQtoQqqJ1HC4=
Date: Thu, 24 Jun 2010 09:24:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Rabin VINCENT <rabin.vincent@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 5/5] input: STMPE touch controller support
Message-ID: <20100624162407.GA18899@core.coreip.homeip.net>
References: <1277382530-23734-1-git-send-email-l.fu@pengutronix.de>
 <1277389575-574-1-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277389575-574-1-git-send-email-l.fu@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luotao,

On Thu, Jun 24, 2010 at 04:26:15PM +0200, Luotao Fu wrote:
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 497964a..2691c62 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -47,3 +47,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+= tps6507x-ts.o
> +obj-$(CONFIG_TOUCHSCREEN_STMPE)		+= stmpe-ts.o

Please keep Makefile ordered alphabetically, it makes it easier to merge
stuff. Might try to do the same for Kconfig as well.

> +
> +static int inline __stmpe_reset_fifo(struct stmpe *stmpe)

Do not mark private function inline unless absolutely necessary - let
compiler figure out whether it makes sense to inline and what.

> +{
> +	int ret;
> +
> +	ret = stmpe_set_bits(stmpe, STMPE_REG_FIFO_STA,
> +			STMPE_FIFO_STA_RESET, STMPE_FIFO_STA_RESET);
> +	if (ret)
> +		return ret;
> +
> +	return stmpe_set_bits(stmpe, STMPE_REG_FIFO_STA,
> +			STMPE_FIFO_STA_RESET, 0);
> +}
> +
> +static void stmpe_work(struct work_struct *work)
> +{
> +	int int_sta;
> +	u32 timeout = 40;
> +
> +	struct stmpe_touch *ts =
> +	    container_of(work, struct stmpe_touch, work.work);
> +
> +	int_sta = stmpe_reg_read(ts->stmpe, STMPE_REG_INT_STA);
> +
> +	/* touch_det sometimes get desasserted or just get stuck. This appears
> +	 * to be a silicon bug, We still have to clearify this with the
> +	 * manufacture. As a workaround We release the key anyway if the
> +	 * touch_det keeps coming in after 4ms, while the FIFO contains no value
> +	 * during the whole time. */

I would appreciate if we could maintain the following format for
multiline comments (within input at least):

/*
 * This is a long long
 * long comment.
 */

> +	while ((int_sta & (1 << STMPE_IRQ_TOUCH_DET)) && (timeout > 0)) {
> +		timeout--;
> +		int_sta = stmpe_reg_read(ts->stmpe, STMPE_REG_INT_STA);
> +		udelay(100);
> +	}
> +
> +	/* reset the FIFO before we report release event */
> +	__stmpe_reset_fifo(ts->stmpe);
> +
> +	input_report_abs(ts->idev, ABS_PRESSURE, 0);
> +	input_sync(ts->idev);

Hmm, this function appears to be always reporting release, no matter
what the state of hardware is. I do not think this was the intention...
or was it?

> +}
> +
> +static irqreturn_t stmpe_ts_handler(int irq, void *data)
> +{
> +	u8 data_set[4];
> +	int x, y, z;
> +	struct stmpe_touch *ts = data;
> +
> +	/* Cancel scheduled polling for release if we have new value
> +	 * available. Wait if the polling is already running. */
> +	cancel_delayed_work_sync(&ts->work);
> +
> +	/*
> +	 * The FIFO sometimes just crashes and stops generating interrupts. This
> +	 * appears to be a silicon bug. We still have to clearify this with
> +	 * the manufacture. As a workaround we disable the TSC while we are
> +	 * collecting data and flush the FIFO after reading
> +	 */
> +	stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
> +				STMPE_TSC_CTRL_TSC_EN, 0);
> +
> +	stmpe_block_read(ts->stmpe, STMPE_REG_TSC_DATA_XYZ, 4, data_set);
> +
> +	x = (data_set[0] << 4) | (data_set[1] >> 4);
> +	y = ((data_set[1] & 0xf) << 8) | data_set[2];
> +	z = data_set[3];
> +
> +	input_report_abs(ts->idev, ABS_X, x);
> +	input_report_abs(ts->idev, ABS_Y, y);
> +	input_report_abs(ts->idev, ABS_PRESSURE, z);
> +	input_sync(ts->idev);
> +
> +       /* flush the FIFO after we have read out our values. */
> +	__stmpe_reset_fifo(ts->stmpe);
> +
> +	/* reenable the tsc */
> +	stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
> +			STMPE_TSC_CTRL_TSC_EN, STMPE_TSC_CTRL_TSC_EN);
> +
> +	/* start polling for touch_det to detect release */
> +	schedule_delayed_work(&ts->work, HZ / 50);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int stmpe_ts_open(struct input_dev *dev)
> +{
> +	struct stmpe_touch *ts = input_get_drvdata(dev);
> +	int ret = 0;
> +
> +	ret = __stmpe_reset_fifo(ts->stmpe);
> +	if (ret)
> +		return ret;
> +
> +	return stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
> +			STMPE_TSC_CTRL_TSC_EN, STMPE_TSC_CTRL_TSC_EN);
> +}
> +
> +static void stmpe_ts_close(struct input_dev *dev)
> +{
> +	struct stmpe_touch *ts = input_get_drvdata(dev);
> +
> +	stmpe_set_bits(ts->stmpe, STMPE_REG_TSC_CTRL,
> +			STMPE_TSC_CTRL_TSC_EN, 0);
> +}
> +
> +static int __devinit stmpe_input_probe(struct platform_device *pdev)
> +{
> +	struct stmpe *stmpe = dev_get_drvdata(pdev->dev.parent);
> +	struct stmpe_platform_data *pdata = stmpe->pdata;
> +	struct stmpe_touch *ts;
> +	struct input_dev *idev;
> +	struct stmpe_ts_platform_data *ts_pdata = NULL;
> +	int ret = 0;
> +	unsigned int ts_irq;
> +	u8 adc_ctrl1, adc_ctrl1_mask, tsc_cfg, tsc_cfg_mask;
> +
> +	ts_irq = platform_get_irq_byname(pdev, "FIFO_TH");
> +	if (ts_irq < 0)
> +		return ts_irq;
> +
> +	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
> +	if (!ts)
> +		goto err_out;
> +
> +	idev = input_allocate_device();
> +	if (!idev)
> +		goto err_free_ts;
> +
> +	platform_set_drvdata(pdev, ts);
> +	ts->stmpe = stmpe;
> +	ts->idev = idev;
> +
> +	if (pdata)
> +		ts_pdata = pdata->ts;
> +
> +	if (ts_pdata) {
> +		ts->sample_time = ts_pdata->sample_time;
> +		ts->mod_12b = ts_pdata->mod_12b;
> +		ts->ref_sel = ts_pdata->ref_sel;
> +		ts->adc_freq = ts_pdata->adc_freq;
> +		ts->ave_ctrl = ts_pdata->ave_ctrl;
> +		ts->touch_det_delay = ts_pdata->touch_det_delay;
> +		ts->settling = ts_pdata->settling;
> +		ts->fraction_z = ts_pdata->fraction_z;
> +		ts->i_drive = ts_pdata->i_drive;
> +	}
> +
> +	INIT_DELAYED_WORK(&ts->work, stmpe_work);
> +
> +	ret = request_threaded_irq(ts_irq, NULL, stmpe_ts_handler,
> +			IRQF_ONESHOT, STMPE_TS_NAME, ts);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to request IRQ %d\n", ts_irq);
> +		goto err_free_input;
> +	}
> +
> +	ret = stmpe_enable(stmpe, STMPE_BLOCK_TOUCHSCREEN | STMPE_BLOCK_ADC);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not enable clock for ADC and TS\n");
> +		goto err_free_irq;
> +	}
> +
> +	adc_ctrl1 = SAMPLE_TIME(ts->sample_time) | MOD_12B(ts->mod_12b) |
> +		REF_SEL(ts->ref_sel);
> +	adc_ctrl1_mask = SAMPLE_TIME(0xff) | MOD_12B(0xff) | REF_SEL(0xff);
> +	ret = stmpe_set_bits(stmpe, STMPE_REG_ADC_CTRL1,
> +			adc_ctrl1_mask, adc_ctrl1);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not setup ADC\n");
> +		goto err_free_irq;
> +	}
> +
> +	ret = stmpe_set_bits(stmpe, STMPE_REG_ADC_CTRL2,
> +			ADC_FREQ(0xff), ADC_FREQ(ts->adc_freq));
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not setup ADC\n");
> +		goto err_free_irq;
> +	}
> +
> +	tsc_cfg = AVE_CTRL(ts->ave_ctrl) | DET_DELAY(ts->touch_det_delay) |
> +			SETTLING(ts->settling);
> +	tsc_cfg_mask = AVE_CTRL(0xff) | DET_DELAY(0xff) | SETTLING(0xff);
> +
> +	ret = stmpe_set_bits(stmpe, STMPE_REG_TSC_CFG, tsc_cfg_mask, tsc_cfg);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not config touch\n");
> +		goto err_free_irq;
> +	}
> +
> +	ret = stmpe_set_bits(stmpe, STMPE_REG_TSC_FRACTION_Z,
> +			FRACTION_Z(0xff), FRACTION_Z(ts->fraction_z));
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not config touch\n");
> +		goto err_free_irq;
> +	}
> +
> +	ret = stmpe_set_bits(stmpe, STMPE_REG_TSC_I_DRIVE,
> +			I_DRIVE(0xff), I_DRIVE(ts->i_drive));
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not config touch\n");
> +		goto err_free_irq;
> +	}
> +
> +	/* set FIFO to 1 for single point reading */
> +	ret = stmpe_reg_write(stmpe, STMPE_REG_FIFO_TH, 1);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not set FIFO\n");
> +		goto err_free_irq;
> +	}
> +
> +	ret = stmpe_set_bits(stmpe, STMPE_REG_TSC_CTRL,
> +			OP_MODE(0xff), OP_MODE(OP_MOD_XYZ));
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not set mode\n");
> +		goto err_free_irq;
> +	}


Could we pull all these stmpe_set_bits(...) settig up the hardware into
a separate function?

> +
> +	idev->name = STMPE_TS_NAME;
> +	idev->id.bustype = BUS_I2C;
> +	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +	idev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +
> +	idev->open = stmpe_ts_open;
> +	idev->close = stmpe_ts_close;
> +
> +	input_set_drvdata(idev, ts);
> +
> +	ret = input_register_device(idev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not register input device\n");
> +		goto err_free_irq;
> +	}
> +
> +	input_set_abs_params(idev, ABS_X, 0, XY_MASK, 0, 0);
> +	input_set_abs_params(idev, ABS_Y, 0, XY_MASK, 0, 0);
> +	input_set_abs_params(idev, ABS_PRESSURE, 0x0, 0xff, 0, 0);

These calls better happen before registering the device.

> +
> +	return ret;
> +
> +err_free_irq:
> +	free_irq(ts_irq, ts);
> +err_free_input:
> +	input_free_device(idev);
> +	platform_set_drvdata(pdev, NULL);
> +err_free_ts:
> +	kfree(ts);
> +err_out:
> +	return ret;
> +}
> +
> +static int __devexit stmpe_ts_remove(struct platform_device *pdev)
> +{
> +	struct stmpe_touch *ts = platform_get_drvdata(pdev);
> +	unsigned int ts_irq = platform_get_irq_byname(pdev, "FIFO_TH");
> +
> +	cancel_delayed_work(&ts->work);

cancel_delayed_work_sync().

> +
> +	stmpe_reg_write(ts->stmpe, STMPE_REG_FIFO_TH, 0);
> +
> +	stmpe_disable(ts->stmpe, STMPE_BLOCK_TOUCHSCREEN);
> +

I'd expect the 3 calls above being part of stmpe_ts_close().

> +	free_irq(ts_irq, ts);
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	input_unregister_device(ts->idev);
> +	input_free_device(ts->idev);
> +
> +	kfree(ts);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver stmpe_ts_driver = {
> +	.driver = {
> +		   .name = STMPE_TS_NAME,

		.owner = THIS_MODULE,

> +		   },
> +	.probe = stmpe_input_probe,
> +	.remove = __devexit_p(stmpe_ts_remove),

No PM? Or simply not yet?

> +};
> +
> +static int __init stmpe_ts_init(void)
> +{
> +	return platform_driver_register(&stmpe_ts_driver);
> +}
> +
> +module_init(stmpe_ts_init);
> +
> +static void __exit stmpe_ts_exit(void)
> +{
> +	platform_driver_unregister(&stmpe_ts_driver);
> +}
> +
> +module_exit(stmpe_ts_exit);
> +
> +MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
> +MODULE_DESCRIPTION("STMPEXXX touchscreen driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:" STMPE_TS_NAME);
> -- 
> 1.7.1
> 

Thanks.

-- 
Dmitry
