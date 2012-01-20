Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab2ATSBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 13:01:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab2ATSBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 13:01:14 -0500
Date: Fri, 20 Jan 2012 13:01:00 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120120180059.GB2323@redhat.com>
References: <20120113182015.GA3902@redhat.com>
 <20120115182441.GA24694@redhat.com>
 <20120116074540.GE15641@elte.hu>
 <1326717070.7642.144.camel@gandalf.stny.rr.com>
 <20120116125329.GB31667@elte.hu>
 <1326729123.7642.146.camel@gandalf.stny.rr.com>
 <20120117100222.GH10397@elte.hu>
 <1326801811.7642.188.camel@gandalf.stny.rr.com>
 <20120117124023.GA13969@elte.hu>
 <1326811069.17534.46.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326811069.17534.46.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 09:37:49AM -0500, Steven Rostedt wrote:
> On Tue, 2012-01-17 at 13:40 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Any tool that requests the signal trace event, and copies the 
> > full (and now larger) record it got in the ring-buffer, without 
> > expanding the target record's size accordingly will *BREAK*. 
> 
> I'm curious to where it gets the size?
> 
> This is not like the kernel writing to a pointer in userspace memory,
> where it can indeed break code by writing too much. This is the
> userspace program writing from a shared memory location.
> 
> 
> > 
> > I do not claim that tools will break in practice - i'm raising 
> > the *possibility* out of caution and i'm frustrated that you 
> > *STILL* don't understand how ABIs are maintained in Linux. 
> 
> You are defending code that would do:
> 
> 	size = read_size(ring_buffer_event);
> 	memcpy(data, buffer, size);
> 
> over code that would most likely do:
> 
> 	memcpy(data, buffer, sizeof(*data));
> 
> ???
> 
> According to this logic, we should never increase the size
> of /proc/stat, because someone might do:
> 
> 	i = 0;
> 	fd = open("/proc/stat", O_RDONLY);
> 	do {
> 		r = read(fd, buff+i, BUFSIZ);
> 		i += r;
> 	} while (r > 0);
> 
> 
> 
> > 
> > You arguing about defined semantics is *MEANINGLESS*. What 
> > matters is what the apps do in practice.
> 
> Exactly, to depend on the ring buffer size to do all copies to fixed
> size data structures seems to be backwards to what would be done in
> practice.
> 
> 
> >  If the apps we know 
> > about do it robustly and adapt (or don't care) about the 
> > expansion, and if no-one reports a regression in tools we don't 
> > know about, then it's probably fine.
> 
> It's not about robustness, it's about the easy way to copy.
> 
> 	memcpy(data, buffer, sizeof(*data));
> 
> wont break.
> 
> 
> > But your argument that expansion is somehow part of the ABI is 
> > patently false and misses the point. Seeing your arguments make 
> > me *very* nervous about applying any ABI affecting patch from 
> > you.
> 
> Well you already think I'm stupid, I wont change the ABI anymore.
> Obviously I know nothing, because I created a flexible interface that's
> not used by anything except perf and trace-cmd, but because there's no
> library, we are stuck with fixed tracepoints, which will come to haunt
> us in the not so distant future.
> 
> This will bloat the kernel. Tracepoints are not free. They bloat the
> kernel's text section. Every tracepoint still adds a bit of code in the
> "unlikely" part inlined where they are called. So they do have an affect
> on icache, as well as the code to process the tracepoint (around 5k per
> tracepoint).
> 

Right, with the jump label optimization, the 'unlikely' branch is
usually moved to the end of the function, with only a single no-op in
the hot-path. However, with gcc enhancement the unlikely label could
be labeled something like 'cold', and moved either further out-of-line.
Its a potential improvement for jump labels, that I need to look into.

Thanks,

-Jason

