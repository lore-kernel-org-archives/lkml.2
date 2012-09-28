Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab2I1DGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:06:35 -0400
Received: from 11.mo4.mail-out.ovh.net ([46.105.34.195]:35257 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755935Ab2I1DGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:06:34 -0400
X-Greylist: delayed 980 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 23:06:33 EDT
Date: Fri, 28 Sep 2012 04:47:44 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
Message-ID: <20120928024744.GV17667@game.jcrosoft.org>
References: <1348780923-27428-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348780923-27428-1-git-send-email-stigge@antcom.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1176846879533280093
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrleegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrleegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:22 Thu 27 Sep     , Roland Stigge wrote:
> The recurring task of providing simultaneous access to GPIO lines (especially
> for bit banging protocols) needs an appropriate API.
> 
> This patch adds a kernel internal "Block GPIO" API that enables simultaneous
> access to several GPIOs in the same gpio_chip (bit mapped). Further, it adds a
> sysfs interface (/sys/class/gpio/gpiochipXX/block).
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> ---
> NOTE: This is only useful if individual drivers implement the .get_block() and
> .set_block() functions. I'm providing an example implementation for max730x
> (see next patch), and can provide further driver patches after API review.
> 
> Thanks in advance!
> 
>  Documentation/gpio.txt     |   52 +++++++++++++++++++
>  drivers/gpio/gpiolib.c     |  121 +++++++++++++++++++++++++++++++++++++++++++++
>  include/asm-generic/gpio.h |    7 ++
>  include/linux/gpio.h       |   24 ++++++++
>  4 files changed, 204 insertions(+)
> 
> --- linux-2.6.orig/Documentation/gpio.txt
> +++ linux-2.6/Documentation/gpio.txt
> @@ -439,6 +439,51 @@ slower clock delays the rising edge of S
>  signaling rate accordingly.
>  
>  
> +Block GPIO (optional)
> +---------------------
> +
> +The above described interface concentrates on handling single GPIOs.  However,
> +in applications where it is critical to set several GPIOs at once, this
> +interface doesn't work well, e.g. bit-banging protocols via GPIO lines.
> +Consider a GPIO controller that is connected via a slow I2C line. When
> +switching two or more GPIOs one after another, there can be considerable time
> +between those events. This is solved by an interface called Block GPIO:
> +
> +void gpio_get_block(unsigned int gpio, u8* values, size_t size);
> +void gpio_set_block(unsigned int gpio, u8* set, u8* clr, size_t size);
> +
> +The function gpio_get_block() detects the current state of several GPIOs at
> +once, practically by doing only one query at the hardware level (e.g. memory
> +mapped or via bus transfers like I2C). There are some limits to this interface:
> +A certain gpio_chip (see below) must be specified via the gpio parameter as the
> +first GPIO in the gpio_chip group. The Block GPIO interface only supports
> +simultaneous handling of GPIOs in the same gpio_chip group since different
> +gpio_chips typically map to different GPIO hardware blocks.
so basicaly you use a gpio numberthat you do not request, that is maybe
requested. This is broken if you want to get or set block you need to pass the
list of GPIO you want to control not some fancy magic

Otherwise this will end be broken code.

And how you can hope to describe this via DT

Best Regards,
J.
