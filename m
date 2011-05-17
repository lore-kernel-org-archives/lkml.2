Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1EQB5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 21:57:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56246 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1EQB5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 21:57:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=D5aoM/P+Y/oTNy7Vjd1HxDXvQ2yrMkR9iMOWWDWwGjrI+vGeMdIK+UX+uwt+dNm0/y
         CwwOpiLDyMCxuCWoMpB/76gB4pGZEW0VNEkiR9ThmuDd8CU8oLd47DypqW8ks7nFH7Ol
         A+DxAif6SN/M6JprLsso21vhIBQMNlKHbUl8I=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=O_mZEqMhOS_Fz0vAYCQ-XpyG4UA@mail.gmail.com>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
	<20110503172712.GE6538@lunn.ch>
	<BANLkTi=ncV3M1q5SXNdUaXmtfkZ8Wn9dmw@mail.gmail.com>
	<20110515133312.GM4071@lunn.ch>
	<BANLkTi=O_mZEqMhOS_Fz0vAYCQ-XpyG4UA@mail.gmail.com>
Date: Tue, 17 May 2011 10:57:11 +0900
X-Google-Sender-Auth: MxrQdaYomcL1KGo8qrAxU-Nyp0w
Message-ID: <BANLkTi=TDiAziQU0fYBiK_Npk0x50av7tA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Pinmux subsystem
From: Kyungmin Park <kmpark@infradead.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In real scenario, we can set the full pins at once, but sometimes it
needs to set the function only one,

e.g.,

static void __init goni_radio_init(void)
{
        int gpio;

        gpio = S5PV210_GPJ2(4);                 /* XMSMDATA_4 */
        gpio_request(gpio, "FM_INT");
        s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
        i2c1_devs[0].irq = gpio_to_irq(gpio);

        gpio = S5PV210_GPJ2(5);                 /* XMSMDATA_5 */
        gpio_request(gpio, "FM_RST");
        gpio_direction_output(gpio, 1);
}

In this case we only need to set the function at interrupt by like
s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
So pinmux function provides this feature also.

How do you think?

Thank you,
Kyungmin Park


On Mon, May 16, 2011 at 2:50 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> 2011/5/15 Andrew Lunn <andrew@lunn.ch>:
>
>> With a bit of scripting, came to the following results. Each line is
>> on pinmux function description what would be needed in the driver. The
>> number at the front says how many boards would use it. In total there
>> are 33 descriptions needed. Of these, 18 are used only once. This to
>> me suggests the board needs to be able to specify a pin description
>> when there is no reuse with other boards.
>
> As indicated elsewhere in this thread, a pinmux driver can pass in
> platform/package/board/system data just like any other platform
> driver in the kernel tree can.
>
> You will have to specify it somehow in a custom header file, just
> like with any other platform driver.
>
> Example from:
> arch/arm/mach-orion5x/ls-chl-setup.c:
>
> static struct gpio_led lschl_led_pins[] = {
>        {
>                .name = "alarm:red",
>                .gpio = LSCHL_GPIO_LED_ALARM,
>                .active_low = 1,
>        }, {
>                .name = "info:amber",
>                .gpio = LSCHL_GPIO_LED_INFO,
>                .active_low = 1,
>        }, {
>                .name = "func:blue:top",
>                .gpio = LSCHL_GPIO_LED_FUNC,
>                .active_low = 1,
>        }, {
>                .name = "power:blue:bottom",
>                .gpio = LSCHL_GPIO_LED_PWR,
>        },
> };
>
> static struct gpio_led_platform_data lschl_led_data = {
>        .leds = lschl_led_pins,
>        .num_leds = ARRAY_SIZE(lschl_led_pins),
> };
>
> static struct platform_device lschl_leds = {
>        .name = "leds-gpio",
>        .id = -1,
>        .dev = {
>                .platform_data = &lschl_led_data,
>        },
> };
>
> Still, the driver for these LEDs is in
> drivers/leds/leds-gpio.c and the above structure is
> described in include/linux/leds.h
>
> There is no difference between this and letting
> drivers/pinmux/pinmux-orion.c have a header file in
> include/linux/pinmux/orion.h and pass in necessary board
> data that way.
>
> Are we now in agreement that this will work just fine?
>
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
