Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0ESSoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:44:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48923 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab0ESSoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:44:23 -0400
X-Authority-Analysis: v=1.1 cv=ThiPuEJrAfM5PTlEgIT3cJp8+3pkHBIG3CaogqDGxqo= c=1 sm=0 a=PMJxTGDUVXsA:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=uWVYX686caYegmDCBWkA:9 a=GmTNuyjtuxOmBWii84gA:7 a=0zsiyVWOGMSPrOxtkRQG3XntCfYA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC] Unified Ring Buffer (Next Generation)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20100519181001.GC18073@basil.fritz.box>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com>
	 <20100519181001.GC18073@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 19 May 2010 14:44:18 -0400
Message-ID: <1274294658.26328.997.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 20:10 +0200, Andi Kleen wrote:
> On Wed, May 19, 2010 at 01:51:54PM -0400, Steven Rostedt wrote:
> 
> Hi Steven,
> 
> > More than a year and a half ago (September 2008), at Linux Plumbers, we
> > had a meeting with several kernel developers to come up with a unified
> > ring buffer. A generic ring buffer in the kernel that any subsystem
> > could use. After coming up with a set of requirements, I worked on
> 
> If we take a step back.
> 
> Why do you want a single ring buffer for everyone?

Actually, I would like to have one ring buffer interface, not one ring
buffer per say.

> 
> A lot more low profile subsystems subsystems simply use kfifo
> (which is also actively developed by Stefanie). In fact there
> are far more users of it than of your ring buffer. And it's 
> really quite simple and easy to use. And it works fine for them.
> 
> I don't think it's that great a goal to have a single ring buffer
> for all possible ring buffer needs. After all the requirements
> are quite different.
> 
> Some want a simple ring buffer with minimal overhead
> and simple interface, others need a mmaped one or have other special 
> requirements. One size doesn't fit all. 

Exactly! One size does not fit all. I've discussed this off list with
Maitheu, and we agree that different requirements call for different
types of ring buffers. Depending on mmapping, splice, single writer (no
need for per CPU buffers if there's only ever one writer), multiple
writers, etc.

What would be nice to have is a single interface where the same event
can be recorded using the same interface.

> 
> It's also not that we're talking about gigantic amounts of code
> in all cases where there is a pressing need to unify.
> 
> If perf's current ring buffer works for it why not keep using it? 

Because it does not work for the functionality of ftrace. And there's a
driving need to try to unify the two.

> 
> One problem I always had with your version was that it's quite 
> bloated frankly, especially in terms of code size, but 
> also in its data structures and in the interface complexity.

These are valid concerns, and even Mathieu has mentioned this. One way
is to develop a layered approach. Where the lowest layer is very simple
and small, but without much features. The higher layers have more
features but are built on top of the lower ones.

> 
> For debugging kernels etc. with tracing that's not that big an issue, but
> I think it's a problem for "non debugging" use. After all Linux
> still has the goal to be at least configurable as a low footprint operating
> system.

Agreed.

> 
> Part of the reason for its big code size seems to be that 
> it tries to support everyone's requirements, which unsurprisingly
> leads to some bloat both in implementation and interface.

OK, as I mentioned, what about a layered approach? Where one level
builds off of another? This may actually solve some of the bloat. That
is, try to keep the more complex users using the same code, but have
that on top of code that is simple for the users that have a restrictive
environment.

> 
> Also to be honest it's so clever now that at least I have
> a hard time understanding it, and I personally prefer code
> that I can understand over too clever code. After all if there
> is a bug in there and you need to be more clever than the programmer
> to debug it, how would that be done? 

Thanks for the complement ;-)

Yes, I've heard this complaint, and it is also why I'm asking Mathieu to
do the work and I'm staying away (except for helping with review and
requirements). I like the "clever" solutions.

> 
> Perhaps a better goal would be to have a smaller simpler more
> maintainable buffer for ftrace and let the other users their own?

Perhaps, but the goal is actually to handle all the features of perf and
ftrace in a generic fashion.

You also bring up a point that I try very hard to get across. When
people think of a ring buffer, they think of the ones that they created
in CS101, not realizing that when you are dealing with production
systems, handling the requirements makes the buffering much more
complex.

Perhaps the answer is we are fine with more than one ring buffer. I'm OK
with that too. But Linus did push this agenda back in the 2008 Kernel
Summit. I'm just continuing it.

> 
> Just my 0.05 cent.

Thanks,

-- Steve


