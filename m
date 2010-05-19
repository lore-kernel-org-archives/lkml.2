Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0ESTZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:25:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58873 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0ESTZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:25:45 -0400
Date: Wed, 19 May 2010 21:25:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [RFC] Unified Ring Buffer (Next Generation)
Message-ID: <20100519192542.GD18073@basil.fritz.box>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com> <20100519181001.GC18073@basil.fritz.box> <1274294658.26328.997.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274294658.26328.997.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 02:44:18PM -0400, Steven Rostedt wrote:
> > > More than a year and a half ago (September 2008), at Linux Plumbers, we
> > > had a meeting with several kernel developers to come up with a unified
> > > ring buffer. A generic ring buffer in the kernel that any subsystem
> > > could use. After coming up with a set of requirements, I worked on
> > 
> > If we take a step back.
> > 
> > Why do you want a single ring buffer for everyone?
> 
> Actually, I would like to have one ring buffer interface, not one ring
> buffer per say.

Why does every user in the kernel need the same interface? 

A user with simple requirements would prefer a simple and fast interface,
an user with complex requirement a complex requirements a complex one.
But they're not the same.

Or do you just want the same interface between ftrace and perf?

> What would be nice to have is a single interface where the same event
> can be recorded using the same interface.

I'm not fully sure what advantage that would have. Would you like
to exchange different ring buffers for existing users frequently?

> OK, as I mentioned, what about a layered approach? Where one level
> builds off of another? This may actually solve some of the bloat. That
> is, try to keep the more complex users using the same code, but have
> that on top of code that is simple for the users that have a restrictive
> environment.

Some of the complexity is in the underlying implementation isn't it?
e.g. single continuous buffer versus multiple ones. 

That cannot really be addressed by layers, unless you go to 
virtual call tables (which would seem a bad idea to me for such a hot
path) 

> > 
> > Perhaps a better goal would be to have a smaller simpler more
> > maintainable buffer for ftrace and let the other users their own?
> 
> Perhaps, but the goal is actually to handle all the features of perf and
> ftrace in a generic fashion.

Ok so your goal is to only cover perf and ftrace and let all 
the other users be alone? 

> 
> You also bring up a point that I try very hard to get across. When
> people think of a ring buffer, they think of the ones that they created
> in CS101, not realizing that when you are dealing with production
> systems, handling the requirements makes the buffering much more
> complex.

For most users the simple ones are totally adequate though.

> Perhaps the answer is we are fine with more than one ring buffer. I'm OK

That's what we already have in fact: kfifo, ftrace, perf, a couple
of private ones all over.

I think a couple of private ones could be converted to kfifo
(I did some of that for my own code) 

But I don't really see how you can marry the simple kfifo world
to the highend bells'n'whistles ftrace world. And even in the highend
world there might be space for multiple specialized ones.

On the other hand if the highend world had less overhead
then at least some of the "higher end" kfifo users could start 
considering to use it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
