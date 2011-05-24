Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1EXTlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:41:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55190 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1EXTlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AeJX/JqH/ef9kFxfrZwJ2S8+ZdWkgg+tP+uLkd/IBnphUt9377MnajXIZjZjyNjpIR
         23POehh3IHExGkU6PO9Q==
MIME-Version: 1.0
In-Reply-To: <20110524080936.GI20715@pengutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo>
	<BANLkTik=EFayZW61TgfOni-XML+tRLOcqw@mail.gmail.com>
	<20110524062620.GA22096@pengutronix.de>
	<BANLkTimEoCaKwJtpbQTDSEDydNkZ1BkKog@mail.gmail.com>
	<20110524080936.GI20715@pengutronix.de>
Date: Tue, 24 May 2011 12:41:20 -0700
Message-ID: <BANLkTinVnFasvOmu0MWRDzv21P3vM8eM6g@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add a generic struct clk
From: Colin Cross <ccross@google.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 1:09 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, May 24, 2011 at 12:31:13AM -0700, Colin Cross wrote:
>> On Mon, May 23, 2011 at 11:26 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> > On Mon, May 23, 2011 at 04:12:24PM -0700, Colin Cross wrote:
>> >> >
>> >> >   tglx's plan is to create a separate struct clk_hwdata, which contains a
>> >> >   union of base data structures for common clocks: div, mux, gate, etc. The
>> >> >   ops callbacks are passed a clk_hw, plus a clk_hwdata, and most of the base
>> >> >   hwdata fields are handled within the core clock code. This means less
>> >> >   encapsulation of clock implementation logic, but more coverage of
>> >> >   clock basics through the core code.
>> >>
>> >> I don't think they should be a union, I think there should be 3
>> >> separate private datas, and three sets of clock ops, for the three
>> >> different types of clock blocks: rate changers (dividers and plls),
>> >> muxes, and gates.  These blocks are very often combined - a device
>> >> clock often has a mux and a divider, and clk_set_parent and
>> >> clk_set_rate on the same struct clk both need to work.
>> >
>> > The idea is to being able to propagate functions to the parent. It's
>> > very convenient for the implementation of clocks when they only
>> > implement either a divider, a mux or a gate. Combining all of these
>> > into a single clock leads to complicated clock trees and many different
>> > clocks where you can't factor out the common stuff.
>>
>> That seems complicated.  You end up with lots of extra clocks (meaning
>> more boilerplate in the platform files) that have no meaning in the
>> system (what is the clock between the mux and the divider in Tegra's
>> i2c1 clock, it can never feed any devices), and you have to figure out
>> at the framework level when to propagate and when to error out.  I'm
>> not even sure you can always find the right place to stop propagating
>> - do you just keep going up until the set_parent callback succeeds, or
>> exists, or what?
>
> For the set_parent there would be no propagating at all. For set_rate I
> can imagine a flag in the generic clock which tells whether to propagate
> set_rate or not.
>
>>
>> I think you can still factor out all the common code if you treat each
>> clock as a possible mux, divider, and gate combination.  Each part of
>> the clock is still just as abstractable as before - you can set the
>> rate_ops to be the generic single register divider implementation, and
>> the gate ops to be the generic single bit enable implementation.  The
>> idea of what a clock node is matches the HW design,
>
> The hardware design consists of only discrete rate changers (plls,
> dividers), muxes and gates. These are the only building blocks
> *every* hardware design has. I believe that many of the problems
> the current implementations have are due to the multiple building
> blocks stuffed into one clock. If you haven't already take a look
> at my i.MX5 clock patches:
>
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/113631
>
> They need changes to fit onto the current patches and the rate
> propagation problem is not solved there, but the resulting clock
> data files are really short and nice to read. Furthermore it's easy
> to implement. Just look at the diagrams in the datasheet and go through
> them.

Propagation is what I'm trying simplify, because it's impossible at
the framework level to determine the right time to propagate, and the
right time to return an error, and I don't like pushing it down to
each clock implementation either, because then you need a "propagating
clk gate" and a "non-propagating clk gate".

Your building blocks implement every op - clk_gate_ops implements
set_rate as clk_parent_set_rate (won't that cause a deadlock on
prepare_lock when it calls clk_set_rate?).  I'm suggesting breaking
out the clock gate ops into a struct that only contains:
enable
disable
prepare
unprepare
And a rate ops struct that contains:
round_rate
set_rate
And a mux ops struct that contains
set_parent

For a single HW clock that has a mux, a gate, and a divider, the
existing implementation requires:
INIT_CLK(..., clk_mux_ops)
INIT_CLK(..., clk_div_ops)
INIT_CLK(..., clk_gate_ops)
which creates 3 clocks, and requires lots of propagation logic to
figure out how to call clk_set_rate on the single clock that is
exposed to the device, but not propagate it past the device clock if
the device clock doesn't have a divider (propagating it up to an
active pll feeding other devices results in disaster, at least on
Tegra).  This combination doesn't seem to be common in your MX code,
but _every_ Tegra device clock has these three parts.

With multiple smaller building blocks that can fit inside a clock, all
you need is:
INIT_CLK(..., clk_mux_ops, clk_div_ops, clk_gate_ops)
You have one struct clk, which is exposed to the device and matches
the datasheet.  If the clock has rate ops, clk_set_rate works with no
propagation.  If it doesn't have a rate, clk_rate_ops is NULL, and the
framework deal with propagation only in the case where it is really
propagation - a child clock that requires changing a parent clock.
The block abstraction is still in place, there are just 3 slots for
blocks within each clock.

Using a flag to mark clocks as "non-propagatable" is also not correct
- propagatability is a feature of the parent, not the child.
