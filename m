Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab1KIXCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 18:02:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58693 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab1KIXCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 18:02:22 -0500
Date: Thu, 10 Nov 2011 00:02:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        jean.pihet@newoldbits.com
Subject: Re: [PATCH 2/7] PM / Domains: Make it possible to use per-device
 .active_wakeup()
In-Reply-To: <201111092340.57280.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.1111100001530.4188@axis700.grange>
References: <201111070101.33960.rjw@sisk.pl> <201111082140.00876.rjw@sisk.pl>
 <Pine.LNX.4.64.1111090818060.24340@axis700.grange> <201111092340.57280.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:BM/jTFHb4glvwT5q8H3MwbfGXbR4rFgSp1G29MBejSz
 cKogmGi+hkhxF3Cjvem+rdR+6Qd98r/LPqE2qneQ1hGs9bIz82
 tdkRUGlNVkbkntT73KSz9y+xvg6Hpet5w3sbTpBx5hQ0QpYYs6
 uy38mcSk5t3T/sfyRilpTEDXNtAAOPZnMxzWlC7zgPVQgM5KyT
 U1NuWNxzESjfr3h5gMUGw6QVNuKY4jEjPSKgRUHdl/Z8ybsCGf
 BQey+7BBclyh4N+5GqApgl6Y0hBGExYOicCtif4hlENSBVkgUD
 eyNj+oKGAfc3bVSzU82ln/oH9xywekMrlW7I7VrHL9H1NxOFZa
 P88HzPLDGgVJWXxcQoxC2bT3vlNqoYi9YhsL6ssoA10SKymwEt
 AveFR+DDYIPrg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Nov 2011, Rafael J. Wysocki wrote:

> On Wednesday, November 09, 2011, Guennadi Liakhovetski wrote:
> > On Tue, 8 Nov 2011, Rafael J. Wysocki wrote:
> > 
> > > On Tuesday, November 08, 2011, Guennadi Liakhovetski wrote:
> > > > On Mon, 7 Nov 2011, Rafael J. Wysocki wrote:
> > > > 
> > > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > 
> > > > > The current generic PM domains code requires that the same
> > > > > .active_wakeup() device callback routine be used for all devices in
> > > > > the given domain, which is inflexible and may not cover some specific
> > > > > use cases.  For this reason, make it possible to use device specific
> > > > > .active_wakeup() callback routines by adding a corresponding callback
> > > > > pointer to struct generic_pm_domain_data.  To reduce code duplication
> > > > > use struct gpd_dev_ops to represent PM domain device callbacks as
> > > > > well as device-specific ones and add a macro for defining routines
> > > > > that will execute those callbacks.
> > > > > 
> > > > > Modify the shmobile's power domains code to allow drivers to use
> > > > > their own .active_wakeup() callback routines.
> > > > > 
> > > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > ---
> > > > >  arch/arm/mach-shmobile/pm-sh7372.c |   11 ++++---
> > > > >  drivers/base/power/domain.c        |   54 ++++++++++++++++++-------------------
> > > > >  include/linux/pm_domain.h          |   15 ++++------
> > > > >  3 files changed, 41 insertions(+), 39 deletions(-)
> > > > > 
> > > > > Index: linux/include/linux/pm_domain.h
> > > > > ===================================================================
> > > > > --- linux.orig/include/linux/pm_domain.h
> > > > > +++ linux/include/linux/pm_domain.h
> > > > > @@ -23,6 +23,12 @@ struct dev_power_governor {
> > > > >  	bool (*power_down_ok)(struct dev_pm_domain *domain);
> > > > >  };
> > > > >  
> > > > > +struct gpd_dev_ops {
> > > > > +	int (*start)(struct device *dev);
> > > > > +	int (*stop)(struct device *dev);
> > > > > +	bool (*active_wakeup)(struct device *dev);
> > > > > +};
> > > > > +
> > > > >  struct generic_pm_domain {
> > > > >  	struct dev_pm_domain domain;	/* PM domain operations */
> > > > >  	struct list_head gpd_list_node;	/* Node in the global PM domains list */
> > > > > @@ -45,9 +51,7 @@ struct generic_pm_domain {
> > > > >  	bool dev_irq_safe;	/* Device callbacks are IRQ-safe */
> > > > >  	int (*power_off)(struct generic_pm_domain *domain);
> > > > >  	int (*power_on)(struct generic_pm_domain *domain);
> > > > > -	int (*start_device)(struct device *dev);
> > > > > -	int (*stop_device)(struct device *dev);
> > > > > -	bool (*active_wakeup)(struct device *dev);
> > > > > +	struct gpd_dev_ops dev_ops;
> > > > 
> > > > Wouldn't it be better to merge patches 1 and 2?
> > > 
> > > First, why would it?
> > 
> > Because (1) AFAICS both these patches add new logically rather close to 
> > each other methods to the same existing API,
> 
> Well, in fact .active_wakeup() was added for a totally different reason,
> but I agree that now it _looks_ analogous.
> 
> > and (2) it would reduce the 
> > total changed lines count and simplify reading of the patch(es), because 
> > your second patch moves around and modifies lines of code, that the first 
> > patch adds.
> 
> Well, I can fold [2/7] into [1/7] if that helps.

IMHO that would look nicer, yes.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
