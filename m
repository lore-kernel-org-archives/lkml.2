Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2KWRds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:33:48 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:39391 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab2KWRdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:33:47 -0500
MIME-Version: 1.0
In-Reply-To: <20121123094132.EFCB73E07BE@localhost>
References: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
	<7a48ae364663ab3a336251fada9aee07ccd728b8.1353610437.git.viresh.kumar@linaro.org>
	<20121123094132.EFCB73E07BE@localhost>
Date: Fri, 23 Nov 2012 23:03:47 +0530
Message-ID: <CAKohpomAM2pw9kgB6khtHzQ2WCXKZ9_pi1_sOH2dQToVS8ep4w@mail.gmail.com>
Subject: Re: [PATCH V3 3/3] mfd: stmpe: Update DT support in stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: lee.jones@linaro.org, Grant Likely <grant.likely@secretlab.ca>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 15:11, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, 23 Nov 2012 00:26:20 +0530, Viresh Kumar <viresh.kumar@linaro.org> wrote:

>> + - irq-trigger                       : IRQ trigger to use for the interrupt to the host
>> + - irq-invert-polarity               : bool, IRQ line is connected with reversed polarity
>
> This looks odd. Normally the interrupt polarity should be encoded in the irq
> specifier flags field.

Hi Grant and Lee Jones,

This looks odd because stmpe is odd, i am taking the discussion held
with Lee jones to this thread.

So, how interrupt stuff works currently in DT..
We have a interrupt controller IC:

	ic: interrupt-controller@40008000 {
		compatible = "foo";
		interrupt-controller;
		#interrupt-cells = <2>;
                ...
	};

And we have a user of this IC:

	foo-peripheral@40048000 {
		compatible = "foo-peripheral";
		interrupt-parent = <&ic>;
		interrupts = <39 4>;
	};

Here first field of "interrupts" gives interrupt line number and the second one
gives polarity, interrupt type etc..

All is good till now. Now, every interrupt controller supports the first
field, but the second one depends on its capabilities. An interrupt controller
might not have registers to configure interrupt polarity, type, etc of
the interrupt
it will service and so the second field wouldn't be available for them.

For now just think stmpe is not a MFD and not a interrupt controller
either. It is
just a simple device, dev-foo.

It will declare values of its interrupts field based on the type of
interrupt controller
that will service its interrupt and that can be anything like VIC/GIC/GPIO
controller.

Obviously nobody else than the parent IC driver can parse interrupts field
of dev-foo, because only that driver understands the real meaning of
these fields.

Now, stmpe has a special property. It can decide the way its output
interrupt line
will work. i.e. its polarity and interrupt type - edle/level, etc..
This is not commonly
seen in any peripheral. Now my original bindings and the real question here is
about passing this information to stmpe driver.

I can't pass it in interrupts field of stmpe node, as that field
belongs to parent
interrupt controller of stmpe.

I can't pass that from child nodes of stmpe, as we are programming the interrupt
coming out of stmpe and not the interrupt coming out of stmpe-gpio or
stmpe-keypad.

And that's why i added these bindings. Please suggest me if i am still missing
something.

--
viresh
