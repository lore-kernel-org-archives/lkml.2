Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab2KNI3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:29:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50305 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab2KNI3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:29:17 -0500
Date: Wed, 14 Nov 2012 11:27:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] ALSA: es1968: precedence bug in
 snd_es1968_tea575x_get_pins()
Message-ID: <20121114082739.GF11566@mwanda>
References: <20121113074454.GB13198@elgon.mountain>
 <1352793790.24230.18.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352793790.24230.18.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 12:03:10AM -0800, Joe Perches wrote:
> On Tue, 2012-11-13 at 10:44 +0300, Dan Carpenter wrote:
> > I don't think this works as intended.  '|' higher precedence than ?: so
> > the bitwize OR "0 | (val & STR_MOST)" is a no-op.
> > 
> > I have re-written it to be more clear.
> []
> > diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
> []
> > @@ -2581,9 +2581,14 @@ static u8 snd_es1968_tea575x_get_pins(struct snd_tea575x *tea)
> >  	struct es1968 *chip = tea->private_data;
> >  	unsigned long io = chip->io_port + GPIO_DATA;
> >  	u16 val = inw(io);
> > -
> > -	return  (val & STR_DATA) ? TEA575X_DATA : 0 |
> > -		(val & STR_MOST) ? TEA575X_MOST : 0;
> > +	u8 ret;
> > +
> > +	ret = 0;
> > +	if (val & STR_DATA)
> > +		ret |= TEA575X_DATA;
> > +	if (val & STR_MOST)
> > +		ret |= TEA575X_MOST;
> > +	return ret;
> 
> Cute.  smatch I presume?  Tools are useful.

Yep.  This is a smatch thing.

> 
> Moving the close parentheses is a pretty common style too
> 
> 	return  (val & STR_DATA ? TEA575X_DATA : 0) |
> 		(val & STR_MOST ? TEA575X_MOST : 0);

That would work as well, of course.  I don't have a strong
preference either way.

regards,
dan carpenter

