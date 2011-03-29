Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1C2VUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:20:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46140 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752809Ab1C2VUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:20:02 -0400
Date: Wed, 30 Mar 2011 06:20:11 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regulator: Propagate uA_load requirements up
 supply chain
Message-ID: <20110329212010.GA30482@opensource.wolfsonmicro.com>
References: <1301356355-7546-1-git-send-email-collinsd@codeaurora.org>
 <1301356432-7586-2-git-send-email-collinsd@codeaurora.org>
 <20110329084458.GD29330@opensource.wolfsonmicro.com>
 <4D9203EF.4060303@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9203EF.4060303@codeaurora.org>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 09:08:15AM -0700, David Collins wrote:

> I agree that it would be beneficial to change regulator_dev.supply from
> type struct regulator_dev * to type struct regulator *.  However, I think
> that going that route will be a major undertaking with a lot of details to

Hrm, it doesn't look too bad - as far as I can see it should just be
fairly direct refactorings of each of get, put, enable and disable?

> work out and more room for deadlocking scenarios to get introduced.  Who
> would be responsible for making such a change?

I don't know, but I don't think we should make their life more difficult
by adding additional complexity that then needs to be unpicked.  I might
look into this (it's been bugging me for a while), no idea when but if
people are actively working with supplies that obviously helps.

> > The other issue here is that I'm concerned about the direction this
> > appears to be heading given that it seems like in order for this to do
> > something useful we'd need to start supplying current drain information
> > from consumers.  We're not doing that at the minute and I'm not terribly
> > optimistic that we'd ever get enough useful information to make it
> > generally worthwhile.

> The regulator framework does have a mechanism for consumers to specify
> their current drain information: regulator_set_optimum_mode.  Systems that
> do not wish to take advantage of the current propagation API are under no
> obligation to use it.

It's true that there's some code for this, but it's also true that there
are no actual users of the code and only a very few drivers (mostly
written by me) that implement the required bits on the driver side.
This API has been there since the regulator API was merged and has still
not been picked up by any users.  To a large extent I think this is
because it is difficult to deploy effectively.

I'd also not say that there's no impact on systems not using it - any
consumer that needs to participate in the current management will need
to have support for telling the core about what it's using.  The actual
numbers there are going to be dependant on a range of per-system
factors, including supply voltages, workloads, hardware configuration,
different software compatible silicon and the ability of the supplies to
cope with brief load transients.  Providing that information is not a
trivial requirement, it's a very wide ranging one with an impact on any
device that uses power.

> The system that I am working with utilizes a PMIC containing 8 switching
> regulators (SMPS) and 26 LDO regulators.  Many of the LDO's are
> subregulated from the SMPS's.  The system state at the beginning of boot
> will have all non-essential regulators disabled and in low power mode (LPM
> signified with REGULATOR_MODE_STANDBY).  Consumer drivers will then be
> responsible for setting up the regulators that their peripheral devices
> require.  Most of the LDO regulators have a LPM threshold of 10mA and high

This is very different to the normal usage model for the regulator API -
you'd not expect every single consumer driver on the board to have to be
involved in specifying the load they're drawing as actual current
numbers and you'll also need to take into account things that draw
current without having a driver.  The idea is that there should be very
little impact on most devices that aren't actively managing their
supplies by doing things like changing voltages at runtime, most
regulator configuration should be done for them by the board.

> power mode (HPM signified with REGULATOR_MODE_FAST) threshold of 50-1200mA

You should be using _NORMAL for this mode, that just sounds like a
regular LDO.  _FAST is intended for use on older DCDCs which have modes
where they can respond particularly quickly to dramatic changes in load
at the expense of some overhead on lower loads (modern regulators are
able to just cope with this and don't need any software control here,
though they often still provide it just in case some workload requires
it).  _NORMAL is just the vanilla mode which you should use if you've
not got any particular requirements.

> depending upon type.  Thus, consumers will need to call
> regulator_set_optimum_mode with their peak load current in order to change
> their supply regulator from LPM to HPM.  It is also worth noting that many

This is the thing I was saying about all the consumer drivers needing to
get involved.  

> One could solve this problem by using HPM at all times, but there is a
> design requirement that system use the smallest amount of power possible.
>  Do you have thoughts about a different solution?

In principle if we could get the information about the consumption of
the consumers reliably and accurately supplied this would work well but
that first step is the issue.  It doesn't seem terribly realistic, and
if you've got some consumers in play which aren't taking part the wheels
will start to come off the system.  I think we'll run into lots of
implementation issues if we try to do things this way and that it'll be
very fragile, especially with consumer devices that are used on many
different platforms.

I expect that if you look at the majority of consumer drivers you've got
they'll have at most one or two loads documented, probably a normal
operation mode and an idle mode.  I think this is the sort of
information that we could realistically get from drivers and we can then
do the mapping into actual numbers in the machine driver, adding more
data to the supply mapping.  This degrades much better than having all
consumers specify actual numbers at all times as it means you can get
basic operation with no involvement whatsoever from most of the drivers,
and we could also hook in with disabling the regulators so that we go
into the idle mode when the consumer disables.

Does the above map onto what your system is doing?  If we can come up
with a higher level external API such as this which abstracts away the
numbers from consumers then the problem becomes a lot more tractable and
reasonable to deploy system wide.
