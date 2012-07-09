Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab2GIEmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 00:42:33 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54232 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2GIEmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 00:42:31 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 8 Jul 2012 21:42:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 4/4][update] hwmon / exynos4_tmu: Use struct dev_pm_ops
 for power management
Message-ID: <20120709044235.GA21850@roeck-us.net>
References: <201207072302.16491.rjw@sisk.pl>
 <201207082148.15674.rjw@sisk.pl>
 <20120708203004.GA20390@roeck-us.net>
 <201207082246.13006.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207082246.13006.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2012 at 10:46:12PM +0200, Rafael J. Wysocki wrote:
> On Sunday, July 08, 2012, Guenter Roeck wrote:
> > On Sun, Jul 08, 2012 at 09:48:15PM +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > Hi Rafael,
> > 
> > > Make the Exynos4 TMU driver define its PM callbacks through
> > > a struct dev_pm_ops object rather than by using legacy PM hooks
> > > in struct platform_driver.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
> > >  drivers/hwmon/exynos4_tmu.c |   18 +++++++++++-------
> > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > 
> > > Index: linux/drivers/hwmon/exynos4_tmu.c
> > > ===================================================================
> > > --- linux.orig/drivers/hwmon/exynos4_tmu.c
> > > +++ linux/drivers/hwmon/exynos4_tmu.c
> > > @@ -476,34 +476,38 @@ static int __devexit exynos4_tmu_remove(
> > >  }
> > >  
> > >  #ifdef CONFIG_PM
> > > -static int exynos4_tmu_suspend(struct platform_device *pdev, pm_message_t state)
> > > +static int exynos4_tmu_suspend(struct device *dev)
> > >  {
> > > -	exynos4_tmu_control(pdev, false);
> > > +	exynos4_tmu_control(to_platform_device(dev), false);
> > >  
> > >  	return 0;
> > >  }
> > >  
> > > -static int exynos4_tmu_resume(struct platform_device *pdev)
> > > +static int exynos4_tmu_resume(struct device *dev)
> > >  {
> > > +	struct platform_device *pdev = to_platform_device(dev);
> > > +
> > >  	exynos4_tmu_initialize(pdev);
> > >  	exynos4_tmu_control(pdev, true);
> > >  
> > >  	return 0;
> > >  }
> > > +
> > > +static SIMPLE_DEV_PM_OPS(exynos4_tmu_pm,
> > > +			 exynos4_tmu_suspend, exynos4_tmu_resume);
> > > +#define EXYNOS4_TMU_PM	(&exynos4_tmu_pm)
> > >  #else
> > > -#define exynos4_tmu_suspend NULL
> > > -#define exynos4_tmu_resume NULL
> > > +#define EXYNOS4_TMU_PM	NULL
> > >  #endif
> > 
> > Actually, looking into other drivers, the common approach seems to be to declare
> > 
> > static SIMPLE_DEV_PM_OPS(exynos4_tmu_pm,
> > 			 exynos4_tmu_suspend, exynos4_tmu_resume);
> > 
> > outside the #ifdef code and then just assign
> > 
> > 		.pm = &exynos4_tmu_pm;
> > 
> > unconditionally.
> > 
> > That seems to be a much simpler solution. Any special reason for not
> > implementing it this way ? Same question applies to the other patches in the
> > series.
> 
> In fact, there are two ways.  One of them is what you said, the other is to
> put SIMPLE_DEV_PM_OPS() under the #ifdef like I did.  I'm not sure which one
> is prevalent, but what I did has the advatnage that the kernel data will
> be slightly smaller if CONFIG_PM is unset.
> 
Ok, make sense. Applied to -next.

Thanks,
Guenter
