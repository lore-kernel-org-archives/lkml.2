Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1EJVmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:42:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59805 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab1EJVms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rw43HPXXdJJlokyIDSLLGoSRkMOgOhDUU1OiVtUZaaBMwv8ivRYom9GQc+qHVdj9ZU
         WSjvyxtx/GzzZgs78rOX6Q7HwdAA1bIHC4bPPUTMnbiEANV8rRfOShDexHZuJtdn0bCq
         YXfnFVYWlZwFD8gPvA7sbndxdejgJOy0dmBfY=
MIME-Version: 1.0
In-Reply-To: <20110503172712.GE6538@lunn.ch>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
	<20110503172712.GE6538@lunn.ch>
Date: Tue, 10 May 2011 23:42:47 +0200
X-Google-Sender-Auth: -3HnorCbfprmd_ieQb16hzeyaDQ
Message-ID: <BANLkTi=ncV3M1q5SXNdUaXmtfkZ8Wn9dmw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/3 Andrew Lunn <andrew@lunn.ch>:

> Say i have a UART core. I can be used as a 3-wire serial port, or
> additionally it can have hardware flow control, or additionally it can
> have all the modem signals. What would i expect to find in the pinmux
> driver?

If and only if it involves reassigning the pins coming out of your package,
enumerated as a one dimensional array, to alternative functions,
defined as possibly overlapping groups of pins in said array.

Anything else is orthogonal.

> 1) Three functions: uart-3wire, uart-hw-flow, uart-hw-flow-modem.  The
>   first just has 2 pins, the second 4 and the last 8. The board code
>   selects one of these for the serial driver to use.

Sounds like a solid case for pinmuxing. Here the board code defines
three mux settings by name that your pinmux driver shall be able to handle,
and associate each of them with the same device.

> 2) Three functions: uart-core, uart-hw-flow, uart-mode.  The first has
>   2 pins, the second has 2 pins and the last 4 pins. The board code tells
>   the driver to use uart-core, plus say uart-hw-flow.

Same thing.

> Do you think the documentation should have guidelines how best to do
> this sort of core + additional optional extras?

I believe it already has, it describes a simple case of an overlapping
I2C and SPI port, two overlapping UART configurations are not
conceptually different.

> Say i have a SoC with an SPI core. This core has the usual MISC, MOSI
> and SCLK. It additionally has 4 chip select lines. My board uses chip
> select lines 2 and 3 for SPI, and select lines 0 and 1 as GPIO lines.
> How does the pinmux driver handle this? Again, it is the problems of a
> few core pins plus additional optional extras.

The pinmux API keeps track of individual pins and whether they are in
use or not. It keeps track of groups of pins and whether they overlap.
It denies a certain function to be muxed in in case its desired pins
overlap with another function.

Once you start modeling it you decide what overlapping means,
and in practice in this case taking the two lines that could have been
used for SPI chipselects as GPIO lines assures any attempts to
use them as SPI chipselects at the same time will be denied.

So the idea is not to keep track of all possible weird ways you may
use your pins, the idea is to put constraints on what you can physically
do and from there define the groups of pins you may use in practice.
Additionally requesting a single GPIO pin will mark a single pin as
"taken".

I *could* have modeled every pin that can be taken for GPIO as a
function containing a single pin but it seems too silly, mathematicians
would have loved it.

> Maybe the documentation should make some recommendations about what is
> placed into the drivers/pinmux/pinmux-foo.c and what should be kept in
> the board specific code?

It does by written example. And as an additional example a real-world
pinmux for the U300 has been moved from mach-u300 to
drivers/pinmux.

> Without these guidelines, it seems to me,
> each board for a given SoC is going to add its own peculiar pin
> combination to the drivers/pinmux/pinmux-foo.c file.

No not board. The driver is a driver for the package or pad ring,
nothing else. And the package certainly knows, by virtue of knowing
what differernt functions it can mux in/out by poking bits in the
hardware, about the actual groups that exists on the package.

The board in turn defines which of these possible functions that
it wants to mux in to certain devices. Note that it can assign multiple
functions to a single device, as mentioned in the reply to Russell.

>  Maybe it makes
> more sense to have a collection of standard pin functions in
> drivers/pinmux/pinmux-foo.c, which cover 75% of the likely
> combinations.

I don't get it. There are as many combinations as there are
chips. A function on pin 12, 13 and 35 on my package is very
unlikely to be viable on another package.

The pinmux API is *not* about keeping track of the fact that
SPI uses so or so many pins, it's just about groups of pins
in an array, nothing else.

> And recommend a board file to have its own additional
> list of strange pin functions which it registers with the pinmux core?

The board file only references the functions that the the package
can mux. The board file should *never* define any functions
or pin groups whatsoever, the pinmux driver knows about those.

Thanks,
Linus Walleij
