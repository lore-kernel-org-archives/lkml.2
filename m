Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab2AQXhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:37:35 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:53454 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932081Ab2AQXhe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:37:34 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6vC7DBW0w6LhRTg_fi5bZ2aHxwFY2DNbT6KFcUmoYpNYA@mail.gmail.com>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D2353@HQMAIL01.nvidia.com> <CACxGe6vC7DBW0w6LhRTg_fi5bZ2aHxwFY2DNbT6KFcUmoYpNYA@mail.gmail.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 17 Jan 2012 15:37:12 -0800
Message-ID: <CAJOA=zMgGsZKGQ-EfSnXDY_WoFrzG6XPZtuxANFKqdL8CAaYrw@mail.gmail.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 2:47 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, Jan 17, 2012 at 1:44 PM, Stephen Warren <swarren@nvidia.com> wrote:
>> In other words, does the UART driver need to do something like:
>>
>> clk_reg = clk_get(dev, "register");
>> clk_parent = of_clk_get_by_name(np, "register);
>> clk_set_parent(clk_reg, clk_parent);
>>
>> Or will that all happen transparently within just the of_clk_get_by_name
>> call?
>>
>> (I suppose this question makes slightly more sense for the PLL itself,
>> since both the upstream and downstream clocks are represented in the PLL
>> node, whereas the UART's node only represents the clock consumer side,
>> so the above code isn't really possible automatically).
>
> The intent is that device only interacts with the leaf device.  If the
> clocks are arranged into a hierarchy, then the clock driver is
> responsible for any interactions with the parent clock.  Requiring the
> driver to manipulate parent clocks directly defeats the purpose of
> having a clock abstraction.

I don't think that we can get rid of all instances of drivers knowing
a bit about hierarchy.  I think we can get rid of most, but there are
cases where it is valid for a driver to know some of the details.
More on that below.

>> Somewhat related to this: How does dynamic reparenting interact with
>> the DT clock binding; is the DT just the default/initial clock setup,
>> and anything beyond that needs a custom binding and code in the consumer?
>
> As far as the clock binding goes, it only describes provider/consumer
> relationships.  The fact that such relationships may resolve to a
> hierarchy is beyond what the binding describes.  If a clock has
> multiple possible parents, then that specific clock binding should
> document how the multiple parent clocks are described and the clock
> driver is responsible for implementing the correct behaviour.

It also deserves to be said that the DT data says nothing about which
of the possible parents _should_ be the input to a mux clock.  It's
pretty common to want to make changes to hierarchy after taking a
device out of reset, since the reset values for a clock management IP
might be pretty conservative.  So someone, somewhere must know some
details about hierarchy and set things up correctly.  Maybe a "clock
driver" can do this, but for specific IPs such as the audio example
below it makes sense for that driver to have the knowledge.

> Similarly, the DT clock binding provides no generic mechanism for
> walking up the clock tree.  That behaviour must also be implemented by
> each specific clock driver.
>
>> I'm thinking of say a system with 1 I2S controller, and both an internal
>> and external I2S clock source, where perhaps the internal source needs
>> to be used to capture from an I2S interface on one set of pins (e.g.
>> analog mic) but the other clock source needs to be used to capture from
>> I2S on another set of pins (e.g. digital baseband unit connection).
>> (This example is theoretical, but I'm sure there are other dynamic clock
>> cases in practice).
>
> That is a reasonable example.  In this case, the i2c controller would
> include both in its clocks property, and the binding would document
> when and why each clock source is used.

I'm confused on this point.  How does the binding "document when and
why each clock is used"?  In the case where this I2S controller
expects to dynamically switch roles at run-time (analog mic versus
baseband) then clk_set_parent must still be invoked by the driver.  To
be clear I'm imagining the above example like:

i_I2S   e_I2S
   \       /
    I2S_mux
        |
I2S controller IP

Regards,
Mike
