Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0IOKwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:52:20 -0400
Received: from relay.atmel.no ([194.19.124.36]:22193 "EHLO relay.atmel.no"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750844Ab0IOKwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:52:19 -0400
Date: Wed, 15 Sep 2010 12:51:38 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: linux-mmc@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] mmc: Reduce fOD to 200 kHz if possible
Message-ID: <20100915125138.1f25e4b1@hskinnemoen-d830>
In-Reply-To: <9348108E-1108-46FE-8437-6F1271025C61@niasdigital.com>
References: <1284541140-7328-1-git-send-email-haavard.skinnemoen@atmel.com>
	<9348108E-1108-46FE-8437-6F1271025C61@niasdigital.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette <bn@niasdigital.com> wrote:
> On 15/09/2010, at 6:59 PM, Haavard Skinnemoen wrote:
> 
> > Since the identification frequency was increased to 400 kHz, my
> > ATSTK1000 board has not been able to initialize any MMC or SD cards.
> > Reducing the identification mode frequency to 200 kHz fixes the problem.
> > 
> > This is definitely a board-specific issue, probably due to weak pull-up
> > resistor values, but this is the simplest fix I could come up with.  
> 
> I wonder whether there's an Atmel reference schematic around with an incorrect resistor value on it, the only three people I know affected by this are myself, Hein Tibosch and you, all on AVR32.

Yes, if you've used the STK1000 schematics as a reference, the resistor
values are probably a bit on the high side. I can't really suggest any
better values, as I don't remember what they should be, and the various
specs are quite inconsistent so it's not straightforward to find the
best values.

On the other hand, you could argue that the resistor values are fine as
they are, and that the Linux MMC subsystem is broken because it runs
the bus faster than what the hardware allows. Replacing the resistors
with stronger ones might reduce the maximum speed in push-pull mode, so
I wouldn't necessarily recommend it, especially when it's trivial to fix
the issue in software.

> We've now submitted one fix each, mine was similar to yours [1] but there's been movement on Hein's more comprehensive patch recently [2].  I don't know who's supposed to be merging MMC patches atm, Chris Ball added on CC on a hunch.

Thanks for the references. IMO Hein's patch is overkill. There is
absolutely no reason why 200 kHz should be a problem on any setup, and
I haven't found any indication in any discussions that it is.

The reason why fOD was set to 400 kHz in the first place is that some
controllers have a very low f_min so running the initialization at that
frequency causes problems. Which makes sense because the SD standard
clearly says that the clock can't be slower than 100 kHz.

But I have never seen any reasons why we absolutely _have_ to run the
clock at the maximum frequency allowed by the spec. In fact, Sascha
Hauer, who was the one who changed the minimum clock frequency to 400
kHz, said he would be fine with any frequency between 50 kHz and 400
kHz [1].

Haavard

[1] http://lkml.org/lkml/2010/1/5/120
