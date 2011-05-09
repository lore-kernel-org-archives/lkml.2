Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1EITU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:20:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34328 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1EITUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:20:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH 3/5] PM: Support for system-wide power transitions in generic power domains
Date: Mon, 9 May 2011 21:20:41 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.44L0.1105091032190.2002-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105091032190.2002-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105092120.42005.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 09, 2011, Alan Stern wrote:
> On Sun, 8 May 2011, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Make generic power domains support system-wide power transitions
> > (system suspend and hibernation).  Add suspend, resume, freeze and
> > thaw callbacks to be associated with struct generic_power_domain
> > objects and make pm_genpd_init() use them as appropriate.
> 
> ...
> 
> > Index: linux-2.6/drivers/base/power/domain.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/power/domain.c
> > +++ linux-2.6/drivers/base/power/domain.c
> > @@ -273,6 +273,280 @@ static int pm_genpd_runtime_resume(struc
> >  
> >  #endif /* CONFIG_PM_RUNTIME */
> >  
> > +#ifdef CONFIG_PM_SLEEP
> > +
> > +/**
> > + * pm_genpd_powered_down - Check if power has been removed from a power domain.
> > + * @genpd: Power domain to check.
> > + */
> > +static bool pm_genpd_powered_down(struct generic_power_domain *genpd)
> > +{
> > +	bool ret;
> > +
> > +	mutex_lock(&genpd->lock);
> > +	ret = genpd->power_is_off;
> > +	mutex_unlock(&genpd->lock);
> > +
> > +	return ret;
> > +}
> 
> What is the purpose of the mutex?  On the face of it, there's nothing 
> to prevent another thread from changing the domain's power state in 
> between the mutex_unlock() call and the return statement.

Now, that I think of it, the mutex isn't really necessary.

genpd->power_is_off is only changed by the runtime PM code that will
never be called during system suspend if genpd->power_is_off is set
already.

I'm going to post an update shortly, I'll include a fix for that in it.

Thanks,
Rafael
