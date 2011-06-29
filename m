Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1F2Sru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:47:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55954 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751361Ab1F2Srs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:47:48 -0400
Date: Wed, 29 Jun 2011 14:47:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Partha Basak <p-basak2@ti.com>
cc: Keshava Munegowda <keshava_mgowda@ti.com>, Kevin Hilman <khilman@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Anand Gadiyar <gadiyar@ti.com>, <sameo@linux.intel.com>,
        <parthab@india.ti.com>, <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>, <paul@pwsan.com>
Subject: RE: [PATCH 4/4] mfd: global Suspend and resume support of ehci and
 ohci
In-Reply-To: <2f837bd4c0fb09f310feb414479f3350@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1106291446220.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, Partha Basak wrote:

> >-----Original Message-----
> >From: Alan Stern [mailto:stern@rowland.harvard.edu]
> >Sent: Wednesday, June 29, 2011 11:03 PM
> >To: Munegowda, Keshava
> >Cc: Kevin Hilman; linux-usb@vger.kernel.org; linux-omap@vger.kernel.org;
> >linux-kernel@vger.kernel.org; balbi@ti.com; gadiyar@ti.com;
> >sameo@linux.intel.com; parthab@india.ti.com; tony@atomide.com; b-
> >cousson@ti.com; paul@pwsan.com
> >Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci
> >and ohci
> >
> >On Wed, 29 Jun 2011, Munegowda, Keshava wrote:
> >
> >> for usb host case , I am seeing that the pm_runtime_get_sync
> >>
> >>
> >> static int rpm_resume(struct device *dev, int rpmflags)
> >> {
> >>   ............
> >>  ..........
> >> 	if (dev->pwr_domain) {
> >> 		callback = dev->pwr_domain->ops.runtime_resume;
> >> 		if(!strcmp(dev_name(dev),"usbhs_omap"))
> >> 			 pr_err("dev->pwr_domain->ops.runtime_resume");
> >> 	}
> >> 	else if (dev->type && dev->type->pm) {
> >> 		callback = dev->type->pm->runtime_resume;
> >> 		if(!strcmp(dev_name(dev),"usbhs_omap"))
> >> 			 pr_err("dev->type->pm->runtime_resume");
> >> 	}
> >> 	else if (dev->class && dev->class->pm) {
> >> 		callback = dev->class->pm->runtime_resume;
> >> 		if(!strcmp(dev_name(dev),"usbhs_omap"))
> >> 			 pr_err("ev->class->pm->runtime_resume");
> >> 	}
> >> 	else if (dev->bus && dev->bus->pm) {
> >> 		callback = dev->bus->pm->runtime_resume;
> >> 	if(!strcmp(dev_name(dev),"usbhs_omap"))
> >> 		 pr_err("dev->bus->pm->runtime_resume");
> >> 	}
> >> 	else
> >> 		callback = NULL;
> >> }
> >>
> >>
> >> I am seeing that below if statement was hitting true:
> >>
> >> 	if (dev->pwr_domain) {
> >> 		callback = dev->pwr_domain->ops.runtime_resume;
> >> 		if(!strcmp(dev_name(dev),"usbhs_omap"))
> >> 			 pr_err("dev->pwr_domain->ops.runtime_resume");
> >>
> >>
> >> due to this; the driver->runtime_resume was not getting called.
> >>
> >> Any idea on why I am seeing only the dev->pwr_domain is set not
> >> dev->bus && dev->bus->pm is hitting here?
> >
> >Because the PM domain takes precedence over the subsystem for PM
> >callbacks.  If the subsystem routine should be called then the PM
> >domain code has to call it.
> 
> This is taken care of in the pm-domain code:
> static int _od_runtime_resume(struct device *dev)
> {
> 	struct platform_device *pdev = to_platform_device(dev);
> 
> 	omap_device_enable(pdev);
> 
> 	return pm_generic_runtime_resume(dev);
> }
> pm_generic_runtime_resume will in turn call the driver call back.
> 
> int pm_generic_runtime_resume(struct device *dev)
> {
> 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm :
> NULL;
> 	int ret;
> 
> 	ret = pm && pm->runtime_resume ? pm->runtime_resume(dev) : 0;
> 
> 	return ret;
> }

You appear to be contradicting what Keshava wrote: "due to this; the
driver->runtime_resume was not getting called."

You can't both be right.

Alan Stern


