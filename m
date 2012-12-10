Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2LJPZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:25:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57777 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab2LJPZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:25:34 -0500
Date: Mon, 10 Dec 2012 15:25:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will.deacon@arm.com>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are
	synchronised across all cpus
Message-ID: <20121210152518.GO14363@n2100.arm.linux.org.uk>
References: <1354898200.17101.50.camel@gandalf.local.home> <20121207164530.GX14363@n2100.arm.linux.org.uk> <1354900436.17101.58.camel@gandalf.local.home> <1354902347.8263.12.camel@linaro1.home> <20121210100433.GB6624@mudshark.cambridge.arm.com> <1355144537.17101.155.camel@gandalf.local.home> <20121210135747.GK14363@n2100.arm.linux.org.uk> <1355148365.17101.168.camel@gandalf.local.home> <20121210140749.GM14363@n2100.arm.linux.org.uk> <1355150801.17101.197.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355150801.17101.197.camel@gandalf.local.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 09:46:41AM -0500, Steven Rostedt wrote:
> Again, you and I are having a disconnect. I'm not a HW expert. I'm
> trying to get a total understanding of what you, Will, Jon and others
> are trying to say.

Well, there's people who think that you're intentionally trying to wind
me up (I'm not alone in this opinion; believe me, I checked with someone
else taking part in this thread and they said as much...)

> > ... which, if it's misaligned to a 32-bit boundary, which can happen with
> > Thumb-2 code, will require the replacement to be done atomically; you will
> > need to use stop_machine() to ensure that other CPUs don't try to execute
> > the instruction mid-way through modification... as I have already
> > explained in my previous mails.
> 
> I'm confused to what is wrong to "misaligned to a 32-bit boundery".
> Isn't it best if it is on a 32-bit boundary? Or do you mean that it's
> misaligned across a 32-bit boundary? I guess I just read it wrong.

What I mean is a store of 32-bit size to an address which is not
numerically an integer multiple of four.

To see why this is a problem, take a moment to think about how you'd
update a misaligned 32-bit value on a 32-bit bus with byte enables.
You need to do it as two transactions.

If your bus is 64-bits wide, then the problem potentially becomes one
where there's an issue if it crosses a 64-bit boundary.  Continue for
larger bus widths...

Now add in the effect of caching with its cache line boundaries, and
what the effects are if a write crosses the cache line boundary (which
means it ends up with two separate validity bits etc.)

Lastly, remember that ARM CPUs have a Harvard cache architecture; that
means that the data paths are entirely separate from the instruction
paths - and in some cases that goes all the way to the memory controller,
but that's not relevant.  The relevant point here is that the point in
the pathways where the instruction and data paths unite can be quite
some distance _outside_ of the CPU.

What this all means is that a misaligned 32-bit store can ultimately
appear as two separate 16-bit stores, which may be interleaved by
other bus activity.  Whether that is visible to other CPUs in a SMP
system as two separate 16-bit stores or not isn't well defined.

x86 in this regard is beautiful; it's fully coherent with everything.
It enforces correctness for almost every situation.  It manages this
by using a hell of a lot of logic to do interlocking and ensure
correct ordering.  If you want that from an ARM CPU then you'd probably
need a comparible amount of logic - and power - to be able to do that.

> Either way, I said there's probably no guarantee that the 32-bit calls
> to mcount that gcc has inserted (or the tracepoints) are going to be
> aligned to 32-bit boundaries.

Correct; there is no guarantee of that what so ever when building for
Thumb-2.

> But I'm wondering if that's still a
> problem. Let's look at the ways another CPU could get the 32-bit
> instruction if it is misaligned, and across two different cache lines,
> or even two different pages:
> 
> 
> 1) the CPU gets the full 32bits as it was on the other CPU, or how it
> will be.
> 
> 2) The CPU gets the first 16bits as it was on the other CPU an the
> second 16bits with the update.
> 
> 3) The CPU gets the first 16bits with the update and the second 16bits
> as it use to be.
> 
> 
> The first case isn't interesting, so lets jump to the 2 and 3rd cases.
> 
> On an update of a 32bit nop to a 16bit breakpoint or branch (jump over
> second half).

Err.  Let me remind you what you said in the message which I replied to
earlier today:

   We are replacing a 32bit call with a nop. That nop must also         
                      ^^^^^
   be 32bits, because we could eventually replace the nop(s) with a 32bit
      ^^^^^^          
   call.

Maybe that's sloppy language, but I tend to read what's written and
interpret it as written... so to now say about 16-bit breakpoint or
branch instructions to me sounds like changing the point of discussion.
