Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab0E0AfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 20:35:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55108 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754478Ab0E0AfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 20:35:11 -0400
Date: Wed, 26 May 2010 17:07:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar R IYER <sundar.iyer@stericsson.com>
Cc: Sundar <sunder.svit@gmail.com>, Viresh KUMAR <viresh.kumar@st.com>,
       Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       Armando VISCONTI <armando.visconti@st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Power Domain Framework
Message-ID: <20100526210728.GB19188@opensource.wolfsonmicro.com>
References: <1274115886.2698.22.camel@finisterre.wolfsonmicro.main>
 <1274118332.17303.17.camel@bnru01>
 <CEE6BB42CAD6E947908279175AF8470A025A726240@EXDCVYMBSTM006.EQ1STM.local>
 <1274131108.2698.161.camel@finisterre.wolfsonmicro.main>
 <CEE6BB42CAD6E947908279175AF8470A025A72624A@EXDCVYMBSTM006.EQ1STM.local>
 <1274134636.2698.170.camel@finisterre.wolfsonmicro.main>
 <1274162450.17303.35.camel@bnru01>
 <AANLkTinTdTp_X4lGtZ0hCaVJN5GmvI0tXR1RTRkRNkjN@mail.gmail.com>
 <20100524033859.GB24480@opensource.wolfsonmicro.com>
 <33A307AF30D7BF4F811B1568FE7A9B180B67C60C@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33A307AF30D7BF4F811B1568FE7A9B180B67C60C@EXDCVYMBSTM006.EQ1STM.local>
X-Cookie: You will pass away very quickly.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 10:33:49AM +0200, Sundar R IYER wrote:

> >needs of the core regulator applications.  As I keep saying I'm just not
> >seeing much more overlap here with the regulator API than I do with the
> >clock API: it feels like you've got another use case which needs an API
> >with a similar structure and the reference counted enable and disable
> >calls but otherwise very little overlap.

> As I agreed earlier, its true about requirement. It is also true that the clock API can suffice.
> But what is essential here is: we are talking about regulators here.
> Why would we need to model a seemingly similar regulator as a clock?

You're missing the point here.  I'm not saying use the clock API, I'm
saying that it feels like you want a parallel API that's aimed at the
needs of operating points which mirrors the structure of the existing
clock and regulator APIs.

> 1. Both power domains and a regulator can be enabled/disabled.
> 2. Both power domains and a regulator can be controlled to a specific voltage.

This isn't universal by any stretch of the imagination and manner in
which this is done is very different to how a regulator consumer would
operate.  A regulator consumer knows which voltage it wants to work at
directly and is selecting that voltage purely for itself, generally in a
way that applies to all implementations of the device.  With an
operating point a voltage is not set by the individual consumer but
rather for the power domain as a whole based on the needs of all the
consumers in the power domain.  If the same consumer driver is used in
multiple SoCs it's likely that the particular voltages needed will vary 
depending on the implementation on a given device.

It's perfectly sensible for the power domain to be a regulator consumer,
but having the individual consumer devices be regulator consumers seems
non-obvious.

> 3. Every peripheral is dependent on both power domains and a regulator to be essentially
>    on. Turning off the clocks will disable the peripheral, but it is not the same as turning off
>    the peripheral. And here is where the biggest difference from the clock API. You can disable
>    the peripheral clock with the clk_disable, but turning it off will be encroachment there. Whilst
>    a regulator_disable is the most logical fit here.

This is very much dependant on hardware again, some devices require a
clock for even basic functionality such as register access and there are
things such as dynamic RAM which won't even provide retention if they
are declocked.

You also need to remember that a key part of the operating point
configuration of some devices is the clock rate - normally the voltage
required by the block will be driven by the clock rates in operation in
the block.  The clock rates required may be a function of the operation
of the individual blocks but are often also driven by things like the
overall bandwidth needed on the various buses in the system.

As I keep saying the operating point selection in general hardware is
often a function of both the clocking and voltage selection, and often
chosen in a different way.

> 4. Both power domains and a regulator can be enforced upon constraints from their clients.

A different set of constraints, though - there's not much overlap here.

> *What* power domains and regulators differ about is:
> 1.a the nature of constraints is a bit different. On SoC regulators aka power domains have usually
>      a fixed set of clients which don't vary, but off SoC regulators can have varying clients.

As I keep saying the interaction between the consumer and the supplier
is also rather different between the two use cases.

> 2.a On SoC regulators aka power domains allow you controlling operational states like 
>      On/Off/Retention/Idle etc, whilst conventional regulators are more happy judging their current loads.
>      However, this still doesn't stop anyone from actually adding operational states to regulators.

Can you identify how operating points might be added to regulators?  The
physical connection between the regulators and the devices they are
supplying is very clear and does not leave much (if any) room for
flexibility here, and as I discussed in a prior message the trend in
hardware implementation is towards reducing the control which systems
use rather than increasing it.

> I agree with your reservations about pains trying to co-relate exactly a power domain and a regulator.
> If you agree, from the top, reaching out to bottom, there are only subtle differences and these 
> differences (1.a/2.a) can also be incorporated into conventional regulators which can be gradually 
> diminishing, whereas the similarities, (1,2,3,4) can only possible increase!

I'm still not seeing any meaningful overlap between the two things - it
seems unlikely that a substantial proportion of the drivers that need to
interact with operating points will also wish to explicitly use anything
other than enable and disable that the regulator API offers so even if
the two ended up being implemented in the same API you'd still have two
disjoint blocks of code implementing different things.

There are many interfaces in the kernel which work together to provide
power efficiency and to me it seems like you have identified a need for
a new one.  I'd also repeat my previous suggestion to look in more
detail at the operating point implementations that already exist in the
kernel and the needs of the hardware out there.
