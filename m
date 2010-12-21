Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0LUQt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:49:56 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2322 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0LUQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:49:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [alsa-devel] [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Tue, 21 Dec 2010 17:49:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-23-generic; KDE/4.4.5; x86_64; ; )
Cc: Clemens Ladisch <clemens@ladisch.de>, alsa-devel@alsa-project.org,
        sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <4D0775DB.2020902@ladisch.de> <201012150050.44885.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012150050.44885.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012211749.22393.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 15, 2010 00:50:44 Laurent Pinchart wrote:
> Hi Clemens,
> 
> On Tuesday 14 December 2010 14:49:15 Clemens Ladisch wrote:
> > Laurent Pinchart wrote:
> > > On Tuesday 14 December 2010 13:40:21 Hans Verkuil wrote:
> > >> > On Monday 13 December 2010 17:10:51 Clemens Ladisch wrote:
> > >> >> * Entity types
> > >> >> 
> > >> >> TYPE_NODE was renamed to TYPE_DEVICE because "node" sounds like a
> > >> >> node in a graph, which does not distinguish it from other entity
> > >> >> types because all entities are part of the topology graph.  I chose
> > >> >> "device" as this type describes entities that are visible as some
> > >> >> device node to other software.
> > >> > 
> > >> > What this type describes is a device node. Both NODE and DEVICE can be
> > >> > confusing in my opinion, but DEVICE_NODE is a bit long.
> > >> 
> > >> What about DEVNODE? I think that would be a good alternative.
> > > 
> > > Fine with me. Clemens, any opinion on that ?
> > 
> > Fine with me too.
> 
> OK I'll use that name.
> 
> > > > >> TYPE_EXT describes entities that represent some interface to the
> > > > >> external world, TYPE_INT those that are internal to the entire
> > > > >> device. (I'm not sure if that distinction is very useful, but
> > > > >> TYPE_SUBDEV seems to be an even more meaningless name.)
> > > > > 
> > > > > SUBDEV comes from the V4L2 world, and I agree that it might not be a
> > > > > very good name.
> > > > 
> > > > SUBDEV refers to a specific type of driver. Within the v4l world it is
> > > > well defined. So I prefer to keep this. Perhaps some additional
> > > > comments or documentation can be added to clarify this.
> > > 
> > > Should this be clarified by using V4L2_SUBDEV instead then ?
> > 
> > If the "SUBDEV" concept doesn't exist outside V4L, that would indeed be
> > better.
> > 
> > I don't want to rename things that come out of existing frameworks; this
> > naming discussion makes sense only for those entity (sub)types that can
> > be shared between them.  Are there any, besides jacks?
> 
> Some entities like TV tuners play a dual audio/video role. I'm not sure how to 
> handle them, I lack experience in that field.

It is very important to distinguish between the actual tuner device and the
physical connector. ALSA doesn't program a tuner device, that's the domain
of V4L and DVB. ALSA just sees an input pin.

Regarding tuners there are roughly two types of hardware: one where the audio
goes to an output jack (and the user has to use a loopback cable to hook it up
to an audio input), or it goes to memory using DMA and an ALSA driver.

In the first scenario the MC would model a TV_ANTENNA connector and an AUDIO_OUT
connector. The TV_ANTENNA connector would typically link to a V4L2_SUBDEV_TUNER,
which would link to a V4L2_SUBDEV_AUDIO_DEMOD (in turn linked to the AUDIO_OUT
connector). The tuner would also link to a V4L2_SUBDEV_VIDEO_DIGITIZER (in turn
linked to a DEVNODE_V4L).

In the second scenario there is no AUDIO_OUT connector, instead there is a
DEVNODE_ALSA.

It can get more complex: in the case of MPEG encoders the audio from the tuner
goes to an audio demod, the video goes to a digitizer, and the output of those
subdevs both go into the same MPEG encoder subdev.

When modeling hardware like audio or video devices it is important to remember
to separate I/O pins from actually physical connectors. E.g. an audio device may
have many possible input pins, but how they are hooked up to which physical
connectors is something that is board specific and not part of the audio driver
itself.

Anyway, what we need is a 'connector' entity. And just like the other entities,
connectors can have multiple input pads so I don't see any problems in modeling
antenna connectors.

Regards,

	Hans

> > > What about ALSA entities, should they use MEDIA_ENTITY_TYPE_ALSA_* ?
> > 
> > The entity types representing ALSA devices are already named "ALSA".
> 
> I was talking about the INT_* types. They're ALSA-specific, but have no ALSA 
> in the type name.
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
