Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1GAAIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:08:25 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:36841 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533Ab1GAAIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:08:23 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 7/10 v6] PM / Domains: Don't stop wakeup devices during system sleep transitions
Organization: Texas Instruments, Inc.
References: <201106112223.04972.rjw@sisk.pl> <201107010055.26952.rjw@sisk.pl>
	<87iprmdi9o.fsf@ti.com> <201107010128.03732.rjw@sisk.pl>
Date: Thu, 30 Jun 2011 17:01:51 -0700
In-Reply-To: <201107010128.03732.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri, 1 Jul 2011 01:28:03 +0200")
Message-ID: <8762nmc1hs.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Friday, July 01, 2011, Kevin Hilman wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > On Friday, July 01, 2011, Kevin Hilman wrote:
>> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> >> 
>> >> > On Thursday, June 30, 2011, Kevin Hilman wrote:
>> >> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> >> >> 
>> >> >> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> >> >> >
>> >> >> > Devices that are set up to wake up the system from sleep states
>> >> >> > should not be stopped and power should not be removed from them
>> >> >> > when the system goes into a sleep state.  
>> >> >> 
>> >> >> I don't think this belongs in the generic layer since the two
>> >> >> assumptions above are not generally true on embedded systems, and would
>> >> >> result in rather significant power consumption unnecessarily.
>> >> >
>> >> > As to whether or not this belongs to the generic layer, I don't quite agree
>> >> > (see below), but the changelog seems to be a bit inaccurate.
>> >> >
>> >> >> First, whether the device should be stopped on device_may_wakeup():
>> >> >> b
>> >> >> Some IP blocks (at least on OMAP) have "asynchronous" wakeups.  Meaning
>> >> >> that they can generate wakeups even when they're not clocked (a.k.a
>> >> >> stopped).  So in this case, even after a ->stop_device (which clock
>> >> >> gates the IP), it can still generate wakeups.
>> >> >> 
>> >> >> Second, whether the device should be powered off if device_may_wakeup():
>> >> >> 
>> >> >> Embedded SoCs have other ways to wakeup than device-level wakeups.
>> >> >> 
>> >> >> For example, on OMAP, every pad on the SoC can be configured as a wakeup
>> >> >> source So, for example, you could completely power down the UART IP
>> >> >> blocks (and the enclosing power domain), configure the UART RX pad as a
>> >> >> wakeup source, and still wakeup the system on UART activity.  The OMAP
>> >> >> docs call these IO pad wakeups.
>> >> >> 
>> >> >> On OMAP in fact, this is the common, default behavior when we enable
>> >> >> "off-mode" in idle and/or suspend, since most of the IPs are powered off
>> >> >> but can still wake up the system.
>> >> >> 
>> >> >> So in summary, even if device_may_wakeup() is true, many devices (with
>> >> >> additional SoC magic) can still generate wakeups even when stopped and
>> >> >> powered off.
>> >> >
>> >> > Well, on the other hand, on some SoCs there are devices that can't be
>> >> > powered off (or "declocked") if they are supposed to generate wakeups.
>> >> 
>> >> Correct.
>> >> 
>> >> > Also, I'm sure there are cases in which wakeups can be generated for devices
>> >> > with their clocks off, but only if power is present.  
>> >> 
>> >> Yes.
>> >> 
>> >> > So there are multiple
>> >> > cases, but not so many overall.  So, IMO, it makes sense to handle that at
>> >> > the generic level, although not necessarily in such a simplistic way.
>> >> >
>> >> > Now, at this point, I want to do something very simple, which I think is
>> >> > done by this patch. 
>> >> >
>> >> > Is this optimal power comsumption-wise for every potential
>> >> > user of the framework?  
>> >> 
>> >> Well, sub-optimal would be an understatement.  I would consider this a
>> >> major regression since if we were to use this for OMAP, we would never
>> >> hit the full-chip low-power states if *any* device had wakeups enabled,
>> >> whereas today we can.
>> >> 
>> >> > No, but certainly for some it's sufficient.  Is it
>> >> > going to work in general?  I think it is.
>> >> >
>> >> > Of course, there's the question how to handle that more accurately and I have
>> >> > some ideas.  If you have any, please let me know.
>> >> >
>> >> > In the meantime, I'm going to modify the changelog so that it's clear that
>> >> > it's a "first approximation" thing, like in the patch below.
>> >> >
>> >> > Thanks,
>> >> > Rafael
>> >> >
>> >> > ---
>> >> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> >> > Subject: PM / Domains: Don't stop wakeup devices during system sleep transitions
>> >> >
>> >> > There is the problem how to handle devices set up to wake up the
>> >> > system from sleep states during system-wide power transitions.
>> >> > In some cases, those devices can be turned off entirely, because the
>> >> > wakeup signals will be generated on their behalf anyway.  In some
>> >> > other cases, they will generate wakeup signals if their clocks are
>> >> > stopped, but only if power is not removed from them.  Finally, in
>> >> > some cases, they can only generate wakeup signals if power is not
>> >> > removed from them and their clocks are enabled.
>> >> 
>> >> That's a good summary.
>> >> 
>> >> > In the future, it will be necessary to take all of the above
>> >> > situations into account, but for starters it is possible to use
>> >> > the observation that if all wakeup devices are treated like the
>> >> > last group (i.e. their clocks are enabled and power in not removed
>> >> > from them during system suspend transitions), they all will be able
>> >> > to generate wakeups, although power consumption in the resulting
>> >> > system sleep state may not be optimal in some cases.
>> >> 
>> >> I'm not opposed to this kind of check happening.  I'm only opposed to it
>> >> happening in this "generic" layer because..., well, it's not generic.
>> >> 
>> >> Not only is it not generic, it would be a major regression in power
>> >> consumption for anyone moving to this layer that has the various
>> >> different wakeup capabilities already described.
>> >> 
>> >> The decision of whether or not to clock gate and/or power gate based on
>> >> wakeup capabilies has to be made somewhere (and in fact is already made
>> >> by existing code.)  But IMO, that decision should only be made where
>> >> wakeup capabilies are known, so that sensible decisions (for power
>> >> management) can be made.
>> >> 
>> >> Until there is a way in the generic code to distinguish between the
>> >> various ways a device can wakeup, this decision should be left up to the
>> >> code that knows how.
>> >
>> > OK, so I suppose your suggestion is to drop the patch and let the
>> > .stop_device() and .power_off() PM domain callbacks to hand that, is this
>> > correct?
>> 
>> Correct.
>> 
>> Initially I was thinking only about .power_off(), but you'd probably
>> want this at .stop_device() too.  In order to do that, probably want
>> .stop_device() to be able to return an error code such that an error
>> would prevent .power_off().
>
> I've just sent a reply to that. :-) I'll reproduce it below for easier
> reference:
>
> Neither .stop_device(), nor .power_off() can make such decisions,
> because they are used for both runtime PM and system suspend, so they
> shouldn't do system suspend-specific checks.
>
> So the only way forward I can see is to add a special PM domain callback,
> say .active_wakeup(), that will return "true" if the device is to be left
> active when wakeup-enabled.  So the check you don't like will become
> something like:
>
> if (device_may_wakeup(dev) && genpd->active_wakeup
>     && genpd->active_wakeup(dev))
>         return 0;
>
> Would that be better?

Yes, much better.  And I like the default behavior if no hooks are provided.

Thanks!

Kevin






