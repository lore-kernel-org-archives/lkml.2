Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1FIJFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:05:19 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:25767 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab1FIJFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:05:14 -0400
Date: Thu, 9 Jun 2011 11:05:21 +0200
From: David Jander <david.jander@protonic.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Jander <david@protonic.nl>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/6] GPIO: pca953x.c: Remove meaningless device-tree
 bindings
Message-ID: <20110609110521.28db651a@archvile>
In-Reply-To: <20110608170857.GI8499@ponder.secretlab.ca>
References: <1307537314-4345-1-git-send-email-david@protonic.nl>
	<1307537314-4345-4-git-send-email-david@protonic.nl>
	<20110608170857.GI8499@ponder.secretlab.ca>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011 11:08:57 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Wed, Jun 08, 2011 at 02:48:31PM +0200, David Jander wrote:
> > The property 'polarity' is handled by the GPIO core, and the 'gpio-base'
> > should be assigned automatically. It is meaningless in the device-tree,
> > since GPIO's are identified by the "chip-name"/offset pair.
> > This way, the whole pca953x_get_alt_pdata() can go away.
> > We still need to check whether we really want GPIO-interrupt functionality
> > by simply looking if the I2C node has an interrupts property defined, since
> > this property is not used for anything else.
> > 
> > Signed-off-by: David Jander <david@protonic.nl>
> > ---
> >  drivers/gpio/pca953x.c |   62
> > ++++++++--------------------------------------- 1 files changed, 11
> > insertions(+), 51 deletions(-)
> > 
> > diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> > index 2dff562..ae9fe61 100644
> > --- a/drivers/gpio/pca953x.c
> > +++ b/drivers/gpio/pca953x.c
> > @@ -21,7 +21,6 @@
> >  #include <linux/slab.h>
> >  #ifdef CONFIG_OF_GPIO
> >  #include <linux/of_platform.h>
> > -#include <linux/of_gpio.h>
> >  #endif
> >  
> >  #define PCA953X_INPUT		0
> > @@ -539,55 +538,6 @@ static void pca953x_irq_teardown(struct pca953x_chip
> > *chip) }
> >  #endif
> >  
> > -/*
> > - * Handlers for alternative sources of platform_data
> > - */
> > -#ifdef CONFIG_OF_GPIO
> > -/*
> > - * Translate OpenFirmware node properties into platform_data
> > - */
> > -static struct pca953x_platform_data *
> > -pca953x_get_alt_pdata(struct i2c_client *client)
> > -{
> > -	struct pca953x_platform_data *pdata;
> > -	struct device_node *node;
> > -	const __be32 *val;
> > -	int size;
> > -
> > -	node = client->dev.of_node;
> > -	if (node == NULL)
> > -		return NULL;
> > -
> > -	pdata = kzalloc(sizeof(struct pca953x_platform_data), GFP_KERNEL);
> > -	if (pdata == NULL) {
> > -		dev_err(&client->dev, "Unable to allocate
> > platform_data\n");
> > -		return NULL;
> > -	}
> > -
> > -	pdata->gpio_base = -1;
> > -	val = of_get_property(node, "linux,gpio-base", &size);
> > -	if (val) {
> > -		if (size != sizeof(*val))
> > -			dev_warn(&client->dev, "%s: wrong
> > linux,gpio-base\n",
> > -				 node->full_name);
> > -		else
> > -			pdata->gpio_base = be32_to_cpup(val);
> > -	}
> > -
> > -	val = of_get_property(node, "polarity", NULL);
> > -	if (val)
> > -		pdata->invert = *val;
> > -
> > -	return pdata;
> > -}
> > -#else
> > -static struct pca953x_platform_data *
> > -pca953x_get_alt_pdata(struct i2c_client *client)
> > -{
> > -	return NULL;
> > -}
> > -#endif
> > -
> 
> Ah, hmm.  I missed that you were adding documentation for properties
> that were already implemented.  I try really hard not to break things
> that others are already relying on, so I don't think this code can be
> removed.  However, bonus points if you make it deprecated and spit
> out a scary warning when these properties are used.

Ok :-)
Is something like a WARN() a good thing to do here?

> >  static int __devinit device_pca953x_init(struct pca953x_chip *chip, int
> > invert) {
> >  	int ret;
> > @@ -654,7 +604,17 @@ static int __devinit pca953x_probe(struct i2c_client
> > *client, 
> >  	pdata = client->dev.platform_data;
> >  	if (pdata == NULL) {
> > -		pdata = pca953x_get_alt_pdata(client);
> > +		pdata = kzalloc(sizeof(struct pca953x_platform_data),
> > GFP_KERNEL);
> > +		if (pdata == NULL) {
> > +			dev_err(&client->dev, "Unable to allocate
> > platform_data\n");
> > +			goto out_failed;
> > +		}
> > +		pdata->gpio_base = -1;
> > +#ifdef CONFIG_OF_GPIO
> > +		/* If I2C node has no interrupts property, disable GPIO
> > interrupts */
> > +		if (of_find_property(client->dev.of_node, "interrupts",
> > NULL) == NULL)
> > +			pdata->irq_base = -1;
> > +#endif
> 
> Interesting fact: pdata is only used during setup of this driver.  All
> the goofing around to kzalloc a pdata for the dt use case is really
> kind of pointless, and the driver could be simpler if it were removed.
> It would be nice if somebody could investigate this.

I agree. Before I fix that, would it have been ok to just look up the
"interrupts" property like this to decide whether to activate GPIO-interrupt
support?
Unfortunately of_platform code leaves the .irq member as 0 if this property is
not specified, and AFAIK, "0" is a valid IRQ number on some platforms, so I
can't check on the value.

Should I post a complete new patch set, or can I just reply on the not yet
accepted parts (2 and 3, while 6 could be dismissed)?

Also, I just realized that I do need to free the alloc'd irq descriptors in
case the driver fails in gpiochip_add(). You already accepted that patch,
though. Should I post a separate patch adding just the missing
irq_free_descs(), or should I modify the patch and repost it?

Best regards,

-- 
David Jander
Protonic Holland.
