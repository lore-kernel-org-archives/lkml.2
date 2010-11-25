Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0KYPV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:21:28 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:44904 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0KYPV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:21:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [RFC/PATCH v6 03/12] [alsa-devel] media: Entities, pads and links
Date: Thu, 25 Nov 2010 16:21:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290652099-15102-4-git-send-email-laurent.pinchart@ideasonboard.com> <4CEE2E7D.6060608@ladisch.de>
In-Reply-To: <4CEE2E7D.6060608@ladisch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011251621.38757.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens,

Thanks a lot for the review.

On Thursday 25 November 2010 10:38:05 Clemens Ladisch wrote:
> Laurent Pinchart wrote:
> > A link is a point-to-point oriented connection between two pads, either
> > on the same entity or on different entities. Data flows from a source
> > pad to a sink pad.
> > 
> > Links are stored in the source entity.
> 
> In the descriptors of USB Audio and HDAudio devices, the links are
> stored only in the sink.  But AFAICS this doesn't matter in the media
> driver API.

Same for USB Video (UVC). The reason for that is that UAC and UVC have only 1-
to-many connections (same for the media controller by the way), and it's 
easier to store that information in fixed-size structures if you store it in 
the sink entities.

On the kernel side, the media controller stores links in both source and sink 
entities for internal reasons. Links stored in the sink entity are called 
backlinks.

On the userspace side applications will only see "forward" links, stored in 
source entities. Applications will of course be free to store the links 
whereever they want in their internal data structures.

As you mentioned, I think it doesn't matter much anyway.

> > +Links have flags that describe the link capabilities and state.
> > +
> > +	MEDIA_LINK_FLAG_ACTIVE indicates that the link is active and can be
> > +	used to transfer media data. When two or more links target a sink pad,
> > +	only one of them can be active at a time.
> > +	MEDIA_LINK_FLAG_IMMUTABLE indicates that the link active state can't
> > +	be modified at runtime. If MEDIA_LINK_FLAG_IMMUTABLE is set, then
> > +	MEDIA_LINK_FLAG_ACTIVE must also be set since an immutable link is
> > +	always active.
> 
> So the intended userspace API for controlling routing is to change the
> ACTIVE flag of links?

That's correct.

> In USB and HD audio devices, all links are immutable, and the routing
> is controlled by 'selector' entities that activate exactly one of their
> input pads.  In userspace, this entity shows up as a mixer control.
> I guess it would be possible to map the ACTIVE flag onto these controls.

Same for UVC once again. It would be quite easy to map selector units to link 
activation, but it doesn't even have to be done. We could keep the selector 
units in the graph with all links immutable, and use the existing APIs to 
control the selector units.

The alternative would have been to add selector units to the media controller. 
I've thought about it, but we have embedded hardware (at least on the video 
side) that have configurable links without selector units. The media 
controller would have had to create fake selector units.

Between creating fake selector and translating link activation to selector 
unit commands, I've decided to go for the second solution, as this will make 
the graph simpler. Once again we can decide to keep explicit selector units in 
the graph for UVC, UAC and HD audio devices. That's one I've done in a test 
implementation of the media controller API in the uvcvideo driver.

> Alternatively, entities can have 'mute' mixer controls associated with
> their pads.  In this case, multiple unmuted inputs would be mixed
> together.

I don't see any problem keeping those.

> > +#define MEDIA_ENTITY_TYPE_MASK               0x00ff0000
> > +#define MEDIA_ENTITY_SUBTYPE_MASK            0x0000ffff
> > +
> > +#define MEDIA_ENTITY_TYPE_NODE               (1 <<
> > MEDIA_ENTITY_TYPE_SHIFT) ...
> > +#define MEDIA_ENTITY_TYPE_NODE_ALSA          (MEDIA_ENTITY_TYPE_NODE +
> > 3)
> 
> ALSA has PCM and MIDI devices, and several types of mixer controls.
> (It also has hardware dependent and timer devices, but I don't think
> these would need topology information.)  So we need at least these:
>   MEDIA_ENTITY_TYPE_NODE_ALSA_PCM
>   MEDIA_ENTITY_TYPE_NODE_ALSA_MIDI
>   MEDIA_ENTITY_TYPE_SUBDEV_ALSA_CONTROL

I agree about PCM and MIDI, but I'm not sure about controls. If controls are 
part of an entity, the entity will be reported through the media controller 
API. If information about that entity can be queried through existing APIs 
(ALSA, V4L, ...) those APIs should be used. For instance, on the V4L side, 
V4L2 sub-devices are mapped to entities and also have a device node which can 
be used to enumerate the controls supported by the subdev. The media 
controller only reports the entity -> major:minor mapping to let applications 
find the device and query it directly.

I think we will need a new ioctl in the media controller API to report 
advanced information about an entity. This could be used to report controls 
implemented by an ALSA element if ALSA doesn't provide a way to do that 
directly. Another use case, which make me think that such an ioctl would be 
needed, is to report UVC extension units type (16-byte GUID) to userspace.

> Furthermore, topology information is also needed for entities not
> associated with a mixer control, such as microphones, speakers, jacks/
> connectors, and effect units.  These entities are defined in the USB and
> HD audio specifications, but are not yet handled by ALSA.

Agreed, we will need to add new entity types and subtypes for those. The 
reason they're not part of this submission is that I wanted real use cases 
instead of coming up with a made-up list of entities I think would be useful.

> > +struct media_entity {
> > ...
> > +	union {
> > +		/* Node specifications */
> > +		struct {
> > +			u32 major;
> > +			u32 minor;
> > +		} v4l;
> > +		struct {
> > +			u32 major;
> > +			u32 minor;
> > +		} fb;
> > +		int alsa;
> > +		int dvb;
> > +
> > +		/* Sub-device specifications */
> > +		/* Nothing needed yet */
> > +	};
> 
> ALSA devices are not addressed by their device node but with card/device/
> subdevice numbers; mixer controls have numeric IDs, unique per card:
> 
> 		struct {
> 			int card;
> 			int device;
> 			int subdevice;
> 		} alsa_device;

I will use this instead of 'int alsa'. Thanks a lot for the useful feedback.

> 		struct {
> 			int card;
> 			int numid;
> 		} alsa_control;

Regarding controls, let's first see how they should be reported by userspace, 
as explained above.

-- 
Regards,

Laurent Pinchart
