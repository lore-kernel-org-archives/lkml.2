Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab1GDXZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 19:25:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40950 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1GDXZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 19:25:14 -0400
Date: Mon, 4 Jul 2011 17:25:09 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20110704232509.GA12824@ponder.secretlab.ca>
References: <20110704170949.11059.92774.stgit@ponder>
 <20110704204717.GE32624@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704204717.GE32624@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 01:47:18PM -0700, Mark Brown wrote:
> On Mon, Jul 04, 2011 at 11:11:59AM -0600, Grant Likely wrote:
> 
> > Mark, I'm particularly interested in your thoughts on this approach.
> > It is decidedly "low-tech" in its approach to handling device
> > dependencies, but it has the advantage of being simple and should
> > handle a wide range of use-cases reliably.  Would this work for ALSA
> > SoC probing?
> 
> It's essentially what we're doing currently for the part of the system
> where we decide that everything is registered and we should run the
> actual probe functions so it'll help with that.  Having a clock API we
> can actually use off-SoC will help with a lot of the remaining stuff.

Is that the bit that snd_soc_instantiate_cards() is doing?  If I made 
snd_soc_register_card() attempt to instantiate immediately and return
-EAGAIN if resources were not available, it looks like I should be
able to remove the card_list entirely.  Would that be the right way to
go about it?

> I *think* we'll still going to need to have the infrastructure to deal
> with running all the probes together, at least for a while, as the
> current code really assumes that it's got some of the card wide stuff
> around when all the devices get instantiated but I think if we were
> starting from fresh this would be fairly good.

I'm not sure what you're getting at here.  Are you talking about the
infrastructure to keep track of codecs, DAIs and the like?  Yes, that
infrastructure is still needed because the drivers need an api for
each of the kinds of resources it needs.

> The only thing I can
> think might be an issue is n way dependencies, but those mostly shake
> out as being a dependency of the overall card on subdevices.  I'd need
> to separate out the implementation issues from the assumptions to be
> 100% clear if that was the case, though.

Do you have an example?  I don't see any problems with complex
dependencies providing that none of them are circular.  If, say,
device A depends on B and C, and B also depends on C, then it may take
a couple of cycles before everything gets probed, but it all still
works correctly.

g.

