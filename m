Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab2LJNCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:02:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2LJNCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:02:21 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0q0mCv_Vr9gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrIq2vSOvhQA:10 a=Mcv_8NHxT8gbKlWm0JQA:9 a=PUjeQqilurYA:10 a=k6txnzOdrmpDs54j:21 a=kARhebiyD940aEpH:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355144537.17101.155.camel@gandalf.local.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 10 Dec 2012 08:02:17 -0500
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
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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

Why?

> 
> > 2. Sync.(cache flush to PoU + IPIs to make other cores invalidate the
> > icache for changed part of the nop instruction).
> 
> Why do you need to use IPIs for I-cache invalidation on other cores? For
> ARMv7 SMP (i.e. the multi-processing extensions) doing I-cache invalidation
> by MVA to PoU will be broadcast to the applicable domain for the
> shareability attributes of the address. So if you do icimvau with an
> inner-shareable virtual address, it will be broadcast by the hardware.
> 
> > However, wouldn't we need any of this breakpoint malarkey, why not just
> > just use a 16-bit branch instruction which branches over the second half
> > of the nop? :-)
> 
> Yes, and I think if you do use two 16-bit nops, you can even get rid of all
> the intermediate `sync' operations (I guess you might want one at the end if
> you want the call to become visible at a particular point).

Wont work. We are replacing a 32bit call with a nop. That nop must also
be 32bits, because we could eventually replace the nop(s) with a 32bit
call. Basically, we can never allow the second 16bit part ever be the
next instruction. If the first 16bit nop is executed, and then the task
gets preempted. The nops get converted to a 32bit call. The task gets
scheduled again and now is executing the second 16bits of the 32bit call
and we get unexpected (probably crashing) results.

By having either a 16bit breakpoint whose handler returns after the
second 16bit part, or a 16bit jump that simply jumps over the second
half, then all this should work. When the CPU processes a 32bit
instruction, it either processes all or non of it, correct?

-- Steve


