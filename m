Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1KYOft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:35:49 -0500
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:57535 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754762Ab1KYOfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:35:48 -0500
X-Greylist: delayed 1798 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Nov 2011 09:35:48 EST
Date: Fri, 25 Nov 2011 15:23:05 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 1/2] gpiolib: introduce gpio_set_pullup
Message-ID: <20111125142305.GA15008@game.jcrosoft.org>
References: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
 <20111125141640.GB13747@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111125141640.GB13747@legolas.emea.dhcp.ti.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11919339365623245765
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrudduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpeen
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -215
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddmnehjucdnkihjvgculddqhedmnehlihhnuhigucdlqddutddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:16 Fri 25 Nov     , Felipe Balbi wrote:
> Hi,
> 
> On Fri, Nov 25, 2011 at 03:08:39PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > ---
> >  drivers/gpio/gpiolib.c     |   44 ++++++++++++++++++++++++++++++++++++++++++++
> >  include/asm-generic/gpio.h |    4 ++++
> >  include/linux/gpio.h       |    5 +++++
> >  3 files changed, 53 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index a971e3d..b7e5e75 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -1519,6 +1519,50 @@ fail:
> >  }
> >  EXPORT_SYMBOL_GPL(gpio_set_debounce);
> >  
> > +/**
> > + * gpio_set_pullup - sets @pullup for a @gpio
> > + * @gpio: the gpio to set pullup
> > + * @pullup: pullup level
> > + */
> > +int gpio_set_pullup(unsigned gpio, unsigned pullup)
> > +{
> > +	unsigned long		flags;
> > +	struct gpio_chip	*chip;
> > +	struct gpio_desc	*desc = &gpio_desc[gpio];
> > +	int			status = -EINVAL;
> > +
> > +	spin_lock_irqsave(&gpio_lock, flags);
> > +
> > +	if (!gpio_is_valid(gpio))
> > +		goto fail;
> > +	chip = desc->chip;
> > +	if (!chip || !chip->set_pullup)
> > +		goto fail;
> > +	gpio -= chip->base;
> > +	if (gpio >= chip->ngpio)
> > +		goto fail;
> > +	status = gpio_ensure_requested(desc, gpio);
> > +	if (status < 0)
> > +		goto fail;
> > +
> > +	/* now we know the gpio is valid and chip won't vanish */
> > +
> > +	spin_unlock_irqrestore(&gpio_lock, flags);
> > +
> > +	might_sleep_if(chip->can_sleep);
> > +
> > +	return chip->set_pullup(chip, gpio, pullup);
> > +
> > +fail:
> > +	spin_unlock_irqrestore(&gpio_lock, flags);
> > +	if (status)
> > +		pr_debug("%s: gpio-%d status %d\n",
> > +			__func__, gpio, status);
> > +
> > +	return status;
> > +}
> > +EXPORT_SYMBOL_GPL(gpio_set_pullup);
> 
> Maybe I'm missing something, but isn't it essentially what
> gpio_set_value() does ? I mean, you set a pullup and you get '1' value
> and set a pulldown and you get a '0' value ??
> 
> Without a proper description of the necessity for this change, I can't
> easily tell them apart :-(
set_value is for output set_pullup is for input mode

some IP allow you when you configure an gpio as input to enable the internal pullup
so no need on the board to add an external pull up

Best Regards,
J.

> 
> -- 
> balbi


