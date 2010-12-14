Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194Ab0LNMw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:52:26 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:57972 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759009Ab0LNMwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:52:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [alsa-devel] [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Tue, 14 Dec 2010 13:53:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3; KDE/4.5.3; x86_64; ; )
Cc: "Clemens Ladisch" <clemens@ladisch.de>, alsa-devel@alsa-project.org,
        sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <201012141300.57118.laurent.pinchart@ideasonboard.com> <e629c78fffa0f709d743473f10334fd7.squirrel@webmail.xs4all.nl>
In-Reply-To: <e629c78fffa0f709d743473f10334fd7.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012141353.15749.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Tuesday 14 December 2010 13:40:21 Hans Verkuil wrote:
> > On Monday 13 December 2010 17:10:51 Clemens Ladisch wrote:
> >> * Entity types
> >> 
> >> TYPE_NODE was renamed to TYPE_DEVICE because "node" sounds like a node
> >> in a graph, which does not distinguish it from other entity types
> >> because all entities are part of the topology graph.  I chose "device"
> >> as this type describes entities that are visible as some device node to
> >> other software.
> > 
> > What this type describes is a device node. Both NODE and DEVICE can be
> > confusing in my opinion, but DEVICE_NODE is a bit long.
> 
> What about DEVNODE? I think that would be a good alternative.

Fine with me. Clemens, any opinion on that ?

> >> TYPE_EXT describes entities that represent some interface to the
> >> external world, TYPE_INT those that are internal to the entire device.
> >> (I'm not sure if that distinction is very useful, but TYPE_SUBDEV seems
> >> to be an even more meaningless name.)
> > 
> > SUBDEV comes from the V4L2 world, and I agree that it might not be a very
> > good name.
> 
> SUBDEV refers to a specific type of driver. Within the v4l world it is
> well defined. So I prefer to keep this. Perhaps some additional comments
> or documentation can be added to clarify this.

Should this be clarified by using V4L2_SUBDEV instead then ? What about ALSA 
entities, should they use MEDIA_ENTITY_TYPE_ALSA_* ?

> > I'm not sure I would split entities in internal/external categories. I
> > would create a category for connectors though.
> 
> I agree. It was always the plan to eventually add connectors, but v4l
> didn't really need it (it already has an API to enumerate connectors).
> 
> >> ALSA mixer controls are not directly represented; a better fit for the
> >> architecture of actual devices is that one or more mixer controls can be
> >> associated with an entity.  (This can be done with a field of the mixer
> >> control.)
> > 
> > Agreed.
> > 
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
> > 
> >> * Entity subtypes
> >> 
> >> EXT_JACK_ANALOG represents any analog audio and/or video connector.
> >> Properties for audio jacks would be jack type (TRS/RCA), color code,
> >> line level, position, etc.
> >> 
> >> EXT_JACK_DIGITAL represents a digital connector like S/PDIF (coax/
> >> TOSLINK), ADAT, TDIF, or MADI.
> >> 
> >> EXT_JACK_BUS represents a bus like FireWire and comes from the USB audio
> >> spec.  (I doubt that any devices with this entitiy will ever exist.)
> >> 
> >> EXT_INSTRUMENT represents something like an e-guitar, keyboard, or MIDI
> >> controller.  (Instrument entities are typically audio sources and MIDI
> >> sources and sinks, but can also be audio sinks.)
> >> 
> >> EXT_SPEAKER also includes headphones; there might be made a case for
> >> having those as a separate subtype.
> > 
> > Shouldn't headphones be represented by an EXT_JACK_ANALOG ?
> > 
> >> EXT_PLAYER represents a device like a CD/DVD/tape player.  Recorders can
> >> also write to that device, so "player" might not be an ideal name.
> >> 
> >> EXT_BROADCAST represents devices like TV tuners, satellite receivers,
> >> cable tuners, or radios.
> 
> I don't think it is right to talk about 'represents devices'. I'd rephrase
> it to 'connects to devices'.
> 
> > There's clearly an overlap with V4L here. Hopefully someone from the
> > linux-media list can comment on this.
> 
> I don't think this will be a problem. Initially we probably won't be
> enumerating connectors for V4L since it already has its own API for that.

My understanding is that EXT_BROADCAST really represents the TV tuners, ..., 
not the connector they connect to. Some (all ?) of them are definitely V4L2 
subdevs.

> >> INT_SYNTHESIZER converts MIDI to audio.
> >> 
> >> INT_NOISE_SOURCE comes from the USB audio spec; this is not an attempt
> >> to describe the characteristics of consumer-grade devices :-) , but
> >> represents an internal noise source for level calibration or
> >> measurements.
> >> 
> >> INT_CONTROLS may have multiple independent controls (this is USB's
> >> Feature Unit); INT_EFFECT may have multiple controls that affect one
> >> single algorithm.
> > 
> > I'd describe this as a feature unit/processing unit then.
> > 
> >> INT_CHANNEL_SPLIT/MERGE are needed for HDAudio devices, whose topology
> >> information has only stereo links.
> > 
> > Some of those INT entities could also be implemented in dedicated chips,
> > so I really think the EXT/INT split doesn't make too much sense. Should we
> > have an AUDIO category ?
> > 
> >> * Entity specifications
> >> 
> >> While TYPE_DEVICE entities can be identified by their device node, other
> >> entities typcially have just a numeric ID.
> > 
> > In V4L2 sub-devices have (or rather will have once the media controller
> > patches will be integrated) device nodes as well, so exposing that
> > information
> > is required.
> > 
> >> For that, it would be useful to make do without separate identification
> >> and let the driver choose the entity ID.
> > 
> > How would drivers do that ? What if you have two instances of the same
> > chip (a video sensor, audio mixer, ...) on the same board ?

-- 
Regards,

Laurent Pinchart
