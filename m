Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab1FVV3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:29:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51413 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023Ab1FVV33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:29:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [Update][PATCH 4/8] PM / Domains: Support for generic I/O PM domains (v6)
Date: Wed, 22 Jun 2011 23:30:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
References: <201106112223.04972.rjw@sisk.pl> <201106220207.01434.rjw@sisk.pl> <87fwn1lk61.fsf@ti.com>
In-Reply-To: <87fwn1lk61.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106222330.03146.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 22, 2011, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Tuesday, June 21, 2011, Kevin Hilman wrote:
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> [...]
> 
> >> 
> >> There's a guiding assumption in this generic PM domain layer that the
> >> runtime PM callbacks need only be called if power to the underlying PM
> >> domain is actually being cut.  As a result, devices no longer have a
> >> callback called for other low-power states where the power may not
> >> actually be cut (a.k.a low-power with memory & logic retention.)
> >> 
> >> However, there are devices (at least on OMAP, but I presume on all SoCs)
> >> where the driver will need to do other "stuff" for *all* low-power
> >> transitions, not just the power-off ones (e.g. device specific idle mode
> >> registers, clearing device-specific events/state that prevent low power
> >> transitions, etc.)
> >> 
> >> Because of this, I don't currently see how to use these generic PM
> >> domains on devices with multiple power states since the runtime PM
> >> callbacks are only called for a subset of the power states.
> >> 
> >> I haven't given this too much thought yet (especially the system PM
> >> aspects), but in order for generic PM domains to be more broadly useful
> >> for runtime PM, I'm starting to think that this series should add
> >> another set of callbacks: .power_off, .power_on or something similar.
> >> The .runtime_suspend/.runtime_resume callbacks would then be used for
> >> all power states and the .power_off/.power_on callbacks used only when
> >> power is actually cut.
> >
> > Well, I _really_ would like to avoid adding more callbacks to struct
> > dev_pm_ops, if that's what you mean, because we already seem to have
> > problems with managing the existing ones.
> 
> I agree, I don't really want to see more callbacks either.
> 
> > Also, IMO, you can always map every system with more power states to the
> > model where there are only "device active" (runtime PM RPM_ACTIVE) "device
> > stopped" (runtime PM RPM_SUSPENDED, need not save state) and "device
> > power off" (runtime PM RPM_SUSPENDED, must save state) "software" states
> > represented here.
> 
> Yes, but note that you list 2 RPM_SUSPENDED states, but there is only
> one .runtime_suspend callback, so the driver is only be notified of one
> of the them.

That's correct.

> More specifically, the problem is that using generic PM domains, there
> are no callbacks to the driver for "device stopped", since the driver's
> .runtime_suspend() is not called until "device power off."

Yes, it is, because that is not necessary for the first user (the shmobile
domain added by [8/8]).  However, I have a plan to add such a mechanism
using the subsys_data field from struct dev_pm_info (it's only used for
the clocks management right now, but it's going to see more usage anyway :-)).

> What I tried to say in my initial reply is that many devices actually
> have device specific stuff to do in preparation for "device stopped", or
> the hardware will not actually reach the targetted power state.  Without
> a callback, no device-specific preparation for "device stopped" can be
> done.
> 
> thinking out loud: hmm..., the more I think of this, maybe we should
> actually be using RPM_IDLE to represent your definition of "device
> stopped."

I don't think that will work as expected.

> > If anything more fine grained is necessary or useful, I'd say you need
> > a more complicated model, but I'd prefer to avoid further
> > complications in this patchset.
> 
> Unfortunately, PM on embedded devices is very fine grained and very
> complicated.

Which hopefully doesn't mean the code has to cover all of the possible
complications from the start. :-)

Thanks,
Rafael
