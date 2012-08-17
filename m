Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2HQPUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:20:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32924 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab2HQPUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:20:32 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=07ZCQtT27sEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZRzJ3tYFNvQA:10 a=meVymXHHAAAA:8 a=8FsYDA-1NFyRM1qZKacA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345216829.3708.33.camel@gandalf.local.home>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 17 Aug 2012 11:20:29 -0400
In-Reply-To: <20120817073815.GA21017@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
	 <20120816141253.0142ddd0@lwn.net>
	 <20120816205539.GA16308@aftab.osrc.amd.com>
	 <1345151613.3708.4.camel@gandalf.local.home>
	 <20120816214103.GE16308@aftab.osrc.amd.com>
	 <1345154418.3708.13.camel@gandalf.local.home>
	 <20120817073815.GA21017@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 09:38 +0200, Borislav Petkov wrote:
> On Thu, Aug 16, 2012 at 06:00:18PM -0400, Steven Rostedt wrote:
> > Do these need to be mmapped, or are they copied into another location
> > (disk or network)? I had code to allow the ftrace ring buffers to be
> > mmapped, but stopped that work a while ago.
> 
> Well, my angle here is that since those are persistent, i.e. always-on
> events, they should be as low overhead as possible. So mmaping the
> buffer is probably that since it doesn't involve any data shuffling to
> and fro...

Understood.

> 
> > > > I'm currently working on having perf read ftrace data, so in the near
> > > > future, I plan on having some RFC patches to have perf reading from
> > > > this buffer anyway.
> > > 
> > > Are you saying the ftrace buffer would be mmappable too now?
> > 
> > No, the ftrace buffer was optimized for the splice command.
> 
> Ah, the splice thing moving data between two fds.

Yep.

> 
> > I would have perf do what trace-cmd does. That is, write directly into
> > a file as it reads it, without ever needing the info to come into
> > userspace.
> 
> Is that a real file?

It's anything that needs a file descriptor. But yeah.

> 
> Because what I was doing in the RAS daemon is mmap the buffer, read out
> the logged events in userspace and work on them.

OK, so you're not storing the data, your just using it to manipulate it.

If it wasn't for sparc, we could have done this with the ftrace buffers,
but sparc has some crazy requirement that physical pages can only be
mapped at certain locations, and you can't just take a bunch of random
pages and map them at the same location.

> 
> Having them go to a file which I need to open in userspace adds one more
> step and I don't know how that would pan out in a critical situation of
> you getting a machine check where every insn counts. And besides, in a
> MCE situation you cannot be sure that the events would actually go to
> file... So my current impression is that reading them direct from memory
> is the fastest we can do. But this is only me and I have been wrong in
> the past. Lotsa times :).
> 
> > I wasn't planning on replacing perf buffers, I was just planning on
> > giving perf a tracing boost.
> 
> Cool.
> 
> > Another alternative, which would be a bit slower, would be to copy the
> > pages, either into userspace (as a read) or into a location to mmap the
> > buffers.
> 
> Yeah, copying is not a good idea, IMHO, due to the said above.

I agree.

> 
> > I could also continue the work on allowing ftrace buffers to be
> > mmapped. But if the best thing to do is just use the perf buffers,
> > then we could just stick with that.
> 
> The easiest for now, I'd say, since it is already there.

Yeah, I agree with this too. As the perf buffer is better for
manipulating of data and not storing it.


-- Steve


