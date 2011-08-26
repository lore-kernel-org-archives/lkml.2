Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1HZRMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:12:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7593 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1HZRMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:12:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 26 Aug 2011 10:12:11 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Barry Song <21cnbao@gmail.com>, Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Date: Fri, 26 Aug 2011 10:12:08 -0700
Subject: RE: [PATCH 0/4 v4] pin controller subsystem v4
Thread-Topic: [PATCH 0/4 v4] pin controller subsystem v4
Thread-Index: Acxjk7pwkdSG1YzEQx6NCRmQMIZDAAAfXzFA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B24A4113@HQMAIL01.nvidia.com>
References: <1313747619-32222-1-git-send-email-linus.walleij@stericsson.com>
 <CAGsJ_4z7s-ibmUuR1DA6Jps030dRrnE8M0dUWHoMhMPFtyyY_A@mail.gmail.com>
 <CACRpkdb4-0TfO-viUoZyW3VoLnVuo2ztHTX=8Hef3_RYWB52vg@mail.gmail.com>
 <CAGsJ_4yEXEajH1JyNjnYE0hg13Fgd7bdiMNFs2fp6Ou=h_9N9g@mail.gmail.com>
In-Reply-To: <CAGsJ_4yEXEajH1JyNjnYE0hg13Fgd7bdiMNFs2fp6Ou=h_9N9g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7QHCb1r005793

Barry Song wrote at Thursday, August 25, 2011 7:59 PM:
> 2011/8/22 Linus Walleij <linus.walleij@linaro.org>:
> > On Sun, Aug 21, 2011 at 4:42 PM, Barry Song <21cnbao@gmail.com> wrote:
> >
> >> it seems there is not an actual example that gpio requests pin from
> >> pinctrl yet. i might give one on SiRFprimaII.
> >
> > No good example yet, no.
> >
> > The reason is that for the U300 that I use as guinea pig, the
> > GPIO driver is tangled up in discussions about how to handle
> > the special control mechanics like requesting muxing and
> > biasing pins. Right now it seems easier to rewrite all that
> > to use the new pinctrl subsystem rather than actually trying
> > to work it into the GPIO subsystem first and refactor from
> > there, and that needs quite a bit of upfront work...
> 
> Do you want the pinmux_request_gpio called by the gpiolib driver or by
> every device driver who uses this gpio?
> Do you think the following make sense in gpiolib driver?
>
> static int xxx_gpio_request(struct gpio_chip *chip, unsigned offset)
> {
>         int ret = 0;
> 
>         ret = pinmux_request_gpio(chip->base + offset);
>         if (ret)
>                 goto out;
>         .....
> out:
>         return ret;
> }

I would have expected this to work the other way around; "gpio" is just
another function that can be assigned to a pin.

This has the benefit of catering to the following cases:

Below, "SF" == "some special function"

1) Pin is SF or a particular GPIO.

2) Pin is SF or a particular GPIO from GPIO controller A, or a particular
   GPIO from controller B

3) Pin is SF, or one of a number of user-selectable GPIOs.

Case (1) is covered by the code quoted above from earlier in the thread.
Cases (2) and (3) can't be covered by that code, and according to comments
in earlier replies, both actually exist in real HW.

For reference, here's how I'd imagine modeling those three cases in
pinmux (all based on my earlier comments about the data model I imagine,
rather than what's currently in the pinmux patches):

1) Have a single function "gpio" that can be applied to any pin that
supports it. The actual GPIO number that gets mux'd onto the pin differs
per pin, and is determine by HW design. But logically, we're connecting
that pin to function "gpio", so we only need one function name for that.

2) Have a function for each GPIO controller that can be attached to a
pin; "gpioa" or "gpiob". Based on the pin being configured, and which of
those two GPIO functions is selected, the HW determines the specific GPIO
number that's assigned to the pin.

3) Where the GPIO ID assigned to pins is user-selectable, have a function
per GPIO ID; "gpio1", "gpio2", "gpio3", ... "gpio31". This sounds like
it'd cause a huge explosion in the number of functions; one to represent
each GPIO ID. However, I suspect this won't be too bad in practice, since
there's presumably some practical limit to the amount of muxing logic that
can be applied to each pin in HW, so the set of options won't be too large.

If the set of GPIO IDs that can be assigned to any particular pin is a subset
of the whole GPIO number space, e.g.:

pina: gpio1, gpio2, gpio3, gpio4
pinb: gpio2, gpio3, gpio4, gpio5
pinc: gpio3, gpio4, gpio5, gpio6

... then I imagine HW has already defined an enumerator gpioa, gpiob, gpioc,
gpiod and a mapping from those to the specific GPIO ID that each means when
assigned to a given pin, so those gpioa/b/c/d values could be used as the
function exposed by the pinmux driver.

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
