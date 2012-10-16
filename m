Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2JPGvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:51:45 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:38125 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab2JPGvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:51:44 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.724
From: Lars Poeschel <poeschel@lemonage.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
Date: Tue, 16 Oct 2012 08:51:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
References: <20120925085559.GL28670@sortiz-mobl> <1350052469-27802-2-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkdadDJDU_UUmdFoKBUm49_1CPjBnibq_RsiSeu+y4zRTsw@mail.gmail.com>
In-Reply-To: <CACRpkdadDJDU_UUmdFoKBUm49_1CPjBnibq_RsiSeu+y4zRTsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210160851.33324.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012 at 15:00:12, Linus Walleij wrote:

> > +#define VPRBRD_GPIOA_CLK_1             0           /* (1us   = 1MHz)  
> > */ +#define VPRBRD_GPIOA_CLK_10            1           /* (10us  =
> > 100kHz) */ +#define VPRBRD_GPIOA_CLK_100           2           /* (100us
> > = 10kHz)  */ +#define VPRBRD_GPIOA_CLK_1000          3           /* (1ms
> >   = 1kHz)   */ +#define VPRBRD_GPIOA_CLK_10000         4           /*
> > (10ms  = 100Hz)  */ +#define VPRBRD_GPIOA_CLK_100000                5   
> >        /* (100ms = 10Hz)   */
> 
> So instead of #defining something noone understands and
> then writing in the comment what it actually means, why
> don't you just:
> 
> #define VPRBRD_GPIOA_CLK_1MHZ           0
> #define VPRBRD_GPIOA_CLK_100KHZ          1
> 
> or maybe:
> 
> #define VPRBRD_GPIOA_CLK_PERIOD_1US             0
> #define VPRBRD_GPIOA_CLK_PERIOD_10US            1
> 
> or something else you will understand immediately when reading the
> code?

Yes, you are right. I was too involved with my hardware to see this. I will 
change this.
 
> > +struct __packed vprbrd_gpioa_msg {
> 
> __packed always goes *after* the struct does it not?
> 
> > +       u8 cmd;
> > +       u8 clk;
> > +       u8 offset;
> > +       u8 t1;
> > +       u8 t2;
> > +       u8 invert;
> > +       u8 pwmlevel;
> > +       u8 outval;
> > +       u8 risefall;
> > +       u8 answer;
> > +       u8 __fill;
> > +};  <- i.e. here, before the semicolon.

GCC does allow both alternatives. See description of packed attribute under:

http://gcc.gnu.org/onlinedocs/gcc/Type-Attributes.html#Type-Attributes

But since most kernel code does it right before the semicolon, I will change 
that too.

> > +/* gpioa sampling clock module parameter */
> > +static unsigned char gpioa_clk = 3;
> 
> Isn't this actually
> 
> static unsigned char gpioa_clk = VPRBRD_GPIOA_CLK_1000
> 
> > +module_param(gpioa_clk, byte, 0);
> > +MODULE_PARM_DESC(gpioa_clk, "gpio a sampling clk (default is 3 for 1
> > kHz)");
> 
> So if you're adding very magic module parameters maybe
> this magic number isn't such a good idea. Oh well, there
> are stranger things in the world so OK...

Also I will change this to be more descriptive.

> > +static int vprbrd_gpioa_get(struct gpio_chip *chip,
> > +               unsigned offset)
> > +{
> > +       int ret, answer, error = 0;
> > +       struct vprbrd_gpio *gpio =
> > +                       container_of(chip, struct vprbrd_gpio, gpioa);
> > +       struct vprbrd *vb = gpio->vb;
> > +       struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg
> > *)vb->buf; +
> > +       /* if io is set to output, just return the saved value */
> > +       if (gpio->gpioa_out & (1 << offset))
> > +               return gpio->gpioa_val & (1 << offset);
> 
> That's not going to work if the hardware changes state
> behind the back of the driver right? Oh well, maybe
> it doesn't matter.

I thought about that and then did this "cache" only in case the gpio is a 
output to save to usb ping-pong that is needed otherwise. I thought that 
nothing can change to state of the output but the driver itself.

> The rest does some clever USB marshalling that I trust
> is doing what it should :-)
> 
> > +       ret = usb_control_msg(vb->usb_dev, usb_sndctrlpipe(vb->usb_dev,
> > 0), +               0xed, 0x40, 0x0000, 0x0000, gamsg,
> > +               sizeof(struct vprbrd_gpioa_msg), 100);
> 
> 0xed? 0x40? 100?
> 
> Can you #define the magic constants, or are they already available
> in some existing header file?
> 
> (The zeros are OK.)

No there are no constants in some existing file. I will introduce them.

> > +       if (ret != sizeof(struct vprbrd_gpioa_msg))
> > +               error = -EREMOTEIO;
> > +
> > +       ret = usb_control_msg(vb->usb_dev, usb_rcvctrlpipe(vb->usb_dev,
> > 0), +               0xed, 0xc0, 0x0000, 0x0000, gamsg,
> > +               sizeof(struct vprbrd_gpioa_msg), 100);
> 
> Dito...
> 
> Same comment for *set, *direction_input, *direction_output,
> *setdir,
> 
> (...)
> 
> > +static int __devinit vprbrd_gpio_probe(struct platform_device *pdev)
> > +{
> > +       struct vprbrd *vb = dev_get_drvdata(pdev->dev.parent);
> > +       struct vprbrd_gpio *vb_gpio;
> > +       int ret;
> > +
> > +       vb_gpio = kzalloc(sizeof(*vb_gpio), GFP_KERNEL);
> 
> Can you use devm_kzalloc(&pdev->dev, ...)?

Ofcourse. Thanks for the hint. I did not knew this function.
 
> > +       if (vb_gpio == NULL)
> > +               return -ENOMEM;
> > +
> > +       vb_gpio->vb = vb;
> > +       /* registering gpio a */
> > +       vb_gpio->gpioa.label = "viperboard gpio a";
> > +       vb_gpio->gpioa.dev = &pdev->dev;
> > +       vb_gpio->gpioa.owner = THIS_MODULE;
> > +       vb_gpio->gpioa.base = -1;
> > +       vb_gpio->gpioa.ngpio = 16;
> > +       vb_gpio->gpioa.can_sleep = 1;
> > +       vb_gpio->gpioa.set = vprbrd_gpioa_set;
> > +       vb_gpio->gpioa.get = vprbrd_gpioa_get;
> > +       vb_gpio->gpioa.direction_input = vprbrd_gpioa_direction_input;
> > +       vb_gpio->gpioa.direction_output = vprbrd_gpioa_direction_output;
> > +       ret = gpiochip_add(&vb_gpio->gpioa);
> > +       if (ret < 0) {
> > +               dev_err(vb_gpio->gpioa.dev, "could not add gpio a");
> > +               goto err_gpioa;
> > +       }
> > +
> > +       /* registering gpio b */
> > +       vb_gpio->gpiob.label = "viperboard gpio b";
> > +       vb_gpio->gpiob.dev = &pdev->dev;
> > +       vb_gpio->gpiob.owner = THIS_MODULE;
> > +       vb_gpio->gpiob.base = -1;
> > +       vb_gpio->gpiob.ngpio = 16;
> > +       vb_gpio->gpiob.can_sleep = 1;
> > +       vb_gpio->gpiob.set = vprbrd_gpiob_set;
> > +       vb_gpio->gpiob.get = vprbrd_gpiob_get;
> > +       vb_gpio->gpiob.direction_input = vprbrd_gpiob_direction_input;
> > +       vb_gpio->gpiob.direction_output = vprbrd_gpiob_direction_output;
> > +       ret = gpiochip_add(&vb_gpio->gpiob);
> > +       if (ret < 0) {
> > +               dev_err(vb_gpio->gpiob.dev, "could not add gpio b");
> > +               goto err_gpiob;
> > +       }
> > +
> > +       platform_set_drvdata(pdev, vb_gpio);
> > +
> > +       return ret;
> > +
> > +err_gpiob:
> > +       ret = gpiochip_remove(&vb_gpio->gpioa);
> > +
> > +err_gpioa:
> > +       kfree(vb_gpio);
> 
> With devm_kzalloc you don't need this free.
> 
> (...)
> 
> > +static int __devexit vprbrd_gpio_remove(struct platform_device *pdev)
> > +{
> > +       struct vprbrd_gpio *vb_gpio = platform_get_drvdata(pdev);
> > +       int ret;
> > +
> > +       ret = gpiochip_remove(&vb_gpio->gpiob);
> > +       if (ret == 0)
> > +               ret = gpiochip_remove(&vb_gpio->gpioa);
> > +       if (ret == 0)
> > +               kfree(vb_gpio);
> 
> Nor this.
> 
> Apart from this the driver is looking nice!

Thank you for your feedback. I will wait some time for responses of the other 
maintainers and then do a version 3 of the whole patchset.

Regards,
Lars
