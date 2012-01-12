Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2ALErU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 23:47:20 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57286 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2ALErT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 23:47:19 -0500
MIME-Version: 1.0
In-Reply-To: <20120110213338.GD3226@page>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca> <20120110213338.GD3226@page>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 Jan 2012 21:46:58 -0700
X-Google-Sender-Auth: 7iun2kCUBIS-NtmG_MqayxR2QGE
Message-ID: <CACxGe6vqb8AZcZb5WMvfmLsUZH7=SEtBrJCSfsFmDYpKX42MzA@mail.gmail.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Mike Turquette <mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 2:33 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> Hi Grant,
>
> On Mon, Dec 12, 2011 at 03:02:04PM -0700, Grant Likely wrote:
>> Based on work by Ben Herrenschmidt and Jeremy Kerr, this patch adds an
>> of_clk_get function to allow platforms to retrieve clock data from the
>> device tree.
>>
>> Platform register a provider through of_clk_add_provider, which will be
>> called when a device references the provider's OF node for a clock
>> reference.
> [...]
>> diff --git a/Documentation/devicetree/bindings/clock/fixed-clock.txt b/Documentation/devicetree/bindings/clock/fixed-clock.txt
>> new file mode 100644
>> index 0000000..9a75342
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/fixed-clock.txt
>> @@ -0,0 +1,21 @@
>> +Binding for simple fixed-rate clock sources.
>> +
>> +This binding uses the common clock binding[1].
>> +
>> +[1] Documentation/devicetree/bindings/clock/fixed-clock.txt
>
> This appears to reference itself?

Heh, oops.

>
>> +
>> +Required properties:
>> +- compatible : shall be "fixed-clock".
>> +- #clock-cells : from common clock binding; shall be set to 0.
>> +- clock-frequency : frequency of clock in Hz. May be multiple cells.
>> +
>> +Optional properties:
>> +- gpios : From common gpio binding; gpio connection to clock enable pin.
>
> This seems a little odd to me to have in the common binding, but I'm not
> that familiar with too many platforms.
>
>> +- clock-output-names : From common clock binding
>> +
>> +Example:
>> +     clock {
>> +             compatible = "fixed-clock";
>> +             #clock-cells = <0>;
>> +             clock-frequency = <1000000000>;
>> +     };
>
> I wonder if this should have an optional clock consumer with a standard
> name for parenting?  For example, on picoxcell there is a fixed 200MHz
> APB clock that is really a PLL from a 20MHz reference input and I'd like
> to represent that in the clock tree.

If it depends on a parent clock, then it really isn't a fixed clock,
is it (from the perspective of the OS).  The point of this binding is
a trivial way to describe clocks that don't change.  If that
assumption doesn't hold true, then this binding isn't suitable for
that clock.  As you point out, even the gpio enable feature is pushing
things a bit.

That said, I'm open to extending this binding if something can be
defined that will have a lot of use cases.

> I'm about to start trying to get this and Mike's common struct clk
> patches working on picoxcell, and the one thing I'm not understanding at
> the moment is how to handle the tree itself.  Currently I was planning
> on iterating over all clocks and finding a named input clock "ref" or
> "input" perhaps.  This would be fine for picoxcell, but I guess more
> complicated chips may need something else.

It might be useful to have something like of_irq_init() for setting up
initial clocks, but the solution feels inelegant to me.  I suspect
that there will be end up being intertwined init order dependencies
between clocks and irqs and other early setup stuff that could be
handled better.  Again, I need to think about this some more.  There
might need to be something like an of_early_probe() call that accepts
a match table of compatible values and setup functions with some logic
or data to resolve dependencies.  The trick will be to not end up with
something complex.  I'll need to think about this more...

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
