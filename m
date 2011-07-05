Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab1GEGMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 02:12:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41596 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753590Ab1GEGL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 02:11:58 -0400
Date: Mon, 4 Jul 2011 23:11:54 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20110705061153.GA1625@opensource.wolfsonmicro.com>
References: <20110704170949.11059.92774.stgit@ponder>
 <20110704204717.GE32624@opensource.wolfsonmicro.com>
 <20110704232509.GA12824@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704232509.GA12824@ponder.secretlab.ca>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 05:25:09PM -0600, Grant Likely wrote:
> On Mon, Jul 04, 2011 at 01:47:18PM -0700, Mark Brown wrote:

> > where we decide that everything is registered and we should run the
> > actual probe functions so it'll help with that.  Having a clock API we
> > can actually use off-SoC will help with a lot of the remaining stuff.

> Is that the bit that snd_soc_instantiate_cards() is doing?  If I made 
> snd_soc_register_card() attempt to instantiate immediately and return
> -EAGAIN if resources were not available, it looks like I should be
> able to remove the card_list entirely.  Would that be the right way to
> go about it?

That's exactly what I'd expect to do, yes.

> > I *think* we'll still going to need to have the infrastructure to deal
> > with running all the probes together, at least for a while, as the
> > current code really assumes that it's got some of the card wide stuff
> > around when all the devices get instantiated but I think if we were
> > starting from fresh this would be fairly good.

> I'm not sure what you're getting at here.  Are you talking about the
> infrastructure to keep track of codecs, DAIs and the like?  Yes, that
> infrastructure is still needed because the drivers need an api for
> each of the kinds of resources it needs.

Sort of, but I'm more thinking of the fact that we currently defer all
the "real" probes until the full card is ready - ideally these could all
be done as part of the device model probe, but this is something we can
improve over time rather than a critical thing.  The regmap API will
help here.

> > The only thing I can
> > think might be an issue is n way dependencies, but those mostly shake
> > out as being a dependency of the overall card on subdevices.  I'd need
> > to separate out the implementation issues from the assumptions to be
> > 100% clear if that was the case, though.

> Do you have an example?  I don't see any problems with complex
> dependencies providing that none of them are circular.  If, say,
> device A depends on B and C, and B also depends on C, then it may take
> a couple of cycles before everything gets probed, but it all still
> works correctly.

It's circular dependencies that worry me.  I don't have any concrete
examples in mainline now but I'm aware of systems that are more
complicated than mainline.  Things like clock trees that go out of one
device, into another, and back into to the first.  Like I say I think
these all shake out as simple dependencies of component devices on the
card so it's probably not a problem.
