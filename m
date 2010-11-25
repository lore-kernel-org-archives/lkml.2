Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0KYRtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:49:14 -0500
Received: from smtp.nokia.com ([147.243.1.47]:20586 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab0KYRtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:49:12 -0500
Message-ID: <4CEEA191.1000706@maxwell.research.nokia.com>
Date: Thu, 25 Nov 2010 19:49:05 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        lennart@poettering.net
Subject: Re: [RFC/PATCH v6 05/12] media: Reference count and power handling
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290652099-15102-6-git-send-email-laurent.pinchart@ideasonboard.com> <20101125134908.GC24208@opensource.wolfsonmicro.com> <201011251643.17313.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011251643.17313.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> Hi Mark,

Hi Laurent, others,

> On Thursday 25 November 2010 14:49:08 Mark Brown wrote:
>> On Thu, Nov 25, 2010 at 03:28:12AM +0100, Laurent Pinchart wrote:
>>> 	If the entity is of node type, the power change is distributed to
>>> 	all connected entities. For non-nodes it only affects that very
>>> 	node. A mutex is used to serialise access to the entity graph.
>>
>> ASoC has its own power management stuff which doesn't *quite* map onto
>> this one as-is.  The power determination stuff is essentially identical
>> (and this is actually nicer) but we have a separate postprocessing stage
>> that actually applies the changes in a sequence which minimises audible
>> issues caused by doing things in a bad order (eg, power down a PGA
>> before you turn off inputs).  This is noddy enough to implement, though
>> - we just need a pre and post run notifications to set up and implement
>> the changes I think.
> 
> That sounds feasible. Sakari, you've implemented power management, what do you 
> think about this ?

I first have to admit that I don't know ALSA almost at all.

Currently when two media entities are connected they will be powered up
for the duration of the link setup, just in case the drivers would need
to access hardware for some reason. I don't think we have a need for
that at the moment, it's so just because it seemed to be the right thing
to do.

Essentially the idea is that the drivers do not need to be involved with
the power state handling and the device would be powered always when
they are run, but not be powered when it's not necessary.

That feature put aside, then what's left is what Laurent described; the
entities will be powered up based on opening subdev and video nodes
(V4L2 case, for ALSA it'd be different kind of ALSA nodes). But I don't
think there's necessarily even need to remove this feature.

Subdev is a V4L2 specific concept and I don't know if ALSA would benefit
from something similar. If you want to be able to access the individual
enties from user space, then similar arrangement might be useful.

There are use cases to only use subdev nodes on V4L2: camera LED flash
in torch mode, for example. There is no need to power on the rest of the
system.

I don't see a problem in applying restrictions on power on / off
sequence. They would probably be useful also on the V4L2 side in the future.


Could the restrictions be described as dependencies only, i.e. entity 1
power-up requires entity 2 to be powered first, also meaning that entity
2 could be powered down only after entity 1 has been powered down?

This type of restrictions would fit quite well to the current model as
it would essentially mean just media_entity_get() for the dependent
entities, and media_entity_put() when the original entity is powered
down. This would work recursively.

In the case of audio, most if not all devices (right?) would be always
powered up in certain order. At the same time this would be good for the
flash in torch mode case.


Comments, opinions? :-)


Best regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
