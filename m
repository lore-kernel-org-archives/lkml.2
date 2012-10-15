Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2JONAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:00:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52711 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2JONAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:00:13 -0400
MIME-Version: 1.0
In-Reply-To: <1350052469-27802-2-git-send-email-larsi@wh2.tu-dresden.de>
References: <20120925085559.GL28670@sortiz-mobl>
	<1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de>
	<1350052469-27802-2-git-send-email-larsi@wh2.tu-dresden.de>
Date: Mon, 15 Oct 2012 15:00:12 +0200
Message-ID: <CACRpkdadDJDU_UUmdFoKBUm49_1CPjBnibq_RsiSeu+y4zRTsw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        grant.likely@secretlab.ca, Lars Poeschel <poeschel@lemonage.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 4:34 PM, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:

> From: Lars Poeschel <poeschel@lemonage.de>
>
> This adds the mfd cell to use the gpio a and gpio b part
> of the Nano River Technologies viperboard.
>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

OK...
(...)
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
(...)

> +#define VPRBRD_GPIOA_CLK_1             0           /* (1us   = 1MHz)   */
> +#define VPRBRD_GPIOA_CLK_10            1           /* (10us  = 100kHz) */
> +#define VPRBRD_GPIOA_CLK_100           2           /* (100us = 10kHz)  */
> +#define VPRBRD_GPIOA_CLK_1000          3           /* (1ms   = 1kHz)   */
> +#define VPRBRD_GPIOA_CLK_10000         4           /* (10ms  = 100Hz)  */
> +#define VPRBRD_GPIOA_CLK_100000                5           /* (100ms = 10Hz)   */

So instead of #defining something noone understands and
then writing in the comment what it actually means, why
don't you just:

#define VPRBRD_GPIOA_CLK_1MHZ           0
#define VPRBRD_GPIOA_CLK_100KHZ          1

or maybe:

#define VPRBRD_GPIOA_CLK_PERIOD_1US             0
#define VPRBRD_GPIOA_CLK_PERIOD_10US            1

or something else you will understand immediately when reading the
code?

(...)
> +struct __packed vprbrd_gpioa_msg {

__packed always goes *after* the struct does it not?

> +       u8 cmd;
> +       u8 clk;
> +       u8 offset;
> +       u8 t1;
> +       u8 t2;
> +       u8 invert;
> +       u8 pwmlevel;
> +       u8 outval;
> +       u8 risefall;
> +       u8 answer;
> +       u8 __fill;
> +};  <- i.e. here, before the semicolon.

> +/* gpioa sampling clock module parameter */
> +static unsigned char gpioa_clk = 3;

Isn't this actually

static unsigned char gpioa_clk = VPRBRD_GPIOA_CLK_1000

> +module_param(gpioa_clk, byte, 0);
> +MODULE_PARM_DESC(gpioa_clk, "gpio a sampling clk (default is 3 for 1 kHz)");

So if you're adding very magic module parameters maybe
this magic number isn't such a good idea. Oh well, there
are stranger things in the world so OK...

(...)
> +static int vprbrd_gpioa_get(struct gpio_chip *chip,
> +               unsigned offset)
> +{
> +       int ret, answer, error = 0;
> +       struct vprbrd_gpio *gpio =
> +                       container_of(chip, struct vprbrd_gpio, gpioa);
> +       struct vprbrd *vb = gpio->vb;
> +       struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg *)vb->buf;
> +
> +       /* if io is set to output, just return the saved value */
> +       if (gpio->gpioa_out & (1 << offset))
> +               return gpio->gpioa_val & (1 << offset);

That's not going to work if the hardware changes state
behind the back of the driver right? Oh well, maybe
it doesn't matter.

The rest does some clever USB marshalling that I trust
is doing what it should :-)

> +       ret = usb_control_msg(vb->usb_dev, usb_sndctrlpipe(vb->usb_dev, 0),
> +               0xed, 0x40, 0x0000, 0x0000, gamsg,
> +               sizeof(struct vprbrd_gpioa_msg), 100);

0xed? 0x40? 100?

Can you #define the magic constants, or are they already available
in some existing header file?

(The zeros are OK.)

> +       if (ret != sizeof(struct vprbrd_gpioa_msg))
> +               error = -EREMOTEIO;
> +
> +       ret = usb_control_msg(vb->usb_dev, usb_rcvctrlpipe(vb->usb_dev, 0),
> +               0xed, 0xc0, 0x0000, 0x0000, gamsg,
> +               sizeof(struct vprbrd_gpioa_msg), 100);

Dito...

Same comment for *set, *direction_input, *direction_output,
*setdir,

(...)
> +static int __devinit vprbrd_gpio_probe(struct platform_device *pdev)
> +{
> +       struct vprbrd *vb = dev_get_drvdata(pdev->dev.parent);
> +       struct vprbrd_gpio *vb_gpio;
> +       int ret;
> +
> +       vb_gpio = kzalloc(sizeof(*vb_gpio), GFP_KERNEL);

Can you use devm_kzalloc(&pdev->dev, ...)?

> +       if (vb_gpio == NULL)
> +               return -ENOMEM;
> +
> +       vb_gpio->vb = vb;
> +       /* registering gpio a */
> +       vb_gpio->gpioa.label = "viperboard gpio a";
> +       vb_gpio->gpioa.dev = &pdev->dev;
> +       vb_gpio->gpioa.owner = THIS_MODULE;
> +       vb_gpio->gpioa.base = -1;
> +       vb_gpio->gpioa.ngpio = 16;
> +       vb_gpio->gpioa.can_sleep = 1;
> +       vb_gpio->gpioa.set = vprbrd_gpioa_set;
> +       vb_gpio->gpioa.get = vprbrd_gpioa_get;
> +       vb_gpio->gpioa.direction_input = vprbrd_gpioa_direction_input;
> +       vb_gpio->gpioa.direction_output = vprbrd_gpioa_direction_output;
> +       ret = gpiochip_add(&vb_gpio->gpioa);
> +       if (ret < 0) {
> +               dev_err(vb_gpio->gpioa.dev, "could not add gpio a");
> +               goto err_gpioa;
> +       }
> +
> +       /* registering gpio b */
> +       vb_gpio->gpiob.label = "viperboard gpio b";
> +       vb_gpio->gpiob.dev = &pdev->dev;
> +       vb_gpio->gpiob.owner = THIS_MODULE;
> +       vb_gpio->gpiob.base = -1;
> +       vb_gpio->gpiob.ngpio = 16;
> +       vb_gpio->gpiob.can_sleep = 1;
> +       vb_gpio->gpiob.set = vprbrd_gpiob_set;
> +       vb_gpio->gpiob.get = vprbrd_gpiob_get;
> +       vb_gpio->gpiob.direction_input = vprbrd_gpiob_direction_input;
> +       vb_gpio->gpiob.direction_output = vprbrd_gpiob_direction_output;
> +       ret = gpiochip_add(&vb_gpio->gpiob);
> +       if (ret < 0) {
> +               dev_err(vb_gpio->gpiob.dev, "could not add gpio b");
> +               goto err_gpiob;
> +       }
> +
> +       platform_set_drvdata(pdev, vb_gpio);
> +
> +       return ret;
> +
> +err_gpiob:
> +       ret = gpiochip_remove(&vb_gpio->gpioa);
> +
> +err_gpioa:
> +       kfree(vb_gpio);

With devm_kzalloc you don't need this free.

(...)
> +static int __devexit vprbrd_gpio_remove(struct platform_device *pdev)
> +{
> +       struct vprbrd_gpio *vb_gpio = platform_get_drvdata(pdev);
> +       int ret;
> +
> +       ret = gpiochip_remove(&vb_gpio->gpiob);
> +       if (ret == 0)
> +               ret = gpiochip_remove(&vb_gpio->gpioa);
> +       if (ret == 0)
> +               kfree(vb_gpio);

Nor this.

Apart from this the driver is looking nice!

Yours,
Linus Walleij
