Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab0JVX1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:27:36 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:46868 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab0JVX1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:27:35 -0400
Date: Sat, 23 Oct 2010 00:27:22 +0100
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: Re: [PATCH 27/30] staging/vme: rework the bus model
Message-ID: <20101022232707.GA1370@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org> <1287729412-24356-28-git-send-email-cota@braap.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287729412-24356-28-git-send-email-cota@braap.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 10:26:11 +0100, Martyn Welch wrote:
> Hi Emilio,
> 
> Thank you for the fixes. After a quick glance, there seem to be a number
> of valid fixes here, but I'm very concerned by the patches that change
> the driver model. We discussed this approach in August last year, I am
> still yet to be convinced by the approach you wish to take.
(snip)
> As I've said above - I am still not convinced by the change in approach.

I'd like to know what exactly doesn't convince you.

Let's re-visit the commit message:

Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> The way in which VME devices and drivers are currently bound together
> involves unnecessary contortions. Controlling a device with a VME driver
> requires the following steps, in this order:
> 
> - installing the VME core, eg insmod vme.ko
> - installing the VME boards' drivers, where the devices to be controlled
>   are passed to the VME core through the so-called bind tables.  Note that
>   these modules are hooking stuff onto the VME core while the bridge driver
>   that provides the bus they'll to attach hasn't yet been loaded.
> - insmod of the VME bridge driver. 32 devices (called slots) are _always_
>   created, and then the bus's .match method is called for each of them.
>   This works because the boards' drivers have already hooked stuff onto
>   the VME core (see previous step.)
> 
> There are a few things I dislike about the above:
> 
> * installing drivers even before the bridges they need are present
>   seems counter-intuitive and wrong.
> * a VME bus may need more than 32 devices--the relation to the 32 slots on
>   a VME crate is artificial and confusing:
> 	* Some VME cards may be best treated in the kernel as several
> 	  independent devices, and therefore it is pointless to limit the
> 	  number of devices on the bus.
> 	* In VME jargon, a slot is a physical place where hardware is sitting,
> 	  and is clearly out of the kernel's control. Users may thus have a
> 	  misleading impression of 'this is what's on slot X', and then go
> 	  to the crate and see that slot X is empty.
> * .probe and .remove pass a pointer to a struct device representing a VME
>   bridge, instead of representing the device to be added/removed.
> 	* a bridge's module may be removed anytime and things do fall over;
> 	  there is no refcounting at all and thus all drivers attached to
> 	  the removed bus will oops.
> * the so-called "bind table" is tricky, unnecessary and boring code that just
>   duplicates what modparam's arrays do.

Do we first agree on the shortcomings mentioned above?
Because if we don't, then there's no point in discussing alternatives.


This is what the patch does:


> The appended implements a new driver model for VME that is free of the
> shortcomings described above.
> 
> In short, a VME driver calls vme_register_driver, which takes the number of
> devices to be matched as a parameter, say n. Then the driver's .match method
> is called n times for each bus registered on the VME core. That is,
> if there are m VME buses registered, m * n devices are created and passed
> to .match. Devices that do match are probed, while devices that don't match
> are removed. The only difference between this and what happens in most
> buses is that here .match is passed down from the bus to the drivers, which
> in VME are the only ones that can tell whether or not a particular device is
> present.
> 
> A VME device is thus uniquely identified by the triplet
> (driver_name,bus_id,dev_id), formatted as '$driver_name-$bus_id.$dev_id'.
> 
> The VME bus has no auto-discovery capabilities, an illness which the ISA
> bus also suffers from. Not surprisingly then, most of the appended code has
> been adapted from drivers/base/isa.c, added to the kernel in a5117ba7da. For
> further explanations please read that a5117ba7da's commit message. The major
> difference here is that several VME buses can coexist whereas in ISA only
> a single bus is supported.

The key here is to realise that .match is passed down to the drivers.
This way drivers don't need to do contortions like the bind table
and things flow naturally--e.g. when a bridge is installed, vme
drivers can be installed/uninstalled on top of it, not the other
way around.

This is not my idea; I took it from ISA, where they had the same problem.

The code is there, it works, and aligns the VME driver model closer with
that of other buses supported by the kernel.

Again, please let me know the precise source of your concerns.

Thanks

		Emilio

