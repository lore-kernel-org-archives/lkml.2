Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0KYJf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:35:58 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:44724 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab0KYJf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:35:56 -0500
Message-ID: <4CEE2E7D.6060608@ladisch.de>
Date: Thu, 25 Nov 2010 10:38:05 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, lennart@poettering.net
Subject: Re: [RFC/PATCH v6 03/12] [alsa-devel] media: Entities, pads and links
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290652099-15102-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1290652099-15102-4-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> A link is a point-to-point oriented connection between two pads, either
> on the same entity or on different entities. Data flows from a source
> pad to a sink pad.
> 
> Links are stored in the source entity.

In the descriptors of USB Audio and HDAudio devices, the links are
stored only in the sink.  But AFAICS this doesn't matter in the media
driver API.

> +Links have flags that describe the link capabilities and state.
> +
> +	MEDIA_LINK_FLAG_ACTIVE indicates that the link is active and can be
> +	used to transfer media data. When two or more links target a sink pad,
> +	only one of them can be active at a time.
> +	MEDIA_LINK_FLAG_IMMUTABLE indicates that the link active state can't
> +	be modified at runtime. If MEDIA_LINK_FLAG_IMMUTABLE is set, then
> +	MEDIA_LINK_FLAG_ACTIVE must also be set since an immutable link is
> +	always active.

So the intended userspace API for controlling routing is to change the
ACTIVE flag of links?

In USB and HD audio devices, all links are immutable, and the routing
is controlled by 'selector' entities that activate exactly one of their
input pads.  In userspace, this entity shows up as a mixer control.
I guess it would be possible to map the ACTIVE flag onto these controls.

Alternatively, entities can have 'mute' mixer controls associated with
their pads.  In this case, multiple unmuted inputs would be mixed
together.

> +#define MEDIA_ENTITY_TYPE_MASK               0x00ff0000
> +#define MEDIA_ENTITY_SUBTYPE_MASK            0x0000ffff
> +
> +#define MEDIA_ENTITY_TYPE_NODE               (1 << MEDIA_ENTITY_TYPE_SHIFT)
> ...
> +#define MEDIA_ENTITY_TYPE_NODE_ALSA          (MEDIA_ENTITY_TYPE_NODE + 3)

ALSA has PCM and MIDI devices, and several types of mixer controls.
(It also has hardware dependent and timer devices, but I don't think
these would need topology information.)  So we need at least these:
  MEDIA_ENTITY_TYPE_NODE_ALSA_PCM
  MEDIA_ENTITY_TYPE_NODE_ALSA_MIDI
  MEDIA_ENTITY_TYPE_SUBDEV_ALSA_CONTROL

Furthermore, topology information is also needed for entities not
associated with a mixer control, such as microphones, speakers, jacks/
connectors, and effect units.  These entities are defined in the USB and
HD audio specifications, but are not yet handled by ALSA.

> +struct media_entity {
> ...
> +	union {
> +		/* Node specifications */
> +		struct {
> +			u32 major;
> +			u32 minor;
> +		} v4l;
> +		struct {
> +			u32 major;
> +			u32 minor;
> +		} fb;
> +		int alsa;
> +		int dvb;
> +
> +		/* Sub-device specifications */
> +		/* Nothing needed yet */
> +	};

ALSA devices are not addressed by their device node but with card/device/
subdevice numbers; mixer controls have numeric IDs, unique per card:

		struct {
			int card;
			int device;
			int subdevice;
		} alsa_device;
		struct {
			int card;
			int numid;
		} alsa_control;


Regards,
Clemens
