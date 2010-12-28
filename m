Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab0L1OHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 09:07:09 -0500
Received: from novprvoes0310.provo.novell.com ([137.65.248.74]:60863 "EHLO
	novprvoes0310.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038Ab0L1OHF convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-ghaskins@novell.com:7:1>);
	Tue, 28 Dec 2010 09:07:05 -0500
Message-Id: <4D19A8B20200005A00079658@novprvoes0310.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 28 Dec 2010 07:06:58 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "ThomasGleixner" <tglx@linutronix.de>,
        "Peter Morreale" <PMorreale@novell.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock
 wakeup
References: <20101223224755.078983538@goodmis.org>
 <20101223225116.729981172@goodmis.org>
 <4D13DF250200005A000793E1@novprvoes0310.provo.novell.com>
 <1293166464.22802.415.camel@gandalf.stny.rr.com>
In-Reply-To: <1293166464.22802.415.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12/23/2010 at 11:54 PM, in message
<1293166464.22802.415.camel@gandalf.stny.rr.com>, Steven Rostedt
<rostedt@goodmis.org> wrote: 
> On Thu, 2010-12-23 at 21:45 -0700, Gregory Haskins wrote:
>> Hey Steve,
>> 
>> >>> On 12/23/2010 at 05:47 PM, in message <20101223225116.729981172@goodmis.org>,
>> Steven Rostedt <rostedt@goodmis.org> wrote: 
>> > From: Steven Rostedt <srostedt@redhat.com>
>> > 
>> > The commit: rtmutex: Optimize rt lock wakeup
>> > 
>> > Does not do what it was suppose to do.
>> > This is because the adaptive waiter sets its state to 
> TASK_(UN)INTERRUPTIBLE
>> > before going into the loop. Thus, the test in wakeup_next_waiter()
>> > will always fail on an adaptive waiter, as it only tests to see if
>> > the pending waiter never has its state set ot TASK_RUNNING unless
>> > something else had woke it up.
>> > 
>> > The smp_mb() added to make this test work is just as expensive as
>> > just calling wakeup. And since we we fail to wake up anyway, we are
>> > doing both a smp_mb() and wakeup as well.
>> > 
>> > I tested this with dbench and we run faster without this patch.
>> > I also tried a variant that instead fixed the loop, to change the state
>> > only if the spinner was to go to sleep, and that still did not show
>> > any improvement.
>> 
>> Just a quick note to say I am a bit skeptical of this patch.  I know you are 
> offline next week, so lets plan on hashing it out after the new year before I 
> ack it.
> 
> Sure, but as I said, it is mostly broken anyway. I could even insert
> some tracepoints to show that this is always missed (heck I'll add an
> unlikely and do the branch profiler ;-)

Well, I think that would be a good datapoint and is one of the things I'd like to see.

> 
> The reason is that adaptive spinners spin in some other state than
> TASK_RUNNING, thus it does not help adaptive spinners at all. I first
> tried to fix that, but it made dbench run even slower.

This is why I am skeptical.  You are essentially asserting there are two issues here, IIUC:

1) The intent of avoiding a wakeup is broken and we take the double whammy of a mb()
plus the wakeup() anyway.

2) mb() is apparently slower than wakeup().

I agree (1) is plausible, though I would like to see the traces to confirm.  Its been a long time
since I looked at that code, but I think the original code either ran in RUNNING_MUTEX and was
inadvertently broken in the mean time or the other cpu would have transitioned to RUNNING on
its own when we flipped the owner before the release-side check was performed.  Or perhaps
we just plain screwed this up and it was racy ;)  I'm not sure.  But as Peter (M) stated, it seems
like a shame to walk away from the concept without further investigation.  I think everyone can
agree that at the very least, if it is in fact taking a double whammy we should fix that.

For (2), I am skeptical in two parts ;).  You stated you thought mb() was just as expensive as a
wakeup which seems suspect to me, given a wakeup needs to be a superset of a barrier
II[R|U]C.  Lets call this "2a".  In addition, your results when you removed the logic and went 
straight to a wakeup() and found dbench actually was faster than the "fixed mb()" path would 
imply wakeup() is actually _faster_ than mb().  Lets call this "2b".

For (2a), I would like to see some traces that compare mb() to wakeup() (of a presumably 
already running task that happens in the INTERRUPTIBLE state) to be convinced that wakeup() is 
equal/faster.  I suspect it isn't

For (2b), I would suggest that we don't rely on dbench alone in evaluating the merit of the 
change.  In some ways, its a great test for this type of change since it leans heavily on the coarse 
VFS locks.  However, dbench is also pretty odd and thrives on somewhat chaotic behavior.  For 
instance, it loves the "lateral steal" logic, even though this patch technically breaks fairness.  So
I would therefore propose a suite of benchmarks known for creating as much lock contention as
possible should be run in addition to dbench alone.

Happy new year, all,
-Greg

