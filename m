Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2HGRCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:02:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58992 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745Ab2HGRCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:02:07 -0400
Date: Tue, 7 Aug 2012 18:02:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH] regmap-irq: allow auto-allocated IRQs to be mapped
Message-ID: <20120807170204.GU16861@opensource.wolfsonmicro.com>
References: <201208020805.q72858Yj003147@latitude.olech.com>
 <20120804105424.GB10523@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032C3B7E@NB-EX-MBX02.diasemi.com>
 <20120807140311.GH16861@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032C3C2A@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51032C3C2A@NB-EX-MBX02.diasemi.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 02:37:37PM +0000, Opensource [Anthony Olech] wrote:

> > The bottom line here is that if your driver requires a dynamically allocated
> > legacy domain it is broken.

> I am trying to use the latest REGMAP API, and I do not understand why you
> say the DSA9058 driver "requires" a dynamically allocated legacy domain.

If you care if you got a linear or a legacy domain then that shows
you're reyling on having a legacy domain (indeed, my statement above
should've been stronger - if anything in the driver itself cares if it's
got a linear or a legacy domain the driver is buggy).

> Surely the virtual IRQs that the PMIC component drivers use must be
> dynamically allocated. It is only the single GPIO line designated as an
> interrupt line in the machne drivert that is fixed by the hardware. That
> surely means the "irq_base" parameter to regmap_add_irq_chip() must
> be set to "-1". What else could it be set to??

If the driver doesn't have any inputs which could be used as an
interrupt by another device then it should be set to -1, yes, and
nothing in the code should ever care how the specific virq values are
related to each other.

If the driver does support another device using it as an interrupt
controller then unfortunately for non-DT systems platform data would
need to configure an irq_base so that the interrupt can be supplied to
whatever the other device is but in all other circumstances it should be
set to -1.

> I am beginning to suspect that I have misunderstood something. The
> regmap-irq API seemed taylor-made for our PMIC with one real h/w
> interrupt line with several PMIC chip irq sources controlled by a set
> of registers that seemed to slot into the "regmap_add_irq_chip" struct
> perfectly. Why should that set of virtual irqs be given a specific base??

It shouldn't, this is what I'm saying.  The IRQs shouldn't have a base
at all and should instead be using a linear domain (which doesn't have
a base but instead maps each IRQ on demand).  What your patch does is to
stop that happening and instead always allocate a legacy domain even
when linear is OK.

It sounds like your code to allocate the IRQs is fine but the code using
the IRQs is buggy as it's relying on the linear domain.
