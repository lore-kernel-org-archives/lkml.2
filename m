Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1DGO7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:59:07 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:33133 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171Ab1DGO7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:59:04 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH/RFC 0/6] ARM: runtime PM: consolidate runtime PM implementations
Organization: Texas Instruments, Inc.
References: <1302134569-22825-1-git-send-email-khilman@ti.com>
	<201104070738.42956.rjw@suse.com>
Date: Thu, 07 Apr 2011 07:58:57 -0700
In-Reply-To: <201104070738.42956.rjw@suse.com> (Rafael J. Wysocki's message of
	"Thu, 7 Apr 2011 07:38:42 +0200")
Message-ID: <871v1eaz0u.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding linux-pm, which I forgot to add in original post]

"Rafael J. Wysocki" <rjw@suse.com> writes:

> On Thursday, April 07, 2011, Kevin Hilman wrote:
>> This series aims to consolidate OMAP and SH-mobile runtime PM
>> implementations around the new device power domains.
>> 
>> In 2.6.39, device power domains were added (commit
>> 7538e3db6e015e890825fbd9f8659952896ddd5b, PM: add support for device
>> power domains).  In converting both OMAP and SH-mobile to use device
>> power domains, the overlap between implementations was almost 100%.  
>> 
>> To share the runtime PM implementation based on simple clock gating,
>> move it to arch/arm/common and initialize it from OMAP and SH-mobile.
>> 
>> Also, OMAP was the only user of platform_bus_set_pm_ops().  Now that
>> it has been converted to device power domains, remove
>> platform_bus_set_pm_ops().
>
> Please, don't do it this way.
>
> First, we'll still need platform_bus_set_pm_ops() on shmobile and the reason
> is that we want to override the platform bus type PM ops for _all_ devices on
> that platform, which power domains are not really suitable for.

That doesn't sound quite right to me.

Magnus should step in here to clarify the situation on SH-mobile, but
like Grant, I'm pretty sure that we don't need (or want) to replace PM
ops for _all_ platform devices.

Looking at the replacement ops used, they simply manage device clocks,
and this probably only applies to on-chip devices (at least that's true
on OMAP.)

Replacing the PM ops for all devices was done on OMAP and SH-mobile
because that was the only approach we had.  Now that we have device
power domains (thanks Rafael!), we can be more selective about which
devices to apply them to.

Note that my RFC patch/series did not do the selective part of deciding
which devices to override and which ones not to, that part will be
platform specific.  

> Second, we're going to introduce code for handling real power domains for
> shmobile that would conflict with the way you're using power domains for
> overriding the default PM ops.

Conflict in what way?

If you have new device power domain callbacks for specific devices in a
an on-chp power domain, they would just override the "default" ones that
only do basic clock gating.  I'm guessing the new callbacks will do some
management of the SoC specific powerdomains in addition to clock gating.
That's how it works on OMAP.

Put a different way, the device power domain callbacks in this proposal
will be the defaults, providing a simple clock-gating only approach to
device power management.   However, when new code comes along to manage
the actual SoC power domains, devices in those power domains will just
override these default clock-gating-only versions.

This is exactly how things are working in OMAP.  On OMAP1, we use only
the simple, clock-gating only callbacks because the OMAP1 PM
capabilities are much more limited.  On OMAP2+, we override these
callbacks with different ones that in addition to managing clocks, also
manage the SoC power domains.

> Besides, the way you've used power domains appears to assume that drivers
> will not define their own runtime PM callbacks, because if they do, those
> callbacks will be called _in_ _addition_ to the power domain callbacks you're
> trying to add (from the default platform bus type callbacks).

That was intentional.

If all a driver needs to do for runtime PM is manage clocks, it doesn't
need runtime PM callbacks since it's hanlded by core code.  If it has
additional things to do (save context, quiesce hardware, wait for
somthing to finish etc.) it can do that in it's own callbacks, and then
the clock gating will happen in the device power domain callbacks.

The point is use both levels of callbacks. The device power domain
callbacks handle all the operations that are common to the device power
domain, and the driver callbacks handle driver specific stuff.  

It also means that drivers don't have to manage their own clocks, at
least for PM purposes.  This is a big win for drivers that are used on
multiple platforms, or even multiple SoCs in the same family where
clocking may be different.  Drivers that can remain ignorant of the
underlying clocking (and power domain layout) are much more portable.

Kevin



