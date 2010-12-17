Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0LQXCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:02:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab0LQXCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:02:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Date: Sat, 18 Dec 2010 00:01:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Rabin Vincent <rabin@rab.in>, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com> <201012171449.26082.rjw@sisk.pl> <20101217142402.GA19391@rakim.wolfsonmicro.main>
In-Reply-To: <20101217142402.GA19391@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012180001.25263.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 17, 2010, Mark Brown wrote:
> On Fri, Dec 17, 2010 at 02:49:25PM +0100, Rafael J. Wysocki wrote:
> > On Friday, December 17, 2010, Mark Brown wrote:
> 
> > > By, for example, providing default implementations which the buses can
> > > use if they choose to.
> 
> > OK, so we have generic_subsys_pm_ops.  Do we need anything beyond that?
> 
> Hrm.  Possibly just some fiddling with those or alternative versions.
> For example, looking at the I2C bus suspend it's this:
> 
> static int i2c_device_pm_suspend(struct device *dev)
> {
> 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> 
> 	if (pm) {
> 		if (pm_runtime_suspended(dev))
> 			return 0;
> 		else
> 			return pm->suspend ? pm->suspend(dev) : 0;
> 	}
> 
> 	return i2c_legacy_suspend(dev, PMSG_SUSPEND);
> }
> 
> Ideally the if (pm) block could just be factored out into the pm core as
> there's nothing I2C-specific about that at all.  Possibly even the whole
> logic surrounding fall back to legacy, though that smells a bit.

No, the legacy is i2c-specific.

> The generic suspend operation doesn't fit here:
> 
> int pm_generic_suspend(struct device *dev)
> {
> 	return __pm_generic_call(dev, PM_EVENT_SUSPEND);
> }
> EXPORT_SYMBOL_GPL(pm_generic_suspend);

Well, looking at __pm_generic_call(), I think it does.

It appears to do exactly what the pm block above does, so it should be possible
to have something like this:

static int i2c_device_pm_suspend(struct device *dev)
{
	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
	return pm ? pm_generic_suspend(dev) : i2c_legacy_suspend(dev, PMSG_SUSPEND);
}

if I'm not missing anything.

Thanks,
Rafael
