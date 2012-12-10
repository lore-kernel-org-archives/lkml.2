Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab2LJNdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:33:39 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48914 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab2LJNdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:33:38 -0500
Date: Mon, 10 Dec 2012 13:33:13 +0000
From: Will Deacon <will.deacon@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
Message-ID: <20121210133313.GB7869@mudshark.cambridge.arm.com>
References: <1354888985.17101.41.camel@gandalf.local.home>
 <1354892111.13000.50.camel@linaro1.home>
 <1354894134.17101.44.camel@gandalf.local.home>
 <20121207162346.GW14363@n2100.arm.linux.org.uk>
 <1354898200.17101.50.camel@gandalf.local.home>
 <20121207164530.GX14363@n2100.arm.linux.org.uk>
 <1354900436.17101.58.camel@gandalf.local.home>
 <1354902347.8263.12.camel@linaro1.home>
 <20121210100433.GB6624@mudshark.cambridge.arm.com>
 <1355144537.17101.155.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355144537.17101.155.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 01:02:17PM +0000, Steven Rostedt wrote:
> On Mon, 2012-12-10 at 10:04 +0000, Will Deacon wrote:
> > Hi Jon,
> > 
> > Back-pedalling a bit here, but I'm confused by one of your points below:
> > 
> > On Fri, Dec 07, 2012 at 05:45:47PM +0000, Jon Medhurst (Tixy) wrote:
> > > On Fri, 2012-12-07 at 12:13 -0500, Steven Rostedt wrote:
> > > > I'll make my question more general:
> > > > 
> > > > If I have a nop, that is a size of a call (branch and link), which is
> > > > near the beginning of a function and not part of any conditional, and I
> > > > want to convert it into a call (branch and link), would adding a
> > > > breakpoint to it, modifying it to the call, and then removing the
> > > > breakpoint be possible? Of course it would require syncing in between
> > > > steps, but my question is, if the above is possible on a thumb2 ARM
> > > > processor?
> > > 
> > > I believe so. The details are (repeating your earlier explanation) ...
> > > 
> > > 1. Replace first half of nop with 16bit 'breakpoint' instruction.
> > 
> > Sort of -- you'd actually need 2x16-bit nops to make this work.
> 
> Why?

Because the architecture doesn't provide any guarantees about concurrent
modification of 32-bit nop instructions. If you stop the world every time,
fine, but that's what we're trying to avoid, right?

> > > However, wouldn't we need any of this breakpoint malarkey, why not just
> > > just use a 16-bit branch instruction which branches over the second half
> > > of the nop? :-)
> > 
> > Yes, and I think if you do use two 16-bit nops, you can even get rid of all
> > the intermediate `sync' operations (I guess you might want one at the end if
> > you want the call to become visible at a particular point).
> 
> Wont work. We are replacing a 32bit call with a nop. That nop must also
> be 32bits, because we could eventually replace the nop(s) with a 32bit
> call. Basically, we can never allow the second 16bit part ever be the
> next instruction. If the first 16bit nop is executed, and then the task
> gets preempted. The nops get converted to a 32bit call. The task gets
> scheduled again and now is executing the second 16bits of the 32bit call
> and we get unexpected (probably crashing) results.

Damn, I didn't realise you wanted to put the 32-bit call back on
pre-emption. Still, the `sync' is not needed when patching in a b for a nop.

> By having either a 16bit breakpoint whose handler returns after the
> second 16bit part, or a 16bit jump that simply jumps over the second
> half, then all this should work. When the CPU processes a 32bit
> instruction, it either processes all or non of it, correct?

If you have two 16-bit nops, patching the first to branch over the second
will work.

Will
