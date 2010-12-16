Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab0LPVIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:08:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589Ab0LPVIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:08:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] rtc-cmos: fix suspend/resume
Date: Thu, 16 Dec 2010 22:08:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, pgf@laptop.org
References: <20101216180829.A8E5A9D401B@zog.reactivated.net> <201012162205.39435.rjw@sisk.pl>
In-Reply-To: <201012162205.39435.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012162208.19868.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 16, 2010, Rafael J. Wysocki wrote:
> On Thursday, December 16, 2010, Daniel Drake wrote:
> > From: Paul Fox <pgf@laptop.org>
> > 
> > rtc-cmos was setting suspend/resume hooks at the device_driver level.
> > However, the platform bus code (drivers/base/platform.c) only looks
> > for resume hooks at the dev_pm_ops level, or within the platform_driver.
> > 
> > Switch rtc_cmos to use dev_pm_ops so that suspend/resume code is
> > executed again.
> > 
> > Signed-off-by: Paul Fox <pgf@laptop.org>
> > Signed-off-by: Daniel Drake <dsd@laptop.org>
> > ---
> >  drivers/rtc/rtc-cmos.c |   14 +++++++++-----
> >  1 files changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> > index 5856167..dfa5547 100644
> > --- a/drivers/rtc/rtc-cmos.c
> > +++ b/drivers/rtc/rtc-cmos.c
> > @@ -850,7 +850,7 @@ static void __exit cmos_do_remove(struct device *dev)
> >  
> >  #ifdef	CONFIG_PM
> >  
> > -static int cmos_suspend(struct device *dev, pm_message_t mesg)
> > +static int cmos_suspend(struct device *dev)
> >  {
> >  	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
> >  	unsigned char	tmp;
> > @@ -898,7 +898,7 @@ static int cmos_suspend(struct device *dev, pm_message_t mesg)
> >   */
> >  static inline int cmos_poweroff(struct device *dev)
> >  {
> > -	return cmos_suspend(dev, PMSG_HIBERNATE);
> > +	return cmos_suspend(dev);
> >  }
> >  
> >  static int cmos_resume(struct device *dev)
> > @@ -1077,7 +1077,7 @@ static void __exit cmos_pnp_remove(struct pnp_dev *pnp)
> >  
> >  static int cmos_pnp_suspend(struct pnp_dev *pnp, pm_message_t mesg)
> >  {
> > -	return cmos_suspend(&pnp->dev, mesg);
> > +	return cmos_suspend(&pnp->dev);
> >  }
> >  
> >  static int cmos_pnp_resume(struct pnp_dev *pnp)
> > @@ -1152,13 +1152,17 @@ static void cmos_platform_shutdown(struct platform_device *pdev)
> >  /* work with hotplug and coldplug */
> >  MODULE_ALIAS("platform:rtc_cmos");
> >  
> > +static struct dev_pm_ops cmos_pm_ops = {
> > +	.suspend = cmos_suspend,
> > +	.resume = cmos_resume,
> > +};
> 
> That's not enough.  Please also specify hibernation callbacks as documented
> in Documentation/power/devices.txt (they can point to the same routines as the
> suspend/resume ones).

You can use the SIMPLE_DEV_PM_OPS() macro (defined in include/linux/pm.h)
for this purpose.

Thanks,
Rafael


> > +
> >  static struct platform_driver cmos_platform_driver = {
> >  	.remove		= __exit_p(cmos_platform_remove),
> >  	.shutdown	= cmos_platform_shutdown,
> >  	.driver = {
> >  		.name		= (char *) driver_name,
> > -		.suspend	= cmos_suspend,
> > -		.resume		= cmos_resume,
> > +		.pm = &cmos_pm_ops,
> >  	}
> >  };
> >  
> > 
> 
> 

