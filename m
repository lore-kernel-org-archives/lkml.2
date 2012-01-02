Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab2ABTd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 14:33:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2ABTdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 14:33:24 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QcgJSxWpgi8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=AbRfIacH8YZp8xWtdOsA:9 a=N3TRipXHKumL_IhPjRsA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325532801.6233.19.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 02 Jan 2012 14:33:21 -0500
In-Reply-To: <20120101180949.GA25066@elte.hu>
References: <20111221123624.193898256@goodmis.org>
	 <20120101180949.GA25066@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Thanks for looking into this.

On Sun, 2012-01-01 at 19:09 +0100, Ingo Molnar wrote:

> Hm, i'm seeing spontaneous reboot crashes with these commits 
> applied. The reboots just happen out of the blue during an 
> allyesconfig bootup (config attached), and they happen at
> random places.

Interesting. This patch set only deals with function tracing (and stack
tracer which is on top of the function tracer). It shouldn't affect
anything if function tracing is never set. With a few exceptions...


> 
> In about 50% of the cases the kernel boots up fine - so 
> bisection is very difficult - i have to repeat the bootup 10 
> times to have a reasonable confidence during a 5-step bisection 
> process.
> 
> I've narrowed it down the commits in the above tree:
> 
> 38b78eb85540: tracing: Factorize filter creation

This one just touches the filter code. Unless you are doing filtering,
this code should never be executed. Are you running perf, as I believe
perf can trigger it too.


> 762e1207889b: tracing: Have stack tracing set filtered functions at boot

This one just adds a kernel command line that allows stack trace
filtering to be done at boot up. Do you have any function tracing things
enabled in your kernel command line?

> 2a85a37f168d: ftrace: Allow access to the boot time function enabling

This one just changes a name of a function and makes it global.

> d2d45c7a03a2: tracing: Have stack_tracer use a separate list of functions

This one touches the way stack tracer sets up what functions to trace,
and should not be touched if stack tracer is never updated.

> 69a3083c4a7d: ftrace: Decouple hash items from showing filtered functions

This is a simple change that adds another enum to the way records are
stored in the function filters. Again, should never be touched unless
you are filtering functions in the function tracer.


> fc13cb0ce452: ftrace: Allow other users of function tracing to use the output listing

This one just moves some code around to replace the global function
filter with a descriptor that other users (like perf and stack tracer)
can filter what functions to trace. Again, this is only used by function
filtering. The dynamic ftrace start up test does test this, maybe the
error was there?

> 06a51d930738: ftrace: Create ftrace_hash_empty() helper routine

This is a simple clean up that also fixes a bug in the way function
filtering works. Again, this should only be touched by function filters.

> c842e975520f: ftrace: Fix ftrace hash record update with notrace

This fixes a bug in the function filter logic. Again, this is caused by
different tracers filtering functions for the function tracer.


> 5855fead9cc3: ftrace: Use bsearch to find record ip

This code isn't even used in x86 (not yet). But it is needed for powerpc
(coming soon).

> 68950619f8c8: ftrace: Sort the mcount records on each page

This sorts the mcount tables used by function tracer.

> 85ae32ae019b: ftrace: Replace record newlist with record page list
> a79008755497: ftrace: Allocate the mcount record pages as groups

These two are clean up code that does affect all kernels when the
function tracer is updated.


> 3208230983a0: ftrace: Remove usage of "freed" records

The "freed" records are affected when modules are unloaded. But an
allyesconfig shouldn't be unloading modules.

> c88fd8634ea6: ftrace: Allow archs to modify code without stop machine

This is a little restructuring of the updates of ftrace calls (nops), so
it is affecting boot up.

> 45959ee7aa64: ftrace: Do not function trace inlined functions

This patch changes the way inlined functions are when
CONFIG_OPTIMIZE_INLINING is set. I wonder if this is the problem patch.
It forces all functions marked as "inline" to be notraced as well. But
perhaps this is affecting the way gcc does stuff. We have had issues
when gcc decides not to inline something.

> 30fb6aa74011: ftrace: Fix unregister ftrace_ops accounting

This may affect the kernel when function tracing is stopped. The
selftests should trigger this.

> 
> -tip commit 1bc2a3035df2 appears to be fine, it survived 10 
> consecutive reboots.
> 
> So i'm a bit stuck - i wanted to pull this and the NMI bits. 
> I'll test the NMI bits independently as well, excluding the 
> above commits, so that we can at least move forward on that 
> topic.

The NMI bits should be on a separate branch. That is, if they are OK,
they should not affect this code. And this code does not require the NMI
code. I left the one patch that converts x86 to non-stop-machine out of
this patch set so that the infrastructure can get in first.

Interesting that these patches cause an issue. Besides the inline one
that I mentioned, the rest should not cause races. They are all set up
and take down of the ftrace function filtering. If there was a bug, it
should crash reliably.

Maybe there's an off-by-one in the sorting. I'll take a look. If there
is, it may corrupt some other data. This is the first time I used the
in-kernel sort and bsearch algorithms. But again, I've been running this
code on my boxes without issues.

I'll add your config and boot my box with it and see how it goes. Note,
I wont be doing much more today, as I'm still on PTO.

Thanks!

-- Steve


