Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1KDWQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:16:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44723 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab1KDWQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:16:13 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20111104214650.GC8266@opensource.wolfsonmicro.com>
References: <1319721864-30067-1-git-send-email-rnayak@ti.com>
	<20111104202905.GA3918@quad.lixom.net>
	<20111104211447.GC2541@opensource.wolfsonmicro.com>
	<20111104212216.GA5756@quad.lixom.net>
	<20111104212910.GB8266@opensource.wolfsonmicro.com>
	<CAOesGMgA7UayF9SJUP0YLnj86GmKBrajsBxv4_kRNNqCsvKTYg@mail.gmail.com>
	<20111104214650.GC8266@opensource.wolfsonmicro.com>
Date: Fri, 4 Nov 2011 15:16:12 -0700
Message-ID: <CAOesGMjkcExKXhNN1nFGey=wBie0PQGp2XS_r-5Rr3X0p4eNhg@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] regulator: helper routine to extract regulator_init_data
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 2:46 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Nov 04, 2011 at 02:34:35PM -0700, Olof Johansson wrote:
>> On Fri, Nov 4, 2011 at 2:29 PM, Mark Brown
>
>> > I think it's useful to define how consumers are supposed to do this
>> > somewhere - it is actually part of the core binding how consumers are
>> > supposed to do this.
>
>> Yeah, ok, but it shouldn't be part of the description of regulator
>> properties per se. See how gpio does it, defining how a gpio-specifier
>> is crafted. The equivalent should be done for regulators.
>
> That seems to be pretty much exactly what's being done here, and like
> the GPIO bindings it's specified in the core document.  Though perhaps
> there's some aspect of how the document is written that's missing.

Yep, sounds good. A slightly more elaborate description of the binding
inspired by the gpio.txt document would be the way to do that.

> If you're talking about the specifics of the binding the GPIO bindings
> do suffer from the whole magic indexes into arrays problem that makes a
> lot of the older device tree bindings quite hard to read.

I wasn't talking about that in this case, but that is unfortunate and
I do agree that the ordered array of gpios is messy and hard to
follow.

I've been trying to catch those as they are introduced -- i.e. we
moved away from the magic array-of-three-gpios to discrete properties
on the sdhci binding for tegra, for example. We'll keep an eye on the
same for regulators.

>> > There's also a bit of magic here for chained supplies with one regulator
>> > supplying another (eg, using a DCDC to drop the system supply down to a
>> > lower voltage to supply a bunch of LDOs for improved efficiency).
>
>> Describing that in the device tree using regulator-specifiers
>> shouldn't be too bad? The LDO will reference the DCDC as the parent
>> supply (or input or whatever language you prefer). They don't have to
>> be in the same topology, they will instead be under whatever
>> controller/bus they are on for control -- i2c, etc.
>
> That's not great as it means you've got a separate binding for supplies
> that happen to be connected to another regulator from that used for
> other supplies on the device which is particularly confusing in the
> fairly common case where a regulator chip has multiple supplies.  Using
> the same method for binding all supplies seems much neater.

I'm not following the above 100%, but I think you are saying that you
would prefer to describe the regulator / power hierarchy in the
functional topology instead of how the various regulators and supplies
are organized on i2c busses and other controllers?  And the obvious
one that would be less than trivial to find a home for would be the
top-level or freestanding fixed regulators that don't sit on a
controlling bus.

If that is the case then this is yet another case of where we have a
couple of different structures that are overlaid on each other in the
device tree. Another is/will be clocking.

That should be OK, since you can have a binding for your PMIC that
splits up the various rails in separate subnodes, where each can
specify a reference to the upstream supply for that rail, etc. Would
that work?

Finding a best-practices location for where to put the fixed
regulators that don't sit on a controlling bus would be the trickiest
part, and I suppose we will just have to make up a location for those
(/power-supplies or something).  But various regulators will need to
be spread around the device tree a bit, in particular the i2c vs gpio
controlled ones will need to sit on their controlling busses.


-Olof
