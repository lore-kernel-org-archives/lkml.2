Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2FOLyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:54:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25753 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2FOLyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:54:22 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=G0s97Kyuy1EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=mz5n7y54v8WvLf5km8YA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339761261.13377.353.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Fix the outmost stupidity of tracing_off()
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Fri, 15 Jun 2012 07:54:21 -0400
In-Reply-To: <1339733919.13377.328.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.02.1206142345100.3086@ionos>
	 <1339714725.13377.252.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1206150106511.3086@ionos>
	 <1339717703.13377.285.camel@gandalf.stny.rr.com>
	 <1339733919.13377.328.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 00:18 -0400, Steven Rostedt wrote:
> For testing something like this, I would have
> added tracing_off() in the code, and I do reset --hard to remove my
> testing code. If I made the fix and forgot to --amend it, the fix was
> lost.

I'm almost positive this is what happened.

tracing_off() is similar to trace_printk(), it's something that is
usually added during development and not something that is normally
executed in production. With an unmodified kernel, to test it, you need
to start tracing and trigger a crash and have ftrace_dump_on_opps set,
and have something to read it so that you know the tracing stopped. Not
very reliable, and not something to put into generic testing.

I forgot that the function tracer 'traceoff' trigger uses it, otherwise
I would have added that new test a while ago.

For my testing, I put in tracing_off() at various places in the kernel,
and made sure that it worked. I did see that it was broken before and
fixed it. But for some reason, maybe I was distracted by other work, I
never did the git commit --amend (similar to forgetting to do a quilt
refresh). All my tests worked, and I reverted the test code I added with
either a 'git reset --hard', or a 'git diff | patch -p1 -R', both of
which would have removed my fix.

I usually scan the 'git diff' before doing the revert, but as this
change was a one liner, it could easily have been missed.

The code I've been working on for the last few months was debugging the
breakpoint code, which, when it failed, triple faulted the box. Tracing
was never an option. Which means that I would not have played with
tracing_off() then. And the older code that I've been working with
(3.2-rt), did not have this bug.

Again, I know you are one of the biggest users of ftrace, and I'm very
sorry (and ashamed) that his bug got in and caused you a days worth of
frustration.

-- Steve


