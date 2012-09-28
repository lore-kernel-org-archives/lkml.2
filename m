Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab2I1M7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:59:38 -0400
Received: from 6.mo5.mail-out.ovh.net ([178.32.119.138]:57115 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756148Ab2I1M7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:59:36 -0400
X-Greylist: delayed 6600 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 08:59:35 EDT
Date: Fri, 28 Sep 2012 12:28:22 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Roland Stigge <stigge@antcom.de>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
Message-ID: <20120928102822.GY17667@game.jcrosoft.org>
References: <1348780923-27428-1-git-send-email-stigge@antcom.de>
 <20120928024744.GV17667@game.jcrosoft.org>
 <50654E57.3080201@antcom.de>
 <20120928075145.GW17667@game.jcrosoft.org>
 <50656522.1050900@antcom.de>
 <20120928090848.GX17667@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928090848.GX17667@game.jcrosoft.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 8959911459570821981
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

On 11:08 Fri 28 Sep     , Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 10:51 Fri 28 Sep     , Roland Stigge wrote:
> > Hi!
> > 
> > On 09/28/2012 09:51 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > >> Right - will add checking for the request state of the respective GPIOs.
> > >>
> > >> The list of GPIOs to handle is defined by the offset (specified GPIO)
> > >> and bitmapped list.
> > >>
> > >> If it looks more natural, I can change this to a list of ints specifying
> > >> GPIOs directly.
> > > you pass the correctly information to the gpiolib
> > > 
> > > as if you do not request the gpio the gpiolib will auto request the gpios
> > > so you api will be 
> > > int gpio_get_block(unsigned int *gpios, u8* values, size_t size);
> > > 
> > > return an error
> > > 
> > > int gpio_set_block(unsigned int *gpios, u8* set, size_t size);
> > > 
> > > so you do not care about the banks you work on the gpiolib framework will call
> > > each gpio_chip seperatly. If the set_block get_block is not availlable the
> > > gpiolib could fallback to get/set
> > > 
> > > inside of the gpiolib that you call each bank with a bitmapped list is correct
> > > but not in the public gpiolib API
> > 
> > Good idea! Talking about the public API (your above gpio_set_block()):
> > *gpios is a list of GPIOs, but set is still bitmapped (mapped onto the
> > list specified in *gpios)? To prevent confusion about what the size
> > argument means (number of gpios in *gpios _or_ number of bytes in the
> > bitmap *set) - wouldn't it be clearer to have a "bool *set" and "bool
> > *values" list?
> public API list of gpio as example
> 
> gpios = {1, 33, 34, 55};
> set = {1, 0, 0 ,1};
> 
> gpio_set_blocks(gpios, set, 4);
> 
> private you do just provide the array related to the gpio_chip
> lets assume 4 bank with 32 gpio each
> 
> gpio0 = {1};
> set0 = {1};
> 
> gpio1 = {33, 34};
here should be

pin0 = {1};
set0 = {1};

pin1 = {1, 2, 23};
set1 = {0, 0, 1};

set_blocks(gpio_chip0, pin0, set0, 1);
set_blocks(gpio_chip1, pin1, set1, 3);

You may need to add a prepare to do not do the conversion between array and
gpio_chip array as I guess you will work on gpio block with multiple time
acces

Best Regards,
J.
