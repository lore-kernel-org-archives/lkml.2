Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab0LNMAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:00:06 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:36560 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab0LNMAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:00:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [alsa-devel] [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Tue, 14 Dec 2010 13:00:56 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3; KDE/4.5.3; x86_64; ; )
Cc: alsa-devel@alsa-project.org, sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <4CEF799E.7060508@ladisch.de> <4D06458B.6080808@ladisch.de>
In-Reply-To: <4D06458B.6080808@ladisch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012141300.57118.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens,

On Monday 13 December 2010 17:10:51 Clemens Ladisch wrote:
> I wrote:
> > I'll see if I can draw up the ALSA-specific media stuff over the weekend.
> 
> Sorry, wrong weekend.
> 
> Anyway, below are some remarks and a patch.

Thank you. Please see my comments inline.

> * Entity types
> 
> TYPE_NODE was renamed to TYPE_DEVICE because "node" sounds like a node
> in a graph, which does not distinguish it from other entity types
> because all entities are part of the topology graph.  I chose "device"
> as this type describes entities that are visible as some device node to
> other software.

What this type describes is a device node. Both NODE and DEVICE can be 
confusing in my opinion, but DEVICE_NODE is a bit long.

> TYPE_EXT describes entities that represent some interface to the
> external world, TYPE_INT those that are internal to the entire device.
> (I'm not sure if that distinction is very useful, but TYPE_SUBDEV seems
> to be an even more meaningless name.)

SUBDEV comes from the V4L2 world, and I agree that it might not be a very good 
name.

I'm not sure I would split entities in internal/external categories. I would 
create a category for connectors though.

> ALSA mixer controls are not directly represented; a better fit for the
> architecture of actual devices is that one or more mixer controls can be
> associated with an entity.  (This can be done with a field of the mixer
> control.)

Agreed.

> * Entity properties
> 
> There needs to be a mechanism to associate meta-information (properties)
> with entities.  This information should be optional and extensible, but,
> when being handled inside the kernel, doesn't need to be more than
> a read-only blob.  I think that something like ALSA's TLV format (used
> for mixer controls) can be used here.  (I'm not mentioning the X-word
> here, except to note that the "M" stands for "markup".)

I've been thinking of adding a new ioctl for that. It's something we need to 
draft. The UVC driver will need it, and I'm pretty sure other V4L2 drivers 
would find it useful as well.

> * Entity subtypes
> 
> EXT_JACK_ANALOG represents any analog audio and/or video connector.
> Properties for audio jacks would be jack type (TRS/RCA), color code,
> line level, position, etc.
> 
> EXT_JACK_DIGITAL represents a digital connector like S/PDIF (coax/
> TOSLINK), ADAT, TDIF, or MADI.
> 
> EXT_JACK_BUS represents a bus like FireWire and comes from the USB audio
> spec.  (I doubt that any devices with this entitiy will ever exist.)
> 
> EXT_INSTRUMENT represents something like an e-guitar, keyboard, or MIDI
> controller.  (Instrument entities are typically audio sources and MIDI
> sources and sinks, but can also be audio sinks.)
> 
> EXT_SPEAKER also includes headphones; there might be made a case for
> having those as a separate subtype.

Shouldn't headphones be represented by an EXT_JACK_ANALOG ?

> EXT_PLAYER represents a device like a CD/DVD/tape player.  Recorders can
> also write to that device, so "player" might not be an ideal name.
> 
> EXT_BROADCAST represents devices like TV tuners, satellite receivers,
> cable tuners, or radios.

There's clearly an overlap with V4L here. Hopefully someone from the linux-
media list can comment on this.

> INT_SYNTHESIZER converts MIDI to audio.
> 
> INT_NOISE_SOURCE comes from the USB audio spec; this is not an attempt
> to describe the characteristics of consumer-grade devices :-) , but
> represents an internal noise source for level calibration or measurements.
> 
> INT_CONTROLS may have multiple independent controls (this is USB's
> Feature Unit); INT_EFFECT may have multiple controls that affect one
> single algorithm.

I'd describe this as a feature unit/processing unit then.

> INT_CHANNEL_SPLIT/MERGE are needed for HDAudio devices, whose topology
> information has only stereo links.

Some of those INT entities could also be implemented in dedicated chips, so I 
really think the EXT/INT split doesn't make too much sense. Should we have an 
AUDIO category ?

> * Entity specifications
> 
> While TYPE_DEVICE entities can be identified by their device node, other
> entities typcially have just a numeric ID.

In V4L2 sub-devices have (or rather will have once the media controller 
patches will be integrated) device nodes as well, so exposing that information 
is required.

> For that, it would be useful to make do without separate identification and
> let the driver choose the entity ID.

How would drivers do that ? What if you have two instances of the same chip (a 
video sensor, audio mixer, ...) on the same board ?

> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> 
> --- linux/include/linux/media.h
> +++ linux/include/linux/media.h
> @@ -46,16 +46,36 @@ struct media_device_info {
>  #define MEDIA_ENTITY_TYPE_MASK			0x00ff0000
>  #define MEDIA_ENTITY_SUBTYPE_MASK		0x0000ffff
> 
> -#define MEDIA_ENTITY_TYPE_NODE			(1 << MEDIA_ENTITY_TYPE_SHIFT)
> -#define MEDIA_ENTITY_TYPE_NODE_V4L		(MEDIA_ENTITY_TYPE_NODE + 1)
> -#define MEDIA_ENTITY_TYPE_NODE_FB		(MEDIA_ENTITY_TYPE_NODE + 2)
> -#define MEDIA_ENTITY_TYPE_NODE_ALSA		(MEDIA_ENTITY_TYPE_NODE + 3)
> -#define MEDIA_ENTITY_TYPE_NODE_DVB		(MEDIA_ENTITY_TYPE_NODE + 4)
> +#define MEDIA_ENTITY_TYPE_DEVICE		(1 << MEDIA_ENTITY_TYPE_SHIFT)
> +#define MEDIA_ENTITY_TYPE_DEVICE_V4L		(MEDIA_ENTITY_TYPE_DEVICE + 1)
> +#define MEDIA_ENTITY_TYPE_DEVICE_FB		(MEDIA_ENTITY_TYPE_DEVICE + 2)
> +#define MEDIA_ENTITY_TYPE_DEVICE_DVB		(MEDIA_ENTITY_TYPE_DEVICE + 3)
> +#define MEDIA_ENTITY_TYPE_DEVICE_ALSA_PCM	(MEDIA_ENTITY_TYPE_DEVICE + 4)
> +#define MEDIA_ENTITY_TYPE_DEVICE_ALSA_MIDI	(MEDIA_ENTITY_TYPE_DEVICE + 5)
> 
> -#define MEDIA_ENTITY_TYPE_SUBDEV		(2 << MEDIA_ENTITY_TYPE_SHIFT)
> -#define MEDIA_ENTITY_TYPE_SUBDEV_SENSOR		(MEDIA_ENTITY_TYPE_SUBDEV + 1)
> -#define MEDIA_ENTITY_TYPE_SUBDEV_FLASH		(MEDIA_ENTITY_TYPE_SUBDEV + 2)
> -#define MEDIA_ENTITY_TYPE_SUBDEV_LENS		(MEDIA_ENTITY_TYPE_SUBDEV + 3)
> +#define MEDIA_ENTITY_TYPE_EXT			(2 << MEDIA_ENTITY_TYPE_SHIFT)
> +#define MEDIA_ENTITY_TYPE_EXT_SENSOR		(MEDIA_ENTITY_TYPE_EXT + 1)
> +#define MEDIA_ENTITY_TYPE_EXT_FLASH		(MEDIA_ENTITY_TYPE_EXT + 2)
> +#define MEDIA_ENTITY_TYPE_EXT_LENS		(MEDIA_ENTITY_TYPE_EXT + 3)
> +#define MEDIA_ENTITY_TYPE_EXT_JACK_MIDI		(MEDIA_ENTITY_TYPE_EXT + 4)
> +#define MEDIA_ENTITY_TYPE_EXT_JACK_ANALOG	(MEDIA_ENTITY_TYPE_EXT + 5)
> +#define MEDIA_ENTITY_TYPE_EXT_JACK_DIGITAL	(MEDIA_ENTITY_TYPE_EXT + 6)
> +#define MEDIA_ENTITY_TYPE_EXT_JACK_BUS		(MEDIA_ENTITY_TYPE_EXT + 7)
> +#define MEDIA_ENTITY_TYPE_EXT_INSTRUMENT	(MEDIA_ENTITY_TYPE_EXT + 8)
> +#define MEDIA_ENTITY_TYPE_EXT_SPEAKER		(MEDIA_ENTITY_TYPE_EXT + 9)
> +#define MEDIA_ENTITY_TYPE_EXT_MICROPHONE	(MEDIA_ENTITY_TYPE_EXT + 10)
> +#define MEDIA_ENTITY_TYPE_EXT_PLAYER		(MEDIA_ENTITY_TYPE_EXT + 11)
> +#define MEDIA_ENTITY_TYPE_EXT_BROADCAST		(MEDIA_ENTITY_TYPE_EXT + 12)
> +
> +#define MEDIA_ENTITY_TYPE_INT			(3 << MEDIA_ENTITY_TYPE_SHIFT)
> +#define MEDIA_ENTITY_TYPE_INT_SYNTHESIZER	(MEDIA_ENTITY_TYPE_INT + 1)
> +#define MEDIA_ENTITY_TYPE_INT_NOISE_SOURCE	(MEDIA_ENTITY_TYPE_INT + 2)
> +#define MEDIA_ENTITY_TYPE_INT_MIXER		(MEDIA_ENTITY_TYPE_INT + 3)
> +#define MEDIA_ENTITY_TYPE_INT_SELECTOR		(MEDIA_ENTITY_TYPE_INT + 4)
> +#define MEDIA_ENTITY_TYPE_INT_CONTROLS		(MEDIA_ENTITY_TYPE_INT + 5)
> +#define MEDIA_ENTITY_TYPE_INT_EFFECT		(MEDIA_ENTITY_TYPE_INT + 6)
> +#define MEDIA_ENTITY_TYPE_INT_CHANNEL_SPLIT	(MEDIA_ENTITY_TYPE_INT + 7)
> +#define MEDIA_ENTITY_TYPE_INT_CHANNEL_MERGE	(MEDIA_ENTITY_TYPE_INT + 8)
> 
>  #define MEDIA_ENTITY_FLAG_DEFAULT		(1 << 0)
> 
> @@ -72,7 +92,7 @@ struct media_entity_desc {
>  	__u32 reserved[4];
> 
>  	union {
> -		/* Node specifications */
> +		/* Device specifications */
>  		struct {
>  			__u32 major;
>  			__u32 minor;
> @@ -81,11 +101,15 @@ struct media_entity_desc {
>  			__u32 major;
>  			__u32 minor;
>  		} fb;
> -		int alsa;
> +		struct {
> +			__u32 card;
> +			__u32 device;
> +			__s32 subdevice;
> +		} alsa;

I will already incorporate this change, and I'll wait for other opinions on 
the types before changing them.

>  		int dvb;
> 
>  		/* Sub-device specifications */
>  		/* Nothing needed yet */
>  		__u8 raw[184];
>  	};
>  };

-- 
Regards,

Laurent Pinchart
