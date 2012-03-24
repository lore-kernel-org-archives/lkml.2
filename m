Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2CXHhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:37:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33885 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2CXHhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:37:35 -0400
Date: Sat, 24 Mar 2012 08:37:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, mce: Add persistent MCE event
Message-ID: <20120324073731.GD20145@gmail.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
 <1332340496-21658-3-git-send-email-bp@amd64.org>
 <20120323123156.GF13920@gmail.com>
 <20120323133044.GA8115@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120323133044.GA8115@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Fri, Mar 23, 2012 at 01:31:56PM +0100, Ingo Molnar wrote:
> > Have you considered making the addition of persistent events
> > straightforward and robust, in terms of adding a TRACE_EVENT() variant
> > for them? It could replace the above code.
> 
> Err,
> 
> are you thinking of something in TRACE_EVENT() that sets
> perf_event_attr.persistent to 1?

I was mainly thinking of reducing this:

 arch/x86/kernel/cpu/mcheck/mce.c |   53 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

to almost nothing. There doesn't seem to be much MCE specific in 
that code, right?

> Btw, the more important question is are we going to need 
> persistent events that much so that a generic approach is 
> warranted? I guess maybe the black box events recording deal 
> would be another user..

So, here's the big picture as I see it:

I think tracing could use persistent events: mark all the events 
we want to trace as persistent from bootup, and recover the 
bootup trace after the system has been booted up.

But other, runtime models of tracing could use it as well: 
basically the main difference that ftrace has to perf based 
tracing today is a system-wide persistent buffer with no 
particular owning process. (The rest is mostly UI and analysis 
features and scope of tracing differences, and of course a lot 
more love and detail went into ftrace so far.)

So MCE will in the end be just a minor user of such a facility - 
I think you should aim for enabling *any* set of events to have 
persistent recording properties, and add the APIs to recover 
that information sanely. It should also be possible for them to 
record into a shared mmap page in essence - instead of having 
per event persistent buffers.

That way testing would be a lot easier as well: you could enable 
persistent tracing via something like:

    perf trace on -e <events>

and turn it off via:

    perf trace off

and just recover the recorded events via something like:

    perf trace

... or so. That you can then also enable this during bootup for 
MCE events is just a very nice side effect of a much more 
generally useful feature.

Would you be interested in creating a clean incarnation of this 
without making peterz sad? The 'perf trace' perf subcommand is 
still unused and up for grabs for sufficiently good patches, 
coincidentally ;-)

Thanks,

	Ingo
