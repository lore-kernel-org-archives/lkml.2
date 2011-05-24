Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1EXHbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:31:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1EXHbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:31:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H8cN8/Nqmb/5jdzTiyc0LzkbREixIzjx5i7NfPlYsHs09NkeOYdn2QIAHWq5KlGR/7
         BceYsRFa9uYFbXYtPpvA==
MIME-Version: 1.0
In-Reply-To: <20110524062620.GA22096@pengutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo>
	<BANLkTik=EFayZW61TgfOni-XML+tRLOcqw@mail.gmail.com>
	<20110524062620.GA22096@pengutronix.de>
Date: Tue, 24 May 2011 00:31:13 -0700
Message-ID: <BANLkTimEoCaKwJtpbQTDSEDydNkZ1BkKog@mail.gmail.com>
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

On Mon, May 23, 2011 at 11:26 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Mon, May 23, 2011 at 04:12:24PM -0700, Colin Cross wrote:
>> >
>> >   tglx's plan is to create a separate struct clk_hwdata, which contains a
>> >   union of base data structures for common clocks: div, mux, gate, etc. The
>> >   ops callbacks are passed a clk_hw, plus a clk_hwdata, and most of the base
>> >   hwdata fields are handled within the core clock code. This means less
>> >   encapsulation of clock implementation logic, but more coverage of
>> >   clock basics through the core code.
>>
>> I don't think they should be a union, I think there should be 3
>> separate private datas, and three sets of clock ops, for the three
>> different types of clock blocks: rate changers (dividers and plls),
>> muxes, and gates.  These blocks are very often combined - a device
>> clock often has a mux and a divider, and clk_set_parent and
>> clk_set_rate on the same struct clk both need to work.
>
> The idea is to being able to propagate functions to the parent. It's
> very convenient for the implementation of clocks when they only
> implement either a divider, a mux or a gate. Combining all of these
> into a single clock leads to complicated clock trees and many different
> clocks where you can't factor out the common stuff.

That seems complicated.  You end up with lots of extra clocks (meaning
more boilerplate in the platform files) that have no meaning in the
system (what is the clock between the mux and the divider in Tegra's
i2c1 clock, it can never feed any devices), and you have to figure out
at the framework level when to propagate and when to error out.  I'm
not even sure you can always find the right place to stop propagating
- do you just keep going up until the set_parent callback succeeds, or
exists, or what?

I think you can still factor out all the common code if you treat each
clock as a possible mux, divider, and gate combination.  Each part of
the clock is still just as abstractable as before - you can set the
rate_ops to be the generic single register divider implementation, and
the gate ops to be the generic single bit enable implementation.  The
idea of what a clock node is matches the HW design, and op propagation
is easy - if it has rate ops, you can call clk_set_rate on it,
otherwise you can't.
