Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab2LQQuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:50:50 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52214 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2LQQut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:50:49 -0500
MIME-Version: 1.0
In-Reply-To: <000001cddc2f$a2b2e8a0$e818b9e0$%han@samsung.com>
References: <000001cddc2f$a2b2e8a0$e818b9e0$%han@samsung.com>
Date: Mon, 17 Dec 2012 11:50:48 -0500
Message-ID: <CAHdPZaOCy8uOHmoKEiLqZg8RmM10FDSapJitJgWX1ebhRyvkXw@mail.gmail.com>
Subject: Re: PATCH] backlight: add lms501kf03 LCD driver
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> +static int lms501kf03_spi_write(struct lms501kf03 *lcd, unsigned char address,
> +                               unsigned char command)
> +{
> +       int ret;
> +
> +       ret = lms501kf03_spi_write_byte(lcd, address, command);
> +
> +       return ret;

there is redundancy here,
you can do just removing the ret and do return.

> +}
> +
> +static int lms501kf03_panel_send_sequence(struct lms501kf03 *lcd,
> +                                       const unsigned short *wbuf)
> +{
> +       int ret = 0, i = 0;
> +
> +       while (wbuf[i] != ENDDEF) {
> +               if (i == 0)
> +                       ret = lms501kf03_spi_write(lcd, COMMAND_ONLY, wbuf[i]);
> +               else
> +                       ret = lms501kf03_spi_write(lcd, DATA_ONLY, wbuf[i]);
> +               if (ret)
> +                       break;
> +               i += 1;
> +       }
> +
> +       return ret;
> +}
> +
> +static int lms501kf03_ldi_init(struct lms501kf03 *lcd)
> +{
> +       int ret, i;
> +       static const unsigned short *init_seq[] = {
> +               seq_password,
> +               seq_power,
> +               seq_display,
> +               seq_rgb_if,
> +               seq_display_inv,
> +               seq_vcom,
> +               seq_gate,
> +               seq_panel,
> +               seq_col_mod,
> +               seq_w_gamma,
> +               seq_rgb_gamma,
> +               seq_sleep_out,
> +       };
> +
> +       for (i = 0; i < ARRAY_SIZE(init_seq); i++) {
> +               ret = lms501kf03_panel_send_sequence(lcd, init_seq[i]);
> +               if (ret)
> +                       break;
> +       }
> +       /* according to the datasheet, 120ms delay time is required. */
why the 120ms delay required would be good to specify as comment. or
you can put the link to datasheet if available.

> +       msleep(120);
> +
> +       return ret;
> +}
> +
> +static int lms501kf03_ldi_enable(struct lms501kf03 *lcd)
> +{
> +       return lms501kf03_panel_send_sequence(lcd, seq_display_on);
> +}
> +
> +static int lms501kf03_ldi_disable(struct lms501kf03 *lcd)
> +{
> +       return lms501kf03_panel_send_sequence(lcd, seq_display_off);
> +}
> +
> +static int lms501kf03_power_is_on(int power)
> +{
> +       return (power) <= FB_BLANK_NORMAL;
> +}
> +
> +static int lms501kf03_power_on(struct lms501kf03 *lcd)
> +{
> +       int ret = 0;
> +       struct lcd_platform_data *pd;
> +
> +       pd = lcd->lcd_pd;
> +
> +       if (!pd->power_on) {
> +               dev_err(lcd->dev, "power_on is NULL.\n");
> +               return -EFAULT;
we may need to do -EINVAL instead of EFAULT as EFAULT tends to be for
the invalid memory addresses.

> +       } else {
> +               pd->power_on(lcd->ld, 1);
> +               msleep(pd->power_on_delay);
> +       }
> +
> +       if (!pd->reset) {
> +               dev_err(lcd->dev, "reset is NULL.\n");
> +               return -EFAULT;

may be here too..

> +       } else {
> +               pd->reset(lcd->ld);
> +               msleep(pd->reset_delay);
> +       }
> +
> +       ret = lms501kf03_ldi_init(lcd);
> +       if (ret) {
> +               dev_err(lcd->dev, "failed to initialize ldi.\n");
> +               return ret;
> +       }
> +
> +       ret = lms501kf03_ldi_enable(lcd);
> +       if (ret) {
> +               dev_err(lcd->dev, "failed to enable ldi.\n");
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int lms501kf03_power_off(struct lms501kf03 *lcd)
> +{
> +       int ret = 0;
> +       struct lcd_platform_data *pd;
> +
> +       pd = lcd->lcd_pd;
> +
> +       ret = lms501kf03_ldi_disable(lcd);
> +       if (ret) {
> +               dev_err(lcd->dev, "lcd setting failed.\n");
> +               return -EIO;
> +       }
> +
> +       msleep(pd->power_off_delay);
> +
> +       pd->power_on(lcd->ld, 0);
> +

seems that you are calling the core lcd framework api, i am curious to
know why, :p , and obviously i dunno why its calling that way.

> +       return 0;
> +}
> +
> +static int lms501kf03_power(struct lms501kf03 *lcd, int power)
> +{
> +       int ret = 0;
> +
> +       if (lms501kf03_power_is_on(power) &&
> +               !lms501kf03_power_is_on(lcd->power))
> +               ret = lms501kf03_power_on(lcd);
> +       else if (!lms501kf03_power_is_on(power) &&
> +               lms501kf03_power_is_on(lcd->power))
> +               ret = lms501kf03_power_off(lcd);
> +

seems that ret is used unitialised in this function bug is covered by
ret = 0 assignment, but why that else case is missed, or i am just
misreading?

> +       if (!ret)
> +               lcd->power = power;
> +
> +       return ret;
> +}
> +

[snip]
> +
> +static int lms501kf03_probe(struct spi_device *spi)
> +{
> +       struct lms501kf03 *lcd = NULL;
> +       struct lcd_device *ld = NULL;
> +       int ret = 0;
> +
> +       lcd = devm_kzalloc(&spi->dev, sizeof(struct lms501kf03), GFP_KERNEL);
> +       if (!lcd)
> +               return -ENOMEM;
> +

glad you used devm api.

> +       /* lms501kf03 lcd panel uses 3-wire 9-bit SPI Mode. */
> +       spi->bits_per_word = 9;
> +
> +       ret = spi_setup(spi);
> +       if (ret < 0) {
> +               dev_err(&spi->dev, "spi setup failed.\n");
> +               return ret;
> +       }
> +
> +       lcd->spi = spi;
> +       lcd->dev = &spi->dev;
> +
> +       lcd->lcd_pd = spi->dev.platform_data;
> +       if (!lcd->lcd_pd) {
> +               dev_err(&spi->dev, "platform data is NULL\n");
> +               return -EFAULT;
May be here too -EINVAL or some correct errno should be returned not
the EFAULT no?

> +       }
> +
> +       ld = lcd_device_register("lms501kf03", &spi->dev, lcd,
> +                               &lms501kf03_lcd_ops);
> +       if (IS_ERR(ld))
> +               return PTR_ERR(ld);
> +
> +       lcd->ld = ld;
> +

[snip]

> +#if defined(CONFIG_PM)
> +static unsigned int before_power;
> +
> +static int lms501kf03_suspend(struct spi_device *spi, pm_message_t mesg)
> +{
> +       int ret = 0;
> +       struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
> +
> +       dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
> +
> +       before_power = lcd->power;
> +
> +       /*
> +        * when lcd panel is suspend, lcd panel becomes off
> +        * regardless of status.
> +        */
> +       ret = lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
> +

returning ret is redundant just like that return that is mentioned
above. you can return as is.

> +       return ret;
> +}
> +
> +static int lms501kf03_resume(struct spi_device *spi)
> +{
> +       int ret = 0;
> +       struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
> +
> +       lcd->power = FB_BLANK_POWERDOWN;
> +
> +       ret = lms501kf03_power(lcd, FB_BLANK_UNBLANK);
> +
> +       return ret;
> +}

here too..
> +#else
> +#define lms501kf03_suspend     NULL
> +#define lms501kf03_resume      NULL
> +#endif
> +
> +void lms501kf03_shutdown(struct spi_device *spi)
> +{
> +       struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
> +
> +       lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
> +}
> +
> +static struct spi_driver lms501kf03_driver = {
> +       .driver = {
> +               .name   = "lms501kf03",
> +               .owner  = THIS_MODULE,
> +       },
> +       .probe          = lms501kf03_probe,
> +       .remove         = lms501kf03_remove,
> +       .shutdown       = lms501kf03_shutdown,
> +       .suspend        = lms501kf03_suspend,
> +       .resume         = lms501kf03_resume,
> +};
> +
> +module_spi_driver(lms501kf03_driver);
> +

nice, using module_spi_driver reduce the duplication of the
spi_register unregister code.
