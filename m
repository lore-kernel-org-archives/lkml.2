Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0K1Psq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 10:48:46 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:51301 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0K1Psn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 10:48:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC/PATCH v6 05/12] media: Reference count and power handling
Date: Sun, 28 Nov 2010 13:33:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <4CEEA191.1000706@maxwell.research.nokia.com> <20101125214633.GC25162@opensource.wolfsonmicro.com>
In-Reply-To: <20101125214633.GC25162@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011281333.39214.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thursday 25 November 2010 22:47:09 Mark Brown wrote:
> On Thu, Nov 25, 2010 at 07:49:05PM +0200, Sakari Ailus wrote:
> > Currently when two media entities are connected they will be powered up
> > for the duration of the link setup, just in case the drivers would need
> > to access hardware for some reason. I don't think we have a need for
> > that at the moment, it's so just because it seemed to be the right thing
> > to do.
> 
> This is *really* bad for audio, powering things on and off needlessly
> can cause audible effects for users.  If the individual drivers need to
> do something they can go and implement that but powering things up by
> default seems like it'll at best waste power most of the time.

The OMAP3 ISP driver required entities to be powered on when link attributes 
were modified, but that's not true anymore. We could remove this feature, or 
make it optional.

> > Essentially the idea is that the drivers do not need to be involved with
> > the power state handling and the device would be powered always when
> > they are run, but not be powered when it's not necessary.
> 
> This is what DAPM does in ASoC at the minute.  What it does is that
> every time there is a change in the device configuration which might
> have affected the power state it walks the graph of power nodes in the
> system.  If there has been a change in the state the core will generate
> a power transition sequence and apply it.  The devices have no knowledge
> of this (though they can insert manual sequences for nodes if they need
> to), for the most part they just describe the graph and the register
> bits that control the power for the nodes and the routing.
> 
> > Subdev is a V4L2 specific concept and I don't know if ALSA would benefit
> > from something similar. If you want to be able to access the individual
> > enties from user space, then similar arrangement might be useful.
> 
> ALSA already has this feature (at least in the embedded case, HDA has
> some of these features too).
> 
> > I don't see a problem in applying restrictions on power on / off
> > sequence. They would probably be useful also on the V4L2 side in the
> > future.
> > 
> > Could the restrictions be described as dependencies only, i.e. entity 1
> > power-up requires entity 2 to be powered first, also meaning that entity
> > 2 could be powered down only after entity 1 has been powered down?
> 
> No.  Audio power sequencing tends to work better if sorted by the type
> of object rather than the route (though using the route as a lower order
> sort key can be useful).  It's also useful to coalesce the I/O on the
> hardware for performance (both speed and user experience).
> 
> The way we're currently doing it the sequencing is actually separated
> from the graph walk - the result of the graph walk is a set of things
> that need doing which is then implemented in a separate step.  I think
> this would be the easiest way to integrate with what you're doing at the
> minute, keep the same split and then ASoC can do the postprocessing of
> the results of the graph walk in the same way as it does currently.

Throwing an idea here, what about making power management modular ? The MC 
core would then call back to drivers to handle use count changes. The 
media_entity_use_change() function would be exported (and renamed), so that 
drivers could use it if they want graph-based power management. ALSA would 
have its own use count handler.

-- 
Regards,

Laurent Pinchart
