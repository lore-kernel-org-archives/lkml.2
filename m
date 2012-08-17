Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787Ab2HQHi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:38:26 -0400
Received: from mail.x86-64.org ([217.9.48.20]:55201 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964805Ab2HQHiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:38:24 -0400
Date: Fri, 17 Aug 2012 09:38:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
Message-ID: <20120817073815.GA21017@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
 <20120816141253.0142ddd0@lwn.net>
 <20120816205539.GA16308@aftab.osrc.amd.com>
 <1345151613.3708.4.camel@gandalf.local.home>
 <20120816214103.GE16308@aftab.osrc.amd.com>
 <1345154418.3708.13.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345154418.3708.13.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 06:00:18PM -0400, Steven Rostedt wrote:
> Do these need to be mmapped, or are they copied into another location
> (disk or network)? I had code to allow the ftrace ring buffers to be
> mmapped, but stopped that work a while ago.

Well, my angle here is that since those are persistent, i.e. always-on
events, they should be as low overhead as possible. So mmaping the
buffer is probably that since it doesn't involve any data shuffling to
and fro...

> > > I'm currently working on having perf read ftrace data, so in the near
> > > future, I plan on having some RFC patches to have perf reading from
> > > this buffer anyway.
> > 
> > Are you saying the ftrace buffer would be mmappable too now?
> 
> No, the ftrace buffer was optimized for the splice command.

Ah, the splice thing moving data between two fds.

> I would have perf do what trace-cmd does. That is, write directly into
> a file as it reads it, without ever needing the info to come into
> userspace.

Is that a real file?

Because what I was doing in the RAS daemon is mmap the buffer, read out
the logged events in userspace and work on them.

Having them go to a file which I need to open in userspace adds one more
step and I don't know how that would pan out in a critical situation of
you getting a machine check where every insn counts. And besides, in a
MCE situation you cannot be sure that the events would actually go to
file... So my current impression is that reading them direct from memory
is the fastest we can do. But this is only me and I have been wrong in
the past. Lotsa times :).

> I wasn't planning on replacing perf buffers, I was just planning on
> giving perf a tracing boost.

Cool.

> Another alternative, which would be a bit slower, would be to copy the
> pages, either into userspace (as a read) or into a location to mmap the
> buffers.

Yeah, copying is not a good idea, IMHO, due to the said above.

> I could also continue the work on allowing ftrace buffers to be
> mmapped. But if the best thing to do is just use the perf buffers,
> then we could just stick with that.

The easiest for now, I'd say, since it is already there.

> > Btw, I wanted to hear your opinion on patch 1/4 since it touches
> > ftrace/trace_events code. Can you please look at it and tell me if its
> > ok?
> > 
> I'll take a look.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
