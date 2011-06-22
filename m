Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab1FVTvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:51:08 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:35957 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758014Ab1FVTvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:51:06 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Subject: Re: [Update][PATCH 4/8] PM / Domains: Support for generic I/O PM domains (v6)
Organization: Texas Instruments, Inc.
References: <201106112223.04972.rjw@sisk.pl> <201106200002.19377.rjw@sisk.pl>
	<874o3jt72c.fsf@ti.com> <201106220207.01434.rjw@sisk.pl>
Date: Wed, 22 Jun 2011 12:51:02 -0700
In-Reply-To: <201106220207.01434.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 22 Jun 2011 02:07:01 +0200")
Message-ID: <87fwn1lk61.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Tuesday, June 21, 2011, Kevin Hilman wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:

[...]

>> 
>> There's a guiding assumption in this generic PM domain layer that the
>> runtime PM callbacks need only be called if power to the underlying PM
>> domain is actually being cut.  As a result, devices no longer have a
>> callback called for other low-power states where the power may not
>> actually be cut (a.k.a low-power with memory & logic retention.)
>> 
>> However, there are devices (at least on OMAP, but I presume on all SoCs)
>> where the driver will need to do other "stuff" for *all* low-power
>> transitions, not just the power-off ones (e.g. device specific idle mode
>> registers, clearing device-specific events/state that prevent low power
>> transitions, etc.)
>> 
>> Because of this, I don't currently see how to use these generic PM
>> domains on devices with multiple power states since the runtime PM
>> callbacks are only called for a subset of the power states.
>> 
>> I haven't given this too much thought yet (especially the system PM
>> aspects), but in order for generic PM domains to be more broadly useful
>> for runtime PM, I'm starting to think that this series should add
>> another set of callbacks: .power_off, .power_on or something similar.
>> The .runtime_suspend/.runtime_resume callbacks would then be used for
>> all power states and the .power_off/.power_on callbacks used only when
>> power is actually cut.
>
> Well, I _really_ would like to avoid adding more callbacks to struct
> dev_pm_ops, if that's what you mean, because we already seem to have
> problems with managing the existing ones.

I agree, I don't really want to see more callbacks either.

> Also, IMO, you can always map every system with more power states to the
> model where there are only "device active" (runtime PM RPM_ACTIVE) "device
> stopped" (runtime PM RPM_SUSPENDED, need not save state) and "device
> power off" (runtime PM RPM_SUSPENDED, must save state) "software" states
> represented here.

Yes, but note that you list 2 RPM_SUSPENDED states, but there is only
one .runtime_suspend callback, so the driver is only be notified of one
of the them.

More specifically, the problem is that using generic PM domains, there
are no callbacks to the driver for "device stopped", since the driver's
.runtime_suspend() is not called until "device power off."

What I tried to say in my initial reply is that many devices actually
have device specific stuff to do in preparation for "device stopped", or
the hardware will not actually reach the targetted power state.  Without
a callback, no device-specific preparation for "device stopped" can be
done.

thinking out loud: hmm..., the more I think of this, maybe we should
actually be using RPM_IDLE to represent your definition of "device
stopped."

> If anything more fine grained is necessary or useful, I'd say you need
> a more complicated model, but I'd prefer to avoid further
> complications in this patchset.

Unfortunately, PM on embedded devices is very fine grained and very
complicated.

Kevin
