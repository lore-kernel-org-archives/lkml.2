Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1CWKWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:22:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:39169 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab1CWKWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:22:44 -0400
Subject: Re: RFC: Platform data for onboard USB assets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: andy.green@linaro.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
In-Reply-To: <4D89BDE2.60907@linaro.org>
References: <4D79F068.2080009@linaro.org>
	 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
	 <1300828125.2402.300.camel@pasglop>  <4D8924B6.8040403@linaro.org>
	 <1300842219.2402.309.camel@pasglop>
	 <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
	 <1300850595.2402.320.camel@pasglop>  <4D89BDE2.60907@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 21:22:12 +1100
Message-ID: <1300875732.2402.359.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Well I am glad there is consensus on that, although this was the initial 
> approach in the patches already.
> 
> For me the most important issues I wanted to understand from the RFC 
> were: "do others see it as generally useful to target async probed 
> devices with data from the board definition file", and was there 
> appetite to use the apis elsewhere in the kernel to solve the problems 
> in front of me in Panda.

There is definitely some use into providing what I call "auxilliary"
data to dynamically probed devices (I'm not a fan of the "async"
terminology here), however I believe that doing so by perpetuating the
platform_data mechanism isn't the right way to go.

> I learned that among people that understood what the RFC was about there 
> was also consensus it's useful, although some people demand Device Tree 
> implementation, I think we got beyond arguing against the abstract idea 
> overall: it is accepted it would be valuable.  So this is encouraging as 
> far as it goes.

Right.

> For subsystems using it, in the initial USB case discussion got mired 
> first in understanding the idea at all from USB perspective, and then 
> lost down well-trodden positions on what the actual data is used for in 
> the included use-cases.  The same is happening here -->

Note that the discussion is valid for PCI as well. A typical example is
old style PCI 2.x (still quite common) where interrupt lines for on
board devices are wired to random GPIO :-)

Here too we have an old ad-hoc solution which tends to be subtely
different for all architectures, tho at least drivers generally don't
care. The basic problem is the same tho.

> > The device-tree and whatever other udev based solutions using physical
> > path are both "transports" in a sense for that same information and so
> > in the grand scheme of thing equivalent.
> >
> > The argument boils down to should we encourage adding an additional
> > in-kernel platform_data based hooks for dynamically probed busses such
> 
> Well, these are not hooks in the usual usage of the word.
> 
> > as USB as well ? or go for a udev based solution for the time being
> > which would probably work as well in practice and focus on getting the
> > device-tree based solution for the long term instead.
> 
> There is no udev solution for what is being done currently by the async 
> platform_data patchset with SDIO WLAN.  The patches are out there and in 
> use already.  The only reason I don't post them here as round 2 of the 
> RFC yet is because Grant wanted a couple of days and politically it's 
> expedient for me to agree to that.

I haven't looked at your SDIO work nor have I time to get into details
here. However I'm concerned about the "big picture" if you like and
eager to move toward a generally more flexible model than platform_data
style data structures.

I don't believe that the legacy of platform_data for platform_devices is
relevant here as we are -not- talking about platform_devices, but
generally devices that have their own "struct device" subclass, and thus
have the potential of using new tools to fix those drivers without
necessarily engaging into an immediate conversion of all the existing
platform_devices in the tree.

> >> With regards to DT on ARM I'm rather "softly" convinced this is a good
> >> thing.  However seeing a persisting lack of truly technical answers to
> >> Andy's questions is rather disturbing, and makes me wish for much more
> >> than the current hype around DT which appears to fall flat when
> >> challenged.
> >
> > I don't think any technical answer is missing. Dynamic platform data is
> > possible and in fact the platform could do it today using bus notifiers
> > and "hooking up" the platform data on the fly if needed I suppose.
> 
> Ah now, steady on.  I was very surprised actually and I still am in this 
> thread how incomplete the thinking and implementation is for Device Tree 
> interoperation with platform_data.

It's been generally an evolving process, with trial and error, as is
common with the Linux kernel. Nobody wants a big flag day which requires
a full conversion of the entire kernel.

Among ideas that have been proposed have been the idea of having stubs
generating pseudo-device nodes from platform_data for devices in order
to enable the drivers to use a single interface for example. That didn't
really go through tho. However, whatever the final approach will be, the
point remains that for drivers that have not so far been "contaminated"
by the platform_data paradigm, we have the opportunity to try something
better, which can then, maybe, be retro-fitted on a case by case basis
to platform drivers, for example as such drivers get converted to also
be capable of using the device-tree.

This is where I'm trying to propose a middle ground with the idea of
named properties. It goes toward the direction that platform_device has
been trying to to with the struct resource, but there's only so much you
can do with these and they are showing their limits when it comes to
expose arbitrary informations. MAC addresses are an example but there
are many more, from clock bindings, power control, PHY data, connector
informations, yadadada... which all can potentially apply to on-board
USB or PCI based devices.

>   Surely interoperation with the 
> established way of doing things should have been very high on the list 
> of things to have an answer for before embarking on everything else.  In 
> fact, how to do that in drivers seems to be being figured out by you 
> guys as you go along in this thread as if my RFC is the first time that 
> particular critical bit of Device Tree rubber is meeting the real road. 
>   I have no idea why the burden of that has appeared on my particular back.
> 
> When I described the issues I see with Arnd's approach fracturing 
> support for new features and bugfixes in drivers, it was waved off 
> because of patches that were "just posted" that apparently "solve" this. 
>   Where they were posted, what they do, how they solve it was not told 
> and that strand of the discussion was killed.  However it seemed like 
> the single most important issue to come out of the thread for Device 
> Tree and we take it back up again in this post.

Rant rant rant :-) The device-tree is a well proven mechanism on some
platforms, the question is mostly whether we want it to become the
standard way to go, and whether we can find out a reasonable approach to
migration that doesn't involve requiring an immediate conversion of all
drivers in the tree.

To some extent I think that an approach that can isolate the drivers
from the "transport" mechanism (device-tree or hard wired platform data
style data structures) would be best and that's where I coming with my
proposal of introducing a concept of named properties.

Cheers,
Ben.


