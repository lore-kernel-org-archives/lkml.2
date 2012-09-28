Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab2I1IRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:17:43 -0400
Received: from 8.mo3.mail-out.ovh.net ([87.98.172.249]:44475 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751277Ab2I1IR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:17:27 -0400
Date: Fri, 28 Sep 2012 09:51:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
Message-ID: <20120928075145.GW17667@game.jcrosoft.org>
References: <1348780923-27428-1-git-send-email-stigge@antcom.de>
 <20120928024744.GV17667@game.jcrosoft.org>
 <50654E57.3080201@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50654E57.3080201@antcom.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6314891104581561181
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

On 09:14 Fri 28 Sep     , Roland Stigge wrote:
> 
> Hi!
> 
> On 09/28/2012 04:47 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >> +Block GPIO (optional)
> >> +---------------------
> >> +
> >> +The above described interface concentrates on handling single GPIOs.  However,
> >> +in applications where it is critical to set several GPIOs at once, this
> >> +interface doesn't work well, e.g. bit-banging protocols via GPIO lines.
> >> +Consider a GPIO controller that is connected via a slow I2C line. When
> >> +switching two or more GPIOs one after another, there can be considerable time
> >> +between those events. This is solved by an interface called Block GPIO:
> >> +
> >> +void gpio_get_block(unsigned int gpio, u8* values, size_t size);
> >> +void gpio_set_block(unsigned int gpio, u8* set, u8* clr, size_t size);
> >> +
> >> +The function gpio_get_block() detects the current state of several GPIOs at
> >> +once, practically by doing only one query at the hardware level (e.g. memory
> >> +mapped or via bus transfers like I2C). There are some limits to this interface:
> >> +A certain gpio_chip (see below) must be specified via the gpio parameter as the
> >> +first GPIO in the gpio_chip group. The Block GPIO interface only supports
> >> +simultaneous handling of GPIOs in the same gpio_chip group since different
> >> +gpio_chips typically map to different GPIO hardware blocks.
> > so basicaly you use a gpio numberthat you do not request, that is maybe
> > requested. This is broken if you want to get or set block you need to pass the
> > list of GPIO you want to control not some fancy magic
> 
> Right - will add checking for the request state of the respective GPIOs.
> 
> The list of GPIOs to handle is defined by the offset (specified GPIO)
> and bitmapped list.
> 
> If it looks more natural, I can change this to a list of ints specifying
> GPIOs directly.
you pass the correctly information to the gpiolib

as if you do not request the gpio the gpiolib will auto request the gpios
so you api will be 
int gpio_get_block(unsigned int *gpios, u8* values, size_t size);

return an error

int gpio_set_block(unsigned int *gpios, u8* set, size_t size);

so you do not care about the banks you work on the gpiolib framework will call
each gpio_chip seperatly. If the set_block get_block is not availlable the
gpiolib could fallback to get/set

inside of the gpiolib that you call each bank with a bitmapped list is correct
but not in the public gpiolib API

> 
> > And how you can hope to describe this via DT
> 
> Haven't had planned that yet. Finally, this interface should just be
> another view on the GPIOs already requested / assigned. Or which
> additional info do you mean?
how do you plan to give the gpio base vai DT to the driver as via DT we just
pass the list of GPIO to work on
> 
> Thanks for your notes!
> 
> Roland
