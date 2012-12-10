Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2LJQpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 11:45:39 -0500
Received: from smarthost01.mail.zen.net.uk ([212.23.1.1]:60508 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995Ab2LJQpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 11:45:38 -0500
Message-ID: <1355157933.3386.55.camel@linaro1.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Rabin Vincent <rabin@rab.in>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 10 Dec 2012 16:45:33 +0000
In-Reply-To: <20121210100433.GB6624@mudshark.cambridge.arm.com>
References: <1354821581.17101.17.camel@gandalf.local.home>
	 <1354872138.3176.15.camel@computer5.home>
	 <1354888985.17101.41.camel@gandalf.local.home>
	 <1354892111.13000.50.camel@linaro1.home>
	 <1354894134.17101.44.camel@gandalf.local.home>
	 <20121207162346.GW14363@n2100.arm.linux.org.uk>
	 <1354898200.17101.50.camel@gandalf.local.home>
	 <20121207164530.GX14363@n2100.arm.linux.org.uk>
	 <1354900436.17101.58.camel@gandalf.local.home>
	 <1354902347.8263.12.camel@linaro1.home>
	 <20121210100433.GB6624@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 10:04 +0000, Will Deacon wrote:
> Hi Jon,
> 
> Back-pedalling a bit here, but I'm confused by one of your points below:
> 
> On Fri, Dec 07, 2012 at 05:45:47PM +0000, Jon Medhurst (Tixy) wrote:
> > On Fri, 2012-12-07 at 12:13 -0500, Steven Rostedt wrote:
> > > I'll make my question more general:
> > > 
> > > If I have a nop, that is a size of a call (branch and link), which is
> > > near the beginning of a function and not part of any conditional, and I
> > > want to convert it into a call (branch and link), would adding a
> > > breakpoint to it, modifying it to the call, and then removing the
> > > breakpoint be possible? Of course it would require syncing in between
> > > steps, but my question is, if the above is possible on a thumb2 ARM
> > > processor?
> > 
> > I believe so. The details are (repeating your earlier explanation) ...
> > 
> > 1. Replace first half of nop with 16bit 'breakpoint' instruction.
> 
> Sort of -- you'd actually need 2x16-bit nops to make this work.
> 
> > 2. Sync.(cache flush to PoU + IPIs to make other cores invalidate the
> > icache for changed part of the nop instruction).
> 
> Why do you need to use IPIs for I-cache invalidation on other cores? For
> ARMv7 SMP (i.e. the multi-processing extensions) doing I-cache invalidation
> by MVA to PoU will be broadcast to the applicable domain for the
> shareability attributes of the address. So if you do icimvau with an
> inner-shareable virtual address, it will be broadcast by the hardware.

That was a clue I was missing, and it means that my patch which spawned
this thread is flawed. The original problem I was trying to cure was
random crashes whilst ftrace_modify_all_code() was going round modifying
kernel functions, and I fixed this by getting all cores to
__flush_icache_all() after the modifications had been made. But if cache
flushes are broadcast across all cores then my reasoning for the fix is
wrong.

As this only seems to surface on TC2 perhaps CCI doesn't do the magic we
want, or we have it misconfigured, or were been hit by cache differences
between A7 and A15? (I've seen comments somewhere which says A7 has VIPT
aliasing I-cache, and A15 is PIPT non-aliasing).

Will need to some more detailed investigation when I get time.

-- 
Tixy

