Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab0LQOYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 09:24:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42659 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754860Ab0LQOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:24:05 -0500
Date: Fri, 17 Dec 2010 14:24:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rabin Vincent <rabin@rab.in>, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Message-ID: <20101217142402.GA19391@rakim.wolfsonmicro.main>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com>
 <201012171425.07775.rjw@sisk.pl>
 <20101217133434.GH31453@rakim.wolfsonmicro.main>
 <201012171449.26082.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012171449.26082.rjw@sisk.pl>
X-Cookie: Edited for television.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 02:49:25PM +0100, Rafael J. Wysocki wrote:
> On Friday, December 17, 2010, Mark Brown wrote:

> > By, for example, providing default implementations which the buses can
> > use if they choose to.

> OK, so we have generic_subsys_pm_ops.  Do we need anything beyond that?

Hrm.  Possibly just some fiddling with those or alternative versions.
For example, looking at the I2C bus suspend it's this:

static int i2c_device_pm_suspend(struct device *dev)
{
	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;

	if (pm) {
		if (pm_runtime_suspended(dev))
			return 0;
		else
			return pm->suspend ? pm->suspend(dev) : 0;
	}

	return i2c_legacy_suspend(dev, PMSG_SUSPEND);
}

Ideally the if (pm) block could just be factored out into the pm core as
there's nothing I2C-specific about that at all.  Possibly even the whole
logic surrounding fall back to legacy, though that smells a bit.  The
generic suspend operation doesn't fit here:

int pm_generic_suspend(struct device *dev)
{
	return __pm_generic_call(dev, PM_EVENT_SUSPEND);
}
EXPORT_SYMBOL_GPL(pm_generic_suspend);
