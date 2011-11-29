Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab1K2Ufa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:35:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53737 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab1K2Uf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:35:27 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=x9VNfy9Nl58A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=Z4Rwk6OoAAAA:8 a=L87aYj3AxOr8ET8XuNQA:9 a=KivBQKu9AgHkgx4Z6A8A:7 a=QEXdDO2ut3YA:10 a=jbrJJM5MRmoA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Perhaps a side effect regarding NMI returns
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
In-Reply-To: <m2r50qlmgk.fsf@firstfloor.org>
References: <1322539673.17003.45.camel@frodo>
	 <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
	 <m2r50qlmgk.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 15:35:20 -0500
Message-ID: <1322598920.17003.71.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 12:09 -0800, Andi Kleen wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> Not sure what problem Steven thinks is there. Once you 
> switched the stack any nesting is fine.

Problem? I never said there was a problem. I just said there was a
subtle side effect, that may or may not be a problem. But I never said
there was an actually problem.

There may be a problem where you are profiling at a high frequency, and
then hit this and suddenly, your high frequency NMIs are stopped till
the next interrupt. If you are running at 100HZ, the next interrupt may
not happen for 10ms, where we don't have an NMI triggered until then.

Perhaps for some reason NEED_RESCHED is set, but the task is no longer
going to run. Not sure if that could even happen, but for kicks, lets
assume it can.  Then we schedule into the idle task that goes to sleep.
With NO_HZ, we may not even get another interrupt for a very long time.
But we keep NMIs disabled.

The difference here is that we call schedule without ever enabling NMIs.
Now is that a problem? It may be.


> 
> > I would suggest that the actual NMI handler itself should probably
> > never use that paranoid exit at all, and just always use a regular
> > iret. Screw scheduling and TIF checks.
> 
> The reason I added them originally is to prevent the race of remote
> kernel events being delayed for a long time. With Frederic's nohz work
> this will be more important in the future. Today it would be eventually
> picked up by the regular timer interrupts.

I'm curious to what remote events can be set by an NMI that wont take
affect in what the NMI interrupted. I would think that NMIs should be
treated as if they didn't exist, because they should not be calling
anything that sets NEED_RESCHED or grabbing locks and such.

If a process on another CPU sets NEED_RESCHED on the task for this CPU,
it doesn't matter if it is in an NMI or not. The other process still
needs to send an IPI or something (that will be blocked until the NMI
finishes) in which case, the return from the NMI will trigger the
scheduling.

I don't see the problem where we can't just ignore the flags for NMIs.
What exactly is the race that causes issues when NMIs are not checking
for scheduling and such?

-- Steve


