Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2GXM5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 08:57:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2GXM5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 08:57:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Mack <zonque@gmail.com>
Subject: Re: [PATCH] gpiolib: fix chip->base handling in of_gpio_simple_xlate()
Date: Tue, 24 Jul 2012 12:56:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
References: <1342977052-7880-1-git-send-email-zonque@gmail.com> <500D632B.3000206@gmail.com>
In-Reply-To: <500D632B.3000206@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207241256.56535.arnd@arndb.de>
X-Provags-ID: V02:K0:21NiH6f3sfl26KUdEkC+wf9GHu7NlqBH4yncUNfcUps
 BirPlxaYKTVlzGcYak77PopobBY0TsscApGPl60DjKrKN0VUZn
 kfahzK7Z8TiO4yT3PN8zYcFU6HBvE/Daa5wYQOeUs3QjBqA/Gi
 44ATq2KkslP3WFnBUpwgr2na9hQ2RThE7xVUX1w3qjpNTFEw4y
 0FoIMg5Hlf8pOtVyYmisww1cOyPYVRW4mumF7zVQEaaEzK+KW0
 ARE5Ad3AF7AFXmhnfcyPQQSFyCWYPKymsW1PAnBmsn2tSoBOmt
 kTug7h69Iwd3+AieheWVbEMLrVHWEzdIf4BZ0fjqPSKe4cNFEF
 FAs78vVyTfcm/AzHtb9w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2012, Daniel Mack wrote:
> (Cc: Arnd)
> 
> On 22.07.2012 19:10, Daniel Mack wrote:
> > of_gpio_simple_xlate() is called for each chip when a GPIO is looked up.
> > When registering several chips off the same DT node (with different pin
> > offsets) however, the lookup fails as the GPIO number passed in to
> > of_gpio_simple_xlate() is likely higher than the chip's ->ngpio value.
> > 
> > Fix that by taking into account the chip's ->base value, and return the
> > relative offset of the pin inside the chip.
> > 
> > Signed-off-by: Daniel Mack <zonque@gmail.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Linus Walleij <linus.walleij@stericsson.com>
> > ---
> > 
> > I'm currently porting the PXA pieces over to DT, and stumbled over what
> > looks like an obvious bug to me. Correct me if I'm mistaken, but I see
> > no reason why one shouldn't be able to instanciate several GPIO chips
> > from a single DT node.

But why would you do that? Both the "gpiochip" and its DT representation
attempt to represent the hardware structure. If they don't match, then
I'd assume one of them is wrong ;-)

> > diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> > index d18068a..51bc232 100644
> > --- a/drivers/gpio/gpiolib-of.c
> > +++ b/drivers/gpio/gpiolib-of.c
> > @@ -147,13 +147,13 @@ int of_gpio_simple_xlate(struct gpio_chip *gc,
> >  	if (WARN_ON(gpiospec->args_count < gc->of_gpio_n_cells))
> >  		return -EINVAL;
> >  
> > -	if (gpiospec->args[0] >= gc->ngpio)
> > +	if (gpiospec->args[0] >= gc->ngpio + gc->base)
> >  		return -EINVAL;
> >  
> >  	if (flags)
> >  		*flags = gpiospec->args[1];
> >  
> > -	return gpiospec->args[0];
> > +	return gpiospec->args[0] - gc->base;
> >  }
> >  EXPORT_SYMBOL(of_gpio_simple_xlate);

Where would that gc->base come from?

	Arnd
