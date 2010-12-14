Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0LNOYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:24:11 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:36816 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0LNOYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:24:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [alsa-devel] [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Tue, 14 Dec 2010 15:25:00 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3; KDE/4.5.3; x86_64; ; )
Cc: alsa-devel@alsa-project.org, sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <201012141300.57118.laurent.pinchart@ideasonboard.com> <4D0771CB.3020809@ladisch.de>
In-Reply-To: <4D0771CB.3020809@ladisch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012141525.02463.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens,

On Tuesday 14 December 2010 14:31:55 Clemens Ladisch wrote:
> Laurent Pinchart wrote:
> > On Monday 13 December 2010 17:10:51 Clemens Ladisch wrote:
> >> TYPE_EXT describes entities that represent some interface to the
> >> external world, TYPE_INT those that are internal to the entire device.
> >> (I'm not sure if that distinction is very useful, but TYPE_SUBDEV seems
> >> to be an even more meaningless name.)
> > 
> > SUBDEV comes from the V4L2 world, and I agree that it might not be a very
> > good name.
> > 
> > I'm not sure I would split entities in internal/external categories. I
> > would create a category for connectors though.
> 
> I'm not disagreeing, but what is actually the distinction between types
> and subtypes?  ;-)

The type is currently used to distinguish between entities that stream media 
data from/to memory and other entities. They need to be handled differently in 
the kernel for power management purposes for instance.

I'm not sure if we should create new types, or just remove the type/subtype 
distinction and add a flag somewhere.

> >> * Entity properties
> >> 
> >> There needs to be a mechanism to associate meta-information (properties)
> >> with entities.  This information should be optional and extensible, but,
> >> when being handled inside the kernel, doesn't need to be more than
> >> a read-only blob.  I think that something like ALSA's TLV format (used
> >> for mixer controls) can be used here.  (I'm not mentioning the X-word
> >> here, except to note that the "M" stands for "markup".)
> > 
> > I've been thinking of adding a new ioctl for that. It's something we need
> > to draft. The UVC driver will need it, and I'm pretty sure other V4L2
> > drivers would find it useful as well.
> 
> I'm imagining a "read-the-properties" ioctl that just returns the
> entity's blob.

Martin Rubli has already proposed something similar a while ago on the linux-
media mailing list. His proposal didn't use TLV though.

> >> EXT_SPEAKER also includes headphones; there might be made a case for
> >> having those as a separate subtype.
> > 
> > Shouldn't headphones be represented by an EXT_JACK_ANALOG ?
> 
> Headphone jacks are jacks; there are also USB headphones.

So EXT_SPEAKER are speakers not connected through a jack (USB, internal 
analog, ...) ?

> >> EXT_BROADCAST represents devices like TV tuners, satellite receivers,
> >> cable tuners, or radios.
> > 
> > There's clearly an overlap with V4L here.
> 
> These come from the USB audio spec.  Video devices are indeed likely to
> be more detailed than just a single audio source. :)

Does EXT_BROADCAST represent the TV tuner (or satellite receiver, cable tuner, 
radio tuner, ...) itself, or the connection between the tuner and the rest of 
the device ? Most TV tuner are currently handled by V4L2 and would thus turn 
up as V4L2 subdevs (I'm not sure if that's what we want in the long term, but 
it's at least the current situation).

> >> INT_CONTROLS may have multiple independent controls (this is USB's
> >> Feature Unit); INT_EFFECT may have multiple controls that affect one
> >> single algorithm.
> > 
> > I'd describe this as a feature unit/processing unit then.
> 
> I was aiming for more descriptive names, but I agree that the original
> names might be more useful.
> 
> > Should we have an AUDIO category ?
> 
> Probably not, because there are combined audio/video jacks, any maybe
> other entities.

> >> * Entity specifications
> >> 
> >> While TYPE_DEVICE entities can be identified by their device node, other
> >> entities typcially have just a numeric ID.
> > 
> > In V4L2 sub-devices have (or rather will have once the media controller
> > patches will be integrated) device nodes as well, so exposing that
> > information is required.
> 
> USB and HDA entities already have numeric IDs.

Right. Same for USB Video Class.

We could let drivers set the entity ID, and have the core fill it if the value 
is 0. Non-zero values would have to be checked for uniqueness though. Hans, a 
comment on that ?

> >> For that, it would be useful to make do without separate identification
> >> and let the driver choose the entity ID.
> > 
> > How would drivers do that ? What if you have two instances of the same
> > chip (a video sensor, audio mixer, ...) on the same board ?
> 
> Then those would get different IDs; USB descriptors always describe the
> entire device.

-- 
Regards,

Laurent Pinchart
