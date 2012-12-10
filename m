Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2LJQbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 11:31:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2LJQbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 11:31:33 -0500
X-Authority-Analysis: v=2.0 cv=JuRzXbEC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0q0mCv_Vr9gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrIq2vSOvhQA:10 a=O8pGZApEfOqDBh7hbo4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355157090.17101.222.camel@gandalf.local.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 10 Dec 2012 11:31:30 -0500
In-Reply-To: <20121210152518.GO14363@n2100.arm.linux.org.uk>
References: <1354898200.17101.50.camel@gandalf.local.home>
	 <20121207164530.GX14363@n2100.arm.linux.org.uk>
	 <1354900436.17101.58.camel@gandalf.local.home>
	 <1354902347.8263.12.camel@linaro1.home>
	 <20121210100433.GB6624@mudshark.cambridge.arm.com>
	 <1355144537.17101.155.camel@gandalf.local.home>
	 <20121210135747.GK14363@n2100.arm.linux.org.uk>
	 <1355148365.17101.168.camel@gandalf.local.home>
	 <20121210140749.GM14363@n2100.arm.linux.org.uk>
	 <1355150801.17101.197.camel@gandalf.local.home>
	 <20121210152518.GO14363@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 15:25 +0000, Russell King - ARM Linux wrote:
> On Mon, Dec 10, 2012 at 09:46:41AM -0500, Steven Rostedt wrote:
> > Again, you and I are having a disconnect. I'm not a HW expert. I'm
> > trying to get a total understanding of what you, Will, Jon and others
> > are trying to say.
> 
> Well, there's people who think that you're intentionally trying to wind
> me up (I'm not alone in this opinion; believe me, I checked with someone
> else taking part in this thread and they said as much...)

I'm sorry that you and others feel that way. What benefit would I get to
do such a thing? That would be counter productive on my part, and
honestly, that's the last thing I want to do. I think it may just be
that my general personality and my way of writing may be of issue. Ask
others that deal with me. I'm not saying anything differently to you
than I do to anyone else. But that's just me. I'm really not taking any
of this personal nor am I trying to piss you or anyone else off. I'm
just trying to talk technical here.


> 
> > > ... which, if it's misaligned to a 32-bit boundary, which can happen with
> > > Thumb-2 code, will require the replacement to be done atomically; you will
> > > need to use stop_machine() to ensure that other CPUs don't try to execute
> > > the instruction mid-way through modification... as I have already
> > > explained in my previous mails.
> > 
> > I'm confused to what is wrong to "misaligned to a 32-bit boundery".
> > Isn't it best if it is on a 32-bit boundary? Or do you mean that it's
> > misaligned across a 32-bit boundary? I guess I just read it wrong.
> 
> What I mean is a store of 32-bit size to an address which is not
> numerically an integer multiple of four.
> 
> To see why this is a problem, take a moment to think about how you'd
> update a misaligned 32-bit value on a 32-bit bus with byte enables.
> You need to do it as two transactions.
> 
> If your bus is 64-bits wide, then the problem potentially becomes one
> where there's an issue if it crosses a 64-bit boundary.  Continue for
> larger bus widths...
> 
> Now add in the effect of caching with its cache line boundaries, and
> what the effects are if a write crosses the cache line boundary (which
> means it ends up with two separate validity bits etc.)
> 
> Lastly, remember that ARM CPUs have a Harvard cache architecture; that
> means that the data paths are entirely separate from the instruction
> paths - and in some cases that goes all the way to the memory controller,
> but that's not relevant.  The relevant point here is that the point in
> the pathways where the instruction and data paths unite can be quite
> some distance _outside_ of the CPU.
> 
> What this all means is that a misaligned 32-bit store can ultimately
> appear as two separate 16-bit stores, which may be interleaved by
> other bus activity.  Whether that is visible to other CPUs in a SMP
> system as two separate 16-bit stores or not isn't well defined.
> 
> x86 in this regard is beautiful; it's fully coherent with everything.
> It enforces correctness for almost every situation.  It manages this
> by using a hell of a lot of logic to do interlocking and ensure
> correct ordering.  If you want that from an ARM CPU then you'd probably
> need a comparible amount of logic - and power - to be able to do that.

I'm going to be bluntly honest here, and say that I do not fully
understand all the intrinsic operations that you've explained above.
This may be part of the frustration that you have with me. Not that I'm
trying to piss you off, but the fact that I'm not as well versed of all
the details that goes on inside an ARM processor. Yes, I've been spoiled
with x86, but I'm trying hard to understand the differences with ARM. 

I may be asking stupid questions that are very obvious to you, but to
me, this is a new world. Please have some patience with me.

> 
> > Either way, I said there's probably no guarantee that the 32-bit calls
> > to mcount that gcc has inserted (or the tracepoints) are going to be
> > aligned to 32-bit boundaries.
> 
> Correct; there is no guarantee of that what so ever when building for
> Thumb-2.
> 
> > But I'm wondering if that's still a
> > problem. Let's look at the ways another CPU could get the 32-bit
> > instruction if it is misaligned, and across two different cache lines,
> > or even two different pages:
> > 
> > 
> > 1) the CPU gets the full 32bits as it was on the other CPU, or how it
> > will be.
> > 
> > 2) The CPU gets the first 16bits as it was on the other CPU an the
> > second 16bits with the update.
> > 
> > 3) The CPU gets the first 16bits with the update and the second 16bits
> > as it use to be.
> > 
> > 
> > The first case isn't interesting, so lets jump to the 2 and 3rd cases.
> > 
> > On an update of a 32bit nop to a 16bit breakpoint or branch (jump over
> > second half).
> 
> Err.  Let me remind you what you said in the message which I replied to
> earlier today:
> 
>    We are replacing a 32bit call with a nop. That nop must also         
>                       ^^^^^
>    be 32bits, because we could eventually replace the nop(s) with a 32bit
>       ^^^^^^          
>    call.
> 
> Maybe that's sloppy language, but I tend to read what's written and
> interpret it as written... so to now say about 16-bit breakpoint or
> branch instructions to me sounds like changing the point of discussion.


The grand view is to change a 32bit nop to a 32bit branch and link, and
vice-versa. But because the 32bit operation may cross cache-lines or
pages, there's no safe way to to do that directly (I'm assuming from
everything that I've been told). Thus, the idea is to break the
conversion up into steps where we only change half of the instruction.
Changing the first half to be either a breakpoint or a branch that skips
the second half. Considering that no matter how the processor sees the
result, it wont be an issue. This is where there's a lot of assumptions
that I'm trying to understand, and where you may be frustrated with me.

If we can change the first half of the instruction with a 16bit
operation that skips the second half, then it may be possible to change
the entire 32bit op with another 32bit op in a series of steps, as I
explained several times.

-- Steve


