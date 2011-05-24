Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1EXIJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:09:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46752 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1EXIJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:09:46 -0400
Date: Tue, 24 May 2011 10:09:36 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Colin Cross <ccross@google.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/4] Add a generic struct clk
Message-ID: <20110524080936.GI20715@pengutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo>
 <BANLkTik=EFayZW61TgfOni-XML+tRLOcqw@mail.gmail.com>
 <20110524062620.GA22096@pengutronix.de>
 <BANLkTimEoCaKwJtpbQTDSEDydNkZ1BkKog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimEoCaKwJtpbQTDSEDydNkZ1BkKog@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:46:12 up 3 days, 21:25, 49 users,  load average: 0.71, 0.99, 0.99
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 12:31:13AM -0700, Colin Cross wrote:
> On Mon, May 23, 2011 at 11:26 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Mon, May 23, 2011 at 04:12:24PM -0700, Colin Cross wrote:
> >> >
> >> >   tglx's plan is to create a separate struct clk_hwdata, which contains a
> >> >   union of base data structures for common clocks: div, mux, gate, etc. The
> >> >   ops callbacks are passed a clk_hw, plus a clk_hwdata, and most of the base
> >> >   hwdata fields are handled within the core clock code. This means less
> >> >   encapsulation of clock implementation logic, but more coverage of
> >> >   clock basics through the core code.
> >>
> >> I don't think they should be a union, I think there should be 3
> >> separate private datas, and three sets of clock ops, for the three
> >> different types of clock blocks: rate changers (dividers and plls),
> >> muxes, and gates.  These blocks are very often combined - a device
> >> clock often has a mux and a divider, and clk_set_parent and
> >> clk_set_rate on the same struct clk both need to work.
> >
> > The idea is to being able to propagate functions to the parent. It's
> > very convenient for the implementation of clocks when they only
> > implement either a divider, a mux or a gate. Combining all of these
> > into a single clock leads to complicated clock trees and many different
> > clocks where you can't factor out the common stuff.
> 
> That seems complicated.  You end up with lots of extra clocks (meaning
> more boilerplate in the platform files) that have no meaning in the
> system (what is the clock between the mux and the divider in Tegra's
> i2c1 clock, it can never feed any devices), and you have to figure out
> at the framework level when to propagate and when to error out.  I'm
> not even sure you can always find the right place to stop propagating
> - do you just keep going up until the set_parent callback succeeds, or
> exists, or what?

For the set_parent there would be no propagating at all. For set_rate I
can imagine a flag in the generic clock which tells whether to propagate
set_rate or not.

> 
> I think you can still factor out all the common code if you treat each
> clock as a possible mux, divider, and gate combination.  Each part of
> the clock is still just as abstractable as before - you can set the
> rate_ops to be the generic single register divider implementation, and
> the gate ops to be the generic single bit enable implementation.  The
> idea of what a clock node is matches the HW design,

The hardware design consists of only discrete rate changers (plls,
dividers), muxes and gates. These are the only building blocks
*every* hardware design has. I believe that many of the problems
the current implementations have are due to the multiple building
blocks stuffed into one clock. If you haven't already take a look
at my i.MX5 clock patches:

http://thread.gmane.org/gmane.linux.ports.arm.kernel/113631

They need changes to fit onto the current patches and the rate
propagation problem is not solved there, but the resulting clock
data files are really short and nice to read. Furthermore it's easy
to implement. Just look at the diagrams in the datasheet and go through
them.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
