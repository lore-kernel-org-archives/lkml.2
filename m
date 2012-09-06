Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab2IFPI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:08:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18702 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab2IFPIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:08:24 -0400
Date: Thu, 6 Sep 2012 08:07:58 -0700
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] da9052-battery: don't free IRQ that wasn't requested
Message-ID: <20120906150758.GL19410@mwanda>
References: <20120905123440.GF6128@elgon.mountain>
 <50475D75.2040908@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50475D75.2040908@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 04:11:01PM +0200, walter harms wrote:
> 
> 
> Am 05.09.2012 14:34, schrieb Dan Carpenter:
> > We should decrement "i" before doing the free_irq().  If we call this
> > because request_threaded_irq() failed then we don't want to free the
> > thing which failed.  Or in the case where we get here because
> > power_supply_register() failed then the original codes does a read past
> > the end of the array.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
> > index 20b86ed..d9d034d 100644
> > --- a/drivers/power/da9052-battery.c
> > +++ b/drivers/power/da9052-battery.c
> > @@ -623,7 +623,7 @@ static s32 __devinit da9052_bat_probe(struct platform_device *pdev)
> >  	return 0;
> >  
> >  err:
> > -	for (; i >= 0; i--) {
> > +	while (--i >= 0) {
> >  		irq = platform_get_irq_byname(pdev, da9052_bat_irqs[i]);
> >  		free_irq(bat->da9052->irq_base + irq, bat);
> >  	}
> 
> hi da,
> (my usual nitpicking ...)

Ha ha.  Your nit picks are welcome even if I don't always agree.

> since a lot of people do make mistakes on count-down-loops, is there any chance to
> make this a common count-up-for()-loop ?
> like:

I like the count down loops...  It feels very natural to unwind that
way.

>    for (j=0; j <= i ;j++ ) {
               ^^^^^^
The count up loops are prone to the exact same off by one bugs.  ;)
You've got one in your sample code.  Plus I'd have to declare
another variable and send a v2 patch and I am very lazy...  So in
this case I think should just take my original patch.

regards,
dan carpenter

