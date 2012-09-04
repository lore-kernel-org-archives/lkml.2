Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab2IDScx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:32:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41262 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab2IDScv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:32:51 -0400
MIME-Version: 1.0
In-Reply-To: <50450472.5090603@gmail.com>
References: <1346653236-19728-1-git-send-email-kth3321@gmail.com>
	<1346693799.3485.2.camel@taehun-desktop>
	<50450472.5090603@gmail.com>
Date: Wed, 5 Sep 2012 03:32:50 +0900
Message-ID: <CAOkfWjfEO43WOtaM24P4xp_yW9FWfL5q99yNwftoXDONCAM9Kw@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: S3C24XX: Add WIZnet W5300E01-ARM board support
From: Taehun Kim <kth3321@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/4 Sylwester Nawrocki <sylvester.nawrocki@gmail.com>:
> On 09/03/2012 07:36 PM, Taehun Kim wrote:
>> +static void __init w5300e01_init(void)
>> +{
>> +     s3c_nand_set_platdata(&w5300e01_nand_info);
>> +     platform_add_devices(w5300e01_devices, ARRAY_SIZE(w5300e01_devices));
>> +
>> +     /* W5300 interrupt pin. */
>> +     s3c_gpio_cfgpin(S3C2410_GPF(0), S3C2410_GPIO_IRQ);
>> +
>> +     s3c_gpio_cfgpin(S3C2410_GPF(4), S3C2410_GPIO_OUTPUT);
>> +     s3c_gpio_cfgpin(S3C2410_GPF(5), S3C2410_GPIO_OUTPUT);
>> +     s3c_gpio_cfgpin(S3C2410_GPF(6), S3C2410_GPIO_OUTPUT);
>> +     s3c_gpio_cfgpin(S3C2410_GPF(7), S3C2410_GPIO_OUTPUT);
>
> Please don't use these obsolete S3C2410_GPIO_* defines, they will be
> gone soon, if aren't yet.
>
>> +     gpio_set_value(S3C2410_GPF(0), 1);
>> +     gpio_set_value(S3C2410_GPF(4), 1);
>> +     gpio_set_value(S3C2410_GPF(5), 1);
>> +     gpio_set_value(S3C2410_GPF(6), 1);
>> +     gpio_set_value(S3C2410_GPF(7), 1);
>
> Instead I would do something like:
>
> 8<-----------------------------------------------------------------
>
> static const struct gpio gpios[] = {
>         { S3C2410_GPF(4), GPIOF_OUT_INIT_HIGH, NULL },
>         { S3C2410_GPF(5), GPIOF_OUT_INIT_HIGH, NULL },
>         { S3C2410_GPF(6), GPIOF_OUT_INIT_HIGH, NULL },
>         { S3C2410_GPF(7), GPIOF_OUT_INIT_HIGH, NULL },
> };
>
> if (!WARN_ON(gpio_request_array(gpios, ARRAY_SIZE(gpios)))
>         gpios_free_array(gpios);
>
> /* W5300 interrupt pin. */
> if (!WARN_ON(gpio_request(S3C2410_GPF(0), GPIOF_IN, NULL))) {
>         s3c_gpio_cfgpin(S3C2410_GPF(0), S3C_GPIO_SFN(2)); /* EINT0 */
>         gpio_free(S3C2410_GPF(0));
> }
>
> 8<-----------------------------------------------------------------
>
> --
>
> Regards,
> Sylwester

Thank you for your feedback. I will change the gpio routine as follows:

-----------------------------------------------------------------

static const struct gpio w5300e01_gpios[] = {
	{ S3C2410_GPF(4), GPIOF_OUT_INIT_HIGH, NULL },
	{ S3C2410_GPF(5), GPIOF_OUT_INIT_HIGH, NULL },
	{ S3C2410_GPF(6), GPIOF_OUT_INIT_HIGH, NULL },
	{ S3C2410_GPF(7), GPIOF_OUT_INIT_HIGH, NULL },
};

static void __init w5300_init(void)
{
	/* W5300 interrupt pin. */
	if (WARN_ON(gpio_request(S3C2410_GPF(0), "W5300 irq"))) {
		pr_err("%s: GPIO request failed.\n", __func__);
		return;
	}
	s3c_gpio_cfgpin(S3C2410_GPF(0), S3C_GPIO_SFN(2)); /* EINT0 */
}

static void __init w5300e01_init(void)
{
	s3c_nand_set_platdata(&w5300e01_nand_info);
	platform_add_devices(w5300e01_devices, ARRAY_SIZE(w5300e01_devices));

	if (WARN_ON(gpio_request_array(w5300e01_gpios, ARRAY_SIZE(w5300e01_gpios))))
		pr_err("%s: GPIO request failed\n", __func__);

	w5300_init();
	s3c_pm_init();
}
-----------------------------------------------------------------

Does anybody have a other comments?
