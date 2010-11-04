Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab0KDEQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 00:16:50 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:42096 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab0KDEQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 00:16:49 -0400
Date: Thu, 4 Nov 2010 00:16:27 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 27/30] staging/vme: rework the bus model
Message-ID: <20101104041627.GD9037@flamenco.cs.columbia.edu>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
 <1288055476-19438-28-git-send-email-cota@braap.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288055476-19438-28-git-send-email-cota@braap.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martyn,

Do you have any further comments on this patch?
I quote below the commit message, inlining some comments since
some messages didn't hit some of the recipients the first time.

On Mon, Oct 25, 2010 at 21:11:13 -0400, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> The way in which VME devices and drivers are currently bound together
> involves unnecessary contortions. Controlling a device with a VME driver
> requires the following steps, in this order:
(snip)
> There are a few things I dislike about the above:

> * installing drivers even before the bridges they need are present
>   seems counter-intuitive and wrong.

My mistake, this isn't true. As we've discussed already(*), binding
happens both when a device is registered AND when a driver is registered.

(*) http://lkml.org/lkml/2010/10/27/284

> * a VME bus may need more than 32 devices--the relation to the 32 slots on
>   a VME crate is artificial and confusing:
(snip)
Which translates into what I described here:
http://lkml.org/lkml/2010/10/27/284

And I resuscitate from that message the following:

> Imagine the following situation:
> 
> - insmod vme_driver1.ko bus=0,0,0 slot=1,2,3
> 
> Then two days after I want to install another driver:
> 
> - insmod vme_driver2.ko bus=0,0,0 slot=X,Y,Z
> 
> Now X,Y,Z cannot be in (1,2,3), because those are understood
> as physical slots, even if they're not (this is not VME64x)
> 
> So, anytime I need to install a device, I must know the slot
> numbers of all other devices--even though there's no
> physical meaning to it!

In the model I proposed device id's ("slots") are unique
to each driver. This way we can install drivers without
caring whether or not other drivers have overlapping "slot" id's
for their devices.

> * .probe and .remove pass a pointer to a struct device representing a VME
>   bridge, instead of representing the device to be added/removed.
> 	* a bridge's module may be removed anytime and things do fall over;
> 	  there is no refcounting at all and thus all drivers attached to
> 	  the removed bus will oops.

As discussed here no one is happy with the current state of affairs:
http://lkml.org/lkml/2010/10/27/264

Greg suggests that when a bridge is removed, all devices on top of it
should go away. In my opinion that's the most convenient solution.

This patch, however, does not allow a bridge to be removed unless all
its devices are removed first. It's not as nice as what Greg proposes,
but at least it's an improvement over what we've got now--it gets
refcounting right, etc.

After having inspected the USB core code I think it wouldn't be hard
to go from this patch to a situation where a bridge can be removed
anytime without the whole thing falling over. Before tackling that
I'd like to hear your opinion.

Thanks,

		Emilio

