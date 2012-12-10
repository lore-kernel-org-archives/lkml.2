Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab2LJOqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:46:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8298 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab2LJOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:46:43 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0q0mCv_Vr9gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrIq2vSOvhQA:10 a=RQXyStUKyRP6mIY5jHEA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355150801.17101.197.camel@gandalf.local.home>
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
Date: Mon, 10 Dec 2012 09:46:41 -0500
In-Reply-To: <20121210140749.GM14363@n2100.arm.linux.org.uk>
References: <1354894134.17101.44.camel@gandalf.local.home>
	 <20121207162346.GW14363@n2100.arm.linux.org.uk>
	 <1354898200.17101.50.camel@gandalf.local.home>
	 <20121207164530.GX14363@n2100.arm.linux.org.uk>
	 <1354900436.17101.58.camel@gandalf.local.home>
	 <1354902347.8263.12.camel@linaro1.home>
	 <20121210100433.GB6624@mudshark.cambridge.arm.com>
	 <1355144537.17101.155.camel@gandalf.local.home>
	 <20121210135747.GK14363@n2100.arm.linux.org.uk>
	 <1355148365.17101.168.camel@gandalf.local.home>
	 <20121210140749.GM14363@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 14:07 +0000, Russell King - ARM Linux wrote:
>  
> > If there's no way to modify a 32bit operation without stop_machine(),
> > ever with a breakpoint, than we can stop the discussion here. ARM will
> > forever require stop_machine() for use with tracepoints and ftrace. Too
> > bad, as ARM was the x86 competitor. Here's something that x86 has a one
> > up on ARM.
> 
> You think that kind of blackmail makes a difference?

I'm not trying to blackmail. How does one blackmail to change facts? I
was just showing my disappointment, as I'm starting to grow fond of ARM.
Although I wouldn't mind sending out some blackmail to the ARM HW
vendors (got any pictures of them cheating on their spouses?) to make
them come up with a standardize way to make all this easy :-)


>   Look closely at what
> I've written - I didn't say that there's no way to modify any 32-bit
> operation without stop_machine().

Again, you and I are having a disconnect. I'm not a HW expert. I'm
trying to get a total understanding of what you, Will, Jon and others
are trying to say.

Lets look at what you last said:


> ... which, if it's misaligned to a 32-bit boundary, which can happen with
> Thumb-2 code, will require the replacement to be done atomically; you will
> need to use stop_machine() to ensure that other CPUs don't try to execute
> the instruction mid-way through modification... as I have already
> explained in my previous mails.

I'm confused to what is wrong to "misaligned to a 32-bit boundery".
Isn't it best if it is on a 32-bit boundary? Or do you mean that it's
misaligned across a 32-bit boundary? I guess I just read it wrong.

Either way, I said there's probably no guarantee that the 32-bit calls
to mcount that gcc has inserted (or the tracepoints) are going to be
aligned to 32-bit boundaries. But I'm wondering if that's still a
problem. Let's look at the ways another CPU could get the 32-bit
instruction if it is misaligned, and across two different cache lines,
or even two different pages:


1) the CPU gets the full 32bits as it was on the other CPU, or how it
will be.

2) The CPU gets the first 16bits as it was on the other CPU an the
second 16bits with the update.

3) The CPU gets the first 16bits with the update and the second 16bits
as it use to be.


The first case isn't interesting, so lets jump to the 2 and 3rd cases.

On an update of a 32bit nop to a 16bit breakpoint or branch (jump over
second half).


As we only modify the first half of the 32bit operation, and the second
half still contains the second half of the 32bit nop, the other CPU will
see:

<first 16bits of 32bit nop><second 16bits of 32bit nop>

That doesn't look so bad. Or:

<breakpoint/branch><second 16bits of 32bit nop>

If it sees the breakpoint or branch, then it should just jump over the
second part of the nop, and not execute it. If this is an issue, then we
need stop_machine() otherwise, I'll continue.

Now before changing the second half of the 32bits, we send a sync (IPI
maybe) to all other CPUs, so that we now guarantee that all CPUs sees
the added breakpoint/branch.

As the breakpoint and branch will return pass the second half of the
nop, modifying it shouldn't bother the other CPUs. If it does, then we
have to stay with stop_machine(). If not, let me continue.

We need to send another sync to guarantee that all the other CPUs see
the second half of the jump to ftrace code.

Now the second half matches the second half of the jump to the ftrace
code, and the first half is still the breakpoint/branch. So lets change
that to the first half of the jump to the ftrace code. Now the other
CPUs will see:

<breakpoint/branch><second 16bits of jump to ftrace>

The above should still skip the second half. Or:

<first 16bits of jump to ftrace><second 16bits of jump to ftrace>

The above is what we want CPUs to see.

If my assumptions about the changes above can't be done, then yes we are
stuck with stop_machine(). If they can be done, then we have hope to
remove it.

-- Steve


